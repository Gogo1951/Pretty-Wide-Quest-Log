local _, ns = ...

--[[
	Routes: what the route reads from Questie and the client. The player's position and zone, Questie's
	quest log and its database's escort and instance quests, the client's timed quests, and the signature that says when to plan
	again. Distances are in world yards, from Questie's copy of HereBeDragons, which the arrow uses too
]]

local routes = ns.routes

local HBD

local function HereBeDragons()
	HBD = HBD or LibStub("HereBeDragonsQuestie-2.0", true)
	return HBD
end

-- Once Questie has started, its quest log and database are ready to read
function routes.IsQuestieReady()
	return Questie and Questie.started and HereBeDragons() and ns.ImportQuestieModule("QuestiePlayer") and true or false
end

-- The player's world position in yards, and continent, or nothing where the client won't say
function routes.PlayerPosition()
	local hbd = HereBeDragons()
	if hbd then
		return hbd:GetPlayerWorldPosition()
	end
end

-- A map, or the zone a micro map (a cave, a building) sits in
local function ZoneOf(mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	while info and info.mapType == Enum.UIMapType.Micro and info.parentMapID and info.parentMapID > 0 do
		mapID = info.parentMapID
		info = C_Map.GetMapInfo(mapID)
	end
	return mapID
end

-- The zone the player is in, the one the route covers
function routes.PlayerZone()
	return ZoneOf(C_Map.GetBestMapForUnit("player"))
end

--[[
	While the player is a ghost, where their corpse lies: world yards, continent and zone. Asked of the
	zone the ghost is in first, then each map above it, since the graveyard can be a zone away. Nothing
	where the client won't say, as for a corpse in a dungeon
]]
function routes.CorpsePosition()
	if not (UnitIsGhost("player") and C_DeathInfo and C_DeathInfo.GetCorpseMapPosition) then
		return nil
	end
	local hbd = HereBeDragons()
	local mapID = C_Map.GetBestMapForUnit("player")
	while hbd and mapID and mapID > 0 do
		local position = C_DeathInfo.GetCorpseMapPosition(mapID)
		local x, y = position and position.x, position and position.y
		if x and x >= 0 and x <= 1 and y >= 0 and y <= 1 and (x > 0 or y > 0) then
			local worldX, worldY, instance = hbd:GetWorldCoordinatesFromZone(x, y, mapID)
			if worldX then
				-- The deepest map at the corpse, as a zone
				local info = C_Map.GetMapInfoAtPosition and C_Map.GetMapInfoAtPosition(mapID, x, y)
				return worldX, worldY, instance, ZoneOf(info and info.mapID or mapID)
			end
		end
		local info = C_Map.GetMapInfo(mapID)
		mapID = info and info.parentMapID
	end
	return nil
end

--[[
	Where the route sets out from: the player, or a ghost's corpse, where they'll be once they've run back
	to it. corpse says which
]]
function routes.Origin()
	local x, y, instance, zone = routes.CorpsePosition()
	if x then
		return x, y, instance, zone, true
	end
	x, y, instance = routes.PlayerPosition()
	return x, y, instance, routes.PlayerZone(), false
end

-- Whether a map's parents, followed up to a continent, reach the zone: a cave or building inside it
local function IsWithinByParents(mapID, zone)
	local current = mapID
	local info = current and C_Map.GetMapInfo(current)
	while info do
		if current == zone then
			return true
		end
		if info.mapType <= Enum.UIMapType.Continent or not (info.parentMapID and info.parentMapID > 0) then
			return false
		end
		current = info.parentMapID
		info = C_Map.GetMapInfo(current)
	end
	return false
end

--[[
	Whether the whole of a map lies on the zone's map, on the same continent: a city drawn on the zone's
	map, as the Exodar is on Azuremyst Isle's. The game files such a city under the continent, not the
	zone, so its parents don't say
]]
local function IsWithinByPlace(mapID, zone)
	local hbd = HereBeDragons()
	if not hbd then
		return false
	end
	for _, corner in ipairs({ 0, 1 }) do
		local worldX, worldY, instance = hbd:GetWorldCoordinatesFromZone(corner, corner, mapID)
		if not worldX then
			return false
		end
		local x, y = hbd:GetZoneCoordinatesFromWorldInstance(worldX, worldY, instance, zone, true)
		if not (x and x >= 0 and x <= 1 and y >= 0 and y <= 1) then
			return false
		end
	end
	return true
end

--[[
	Whether a map from Questie's database is the zone or inside it: a micro map (a cave, a building), or a
	city on a map of its own within the zone, as the Exodar is within Azuremyst Isle. Questie draws such a
	city's NPCs on the zone's map too, so their turn-ins are on the route. Cached by zone, as it's asked
	per spawn
]]
local inZone = {}
local function IsInZone(mapID, zone)
	local cache = inZone[zone]
	if not cache then
		cache = {}
		inZone[zone] = cache
	end
	local found = cache[mapID]
	if found == nil then
		found = IsWithinByParents(mapID, zone) or IsWithinByPlace(mapID, zone)
		cache[mapID] = found
	end
	return found
end
routes.IsInZone = IsInZone

--------------------------------------------------------------------------------
-- Questie's quest log
--------------------------------------------------------------------------------

local QuestLog = ns.QuestieQuestLog
routes.QuestLog = QuestLog

-- 1 done, -1 failed, 0 not yet, as Questie counts it
local function QuestState(quest)
	if type(quest.IsComplete) ~= "function" then
		return 0
	end
	local ok, state = pcall(quest.IsComplete, quest)
	return ok and state or 0
end
routes.QuestState = QuestState

-- Each objective in the quest log's list, then Questie's own extra ones (such as a portal to close)
local function ForEachObjective(quest, callback)
	for index, objective in pairs(type(quest.Objectives) == "table" and quest.Objectives or {}) do
		callback("o" .. tostring(index), objective)
	end
	for index, objective in pairs(type(quest.SpecialObjectives) == "table" and quest.SpecialObjectives or {}) do
		callback("s" .. tostring(index), objective)
	end
end
routes.ForEachObjective = ForEachObjective

--[[
	Whether a quest is an escort. Questie's tag for one (QuestieDB.questTagIds.ESCORT) comes from the client
	and Questie's corrections, and most classic escorts, Free From the Hold among them, have none, so its
	database's quest flags count too: PARTY_ACCEPT (2) is the flag the game sets on escorts, so that the
	party is asked to join when one starts. The tag is checked only where Questie names it. Each answer is
	remembered until the quest log next changes (routes.ForgetQuestTags), as the client can know a quest's
	tag only once it has loaded the quest
]]
local PARTY_ACCEPT = 2
local escortQuests = {}

local function HasFlag(flags, flag)
	return type(flags) == "number" and flags % (flag * 2) >= flag
end

local function IsEscort(questID)
	if escortQuests[questID] ~= nil then
		return escortQuests[questID]
	end
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not QuestieDB then
		return false
	end
	local escort = false
	local escortTag = type(QuestieDB.questTagIds) == "table" and QuestieDB.questTagIds.ESCORT
	if escortTag and type(QuestieDB.GetQuestTagInfo) == "function" then
		local ok, tagID = pcall(QuestieDB.GetQuestTagInfo, questID)
		escort = ok and tagID == escortTag
	end
	if not escort and type(QuestieDB.QueryQuestSingle) == "function" then
		local ok, flags = pcall(QuestieDB.QueryQuestSingle, questID, "questFlags")
		escort = ok and HasFlag(flags, PARTY_ACCEPT)
	end
	escortQuests[questID] = escort
	return escort
end
routes.IsEscort = IsEscort

--[[
	The quests whose timer is running, as a set of quest IDs. WoW Forever's C_QuestLog.GetQuestTimers names
	each timer's quest; elsewhere GetQuestTimers counts the timers and GetQuestIndexForTimer finds each one's
	quest log entry, which says its quest ID, so the quest log's selection is never touched. Asked fresh
	each time: a timer starts and ends with no change Questie sees
]]
local function TimedQuests()
	local timed = {}
	if C_QuestLog and C_QuestLog.GetQuestTimers then
		for _, info in ipairs(C_QuestLog.GetQuestTimers() or {}) do
			if type(info) == "table" and info.questID then
				timed[info.questID] = true
			end
		end
	elseif GetQuestTimers and GetQuestIndexForTimer and GetQuestLogTitle then
		for timer = 1, select("#", GetQuestTimers()) do
			local index = GetQuestIndexForTimer(timer)
			local questID = index and select(8, GetQuestLogTitle(index))
			if questID then
				timed[questID] = true
			end
		end
	end
	return timed
end
routes.TimedQuests = TimedQuests

--[[
	Whether a quest is a dungeon or raid quest, by the game's tag for it, the one that puts the D or R after
	its level. The whole quest is left off the route, its objectives and its turn-in, and the arrow never
	points at it; Questie's own icons for it stay on the map, as the route doesn't stand in for them.

	Questie's tag first, as its corrections fix the game's, then the client's. Questie asks the client once,
	again a second later, and then keeps "no tag" for good, so a quest whose tag loads after that has the
	client's D in the quest list and on the route's lines but none from Questie. Remembered as escorts are,
	but only once either has a tag: until then it's asked again, and the signature plans again when it loads
]]
local INSTANCE_KINDS = { DUNGEON = true, RAID = true }
local instanceQuests = {}

local function QuestieTag(questID)
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if QuestieDB and type(QuestieDB.GetQuestTagInfo) == "function" then
		local ok, tagID = pcall(QuestieDB.GetQuestTagInfo, questID)
		return ok and tagID or nil
	end
end

local function IsInstanceQuest(questID)
	if instanceQuests[questID] ~= nil then
		return instanceQuests[questID]
	end
	local tagID = QuestieTag(questID) or ns.GetQuestTagByID(questID)
	if not tagID then
		return false
	end
	local kinds = ns.QUEST_TAG_SUFFIXES or {}
	local found = INSTANCE_KINDS[kinds[tagID]] == true
	instanceQuests[questID] = found
	return found
end

-- A quest's tag can load with the quest log, so both answers are asked again after it changes
function routes.ForgetQuestTags()
	wipe(escortQuests)
	wipe(instanceQuests)
end
routes.IsInstanceQuest = IsInstanceQuest

local function HasSpawns(objective)
	return type(objective.spawnList) == "table" and next(objective.spawnList) ~= nil
end
routes.HasSpawns = HasSpawns

--[[
	What the route depends on, as text: each quest's state, whether it's in an instance and whether its
	timer is running, each objective's being done and having spawns, the same of the party's quests
	(routes.PartyQuests), the skipped stops, the player's zone and whether they're a ghost. The route is
	planned again when this changes. Nil until Questie is ready
]]
function routes.Signature()
	if not routes.IsQuestieReady() then
		return nil
	end
	local parts = {}
	local timed = TimedQuests()
	for questID, quest in pairs(QuestLog()) do
		if type(quest) == "table" then
			local bits = {}
			ForEachObjective(quest, function(key, objective)
				bits[#bits + 1] = key .. (objective.Completed and "+" or "-") .. (HasSpawns(objective) and "s" or "")
			end)
			table.sort(bits)
			parts[#parts + 1] = tostring(questID)
				.. (IsInstanceQuest(questID) and "i" or "")
				.. (timed[questID] and "t" or "")
				.. "="
				.. tostring(QuestState(quest))
				.. ":"
				.. table.concat(bits, ",")
		end
	end
	for questID, quest in pairs(routes.PartyQuests(QuestLog())) do
		local bits = {}
		for index, objective in pairs(quest.Objectives) do
			bits[#bits + 1] = index .. (objective.Completed and "+" or "-") .. (HasSpawns(objective) and "s" or "")
		end
		table.sort(bits)
		parts[#parts + 1] = "party:"
			.. questID
			.. (IsInstanceQuest(questID) and "i" or "")
			.. ":"
			.. table.concat(bits, ",")
	end
	for key in pairs(routes.skipped) do
		parts[#parts + 1] = "skip:" .. key
	end
	table.sort(parts)
	parts[#parts + 1] = tostring(routes.PlayerZone())
	parts[#parts + 1] = UnitIsGhost("player") and "ghost" or "alive"
	return table.concat(parts, ";")
end
