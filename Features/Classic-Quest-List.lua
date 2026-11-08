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

	local frameHeight = (QuestLogTitle1 and QuestLogTitle1:GetHeight() or 0)
	if frameHeight < 8 then
		frameHeight = QUESTLOG_QUEST_HEIGHT
	end

	--[[
		Each row sits in a slot of its own, padded as the WoW Forever list's rows are: a quest's
		LAYOUT.QUEST_ROW_HEIGHT and a zone header's LAYOUT.HEADER_ROW_HEIGHT, with the row's frame centered
		in it. A quest's slot is the list's row step, which the window's height snaps to and counts rows by
	]]
	local questPitch = frameHeight + LAYOUT.QUEST_ROW_HEIGHT - LAYOUT.ROW_HEIGHT
	local headerPitch = frameHeight + LAYOUT.HEADER_ROW_HEIGHT - LAYOUT.ROW_HEIGHT

	--[[
		A zone name shows its Share Quests button on hover (Zone-Share.lua). The row's ID points at its
		entry (RedrawRow)
	]]
	local function ZoneTitleAt(row)
		local title, _, _, isHeader = GetQuestLogTitle(row:GetID() + FauxScrollFrame_GetOffset(QuestLogListScrollFrame))
		return isHeader and title or nil
	end

	local function OnRowEnter(row)
		local zoneTitle = ZoneTitleAt(row)
		if zoneTitle then
			ns.ShowZoneShareButton(row, zoneTitle)
		end
	end

	local function OnRowLeave(row)
		ns.HideZoneShareButton(row)
	end

	local function HookRow(row)
		row:HookScript("OnEnter", OnRowEnter)
		row:HookScript("OnLeave", OnRowLeave)
	end

	for i = 1, QUESTS_DISPLAYED do
		HookRow(_G["QuestLogTitle" .. i])
	end

	--[[
		Blizzard puts a shift-clicked quest into the chat box as the row's text, which now leads with its level
		tag, so the plain title takes its place. Questie inserts its own quest link instead
	]]
	hooksecurefunc("QuestLogTitleButton_OnClick", function(row)
		local editBox = row.plainTitle and IsModifiedClick("CHATLINK") and ChatFrameUtil.GetActiveWindow()
		if not editBox or C_AddOns.IsAddOnLoaded(ns.QUESTIE_ADDON_NAME) then
			return
		end
		local inserted = (row:GetText() or ""):gsub("^ *", "")
		local text, last = editBox:GetText(), nil
		local from = text:find(inserted, 1, true)
		while from do
			last = from
			from = text:find(inserted, from + 1, true)
		end
		if last and inserted ~= row.plainTitle then
			editBox:SetText(text:sub(1, last - 1) .. row.plainTitle .. text:sub(last + #inserted))
		end
	end)

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
			button:SetPoint("TOPLEFT", QuestLogTitle1, "TOPLEFT", 0, -(i - 1) * questPitch)
		end
		createdRows = math.max(createdRows, count)
		for i = count + 1, createdRows do
			_G["QuestLogTitle" .. i]:Hide()
		end
		QUESTS_DISPLAYED = count
		return true
	end

	local function GetQuestSuffix(questID)
		return questID and ns.QuestSuffix((ns.GetQuestTagByID(questID)))
	end

	--------------------------------------------------------------------------------
	-- Row Spacing
	--------------------------------------------------------------------------------

	local function ZoneGap()
		return (ns.db and ns.db.profile.zoneGap) and LAYOUT.HEADER_GAP or 0
	end

	--[[
		Where each row's frame goes, from the top of the first row's, with the list scrolled to offset: each
		row in its padded slot, and with zoneGap on, a gap above every zone but the one in the first row
	]]
	local function RowTops(order, offset)
		local gap = ZoneGap()
		local entryCount = GetNumQuestLogEntries()
		local tops, slotTop, firstInset = {}, 0, 0
		for i = 1, QUESTS_DISPLAYED do
			local position = offset + i
			local isHeader = position <= entryCount and select(4, GetQuestLogTitle(ns.ClassicEntryAt(order, position)))
			if isHeader and i > 1 then
				slotTop = slotTop + gap
			end
			local pitch = isHeader and headerPitch or questPitch
			local inset = (pitch - frameHeight) / 2
			if i == 1 then
				firstInset = inset
			end
			tops[i] = slotTop + inset - firstInset
			slotTop = slotTop + pitch
		end
		return tops
	end

	--[[
		The padding and gaps push rows past the bottom, so the scroll range is extended until the last
		entry can be scrolled fully into view. Extending the range can scroll the list, which runs
		QuestLog_Update() again
	]]
	local extendingScroll
	local function ExtendScrollRange(order)
		if extendingScroll then
			return
		end
		local entryCount = GetNumQuestLogEntries()
		local paneHeight = QuestLogListScrollFrame:GetHeight()
		local offset = math.max(0, entryCount - QUESTS_DISPLAYED)
		while offset < entryCount - 1 do
			local last = entryCount - offset
			if last <= QUESTS_DISPLAYED and RowTops(order, offset)[last] + frameHeight <= paneHeight then
				break
			end
			offset = offset + 1
		end
		local total = offset + QUESTS_DISPLAYED
		if total > entryCount and total > QUESTS_DISPLAYED then
			extendingScroll = true
			FauxScrollFrame_Update(
				QuestLogListScrollFrame,
				total,
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
		The padding and gaps (RowTops), made by moving Blizzard's own rows rather than replacing them. Rows
		pushed past the bottom are hidden
	]]
	local function PositionRows(order)
		local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
		local paneHeight = QuestLogListScrollFrame:GetHeight()
		local tops = RowTops(order, offset)
		for i = 2, QUESTS_DISPLAYED do
			local row = _G["QuestLogTitle" .. i]
			local top = tops[i]
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", QuestLogTitle1, "TOPLEFT", 0, -top)
			if top + frameHeight > paneHeight then
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
		local voiceOverOn = ns.GetVoiceOver() ~= nil
		for i = 1, math.min(QUESTS_DISPLAYED, entryCount - offset) do
			local row, index = _G["QuestLogTitle" .. i], ns.ClassicEntryAt(order, offset + i)
			local text, check = row.Text, _G["QuestLogTitle" .. i .. "Check"]
			local title, level, _, isHeader, _, _, _, questID = GetQuestLogTitle(index)

			ns.UpdateZoneShareButton(row, isHeader and title)
			row.plainTitle = not isHeader and title or nil
			if isHeader then
				row:SetText(ns.ZoneHeaderText(title or ""))
				text:SetPoint("LEFT", row, "LEFT", LAYOUT.HEADER_TEXT_X, 0)
				check:Hide()
			else
				local label = ns.QuestListTitle(level, title, GetQuestSuffix(questID))
				row:SetText(ns.VoiceOverTitlePrefix(text, voiceOverOn) .. label)
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
				local tagWidth = (tag and tag:IsShown() and (tag:GetText() or "") ~= "")
						and (tag:GetStringWidth() + LAYOUT.SPACE.NEAR)
					or LAYOUT.SPACE.TIGHT
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
		-- The map's part builds after this one, and a client whose TOC lists no map has none (Quest-Map.lua)
		if ns.questMap then
			ns.questMap.SetLogEmpty(GetNumQuestLogEntries() == 0)
		end
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
		return questPitch
	end

	ns.SetQuestRowCount = SetQuestRowCount
	ns.UpdateClassicQuestList = UpdateList

	-- Zones sort afresh on the next update rather than keeping the order the window opened with
	function ns.ResetZoneOrder()
		ns.ResetClassicZoneOrder()
		currentOrder = nil
	end
end)
