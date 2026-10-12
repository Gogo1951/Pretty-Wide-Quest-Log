local _, ns = ...
local L = ns.L

-- How both quest logs draw a quest: its title in the list, its text's styling, objective lines and quest ID.

--------------------------------------------------------------------------------
-- Quest Text
--------------------------------------------------------------------------------

--[[
	Letters after the level in the quest list, by quest tag (Enum.QuestTag): D dungeon, R raid, P PvP,
	G group. Elite quests without one of those get E
]]
local QUEST_TAG_SUFFIX = {
	[81] = L["QUEST_SUFFIX_DUNGEON"], -- Dungeon
	[85] = L["QUEST_SUFFIX_DUNGEON"], -- Heroic
	[62] = L["QUEST_SUFFIX_RAID"], -- Raid
	[88] = L["QUEST_SUFFIX_RAID"], -- Raid (10)
	[89] = L["QUEST_SUFFIX_RAID"], -- Raid (25)
	[41] = L["QUEST_SUFFIX_PVP"], -- PvP
	[1] = L["QUEST_SUFFIX_GROUP"], -- Group
}
local ELITE_SUFFIX = L["QUEST_SUFFIX_ELITE"]

function ns.QuestSuffix(tagID, isElite)
	return (tagID and QUEST_TAG_SUFFIX[tagID]) or (isElite and ELITE_SUFFIX) or ""
end

-- "[13]", or "[13D]" for a dungeon quest, and so on
function ns.LevelTag(level, suffix)
	return format("[%d%s]", level or 0, suffix or "")
end

-- "[13] Quest Name", or "[13D] Quest Name" for a dungeon quest, and so on
function ns.LevelTitle(level, title, suffix)
	return ns.LevelTag(level, suffix) .. " " .. (title or "")
end

-- A quest's line in the quest list: tagged as above while showQuestLevels is on, else the title alone
function ns.QuestListTitle(level, title, suffix)
	if ns.db.profile.showQuestLevels then
		return ns.LevelTitle(level, title, suffix)
	end
	return title or ""
end

local function QuestIDText(questID)
	return format(L["QUEST_ID"], questID)
end

--[[
	Shows a quest ID in a FontString, in the same font and colour as source (the description) but
	smaller. One that links to Wowhead starts with a chain link, in the same colour
]]
function ns.StyleQuestID(text, questID, source)
	local file, size, flags = source:GetFont()
	if file and size then
		text:SetFont(file, size - ns.LAYOUT.QUEST_ID_FONT_SHRINK, flags)
	end
	local r, g, b = source:GetTextColor()
	text:SetTextColor(r, g, b)
	local label = QuestIDText(questID)
	if text.linksToWowhead then
		label =
			format("|T%s:0:0:0:0:32:32:0:32:0:32:%d:%d:%d|t %s", ns.WOWHEAD_LINK_ICON, r * 255, g * 255, b * 255, label)
	end
	text:SetText(label)
end

--[[
	Objective lines in the quest details: a green check for a finished objective (or
	a blank the same size, so the names line up), the objective's name, and its count ("8 / 8")
	right-aligned in a column of its own, two spaces in from the right edge of the text column
]]
local CHECK = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t"
local NO_CHECK = "|TInterface\\Common\\spacer:0|t"
ns.CHECK_ICON, ns.NO_CHECK_ICON = CHECK, NO_CHECK -- The quest chain's turned-in parts use them too (Quest-Chain.lua)
local COUNT_GAP = 8 -- Between a name and its count

--[[
	Body text wraps short of the column's edge, so a number flush against it (an objective's count, gold,
	experience, the quest ID) looks like it runs past the text. Those numbers end two spaces in instead, measured in
	the font given, on a hidden FontString: a pair of spaces between two zeros, less the zeros alone,
	since a FontString may not draw trailing spaces
]]
local measure = UIParent:CreateFontString(nil, "ARTWORK")
measure:Hide()

