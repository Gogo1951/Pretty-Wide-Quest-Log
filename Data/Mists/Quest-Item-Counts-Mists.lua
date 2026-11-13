local _, ns = ...

-- A line a quest, "Quest ID:Item ID,Count,Item ID,Count,...". One string, not a table a quest, so
-- the counts cost a small part of the memory (Needed in Features/Zone-Info-Data.lua reads it)
ns.QUEST_ITEM_COUNTS = ""

--[[
How We Got the Data

Last Validated
	2026-11-13, MoP Classic 5.5.4.70631

Notes
	- How many of each item a quest asks the player to bring, for Zone Info's Things to Bring column
	  (Features/Zone-Info-Data.lua): "0 / 4" beside each item. Questie's database names a quest's items but
	  not how many, so the counts come from here.
	- One line a quest, its items in pairs, item ID then count, as quest_template's ReqItemId and
	  ReqItemCount columns have them. Items the quest gives the player to use (ReqSourceId) aren't here.
	- A quest missing from here, one of the server's own or one the dump doesn't have, takes its count from
	  the quest's objective text where the item is named after a number, and from the quest log once the
	  player has the quest.
	- No open database for this client's quests is current, and Cataclysm reworked the old world's quests,
	  so an older dump's counts would be wrong for many of them. The table is empty: counts come from the
	  objective text and the quest log alone.

SQL (CMaNGOS)
	None.

Wowhead
	None.

wago.tools
	None.

QuestieDB
	None.
]]
