local _, ns = ...

-- questId, -- Quest Name
ns.SAMPLE_QUEST_IDS = {
	27756, -- The Foreman
	27758, -- The Carpenter
	27781, -- The Machination
}

ns.SAMPLE_DUNGEON_AREA_ID = 1581 -- The Deadmines
ns.SAMPLE_ZONE_AREA_ID = 40 -- Westfall

--[[
How We Got the Data

Last Validated
	Never.

Notes
	- Three quests from The Deadmines, a dungeon every current client has, that the Quality of Life panel's
	  Example lines name: the share-failed whisper, the dungeon quest announcement and the share prints
	  (Options/Options-Quality-of-Life.lua). Their names come from the client by ID, so the trailing names here
	  are labels only.
	- The dungeon's quests were replaced when Cataclysm rebuilt it, so these are the Alliance quests given
	  inside, not the older ones the Classic Era and TBC files use (167, 168, 214), which have no quest giver
	  in QuestieDB's Mists data.
	- SAMPLE_DUNGEON_AREA_ID is The Deadmines' area, whose name the share prints' Examples ask the client for
	  (C_Map.GetAreaInfo).
	- SAMPLE_ZONE_AREA_ID is Westfall's area, a zone every current client has, whose name the Seconds Between
	  Shares Example asks the client for (C_Map.GetAreaInfo), so that Example shows a zone's quests being shared.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	https://www.wowhead.com/mop-classic/quest=27756
	https://www.wowhead.com/mop-classic/quest=27758
	https://www.wowhead.com/mop-classic/quest=27781

wago.tools
	https://wago.tools/db2/QuestV2?build=5.5.4.70631
	https://wago.tools/db2/AreaTable?build=5.5.4.70631

QuestieDB
	https://raw.githubusercontent.com/Questie/QuestieDB/master/data/MoP/mopQuestDB.lua
]]
