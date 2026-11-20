local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

-- The address of a quest's Wowhead page, before its quest ID
ns.WOWHEAD_QUEST_URL = "https://www.wowhead.com/classic/quest="

--[[
How We Got the Data

Last Validated
	2026-11-20, wago.tools, Season of Discovery 1.15.9.70576

Notes
	- The page the quest log's Wowhead link opens, with the quest ID added on the end
	  (Features/Wowhead-Link.lua), in the part of the site for this client.
	- No game table holds a web address, so the game tables have nothing to check it against.
	- Season of Discovery's quests are on Classic Era's part of the site.

SQL (CMaNGOS)
	None.

Wowhead
	https://www.wowhead.com/classic

wago.tools
	None.

QuestieDB
	None.
]]
