local _, ns = ...

--[[
	Routes: what the route reads from Questie and the client. Questie's quest log and its database's escort
	and instance quests, the client's timed quests, and the signature that says when to plan again. Where
	the player is, and which maps lie within a zone, is in Routes-Geography.lua
]]

local routes = ns.routes

local GetHereBeDragons = routes.HereBeDragons

-- Once Questie has started, its quest log and database are ready to read
function routes.IsQuestieReady()
	return Questie and Questie.started and GetHereBeDragons() and true or false
end

--------------------------------------------------------------------------------
-- Questie's quest log
--------------------------------------------------------------------------------

-- Each quest in Questie's quest log that its database knows, quest ID to Questie's quest
local function QuestLog()
	local log, acceptances = ns.QuestieLogEntries()
	if not acceptances then
		return log or {}
	end
	local quests = {}
	for questID, acceptance in pairs(log) do
		if type(acceptance) == "table" and type(acceptance.quest) == "table" then
			quests[questID] = acceptance.quest
		end
	end
	return quests
end
routes.QuestLog = QuestLog

-- 1 done, -1 failed, 0 not yet, as Questie counts it
local function QuestState(quest)
	if type(quest.IsComplete) ~= "function" then
		return 0
	end
	local ok, state = pcall(quest.IsComplete, quest)
	return ok and state or 0
end
routes.QuestState = QuestState

--[[
	Whether the game's own quest log has the quest, for a turn-in: only the player can turn in, so a quest
	Questie still lists that the game doesn't (turned in or abandoned a moment ago), or a party member's,
	is never one to go hand in. Where the client can't say, Questie's log stands
]]
local function IsOnQuest(questID)
	if C_QuestLog and type(C_QuestLog.IsOnQuest) == "function" then
		local ok, on = pcall(C_QuestLog.IsOnQuest, questID)
		if ok and type(on) == "boolean" then
			return on
		end
	end
	if type(GetQuestLogIndexByID) == "function" then
		local ok, index = pcall(GetQuestLogIndexByID, questID)
		if ok and type(index) == "number" then
			return index > 0
		end
	end
	return true
end
routes.IsOnQuest = IsOnQuest

-- Each objective in the quest log's list, then Questie's own extra ones (such as a portal to close)
local function ForEachObjective(quest, callback)
	for index, objective in pairs(type(quest.Objectives) == "table" and quest.Objectives or {}) do
		callback("o" .. tostring(index), objective)
	end
	for index, objective in pairs(type(quest.SpecialObjectives) == "table" and quest.SpecialObjectives or {}) do
		callback("s" .. tostring(index), objective)
	end
end
routes.ForEachObjective = ForEachObjective

--[[
	Whether a quest is an escort. Questie's tag for one (QuestieDB.questTagIds.ESCORT) comes from the client
	and Questie's corrections, and most classic escorts, Free From the Hold among them, have none, so its
	database's quest flags count too: PARTY_ACCEPT (2) is the flag the game sets on escorts, so that the
	party is asked to join when one starts. The tag is checked only where Questie names it. Each answer is
	remembered until the quest log next changes (routes.ForgetQuestTags), as the client can know a quest's
	tag only once it has loaded the quest
]]
local PARTY_ACCEPT = 2
local escortQuests = {}

local function HasFlag(flags, flag)
	return type(flags) == "number" and flags % (flag * 2) >= flag
end

local function IsEscort(questID)
	if escortQuests[questID] ~= nil then
		return escortQuests[questID]
	end
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not QuestieDB then
		return false
	end
	local escort = false
	local escortTag = type(QuestieDB.questTagIds) == "table" and QuestieDB.questTagIds.ESCORT
	if escortTag and type(QuestieDB.GetQuestTagInfo) == "function" then
		local ok, tagID = pcall(QuestieDB.GetQuestTagInfo, questID)
		escort = ok and tagID == escortTag
	end
	if not escort and type(QuestieDB.QueryQuestSingle) == "function" then
		local ok, flags = pcall(QuestieDB.QueryQuestSingle, questID, "questFlags")
		escort = ok and HasFlag(flags, PARTY_ACCEPT)
	end
	escortQuests[questID] = escort
	return escort
end
routes.IsEscort = IsEscort

--[[
	The quests whose timer is running, each quest ID to its seconds left. WoW Forever's
	C_QuestLog.GetQuestTimers names each timer's quest and its seconds; elsewhere GetQuestTimers gives each
	timer's seconds and GetQuestIndexForTimer finds that timer's quest log entry, which says its quest ID, so
	the quest log's selection is never touched. Asked fresh each time: a timer starts and ends with no change
	Questie sees
]]
local function TimedQuests()
	local timed = {}
	if C_QuestLog and C_QuestLog.GetQuestTimers then
		for _, info in ipairs(C_QuestLog.GetQuestTimers() or {}) do
			if type(info) == "table" and info.questID then
				timed[info.questID] = tonumber(info.questTimer) or 0
			end
		end
	elseif GetQuestTimers and GetQuestIndexForTimer and GetQuestLogTitle then
		local seconds = { GetQuestTimers() }
		for timer = 1, #seconds do
			local index = GetQuestIndexForTimer(timer)
			local questID = index and select(8, GetQuestLogTitle(index))
			if questID then
				timed[questID] = tonumber(seconds[timer]) or 0
			end
		end
	end
	return timed
