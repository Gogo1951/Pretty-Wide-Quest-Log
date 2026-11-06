local _, ns = ...

-- The address of a quest's Wowhead page, before its quest ID
ns.WOWHEAD_QUEST_URL = "https://www.wowhead.com/classic/quest="

--[[
How We Got the Data

Last Validated
	2026-11-06, WoW Forever 1.60.1.70790

Notes
	- The page the quest log's Wowhead link opens, with the quest ID added on the end
	  (Features/Wowhead-Link.lua), in the part of the site for this client.
	- WoW Forever's quests are Classic Era's, so it uses Classic Era's part of the site.

SQL (CMaNGOS)
	None.

Wowhead
	https://www.wowhead.com/classic

wago.tools
	None.

QuestieDB
	None.
]]
