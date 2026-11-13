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

-- What Routes-Chains.lua shares from here
routes.pickUpHelpers = {
	QueryQuest = QueryQuest,
	QuestInfo = QuestInfo,
	StarterBlobs = StarterBlobs,
	IsTakenOrDone = IsTakenOrDone,
	IsTooLow = IsTooLow,
	IsElsewhere = IsElsewhere,
	Handling = Handling,
	ROUTE = ROUTE,
}

--[[
	Adds a "pickUp" node to nodes for every quest the player can pick up nearby that the settings put on the
	route. Each is { key, kind, questID, questName, quest, candidates, blobs, ready, escort }, quest a small
	table of its name and level for the arrow's title line. The map-only ones go on routes.mapOnlyPickUps.

	With Predictive Questing Routes on (predictiveRoutes), a quest that can be done in the zone from start
	to finish (routes.IsChainQuest) counts from anywhere in the zone, not only within the Search Range, and
	Routes-Chains.lua plans its objectives, its turn-in and the quests that follow it. Those are returned,
	nearest giver first. A quest Zone Info's + asked for (task.wanted) counts from anywhere in the zone too,
	whatever its level or kind, ahead of every other. With Local Available Quests off, those are the only
	quests to pick up. No more
	quests are picked up than the log has room for, nearest first
]]
function routes.AddLocalQuestNodes(nodes, start, log, yield)
	local mapOnly = {}
	routes.mapOnlyPickUps = mapOnly
	local settings = routes.Settings()
	local nearby, planChains = settings.showLocalQuests, settings.predictiveRoutes
	local wanted = WantedPickUps()
	if not (nearby or planChains or next(wanted)) then
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
			and not skipped[key]
			and not IsTakenOrDone(questID, log)
			and StarterBlobs(QuestieDB, questID, start, yield)
		local isWanted = wanted[questID] == true
		if
			starters
			and #starters > 0
			and not routes.IsInstanceQuest(questID)
			and (isWanted or not IsTooLow(QuestieDB, questID, settings.localQuestLevel))
		then
			local chained = planChains
				and #starters > 0
				and routes.IsChainQuest(QuestieDB, questID, start, yield)
				and Handling(QuestieDB, questID, start.zone, settings, yield) == ROUTE
			--[[
				One someone in the party has (Party Objectives on): from across the zone, whatever the Search
				Range, as taking it lets the two do it together and both get the credit
			]]
			local shared = routes.PartyHasQuest(questID)
			local blobs = (chained or shared or isWanted) and starters or InRange(starters, start, range)
			local handling, reason = OFF, nil
			if chained or isWanted then
				handling = ROUTE
			elseif (nearby or shared) and #blobs > 0 then
				handling, reason = Handling(QuestieDB, questID, start.zone, settings, yield)
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
				if handling == ROUTE then
					task.candidates = Candidates(blobs, start, false)
					task.blobs = blobs
					task.chained = chained or nil
					task.shared = shared or nil
					task.wanted = isWanted or nil
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
		Only as many as the log takes: the party's quests first, then nearest giver first; the quest ID breaks a
		tie, so the same quests always win
	]]
	table.sort(onRoute, function(a, b)
		if (a.task.wanted ~= nil) ~= (b.task.wanted ~= nil) then
			return a.task.wanted ~= nil
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
		and one within the Search Range is picked up as any other nearby
	]]
	local chainStarts, added = {}, 0
	local free = FreeQuestSlots(log)
	for _, entry in ipairs(onRoute) do
		local task = entry.task
		if task.chained and #chainStarts >= routes.MAX_CHAIN_STARTS then
			task.chained = nil
			task.blobs = (task.shared or task.wanted) and task.blobs
				or nearby and InRange(task.blobs, start, range)
				or {}
			task.candidates = #task.blobs > 0 and Candidates(task.blobs, start, false) or nil
		end
		if added < free and task.candidates then
			added = added + 1
			nodes[#nodes + 1] = task
			if task.chained then
				chainStarts[#chainStarts + 1] = task
			end
		end
	end
	return chainStarts
end

--[[
	What the settings add to the route's signature: the player's level, as Questie offers more quests with
	each, and each Local Available Quests choice. The set of available quests near enough to matter is
	worked out again with every plan
]]
function routes.LocalQuestSignature()
	local settings = routes.Settings()
	local wantedIDs = {}
	for questID in pairs(WantedPickUps()) do
		wantedIDs[#wantedIDs + 1] = questID
	end
	table.sort(wantedIDs)
	local wanted = "wanted=" .. table.concat(wantedIDs, ",")
	if not (settings.showLocalQuests or settings.predictiveRoutes) then
		return "no-local:" .. wanted
	end
	return table.concat({
		wanted,
		settings.showLocalQuests and "local" or "chains-only",
		tostring(UnitLevel("player")),
		tostring(routes.LocalQuestRange()),
		tostring(settings.localQuestLevel),
		tostring(settings.localEscortQuests),
		tostring(settings.localGroupQuests),
		tostring(settings.localOtherZoneQuests),
		settings.predictiveRoutes and "chains" or "no-chains",
	}, ":")
end
