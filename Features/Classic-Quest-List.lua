local _, ns = ...
local L = ns.L

-- Classic Era and TBC: the quest list (left pane) of Blizzard's widened quest log, sorted and spaced.

local LAYOUT = ns.LAYOUT

--------------------------------------------------------------------------------
-- Quest list (left pane)
--------------------------------------------------------------------------------

QuestLogNoQuestsText:ClearAllPoints()
QuestLogNoQuestsText:SetPoint("TOP", QuestLogListScrollFrame, 0, -90)

-- Quest rows overlap by a pixel, so the pitch of the list is one less than a title's height
local rowHeight = (QuestLogTitle1 and QuestLogTitle1:GetHeight() or 0)
if rowHeight < 8 then
	rowHeight = 16 -- QUESTLOG_QUEST_HEIGHT
end
rowHeight = rowHeight - 1

--[[
	QuestLog_Update() only fills rows up to QUESTS_DISPLAYED, so rows a taller window created and a
	shorter one no longer needs have to be hidden here or they keep drawing past the bottom edge.
	Returns whether the number of rows changed
]]
local createdRows = QUESTS_DISPLAYED
local function SetQuestRowCount(count)
	if count == QUESTS_DISPLAYED then
		return false
	end
	for i = createdRows + 1, count do
		local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate")
		button:SetID(i)
		button:Hide()
		button:SetPoint("TOPLEFT", QuestLogTitle1, "TOPLEFT", 0, -(i - 1) * rowHeight)
	end
	createdRows = math.max(createdRows, count)
	for i = count + 1, createdRows do
		_G["QuestLogTitle" .. i]:Hide()
	end
	QUESTS_DISPLAYED = count
	return true
end

local function GetQuestSuffix(questID, questTag)
	local tagID = questID and GetQuestTagInfo and GetQuestTagInfo(questID)
	return ns.QuestSuffix(tagID, ELITE ~= nil and questTag == ELITE)
end

--------------------------------------------------------------------------------
-- Sorting
--------------------------------------------------------------------------------

--[[
	Blizzard's QuestLog_Update() fills row i with quest log entry i + offset. With sorting on, each row is
	redrawn with the entry at its place in the sorted order, and its ID points there too: a row's click,
	shift-click, collapse and tooltip all find their entry from the ID, so they act on the quest the row
	shows. The rows stay Blizzard's own, for the add-ons that hook them.
]]

local zoneOrder -- Zone ranks frozen while the window stays open (ns.SortZones)
local knownZoneLevels = {} -- A collapsed zone lists no quests, so it sorts by its level when last open

