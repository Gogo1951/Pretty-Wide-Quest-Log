local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

-- The address of a quest's Wowhead page, before its quest ID
ns.WOWHEAD_QUEST_URL = "https://www.wowhead.com/classic/quest="

--[[
How We Got the Data

Last Validated
	2026-11-07, Classic Era 1.15.9.70576

Notes
	- The page the quest log's Wowhead link opens, with the quest ID added on the end
	  (Features/Wowhead-Link.lua), in the part of the site for this client.

SQL (CMaNGOS)
	None.

Wowhead
	https://www.wowhead.com/classic

wago.tools
	None.

QuestieDB
	None.
]]