function ns.TwoSpacesWide(fontSource)
	local fontObject = fontSource:GetFontObject()
	if fontObject then
		measure:SetFontObject(fontObject)
	else
		measure:SetFont(fontSource:GetFont())
	end
	measure:SetText("0  0")
	local spaced = measure:GetStringWidth()
	measure:SetText("00")
	return spaced - measure:GetStringWidth()
end

--[[
	"8/8 Ragefire Trogg slain" (WoW Forever) or "Ragefire Trogg slain: 8/8" (Classic). Anything else, a
	reputation objective say, is all name
]]
local function SplitObjective(text)
	local have, need, name = text:match("^%s*(%d+)%s*/%s*(%d+)%s+(.+)$")
	if not have then
		name, have, need = text:match("^(.-):%s*(%d+)%s*/%s*(%d+)%s*$")
	end
	if have then
		return name, format("%s / %s", have, need)
	end
	return text
end

local objectiveCounts = {} -- Count column for each objective line, by line

-- Skins (ElvUI) recolour the lines in hooks that may run after styling, so the counts match them again a frame later
local recolorPending
local function RecolorCounts()
	recolorPending = nil
	for line, count in pairs(objectiveCounts) do
		if count:IsShown() then
			count:SetTextColor(line:GetTextColor())
		end
	end
end

-- Hides every count, before the objective lines showing now are styled
function ns.ClearObjectiveCounts()
	for _, count in pairs(objectiveCounts) do
		count:Hide()
	end
end

-- Space between lines that sets text in font size at LAYOUT.LINE_HEIGHT
local function LineSpacing(size)
	return size * (ns.LAYOUT.LINE_HEIGHT - 1)
end

--[[
	Works out LAYOUT.QUEST_LINE, LAYOUT.HEADING_SPACE_ABOVE and LAYOUT.QUEST_ID_GAP in pixels from
	questText (the quest description), whose font differs between clients and languages
]]
function ns.SetTextSpacing(questText)
	local _, size = questText:GetFont()
	local LAYOUT = ns.LAYOUT
	local function Lines(count)
		return math.floor(count * size * LAYOUT.LINE_HEIGHT + 0.5)
	end
	LAYOUT.QUEST_LINE = Lines(1)
	LAYOUT.HEADING_SPACE_ABOVE = Lines(LAYOUT.HEADING_LINES_ABOVE)
	LAYOUT.QUEST_ID_GAP = Lines(LAYOUT.QUEST_ID_LINES)
end

--[[
	The Description and Rewards headings: the title's font, LAYOUT.SECTION_HEADING_SHRINK smaller, or
	the title's size under ElvUI, whose plain title font is already small beside Blizzard's.
	Skins (ElvUI) set QuestTitleFont after the headings are styled, and again when their font options
	change, so it follows every change to QuestTitleFont's font and shadow
]]
local sectionHeadingFont = CreateFont("PrettyWideQuestLogSectionHeadingFont")
local headingShrink = C_AddOns.IsAddOnLoaded("ElvUI") and 0 or ns.LAYOUT.SECTION_HEADING_SHRINK

local function SyncSectionHeadingFont()
	local file, size, flags = QuestTitleFont:GetFont()
	if file and size then
		sectionHeadingFont:CopyFontObject(QuestTitleFont)
		sectionHeadingFont:SetFont(file, size - headingShrink, flags)
	end
end
SyncSectionHeadingFont()
for _, method in ipairs({ "SetFont", "SetShadowColor", "SetShadowOffset" }) do
	hooksecurefunc(QuestTitleFont, method, SyncSectionHeadingFont)
end

-- Sets a FontString's font object, keeping its colour
local function SetFontObjectKeepingColour(region, fontObject)
	local red, green, blue, alpha = region:GetTextColor()
	region:SetFontObject(fontObject)
	region:SetTextColor(red, green, blue, alpha)
