local _, ns = ...

--[[
	Routes: flight paths the player hasn't discovered, as objectives on the route, with Discover Flight
	Paths (showFlightPaths) on. Every flight master of the player's faction in the zone whose flight path
	the character doesn't have is a node of kind "flightPath", at the flight master, as a turn-in is at its
	NPC.

	Which flight paths a character has is kept for the character (ns.db.char.routesFlightMasters, by the
	flight master's NPC ID): no call says it away from a flight master. Opening a flight map marks the
	flight master the player is talking to, and every other flight path the map shows as known, each
	matched to the Questie flight master standing within MATCH_REACH of where the map puts it. The map's
	places are only trusted once the flight master the player stands at lines up with the player: a client
	whose flight map is drawn differently from its world map marks only that one. "New flight path
	discovered" marks the flight master the player is talking to as well.

	A character that had flight paths before this was tracked would be sent to every flight master, so on
	each continent no flight path is put on the route until a flight map there has been read: one Questie
	could match and that lined up (routesFlightMapSeen, by HereBeDragons instance). A flight map shows only
	its own continent's flight paths. A character at NEW_CHARACTER_LEVEL or below when first seen is taken
	to have none anywhere (routesFlightMapSeen.all), so a new one is sent to its first flight master
	straight away
]]

local routes = ns.routes
local L = ns.L

local AddSpawns = routes.AddSpawns
local NewPoints = routes.NewPoints
local Cluster = routes.Cluster
local Candidates = routes.Candidates

-- The flight master icon from the minimap's tracking menu, on the waypoint's marker (Routes-Map.lua)
routes.FLIGHT_ICON = "Interface\\Minimap\\tracking\\flightmaster"

local MATCH_REACH = 150 -- Yards from where the flight map puts a flight path that its flight master can stand
local NEW_CHARACTER_LEVEL = 10 -- At or below, a character first seen is taken to have no flight paths
--[[
	Flight masters that are no flight path to discover: the druids' own to Moonglade, Bunthen Plainswind in
	Thunder Bluff and Silva Fil'naveth in Rut'theran Village
]]
local NOT_FLIGHT_PATHS = { [11798] = true, [11800] = true }

local function NoYield() end

--------------------------------------------------------------------------------
-- What the character knows
--------------------------------------------------------------------------------

local function Saved()
	return ns.db and ns.db.char
end

-- Whether the character has the flight master's flight path, as far as has been seen
function routes.IsFlightMasterKnown(npcID)
	local saved = Saved()
	return saved ~= nil and type(saved.routesFlightMasters) == "table" and saved.routesFlightMasters[npcID] == true
end

-- The continents whose flight map the character has read, by HereBeDragons instance, and all for a new character
local function Seen()
	local saved = Saved()
	return saved and type(saved.routesFlightMapSeen) == "table" and saved.routesFlightMapSeen or nil
end

--[[
	Whether the character's flight paths are tracked on a continent: its flight map read, or a new
	character. With no instance given, the one the player is on
]]
local function IsTracked(instance)
	local seen = Seen()
	if not seen then
		return false
	end
	if instance == nil then
		instance = select(3, routes.PlayerPosition())
	end
	return seen.all == true or (instance ~= nil and seen[instance] == true)
end
routes.IsFlightTracked = IsTracked

-- How many flight masters the character is known to have, for the signature and Routes Context
function routes.KnownFlightCount()
	local saved = Saved()
	return saved and type(saved.routesFlightMasters) == "table" and routes.CountEntries(saved.routesFlightMasters) or 0
end

-- A new character starts with nothing to forget, so the route can send it to its first flight master
routes.OnLogin(function()
	local seen = Seen()
	if seen and next(seen) == nil and UnitLevel("player") <= NEW_CHARACTER_LEVEL then
		seen.all = true
	end
end)

-- Marks flight masters known; plans again where any is new
local function MarkKnown(npcIDs)
	local saved = Saved()
	if not (saved and type(saved.routesFlightMasters) == "table") then
		return
	end
	local changed = false
	for npcID in pairs(npcIDs) do
		if not saved.routesFlightMasters[npcID] then
			saved.routesFlightMasters[npcID] = true
			changed = true
		end
	end
	if changed then
		routes.RequestPlan()
	end
end

-- The NPC ID of the creature the player is talking to, or has targeted, where the client says
local function TalkingTo()
	for _, unit in ipairs({ "npc", "target" }) do
		local guid = UnitGUID(unit)
		if ns.IsReadable(guid) and type(guid) == "string" then
			local kind, _, _, _, _, npcID = strsplit("-", guid)
			if kind == "Creature" and tonumber(npcID) then
				return tonumber(npcID)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Flight masters, from Questie's database
--------------------------------------------------------------------------------

local function IsFriendly(QuestieDB, friendlyTo)
	if type(QuestieDB.IsFriendlyToPlayer) == "function" then
		local ok, friendly = pcall(QuestieDB.IsFriendlyToPlayer, friendlyTo)
		return ok and friendly == true
	end
	local faction = UnitFactionGroup("player")
	return friendlyTo == nil
		or friendlyTo == "AH"
		or (friendlyTo == "H" and faction == "Horde")
		or (friendlyTo == "A" and faction == "Alliance")
end

--[[
	The flight masters of the player's faction, each { npcID, name, spawns }, from Questie's townsfolk list,
	which it builds before it starts. Worked out once, as a faction doesn't change; nothing is kept while
	Questie has no list yet, so the next plan asks again
]]
local flightMasters

local function FlightMasters()
	if flightMasters then
		return flightMasters
	end
	local Townsfolk = ns.ImportQuestieModule("Townsfolk")
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local ids = Townsfolk and type(Townsfolk.townsfolk) == "table" and Townsfolk.townsfolk["Flight Master"]
	if type(ids) ~= "table" or #ids == 0 or not (QuestieDB and type(QuestieDB.QueryNPCSingle) == "function") then
		return {}
	end
	local list = {}
	for _, npcID in ipairs(ids) do
		if not NOT_FLIGHT_PATHS[npcID] then
			local okFaction, friendlyTo = pcall(QuestieDB.QueryNPCSingle, npcID, "friendlyToFaction")
			local okSpawns, spawns = pcall(QuestieDB.QueryNPCSingle, npcID, "spawns")
			if okFaction and okSpawns and type(spawns) == "table" and IsFriendly(QuestieDB, friendlyTo) then
				local okName, name = pcall(QuestieDB.QueryNPCSingle, npcID, "name")
				list[#list + 1] = { npcID = npcID, name = okName and name or nil, spawns = spawns }
			end
		end
	end
	flightMasters = list
	return list
end
routes.FlightMasters = FlightMasters -- For Routes Context

-- Every place a flight master stands, by continent ({ [instance] = points }), worked out once
local function Places(master)
	if not master.places then
		master.places = {}
		routes.AddWorldSpawns(master.places, master.spawns, master.name, NoYield)
	end
	return master.places
end

-- The flight master standing nearest a place in world yards, within MATCH_REACH, or nothing
local function FlightMasterAt(x, y, instance)
	local nearest, nearestSquared = nil, MATCH_REACH * MATCH_REACH
	for _, master in ipairs(FlightMasters()) do
		local points = Places(master)[instance]
		if points then
			for i = 1, points.count do
				local dx, dy = points.x[i] - x, points.y[i] - y
				local squared = dx * dx + dy * dy
				if squared <= nearestSquared then
					nearest, nearestSquared = master, squared
				end
			end
		end
	end
	return nearest
end

--------------------------------------------------------------------------------
-- The flight map
--------------------------------------------------------------------------------

-- The map the flight map is drawn on: the client's word, else the continent the player is on
local function TaxiMapID()
	if type(GetTaxiMapID) == "function" then
		local ok, mapID = pcall(GetTaxiMapID)
		if ok and type(mapID) == "number" and mapID > 0 then
			return mapID
		end
	end
	local mapID = C_Map.GetBestMapForUnit("player")
	local info = mapID and C_Map.GetMapInfo(mapID)
	while info and info.mapType and info.mapType > Enum.UIMapType.Continent and (info.parentMapID or 0) > 0 do
		mapID = info.parentMapID
		info = C_Map.GetMapInfo(mapID)
	end
	return mapID
end

-- Where the flight map puts a flight path, 0-1 across the map it's drawn on
local function NodePosition(node)
	local position = node.position
	if type(position) == "table" and type(position.x) == "number" and type(position.y) == "number" then
		return position.x, position.y
	end
	if node.slotIndex and type(TaxiNodePosition) == "function" then
		local ok, x, y = pcall(TaxiNodePosition, node.slotIndex)
		if ok and type(x) == "number" and type(y) == "number" then
			return x, y
		end
	end
end

--[[
	What the last flight map said, for Routes Context: how many flight paths it showed as known, how many
	of them were matched to a flight master, and whether its places lined up with the world's
]]
routes.lastFlightMap = nil

--[[
	The flight paths a flight map shows as known (Current or Reachable), each matched to its flight master
	where the map's places line up: the one the player stands at must fall within MATCH_REACH of them.
	Returns the continent's instance when the map was read, lined up and Questie had flight masters to
	match, so it can count as seen; nothing when it couldn't be read
]]
local function ReadFlightMap(known)
	local hereBeDragons = routes.HereBeDragons()
	local mapID = TaxiMapID()
	if not (hereBeDragons and mapID and C_TaxiMap and type(C_TaxiMap.GetAllTaxiNodes) == "function") then
		return
	end
	local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes, mapID)
	if not (ok and type(nodes) == "table") then
		return
	end
	local states = Enum.FlightPathState or {}
	local current, unreachable = states.Current or 0, states.Unreachable or 2
	local places, linedUp = {}, false
	local playerX, playerY, playerInstance = routes.PlayerPosition()
	for _, node in ipairs(nodes) do
		local x, y = NodePosition(node)
		if node.state ~= unreachable and x then
			local worldX, worldY, instance = hereBeDragons:GetWorldCoordinatesFromZone(x, y, mapID)
			if worldX then
				places[#places + 1] = { x = worldX, y = worldY, instance = instance }
				if node.state == current and playerX and instance == playerInstance then
					local dx, dy = worldX - playerX, worldY - playerY
					linedUp = dx * dx + dy * dy <= MATCH_REACH * MATCH_REACH
				end
			end
		end
	end
	local matched = 0
	if linedUp then
		for _, place in ipairs(places) do
			local master = FlightMasterAt(place.x, place.y, place.instance)
			if master and not known[master.npcID] then
				known[master.npcID] = true
				matched = matched + 1
			end
		end
	end
	routes.lastFlightMap = { shown = #places, matched = matched, linedUp = linedUp, mapID = mapID }
	if linedUp and #FlightMasters() > 0 then
		return playerInstance
	end
end

-- Core's EVENTS: a flight map opened, at a flight master
function routes:OnTaximapOpened()
	local saved = Saved()
	if not saved then
		return
	end
	local known = {}
	local npcID = TalkingTo()
	if npcID then
		known[npcID] = true
	end
	local instance = ReadFlightMap(known)
	local seen = Seen()
	if instance and seen and not seen[instance] then
		seen[instance] = true
		routes.RequestPlan()
	end
	MarkKnown(known)
end

-- Core's EVENTS: "New flight path discovered!", said while talking to its flight master
function routes:OnUiInfoMessage(_, message)
	if ERR_NEWTAXIPATH and message == ERR_NEWTAXIPATH then
		local npcID = TalkingTo()
		if npcID then
			MarkKnown({ [npcID] = true })
		end
	end
end

--------------------------------------------------------------------------------
-- Nodes
--------------------------------------------------------------------------------

-- A flight master's blobs in the zone, worked out once for the zone they were worked out in
local function FlightMasterBlobs(master, start, yield)
	local cached = master.blobs
	if cached and cached.zone == start.zone and cached.instance == start.instance then
		return cached.blobs
	end
	local points = NewPoints()
	AddSpawns(points, master.spawns, master.name, start, yield, true)
	local blobs = Cluster(points, yield)
	master.blobs = { zone = start.zone, instance = start.instance, blobs = blobs }
	return blobs
end

--[[
	Adds a "flightPath" node to nodes for every flight master of the player's faction in the zone whose
	flight path the character doesn't have, and the player hasn't ignored. Each is
	{ key, kind, npcID, flightMaster, candidates, blobs, ready }, flightMaster its name
]]
function routes.AddFlightPathNodes(nodes, start, yield)
	if not routes.Settings().showFlightPaths or not IsTracked(start.instance) then
		return
	end
	local skipped = routes.skipped
	for _, master in ipairs(FlightMasters()) do
		local key = "flight:" .. master.npcID
		if not skipped[key] and not routes.IsFlightMasterKnown(master.npcID) then
			local blobs = FlightMasterBlobs(master, start, yield)
			if #blobs > 0 then
				nodes[#nodes + 1] = {
					key = key,
					kind = "flightPath",
					npcID = master.npcID,
					flightMaster = master.name or "",
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
	What flight paths add to the route's signature: the setting, whether they're tracked yet on this
	continent, how many the character has, and how many flight masters Questie lists, so the route is
	planned again as any changes
]]
function routes.FlightPathSignature()
	if not routes.Settings().showFlightPaths then
		return "no-flights"
	end
	return table.concat({
		"flights",
		IsTracked() and "tracked" or "untracked",
		tostring(routes.KnownFlightCount()),
		tostring(#FlightMasters()),
	}, ":")
end

-- What a flight path is called on the Quest Arrow's menu and in chat: "Devrak Flight Path"
function routes.FlightPathLabel(task)
	return string.format(L["ROUTES_MENU_FLIGHT_PATH"], task.flightMaster or "")
end
