local _, ns = ...

--[[
	Routes: quests the player can pick up nearby, as objectives on the route, with Show Available Local
	Quests as Objectives (showLocalQuests) on. A quest counts where Questie shows it as available (its
	AvailableQuests module, which keeps to Questie's own level, repeatable, dungeon and hidden filters) and
	an NPC or object that starts it stands within the Search Range (localQuestRange) of the player as the
	route is planned. A quest started by an item that drops isn't one to walk to, nor is a dungeon or raid
	quest. Each is a node of kind "pickUp", at its quest giver, as a turn-in is at its NPC.

	The Local Available Quests settings then sort them. Below Lowest Quest Level (localQuestLevel) a quest
	is left off. An escort (localEscortQuests), a group or elite quest (localGroupQuests), or one with an
	objective or its turn-in only in another zone (localOtherZoneQuests) each goes on the route, on the map
	only, or nowhere, the strictest of what applies winning. A map-only one is a camp (Routes-Camps.lua):
	a marker on the map, dimmed in the route's zone as camps are, with no route line to it, so the Quest
	Arrow never points there. An escort's marker is green, map only or on the route, and isn't dimmed
]]
local routes = ns.routes

local AddSpawns = routes.AddSpawns
local NewPoints = routes.NewPoints
local Cluster = routes.Cluster
local Candidates = routes.Candidates

--[[
	Yards from the player a quest giver can be and still count: the Search Range setting. Its default, 400,
	is as far as the player walks before the route is planned again (REPLAN_DISTANCE in
	Routes-Planner.lua), so a giver they pass between plans isn't missed; a shorter range can miss one
]]
function routes.LocalQuestRange()
	return tonumber(routes.Settings().localQuestRange) or 400
end

-- What each Local Available Quests choice does with a quest, strictest last
local ROUTE, MAP, OFF = "route", "map", "off"
local STRICTNESS = { [ROUTE] = 1, [MAP] = 2, [OFF] = 3 }

--[[
	Map-only pick-ups from the last plan, each { task, blobs, instance }, for the camps (Routes-Camps.lua).
	A new table each plan, so a plan underway never changes the one the camps are reading
]]
routes.mapOnlyPickUps = {}

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

-- The blobs within range yards of the start
local function InRange(blobs, start, range)
	local near = {}
	for _, blob in ipairs(blobs) do
		local dx, dy = blob.x - start.x, blob.y - start.y
		if dx * dx + dy * dy <= range * range then
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

--------------------------------------------------------------------------------
-- What counts
--------------------------------------------------------------------------------

-- Questie's level for a quest, its -1 being a quest at the player's own level
local function QuestLevel(QuestieDB, questID)
	local level = QueryQuest(QuestieDB, questID, "questLevel")
	if level == -1 or type(level) ~= "number" then
		return UnitLevel("player")
	end
	return level
end

--[[
	Whether a quest is under Lowest Quest Level, in the game's quest colors: gray is more than Questie's
	green range below the player (QuestieCompat.GetQuestGreenRange, the client's own on each game), yellow
	starts two levels below. "questie" adds nothing to Questie's own filter
]]
local function IsTooLow(QuestieDB, questID, setting)
	if setting ~= "green" and setting ~= "yellow" then
		return false
	end
	local below = UnitLevel("player") - QuestLevel(QuestieDB, questID)
	if setting == "yellow" then
		return below > 2
	end
	local QuestieCompat = ns.ImportQuestieModule("QuestieCompat")
	local ok, range = false, nil
	if QuestieCompat and type(QuestieCompat.GetQuestGreenRange) == "function" then
		ok, range = pcall(QuestieCompat.GetQuestGreenRange)
	end
	return ok and type(range) == "number" and below > range or false
end

-- A group or elite quest, by Questie's tag for it
local function IsGroupQuest(QuestieDB, questID)
	if type(QuestieDB.IsGroupQuest) ~= "function" then
		return false
	end
	local ok, group = pcall(QuestieDB.IsGroupQuest, questID)
	return ok and group == true
end

--[[
	Whether a Questie spawn table ({ [areaID] = { { x, y }, ... } }) has a spawn in the zone, and whether it
	has any spawn at all: a place Questie doesn't know never counts as another zone
]]
local function SpawnsInZone(spawns, zone)
	local ZoneDB = ns.ImportQuestieModule("ZoneDB")
	if type(spawns) ~= "table" or not (ZoneDB and ZoneDB.GetUiMapIdByAreaId) then
		return false, false
	end
	local known = false
	for areaID, list in pairs(spawns) do
		if type(list) == "table" and #list > 0 then
			known = true
			local mapID = ZoneDB:GetUiMapIdByAreaId(areaID)
			if mapID and routes.IsInZone(mapID, zone) then
				return true, true
			end
		end
	end
	return false, known
end

local function Spawns(query, id)
	if type(query) ~= "function" then
		return nil
	end
	local ok, spawns = pcall(query, id, "spawns")
	return ok and spawns or nil
end

--[[
	The places each thing a quest needs can be done, as lists of spawn tables: each creature, object and
	item objective (an item where it drops), each kill credit, the area to reach, and the turn-in
]]
local function Needs(QuestieDB, questID)
	local needs = {}
	local NPC, Object = QuestieDB.QueryNPCSingle, QuestieDB.QueryObjectSingle
	local objectives = QueryQuest(QuestieDB, questID, "objectives")
	if type(objectives) == "table" then
		for _, entry in ipairs(type(objectives[1]) == "table" and objectives[1] or {}) do
			needs[#needs + 1] = { Spawns(NPC, entry[1]) }
		end
		for _, entry in ipairs(type(objectives[2]) == "table" and objectives[2] or {}) do
			needs[#needs + 1] = { Spawns(Object, entry[1]) }
		end
		for _, entry in ipairs(type(objectives[3]) == "table" and objectives[3] or {}) do
			local lists = {}
			local item = QuestieDB.QueryItemSingle
			if type(item) == "function" then
				local okNPCs, npcs = pcall(item, entry[1], "npcDrops")
				for _, id in ipairs(okNPCs and type(npcs) == "table" and npcs or {}) do
					lists[#lists + 1] = Spawns(NPC, id)
				end
				local okObjects, objects = pcall(item, entry[1], "objectDrops")
				for _, id in ipairs(okObjects and type(objects) == "table" and objects or {}) do
					lists[#lists + 1] = Spawns(Object, id)
				end
			end
			needs[#needs + 1] = lists
		end
		for _, entry in ipairs(type(objectives[5]) == "table" and objectives[5] or {}) do
			local lists = {}
			for _, id in ipairs(type(entry[1]) == "table" and entry[1] or {}) do
				lists[#lists + 1] = Spawns(NPC, id)
			end
			needs[#needs + 1] = lists
		end
	end
	local trigger = QueryQuest(QuestieDB, questID, "triggerEnd")
	if type(trigger) == "table" and type(trigger[2]) == "table" then
		needs[#needs + 1] = { trigger[2] }
	end
	local finishedBy = QueryQuest(QuestieDB, questID, "finishedBy")
	if type(finishedBy) == "table" then
		local lists = {}
		for _, id in ipairs(type(finishedBy[1]) == "table" and finishedBy[1] or {}) do
			lists[#lists + 1] = Spawns(NPC, id)
		end
		for _, id in ipairs(type(finishedBy[2]) == "table" and finishedBy[2] or {}) do
			lists[#lists + 1] = Spawns(Object, id)
		end
		needs[#needs + 1] = lists
	end
	return needs
end

--[[
	Whether something the quest needs, an objective or its turn-in, is only in other zones than this one.
	Questie's spawns don't move, so it's worked out once a quest and zone
]]
local elsewhereCache = {}

local function IsElsewhere(QuestieDB, questID, zone, yield)
	local byZone = elsewhereCache[zone]
	if not byZone then
		byZone = {}
		elsewhereCache[zone] = byZone
	end
	if byZone[questID] ~= nil then
		return byZone[questID]
	end
	local elsewhere = false
	for _, lists in ipairs(Needs(QuestieDB, questID)) do
		local here, known = false, false
		for _, spawns in pairs(lists) do
			local inZone, has = SpawnsInZone(spawns, zone)
			known = known or has
			if inZone then
				here = true
				break
			end
		end
		if known and not here then
			elsewhere = true
			break
		end
		yield()
	end
	byZone[questID] = elsewhere
	return elsewhere
end

--[[
	What the settings do with a quest whose giver is near: ROUTE, MAP or OFF, the strictest that applies,
	and the reason for it ("escort", "group" or "elsewhere"), for the map marker's tooltip
]]
local function Handling(QuestieDB, questID, zone, settings, yield)
	local handling, reason = ROUTE, nil
	local function Apply(value, why)
		if STRICTNESS[value] and STRICTNESS[value] > STRICTNESS[handling] then
			handling, reason = value, why
		end
	end
	if routes.IsEscort(questID) then
		Apply(settings.localEscortQuests, "escort")
	end
	if handling ~= OFF and settings.localGroupQuests ~= ROUTE and IsGroupQuest(QuestieDB, questID) then
		Apply(settings.localGroupQuests, "group")
	end
	if
		handling ~= OFF
		and (STRICTNESS[settings.localOtherZoneQuests] or 0) > STRICTNESS[handling]
		and IsElsewhere(QuestieDB, questID, zone, yield)
	then
		Apply(settings.localOtherZoneQuests, "elsewhere")
	end
	return handling, reason
end

--[[
	Adds a "pickUp" node to nodes for every quest the player can pick up nearby that the settings put on the
	route. Each is { key, kind, questID, questName, quest, candidates, blobs, ready, escort }, quest a small
	table of its name and level for the arrow's title line. The map-only ones go on routes.mapOnlyPickUps
]]
function routes.AddLocalQuestNodes(nodes, start, log, yield)
	local mapOnly = {}
	routes.mapOnlyPickUps = mapOnly
	local settings = routes.Settings()
	if not settings.showLocalQuests then
		return
	end
	local available = AvailableQuestIDs()
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not (available and QuestieDB and type(QuestieDB.QueryQuestSingle) == "function") then
		return
	end
	local skipped = routes.skipped
	local range = routes.LocalQuestRange()
	local questIDs = {}
	for questID in pairs(available) do
		questIDs[#questIDs + 1] = questID
	end
	table.sort(questIDs)
	for _, questID in ipairs(questIDs) do
		local key = questID .. ":pickUp"
		if
			available[questID]
			and not skipped[key]
			and not IsTakenOrDone(questID, log)
			and not routes.IsInstanceQuest(questID)
			and not IsTooLow(QuestieDB, questID, settings.localQuestLevel)
		then
			local blobs = InRange(StarterBlobs(QuestieDB, questID, start, yield), start, range)
			local handling, reason = OFF, nil
			if #blobs > 0 then
				handling, reason = Handling(QuestieDB, questID, start.zone, settings, yield)
			end
			if handling ~= OFF then
				local name = QueryQuest(QuestieDB, questID, "name") or tostring(questID)
				local task = {
					key = key,
					kind = "pickUp",
					questID = questID,
					questName = name,
					quest = { name = name, level = QuestLevel(QuestieDB, questID) },
					ready = true,
					escort = routes.IsEscort(questID) or nil,
				}
				if handling == ROUTE then
					task.candidates = Candidates(blobs, start, false)
					task.blobs = blobs
					nodes[#nodes + 1] = task
				else
					task.offRoute = reason
					mapOnly[#mapOnly + 1] = { task = task, blobs = blobs, instance = start.instance }
				end
			end
		end
		yield()
	end
end

--[[
	What the settings add to the route's signature: the player's level, as Questie offers more quests with
	each, and each Local Available Quests choice. The set of available quests near enough to matter is
	worked out again with every plan
]]
function routes.LocalQuestSignature()
	local settings = routes.Settings()
	if not settings.showLocalQuests then
		return "no-local"
	end
	return table.concat({
		"local",
		tostring(UnitLevel("player")),
		tostring(routes.LocalQuestRange()),
		tostring(settings.localQuestLevel),
		tostring(settings.localEscortQuests),
		tostring(settings.localGroupQuests),
		tostring(settings.localOtherZoneQuests),
	}, ":")
end
