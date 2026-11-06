local _, ns = ...

-- WoW Forever: the quest log calls behind Share Quests (Zone-Share.lua) and the dungeon quests, by quest ID.

local state = ns.questLog

--------------------------------------------------------------------------------
-- Finding Quests
--------------------------------------------------------------------------------

-- The quest selected in Blizzard's quest log, as its quest ID and title; nothing while none is selected
local function SelectedQuest()
	local questID = C_QuestLog.GetSelectedQuest()
	return questID, questID and C_QuestLog.GetTitleForQuestID(questID)
end

-- The quest a share goes out for: the log entry QuestLogPushQuest is given, or the selected quest when it's given none
function ns.SharedQuest(questLogIndex)
	if not questLogIndex then
		return SelectedQuest()
	end
	local entry = C_QuestLog.GetInfo(questLogIndex)
	if entry and not entry.isHeader and entry.questID then
		return entry.questID, C_QuestLog.GetTitleForQuestID(entry.questID)
	end
end

--[[
	The quests in a zone the game lets you share, as quest IDs, and how many quests the zone holds. The
	quest log lists a collapsed zone's quests too, so the zone stays as it is
]]
function ns.ShareableZoneQuests(zoneTitle)
	local questIDs, total, inZone = {}, 0, false
	for index = 1, C_QuestLog.GetNumQuestLogEntries() do
		local entry = C_QuestLog.GetInfo(index)
		if entry and entry.isHeader then
			inZone = entry.title == zoneTitle
		elseif entry and inZone and not entry.isHidden and not entry.isTask then
			total = total + 1
			if C_QuestLog.IsPushableQuest(entry.questID) then
				questIDs[#questIDs + 1] = entry.questID
			end
		end
	end
	return questIDs, total
end

--[[
	Every quest in the log, as { questID, title, zoneTitle, isComplete, isFailed, pushable }, pushable
	being whether the game lets you share it
]]
function ns.LogQuests()
	local quests, zoneTitle = {}, nil
	for index = 1, C_QuestLog.GetNumQuestLogEntries() do
		local entry = C_QuestLog.GetInfo(index)
		if entry and entry.isHeader then
			zoneTitle = entry.title
		elseif entry and not entry.isHidden and not entry.isTask then
			local questID = entry.questID
			quests[#quests + 1] = {
				questID = questID,
				title = entry.title,
				zoneTitle = zoneTitle,
				isComplete = C_QuestLog.IsComplete(questID) and true or false,
				isFailed = C_QuestLog.IsFailed(questID) and true or false,
				pushable = C_QuestLog.IsPushableQuest(questID) and true or false,
			}
		end
	end
	return quests
end

--------------------------------------------------------------------------------
-- Acting on Quests
--------------------------------------------------------------------------------

--[[
	The share call acts on Blizzard's selected quest, so each quest is selected in turn and
	the quest the details show is selected again afterwards
]]
local function RestoreSelection()
	if state.selectedQuestID then
		C_QuestLog.SetSelectedQuest(state.selectedQuestID)
	end
	ns.RequestUpdate()
end

--[[
	Shares each quest, ns.GetShareInterval() apart as it was when the run began; the game reports each
	result in chat. ns.sharingQuests is set until the last one goes, so a second run can't start alongside.
	WoW Forever blocks QuestLogPushQuest in combat, so a share due then waits, checking every interval,
	until combat ends; the run picks up where it stopped
]]
function ns.ShareQuests(questIDs)
	ns.sharingQuests = true
	local interval = ns.GetShareInterval()
	local function Share(position)
		if InCombatLockdown() then
			C_Timer.After(interval, function()
				Share(position)
			end)
			return
		end
		local questID = questIDs[position]
		if questID and C_QuestLog.GetLogIndexForQuestID(questID) and C_QuestLog.IsPushableQuest(questID) then
			C_QuestLog.SetSelectedQuest(questID)
			QuestLogPushQuest()
			RestoreSelection()
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
