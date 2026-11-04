local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

-- The address of a quest's Wowhead page, before its quest ID
ns.WOWHEAD_QUEST_URL = "https://www.wowhead.com/classic/quest="

--[[
How We Got the Data

Last Validated
	Never.

Notes
	- The page the quest log's Wowhead link opens, with the quest ID added on the end
	  (Features/Wowhead-Link.lua), in the part of the site for this client.
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
