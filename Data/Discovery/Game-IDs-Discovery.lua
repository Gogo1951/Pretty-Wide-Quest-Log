local _, ns = ...

if not ns.IS_DISCOVERY then
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

-- City map ID = { { x, y, facing }, ... }, -- City: its gates onto its zone, as Leatrix Maps places them
ns.CITY_EXITS = {
	[1453] = { -- Stormwind City
		{ 62.3, 72.3, 3.8 },
	},
	[1454] = { -- Orgrimmar
		{ 52.4, 83.7, 3.0 },
	},
	[1455] = { -- Ironforge
		{ 21.9, 77.5, 2.2 },
	},
	[1456] = { -- Thunder Bluff
		{ 35.7, 62.8, 2.0 },
		{ 51.3, 31.3, 5.7 },
	},
	[1457] = { -- Darnassus
		{ 30.3, 41.4, 1.5 },
		{ 86.9, 35.8, 4.8 },
	},
	[1458] = { -- Undercity
		{ 66.2, 5.2, 0.0 },
	},
}

-- Zone map ID = linked zone map ID, -- Zone: Linked Zone
ns.LINKED_ZONE_MAP_IDS = {
	[1416] = 1424, -- Alterac Mountains: Hillsbrad Foothills
	[1424] = 1416, -- Hillsbrad Foothills: Alterac Mountains
}

ns.WORLD_ROOT_MAP_IDS = {
	947, -- Azeroth
}

-- npcID = true, -- Flight Master
ns.NOT_FLIGHT_PATH_NPC_IDS = {
	[11798] = true, -- Bunthen Plainswind
	[11800] = true, -- Silva Fil'naveth
}

-- Quest ID = quest ID that hands out an item it needs, -- Quest: Sub-Quest
ns.SUB_QUEST_IDS = {
	[592] = 593, -- Saving Yenniku: Filling the Soul Gem
	[812] = 813, -- Need for a Cure: Finding the Antidote
	[1712] = 1714, -- Cyclonian: Essence of the Exile
	[3909] = 4041, -- The Videre Elixir: The Videre Elixir
	[6571] = 6581, -- Warsong Supplies: Warsong Saw Blades
	[7643] = 7645, -- Ancient Equine Spirit: Manna-Enriched Horse Feed
	[8507] = 8508, -- Field Duty: Field Duty Papers
	[8731] = 8732, -- Field Duty: Field Duty Papers
}

--[[
How We Got the Data

Last Validated
	2026-11-25, wago.tools, Season of Discovery 1.15.9.70576

Notes
	- CITY_ZONE_MAP_IDS: the six old-world capitals, each city's own map ID to the map ID of the zone it sits in
	  (Features/Routes/Routes-Geography.lua). The game files these cities under the continent, so their parent
	  maps don't say which zone holds them.
	- CITY_EXITS: each city's gates onto the zone it's in, from Leatrix Maps 1.15.166's zone crossing arrows (Leatrix_Maps_Icons.lua,
	  "Arrow" rows on the city's map): x and y on the city's map (0-100), and the arrow's facing in radians, pointing
	  out. Only gates onto the city's own zone: not Orgrimmar's west gate to the Barrens or Shattrath's to Nagrand. The
	  route goes through one where it leaves or enters the city (Features/Routes/Routes-Cities.lua).
	- LINKED_ZONE_MAP_IDS: zones that play as one, each way round: Alterac Mountains and Hillsbrad Foothills,
	  whose quests run back and forth between them (Features/Routes/Routes-Geography.lua). Cataclysm merged
	  them into one map, so Mists and Mainline have none.
	- WORLD_ROOT_MAP_IDS: Azeroth, whose continents Zone Info's zone menu lists (Features/Zone-Info-Data.lua).
	  Season of Discovery has no Cosmic map (946), which only holds Outland from TBC on.
	- NOT_FLIGHT_PATH_NPC_IDS: flight masters that are no flight path to discover, the druids' own to Moonglade:
	  Bunthen Plainswind in Thunder Bluff and Silva Fil'naveth in Rut'theran Village
	  (Features/Routes/Routes-Flights.lua).
	- SUB_QUEST_IDS: quests that need an item only another quest hands out, each quest's ID to that sub-quest's
	  (Features/Routes/Routes-Sub-Quests.lua). While the quest is in the log and the sub-quest isn't turned in,
	  the route does the sub-quest first and holds every waypoint of the quest it's for until then.
	- Found in QuestieDB: a sub-quest Questie lists as a child of the quest, offered only while the quest is
	  in the log, whose reward is an item the quest asks for, with no drop or vendor for that item.
	- Left out: quests that need several sub-quests, since a row holds one (The Green Hills of Stranglethorn's
	  four chapters, The Warsong Reports' three updates, and the Hallow's End treats for Jesper and Spoops, four
	  each), and Call of Water's Water Sapta and Catch of the Day's Fish in a Bucket, which Questie's corrections
	  no longer tie to those quests.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/UiMap?build=1.15.9.70576

QuestieDB
	https://raw.githubusercontent.com/Questie/QuestieDB/master/data/Classic/classicNpcDB.lua
	https://raw.githubusercontent.com/Questie/QuestieDB/master/data/Classic/classicQuestDB.lua
	https://raw.githubusercontent.com/Questie/QuestieDB/master/data/Classic/classicItemDB.lua
	https://raw.githubusercontent.com/Questie/QuestieDB/master/src/corrections/Era/classicQuestFixes.lua
	https://raw.githubusercontent.com/Questie/QuestieDB/master/src/corrections/Sod/sodBaseQuests.lua
	https://raw.githubusercontent.com/Questie/QuestieDB/master/src/corrections/Sod/sodQuestFixes.lua
]]