end
routes.TimedQuests = TimedQuests

--[[
	Whether a quest is a dungeon or raid quest, by the game's tag for it, the one that puts the D or R after
	its level. Its objectives are left off the route, as they're inside the instance, but once it's done its
	turn-in is on it like any other's, where the NPC or object is out in the world (routes.IsInstanceMap);
	Questie's own icons for it stay on the map, as the route doesn't stand in for them.

	Questie's tag first, as its corrections fix the game's, then the client's. Questie asks the client once,
	again a second later, and then keeps "no tag" for good, so a quest whose tag loads after that has the
	client's D in the quest list and on the route's lines but none from Questie. Remembered as escorts are,
	but only once either has a tag: until then it's asked again, and the signature plans again when it loads
]]
local INSTANCE_KINDS = { DUNGEON = true, RAID = true }
local instanceQuests = {}

local function QuestieTag(questID)
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if QuestieDB and type(QuestieDB.GetQuestTagInfo) == "function" then
		local ok, tagID = pcall(QuestieDB.GetQuestTagInfo, questID)
		return ok and tagID or nil
	end
end

local function IsInstanceQuest(questID)
	if instanceQuests[questID] ~= nil then
		return instanceQuests[questID]
	end
	local tagID = QuestieTag(questID) or ns.GetQuestTagByID(questID)
	if not tagID then
		return false
	end
	local kinds = ns.QUEST_TAG_SUFFIXES or {}
	local found = INSTANCE_KINDS[kinds[tagID]] == true
	instanceQuests[questID] = found
	return found
end

-- A quest's tag can load with the quest log, so both answers are asked again after it changes
function routes.ForgetQuestTags()
	wipe(escortQuests)
	wipe(instanceQuests)
end
routes.IsInstanceQuest = IsInstanceQuest

local function HasSpawns(objective)
	return type(objective.spawnList) == "table" and next(objective.spawnList) ~= nil
end
routes.HasSpawns = HasSpawns

--[[
	What the route depends on, as text: each quest's state, whether it's in an instance and whether its
	timer is running, each objective's being done and having spawns, the party's quests' progress
	(routes.PartyProgress), the ignored objectives and party members, the members in another zone, Show Upcoming Turn-Ins, the player's zone and whether they're a ghost. The route is
	planned again when this changes. Nil until Questie is ready
]]
function routes.Signature()
	if not routes.IsQuestieReady() then
		return nil
	end
	local parts = {}
	local timed = TimedQuests()
	for questID, quest in pairs(QuestLog()) do
		if type(quest) == "table" then
			local bits = {}
			ForEachObjective(quest, function(key, objective)
				bits[#bits + 1] = key .. (objective.Completed and "+" or "-") .. (HasSpawns(objective) and "s" or "")
			end)
			table.sort(bits)
			parts[#parts + 1] = tostring(questID)
				.. (IsInstanceQuest(questID) and "i" or "")
				.. (timed[questID] and "t" or "")
				.. "="
				.. tostring(QuestState(quest))
				.. ":"
				.. table.concat(bits, ",")
		end
	end
	--[[
		The party's from what members have shared, not routes.PartyQuests, whose spawn lists are slow to work
		out: a party objective's spawns are worked out once, as it first appears, so they add nothing here
	]]
	for questID, progress in pairs(routes.PartyProgress(QuestLog())) do
		local bits = {}
		for index, entry in pairs(progress) do
			bits[#bits + 1] = index .. (#entry.needed == 0 and "+" or "-")
		end
		table.sort(bits)
		parts[#parts + 1] = "party:"
			.. questID
			.. (IsInstanceQuest(questID) and "i" or "")
			.. ":"
			.. table.concat(bits, ",")
	end
	for key in pairs(routes.skipped) do
		parts[#parts + 1] = "skip:" .. key
	end
	for name in pairs(routes.ignoredMembers) do
		parts[#parts + 1] = "ignore:" .. name
	end
	-- A member in another zone is left out as an ignored one is, until they're back
	for _, member in ipairs(routes.PartyMembers()) do
		if routes.IsUnitOutOfZone(member.unit) then
			parts[#parts + 1] = "away:" .. member.name
		end
	end
	table.sort(parts)
	parts[#parts + 1] = routes.Settings().showUpcomingTurnIns and "upcoming" or "done-only"
	parts[#parts + 1] = tostring(routes.PlayerZone())
	parts[#parts + 1] = UnitIsGhost("player") and "ghost" or "alive"
	return table.concat(parts, ";")
end
