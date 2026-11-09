local _, ns = ...

--[[
	Classic Era and TBC: the quest list's rows (Classic-Quest-List.lua), how many there are and where each
	goes, padded and with a gap above each zone. Made when the list's part builds, as Blizzard's rows are
	only measured then
]]

--[[
	The rows for the quest list, hookRow run on each one made here. Returns ShowRowCount, RowsThatFit and
	PositionRows for the list's update; the window's height sets the rows it holds (ns.SetQuestRowCount)
]]
function ns.CreateClassicQuestRows(hookRow)
	local LAYOUT = ns.LAYOUT

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
		QuestLog_Update() only fills rows up to QUESTS_DISPLAYED, so rows a taller window created and a
		shorter list no longer needs have to be hidden here or they keep drawing past the bottom edge.
		Returns whether the number of rows changed
	]]
	local createdRows = QUESTS_DISPLAYED
	local function ShowRowCount(count)
		if count == QUESTS_DISPLAYED then
			return false
		end
		for i = createdRows + 1, count do
			local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate")
			button:SetID(i)
			hookRow(button)
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

	--[[
		The rows the window's height holds, from Classic-Quest-Log.lua. The list shows fewer when the padding
		and gaps at its end take more room (RowsThatFit). Returns whether the number changed
	]]
	local rowCapacity = QUESTS_DISPLAYED
	local function SetQuestRowCount(count)
		if count == rowCapacity then
			return false
		end
		rowCapacity = count
		ShowRowCount(count)
		return true
	end

	--------------------------------------------------------------------------------
	-- Row Spacing
	--------------------------------------------------------------------------------

	local function ZoneGap()
		return (ns.db and ns.db.profile.zoneGap) and LAYOUT.HEADER_GAP or 0
	end

	--[[
		Where each of count rows' frames goes (QUESTS_DISPLAYED when not given), from the top of the first
		row's, with the list scrolled to offset: each row in its padded slot, and with zoneGap on, a gap above
		every zone but the one in the first row
	]]
	local function RowTops(order, offset, count)
		local gap = ZoneGap()
		local entryCount = GetNumQuestLogEntries()
		local tops, slotTop, firstInset = {}, 0, 0
		for i = 1, count or QUESTS_DISPLAYED do
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
		How many rows the list shows: as many as fit with it scrolled to the end, padding and gaps included, so
		Blizzard's own scroll range (entries less QUESTS_DISPLAYED) reaches the last entry. QuestLog_Update()
		sets that range again on every update, so a wider one made here would be lost, scrolling the list
		back up. Higher up the list, where fewer gaps are in view, this can leave room at the bottom
	]]
	local function RowsThatFit(order)
		local entryCount = GetNumQuestLogEntries()
		local paneHeight = QuestLogListScrollFrame:GetHeight()
		local count = rowCapacity
		while count > 1 do
			local offset = math.max(0, entryCount - count)
			local last = math.min(count, entryCount - offset)
			if last == 0 or RowTops(order, offset, count)[last] + frameHeight <= paneHeight then
				break
			end
			count = count - 1
		end
		return count
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

	function ns.GetQuestRowHeight()
		return questPitch
	end

	ns.SetQuestRowCount = SetQuestRowCount

	return { ShowRowCount = ShowRowCount, RowsThatFit = RowsThatFit, PositionRows = PositionRows }
end
