local _, ns = ...
local L = ns.L

-- How both quest logs draw a quest: its title in the list, its text's styling, objective lines and quest ID.
-- Its rewards are drawn in Quest-Rewards.lua.

--------------------------------------------------------------------------------
-- Quest Text
--------------------------------------------------------------------------------

--[[
	Letters after the level in the quest list, by quest tag. Elite quests without a tag of their own get E.
	Tag 1 is Elite on Classic Era and WoW Forever but Group on TBC, so the tags live in each flavor's folder
	(ns.QUEST_TAG_SUFFIXES)
]]
local QUEST_TAG_SUFFIX = {}
for tagID, kind in pairs(ns.QUEST_TAG_SUFFIXES) do
	QUEST_TAG_SUFFIX[tagID] = L["QUEST_SUFFIX_" .. kind]
end
local ELITE_SUFFIX = L["QUEST_SUFFIX_ELITE"]

function ns.QuestSuffix(tagID, isElite)
	return (tagID and QUEST_TAG_SUFFIX[tagID]) or (isElite and ELITE_SUFFIX) or ""
end

--[[
	"Letters after the level: D dungeon, R raid, E elite, P PvP.": each letter this client can show, with
	what it stands for, for the Show Quest Levels tooltips. E is always in, as an elite quest without a tag
	of its own gets it on any client
]]
local LEGEND_ORDER = { "DUNGEON", "RAID", "GROUP", "ELITE", "PVP" }

local questLevelLegend
do
	local shown = { ELITE = true }
	for _, kind in pairs(ns.QUEST_TAG_SUFFIXES) do
		shown[kind] = true
	end
	local entries = {}
	for _, kind in ipairs(LEGEND_ORDER) do
		if shown[kind] then
			entries[#entries + 1] =
				L["QUEST_LEVEL_LEGEND_ENTRY"]:format(L["QUEST_SUFFIX_" .. kind], L["QUEST_TYPE_" .. kind])
		end
	end
	questLevelLegend = L["QUEST_LEVEL_LEGEND"]:format(table.concat(entries, L["LIST_SEPARATOR"]))
end

function ns.QuestLevelLegend()
	return questLevelLegend
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

-- A quest ID and its chain link, if it has one, in source's color
local function ColorQuestID(text, source)
	local r, g, b = source:GetTextColor()
	text:SetTextColor(r, g, b)
	local label = QuestIDText(text.questID)
	if text.linksToWowhead then
		label =
			format("|T%s:0:0:0:0:32:32:0:32:0:32:%d:%d:%d|t %s", ns.WOWHEAD_LINK_ICON, r * 255, g * 255, b * 255, label)
	end
	text:SetText(label)
end

--[[
	Shows a quest ID in a FontString, in the same font and color as source (the description) but
	smaller. One that links to Wowhead starts with a chain link, in the same color. Skins (ElvUI) recolor
	the description in hooks that may run after this, so the first quest shown would keep Blizzard's
	parchment color. It follows each later recoloring of source instead
]]
function ns.StyleQuestID(text, questID, source)
	local file, size, flags = source:GetFont()
	if file and size then
		text:SetFont(file, size - ns.LAYOUT.QUEST_ID_FONT_SHRINK, flags)
	end
	text.questID = questID
	ColorQuestID(text, source)
	if not text.followsSourceColor then
		text.followsSourceColor = true
		hooksecurefunc(source, "SetTextColor", function()
			ColorQuestID(text, source)
		end)
	end
end

--[[
	An empty piece PAGE_TOP tall under region (the quest ID at the end of a quest giver page), showing
	whenever region does. A scroll frame scrolls as far as the last thing on its page, so this leaves the
	page's own margin under region when scrolled to the bottom, rather than region against the edge.
	Returns it, for a region that moves to another parent
]]
function ns.CreateRoomBelow(parent, region)
	local room = parent:CreateTexture(nil, "BACKGROUND")
	room:SetColorTexture(0, 0, 0, 0)
	room:SetSize(1, ns.LAYOUT.PAGE_TOP)
	room:SetPoint("TOPRIGHT", region, "BOTTOMRIGHT")
	room:SetShown(region:IsShown())
	hooksecurefunc(region, "Show", function()
		room:Show()
	end)
	hooksecurefunc(region, "Hide", function()
		room:Hide()
	end)
	return room
end

--[[
	Objective lines in the quest details: a green check for a finished objective (or
	a blank the same size, so the names line up), the objective's name, and its count ("8 / 8")
	right-aligned in a column of its own, two spaces in from the right edge of the text column
]]
local CHECK_TEXTURE = "Interface\\RaidFrame\\ReadyCheck-Ready"
local NO_CHECK_TEXTURE = "Interface\\Common\\spacer"

--[[
	The check (or the blank in its place) for a line in region's font, sized to the font in so many
	pixels, and CHECK_DROP of its size lower than the game would put it, which is high beside the
	text, so its foot sits on the line the letters sit on. Left to size itself (":0"), it came out small
	and riding high beside the text in ElvUI's quest font. The quest chain's turned-in parts use it too
	(Quest-Chain.lua)
]]
local CHECK_DROP = 0.25

function ns.CheckIcon(region, checked)
	local _, size = region:GetFont()
	size = size or 12
	local pixels = math.floor(size + 0.5)
	local drop = math.floor(size * CHECK_DROP + 0.5)
	return format("|T%s:%d:%d:0:%d|t", checked and CHECK_TEXTURE or NO_CHECK_TEXTURE, pixels, pixels, -drop)
end
local COUNT_GAP = ns.LAYOUT.SPACE.NEAR -- Between a name and its count

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

-- Skins (ElvUI) recolor the lines in hooks that may run after styling, so the counts match them again a frame later
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

-- Sets a FontString's font object, keeping its color
local function SetFontObjectKeepingColor(region, fontObject)
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

-- Puts a remembered FontString's font and line spacing back, keeping its color
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
	Sets a FontString of quest text LAYOUT.LINE_SPACING between lines, and with sectionHeading true gives
	it the section heading font first
]]
function ns.StyleQuestText(region, sectionHeading)
	if sectionHeading and region:GetFontObject() ~= sectionHeadingFont then
		SetFontObjectKeepingColor(region, sectionHeadingFont)
	end
	region:SetSpacing(ns.LAYOUT.LINE_SPACING)
end

--[[
	QuestInfo pieces, shared on every client by the quest giver window's detail and reward pages, and on
	WoW Forever and Mists by the quest details and Blizzard's own (the map's on WoW Forever, the quest
	log's on Mists) too. The quest details style them before
	every repaint; elsewhere they follow the quest giver window cleanup (ns.ApplyQuestGiverCleanup),
	going back to Blizzard's while it's off. A piece a client lacks is skipped
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

-- Gives a FontString the same font and line spacing as another, keeping its own color
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
	line:SetText(ns.CheckIcon(line, finished) .. " " .. name)

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
