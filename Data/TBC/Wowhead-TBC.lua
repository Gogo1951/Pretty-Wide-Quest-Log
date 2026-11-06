local _, ns = ...

-- The address of a quest's Wowhead page, before its quest ID
ns.WOWHEAD_QUEST_URL = "https://www.wowhead.com/tbc/quest="

--[[
How We Got the Data

Last Validated
	2026-11-06, TBC Anniversary 2.5.6.70577

Notes
	- The page the quest log's Wowhead link opens, with the quest ID added on the end
	  (Features/Wowhead-Link.lua), in the part of the site for this client.

SQL (CMaNGOS)
	None.

Wowhead
	https://www.wowhead.com/tbc

wago.tools
	None.

QuestieDB
	None.
]]
