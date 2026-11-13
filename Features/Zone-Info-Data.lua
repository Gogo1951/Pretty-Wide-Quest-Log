local _, ns = ...

--[[
	Zone Info's lists for one zone (Zone-Info.lua draws them), worked out from Questie a few quests a frame.

	Quests to Pick Up: quests Questie shows as available (its AvailableQuests module, the set the route's
	pick-ups read) that work in the zone but start outside it, so the player knows what they could be on
	before they go: "Patrick Garrett in Undercity". A quest whose giver stands in the zone is left out, as
	the route and Questie's own icons show it once the player is there. Each needs an NPC or object to
	start it, isn't gray, and isn't a dungeon or raid quest.

	Things to Bring: every tradeable item the zone's quests ask for, apart from the list above. The zone's
	quests are those available now (wherever their giver stands), those in the log, and those of a
	profession the character knows at any skill, then every quest that follows them, at any level, for the
	character's race and class. Items come from the ones that work in the zone. Questie's database names a
	quest's items but not how many, so the count comes from the quest log when the quest is in it, then
	from QUEST_ITEM_COUNTS (Data/{Game}/Quest-Item-Counts-{Game}.lua), then from the quest's objective
	text. A quest item, or one that binds when picked up, can't be bought, so it's left out once the game
	has loaded it.

	A quest works in a zone when it's filed under the zone, its giver or turn-in stands there, or one of its
	creatures, objects, kill credits or explore spots is there. An item that drops counts for the zone only
	when the zone holds a fair share of what drops it (ZONE_DROP_SHARE), so cloth, potions and herbs that
	drop everywhere never pull a quest in. Questie's spawns don't move, so each answer is kept for the zone
]]

local data = {}
ns.zoneInfoData = data

local QUEST_FLAG_SHARABLE = 8 -- The game's quest flag for a quest players can share
local ITEM_CLASS_QUEST = 12 -- Enum.ItemClass.Questitem, on every client
local BIND_ON_PICKUP, BIND_QUEST = 1, 4 -- GetItemInfo's bind types that can't be traded
local FEW_DROP_SOURCES = 4 -- Up to this many things drop an item and one in the zone is enough
local ZONE_DROP_SHARE = 1 / 3 -- Otherwise this share of them must be in the zone
local MAX_DROP_SOURCES = 64 -- An item more things drop than this drops everywhere, so no zone's
local MAX_FOLLOW_UP_DEPTH = 8 -- Quests followed at most after any one of the zone's
local MAX_CACHED_ZONES = 4 -- Zones whose answers are kept at once
local BUDGET_MS = 4 -- Of each frame, for working the lists out

local EMPTY = {}

local function List(value)
	return type(value) == "table" and value or EMPTY
end

local function HasFlag(mask, flag)
	return type(mask) == "number" and mask % (flag * 2) >= flag
end

local function Query(query, id, field)
	if type(query) ~= "function" or not id then
		return nil
	end
	local ok, value = pcall(query, id, field)
	return ok and value or nil
end

local function QuestieDatabase()
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	return QuestieDB and type(QuestieDB.QueryQuestSingle) == "function" and QuestieDB or nil
end

local function QueryQuest(QuestieDB, questID, field)
	return Query(QuestieDB.QueryQuestSingle, questID, field)
end

-- Questie's set of available quests, quest ID to true, or nil before Questie has one
local function AvailableQuestIDs()
	local AvailableQuests = ns.ImportQuestieModule("AvailableQuests")
	local available = AvailableQuests and AvailableQuests.__availableQuests
	return type(available) == "table" and available or nil
end

local function CompletedQuests()
	local complete = Questie and Questie.db and Questie.db.char and Questie.db.char.complete
	return type(complete) == "table" and complete or EMPTY
end

-- The professions the character knows, Questie's skill ID to { name, rank }
local function Professions()
	local QuestieProfessions = ns.ImportQuestieModule("QuestieProfessions")
	if QuestieProfessions and type(QuestieProfessions.GetPlayerProfessions) == "function" then
		local ok, professions = pcall(QuestieProfessions.GetPlayerProfessions, QuestieProfessions)
		if ok and type(professions) == "table" then
			return professions
		end
	end
	return EMPTY
end

local GetItemInfo = C_Item.GetItemInfo
local GetItemCount = C_Item.GetItemCount
local GetItemIcon = C_Item.GetItemIconByID

