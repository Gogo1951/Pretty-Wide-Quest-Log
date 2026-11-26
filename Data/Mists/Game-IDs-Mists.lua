local _, ns = ...

-- City map ID = zone map ID, -- City: Zone
ns.CITY_ZONE_MAP_IDS = {
	[84] = 37, -- Stormwind City: Elwynn Forest
	[85] = 1, -- Orgrimmar: Durotar
	[87] = 27, -- Ironforge: Dun Morogh
	[88] = 7, -- Thunder Bluff: Mulgore
	[89] = 57, -- Darnassus: Teldrassil
	[998] = 18, -- Undercity: Tirisfal Glades
	[103] = 97, -- The Exodar: Azuremyst Isle
	[110] = 94, -- Silvermoon City: Eversong Woods
	[111] = 108, -- Shattrath City: Terokkar Forest
}

-- City map ID = { { x, y, facing }, ... }, -- City: its gates onto its zone, as Leatrix Maps places them
ns.CITY_EXITS = {}

-- Zone map ID = linked zone map ID, -- Zone: Linked Zone
ns.LINKED_ZONE_MAP_IDS = {}

ns.WORLD_ROOT_MAP_IDS = {
	946, -- Cosmic
	947, -- Azeroth
}

-- npcID = true, -- Flight Master
ns.NOT_FLIGHT_PATH_NPC_IDS = {
	[11798] = true, -- Bunthen Plainswind
	[11800] = true, -- Silva Fil'naveth
}

-- Quest ID = quest ID that hands out an item it needs, -- Quest: Sub-Quest
ns.SUB_QUEST_IDS = {
	[812] = 813, -- Need for a Cure: Finding the Antidote
}

--[[
How We Got the Data

Last Validated
	2026-11-25, wago.tools, MoP Classic 5.5.4.71089

Notes
	- CITY_ZONE_MAP_IDS: the six old-world capitals, plus The Exodar, Silvermoon City and Shattrath City, each
	  city's own map ID to the map ID of the zone it sits in (Features/Routes/Routes-Geography.lua). The game files
	  these cities under the continent, so their parent maps don't say which zone holds them. Undercity is map
	  998 on this client; its old map, 90, is gone.
	- CITY_EXITS: none. Leatrix Maps draws no zone crossing arrows in the cities on this client.
	- LINKED_ZONE_MAP_IDS: none. Cataclysm merged Alterac Mountains into Hillsbrad Foothills, the pair the
	  older flavors link (Features/Routes/Routes-Geography.lua).
	- WORLD_ROOT_MAP_IDS: the Cosmic map, which holds Outland, and Azeroth, whose continents Zone Info's zone menu
	  lists (Features/Zone-Info-Data.lua).
	- NOT_FLIGHT_PATH_NPC_IDS: flight masters that are no flight path to discover, the druids' own to Moonglade:
	  Bunthen Plainswind in Thunder Bluff and Silva Fil'naveth in Rut'theran Village
	  (Features/Routes/Routes-Flights.lua).
	- SUB_QUEST_IDS: quests that need an item only another quest hands out, each quest's ID to that sub-quest's
	  (Features/Routes/Routes-Sub-Quests.lua). While the quest is in the log and the sub-quest isn't turned in,
	  the route does the sub-quest first and holds every waypoint of the quest it's for until then.
	- Found in QuestieDB: a sub-quest Questie lists as a child of the quest, offered only while the quest is
	  in the log, whose reward is an item the quest asks for, with no drop or vendor for that item.
	- QuestieDB lists no quest giver on this client for Need for a Cure or Finding the Antidote, so the row
	  doesn't come into play here, nor for any other pair the older clients carry. The only quests here with
	  sub-quests that hand out their items, the Hallow's End treats for Jesper and Spoops and Up To The
	  Challenge, need several each, and a row holds one.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/UiMap?build=5.5.4.71089

QuestieDB
	https://raw.githubusercontent.com/Questie/QuestieDB/master/data/MoP/mopNpcDB.lua
	https://raw.githubusercontent.com/Questie/QuestieDB/master/data/MoP/mopQuestDB.lua
	https://raw.githubusercontent.com/Questie/QuestieDB/master/data/MoP/mopItemDB.lua
]]
