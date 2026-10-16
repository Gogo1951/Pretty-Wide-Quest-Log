local _, ns = ...

ns.AddWideQuestLogPart(function()
	-- Classic Era and TBC: the quest list's sorted order, and Blizzard's rows redrawn to show it.

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
		local completedFirst = ns.db.profile.completedFirst

		local loose, zones, zone = {}, {}, nil
		for index = 1, GetNumQuestLogEntries() do
			local title, level, _, isHeader, _, isComplete = GetQuestLogTitle(index)
			if isHeader then
				zone = { title = title, sortIndex = index, sortKey = ns.NameSortKey(title), quests = {} }
				zones[#zones + 1] = zone
			else
				local quest = {
					sortIndex = index,
					sortLevel = level or 0,
					sortKey = ns.NameSortKey(title),
					isComplete = (isComplete or 0) > 0, -- Failed quests are -1
				}
				if zone then
					zone.quests[#zone.quests + 1] = quest
				else
					loose[#loose + 1] = quest
				end
			end
		end

		ns.SortQuests(loose, questSort, completedFirst)
		for _, each in ipairs(zones) do
			each.averageLevel = ns.AverageLevel(each.quests)
			if each.averageLevel then
				knownZoneLevels[each.title or ""] = each.averageLevel
			else
				each.averageLevel = knownZoneLevels[each.title or ""]
			end
			ns.SortQuests(each.quests, questSort, completedFirst)
		end
		zoneOrder = ns.SortZones(zones, zoneSort, ns.db.profile.currentZoneFirst, zoneOrder)

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
		elseif ns.IsDailyFrequency(frequency) then
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

	-- For the quest list (Classic-Quest-List.lua)
	ns.BuildClassicDisplayOrder = BuildDisplayOrder
	ns.ClassicEntryAt = EntryAt
	ns.RedrawClassicRows = RedrawRows
	ns.PlaceClassicSelectionHighlight = PlaceSelectionHighlight

	function ns.ResetClassicZoneOrder()
		zoneOrder = nil
	end
end)
