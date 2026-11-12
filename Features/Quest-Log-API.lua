local _, ns = ...

--------------------------------------------------------------------------------
-- Quest Log
--------------------------------------------------------------------------------

--[[
	The quest log read and acted on by quest ID, as WoW Forever's quest log calls do (C_QuestLog.GetInfo
	and the rest), on every client. Classic Era, TBC and Mists have only the older calls by quest log
	index, and those that act on a quest act on the selected one, so here each selects the quest it acts
	on and puts the player's selection back. The window on WoW Forever and Mists reads the log through
	these (Forever-Quest-Log.lua, Forever-Quest-List.lua)
]]
if C_QuestLog.GetInfo then
	function ns.GetNumQuestLogEntries()
		return (C_QuestLog.GetNumQuestLogEntries())
	end

	--[[
		Which zones the window shows collapsed, by zone name, for the session, kept here and never in the game's
		quest log, whose own zones are left as they are. ExpandQuestHeader and CollapseQuestHeader fire
		QUEST_LOG_UPDATE inside the call (Blizzard's quest log sets ignoreQuestLogUpdate around them for that
		reason), so called from add-on code they'd taint every objective tracker module's next update (GitHub
		#23). And Blizzard's map collapses the zones away from the map it shows whenever it refreshes
	]]
	local collapsedZones = {}

	-- One entry (a zone header or a quest), as C_QuestLog.GetInfo describes it; isCollapsed is the window's
	function ns.GetQuestLogEntry(index)
		local entry = C_QuestLog.GetInfo(index)
		if entry and entry.isHeader then
			entry.isCollapsed = collapsedZones[entry.title] and true or false
		end
		return entry
	end

	function ns.SetQuestZoneCollapsed(index, collapsed)
		local entry = C_QuestLog.GetInfo(index)
		if entry and entry.isHeader and entry.title then
			collapsedZones[entry.title] = collapsed or nil
		end
	end

	-- Every quest is listed whether its zone is collapsed or not
	function ns.ShowEveryQuestLogEntry() end

	function ns.GetLogIndexForQuestID(questID)
		return C_QuestLog.GetLogIndexForQuestID(questID)
	end

	function ns.GetHeaderIndexForQuest(questID)
		return C_QuestLog.GetHeaderIndexForQuest(questID)
	end

	ns.IsQuestComplete = C_QuestLog.IsComplete
	ns.IsQuestFailed = C_QuestLog.IsFailed
	ns.IsQuestDisabledForSession = C_QuestLog.IsQuestDisabledForSession
	ns.GetSelectedQuestID = C_QuestLog.GetSelectedQuest

	--[[
		Selects only when the selection differs. Every details repaint selects the quest it shows, and a
		selection made from add-on code can mark Blizzard's objective tracker dirty, leaving its next
		update tainted (README-Technical, Taint)
	]]
	function ns.SelectQuest(questID)
		if C_QuestLog.GetSelectedQuest() ~= questID then
			ns.TrackerTaintStep("SetSelectedQuest", C_QuestLog.SetSelectedQuest, questID)
		end
	end

	ns.IsPushableQuest = C_QuestLog.IsPushableQuest
	ns.CanAbandonQuest = C_QuestLog.CanAbandonQuest

	-- Sharing a quest, held until combat ends while in combat: ns.ShareQuest in Share-Needs.lua

	-- Asks whether to abandon the quest, as the game's own Abandon button does
	function ns.AskToAbandonQuest(questID)
		ns.TrackerTaintStep("QuestMapQuestOptions_AbandonQuest", QuestMapQuestOptions_AbandonQuest, questID)
	end
else
	--[[
		A collapsed zone lists none of its quests here, which would leave it out of the window's list
		altogether. So the window keeps Blizzard's zones open (ns.ShowEveryQuestLogEntry) and remembers which
		it shows collapsed itself, by zone name, for the session
	]]
	local collapsedZones = {}

	function ns.GetNumQuestLogEntries()
		return (GetNumQuestLogEntries())
	end

	--[[
		One entry (a zone header or a quest) with the fields of C_QuestLog.GetInfo the window reads, plus
		isComplete and isFailed. isCollapsed is whether the window shows the zone collapsed
	]]
	function ns.GetQuestLogEntry(index)
		local title, level, _, isHeader, _, isComplete, frequency, questID, _, _, _, _, isTask, isBounty, _, isHidden, isScaling =
			GetQuestLogTitle(index)
		if not title then
			return nil
		end
		return {
			title = title,
			level = level,
			questID = questID,
			questLogIndex = index,
			isHeader = isHeader and true or false,
			isCollapsed = (isHeader and collapsedZones[title]) and true or false,
			frequency = frequency,
			isTask = isTask,
			isBounty = isBounty,
			isHidden = isHidden,
			isScaling = isScaling,
			isComplete = (isComplete or 0) > 0,
			isFailed = (isComplete or 0) < 0,
		}
	end

	function ns.SetQuestZoneCollapsed(index, collapsed)
		local title, _, _, isHeader = GetQuestLogTitle(index)
		if title and isHeader then
			collapsedZones[title] = collapsed or nil
		end
	end

	-- Opens any of Blizzard's zones that are collapsed, so every quest is listed
	function ns.ShowEveryQuestLogEntry()
		for index = 1, GetNumQuestLogEntries() do
			local _, _, _, isHeader, isCollapsed = GetQuestLogTitle(index)
			if isHeader and isCollapsed then
				ExpandQuestHeader(0)
				return
			end
		end
	end

	function ns.GetLogIndexForQuestID(questID)
		for index = 1, GetNumQuestLogEntries() do
			local _, _, _, isHeader, _, _, _, entryID = GetQuestLogTitle(index)
			if not isHeader and entryID == questID then
				return index
			end
		end
	end

	function ns.GetHeaderIndexForQuest(questID)
		for index = ns.GetLogIndexForQuestID(questID) or 0, 1, -1 do
			if select(4, GetQuestLogTitle(index)) then
				return index
			end
		end
	end

	local function QuestEntry(questID)
		local index = ns.GetLogIndexForQuestID(questID)
		return index and ns.GetQuestLogEntry(index)
	end

	function ns.IsQuestComplete(questID)
		local entry = QuestEntry(questID)
		return entry and entry.isComplete or false
	end

	function ns.IsQuestFailed(questID)
		local entry = QuestEntry(questID)
		return entry and entry.isFailed or false
	end

	-- Only WoW Forever turns off quests for a session
	function ns.IsQuestDisabledForSession()
		return false
	end

	function ns.GetSelectedQuestID()
		local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(GetQuestLogSelection())
		if title and not isHeader then
			return questID
		end
	end

	function ns.SelectQuest(questID)
		local index = ns.GetLogIndexForQuestID(questID)
		if index then
			SelectQuestLogEntry(index)
		end
	end

	-- Runs work with the quest selected, then selects what was selected before; returns what work returns
	local function WithQuestSelected(questID, work)
		local index = ns.GetLogIndexForQuestID(questID)
		if not index then
			return nil
		end
		local selected = GetQuestLogSelection()
		SelectQuestLogEntry(index)
		local result = work()
		SelectQuestLogEntry(selected)
		return result
	end

	function ns.IsPushableQuest(questID)
		return WithQuestSelected(questID, function()
			return GetQuestLogPushable() and true or false
		end) or false
	end

	function ns.CanAbandonQuest(questID)
		if CanAbandonQuest then
			return CanAbandonQuest(questID) and true or false
		end
		return ns.GetLogIndexForQuestID(questID) ~= nil
	end

	function ns.ShareQuest(questID)
		WithQuestSelected(questID, QuestLogPushQuest)
	end

	-- Asks whether to abandon the quest, as the game's own Abandon button does
	function ns.AskToAbandonQuest(questID)
		WithQuestSelected(questID, function()
			SetAbandonQuest()
			local items = GetAbandonQuestItems()
			if items then
				StaticPopup_Hide("ABANDON_QUEST")
				StaticPopup_Show("ABANDON_QUEST_WITH_ITEMS", GetAbandonQuestName(), items)
			else
				StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")
				StaticPopup_Show("ABANDON_QUEST", GetAbandonQuestName())
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- Quest Tags
--------------------------------------------------------------------------------

--[[
	A quest's tag (Enum.QuestTag), whether it's elite, and the tag's name ("Dungeon"), by quest ID, whether
	or not it's in the quest log
]]
if C_QuestLog.GetQuestTagInfo then
	function ns.GetQuestTagByID(questID)
		local tagDetails = C_QuestLog.GetQuestTagInfo(questID)
		local isElite = (tagDetails and tagDetails.isElite) or C_QuestLog.IsEliteQuest(questID)
		return tagDetails and tagDetails.tagID, isElite and true or false, tagDetails and tagDetails.tagName
	end
else
	function ns.GetQuestTagByID(questID)
		if not GetQuestTagInfo then
			return nil, false
		end
		-- No elite flag here: the tag ID decides the letter (ns.QUEST_TAG_SUFFIXES), never the tag's name
		local tagID, tagName = GetQuestTagInfo(questID)
		return tagID, false, tagName
	end
end

-- A quest's title by quest ID, whether or not it's in the quest log; nil until the client has loaded it
if C_QuestLog.GetTitleForQuestID then
	function ns.GetQuestTitleByID(questID)
		return C_QuestLog.GetTitleForQuestID(questID)
	end
else
	function ns.GetQuestTitleByID(questID)
		return C_QuestLog.GetQuestInfo and C_QuestLog.GetQuestInfo(questID)
	end
end

--[[
	Whether a party unit has a quest in its log, by quest ID; nil when the client can't tell. A caller that
	knows the quest's log index passes it, so a client without C_QuestLog.IsUnitOnQuest needn't search the log
]]
if C_QuestLog.IsUnitOnQuest then
	function ns.IsUnitOnQuest(unit, questID)
		return C_QuestLog.IsUnitOnQuest(unit, questID)
	end
else
	function ns.IsUnitOnQuest(unit, questID, questLogIndex)
		local index = IsUnitOnQuest and (questLogIndex or ns.GetLogIndexForQuestID(questID))
		return index and IsUnitOnQuest(index, unit)
	end
end

-- Whether a quest log frequency is a daily quest's. TBC tags daily quests; Classic Era has none, nor the constant
local DAILY_FREQUENCY = LE_QUEST_FREQUENCY_DAILY
function ns.IsDailyFrequency(frequency)
	return DAILY_FREQUENCY ~= nil and frequency == DAILY_FREQUENCY
end
