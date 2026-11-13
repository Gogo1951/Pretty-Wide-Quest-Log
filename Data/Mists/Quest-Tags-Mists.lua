local _, ns = ...

-- [QuestInfo ID] = Suffix Kind, -- QuestInfo Name
ns.QUEST_TAG_SUFFIXES = {
	[1] = "GROUP", -- Group
	[41] = "PVP", -- PvP
	[62] = "RAID", -- Raid
	[81] = "DUNGEON", -- Dungeon
	[85] = "DUNGEON", -- Heroic
	[88] = "RAID", -- Raid (10)
	[89] = "RAID", -- Raid (25)
	[294] = "DUNGEON", -- Celestial
}

--[[
How We Got the Data

Last Validated
	2026-11-13, MoP Classic 5.5.4.70631

Notes
	- The quest tags that put a letter after a quest's level, D for a dungeon, R for a raid, P for PvP, G for a
	  group quest and E for an elite one, in the quest list, the quest chain and a quest giver's
	  list of quests (ns.QuestSuffix in Features/Quest-Display.lua). A quest with no tag here but flagged elite
	  gets E there too.
	- Keyed by the client's QuestInfo ID, the tag ID GetQuestTagInfo returns. ID 1 is Elite on Classic Era data
	  (Classic Era, Season of Discovery and WoW Forever) and Group from TBC on, so the same ID takes a different
	  letter by folder.
	- Heroic and Celestial, MoP Classic's harder dungeon difficulties, count as dungeons, and Raid (10) and
	  Raid (25) as raids. Celestial (294) is MoP Classic's own tag, which Retail's QuestInfo table lacks.
	- Class, World Event, Legendary, Escort, Scenario and Account put no letter after a level, so they're
	  left out. A scenario is none of the five kinds the quest level legend explains.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/QuestInfo?build=5.5.4.70631
	https://wago.tools/db2/QuestInfo?build=12.1.5.70783

QuestieDB
	None.
]]
