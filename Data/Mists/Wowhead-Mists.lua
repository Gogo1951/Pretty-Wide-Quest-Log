local _, ns = ...

-- The address of a quest's Wowhead page, before its quest ID
ns.WOWHEAD_QUEST_URL = "https://www.wowhead.com/mop-classic/quest="

--[[
How We Got the Data

Last Validated
	2026-11-07, MoP Classic 5.5.4.70631

Notes
	- The page the quest log's Wowhead link opens, with the quest ID added on the end
	  (Features/Wowhead-Link.lua), in the part of the site for this client.

SQL (CMaNGOS)
	None.

Wowhead
	https://www.wowhead.com/mop-classic

wago.tools
	None.

QuestieDB
	None.
]]
