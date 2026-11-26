local _, ns = ...

--[[
	Routes: a quest item the player needs and doesn't have. A quest such as The Demon Seed hands its work to
	an item (Questie's sourceItemId and requiredSourceItems): a Flawed Power Stone to carry to the altar. One
	that runs out (Routes-Timed-Items.lua) is gone from the bags, and the quest can't be done without
	another. So while a quest isn't done and such an item isn't in the bags, getting one is a node of its own,
	where Questie says it drops, is looted from an object or is sold in the zone, and every objective of the
	quest waits on it. An item with nowhere to get it here (one only the quest giver hands out) adds nothing
]]

local routes = ns.routes

local AddSpawns = routes.AddSpawns
local NewPoints = routes.NewPoints
local Cluster = routes.Cluster
local Candidates = routes.Candidates

local function Query(query, id, field)
	if type(query) ~= "function" then
		return nil
	end
	local ok, value = pcall(query, id, field)
	return ok and value or nil
end

local function List(value)
	return type(value) == "table" and value or {}
end

-- The items a quest hands its work to, by Questie: not its item objectives, which are nodes already
local neededItems = {}
local function NeededItems(questID)
	local items = neededItems[questID]
	if items then
		return items
	end
	items = {}
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if QuestieDB then
		local source = Query(QuestieDB.QueryQuestSingle, questID, "sourceItemId")
		if type(source) == "number" and source > 0 then
			items[#items + 1] = source
		end
		for _, itemID in pairs(List(Query(QuestieDB.QueryQuestSingle, questID, "requiredSourceItems"))) do
			if type(itemID) == "number" and itemID > 0 and itemID ~= source then
				items[#items + 1] = itemID
			end
		end
	end
	neededItems[questID] = items
	return items
end

local function HasItem(itemID)
	local ok, count = pcall(C_Item.GetItemCount, itemID)
	return ok and (tonumber(count) or 0) > 0
end

--[[
	The quests in the log not done yet missing an item they need, each quest ID to a list of the item IDs.
	Nothing for a dungeon or raid quest, whose work is inside
]]
local function MissingItems()
	local missing = {}
	for questID, quest in pairs(routes.QuestLog()) do
		if type(quest) == "table" and routes.QuestState(quest) == 0 and not routes.IsInstanceQuest(questID) then
			for _, itemID in ipairs(NeededItems(questID)) do
				if not HasItem(itemID) then
					missing[questID] = missing[questID] or {}
					table.insert(missing[questID], itemID)
				end
			end
		end
	end
	return missing
end

--[[
	Where an item is got in the zone, as blobs: every creature that drops it, object that holds it and vendor
	that sells it. Worked out once an item and zone, as spawns don't move
]]
local blobCache = {}
local function ItemBlobs(itemID, start, yield)
	local cached = blobCache[itemID]
	if cached and cached.zone == start.zone and cached.instance == start.instance then
		return cached.blobs
	end
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local points = NewPoints()
	if QuestieDB then
		local NPC, Object, Item = QuestieDB.QueryNPCSingle, QuestieDB.QueryObjectSingle, QuestieDB.QueryItemSingle
		for _, field in ipairs({ "npcDrops", "vendors" }) do
			for _, npcID in ipairs(List(Query(Item, itemID, field))) do
				local spawns = Query(NPC, npcID, "spawns")
				if type(spawns) == "table" then
					AddSpawns(points, spawns, Query(NPC, npcID, "name"), start, yield)
				end
			end
		end
		for _, objectID in ipairs(List(Query(Item, itemID, "objectDrops"))) do
			local spawns = Query(Object, objectID, "spawns")
			if type(spawns) == "table" then
				AddSpawns(points, spawns, Query(Object, objectID, "name"), start, yield)
			end
		end
	end
	local blobs = Cluster(points, yield)
	blobs.spawns = { x = points.x, y = points.y, count = points.count }
	blobCache[itemID] = { zone = start.zone, instance = start.instance, blobs = blobs }
	return blobs
end

-- What the item is called: the game's name, in the player's language, else Questie's
local function ItemName(itemID)
	local name = C_Item.GetItemInfo(itemID)
	if type(name) == "string" and name ~= "" then
		return name
	end
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	return QuestieDB and Query(QuestieDB.QueryItemSingle, itemID, "name") or tostring(itemID)
end

--[[
	Adds a node for each item a quest in the log needs and the player doesn't have (MissingItems), keyed
	questID:item<itemID>, an objective shaped as Questie's own for the arrow, the map and their tooltips (its
	name, 0 / 1), and makes each of that quest's objective nodes wait on it. A timed quest's is urgent too
]]
function routes.AddMissingItemNodes(nodes, start, yield)
	local missing = MissingItems()
	if not next(missing) then
		return
	end
	local skipped = routes.skipped
	local objectivesOf = {}
	for _, node in ipairs(nodes) do
		if node.kind == "objective" and not node.party and not node.predicted and missing[node.questID] then
			objectivesOf[node.questID] = objectivesOf[node.questID] or {}
			table.insert(objectivesOf[node.questID], node)
		end
	end
	local log = routes.QuestLog()
	for questID, itemIDs in pairs(missing) do
		local quest = log[questID]
		local objectives = objectivesOf[questID] or {}
		local example = objectives[1] or {}
		for _, itemID in ipairs(itemIDs) do
			local key = questID .. ":item" .. itemID
			local blobs = not skipped[key] and ItemBlobs(itemID, start, yield)
			if blobs and #blobs > 0 then
				local node = {
					key = key,
					kind = "objective",
					questID = questID,
					questName = quest and quest.name or tostring(questID),
					quest = quest,
					objective = {
						Description = ItemName(itemID),
						Icon = Questie and Questie.ICON_TYPE_LOOT,
						Color = example.objective and example.objective.Color,
						Collected = 0,
						Needed = 1,
						Completed = false,
						questId = questID,
					},
					candidates = Candidates(blobs, start, true),
					blobs = blobs,
					spawns = blobs.spawns,
					urgent = example.urgent,
					turnInDistance = example.turnInDistance,
					item = itemID,
				}
				nodes[#nodes + 1] = node
				for _, objective in ipairs(objectives) do
					local requires = { node }
					for _, required in ipairs(objective.requires or {}) do
						requires[#requires + 1] = required
					end
					objective.requires = requires
				end
			end
			yield()
		end
	end
end

--[[
	What missing items add to the route's signature: each quest missing one and which, so the route is
	planned again the moment an item runs out or a new one is in the bags
]]
function routes.MissingItemSignature()
	local parts = {}
	for questID, itemIDs in pairs(MissingItems()) do
		parts[#parts + 1] = questID .. ":" .. table.concat(itemIDs, "+")
	end
	table.sort(parts)
	return "missing:" .. table.concat(parts, ",")
end
