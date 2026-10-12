local _, ns = ...

-- Classic Era and TBC: the quest log calls behind the zone menu (Zone-Menu.lua), by quest ID.

--------------------------------------------------------------------------------
-- Finding Quests
--------------------------------------------------------------------------------

local function IndexForQuestID(questID)
	for index = 1, GetNumQuestLogEntries() do
		local _, _, _, isHeader, _, _, _, entryID = GetQuestLogTitle(index)
		if not isHeader and entryID == questID then
			return index
		end
	end
end

local function SelectedQuestID()
	return select(8, GetQuestLogTitle(GetQuestLogSelection()))
end

local function SelectQuest(questID)
	local index = questID and IndexForQuestID(questID)
	if index then
		SelectQuestLogEntry(index)
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
	The quest log lists no quests under a collapsed zone, so the zone is opened to look and closed again
]]
function ns.ShareableZoneQuests(zoneTitle)
	local headerIndex, collapsed = FindZoneHeader(zoneTitle)
	if not headerIndex then
		return {}, 0
	end
	local selectedID = SelectedQuestID()
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
	SelectQuest(selectedID)
	return questIDs, total
end

--[[
	Runs work with every zone open, as the quest log lists no quests under a collapsed one, then closes
	the zones that were closed (from the bottom up, so the indexes above hold) and puts the player's
	selection back. Returns what work returns
]]
local function WithEveryZoneOpen(work)
	local selectedID = SelectedQuestID()
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
	SelectQuest(selectedID)
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

--[[
	The quests in a zone the list draws gray (GetQuestDifficultyColor, as Classic-Quest-List.lua colors
	rows), as { questID, title, level, suffix }, suffix being the letter after the level ("D"). A
	collapsed zone is opened to look and closed again, and the player's selection put back
]]
function ns.GrayQuests(zoneTitle)
	local headerIndex, collapsed = FindZoneHeader(zoneTitle)
	if not headerIndex then
		return {}
	end
	local selectedID = SelectedQuestID()
	if collapsed then
		ExpandQuestHeader(headerIndex)
	end

	local quests = {}
	for index = headerIndex + 1, GetNumQuestLogEntries() do
		local title, level, _, isHeader, _, _, _, questID = GetQuestLogTitle(index)
		if isHeader then
			break
		end
		if questID and GetQuestDifficultyColor(level) == QuestDifficultyColors.trivial then
			quests[#quests + 1] = {
				questID = questID,
				title = title,
				level = level,
				suffix = ns.QuestSuffix(ns.GetQuestTagByID(questID)),
			}
		end
	end

	if collapsed then
		CollapseQuestHeader(headerIndex)
	end
	SelectQuest(selectedID)
	return quests
end

--------------------------------------------------------------------------------
-- Acting on Quests
--------------------------------------------------------------------------------

--[[
	The share and abandon calls act on the selected quest, so each quest is selected in turn, with every
	zone open so it can be found, and the player's own selection is put back afterwards.

	Abandons each quest still in the log, wherever its zone is; returns how many
]]
function ns.AbandonQuests(questIDs)
	local count = WithEveryZoneOpen(function()
		local abandoned = 0
		for _, questID in ipairs(questIDs) do
			local index = IndexForQuestID(questID)
			if index then
				SelectQuestLogEntry(index)
				SetAbandonQuest()
				AbandonQuest()
				abandoned = abandoned + 1
			end
		end
		return abandoned
	end)
	if QuestLogFrame:IsShown() then
		QuestLog_Update()
	end
	return count
end

--[[
	Shares each quest still in the log, wherever its zone is, ns.GetShareInterval() apart as it was when
	the run began; the game reports each result in chat. ns.sharingQuests is set until the last one goes,
	so a second run can't start alongside
]]
function ns.ShareQuests(questIDs)
	ns.sharingQuests = true
	local interval = ns.GetShareInterval()
	local function Share(position)
		local questID = questIDs[position]
		WithEveryZoneOpen(function()
			local index = questID and IndexForQuestID(questID)
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
