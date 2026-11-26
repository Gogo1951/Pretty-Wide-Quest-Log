local _, ns = ...

-- The address of a quest's Wowhead page, before its quest ID
ns.WOWHEAD_QUEST_URL = "https://www.wowhead.com/classic/quest="

--[[
How We Got the Data

Last Validated
	2026-11-25, wago.tools, WoW Forever 1.60.1.71139

Notes
	- The page the quest log's Wowhead link opens, with the quest ID added on the end
	  (Features/Wowhead-Link.lua), in the part of the site for this client.
	- No game table holds a web address, so the game tables have nothing to check it against.
	- WoW Forever's quests from Classic Era use Classic Era's part of the site. QuestieDB also lists 1,678
	  quests of WoW Forever's own and links them to Wowhead's Forever part of the site (wowhead.com/forever).

SQL (CMaNGOS)
	None.

Wowhead
	https://www.wowhead.com/classic

wago.tools
	None.

QuestieDB
	https://raw.githubusercontent.com/Questie/QuestieDB/master/src/corrections/Forever/generated/foreverBaseQuest.lua
]]
