local _, ns = ...

-- [QuestInfo ID] = Suffix Kind, -- QuestInfo Name
ns.QUEST_TAG_SUFFIXES = {
	[1] = "GROUP", -- Group
	[41] = "PVP", -- PvP
	[62] = "RAID", -- Raid
	[81] = "DUNGEON", -- Dungeon
	[85] = "DUNGEON", -- Heroic
}

--[[
How We Got the Data

Last Validated
	Never. Copied from Data/TBC/.

Notes
	- The quest tags that put a letter after a quest's level, D for a dungeon, R for a raid, P for PvP, G for a
	  group quest and E for an elite one, in the quest list, the quest chain, the zone menu and a quest giver's
	  list of quests (ns.QuestSuffix in Features/Quest-Display.lua). A quest with no tag here but flagged elite
	  gets E there too.
	- Keyed by the client's QuestInfo ID, the tag ID GetQuestTagInfo returns. ID 1 is Elite on Classic Era data
	  (Classic Era, Season of Discovery and WoW Forever) and Group from TBC on, so the same ID takes a different
	  letter by folder.
	- Heroic counts as a dungeon, and Raid (10) and Raid (25) as raids.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	None.

QuestieDB
	None.
]]
