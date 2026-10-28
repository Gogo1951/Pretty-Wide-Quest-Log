local _, ns = ...
local L = ns.L
local LAYOUT = ns.LAYOUT

-- Every client: where the selected quest sits in its chain, from Questie's quest database, in the quest details.

-- Behind this quest's line, so it reads as the one you're on: the text's own color, faint, so it shows on any skin
local CURRENT_PART_BAND_ALPHA = 0.12
local CURRENT_PART_BAND_MARGIN = 3 -- Above and below the row, so the band leaves room around the badge
local TURNED_IN_ALPHA = 0.6 -- A turned-in part's name, so the parts still ahead stand out
local ROW_GAP = LAYOUT.HEADER_GAP -- Between parts: the quest list's space above a zone

--[[
	The level badge: the part's quest log color on a dark shade of the same color. Those colors are made for
	dark backgrounds, so on its own box the level reads on the parchment and on any skin alike
]]
local BADGE_SHADE = 0.3 -- Of the quest log color, for the box
local BADGE_PAD_X = 6 -- Clear of the round ends
local WHITE_TEXTURE = "Interface\\Buttons\\WHITE8X8"
local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local BADGE_PAD_Y = 1

--------------------------------------------------------------------------------
-- Questie
--------------------------------------------------------------------------------

local questieModules = {}
local function QuestieModule(name)
	questieModules[name] = questieModules[name] or ns.ImportQuestieModule(name)
	return questieModules[name]
end

-- One field of a quest's record in Questie's database, or nil while Questie isn't loaded or isn't ready
local function Query(questID, field)
	local questieDB = QuestieModule("QuestieDB")
	if not (questieDB and type(questieDB.QueryQuestSingle) == "function") then
		return nil
	end
	local found, value = pcall(questieDB.QueryQuestSingle, questID, field)
	return found and value or nil
end

-- A quest's tag and whether it's elite, from Questie's corrected list when it has one, else the client's
local function QuestTag(questID)
	local questieDB = QuestieModule("QuestieDB")
	if questieDB and type(questieDB.GetQuestTagInfo) == "function" then
		local found, tagID, tagName = pcall(questieDB.GetQuestTagInfo, questID)
		if found and (tagID or tagName) then
			return tagID, ELITE ~= nil and tagName == ELITE
		end
	end
	return ns.GetQuestTagByID(questID)
end

-- Questie's own tooltip for a quest, the one its quest links show
local function ShowQuestieTooltip(row)
	local questieLink = QuestieModule("QuestieLink")
	if not (row.questID and questieLink and type(questieLink.CreateQuestTooltip) == "function") then
		return
	end
	GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
	local link = "questie:" .. row.questID .. ":" .. UnitGUID("player")
	local shown = pcall(questieLink.CreateQuestTooltip, questieLink, link, GameTooltip)
	if shown and GameTooltip:NumLines() > 0 then
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end
end

--------------------------------------------------------------------------------
-- The Chain
--------------------------------------------------------------------------------

local MAX_PARTS = 25 -- A walk this long has met a loop in the data

-- The part before a quest in a straight chain: its only prerequisite, which names it as the next part
local function PreviousPart(questID)
	local group = Query(questID, "preQuestGroup")
	if type(group) == "table" and next(group) then
		return nil
	end
	local single = Query(questID, "preQuestSingle")
	if type(single) ~= "table" or #single ~= 1 then
		return nil
	end
	if Query(single[1], "nextQuestInChain") == questID then
		return single[1]
	end
end

local function NextPart(questID)
	local nextID = Query(questID, "nextQuestInChain")
	if type(nextID) == "number" and nextID ~= 0 then
		return nextID
	end
end

--[[
	The last chain found, as the quest details repaint in bursts and Questie's data doesn't change in a
	session. Only a chain found is kept: before Questie's database is ready a quest is in none
]]
local lastChain = {}

