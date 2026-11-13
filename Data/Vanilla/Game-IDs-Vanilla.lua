local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

-- City map ID = zone map ID, -- City: Zone
ns.CITY_ZONE_MAP_IDS = {
	[1453] = 1429, -- Stormwind City: Elwynn Forest
	[1454] = 1411, -- Orgrimmar: Durotar
	[1455] = 1426, -- Ironforge: Dun Morogh
	[1456] = 1412, -- Thunder Bluff: Mulgore
	[1457] = 1438, -- Darnassus: Teldrassil
	[1458] = 1420, -- Undercity: Tirisfal Glades
}

ns.WORLD_ROOT_MAP_IDS = {
	947, -- Azeroth
}

-- npcID = true, -- Flight Master
ns.NOT_FLIGHT_PATH_NPC_IDS = {
	[11798] = true, -- Bunthen Plainswind
	[11800] = true, -- Silva Fil'naveth
}

--[[
How We Got the Data

Last Validated
	2026-11-13, Classic Era 1.15.9.70576

Notes
	- CITY_ZONE_MAP_IDS: the six old-world capitals, each city's own map ID to the map ID of the zone it sits in
	  (Features/Routes/Routes-Geography.lua). The game files these cities under the continent, so their parent
	  maps don't say which zone holds them.
	- WORLD_ROOT_MAP_IDS: Azeroth, whose continents Zone Info's zone menu lists (Features/Zone-Info-Data.lua).
	  Classic Era has no Cosmic map (946), which only holds Outland from TBC on.
	- NOT_FLIGHT_PATH_NPC_IDS: flight masters that are no flight path to discover, the druids' own to Moonglade:
	  Bunthen Plainswind in Thunder Bluff and Silva Fil'naveth in Rut'theran Village
	  (Features/Routes/Routes-Flights.lua).

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/UiMap?build=1.15.9.70576

QuestieDB
	None.
]]
