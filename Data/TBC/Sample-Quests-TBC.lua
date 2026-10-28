local _, ns = ...

-- questId, -- Quest Name
ns.SAMPLE_QUEST_IDS = {
	168, -- Collecting Memories
	167, -- Oh Brother. . .
	214, -- Red Silk Bandanas
}

ns.SAMPLE_DUNGEON_AREA_ID = 1581 -- The Deadmines
ns.SAMPLE_ZONE_AREA_ID = 40 -- Westfall

--[[
How We Got the Data

Last Validated
	2026-10-28, TBC Anniversary 2.5.6.70577

Notes
	- Three quests from The Deadmines, a dungeon every current client has, that the Quality of Life panel's
	  Example lines name: the share-failed whisper, the dungeon quest announcement and the share prints
	  (Options/Options-Quality-of-Life.lua). Their names come from the client by ID, so the trailing names here
	  are labels only.
	- SAMPLE_DUNGEON_AREA_ID is The Deadmines' area, whose name the share prints' Examples ask the client for
	  (C_Map.GetAreaInfo).
	- SAMPLE_ZONE_AREA_ID is Westfall's area, a zone every current client has, whose name the Seconds Between
	  Shares Example asks the client for (C_Map.GetAreaInfo), so that Example shows a zone's quests being shared.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	https://www.wowhead.com/tbc/quest=168
	https://www.wowhead.com/tbc/quest=167
	https://www.wowhead.com/tbc/quest=214

wago.tools
	https://wago.tools/db2/QuestV2?build=2.5.6.70577
	https://wago.tools/db2/AreaTable?build=2.5.6.70577

QuestieDB
	None.
]]
