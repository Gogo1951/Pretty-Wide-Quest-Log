local _, ns = ...

-- City map ID = zone map ID, -- City: Zone
ns.CITY_ZONE_MAP_IDS = {
	[84] = 37, -- Stormwind City: Elwynn Forest
	[85] = 1, -- Orgrimmar: Durotar
	[87] = 27, -- Ironforge: Dun Morogh
	[88] = 7, -- Thunder Bluff: Mulgore
	[89] = 57, -- Darnassus: Teldrassil
	[90] = 18, -- Undercity: Tirisfal Glades
	[998] = 18, -- Undercity: Tirisfal Glades
	[103] = 97, -- The Exodar: Azuremyst Isle
	[110] = 94, -- Silvermoon City: Eversong Woods
	[111] = 108, -- Shattrath City: Terokkar Forest
}

ns.WORLD_ROOT_MAP_IDS = {
	946, -- Cosmic
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
	Never. Copied from Data/Mists/.

Notes
	- CITY_ZONE_MAP_IDS: the six old-world capitals, plus The Exodar, Silvermoon City and Shattrath City, each
	  city's own map ID to the map ID of the zone it sits in (Features/Routes/Routes-Geography.lua). The game files
	  these cities under the continent, so their parent maps don't say which zone holds them. Undercity has two
	  maps, 90 and 998, both in Tirisfal Glades.
	- WORLD_ROOT_MAP_IDS: the Cosmic map, which holds Outland, and Azeroth, whose continents Zone Info's zone menu
	  lists (Features/Zone-Info-Data.lua).
	- NOT_FLIGHT_PATH_NPC_IDS: flight masters that are no flight path to discover, the druids' own to Moonglade:
	  Bunthen Plainswind in Thunder Bluff and Silva Fil'naveth in Rut'theran Village
	  (Features/Routes/Routes-Flights.lua).

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	None.

QuestieDB
	None.
]]
