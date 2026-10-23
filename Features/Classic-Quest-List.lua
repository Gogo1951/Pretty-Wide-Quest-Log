local _, ns = ...

ns.AddWideQuestLogPart(function()
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
		A zone name says on hover that a right-click opens the zone menu (Zone-Menu.lua), and opens it. Zone
		names take left clicks only (StyleQuestRows), so a right-click never reaches Blizzard's collapse. The
		row's ID points at its entry (RedrawRow)
	]]
	local function ZoneTitleAt(row)
		local title, _, _, isHeader = GetQuestLogTitle(row:GetID() + FauxScrollFrame_GetOffset(QuestLogListScrollFrame))
		return isHeader and title or nil
	end

	local function OnRowMouseUp(row, button)
		local zoneTitle = button == "RightButton" and ZoneTitleAt(row)
		if zoneTitle then
			ns.HideZoneMenuHint(row)
			ns.OpenZoneMenu(row, zoneTitle)
		end
	end

	local function OnRowEnter(row)
		if ZoneTitleAt(row) then
			ns.ShowZoneMenuHint(row)
		end
	end

	local function OnRowLeave(row)
		ns.HideZoneMenuHint(row)
	end

	local function HookRow(row)
		row:HookScript("OnMouseUp", OnRowMouseUp)
		row:HookScript("OnEnter", OnRowEnter)
		row:HookScript("OnLeave", OnRowLeave)
	end

	for i = 1, QUESTS_DISPLAYED do
		HookRow(_G["QuestLogTitle" .. i])
	end

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
			HookRow(button)
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
			if select(4, GetQuestLogTitle(ns.ClassicEntryAt(order, position))) then
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
			if
				gap > 0
				and position <= entryCount
				and select(4, GetQuestLogTitle(ns.ClassicEntryAt(order, position)))
			then
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
			local row, index = _G["QuestLogTitle" .. i], ns.ClassicEntryAt(order, offset + i)
			local text, check = row.Text, _G["QuestLogTitle" .. i .. "Check"]
			local title, level, questTag, isHeader, _, _, _, questID = GetQuestLogTitle(index)

			if isHeader then
				row:RegisterForClicks("LeftButtonUp") -- Right-clicks open the zone menu instead
				row:SetText(ns.ZoneHeaderText(title or ""))
				text:SetPoint("LEFT", row, "LEFT", LAYOUT.HEADER_TEXT_X, 0)
				check:Hide()
			else
				row:RegisterForClicks("LeftButtonUp", "RightButtonUp") -- Blizzard's own, for quests
				local label = ns.QuestListTitle(level, title, GetQuestSuffix(questID, questTag))
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
				local tagWidth = (tag and tag:IsShown() and (tag:GetText() or "") ~= "") and (tag:GetStringWidth() + 6)
					or 2
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

	-- Blizzard's Track toggle sits just right of "All", under these buttons, and would peek out between them
	if QuestLogTrack then
		QuestLogTrack:SetAlpha(0)
		QuestLogTrack:EnableMouse(false)
	end

	local expandButton, trackButton = ns.CreateListButtons(QuestLogExpandButtonFrame)
	expandButton:SetPoint("LEFT", QuestLogFrame, "TOPLEFT", LAYOUT.LIST_BUTTONS_X, LAYOUT.LIST_BUTTONS_Y)
	-- The map's Show Map button follows them (Quest-Map.lua), and ElvUI styles them to match (Classic-ElvUI.lua)
	ns.listButtons = { expandButton, trackButton }

	expandButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		QuestLogCollapseAllButton_OnClick(QuestLogCollapseAllButton)
	end)

	-- The quest log indexes in the order the list shows them
	local function ListedIndexes(order)
		local indexes = {}
		for position = 1, GetNumQuestLogEntries() do
			indexes[position] = ns.ClassicEntryAt(order, position)
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

	local turnInLine = ns.CreateTurnInLine(QuestLogFrame)

	-- The quests (log indexes, in list order) ready to turn in, each under the zone header above it
	local function UpdateTurnInLine(indexes)
		local ready, zone = {}, nil
		for _, index in ipairs(indexes) do
			local title, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(index)
			if isHeader then
				zone = title
			elseif (isComplete or 0) > 0 and questID then
				ready[#ready + 1] = { questID = questID, title = title, zone = zone }
			end
		end
		ns.UpdateTurnInLine(turnInLine, ready)
	end

	--[[
		Collapse All while any zone is open, Expand All once every zone is collapsed. Track All while a quest
		could still be tracked, Untrack All once none can, enabled while any listed quest is tracked by
		Blizzard's tracker or Questie's. indexes are the quest log indexes in list order
	]]
	local function UpdateListButtons(indexes)
		expandButton:SetText(QuestLogCollapseAllButton.collapsed and L["EXPAND_ALL"] or L["COLLAPSE_ALL"])

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
		currentOrder = ns.BuildClassicDisplayOrder()
		ExtendScrollRange(currentOrder)
		ns.RedrawClassicRows(currentOrder)
		PositionRows(currentOrder)
		ns.MatchVoiceOverButtons(currentOrder)
		StyleQuestRows(currentOrder) -- Last, as VoiceOver's button functions rewrite the title and move the check
		local indexes = ListedIndexes(currentOrder)
		UpdateListButtons(indexes)
		UpdateTurnInLine(indexes)
	end

	--------------------------------------------------------------------------------
	-- Hooks
	--------------------------------------------------------------------------------

	hooksecurefunc("QuestLog_Update", UpdateList)

	-- QuestLog_SetSelection() highlights the row at the selected entry's own place in the list
	hooksecurefunc("QuestLog_SetSelection", function()
		if currentOrder then
			ns.PlaceClassicSelectionHighlight(currentOrder)
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
		ns.ResetClassicZoneOrder()
		currentOrder = nil
	end
end)
