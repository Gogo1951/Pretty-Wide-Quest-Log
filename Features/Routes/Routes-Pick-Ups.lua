local _, ns = ...

--[[
	Routes: quests the player can pick up nearby, as objectives on the route, with What to Route's Plan
	Ahead (planAhead) on Your Quests and Nearby Pick-Ups or Plan Ahead. A quest counts where Questie shows it as available (its
	AvailableQuests module, which keeps to Questie's own level, repeatable, dungeon and hidden filters) and
	an NPC or object that starts it stands within the Search Range (localQuestRange) of the player as the
	route is planned. A quest started by an item that only one named creature or one object gives counts
	there: Hoof of Lakota'mani at Lakota'mani, the Dirt-stained Map at the map on the ground in Mulgore. One
	started by an item that several creatures or objects give isn't one to walk to. Each is a node of kind
	"pickUp", at its quest giver, as a turn-in is at its NPC.

	The What to Route settings then sort them; they only guide what to pick up, as a quest already in the
	log is always on the route (Routes-Nodes.lua), whatever its level or kind. A quest more levels above the
	player than Highest Quest Level (highestQuestLevel) is on the map only, saying the level it goes on the
	route at; one more below than Lowest Quest Level (lowestQuestLevel) is left off. Each kind under Quest
	Types to Pick Up Along the Route that's unchecked is on the map only, saying why: elite (group from TBC
	on), PvP, dungeon, raid and escort quests by their tags (pickUpElite, pickUpPvP, pickUpDungeon,
	pickUpRaid, pickUpEscort), and one with an objective or its turn-in only in another zone
	(pickUpOtherZone). A dungeon or raid quest checked has its pick-up on the route, its objectives being
	inside. A map-only one is a camp (Routes-Camps.lua):
	a marker on the map, dimmed in the route's zone as camps are, with no route line to it, so the Quest
	Arrow never points there. An escort's marker isn't dimmed, map only or on the route. A
	right-click on a map-only marker puts it on the route (routes.AddPickUp) until the zone is reset
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

-- What the settings do with a quest to pick up: on the route, a marker on the map only, or nothing
local ROUTE, MAP, OFF = "route", "map", "off"

--[[
	What to Route's Plan Ahead: "yours" (Your Quests Only), "nearby" (Your Quests and Nearby Pick-Ups) or
	"zone" (Plan Ahead: the zone's quests planned whole with their follow-ups, Routes-Chains.lua)
]]
local PLAN_AHEAD = { yours = true, nearby = true, zone = true }

function routes.PlanAhead()
	local value = routes.Settings().planAhead
	return PLAN_AHEAD[value] and value or "nearby"
end

-- Whether the route guides the player to quests to pick up near them, as Nearby Pick-Ups and Plan Ahead do
function routes.PlansPickUps()
	return routes.PlanAhead() ~= "yours"
end

-- Whether the zone's quests are planned whole with their follow-ups, Plan Ahead
function routes.PlansZone()
	return routes.PlanAhead() == "zone"
end

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

-- The creatures and objects an item drops from, as Questie's database has them; nil without its item lookup
local function ItemSources(QuestieDB, itemID)
	local query = QuestieDB.QueryItemSingle
	if type(query) ~= "function" then
		return nil
	end
	local okObjects, objects = pcall(query, itemID, "objectDrops")
	objects = okObjects and type(objects) == "table" and objects or {}
	local okNPCs, npcs = pcall(query, itemID, "npcDrops")
	npcs = okNPCs and type(npcs) == "table" and npcs or {}
	return npcs, objects
end

--[[
	The one thing an item comes from, as "npc" or "object" and its ID, or nil: an item dropped by a single
	named creature (Hoof of Lakota'mani, from Lakota'mani) starts its quest at that creature, however many
	places it spawns or walks, and one looted from a single object (the Dirt-stained Map, lying on the
	ground in Mulgore) starts it at that object. One that several creatures or objects give could come from
	anywhere, so it isn't a place to walk to
]]
local function SoleSource(QuestieDB, itemID)
	local npcs, objects = ItemSources(QuestieDB, itemID)
	if not npcs or #npcs + #objects ~= 1 then
		return nil
	end
	if #npcs == 1 then
		return "npc", npcs[1]
	end
	return "object", objects[1]
end

--[[
	Whether a quest is started by an item that more than one kind of creature or object drops (Captain
	Sander's Hidden Treasure, on Westfall's coast): it could start anywhere they are, so Questie's own icons
	on each of them are the only place it shows (Routes-Map-Questie-Icons.lua)
]]
local function IsManySourceDrop(QuestieDB, questID)
	local startedBy = QueryQuest(QuestieDB, questID, "startedBy")
	if type(startedBy) ~= "table" or type(startedBy[3]) ~= "table" then
		return false
	end
	for _, itemID in ipairs(startedBy[3]) do
		local npcs, objects = ItemSources(QuestieDB, itemID)
		if npcs and #npcs + #objects > 1 then
			return true
		end
	end
	return false
end

--[[
	The one creature a quest can only be started from, as its ID, or nil: no NPC or object gives it, and every
	item that starts it drops from that creature alone (Fizsprocket's Notes, from Supervisor Fizsprocket)
]]
local function SoleDropper(QuestieDB, questID)
	local startedBy = QueryQuest(QuestieDB, questID, "startedBy")
	if type(startedBy) ~= "table" or type(startedBy[3]) ~= "table" then
		return nil
	end
	for index = 1, 2 do
		if type(startedBy[index]) == "table" and #startedBy[index] > 0 then
			return nil
		end
	end
	local dropper
	for _, itemID in ipairs(startedBy[3]) do
		local kind, id = SoleSource(QuestieDB, itemID)
		if kind ~= "npc" or (dropper and dropper ~= id) then
			return nil
		end
		dropper = id
	end
	return dropper
end

--[[
	Calls add(spawns, name) for every NPC and object that starts the quest, as Questie's database has them,
	and the creature or object an item that starts it comes from, when it comes from only one (SoleSource)
]]
local function ForEachStarter(QuestieDB, questID, add)
	local startedBy = QueryQuest(QuestieDB, questID, "startedBy")
	if type(startedBy) ~= "table" then
		return
	end
	local NPC, Object = QuestieDB.QueryNPCSingle, QuestieDB.QueryObjectSingle
	local function Add(query, id)
		local okSpawns, spawns = pcall(query, id, "spawns")
		local okName, name = pcall(query, id, "name")
		if okSpawns then
			add(spawns, okName and name or nil)
		end
	end
	-- startedBy is { NPCs, objects, items }
	for index, query in pairs({ [1] = NPC, [2] = Object }) do
		local ids = startedBy[index]
		if type(query) == "function" and type(ids) == "table" then
			for _, id in ipairs(ids) do
				Add(query, id)
			end
		end
	end
	if type(startedBy[3]) == "table" then
		local byKind = { npc = NPC, object = Object }
		for _, itemID in ipairs(startedBy[3]) do
			local kind, id = SoleSource(QuestieDB, itemID)
			local query = kind and byKind[kind]
			if type(query) == "function" then
				Add(query, id)
			end
		end
	end
end

--[[
	A quest giver's blobs, worked out once for the zone they were worked out in: spawns don't move. A plain
	table by quest ID, emptied when the planner moves to another zone
]]
local starterCache = {}
local startersZone -- The zone the cached givers were worked out in

local function StarterBlobs(QuestieDB, questID, start, yield)
	if start.zone ~= startersZone then
		startersZone = start.zone
		wipe(starterCache) -- A new zone: the last one's givers go, so they don't pile up over a session
	end
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
	Whether a quest is gray: more than Questie's green range below the player (QuestieCompat.GetQuestGreenRange,
	the client's own on each game), for Zone Info and the Questie map. The route goes by IsOutsideLevels
]]
local function IsGray(QuestieDB, questID)
	local below = UnitLevel("player") - QuestLevel(QuestieDB, questID)
	local QuestieCompat = ns.ImportQuestieModule("QuestieCompat")
	local ok, range = false, nil
	if QuestieCompat and type(QuestieCompat.GetQuestGreenRange) == "function" then
		ok, range = pcall(QuestieCompat.GetQuestGreenRange)
	end
	return ok and type(range) == "number" and below > range or false
end

--[[
	Whether a quest is outside the levels the route picks up: "high", and the player level it comes within
	them at, where its level is more than Highest Quest Level (highestQuestLevel, whose 0 is Your Level)
	above the player's; "low" where it's more than Lowest Quest Level (lowestQuestLevel) below, whose 0 is
	No Limit: gray quests too, for completionists; else false. Levels, not colors: what the colors mean
	differs from game to game. A quest at the player's own level whatever it is (Questie's -1) never is
]]
local function IsOutsideLevels(QuestieDB, questID, settings)
	local level = QueryQuest(QuestieDB, questID, "questLevel")
	if type(level) ~= "number" or level == -1 then
		return false
	end
	local player = UnitLevel("player")
	local above = tonumber(settings.highestQuestLevel) or 3
	local below = tonumber(settings.lowestQuestLevel) or 6
	if level > player + above then
		return "high", level - above
	end
	if below > 0 and level < player - below then
		return "low"
	end
	return false
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
	item objective (an item where it drops), each kill credit, each child quest's finisher, the area to
	reach, and the turn-in
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
	--[[
		Each step Questie keeps as a quest of its own under this one, at the NPC or object that finishes it:
		The Warsong Reports' updates, an item each from a scout in Ashenvale, which no creature drops
	]]
	local children = QueryQuest(QuestieDB, questID, "childQuests")
	for _, childID in ipairs(type(children) == "table" and children or {}) do
		local childFinishers = QueryQuest(QuestieDB, childID, "finishedBy")
		if type(childFinishers) == "table" then
			local lists = {}
			for _, id in ipairs(type(childFinishers[1]) == "table" and childFinishers[1] or {}) do
				lists[#lists + 1] = Spawns(NPC, id)
			end
			for _, id in ipairs(type(childFinishers[2]) == "table" and childFinishers[2] or {}) do
				lists[#lists + 1] = Spawns(Object, id)
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
		wipe(elsewhereCache) -- A new zone: the last one's answers go
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
	Quest Types to Pick Up Along the Route, by the kind of the quest's tag (routes.QuestTagKind): its
	setting, the reason a quest of it unchecked is off the route, and whether it's an instance's, whose
	objectives are inside, so never count as another zone's
]]
local QUEST_TYPES = {
	ELITE = { setting = "pickUpElite", reason = "elite" },
	GROUP = { setting = "pickUpElite", reason = "group" },
	PVP = { setting = "pickUpPvP", reason = "pvp" },
	DUNGEON = { setting = "pickUpDungeon", reason = "dungeon", instance = true },
	RAID = { setting = "pickUpRaid", reason = "raid", instance = true },
}

--[[
	What the settings do with a quest whose giver is near: ROUTE, or MAP and the reason for it ("elite",
	"group", "pvp", "dungeon", "raid", "escort" or "elsewhere") for the map marker's tooltip, where its kind
	is unchecked under Quest Types to Pick Up Along the Route. A dungeon or raid quest checked is on the
	route, its pick-up only (Routes-Nodes.lua leaves an instance's objectives off). One the player put on
	the route with a right-click on its marker (routes.added) is on it, till the zone is reset
]]
local function Handling(QuestieDB, questID, zone, settings, yield)
	if routes.added[questID .. ":pickUp"] then
		return ROUTE, nil
	end
	local questType = QUEST_TYPES[routes.QuestTagKind(questID) or ""]
	if questType and not settings[questType.setting] then
		return MAP, questType.reason
	end
	if not settings.pickUpEscort and routes.IsEscort(questID) then
		return MAP, "escort"
	end
	if
		not settings.pickUpOtherZone
		and not (questType and questType.instance)
		and IsElsewhere(QuestieDB, questID, zone, yield)
	then
		return MAP, "elsewhere"
	end
	return ROUTE, nil
end

-- Yards from the start to the nearest of some blobs, math.huge for none
local function NearestYards(blobs, start)
	local nearest = math.huge
	for _, blob in ipairs(blobs) do
		local dx, dy = blob.x - start.x, blob.y - start.y
		nearest = math.min(nearest, math.sqrt(dx * dx + dy * dy))
	end
	return nearest
end

--[[
	How many more quests the log takes: the client's own limit where it says, else Classic's 20, less the
	quests in Questie's log. Planning pick-ups past it would send the player to a giver who can't give
]]
local function FreeQuestSlots(log)
	local most = 20
	if C_QuestLog and type(C_QuestLog.GetMaxNumQuestsCanAccept) == "function" then
		local ok, value = pcall(C_QuestLog.GetMaxNumQuestsCanAccept)
		most = ok and tonumber(value) or most
	elseif tonumber(MAX_QUESTS) then
		most = tonumber(MAX_QUESTS)
	end
	local taken = 0
	for _, quest in pairs(log) do
		if type(quest) == "table" then
			taken = taken + 1
		end
	end
	return math.max(0, most - taken)
end

--[[
	Quests Zone Info's + put on the route (Zone-Info-Data.lua), quest ID to true: each is picked up from
	anywhere in its giver's zone, whatever the settings below say, as the player asked for it
]]
local function WantedPickUps()
	local data = ns.zoneInfoData
	return data and data.WantedPickUps() or {}
end

-- A small table of a quest's name and level, for the arrow's title line, and the name
local function QuestInfo(QuestieDB, questID)
	local name = QueryQuest(QuestieDB, questID, "name") or tostring(questID)
	return { name = name, level = QuestLevel(QuestieDB, questID) }, name
end

-- What Routes-Chains.lua and the zone discs (Routes-Map-Zones.lua) share from here
routes.pickUpHelpers = {
	AvailableQuestIDs = AvailableQuestIDs,
	ForEachStarter = ForEachStarter,
	QueryQuest = QueryQuest,
	QuestInfo = QuestInfo,
	StarterBlobs = StarterBlobs,
	IsTakenOrDone = IsTakenOrDone,
	IsGray = IsGray,
	IsOutsideLevels = IsOutsideLevels,
	IsElsewhere = IsElsewhere,
	IsManySourceDrop = IsManySourceDrop,
	SoleDropper = SoleDropper,
	Handling = Handling,
	ROUTE = ROUTE,
}

--[[
	Adds a "pickUp" node to nodes for every quest the player can pick up nearby that the settings put on the
	route. Each is { key, kind, questID, questName, quest, candidates, blobs, ready, escort }, quest a small
	table of its name and level for the arrow's title line. The map-only ones go on routes.mapOnlyPickUps,
	with the ignored ones.

	With Plan Ahead (routes.PlansZone), a quest that can be done in the zone from start to finish
	(routes.IsChainQuest) counts from anywhere in the zone, not only within the Search Range, and
	Routes-Chains.lua plans its objectives, its turn-in and the quests that follow it. Those are returned,
	nearest giver first. A quest Zone Info's + asked for (task.wanted) counts from anywhere in the zone too,
	whatever its level or kind, ahead of every other. A quest someone in the party has (Party Objectives on)
	counts from anywhere in the zone as well. With Your Quests Only, those are the only quests to pick up.
	One above Highest Quest Level is on the map only, saying the level it goes on the route at (opensAt). No
	more quests are picked up than the log has room for, nearest first
]]
function routes.AddLocalQuestNodes(nodes, start, log, yield)
	local mapOnly = {}
	routes.mapOnlyPickUps = mapOnly
	local settings = routes.Settings()
	local nearby, planChains = routes.PlansPickUps(), routes.PlansZone()
	local wanted = WantedPickUps()
	if not (nearby or planChains or next(wanted) or routes.ShowsParty()) then
		return {}
	end
	local available = AvailableQuestIDs()
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not (available and QuestieDB and type(QuestieDB.QueryQuestSingle) == "function") then
		return {}
	end
	local skipped = routes.skipped
	local range = routes.LocalQuestRange()
	local questIDs = {}
	for questID in pairs(available) do
		questIDs[#questIDs + 1] = questID
	end
	table.sort(questIDs)
	local onRoute = {}
	for _, questID in ipairs(questIDs) do
		local key = questID .. ":pickUp"
		--[[
			Its givers first, worked out once a zone, so a quest with none in this zone, most of them, skips the
			tag and level lookups
		]]
		local starters = available[questID]
			and not IsTakenOrDone(questID, log)
			and StarterBlobs(QuestieDB, questID, start, yield)
		local isWanted = wanted[questID] == true
		local outside, opensAt = false, nil
		-- One put on the route from its map marker (routes.added) is on it whatever its level, as a wanted one is
		if starters and #starters > 0 and not isWanted and not routes.added[key] then
			outside, opensAt = IsOutsideLevels(QuestieDB, questID, settings)
		end
		if outside == "high" and nearby then
			--[[
				Too hard yet: on the map only, wherever in the zone its giver is, saying the level it goes on the
				route at, so the player sees it's held back, not missed; a right-click puts it on the route
			]]
			local info, name = QuestInfo(QuestieDB, questID)
			mapOnly[#mapOnly + 1] = {
				task = {
					key = key,
					kind = "pickUp",
					questID = questID,
					questName = name,
					quest = info,
					ready = true,
					escort = routes.IsEscort(questID) or nil,
					offRoute = "level",
					opensAt = opensAt,
				},
				blobs = starters,
				instance = start.instance,
			}
		elseif starters and #starters > 0 and not outside then
			local chained = planChains
				and #starters > 0
				and routes.IsChainQuest(QuestieDB, questID, start, yield)
				and Handling(QuestieDB, questID, start.zone, settings, yield) == ROUTE
			--[[
				One someone in the party has (Party Objectives on): from across the zone, whatever the Search
				Range, as taking it lets the two do it together and both get the credit
			]]
			local shared = routes.PartyHasQuest(questID)
			--[[
				One put on the route from its map marker (routes.added) counts from across the zone, as a wanted
				one does: else a giver past the Search Range would fall straight back to "far", off the route
			]]
			local isAdded = routes.added[key] ~= nil
			local blobs = (chained or shared or isWanted or isAdded) and starters or InRange(starters, start, range)
			local handling, reason = OFF, nil
			if chained or isWanted or isAdded then
				handling = ROUTE
			elseif (nearby or shared) and #blobs > 0 then
				handling, reason = Handling(QuestieDB, questID, start.zone, settings, yield)
			elseif nearby then
				--[[
					Givers in the zone but past the Search Range stay on the map, off the route, so Questie's own
					icon for them is hidden as for every other pick-up; a right-click puts one on the route
				]]
				handling, reason = Handling(QuestieDB, questID, start.zone, settings, yield)
				if handling ~= OFF then
					blobs, handling, reason = starters, MAP, handling == ROUTE and "far" or reason
				end
			end
			if handling ~= OFF then
				local info, name = QuestInfo(QuestieDB, questID)
				local task = {
					key = key,
					kind = "pickUp",
					questID = questID,
					questName = name,
					quest = info,
					ready = true,
					escort = routes.IsEscort(questID) or nil,
				}
				--[[
					One ignored stays on the map, off the route: its marker gets the gray ring, and a right-click
					on it puts it back (Routes-Map.lua)
				]]
				if handling == ROUTE and skipped[key] then
					mapOnly[#mapOnly + 1] = { task = task, blobs = blobs, instance = start.instance }
				elseif handling == ROUTE then
					task.candidates = Candidates(blobs, start, false)
					task.blobs = blobs
					task.chained = chained or nil
					task.shared = shared or nil
					task.wanted = isWanted or nil
					task.added = isAdded or nil
					onRoute[#onRoute + 1] = { task = task, yards = NearestYards(blobs, start) }
				else
					task.offRoute = reason
					mapOnly[#mapOnly + 1] = { task = task, blobs = blobs, instance = start.instance }
				end
			end
		end
		yield()
	end

	--[[
		Only as many as the log takes: the wanted quests first, then the right-clicked ones, then the party's,
		then nearest giver first; the
		quest ID breaks a tie, so the same quests always win
	]]
	table.sort(onRoute, function(a, b)
		if (a.task.wanted ~= nil) ~= (b.task.wanted ~= nil) then
			return a.task.wanted ~= nil
		end
		-- One put on the route by a right-click on its marker next, so a full log never pushes it back off
		if (a.task.added ~= nil) ~= (b.task.added ~= nil) then
			return a.task.added ~= nil
		end
		if (a.task.shared ~= nil) ~= (b.task.shared ~= nil) then
			return a.task.shared ~= nil
		end
		if a.yards ~= b.yards then
			return a.yards < b.yards
		end
		return a.task.questID < b.task.questID
	end)
	--[[
		Past the nearest MAX_CHAIN_STARTS planned whole, a quest from across the zone waits for a later plan,
		on the map off the route ("far") as any giver past the Search Range is, so Questie's own icon for it is
		hidden too; one within the Search Range is picked up as any other nearby
	]]
	local chainStarts, added = {}, 0
	local free = FreeQuestSlots(log)
	for _, entry in ipairs(onRoute) do
		local task = entry.task
		local starters -- A chain start past the limit with no giver in range: all its givers
		if task.chained and #chainStarts >= routes.MAX_CHAIN_STARTS then
			starters = task.blobs
			task.chained = nil
			task.blobs = (task.shared or task.wanted or task.added) and task.blobs
				or nearby and InRange(task.blobs, start, range)
				or {}
			task.candidates = #task.blobs > 0 and Candidates(task.blobs, start, false) or nil
		end
		if starters and not task.candidates and #starters > 0 then
			task.offRoute = "far"
			mapOnly[#mapOnly + 1] = { task = task, blobs = starters, instance = start.instance }
		elseif added < free and task.candidates then
			added = added + 1
			nodes[#nodes + 1] = task
			if task.chained then
				chainStarts[#chainStarts + 1] = task
			end
		elseif task.blobs and #task.blobs > 0 then
			--[[
				One the log has no room for stays on the map, off the route, so Questie's own icon for it is
				hidden as for every other pick-up; a right-click on it puts it on the route ahead of the rest
			]]
			task.offRoute = "full"
			task.candidates, task.chained = nil, nil
			mapOnly[#mapOnly + 1] = { task = task, blobs = task.blobs, instance = start.instance }
		end
	end
	return chainStarts
end

-- Quest Types to Pick Up Along the Route's settings, in the signature's order
local TYPE_SETTINGS = { "pickUpElite", "pickUpPvP", "pickUpDungeon", "pickUpRaid", "pickUpEscort", "pickUpOtherZone" }

--[[
	What the settings add to the route's signature: the player's level, as Questie offers more quests with
	each and Easiest First holds back those above it, and each What to Route choice. With Your Quests Only
	only the asked-for pick-ups, the level and Route Focus count, as Route Focus still orders the log's
	quests. The set of available quests near enough to matter is worked out again with every plan
]]
function routes.LocalQuestSignature()
	local settings = routes.Settings()
	local wantedIDs = {}
	for questID in pairs(WantedPickUps()) do
		if routes.HasGiverHere(questID) then -- Not one for another zone, planned once the player gets there
			wantedIDs[#wantedIDs + 1] = questID
		end
	end
	-- The pick-ups put on the route from the map count as Zone Info's do, but those for another zone (routes.IsChangeHere)
	for key, entry in pairs(routes.added) do
		if routes.IsChangeHere(entry.zone) then
			wantedIDs[#wantedIDs + 1] = key
		end
	end
	table.sort(wantedIDs, function(a, b)
		return tostring(a) < tostring(b)
	end)
	local wanted = "wanted=" .. table.concat(wantedIDs, ",")
	if not routes.PlansPickUps() then
		return table.concat({
			"no-local:" .. wanted,
			tostring(UnitLevel("player")),
			tostring(settings.routeFocus),
		}, ":")
	end
	local types = {}
	for _, key in ipairs(TYPE_SETTINGS) do
		types[#types + 1] = settings[key] and "1" or "0"
	end
	return table.concat({
		wanted,
		routes.PlanAhead(),
		tostring(UnitLevel("player")),
		tostring(routes.LocalQuestRange()),
		tostring(settings.highestQuestLevel),
		tostring(settings.lowestQuestLevel),
		table.concat(types),
		tostring(settings.routeFocus),
	}, ":")
end
