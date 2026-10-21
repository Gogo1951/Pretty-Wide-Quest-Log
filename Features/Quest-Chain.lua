local _, ns = ...
local L = ns.L
local LAYOUT = ns.LAYOUT

-- Every client: where the selected quest sits in its chain, from Questie's quest database, in the quest details.

-- Behind this quest's line, so it reads as the one you're on
local CURRENT_PART_BAND = "000000"
local CURRENT_PART_BAND_ALPHA = 0.12
local ROW_GAP = 1

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
	The quest IDs of the chain through questID, first part first, and questID's place in it; nil when
	the quest is in no chain Questie knows. Where a chain branches, only its straight run is followed
]]
function ns.GetQuestChain(questID)
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
	return parts, position
end

-- A part's name with the quest log's tag ("[60D] Agent of Hydraxis"), or the name alone when Questie has no level
local function PartLabel(questID)
	local title = ns.GetQuestTitleByID(questID) or Query(questID, "name") or tostring(questID)
	local level = Query(questID, "questLevel")
	if type(level) ~= "number" or level <= 0 then
		return title
	end
	return ns.LevelTitle(level, title, ns.QuestSuffix(QuestTag(questID)))
end

--------------------------------------------------------------------------------
-- The Section
--------------------------------------------------------------------------------

--[[
	A Quest Chain heading over one row per part, marked in the objectives' check column: a check for
	each part turned in. This quest's row sits on a faint band instead of a mark. Hovering a row shows
	Questie's tooltip for that quest. Each client's details place it below the rewards
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

local function Row(section, index)
	local row = section.rows[index]
	if row then
		return row
	end
	row = CreateFrame("Button", nil, section)
	row:SetWidth(LAYOUT.CONTENT_WIDTH)
	row.Band = row:CreateTexture(nil, "BACKGROUND")
	row.Band:SetAllPoints()
	local red, green, blue = ns.HexToRGB(CURRENT_PART_BAND)
	row.Band:SetColorTexture(red, green, blue, CURRENT_PART_BAND_ALPHA)
	row.Text = row:CreateFontString(nil, "ARTWORK")
	row.Text:SetPoint("LEFT")
	row.Text:SetWidth(LAYOUT.CONTENT_WIDTH)
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

	CopyFont(section.Heading, headingSource)
	section.Heading:SetText(L["QUEST_CHAIN"])
	local height = section.Heading:GetStringHeight()
	local above, gap = section.Heading, LAYOUT.HEADING_SPACE_BELOW

	for index, partID in ipairs(parts) do
		local row = Row(section, index)
		local turnedIn = index ~= position and C_QuestLog.IsQuestFlaggedCompleted(partID)
		local mark = turnedIn and ns.CHECK_ICON or ns.NO_CHECK_ICON
		CopyFont(row.Text, textSource)
		row.Text:SetText(mark .. " " .. PartLabel(partID))
		row.questID = partID
		row.Band:SetShown(index == position)
		row:SetHeight(row.Text:GetStringHeight() + 2)
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
