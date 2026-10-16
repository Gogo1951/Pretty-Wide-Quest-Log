local _, ns = ...

-- WoW Forever: the quest log calls behind the zone menu (Zone-Menu.lua), by quest ID.

local state = ns.questLog

--------------------------------------------------------------------------------
-- Finding Quests
--------------------------------------------------------------------------------

-- The quest selected in Blizzard's quest log, as its quest ID and title; nothing while none is selected
function ns.SelectedQuest()
	local questID = C_QuestLog.GetSelectedQuest()
	return questID, questID and C_QuestLog.GetTitleForQuestID(questID)
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

--[[
	Gray as the quest list draws it (Forever-Quest-List.lua): the server's rating for the player, or the
	quest's level when the server gives none
]]
local function IsGray(entry)
	local difficulty = not C_QuestLog.IsQuestDisabledForSession(entry.questID)
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer(entry.questID)
	if difficulty and GetDifficultyColor then
		return difficulty == Enum.RelativeContentDifficulty.Trivial
	end
	return GetQuestDifficultyColor(entry.difficultyLevel or entry.level, entry.isScaling, entry.questID)
		== QuestDifficultyColors.trivial
end

--[[
	The quests in a zone the list draws gray, as { questID, title, level, suffix }, with the level and
	letter the list tags them with (Forever-Quest-List.lua); the quest log lists a collapsed zone's quests too
]]
function ns.GrayQuests(zoneTitle)
	local quests, inZone = {}, false
	for index = 1, C_QuestLog.GetNumQuestLogEntries() do
		local entry = C_QuestLog.GetInfo(index)
		if entry and entry.isHeader then
			inZone = entry.title == zoneTitle
		elseif entry and inZone and not entry.isHidden and not entry.isTask and IsGray(entry) then
			local questID = entry.questID
			local tagDetails = C_QuestLog.GetQuestTagInfo(questID)
			local elite = C_QuestLog.IsEliteQuest(questID) or (tagDetails and tagDetails.isElite)
			quests[#quests + 1] = {
				questID = questID,
				title = entry.title,
				level = entry.difficultyLevel or entry.level,
				suffix = ns.QuestSuffix(tagDetails and tagDetails.tagID, elite),
			}
		end
	end
	return quests
end

--------------------------------------------------------------------------------
-- Acting on Quests
--------------------------------------------------------------------------------

--[[
	The share and abandon calls act on Blizzard's selected quest, so each quest is selected in turn and
	the quest the details show is selected again afterwards
]]
local function RestoreSelection()
	if state.selectedQuestID then
		C_QuestLog.SetSelectedQuest(state.selectedQuestID)
	end
	ns.RequestUpdate()
end

-- Abandons each quest still in the log that the game lets you abandon; returns how many
function ns.AbandonQuests(questIDs)
	local count = 0
	for _, questID in ipairs(questIDs) do
		if C_QuestLog.GetLogIndexForQuestID(questID) and C_QuestLog.CanAbandonQuest(questID) then
			C_QuestLog.SetSelectedQuest(questID)
			C_QuestLog.SetAbandonQuest()
			C_QuestLog.AbandonQuest()
			count = count + 1
		end
	end
	RestoreSelection()
	return count
end

--[[
	Shares each quest, ns.GetShareInterval() apart as it was when the run began; the game reports each
	result in chat. ns.sharingQuests is set until the last one goes, so a second run can't start alongside
]]
function ns.ShareQuests(questIDs)
	ns.sharingQuests = true
	local interval = ns.GetShareInterval()
	local function Share(position)
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
