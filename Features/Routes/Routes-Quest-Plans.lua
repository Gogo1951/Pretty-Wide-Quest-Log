local _, ns = ...

--[[
	Routes: a quest's objectives and turn-in, from Questie's database, for a quest the player hasn't taken
	yet: Routes-Chains.lua plans each one ahead from them (routes.QuestPlan), and Routes-Nodes.lua finds a
	party member's turn-in (routes.QuestTurnInBlobs)
]]

local routes = ns.routes
local helpers = routes.pickUpHelpers -- Routes-Pick-Ups.lua

local AddSpawns = routes.AddSpawns
local NewPoints = routes.NewPoints
local Cluster = routes.Cluster
local QueryQuest = helpers.QueryQuest

local function Field(query, id, field)
	if type(query) ~= "function" then
		return nil
	end
	local ok, value = pcall(query, id, field)
	return ok and value or nil
end

local function List(value)
	return type(value) == "table" and value or {}
end

--[[
	Each objective of a quest as Questie's database has it, { text, icon, sources }, sources the spawn
	tables where it's done, each { spawns, name }: a creature, an object, an item where it drops, a kill
	credit's creatures, the place to reach. The icon is Questie's for that kind
]]
local function ObjectiveSpecs(QuestieDB, questID)
	local NPC, Object, Item = QuestieDB.QueryNPCSingle, QuestieDB.QueryObjectSingle, QuestieDB.QueryItemSingle
	local slay = Questie and Questie.ICON_TYPE_SLAY
	local specs = {}
	local objectives = List(QueryQuest(QuestieDB, questID, "objectives"))
	for _, entry in ipairs(List(objectives[1])) do
		local name = Field(NPC, entry[1], "name")
		specs[#specs + 1] = {
			text = entry[2] or name,
			icon = slay,
			sources = { { Field(NPC, entry[1], "spawns"), name } },
		}
	end
	for _, entry in ipairs(List(objectives[2])) do
		local name = Field(Object, entry[1], "name")
		specs[#specs + 1] = {
			text = entry[2] or name,
			icon = Questie and Questie.ICON_TYPE_OBJECT,
			sources = { { Field(Object, entry[1], "spawns"), name } },
		}
	end
	for _, entry in ipairs(List(objectives[3])) do
		local sources = {}
		for _, npcID in ipairs(List(Field(Item, entry[1], "npcDrops"))) do
			sources[#sources + 1] = { Field(NPC, npcID, "spawns"), Field(NPC, npcID, "name") }
		end
		for _, objectID in ipairs(List(Field(Item, entry[1], "objectDrops"))) do
			sources[#sources + 1] = { Field(Object, objectID, "spawns"), Field(Object, objectID, "name") }
		end
		specs[#specs + 1] = {
			text = entry[2] or Field(Item, entry[1], "name"),
			icon = Questie and Questie.ICON_TYPE_LOOT,
			sources = sources,
		}
	end
	for _, entry in ipairs(List(objectives[5])) do
		local sources = {}
		for _, npcID in ipairs(List(entry[1])) do
			sources[#sources + 1] = { Field(NPC, npcID, "spawns"), Field(NPC, npcID, "name") }
		end
		specs[#specs + 1] = {
			text = entry[3] or Field(NPC, entry[2], "name"),
			icon = slay,
			sources = sources,
		}
	end
	local trigger = QueryQuest(QuestieDB, questID, "triggerEnd")
	if type(trigger) == "table" and type(trigger[2]) == "table" then
		specs[#specs + 1] = {
			text = trigger[1],
			icon = Questie and Questie.ICON_TYPE_EVENT,
			sources = { { trigger[2], nil } },
		}
	end
	return specs
end

--[[
	A quest's plan in the zone: { objectives, turnIn }, objectives each { text, icon, blobs } for every
	objective with spawns here (one with none, bought or made, is left off), turnIn the blobs of every
	NPC and object out in the world that takes it. Worked out once a quest and zone: spawns don't move
]]
local planCache, turnInCache = {}, {}
local plansZone -- The zone the cached plans were worked out in

-- A new zone: the last one's plans go, so they don't pile up over a session
local function ForgetOtherZones(start)
	if start.zone ~= plansZone then
		plansZone = start.zone
		wipe(planCache)
		wipe(turnInCache)
	end
end

-- The blobs of every NPC and object out in the world that takes a quest, worked out once a quest and zone
local function TurnInBlobs(QuestieDB, questID, start, yield)
	ForgetOtherZones(start)
	local cached = turnInCache[questID]
	if cached and cached.zone == start.zone and cached.instance == start.instance then
		return cached.blobs
	end
	local points = NewPoints()
	local finishedBy = List(QueryQuest(QuestieDB, questID, "finishedBy"))
	for kind, query in pairs({ [1] = QuestieDB.QueryNPCSingle, [2] = QuestieDB.QueryObjectSingle }) do
		for _, id in ipairs(List(finishedBy[kind])) do
			local spawns = Field(query, id, "spawns")
			if type(spawns) == "table" then
				AddSpawns(points, spawns, Field(query, id, "name"), start, yield, true)
			end
		end
	end
	local blobs = Cluster(points, yield)
	turnInCache[questID] = { zone = start.zone, instance = start.instance, blobs = blobs }
	return blobs
end

function routes.QuestPlan(QuestieDB, questID, start, yield)
	ForgetOtherZones(start)
	local cached = planCache[questID]
	if cached and cached.zone == start.zone and cached.instance == start.instance then
		return cached
	end
	local plan = { zone = start.zone, instance = start.instance, objectives = {} }
	for _, spec in ipairs(ObjectiveSpecs(QuestieDB, questID)) do
		local points = NewPoints()
		for _, source in ipairs(spec.sources) do
			if type(source[1]) == "table" then
				AddSpawns(points, source[1], source[2], start, yield)
			end
		end
		if points.count > 0 then
			local blobs = Cluster(points, yield)
			blobs.spawns = { x = points.x, y = points.y, count = points.count }
			plan.objectives[#plan.objectives + 1] = { text = spec.text or "", icon = spec.icon, blobs = blobs }
		end
	end
	plan.turnIn = TurnInBlobs(QuestieDB, questID, start, yield)
	planCache[questID] = plan
	return plan
end

--[[
	Where a quest is turned in, from Questie's database, for a party member's quest (Routes-Nodes.lua): the
	player's own come from Questie's quest log. Empty without Questie's database
]]
function routes.QuestTurnInBlobs(questID, start, yield)
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not (QuestieDB and type(QuestieDB.QueryQuestSingle) == "function") then
		return {}
	end
	return TurnInBlobs(QuestieDB, questID, start, yield)
end