end

-- Each FontString's font and line spacing as Blizzard left it, kept the first time it's restyled
local blizzardStyle = {}

function ns.RememberBlizzardStyle(region)
	if blizzardStyle[region] then
		return
	end
	local file, size, flags = region:GetFont()
	blizzardStyle[region] = {
		fontObject = region:GetFontObject(),
		file = file,
		size = size,
		flags = flags,
		spacing = region:GetSpacing(),
	}
end

-- Puts a remembered FontString's font and line spacing back, keeping its colour
function ns.RestoreBlizzardStyle(region)
	local style = blizzardStyle[region]
	if not style then
		return
	end
	local red, green, blue, alpha = region:GetTextColor()
	if style.fontObject then
		region:SetFontObject(style.fontObject)
	else
		region:SetFont(style.file, style.size, style.flags)
	end
	region:SetTextColor(red, green, blue, alpha)
	region:SetSpacing(style.spacing)
end

--[[
	Sets a FontString of quest text at LAYOUT.LINE_HEIGHT, and with sectionHeading true gives it the
	section heading font first
]]
function ns.StyleQuestText(region, sectionHeading)
	if sectionHeading and region:GetFontObject() ~= sectionHeadingFont then
		SetFontObjectKeepingColour(region, sectionHeadingFont)
	end
	local _, size = region:GetFont()
	region:SetSpacing(LineSpacing(size))
end

