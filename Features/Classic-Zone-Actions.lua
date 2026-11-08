local _, ns = ...

-- Classic Era, TBC and Mists: the quest log calls behind Share Quests (Zone-Share.lua) and the dungeon quests, by quest ID.

--------------------------------------------------------------------------------
-- Finding Quests
--------------------------------------------------------------------------------

-- The quest selected in Blizzard's quest log, as its quest ID and title; nothing while a zone or nothing is selected
local function SelectedQuest()
	local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(GetQuestLogSelection())
	if title and not isHeader then
		return questID, title
	end
end

-- The quest a share goes out for: the log entry QuestLogPushQuest is given, or the selected quest when it's given none
function ns.SharedQuest(questLogIndex)
	if not questLogIndex then
		return SelectedQuest()
	end
	local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(questLogIndex)
	if title and not isHeader then
		return questID, title
	end
end

-- A zone header's quest log index and whether it's collapsed, or nil when the zone isn't in the log
local function FindZoneHeader(zoneTitle)
	for index = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader, isCollapsed = GetQuestLogTitle(index)
		if isHeader and title == zoneTitle then
			return index, isCollapsed
		end
	end
end

--[[
	The quests in a zone the game lets you share, as quest IDs, and how many quests the zone holds. Only
	the selected quest can be asked about, so each is selected in turn and the player's selection put back.
	The quest log lists no quests under a collapsed zone, so the zone is opened to look and closed again.
	Closing it puts every entry back where it was, so the selection is put back by its index, a zone
	header or nothing selected included, as WithQuestSelected in Quest-Log-API.lua does
]]
function ns.ShareableZoneQuests(zoneTitle)
	local headerIndex, collapsed = FindZoneHeader(zoneTitle)
	if not headerIndex then
		return {}, 0
	end
	local selected = GetQuestLogSelection()
	if collapsed then
		ExpandQuestHeader(headerIndex)
	end

	local questIDs, total = {}, 0
	for index = headerIndex + 1, GetNumQuestLogEntries() do
		local _, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(index)
		if isHeader then
			break
		end
		total = total + 1
		SelectQuestLogEntry(index)
		if questID and GetQuestLogPushable() then
			questIDs[#questIDs + 1] = questID
		end
	end

	if collapsed then
		CollapseQuestHeader(headerIndex)
	end
	SelectQuestLogEntry(selected)
	return questIDs, total
end

--[[
	Runs work with every zone open, as the quest log lists no quests under a collapsed one, then closes
	the zones that were closed (from the bottom up, so the indexes above hold) and puts the player's
	selection back by its index, as every entry is back where it was. Returns what work returns
]]
local function WithEveryZoneOpen(work)
	local selected = GetQuestLogSelection()
	local closed = {}
	for index = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader, isCollapsed = GetQuestLogTitle(index)
		if isHeader and isCollapsed then
			closed[title or ""] = true
		end
	end
	if next(closed) then
		ExpandQuestHeader(0)
	end

	local result = work()

	if next(closed) then
		for index = GetNumQuestLogEntries(), 1, -1 do
			local title, _, _, isHeader = GetQuestLogTitle(index)
			if isHeader and closed[title or ""] then
				CollapseQuestHeader(index)
			end
		end
	end
	SelectQuestLogEntry(selected)
	return result
end

--[[
	Every quest in the log, wherever its zone, as { questID, title, zoneTitle, isComplete, isFailed,
	pushable }, pushable being whether the game lets you share it
]]
function ns.LogQuests()
	return WithEveryZoneOpen(function()
		local quests, zoneTitle = {}, nil
		for index = 1, GetNumQuestLogEntries() do
			local title, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(index)
			if isHeader then
				zoneTitle = title
			elseif questID then
				SelectQuestLogEntry(index)
				quests[#quests + 1] = {
					questID = questID,
					title = title,
					zoneTitle = zoneTitle,
					isComplete = (isComplete or 0) > 0,
					isFailed = (isComplete or 0) < 0,
					pushable = GetQuestLogPushable() and true or false,
				}
			end
		end
		return quests
	end)
end

--------------------------------------------------------------------------------
-- Acting on Quests
--------------------------------------------------------------------------------

--[[
	The share call acts on the selected quest, so each quest is selected in turn, with every zone open
	so it can be found, and the player's own selection is put back afterwards.

	Shares each quest still in the log, wherever its zone is, ns.GetShareInterval() apart as it was when
	the run began; the game reports each result in chat. ns.sharingQuests is set until the last one goes,
	so a second run can't start alongside; each share runs through securecall, so one that errors is
	reported and the run still reaches its end. A share due in combat waits, checking every interval,
	until combat ends, and the run picks up where it stopped. Leaving the group ends the run
]]
local function ShareOne(questID)
	WithEveryZoneOpen(function()
		local index = questID and ns.GetLogIndexForQuestID(questID)
		if index then
			SelectQuestLogEntry(index)
			if GetQuestLogPushable() then
				QuestLogPushQuest()
			end
		end
	end)
	if QuestLogFrame:IsShown() then
		QuestLog_Update()
	end
end

function ns.ShareQuests(questIDs)
	ns.sharingQuests = true
	local interval = ns.GetShareInterval()
	local function Share(position)
		if not IsInGroup() then
			ns.sharingQuests = nil
			return
		end
		if InCombatLockdown() then
			C_Timer.After(interval, function()
				Share(position)
			end)
			return
		end
		securecall(ShareOne, questIDs[position])
		if position < #questIDs then
			C_Timer.After(interval, function()
				Share(position + 1)
			end)
		else
			ns.sharingQuests = nil
		end
	end
	Share(1)
end
