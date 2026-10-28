local _, ns = ...

-- Every client: the dungeon the player is in, and which of their quests belong to it, from the quest log and Questie.

--------------------------------------------------------------------------------
-- The Dungeon
--------------------------------------------------------------------------------

local INSTANCE_TYPES = { party = true, raid = true }

local function QuestieZoneDB()
	local zoneDB = ns.ImportQuestieModule("ZoneDB")
	return zoneDB and type(zoneDB.instanceIdToAreaId) == "table" and zoneDB or nil
end

--[[
	The dungeon the player is in, or nil outside one: its name, a key that's the same for every instance
	of it (Questie's zone ID, or the name without Questie), the zone IDs its quest data uses (Questie
	files some dungeons' quests under a second ID) and the names its quest log header can carry
]]
local function CurrentDungeon()
	local instanceName, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
	if not INSTANCE_TYPES[instanceType] then
		return nil
	end
	local name = GetRealZoneText() or instanceName
	local dungeon = { name = name, areaIDs = {}, names = {} }
	dungeon.names[name] = true
	if instanceName then
		dungeon.names[instanceName] = true
	end

	local zoneDB = QuestieZoneDB()
	local areaID = zoneDB and zoneDB.instanceIdToAreaId[instanceID]
	if areaID then
		dungeon.areaIDs[areaID] = true
		local found, dungeons = pcall(zoneDB.GetDungeons, zoneDB)
		local entry = found and type(dungeons) == "table" and dungeons[areaID]
		if entry and type(entry[2]) == "table" then
			for _, alternativeID in ipairs(entry[2]) do
				dungeon.areaIDs[alternativeID] = true
			end
		end
		for zoneID in pairs(dungeon.areaIDs) do
			local areaName = C_Map.GetAreaInfo(zoneID)
			if areaName then
				dungeon.names[areaName] = true
			end
		end
	end
	dungeon.key = areaID or name
	return dungeon
end

--------------------------------------------------------------------------------
-- Questie
--------------------------------------------------------------------------------

-- One field of a record in Questie's database, or nil while Questie isn't loaded or doesn't know it
local function Query(queryName, id, field)
	local questieDB = ns.ImportQuestieModule("QuestieDB")
	local query = questieDB and questieDB[queryName]
	if type(query) ~= "function" or not id then
		return nil
	end
	local found, value = pcall(query, id, field)
	return found and value or nil
end

-- Whether a spawn list (zone ID -> coordinates) has any spawn in the dungeon
local function SpawnsIn(spawns, dungeon)
	if type(spawns) ~= "table" then
		return false
	end
	for areaID in pairs(dungeon.areaIDs) do
		if spawns[areaID] then
			return true
		end
	end
	return false
end

local function NpcIn(npcID, dungeon)
	return SpawnsIn(Query("QueryNPCSingle", npcID, "spawns"), dungeon)
end

local function ObjectIn(objectID, dungeon)
	return SpawnsIn(Query("QueryObjectSingle", objectID, "spawns"), dungeon)
end

-- An item drops in the dungeon when anything there drops it
local function ItemIn(itemID, dungeon)
	for _, npcID in pairs(Query("QueryItemSingle", itemID, "npcDrops") or {}) do
		if NpcIn(npcID, dungeon) then
			return true
		end
	end
	for _, objectID in pairs(Query("QueryItemSingle", itemID, "objectDrops") or {}) do
		if ObjectIn(objectID, dungeon) then
			return true
		end
	end
	return false
end

local REFERENCE_CHECKS = { monster = NpcIn, object = ObjectIn, item = ItemIn }

-- Questie's objectives list creatures, objects and items in its first three slots
local OBJECTIVE_CHECKS = { NpcIn, ObjectIn, ItemIn }

--[[
	Whether Questie places the quest, or any of its objectives, in the dungeon: the quest filed under the
	dungeon, a creature, object or item it asks for found there, or a spot to explore there. This is what
	catches class quests and others filed under another zone
]]
local function QuestieQuestIn(questID, dungeon)
	if next(dungeon.areaIDs) == nil then
		return false
	end
	local zoneOrSort = Query("QueryQuestSingle", questID, "zoneOrSort")
	if zoneOrSort and dungeon.areaIDs[zoneOrSort] then
		return true
	end

	-- Questie's own reads walk these lists with pairs, as they can have gaps
	local objectives = Query("QueryQuestSingle", questID, "objectives") or {}
	for index, check in ipairs(OBJECTIVE_CHECKS) do
		for _, objective in pairs(objectives[index] or {}) do
			if type(objective) == "table" and check(objective[1], dungeon) then
				return true
			end
		end
	end
	for _, killCredit in pairs(objectives[5] or {}) do
		if type(killCredit) == "table" then
			if NpcIn(killCredit[2], dungeon) then
				return true
			end
			for _, npcID in pairs(killCredit[1] or {}) do
				if NpcIn(npcID, dungeon) then
					return true
				end
			end
		end
	end

	local triggerEnd = Query("QueryQuestSingle", questID, "triggerEnd")
	if type(triggerEnd) == "table" and SpawnsIn(triggerEnd[2], dungeon) then
		return true
	end
	for _, extra in pairs(Query("QueryQuestSingle", questID, "extraObjectives") or {}) do
		if type(extra) == "table" then
			if SpawnsIn(extra[1], dungeon) then
				return true
			end
			for _, reference in pairs(extra[5] or {}) do
				local check = type(reference) == "table" and REFERENCE_CHECKS[reference[1]]
				if check and check(reference[2], dungeon) then
					return true
				end
			end
		end
	end
	for _, itemID in pairs(Query("QueryQuestSingle", questID, "requiredSourceItems") or {}) do
		if ItemIn(itemID, dungeon) then
			return true
		end
	end
	return false
end

--[[
	Whether Questie lists the quest under a world event (a holiday or the Darkmoon Faire). These are
	never a dungeon's own quests, though Questie can still place one there
]]
local function IsEventQuest(questID)
	local questieEvent = ns.ImportQuestieModule("QuestieEvent")
	if not (questieEvent and type(questieEvent.IsEventQuest) == "function") then
		return false
	end
	local found, isEvent = pcall(questieEvent.IsEventQuest, questID)
	return found and isEvent == true
end

--------------------------------------------------------------------------------
-- The Dungeon's Quests
--------------------------------------------------------------------------------

--[[
	The quests in the log for the dungeon, in quest log order (ns.LogQuests): those listed under its
	header, and those Questie places there, leaving out world event quests. Without Questie, the header
	alone decides. Each is marked with what placed it, for the Sharing Context report
]]
function ns.DungeonQuests(dungeon)
	local quests = {}
	for _, quest in ipairs(ns.LogQuests()) do
		if not IsEventQuest(quest.questID) then
			if dungeon.names[quest.zoneTitle or ""] then
				quest.matchedBy = "header"
			elseif QuestieQuestIn(quest.questID, dungeon) then
				quest.matchedBy = "Questie"
			end
		end
		if quest.matchedBy then
			quests[#quests + 1] = quest
		end
	end
	return quests
end

-- For Dungeon-Quests.lua and the Sharing Context report
ns.CurrentDungeon = CurrentDungeon
