local _, ns = ...

--[[
	Routes: where the player is and what the maps say about places. The player's position and zone, a
	ghost's corpse, and whether a map lies within a zone or a dungeon. Positions are in world yards, from
	Questie's copy of HereBeDragons (routes.HereBeDragons)
]]

local routes = ns.routes

local GetHereBeDragons = routes.HereBeDragons

-- The player's world position in yards, and continent, or nothing where the client won't say
function routes.PlayerPosition()
	local hereBeDragons = GetHereBeDragons()
	if hereBeDragons then
		return hereBeDragons:GetPlayerWorldPosition()
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
	Whether a party member is in another zone than the player. Not where the client won't say where either
	one is, as for a member in a dungeon the player isn't in, or keeps secret, as WoW Forever can in combat
]]
function routes.IsUnitOutOfZone(unit)
	local myMap, theirMap = C_Map.GetBestMapForUnit("player"), C_Map.GetBestMapForUnit(unit)
	if not ns.IsReadable(myMap, theirMap) then
		return false
	end
	local mine, theirs = ZoneOf(myMap), ZoneOf(theirMap)
	return mine ~= nil and theirs ~= nil and mine ~= theirs
end

-- The zone a party member is in, or nothing where the client won't say or keeps it secret
function routes.UnitZone(unit)
	local mapID = C_Map.GetBestMapForUnit(unit)
	if not ns.IsReadable(mapID) then
		return nil
	end
	return ZoneOf(mapID)
end

--[[
	A party member's world position in yards, and continent, from where the zone map puts them: nothing
	where the client won't say, as in a dungeon, or keeps it secret, as WoW Forever can in combat
]]
function routes.UnitWorldPosition(unit)
	local hereBeDragons = GetHereBeDragons()
	local mapID = C_Map.GetBestMapForUnit(unit)
	if not (hereBeDragons and ns.IsReadable(mapID) and mapID) then
		return nil
	end
	local position = C_Map.GetPlayerMapPosition(mapID, unit)
	if not position then
		return nil
	end
	local x, y = position:GetXY()
	if not (ns.IsReadable(x, y) and x and y) or (x == 0 and y == 0) then
		return nil
	end
	return hereBeDragons:GetWorldCoordinatesFromZone(x, y, mapID)
end

--[[
	While the player is a ghost, where their corpse lies: world yards, continent and zone. Asked of the
	zone the ghost is in first, then each map above it, since the graveyard can be a zone away. Nothing
	where the client won't say, as for a corpse in a dungeon
]]
function routes.CorpsePosition()
	if not UnitIsGhost("player") then
		return nil
	end
	local hereBeDragons = GetHereBeDragons()
	local mapID = C_Map.GetBestMapForUnit("player")
	while hereBeDragons and mapID and mapID > 0 do
		local position = C_DeathInfo.GetCorpseMapPosition(mapID)
		local x, y = position and position.x, position and position.y
		if x and x >= 0 and x <= 1 and y >= 0 and y <= 1 and (x > 0 or y > 0) then
			local worldX, worldY, instance = hereBeDragons:GetWorldCoordinatesFromZone(x, y, mapID)
			if worldX then
				-- The deepest map at the corpse, as a zone
				local info = C_Map.GetMapInfoAtPosition(mapID, x, y)
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
	The zone each city on a map of its own is in, city map ID to zone map ID. The game files these cities
	under the continent, not the zone, so their parents don't say. Only the zone named here counts: Thunder
	Bluff is in Mulgore, not the Barrens, though the Barrens' map reaches over it. Classic Era, TBC and WoW
	Forever share map IDs; Mists has its own
]]
local CITY_ZONES = {
	-- Classic Era, TBC and WoW Forever
	[1453] = 1429, -- Stormwind City: Elwynn Forest
	[1454] = 1411, -- Orgrimmar: Durotar
	[1455] = 1426, -- Ironforge: Dun Morogh
	[1456] = 1412, -- Thunder Bluff: Mulgore
	[1457] = 1438, -- Darnassus: Teldrassil
	[1458] = 1420, -- Undercity: Tirisfal Glades
	[1947] = 1943, -- The Exodar: Azuremyst Isle
	[1954] = 1941, -- Silvermoon City: Eversong Woods
	[1955] = 1952, -- Shattrath City: Terokkar Forest
	-- Mists
	[84] = 37, -- Stormwind City: Elwynn Forest
	[85] = 1, -- Orgrimmar: Durotar
	[87] = 27, -- Ironforge: Dun Morogh
	[88] = 7, -- Thunder Bluff: Mulgore
	[89] = 57, -- Darnassus: Teldrassil
	[90] = 18, -- Undercity: Tirisfal Glades
	[998] = 18, -- Undercity: Tirisfal Glades
	[103] = 97, -- The Exodar: Azuremyst Isle
	[110] = 94, -- Silvermoon City: Eversong Woods
	[111] = 108, -- Shattrath City: Terokkar Forest
}

--[[
	Whether a map from Questie's database is the zone or inside it: a micro map (a cave, a building), or a
	city that's in the zone (CITY_ZONES). Questie draws such a city's NPCs on the zone's map too, so their
	turn-ins are on the route. Cached by zone, as it's asked per spawn
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
		found = IsWithinByParents(mapID, zone) or CITY_ZONES[mapID] == zone
		cache[mapID] = found
	end
	return found
end
routes.IsInZone = IsInZone

--[[
	Whether a map is a dungeon's or a raid's, or a floor of one: it or a map above it is a dungeon map. The
	game can file a dungeon's map under the zone its entrance is in, so routes.IsInZone alone passes it.
	Cached, as it's asked per spawn
]]
local instanceMaps = {}
local function IsInstanceMap(mapID)
	local found = instanceMaps[mapID]
	if found ~= nil then
		return found
	end
	found = false
	local info = C_Map.GetMapInfo(mapID)
	while info do
		if info.mapType == Enum.UIMapType.Dungeon then
			found = true
			break
		end
		if info.mapType <= Enum.UIMapType.Continent or not (info.parentMapID and info.parentMapID > 0) then
			break
		end
		info = C_Map.GetMapInfo(info.parentMapID)
	end
	instanceMaps[mapID] = found
	return found
end
routes.IsInstanceMap = IsInstanceMap
