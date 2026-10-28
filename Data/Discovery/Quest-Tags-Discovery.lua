local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

-- [QuestInfo ID] = Suffix Kind, -- QuestInfo Name
ns.QUEST_TAG_SUFFIXES = {
	[1] = "ELITE", -- Elite
	[41] = "PVP", -- PvP
	[62] = "RAID", -- Raid
	[81] = "DUNGEON", -- Dungeon
}

--[[
How We Got the Data

Last Validated
	2026-10-28, Season of Discovery 1.15.9.70576

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
	https://wago.tools/db2/QuestInfo?build=1.15.9.70576

QuestieDB
	None.
]]
