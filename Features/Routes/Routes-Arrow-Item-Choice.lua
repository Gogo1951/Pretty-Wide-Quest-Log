local _, ns = ...

--[[
	Routes: which items get a Use Item button on the Quest Arrow (Routes-Arrow-Items.lua), and where. For each
	quest the arrow lists, up to two: the client's own quest item where it has one
	(GetQuestLogSpecialItemInfo), then the items Questie's database names for the quest (the item it
	starts with, the items it needs to carry, its item objectives), each only while it's in the bags and
	can be used or worn. Once the quest is done, only a client quest item that says to stay shows. One
	item two quests share shows once, by the first
]]

local routes = ns.routes

local SPACE = ns.LAYOUT.SPACE
local frame = routes.arrowFrame
local titleRows = routes.arrowTitleRows

local BUTTON_SIZE = 32 -- A quest's title and its first objective tall, on the doubling scale
local SMALL_BUTTON_SIZE = 16 -- Beside a quest that's one line, so it stays clear of the next quest's
local ITEMS_PER_QUEST = 2

local function Owned(itemID)
	local ok, count = pcall(C_Item.GetItemCount, itemID)
	return ok and type(count) == "number" and count > 0
end

-- Used from the bags (a spell on it) or worn, as Questie's tracker counts them
local function IsUsable(itemID)
	local ok, spell = pcall(C_Item.GetItemSpell, itemID)
	if ok and spell then
		return true
	end
	local worn, equippable = pcall(C_Item.IsEquippableItem, itemID)
	return worn and equippable == true
end

--[[
	The client's own item for the quest, and whether it stays once the quest is done. Only clients from
	Wrath on have it; Classic Era and TBC go by Questie's database alone
]]
local function ClientItem(questID)
	if not GetQuestLogSpecialItemInfo then
		return nil
	end
	local index = ns.GetLogIndexForQuestID(questID)
	if not index or index <= 0 then
		return nil
	end
	local ok, link, _, _, showWhenComplete = pcall(GetQuestLogSpecialItemInfo, index)
	local itemID = ok and type(link) == "string" and tonumber(link:match("item:(%d+)"))
	if itemID then
		return itemID, showWhenComplete
	end
end

--[[
	The items Questie's database names for a quest: the one it starts with, the ones it needs carried, and
	its item objectives, in that order. They never change, so each quest's are kept once Questie has it
]]
local databaseItems = {}

local function DatabaseItems(questID)
	if databaseItems[questID] then
		return databaseItems[questID]
	end
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local ok, quest = false, nil
	if QuestieDB and type(QuestieDB.GetQuest) == "function" then
		ok, quest = pcall(QuestieDB.GetQuest, questID)
	end
	if not (ok and type(quest) == "table") then
		return {}
	end
	local items = {}
	local function Add(itemID)
		if type(itemID) == "number" and not tContains(items, itemID) then
			items[#items + 1] = itemID
		end
	end
	Add(quest.sourceItemId)
	for _, itemID in ipairs(type(quest.requiredSourceItems) == "table" and quest.requiredSourceItems or {}) do
		Add(itemID)
	end
	for _, objective in ipairs(type(quest.ObjectiveData) == "table" and quest.ObjectiveData or {}) do
		if type(objective) == "table" and objective.Type == "item" then
			Add(objective.Id)
		end
	end
	databaseItems[questID] = items
	return items
end

-- The items to show for one of the player's quests, in order, each in the bags
local function QuestItems(questID, quest)
	local items = {}
	local complete = routes.QuestState(quest) == 1
	local clientItem, showWhenComplete = ClientItem(questID)
	if clientItem and (not complete or showWhenComplete) and Owned(clientItem) then
		items[1] = clientItem
	end
	if not complete then
		for _, itemID in ipairs(DatabaseItems(questID)) do
			if not tContains(items, itemID) and Owned(itemID) and IsUsable(itemID) then
				items[#items + 1] = itemID
			end
		end
	end
	return items
end

--[[
	What the buttons should be now, each { itemID, size, x, top, dim }: x from the arrow frame's left and
	top down from its top, in its own units. In front of each quest's title, outside the list: the first
	button's right edge SPACE.GROUP before the block's left edge, a second item SPACE.NEAR further left,
	tops level with the title's. The block's left edge follows its widest line, so the buttons move with it,
	out of combat only (Routes-Arrow-Items.lua). A party member's quest has none, as only the player's bags
	count
]]
local function Wanted()
	local wanted = {}
	local settings = routes.Settings()
	if not (frame:IsShown() and settings.showQuests and settings.showItemButtons) then
		return wanted
	end
	local log, shown = routes.QuestLog(), {}
	for _, row in ipairs(titleRows.rows) do
		local quest = log[row.questID]
		if type(quest) == "table" and not quest.party and routes.IsOnQuest(row.questID) then
			local size = row.room + SPACE.GROUP >= BUTTON_SIZE + SPACE.LINE and BUTTON_SIZE or SMALL_BUTTON_SIZE
			local placed = 0
			for _, itemID in ipairs(QuestItems(row.questID, quest)) do
				if placed < ITEMS_PER_QUEST and not shown[itemID] then
					shown[itemID] = true
					wanted[#wanted + 1] = {
						itemID = itemID,
						size = size,
						x = titleRows.left - SPACE.GROUP - size - placed * (size + SPACE.NEAR),
						top = row.top,
						dim = row.dim,
					}
					placed = placed + 1
				end
			end
		end
	end
	return wanted
end
routes.WantedItemButtons = Wanted -- For the buttons (Routes-Arrow-Items.lua)