--[[
	The quest IDs of the chain through questID, first part first, and questID's place in it; nil when
	the quest is in no chain Questie knows. Where a chain branches, only its straight run is followed.
	Callers only read them: the section shows the parts and counts the position in its heading
]]
function ns.GetQuestChain(questID)
	if lastChain.questID == questID then
		return lastChain.parts, lastChain.position
	end
	local parts, seen = { questID }, { [questID] = true }
	local previous = PreviousPart(questID)
	while previous and not seen[previous] and #parts < MAX_PARTS do
		table.insert(parts, 1, previous)
		seen[previous] = true
		previous = PreviousPart(previous)
	end
	local position = #parts
	local nextID = NextPart(questID)
	while nextID and not seen[nextID] and #parts < MAX_PARTS do
		parts[#parts + 1] = nextID
		seen[nextID] = true
		nextID = NextPart(nextID)
	end
	if #parts < 2 then
		return nil
	end
	lastChain.questID, lastChain.parts, lastChain.position = questID, parts, position
	return parts, position
end

-- A part's level badge ("60D", the quest log's tag without its brackets) and its name ("Agent of Hydraxis"), with Questie's level for it
local function PartLabel(questID)
	local title = ns.GetQuestTitleByID(questID) or Query(questID, "name") or tostring(questID)
	local level = Query(questID, "questLevel")
	if type(level) ~= "number" or level <= 0 then
		return nil, title
	end
	return format("%d%s", level, ns.QuestSuffix(QuestTag(questID))), title, level
end