--[[
	The display order as quest log indexes, or nil when that's the quest log's own order (zones
	alphabetical, each zone's quests lowest level first) and the rows can stay as Blizzard drew them
]]
local function BuildDisplayOrder()
	if not ns.db then
		return nil
	end
	local zoneSort, questSort = ns.db.profile.zoneSort, ns.db.profile.questSort

	local loose, zones, zone = {}, {}, nil
	for index = 1, GetNumQuestLogEntries() do
		local title, level, _, isHeader = GetQuestLogTitle(index)
		if isHeader then
			zone = { title = title, sortIndex = index, sortKey = ns.NameSortKey(title), quests = {} }
			zones[#zones + 1] = zone
		else
			local quest = { sortIndex = index, sortLevel = level or 0, sortKey = ns.NameSortKey(title) }
			if zone then
				zone.quests[#zone.quests + 1] = quest
			else
				loose[#loose + 1] = quest
			end
		end
	end

	ns.SortQuests(loose, questSort)
	for _, each in ipairs(zones) do
		each.averageLevel = ns.AverageLevel(each.quests)
		if each.averageLevel then
			knownZoneLevels[each.title or ""] = each.averageLevel
		else
			each.averageLevel = knownZoneLevels[each.title or ""]
		end
		ns.SortQuests(each.quests, questSort)
	end
	zoneOrder = ns.SortZones(zones, zoneSort, zoneOrder)

	local order, changed = {}, false
	local function Add(index)
		order[#order + 1] = index
		changed = changed or index ~= #order
	end
	for _, quest in ipairs(loose) do
		Add(quest.sortIndex)
	end
	for _, each in ipairs(zones) do
		Add(each.sortIndex)
		for _, quest in ipairs(each.quests) do
			Add(quest.sortIndex)
		end
	end
	return changed and order or nil
end

-- The quest log entry shown at a place in the list
local function EntryAt(order, position)
	return order and order[position] or position
end

local DAILY_FREQUENCY = LE_QUEST_FREQUENCY_DAILY -- TBC tags daily quests; Classic Era has none

-- Redraws a row the way QuestLog_Update() would for this entry, and points the row's ID at it
local function RedrawRow(row, index, offset)
	row:SetID(index - offset)
	local name = row:GetName()
	local tag, groupMates = _G[name .. "Tag"], _G[name .. "GroupMates"]
	local check, highlight = _G[name .. "Check"], _G[name .. "Highlight"]
	local title, level, questTag, isHeader, isCollapsed, isComplete, frequency = GetQuestLogTitle(index)

	row.isHeader = isHeader
	if isHeader then
		row:SetText(title or "")
		row:SetNormalTexture(
			isCollapsed and "Interface\\Buttons\\UI-PlusButton-Up" or "Interface\\Buttons\\UI-MinusButton-Up"
		)
		highlight:SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		groupMates:SetText("")
		check:Hide()
	else
		row:SetText("  " .. (title or ""))
		row:ClearNormalTexture()
		highlight:SetTexture("")
		local onQuest = 0
		for member = 1, GetNumSubgroupMembers() do
			if IsUnitOnQuest(index, "party" .. member) then
				onQuest = onQuest + 1
			end
		end
		groupMates:SetText(onQuest > 0 and ("[" .. onQuest .. "]") or "")
		check:SetShown(IsQuestWatched(index) and true or false)
	end

	if isComplete and isComplete < 0 then
		questTag = FAILED
	elseif isComplete and isComplete > 0 then
		questTag = COMPLETE
	elseif DAILY_FREQUENCY and frequency == DAILY_FREQUENCY then
		questTag = questTag and format(DAILY_QUEST_TAG_TEMPLATE, questTag) or DAILY
	end
	tag:SetText(questTag and ("(" .. questTag .. ")") or "")

	local color = isHeader and QuestDifficultyColors.header or GetQuestDifficultyColor(level)
	row:SetNormalFontObject(color.font)
	tag:SetTextColor(color.r, color.g, color.b)
	groupMates:SetTextColor(color.r, color.g, color.b)
	row.r, row.g, row.b = color.r, color.g, color.b
end

-- Moves the selection highlight to the row showing the selected quest
local function PlaceSelectionHighlight(order)
	local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
	local selected = QuestLogFrame.selectedButtonID and GetQuestLogSelection()
	QuestLogHighlightFrame:Hide()
	for i = 1, QUESTS_DISPLAYED do
		local row = _G["QuestLogTitle" .. i]
		if selected and row:IsShown() and order[offset + i] == selected then
			local name = row:GetName()
			QuestLogSkillHighlight:SetVertexColor(row.r, row.g, row.b)
			QuestLogHighlightFrame:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
			QuestLogHighlightFrame:Show()
			_G[name .. "Tag"]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			_G[name .. "GroupMates"]:SetTextColor(
				HIGHLIGHT_FONT_COLOR.r,
				HIGHLIGHT_FONT_COLOR.g,
				HIGHLIGHT_FONT_COLOR.b
			)
			row:LockHighlight()
		else
			row:UnlockHighlight()
		end
	end
end

local function RedrawRows(order)
	local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
	if not order then
		for i = 1, QUESTS_DISPLAYED do
			_G["QuestLogTitle" .. i]:SetID(i)
		end
		return
	end
	for i = 1, QUESTS_DISPLAYED do
		local index = order[offset + i]
		if index then
			RedrawRow(_G["QuestLogTitle" .. i], index, offset)
		end
	end
	PlaceSelectionHighlight(order)
end

--------------------------------------------------------------------------------
-- Zone Gaps
--------------------------------------------------------------------------------

local function ZoneGap()
	return (ns.db and ns.db.profile.zoneGap) and LAYOUT.HEADER_GAP or 0
end

--[[
	Each gap counts as an extra row of scrolling, so the last quests can still be scrolled into view.
	Extending the range can scroll the list, which runs QuestLog_Update() again
]]
local extendingScroll
local function ExtendScrollRange(order)
	local gap = ZoneGap()
	if extendingScroll or gap == 0 then
		return
	end
	local entryCount = GetNumQuestLogEntries()
	local gaps = 0
	for position = 2, entryCount do
		if select(4, GetQuestLogTitle(EntryAt(order, position))) then
			gaps = gaps + 1
		end
	end
	if gaps > 0 then
		extendingScroll = true
		FauxScrollFrame_Update(
			QuestLogListScrollFrame,
			entryCount + math.ceil(gaps * gap / rowHeight),
			QUESTS_DISPLAYED,
			QUESTLOG_QUEST_HEIGHT,
			nil,
			nil,
			nil,
			QuestLogHighlightFrame,
			293,
			316
		)
		extendingScroll = nil
	end
end

--[[
	With zoneGap on, a gap above every zone but the first, made by moving Blizzard's own rows rather than
	replacing them. Rows pushed past the bottom are hidden. With the gap off, rows an earlier pass moved
	still go back to the plain pitch
]]
local function PositionRows(order)
	local gap = ZoneGap()
	local entryCount = GetNumQuestLogEntries()
	local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
	local paneHeight = QuestLogListScrollFrame:GetHeight()
	local top = 0
	for i = 2, QUESTS_DISPLAYED do
		local row = _G["QuestLogTitle" .. i]
		local position = offset + i
		top = top + rowHeight
		if gap > 0 and position <= entryCount and select(4, GetQuestLogTitle(EntryAt(order, position))) then
			top = top + gap
		end
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", QuestLogTitle1, "TOPLEFT", 0, -top)
		if top + rowHeight > paneHeight then
			row:Hide()
			if select(2, QuestLogHighlightFrame:GetPoint(1)) == row then
				QuestLogHighlightFrame:Hide()
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Row Style
--------------------------------------------------------------------------------

-- Level and type before each title, and the tracking mark, drawn in Blizzard's check, in a slot in front of it
local function StyleQuestRows(order)
	local entryCount = GetNumQuestLogEntries()
	local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
	for i = 1, math.min(QUESTS_DISPLAYED, entryCount - offset) do
		local row, index = _G["QuestLogTitle" .. i], EntryAt(order, offset + i)
		local text, check = row.Text, _G["QuestLogTitle" .. i .. "Check"]
		local title, level, questTag, isHeader, _, _, _, questID = GetQuestLogTitle(index)

		if isHeader then
			text:SetPoint("LEFT", row, "LEFT", LAYOUT.HEADER_TEXT_X, 0)
			check:Hide()
		else
			local label = ns.LevelTitle(level, title, GetQuestSuffix(questID, questTag))
			row:SetText(ns.VoiceOverTitlePrefix(text) .. label)
			text:SetPoint("LEFT", row, "LEFT", LAYOUT.QUEST_TEXT_X, 0)
			check:ClearAllPoints()
			check:SetPoint("LEFT", row, "LEFT", LAYOUT.CHECK_X, 0)
			check:SetDrawLayer("ARTWORK")
			ns.ShowTrackingMark(check, IsQuestWatched(index))

			--[[
				Blizzard sized the title for its old position and cut it short there, so measure it
				whole, then shorten it to clear the tag ("(Complete)", "(Elite)", ...) if it has to
			]]
			local tag = _G["QuestLogTitle" .. i .. "Tag"]
			local tagWidth = (tag and tag:IsShown() and (tag:GetText() or "") ~= "") and (tag:GetStringWidth() + 6) or 2
			local room = row:GetWidth() - LAYOUT.QUEST_TEXT_X - tagWidth
			text:SetWidth(0)
			if text:GetStringWidth() > room then
				text:SetWidth(room)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Expand All and Track All
--------------------------------------------------------------------------------

--[[
	They replace Blizzard's "All" toggle, inside its frame, which Blizzard hides while the log is empty.
	Expand All runs that toggle's own click, so Blizzard's record of whether everything is collapsed
	stays right
]]
QuestLogCollapseAllButton:SetAlpha(0)
QuestLogCollapseAllButton:EnableMouse(false)

local expandButton, trackButton = ns.CreateListButtons(QuestLogExpandButtonFrame)
expandButton:SetPoint("LEFT", QuestLogFrame, "TOPLEFT", LAYOUT.LIST_BUTTONS_X, LAYOUT.LIST_BUTTONS_Y)

expandButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	QuestLogCollapseAllButton_OnClick(QuestLogCollapseAllButton)
end)

-- The quest log indexes in the order the list shows them
local function ListedIndexes(order)
	local indexes = {}
	for position = 1, GetNumQuestLogEntries() do
		indexes[position] = EntryAt(order, position)
	end
	return indexes
end

local currentOrder
trackButton:SetScript("OnClick", function(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	local indexes = ListedIndexes(currentOrder)
	if self.trackAll then
		ns.TrackAllQuests(indexes)
	else
		ns.UntrackAllQuests(indexes)
	end
end)

--[[
	Collapse All while any zone is open, Expand All once every zone is collapsed. Track All while a quest
	could still be tracked, Untrack All once none can, enabled while any listed quest is tracked by
	Blizzard's tracker or Questie's
]]
local function UpdateListButtons(order)
	expandButton:SetText(QuestLogCollapseAllButton.collapsed and L["EXPAND_ALL"] or L["COLLAPSE_ALL"])

	local indexes = ListedIndexes(order)
	local trackAll = ns.CanTrackMore(indexes)
	trackButton.trackAll = trackAll
	trackButton:SetText(trackAll and L["TRACK_ALL"] or L["UNTRACK_ALL"])
	trackButton:SetEnabled(trackAll or ns.CanUntrackAny(indexes))
end

--------------------------------------------------------------------------------
-- Updating
--------------------------------------------------------------------------------

-- After each QuestLog_Update() while the window is open: scroll range, sorted rows, gaps, then each row's style
local function UpdateList()
	if not QuestLogFrame:IsShown() then
		return
	end
	currentOrder = BuildDisplayOrder()
	ExtendScrollRange(currentOrder)
	RedrawRows(currentOrder)
	PositionRows(currentOrder)
	ns.MatchVoiceOverButtons(currentOrder)
	StyleQuestRows(currentOrder) -- Last, as VoiceOver's button functions rewrite the title and move the check
	UpdateListButtons(currentOrder)
end

--------------------------------------------------------------------------------
-- Hooks
--------------------------------------------------------------------------------

hooksecurefunc("QuestLog_Update", UpdateList)

-- QuestLog_SetSelection() highlights the row at the selected entry's own place in the list
hooksecurefunc("QuestLog_SetSelection", function()
	if currentOrder then
		PlaceSelectionHighlight(currentOrder)
	end
end)

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------

function ns.GetQuestRowHeight()
	return rowHeight
end

ns.SetQuestRowCount = SetQuestRowCount
ns.UpdateClassicQuestList = UpdateList

-- Zones sort afresh on the next update rather than keeping the order the window opened with
function ns.ResetZoneOrder()
	zoneOrder = nil
	currentOrder = nil
end
