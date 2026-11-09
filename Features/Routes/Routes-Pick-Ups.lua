local _, ns = ...

--[[
	Routes: quests the player can pick up nearby, as objectives on the route, with Show Available Local
	Quests as Objectives (showLocalQuests) on. A quest counts where Questie shows it as available (its
	AvailableQuests module, which keeps to Questie's own level, repeatable, dungeon and hidden filters) and
	an NPC or object that starts it stands within LOCAL_QUEST_RANGE yards of the player as the route is
	planned. A quest started by an item that drops isn't one to walk to, nor is a dungeon or raid quest.
	Each is a node of kind "pickUp", at its quest giver, as a turn-in is at its NPC
]]

local routes = ns.routes

local AddSpawns = routes.AddSpawns
local NewPoints = routes.NewPoints
local Cluster = routes.Cluster
local Candidates = routes.Candidates

--[[
	Yards from the player a quest giver can be and still go on the route. As far as the player walks before
	the route is planned again (REPLAN_DISTANCE in Routes-Planner.lua), so a giver they pass between plans
	isn't missed
]]
local LOCAL_QUEST_RANGE = 400
routes.LOCAL_QUEST_RANGE = LOCAL_QUEST_RANGE

-- Questie's set of available quests, quest ID to true; nil where Questie doesn't have one
local function AvailableQuestIDs()
	local AvailableQuests = ns.ImportQuestieModule("AvailableQuests")
	local available = AvailableQuests and AvailableQuests.__availableQuests
	return type(available) == "table" and available or nil
end

local function QueryQuest(QuestieDB, questID, field)
	local ok, value = pcall(QuestieDB.QueryQuestSingle, questID, field)
	return ok and value or nil
end

-- Calls add(spawns, name) for every NPC and object that starts the quest, as Questie's database has them
local function ForEachStarter(QuestieDB, questID, add)
	local startedBy = QueryQuest(QuestieDB, questID, "startedBy")
	if type(startedBy) ~= "table" then
		return
	end
	-- startedBy is { NPCs, objects, items }; an item that drops isn't a place to walk to
	for index, query in pairs({ [1] = QuestieDB.QueryNPCSingle, [2] = QuestieDB.QueryObjectSingle }) do
		local ids = startedBy[index]
		if type(query) == "function" and type(ids) == "table" then
			for _, id in ipairs(ids) do
				local okSpawns, spawns = pcall(query, id, "spawns")
				local okName, name = pcall(query, id, "name")
				if okSpawns then
					add(spawns, okName and name or nil)
				end
			end
		end
	end
end

--[[
	A quest giver's blobs, worked out once for the zone they were worked out in: spawns don't move. Each
	quest has a table of its own here, as a weak-keyed cache needs a table to key by
]]
local starterCache = {}

local function StarterBlobs(QuestieDB, questID, start, yield)
	local cached = starterCache[questID]
	if cached and cached.zone == start.zone and cached.instance == start.instance then
		return cached.blobs
	end
	local points = NewPoints()
	ForEachStarter(QuestieDB, questID, function(spawns, name)
		AddSpawns(points, spawns, name, start, yield, true)
	end)
	local blobs = Cluster(points, yield)
	starterCache[questID] = { zone = start.zone, instance = start.instance, blobs = blobs }
	return blobs
end

-- The blobs within LOCAL_QUEST_RANGE of the start
local function InRange(blobs, start)
	local near = {}
	for _, blob in ipairs(blobs) do
		local dx, dy = blob.x - start.x, blob.y - start.y
		if dx * dx + dy * dy <= LOCAL_QUEST_RANGE * LOCAL_QUEST_RANGE then
			near[#near + 1] = blob
		end
	end
	return near
end

-- Whether the player has the quest already, or has done it: Questie's available set can lag a moment behind
local function IsTakenOrDone(questID, log)
	if log[questID] then
		return true
	end
	local complete = Questie and Questie.db and Questie.db.char and Questie.db.char.complete
	if type(complete) == "table" and complete[questID] then
		return true
	end
	if C_QuestLog and type(C_QuestLog.IsOnQuest) == "function" then
		local ok, on = pcall(C_QuestLog.IsOnQuest, questID)
		if ok and on == true then
			return true
		end
	end
	return false
end

--[[
	Adds a "pickUp" node to nodes for every quest the player can pick up nearby, with the setting on. Each
	is { key, kind, questID, questName, quest, candidates, blobs, ready }, quest a small table of its name
	and level for the arrow's title line
]]
function routes.AddLocalQuestNodes(nodes, start, log, yield)
	if not routes.Settings().showLocalQuests then
		return
	end
	local available = AvailableQuestIDs()
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not (available and QuestieDB and type(QuestieDB.QueryQuestSingle) == "function") then
		return
	end
	local skipped = routes.skipped
	local questIDs = {}
	for questID in pairs(available) do
		questIDs[#questIDs + 1] = questID
	end
	for _, questID in ipairs(questIDs) do
		local key = questID .. ":pickUp"
		if
			available[questID]
			and not skipped[key]
			and not IsTakenOrDone(questID, log)
			and not routes.IsInstanceQuest(questID)
		then
			local blobs = InRange(StarterBlobs(QuestieDB, questID, start, yield), start)
			if #blobs > 0 then
				local name = QueryQuest(QuestieDB, questID, "name") or tostring(questID)
				-- Questie's -1 is a quest at the player's own level
				local level = QueryQuest(QuestieDB, questID, "questLevel")
				if level == -1 then
					level = UnitLevel("player")
				end
				nodes[#nodes + 1] = {
					key = key,
					kind = "pickUp",
					questID = questID,
					questName = name,
					quest = { name = name, level = level },
					candidates = Candidates(blobs, start, false),
					blobs = blobs,
					ready = true,
				}
			end
		end
		yield()
	end
end

--[[
	What the setting adds to the route's signature: the player's level, as Questie offers more quests with
	each, and the set of available quests near enough to matter is worked out again with every plan
]]
function routes.LocalQuestSignature()
	if not routes.Settings().showLocalQuests then
		return "no-local"
	end
	return "local:" .. tostring(UnitLevel("player"))
end