--[[
	Every badge is as wide as the widest one could be: two of the widest digit and the widest letter, in
	the badge's font, so the names line up down the chain. Measured on a hidden FontString once per font
]]
local BADGE_SUFFIXES = { "", L["QUEST_SUFFIX_ELITE"] }
for _, kind in pairs(ns.QUEST_TAG_SUFFIXES) do
	BADGE_SUFFIXES[#BADGE_SUFFIXES + 1] = L["QUEST_SUFFIX_" .. kind]
end

local measure = UIParent:CreateFontString(nil, "ARTWORK")
measure:Hide()
local badgeWidths = {}

local function BadgeTextWidth(file, size, flags)
	local key = format("%s:%s:%s", file, size, flags or "")
	if badgeWidths[key] then
		return badgeWidths[key]
	end
	measure:SetFont(file, size, flags)
	local widest = 0
	for digit = 0, 9 do
		for _, suffix in ipairs(BADGE_SUFFIXES) do
			measure:SetText(digit .. digit .. suffix)
			widest = math.max(widest, measure:GetStringWidth())
		end
	end
	badgeWidths[key] = widest
	return widest
end

--[[
	The color the quest log gives a part: for a part in the log on WoW Forever, how hard the server rates
	it for the player, as Forever-Quest-List.lua colors it. The server rates only quests in the log, so any
	other part, and every part on Classic, goes by its level against the player's. Nil when neither is known
]]
local function PartColor(questID, level)
	local difficulty = C_PlayerInfo
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer
		and C_QuestLog.GetLogIndexForQuestID
		and C_QuestLog.GetLogIndexForQuestID(questID)
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer(questID)
	if difficulty and GetDifficultyColor then
		return GetDifficultyColor(difficulty)
	end
	if level then
		return GetQuestDifficultyColor(level)
	end
end

--------------------------------------------------------------------------------
-- The Section
--------------------------------------------------------------------------------

--[[
	A Quest Chain heading, counting this quest's place ("Quest Chain (3 of 5)"), over one row per part, marked in the objectives' check column: a check for
	each part turned in. Then the part's level in its quest log color on a badge, and its name in the
	Description text's color, faded once turned in. This quest's row sits on a faint band instead of a
	mark. Hovering a row shows Questie's tooltip for that quest. Each client's details place it below
	the rewards
]]
function ns.CreateQuestChainSection(parent)
	local section = CreateFrame("Frame", nil, parent)
	section:SetWidth(LAYOUT.CONTENT_WIDTH)
	section.Heading = section:CreateFontString(nil, "ARTWORK")
	section.Heading:SetPoint("TOPLEFT")
	section.Heading:SetJustifyH("LEFT")
	section.rows = {}
	section:Hide()
	return section
end

--[[
	A pill: a cap at each end, the game's circle mask over a square as tall as the pill, and a middle
	between the caps' centers. All three are one solid color, so where they overlap doesn't show
]]
local function CreateBadge(parent)
	local badge = CreateFrame("Frame", nil, parent)
	badge.pieces = {}
	for _, point in ipairs({ "LEFT", "RIGHT" }) do
		local cap = badge:CreateTexture(nil, "ARTWORK")
		cap:SetTexture(WHITE_TEXTURE)
		cap:SetPoint(point)
		local mask = badge:CreateMaskTexture()
		mask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(cap)
		cap:AddMaskTexture(mask)
		badge[point] = cap
		badge.pieces[#badge.pieces + 1] = cap
	end
	local middle = badge:CreateTexture(nil, "ARTWORK")
	middle:SetTexture(WHITE_TEXTURE)
	middle:SetPoint("TOPLEFT", badge.LEFT, "TOP")
	middle:SetPoint("BOTTOMRIGHT", badge.RIGHT, "BOTTOM")
	badge.pieces[#badge.pieces + 1] = middle
	return badge
end

local function SizeBadge(badge, width, height)
	badge:SetSize(width, height)
	badge.LEFT:SetSize(height, height)
	badge.RIGHT:SetSize(height, height)
end

local function ColorBadge(badge, red, green, blue)
	for _, piece in ipairs(badge.pieces) do
		piece:SetVertexColor(red, green, blue)
	end
end

local function Row(section, index)
	local row = section.rows[index]
	if row then
		return row
	end
	row = CreateFrame("Button", nil, section)
	row:SetWidth(LAYOUT.CONTENT_WIDTH)
	row.Band = row:CreateTexture(nil, "BACKGROUND")
	row.Band:SetPoint("TOPLEFT", 0, CURRENT_PART_BAND_MARGIN)
	row.Band:SetPoint("BOTTOMRIGHT", 0, -CURRENT_PART_BAND_MARGIN)
	-- The mark and badge have a column of their own, so a name too long for one line wraps under the name
	row.Check = row:CreateFontString(nil, "ARTWORK")
	row.Check:SetPoint("TOPLEFT", 0, -1)
	row.Check:SetJustifyH("LEFT")
	row.Badge = CreateBadge(row)
	row.BadgeText = row.Badge:CreateFontString(nil, "OVERLAY")
	row.BadgeText:SetAllPoints()
	row.BadgeText:SetJustifyH("CENTER")
	row.BadgeText:SetShadowOffset(0, 0)
	row.Text = row:CreateFontString(nil, "ARTWORK")
	row.Text:SetJustifyH("LEFT")
	row:SetScript("OnEnter", ShowQuestieTooltip)
	row:SetScript("OnLeave", GameTooltip_Hide)
	section.rows[index] = row
	return row
end

--[[
	source's font, color and shadow. The shadow gives the Description heading and text their weight;
	read off the FontString itself, as skins (ElvUI) set it there rather than on its font object
]]
local function CopyFont(region, source)
	local file, size, flags = source:GetFont()
	if file and size then
		region:SetFont(file, size, flags)
	end
	region:SetTextColor(source:GetTextColor())
	region:SetShadowColor(source:GetShadowColor())
	region:SetShadowOffset(source:GetShadowOffset())
end

-- A row's name and band in the Description text's color, dark ink on parchment and whatever a skin sets
local function ColorRow(row, textSource)
	local red, green, blue = textSource:GetTextColor()
	row.Text:SetTextColor(red, green, blue)
	row.Text:SetShadowColor(textSource:GetShadowColor())
	row.Band:SetColorTexture(red, green, blue, CURRENT_PART_BAND_ALPHA)
end

--[[
	Skins (ElvUI) recolor the Description heading and text only after the details are filled, so the
	section would keep Blizzard's parchment colors. It follows each later recoloring of its sources instead
]]
local function FollowSourceColors(section, headingSource, textSource)
	if section.headingSource then
		return
	end
	section.headingSource, section.textSource = headingSource, textSource
	local function Recolor()
		section.Heading:SetTextColor(headingSource:GetTextColor())
		section.Heading:SetShadowColor(headingSource:GetShadowColor())
		for _, row in ipairs(section.rows) do
			ColorRow(row, textSource)
		end
	end
	for _, source in ipairs({ headingSource, textSource }) do
		hooksecurefunc(source, "SetTextColor", Recolor)
		hooksecurefunc(source, "SetShadowColor", Recolor)
	end
end

--[[
	Fills the section for questID in the fonts and colors of the details' Description heading and text.
	Returns whether it shows
]]
function ns.UpdateQuestChainSection(section, questID, headingSource, textSource)
	local parts, position
	if questID then
		parts, position = ns.GetQuestChain(questID)
	end
	if not parts then
		section:Hide()
		return false
	end

	FollowSourceColors(section, headingSource, textSource)
	CopyFont(section.Heading, headingSource)
	section.Heading:SetText(L["QUEST_CHAIN_PROGRESS"]:format(position, #parts))
	local height = section.Heading:GetStringHeight()
	local above, gap = section.Heading, LAYOUT.HEADING_SPACE_BELOW
	local spaceWidth = ns.TwoSpacesWide(textSource) / 2 -- Between the check, the badge and the name

	-- The badge's text a size down from the Description's, as the quest ID is
	local file, size, flags = textSource:GetFont()
	local badgeSize = size and size - LAYOUT.QUEST_ID_FONT_SHRINK
	local badgeWidth = (file and BadgeTextWidth(file, badgeSize, flags) or 0) + 2 * BADGE_PAD_X

	for index, partID in ipairs(parts) do
		local row = Row(section, index)
		local turnedIn = index ~= position and C_QuestLog.IsQuestFlaggedCompleted(partID)
		local tag, title, level = PartLabel(partID)
		CopyFont(row.Check, textSource)
		row.Check:SetText(turnedIn and ns.CHECK_ICON or ns.NO_CHECK_ICON)
		local checkWidth = row.Check:GetStringWidth()
		local lineHeight = row.Check:GetStringHeight()

		-- A part with no level keeps its badge's room, so its name still lines up
		local color = PartColor(partID, level)
		if file then
			row.BadgeText:SetFont(file, badgeSize, flags)
		end
		row.BadgeText:SetText(tag)
		local badgeHeight = row.BadgeText:GetStringHeight() + 2 * BADGE_PAD_Y
		SizeBadge(row.Badge, badgeWidth, badgeHeight)
		row.Badge:ClearAllPoints()
		row.Badge:SetPoint("TOPLEFT", checkWidth + spaceWidth, -1 - (lineHeight - badgeHeight) / 2)
		local hasBadge = tag ~= nil and color ~= nil
		if hasBadge then
			row.BadgeText:SetTextColor(color.r, color.g, color.b)
			ColorBadge(row.Badge, color.r * BADGE_SHADE, color.g * BADGE_SHADE, color.b * BADGE_SHADE)
		end
		row.Badge:SetShown(hasBadge)

		local leadWidth = checkWidth + spaceWidth + badgeWidth + spaceWidth
		CopyFont(row.Text, textSource)
		row.Text:ClearAllPoints()
		row.Text:SetPoint("TOPLEFT", leadWidth, -1)
		row.Text:SetWidth(LAYOUT.CONTENT_WIDTH - leadWidth)
		row.Text:SetText(title)
		row.Text:SetAlpha(turnedIn and TURNED_IN_ALPHA or 1)
		ColorRow(row, textSource)
		row.questID = partID
		row.Band:SetShown(index == position)
		row:SetHeight(math.max(row.Text:GetStringHeight(), badgeHeight) + 2)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -gap)
		row:Show()
		height = height + gap + row:GetHeight()
		above, gap = row, ROW_GAP
	end
	for index = #parts + 1, #section.rows do
		section.rows[index]:Hide()
	end

	section:SetHeight(height)
	section:Show()
	return true
end