--------------------------------------------------------------------------------
-- Zones
--------------------------------------------------------------------------------

-- The zone a map is, or is in: itself or the nearest map above it that's a zone; nil above any zone
function data.ZoneOf(mapID)
	local seen = {}
	while mapID and mapID > 0 and not seen[mapID] do
		seen[mapID] = true
		local info = C_Map.GetMapInfo(mapID)
		if not info then
			return nil
		end
		if info.mapType == Enum.UIMapType.Zone then
			return mapID
		end
		if info.mapType and info.mapType < Enum.UIMapType.Zone then
			return nil
		end
		mapID = info.parentMapID
	end
	return nil
end

function data.ZoneName(mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	return info and info.name or nil
end

function data.PlayerZone()
	return data.ZoneOf(MapUtil.GetDisplayableMapForPlayer())
end

local function UiMapOfArea(areaID)
	local ZoneDB = ns.ImportQuestieModule("ZoneDB")
	if not (ZoneDB and type(ZoneDB.GetUiMapIdByAreaId) == "function" and type(areaID) == "number") then
		return nil
	end
	local ok, mapID = pcall(ZoneDB.GetUiMapIdByAreaId, ZoneDB, areaID)
	return ok and mapID or nil
end

local function IsDungeonArea(areaID)
	local ZoneDB = ns.ImportQuestieModule("ZoneDB")
	if not (ZoneDB and type(ZoneDB.IsDungeonZone) == "function" and type(areaID) == "number") then
		return false
	end
	local ok, dungeon = pcall(ZoneDB.IsDungeonZone, areaID)
	return ok and dungeon == true
end

-- The zones the quests in the log are filed under, A to Z
function data.LogZones()
	local QuestieDB = QuestieDatabase()
	local found, zones = {}, {}
	if not (QuestieDB and ns.routes) then
		return zones
	end
	for questID in pairs(ns.routes.QuestLog()) do
		local sort = QueryQuest(QuestieDB, questID, "zoneOrSort")
		local zone = type(sort) == "number" and sort > 0 and data.ZoneOf(UiMapOfArea(sort))
		if zone and not found[zone] then
			found[zone] = true
			zones[#zones + 1] = zone
		end
	end
	table.sort(zones, function(a, b)
		return (data.ZoneName(a) or "") < (data.ZoneName(b) or "")
	end)
	return zones
end

--[[
	The zones with the most quests the character could pick up now, filed there, most first: Questie's own
	level, faction and class filters already chose them, so this is where there's work for the character
]]
function data.AvailableZones(most)
	local QuestieDB, available = QuestieDatabase(), AvailableQuestIDs()
	local zones = {}
	if not (QuestieDB and available) then
		return zones
	end
	local helpers = ns.routes and ns.routes.pickUpHelpers
	local counts = {}
	for questID in pairs(available) do
		local sort = QueryQuest(QuestieDB, questID, "zoneOrSort")
		local gray = helpers and helpers.IsTooLow(QuestieDB, questID, "green")
		local zone = not gray and type(sort) == "number" and sort > 0 and data.ZoneOf(UiMapOfArea(sort))
		if zone then
			counts[zone] = (counts[zone] or 0) + 1
		end
	end
	for zone in pairs(counts) do
		zones[#zones + 1] = zone
	end
	table.sort(zones, function(a, b)
		if counts[a] ~= counts[b] then
			return counts[a] > counts[b]
		end
		return (data.ZoneName(a) or "") < (data.ZoneName(b) or "")
	end)
	for index = #zones, (most or #zones) + 1, -1 do
		zones[index] = nil
	end
	return zones, counts
end

--[[
	Every continent the client has, each { mapID, name, zones }, its zones A to Z, the continents too.
	Worked out once: the maps don't change in a session
]]
local continents

function data.Continents()
	if continents then
		return continents
	end
	continents = {}
	local seen, zoneSeen = {}, {}
	for _, root in ipairs(ns.WORLD_ROOT_MAP_IDS) do -- The Cosmic map, holding Outland, and Azeroth
		for _, info in ipairs(C_Map.GetMapChildrenInfo(root, Enum.UIMapType.Continent, true) or EMPTY) do
			if not seen[info.mapID] then
				seen[info.mapID] = true
				local entry = { mapID = info.mapID, name = info.name, zones = {} }
				for _, child in ipairs(C_Map.GetMapChildrenInfo(info.mapID, Enum.UIMapType.Zone, false) or EMPTY) do
					if not zoneSeen[child.mapID] and child.name and child.name ~= "" then
						zoneSeen[child.mapID] = true
						entry.zones[#entry.zones + 1] = { mapID = child.mapID, name = child.name }
					end
				end
				table.sort(entry.zones, function(a, b)
					return a.name < b.name
				end)
				if #entry.zones > 0 then
					continents[#continents + 1] = entry
				end
			end
		end
	end
	table.sort(continents, function(a, b)
		return a.name < b.name
	end)
	return continents
end

--------------------------------------------------------------------------------
-- What's in a zone
--------------------------------------------------------------------------------

-- Each zone's answers: { mapID, areas, npcs, objects, items, quests, starters }, the latest last
local zoneCache = {}

local function ZoneAnswers(mapID)
	for index, answers in ipairs(zoneCache) do
		if answers.mapID == mapID then
			table.remove(zoneCache, index)
			zoneCache[#zoneCache + 1] = answers
			return answers
		end
	end
	local answers = { mapID = mapID, areas = {}, npcs = {}, objects = {}, items = {}, quests = {}, starters = {} }
	zoneCache[#zoneCache + 1] = answers
	if #zoneCache > MAX_CACHED_ZONES then
		table.remove(zoneCache, 1)
	end
	return answers
end

local function AreaHere(zone, areaID)
	local found = zone.areas[areaID]
	if found == nil then
		local mapID = UiMapOfArea(areaID)
		found = mapID and ns.routes.IsInZone(mapID, zone.mapID) or false
		zone.areas[areaID] = found
	end
	return found
end

-- Whether a Questie spawn table ({ [areaID] = { { x, y }, ... } }) has a spawn in the zone
local function SpawnsHere(zone, spawns)
	for areaID, list in pairs(List(spawns)) do
		if type(list) == "table" and #list > 0 and AreaHere(zone, areaID) then
			return true
		end
	end
	return false
end

local function NPCHere(zone, QuestieDB, npcID)
	if type(npcID) ~= "number" then
		return false
	end
	local found = zone.npcs[npcID]
	if found == nil then
		found = SpawnsHere(zone, Query(QuestieDB.QueryNPCSingle, npcID, "spawns"))
		zone.npcs[npcID] = found
	end
	return found
end

local function ObjectHere(zone, QuestieDB, objectID)
	if type(objectID) ~= "number" then
		return false
	end
	local found = zone.objects[objectID]
	if found == nil then
		found = SpawnsHere(zone, Query(QuestieDB.QueryObjectSingle, objectID, "spawns"))
		zone.objects[objectID] = found
	end
	return found
end

local function AnyNPCHere(zone, QuestieDB, ids)
	for _, id in ipairs(List(ids)) do
		if NPCHere(zone, QuestieDB, id) then
			return true
		end
	end
	return false
end

local function AnyObjectHere(zone, QuestieDB, ids)
	for _, id in ipairs(List(ids)) do
		if ObjectHere(zone, QuestieDB, id) then
			return true
		end
	end
	return false
end

-- Whether an item drops in the zone, from enough of what drops it that it's the zone's (ZONE_DROP_SHARE)
local function ItemHere(zone, QuestieDB, itemID, yield)
	if type(itemID) ~= "number" then
		return false
	end
	local found = zone.items[itemID]
	if found ~= nil then
		return found
	end
	local npcs = List(Query(QuestieDB.QueryItemSingle, itemID, "npcDrops"))
	local objects = List(Query(QuestieDB.QueryItemSingle, itemID, "objectDrops"))
	local total = #npcs + #objects
	found = false
	if total > 0 and total <= MAX_DROP_SOURCES then
		local here = 0
		for _, id in ipairs(npcs) do
			here = here + (NPCHere(zone, QuestieDB, id) and 1 or 0)
			yield()
		end
		for _, id in ipairs(objects) do
			here = here + (ObjectHere(zone, QuestieDB, id) and 1 or 0)
			yield()
		end
		found = here > 0 and (total <= FEW_DROP_SOURCES or here / total >= ZONE_DROP_SHARE)
	end
	zone.items[itemID] = found
	return found
end

-- Whether an NPC or object that starts the quest stands in the zone
local function StarterHere(zone, QuestieDB, questID)
	local found = zone.starters[questID]
	if found == nil then
		local startedBy = List(QueryQuest(QuestieDB, questID, "startedBy"))
		found = AnyNPCHere(zone, QuestieDB, startedBy[1]) or AnyObjectHere(zone, QuestieDB, startedBy[2])
		zone.starters[questID] = found
	end
	return found
end

-- Whether the quest works in the zone: filed there, its giver, turn-in, objectives or explore spot there
local function QuestHere(zone, QuestieDB, questID, yield)
	local found = zone.quests[questID]
	if found ~= nil then
		return found
	end
	local sort = QueryQuest(QuestieDB, questID, "zoneOrSort")
	found = type(sort) == "number" and sort > 0 and AreaHere(zone, sort) or StarterHere(zone, QuestieDB, questID)
	if not found then
		local finishedBy = List(QueryQuest(QuestieDB, questID, "finishedBy"))
		found = AnyNPCHere(zone, QuestieDB, finishedBy[1]) or AnyObjectHere(zone, QuestieDB, finishedBy[2])
	end
	if not found then
		local objectives = List(QueryQuest(QuestieDB, questID, "objectives"))
		for _, entry in ipairs(List(objectives[1])) do
			found = found or NPCHere(zone, QuestieDB, type(entry) == "table" and entry[1])
		end
		for _, entry in ipairs(List(objectives[2])) do
			found = found or ObjectHere(zone, QuestieDB, type(entry) == "table" and entry[1])
		end
		for _, entry in ipairs(List(objectives[5])) do
			found = found or AnyNPCHere(zone, QuestieDB, type(entry) == "table" and entry[1])
		end
		for _, entry in ipairs(List(objectives[3])) do
			found = found or ItemHere(zone, QuestieDB, type(entry) == "table" and entry[1], yield)
		end
	end
	if not found then
		local trigger = QueryQuest(QuestieDB, questID, "triggerEnd")
		found = type(trigger) == "table" and SpawnsHere(zone, trigger[2])
	end
	found = found and true or false
	zone.quests[questID] = found
	yield()
	return found
end

--------------------------------------------------------------------------------
-- Which quests count
--------------------------------------------------------------------------------

-- A dungeon or raid quest, by its tag or the area it's filed under
local function IsDungeonQuest(QuestieDB, questID)
	if ns.routes.IsInstanceQuest(questID) then
		return true
	end
	return IsDungeonArea(QueryQuest(QuestieDB, questID, "zoneOrSort"))
end

local function PrerequisitesDone(QuestieDB, questID, complete)
	local single = List(QueryQuest(QuestieDB, questID, "preQuestSingle"))
	if #single > 0 then
		local any = false
		for _, first in ipairs(single) do
			any = any or complete[first] ~= nil
		end
		if not any then
			return false
		end
	end
	for _, raw in ipairs(List(QueryQuest(QuestieDB, questID, "preQuestGroup"))) do
		if type(raw) == "number" and not complete[math.abs(raw)] then
			return false
		end
	end
	return true
end

--[[
	Whether the character could ever take a quest, its level aside: their race and class, a profession it
	asks for known at any skill, and none of the quests it shuts out taken or done
]]
local function CouldEverTake(QuestieDB, questID, context)
	local player = ns.ImportQuestieModule("QuestiePlayer")
	for field, check in pairs({ requiredRaces = "HasRequiredRace", requiredClasses = "HasRequiredClass" }) do
		local mask = QueryQuest(QuestieDB, questID, field)
		if mask and mask ~= 0 then
			local fits = player and player[check]
			local ok, yes = false, false
			if type(fits) == "function" then
				ok, yes = pcall(fits, mask)
			end
			if not (ok and yes) then
				return false
			end
		end
	end
	local skill = QueryQuest(QuestieDB, questID, "requiredSkill")
	if type(skill) == "table" and skill[1] and not context.professions[skill[1]] then
		return false
	end
	for _, other in ipairs(List(QueryQuest(QuestieDB, questID, "exclusiveTo"))) do
		if context.complete[other] or context.log[other] then
			return false
		end
	end
	return true
end

local function IsRepeatable(QuestieDB, questID)
	if type(QuestieDB.IsRepeatable) ~= "function" then
		return false
	end
	local ok, repeatable = pcall(QuestieDB.IsRepeatable, questID)
	return ok and repeatable == true
end

--[[
	Every quest that asks for a profession, skill ID to a list of quest IDs, read from every quest Questie
	has once a session, a few a frame. A run stopped partway leaves it for the next to go on with
]]
local skillIndex = { position = 0, quests = {} }

local function SkillQuests(QuestieDB, yield)
	if skillIndex.done then
		return skillIndex.quests
	end
	if not skillIndex.ids then
		local ids = {}
		for questID in pairs(List(QuestieDB.QuestPointers)) do
			if type(questID) == "number" then
				ids[#ids + 1] = questID
			end
		end
		table.sort(ids)
		skillIndex.ids = ids
	end
	local ids = skillIndex.ids
	while skillIndex.position < #ids do
		skillIndex.position = skillIndex.position + 1
		local questID = ids[skillIndex.position]
		local skill = QueryQuest(QuestieDB, questID, "requiredSkill")
		if type(skill) == "table" and type(skill[1]) == "number" then
			local list = skillIndex.quests[skill[1]]
			if not list then
				list = {}
				skillIndex.quests[skill[1]] = list
			end
			list[#list + 1] = questID
		end
		yield()
	end
	skillIndex.done = true
	skillIndex.ids = nil -- Every quest ID, needed only while reading
	return skillIndex.quests
end

--------------------------------------------------------------------------------
-- Pick-ups the player asked for
--------------------------------------------------------------------------------

--[[
	Quests Zone Info's + put on the route, quest ID to true, for the character. The route picks each up
	from anywhere in its giver's zone (Routes-Pick-Ups.lua); taking or finishing it drops it from here
]]
function data.WantedPickUps()
	local char = ns.db and ns.db.char
	if not char then
		return EMPTY
	end
	char.zoneInfoWanted = char.zoneInfoWanted or {}
	return char.zoneInfoWanted
end

function data.IsWanted(questID)
	return data.WantedPickUps()[questID] == true
end

function data.SetWanted(questID, wanted)
	local list = data.WantedPickUps()
	if list == EMPTY then
		return
	end
	list[questID] = wanted and true or nil
	if ns.routes then
		ns.routes.RequestPlan()
	end
end

-- Drops the pick-ups the player has taken or done since
function data.PruneWanted()
	local list = data.WantedPickUps()
	if not (ns.routes and next(list)) then
		return
	end
	local log = ns.routes.QuestLog()
	for questID in pairs(list) do
		if ns.routes.pickUpHelpers.IsTakenOrDone(questID, log) then
			list[questID] = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Things to Bring
--------------------------------------------------------------------------------

-- The number before the item's name in the quest's objective text, as in "Bring 4 Buzzard Wings"
local function CountFromText(QuestieDB, questID, name)
	if not name or name == "" then
		return nil
	end
	local text = QueryQuest(QuestieDB, questID, "objectivesText")
	if type(text) == "table" then
		text = table.concat(text, " ")
	end
	if type(text) ~= "string" then
		return nil
	end
	local count = text:match("(%d+)%s+" .. name:gsub("%p", "%%%0"))
	return tonumber(count)
end

--[[
	The count QUEST_ITEM_COUNTS gives the item for the quest, nil if it has none. The table is one string, a
	line a quest, "\nQuest ID:Item ID,Count,Item ID,Count", so the quest's line is found with a plain search
]]
local function CountFromTable(questID, itemID)
	local counts = ns.QUEST_ITEM_COUNTS
	if type(counts) ~= "string" or counts == "" then
		return nil
	end
	local key = "\n" .. questID .. ":"
	local start = counts:find(key, 1, true)
	if not start then
		return nil
	end
	local lineEnd = counts:find("\n", start + #key, true) or (#counts + 1)
	for item, count in counts:sub(start + #key, lineEnd - 1):gmatch("(%d+),(%d+)") do
		if tonumber(item) == itemID then
			return tonumber(count)
		end
	end
	return nil
end

-- The item's name in the client's language; nil until the client has loaded it
local function ItemName(itemID)
	return (GetItemInfo(itemID))
end

-- How many of the item the quest asks for: from the log, the counts table, then the quest's text; nil unknown
local function Needed(QuestieDB, questID, itemID, logQuest)
	if type(logQuest) == "table" then
		for _, objective in pairs(List(logQuest.Objectives)) do
			if type(objective) == "table" and objective.Type == "item" and objective.Id == itemID then
				local needed = tonumber(objective.Needed)
				if needed and needed > 0 then
					return needed
				end
			end
		end
	end
	local listed = CountFromTable(questID, itemID)
	if listed then
		return listed
	end
	-- Questie's own name for it stands in, to find in Questie's text, while the client hasn't loaded it
	return CountFromText(QuestieDB, questID, ItemName(itemID) or Query(QuestieDB.QueryItemSingle, itemID, "name"))
end

--[[
	Whether an item can be bought or traded, as far as is known: not a quest item by Questie's database or
	the game's, and not one that binds when picked up. Until the game has loaded it, it's kept and asked for,
	and data.pendingItems, item ID to true, says the lists want working out again once it arrives. One the game
	answered it doesn't have is kept and never asked for again, so it can't set off a refresh each time
]]
data.pendingItems = {}
local unloadableItems = {}

local function IsTradeable(QuestieDB, itemID)
	if Query(QuestieDB.QueryItemSingle, itemID, "class") == ITEM_CLASS_QUEST then
		return false
	end
	local name, _, _, _, _, _, _, _, _, _, _, classID, _, bindType = GetItemInfo(itemID)
	if not name then
		if not unloadableItems[itemID] then
			if C_Item and C_Item.RequestLoadItemDataByID then
				C_Item.RequestLoadItemDataByID(itemID)
			end
			data.pendingItems[itemID] = true
		end
		return true
	end
	return classID ~= ITEM_CLASS_QUEST and bindType ~= BIND_ON_PICKUP and bindType ~= BIND_QUEST
end

-- GET_ITEM_INFO_RECEIVED: true when it's an item the lists were waiting on and it loaded
function data.ItemArrived(itemID, success)
	if not data.pendingItems[itemID] then
		return false
	end
	data.pendingItems[itemID] = nil
	if success == false then
		unloadableItems[itemID] = true
		return false
	end
	return true
end

local function AddItem(QuestieDB, items, itemID, questID, logQuest)
	if type(itemID) ~= "number" or not IsTradeable(QuestieDB, itemID) then
		return
	end
	local item = items[itemID]
	if not item then
		item = { itemID = itemID, quests = {}, questSeen = {}, need = 0 }
		items[itemID] = item
	end
	if item.questSeen[questID] then
		return
	end
	item.questSeen[questID] = true
	item.quests[#item.quests + 1] = questID
	-- One when nothing says how many: a quest that just uses an item, as Flint and Tinder, wants the one
	item.need = item.need + (Needed(QuestieDB, questID, itemID, logQuest) or 1)
end

-- The quest's items to bring, less the item that starts it, which comes with the quest (a Craftsman's Writ)
local function AddQuestItems(QuestieDB, items, questID, logQuest)
	local startItems = {}
	for _, itemID in ipairs(List(List(QueryQuest(QuestieDB, questID, "startedBy"))[3])) do
		startItems[itemID] = true
	end
	local objectives = List(QueryQuest(QuestieDB, questID, "objectives"))
	for _, entry in ipairs(List(objectives[3])) do
		local itemID = type(entry) == "table" and entry[1]
		if not startItems[itemID] then
			AddItem(QuestieDB, items, itemID, questID, logQuest)
		end
	end
	for _, itemID in ipairs(List(QueryQuest(QuestieDB, questID, "requiredSourceItems"))) do
		if not startItems[itemID] then
			AddItem(QuestieDB, items, itemID, questID, logQuest)
		end
	end
end

--------------------------------------------------------------------------------
-- The lists
--------------------------------------------------------------------------------

--[[
	Where the giver stands on the zone's own map, 0 to 100 as Questie keeps it: its first spawn in an area
	whose map is that zone. None for a spawn on a smaller map inside it, whose numbers wouldn't match the zone's
]]
local function GiverSpot(spawns, mapID)
	for areaID, list in pairs(List(spawns)) do
		local spot = List(list)[1]
		if type(spot) == "table" and spot[1] and spot[2] and UiMapOfArea(areaID) == mapID then
			return spot[1], spot[2]
		end
	end
end

-- Who gives a quest and where: the first NPC or object that starts it, the zone it stands in, and its spot there
local function Giver(QuestieDB, questID)
	local startedBy = List(QueryQuest(QuestieDB, questID, "startedBy"))
	for kind, query in pairs({ [1] = QuestieDB.QueryNPCSingle, [2] = QuestieDB.QueryObjectSingle }) do
		local id = List(startedBy[kind])[1]
		if id then
			local name = Query(query, id, "name")
			local spawns = Query(query, id, "spawns")
			local mapID = data.ZoneOf(UiMapOfArea(Query(query, id, "zoneID")))
			if not mapID then
				for areaID, list in pairs(List(spawns)) do
					if type(list) == "table" and #list > 0 then
						mapID = data.ZoneOf(UiMapOfArea(areaID))
						if mapID then
							break
						end
					end
				end
			end
			return name, mapID, GiverSpot(spawns, mapID)
		end
	end
	return nil, nil
end

local function QuestLevel(QuestieDB, questID)
	local level = QueryQuest(QuestieDB, questID, "questLevel")
	if type(level) ~= "number" or level <= 0 then
		return UnitLevel("player")
	end
	return level
end

--[[
	The lists for a zone, { mapID, quests, items, shareable }, or { mapID, unavailable = true } while
	Questie or its database hasn't loaded. quests are { questID, name, level, giver, giverMapID, giverZone,
	giverX, giverY, shareable }, by givers' zones then level then name; items { itemID, name, need, quests },
	A to Z, then the ones whose names haven't loaded, by ID
]]
local function Build(mapID, yield)
	local routes = ns.routes
	local QuestieDB, available = QuestieDatabase(), AvailableQuestIDs()
	if not (routes and QuestieDB and available and routes.IsQuestieReady()) then
		return { mapID = mapID, unavailable = true }
	end
	wipe(data.pendingItems)
	local helpers = routes.pickUpHelpers
	local zone = ZoneAnswers(mapID)
	local log = routes.QuestLog()
	local context = { complete = CompletedQuests(), log = log, professions = Professions() }
	local result = { mapID = mapID, quests = {}, items = {}, shareable = 0 }

	-- Quests to Pick Up, and the zone's quests whose items count
	local roots, rootSeen = {}, {}
	local function AddRoot(questID)
		if not rootSeen[questID] then
			rootSeen[questID] = true
			roots[#roots + 1] = questID
		end
	end
	local availableIDs = {}
	for questID in pairs(available) do
		availableIDs[#availableIDs + 1] = questID
	end
	table.sort(availableIDs)
	for _, questID in ipairs(availableIDs) do
		if
			not helpers.IsTakenOrDone(questID, log)
			and not IsDungeonQuest(QuestieDB, questID)
			and QuestHere(zone, QuestieDB, questID, yield)
		then
			--[[
				One an item starts counts only with the item in the bags: a Craftsman's Writ that might drop
				anywhere isn't a quest to plan for
			]]
			local startedBy = List(QueryQuest(QuestieDB, questID, "startedBy"))
			local hasGiver = #List(startedBy[1]) > 0 or #List(startedBy[2]) > 0
			local carried = false
			for _, itemID in ipairs(List(startedBy[3])) do
				carried = carried or data.ItemCount(itemID) > 0
			end
			if hasGiver or carried then
				AddRoot(questID)
			end
			if
				hasGiver
				and not StarterHere(zone, QuestieDB, questID)
				and not helpers.IsTooLow(QuestieDB, questID, "green")
			then
				local giver, giverMapID, giverX, giverY = Giver(QuestieDB, questID)
				local shareable = HasFlag(QueryQuest(QuestieDB, questID, "questFlags"), QUEST_FLAG_SHARABLE)
				result.quests[#result.quests + 1] = {
					questID = questID,
					name = QueryQuest(QuestieDB, questID, "name") or tostring(questID),
					level = QuestLevel(QuestieDB, questID),
					giver = giver,
					giverMapID = giverMapID,
					giverZone = data.ZoneName(giverMapID),
					giverX = giverX,
					giverY = giverY,
					shareable = shareable,
				}
				result.shareable = result.shareable + (shareable and 1 or 0)
			end
		end
		yield()
	end
	table.sort(result.quests, function(a, b)
		if (a.giverZone or "") ~= (b.giverZone or "") then
			return (a.giverZone or "~") < (b.giverZone or "~")
		end
		if a.level ~= b.level then
			return a.level < b.level
		end
		return a.name < b.name
	end)

	-- The log's quests that work here
	for questID in pairs(log) do
		if not IsDungeonQuest(QuestieDB, questID) and QuestHere(zone, QuestieDB, questID, yield) then
			AddRoot(questID)
		end
	end

	-- Quests of a profession the character knows, at any skill, that work here and they could take
	local skillQuests = SkillQuests(QuestieDB, yield)
	for skillID in pairs(context.professions) do
		for _, questID in ipairs(List(skillQuests[skillID])) do
			if
				not rootSeen[questID]
				and not helpers.IsTakenOrDone(questID, log)
				and not IsRepeatable(QuestieDB, questID)
				and CouldEverTake(QuestieDB, questID, context)
				and PrerequisitesDone(QuestieDB, questID, context.complete)
				and not IsDungeonQuest(QuestieDB, questID)
				and QuestHere(zone, QuestieDB, questID, yield)
			then
				AddRoot(questID)
			end
		end
	end

	-- Every quest that follows them, at any level, and the items of those that work here
	local followUps = routes.FollowUpIndex(QuestieDB, yield)
	local items = {}
	local queue, seen = {}, {}
	for _, questID in ipairs(roots) do
		queue[#queue + 1] = { questID, 0 }
		seen[questID] = true
	end
	local position = 0
	while position < #queue do
		position = position + 1
		local questID, depth = queue[position][1], queue[position][2]
		if depth == 0 or (not IsDungeonQuest(QuestieDB, questID) and QuestHere(zone, QuestieDB, questID, yield)) then
			AddQuestItems(QuestieDB, items, questID, log[questID])
		end
		if depth < MAX_FOLLOW_UP_DEPTH then
			local nextQuests = { unpack(List(followUps[questID])) }
			nextQuests[#nextQuests + 1] = QueryQuest(QuestieDB, questID, "nextQuestInChain")
			for _, nextID in ipairs(nextQuests) do
				if
					type(nextID) == "number"
					and nextID > 0
					and not seen[nextID]
					and not context.complete[nextID]
					and CouldEverTake(QuestieDB, nextID, context)
				then
					seen[nextID] = true
					queue[#queue + 1] = { nextID, depth + 1 }
				end
			end
		end
		yield()
	end

	for _, item in pairs(items) do
		item.questSeen = nil
		item.name = ItemName(item.itemID)
		for index, questID in ipairs(item.quests) do
			item.quests[index] = {
				questID = questID,
				name = QueryQuest(QuestieDB, questID, "name") or tostring(questID),
				level = QuestLevel(QuestieDB, questID),
			}
		end
		result.items[#result.items + 1] = item
	end
	-- By name, and the ones the client hasn't loaded yet after, by ID
	table.sort(result.items, function(a, b)
		if (a.name ~= nil) ~= (b.name ~= nil) then
			return a.name ~= nil
		end
		if a.name and a.name ~= b.name then
			return a.name < b.name
		end
		return a.itemID < b.itemID
	end)
	return result
end

--------------------------------------------------------------------------------
-- Working them out
--------------------------------------------------------------------------------

--[[
	One zone at a time, BUDGET_MS a frame: a new request drops the one underway. The callback gets the
	lists once they're done
]]
local job, onDone
local sliceStarted = 0

local function Yield()
	if debugprofilestop() - sliceStarted > BUDGET_MS then
		coroutine.yield()
	end
end

local runner = CreateFrame("Frame")
runner:Hide()
runner:SetScript("OnUpdate", function(self)
	sliceStarted = debugprofilestop()
	local ok, result = coroutine.resume(job)
	if coroutine.status(job) ~= "dead" then
		return
	end
	self:Hide()
	job = nil
	local callback = onDone
	onDone = nil
	if not ok then
		geterrorhandler()(result)
	elseif callback then
		callback(result)
	end
end)

function data.Request(mapID, callback)
	job = coroutine.create(function()
		return Build(mapID, Yield)
	end)
	onDone = callback
	runner:Show()
end

function data.IsWorking()
	return job ~= nil
end

-- How many of the item are in the bags
function data.ItemCount(itemID)
	return GetItemCount(itemID, false) or 0
end

data.ItemIcon = GetItemIcon
data.GetItemInfo = GetItemInfo