--[[
	Sets a number Blizzard draws in its own white outlined font (the experience reward) in source's font
	and colour (the description's), like the other numbers on the parchment
]]
local function StyleQuestNumber(region, source)
	local fontObject = source:GetFontObject()
	if fontObject then
		region:SetFontObject(fontObject)
	else
		region:SetFont(source:GetFont())
	end
	region:SetTextColor(source:GetTextColor())
end

--[[
	WoW Forever's QuestInfo pieces, shared by the quest giver window, the quest details and the map's
	details. The quest details style them before every repaint; elsewhere they follow the quest giver
	window cleanup (ns.ApplyQuestGiverCleanup), going back to Blizzard's while it's off. The other
	clients don't have them
]]
local QUEST_INFO_TEXT = {
	"QuestInfoTitleHeader",
	"QuestInfoObjectivesText",
	"QuestInfoDescriptionText",
	"QuestInfoRewardText",
}
local QUEST_INFO_HEADINGS = { "QuestInfoObjectivesHeader", "QuestInfoDescriptionHeader" }

-- Calls back with each QuestInfo piece this client has, and whether it's a section heading
local function EachQuestInfoPiece(callback)
	for _, name in ipairs(QUEST_INFO_TEXT) do
		if _G[name] then
			callback(_G[name], false)
		end
	end
	for _, name in ipairs(QUEST_INFO_HEADINGS) do
		if _G[name] then
			callback(_G[name], true)
		end
	end
	local rewards = QuestInfoRewardsFrame
	if rewards then
		for _, region in pairs({ rewards.ItemChooseText, rewards.ItemReceiveText }) do -- pairs, so any this client lacks drop out
			callback(region, false)
		end
		if rewards.Header then
			callback(rewards.Header, true)
		end
	end
end

local function StyleQuestInfoPiece(region, sectionHeading)
	ns.RememberBlizzardStyle(region)
	ns.StyleQuestText(region, sectionHeading)
end

function ns.StyleQuestInfo()
	EachQuestInfoPiece(StyleQuestInfoPiece)
end

function ns.RestoreQuestInfoStyle()
	EachQuestInfoPiece(ns.RestoreBlizzardStyle)
end

--[[
	The experience reward, each time QuestInfo shows one (the quest details, the quest giver window and the
	map's details), in the description's font and colour, its thousands grouped like the turn-in line's.
	On a quest giver page with the quest giver window cleanup off it stays Blizzard's
]]
local experienceFrame = QuestInfoRewardsFrame and QuestInfoRewardsFrame.XPFrame
local experienceValue = experienceFrame and experienceFrame.ValueText
if experienceValue and QuestInfo_Display then
	ns.RememberBlizzardStyle(experienceValue)
	local blizzardRed, blizzardGreen, blizzardBlue, blizzardAlpha = experienceValue:GetTextColor()
	hooksecurefunc("QuestInfo_Display", function(_, parentFrame)
		if ns.IsQuestGiverPage(parentFrame) and not ns.IsQuestGiverCleanupOn() then
			ns.RestoreBlizzardStyle(experienceValue)
			experienceValue:SetTextColor(blizzardRed, blizzardGreen, blizzardBlue, blizzardAlpha)
			return
		end
		StyleQuestNumber(experienceValue, QuestInfoDescriptionText)
		local experience = tonumber((experienceValue:GetText() or ""):gsub("%D", ""), 10)
		if experience then
			experienceValue:SetText(ns.FormatNumber(experience))
		end
	end)
end

--[[
	Spaces the reward buttons LAYOUT.REWARD_BUTTONS_SPACE from the text around them: a button that hangs
	under a line of text (the first of its section) that far below it, and anything that hangs under a
	button (the next section's line) that far below that. Returns how much further down region went,
	for a block that has to grow to match
]]
function ns.SpaceAroundRewardButtons(region)
	if (not region) or (not region:IsShown()) or (region:GetNumPoints() < 1) then
		return 0
	end
	local point, relativeTo, relativePoint, x, y = region:GetPoint(1)
	local relativeType = relativeTo and relativeTo.GetObjectType and relativeTo:GetObjectType()
	local isButton = region:GetObjectType() == "Button"
	if isButton and relativeType ~= "FontString" then
		return 0 -- Buttons further down a section only sit beside or below the one before
	end
	if (not isButton) and relativeType ~= "Button" then
		return 0
	end
	local spacedY = -ns.LAYOUT.REWARD_BUTTONS_SPACE
	region:SetPoint(point, relativeTo, relativePoint, x, spacedY)
	return y - spacedY
end

-- Gives a FontString the same font and line spacing as another, keeping its own colour
local function MatchFont(region, source)
	local red, green, blue, alpha = region:GetTextColor()
	local fontObject = source:GetFontObject()
	if fontObject then
		region:SetFontObject(fontObject)
	else
		region:SetFont(source:GetFont())
	end
	region:SetSpacing(source:GetSpacing())
	region:SetTextColor(red, green, blue, alpha)
end

--[[
	Restyles one of Blizzard's objective lines (a FontString), whose left edge is the left edge of a
	text column width wide. text and finished are the objective's, from GetQuestLogLeaderBoard().
	Blizzard draws objectives a size smaller than the rest of the quest text; they take fontSource's
	font (the description's) instead
]]
function ns.StyleObjective(line, text, finished, width, fontSource)
	local name, countText = SplitObjective(text or "")
	MatchFont(line, fontSource)
	line:SetText((finished and CHECK or NO_CHECK) .. " " .. name)

	local count = objectiveCounts[line]
	if not count then
		count = line:GetParent():CreateFontString(nil, "ARTWORK")
		count:SetJustifyH("RIGHT")
		objectiveCounts[line] = count
	end
	if not countText then
		line:SetWidth(width)
		return
	end

	MatchFont(count, line)
	count:SetTextColor(line:GetTextColor())
	if not recolorPending then
		recolorPending = true
		C_Timer.After(0, RecolorCounts)
	end
	local inset = ns.TwoSpacesWide(count)
	count:SetText(countText)
	count:ClearAllPoints()
	count:SetPoint("TOPRIGHT", line, "TOPLEFT", width - inset, 0)
	count:Show()
	line:SetWidth(width - inset - count:GetStringWidth() - COUNT_GAP)
end
