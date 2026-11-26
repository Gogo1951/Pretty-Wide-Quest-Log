local _, ns = ...

--[[
	Routes: a city's gates as waypoints. A city counts as the zone it's in (Routes-Geography.lua), so one
	route covers both, and a leg between the city and the zone around it would be drawn straight through
	the city's walls. Each such leg goes through a gate instead: a waypoint of its own, kind "exit", at
	the gate Leatrix Maps marks (ns.CITY_EXITS, the flavor's Game-IDs file), which says where it leads:
	"Head to Durotar" going out, "Head to Orgrimmar" going in. Of a city's gates, the one that adds the
	least walking to the leg.

	Going out, the gate waypoint also holds a hidden point just past the city map's edge, out along the
	gate's arrow. The Quest Arrow points to the gate, then to that hidden point once the player is at or
	through it, so it doesn't turn back to the gate while the player is still on the city's map.

	Whether a place is in the city: for the player, the map the game puts them on; for any other place,
	whether it's on the city's map at all (HereBeDragons). The edge of a city's map can take in a little
	ground outside its walls. Stepping through the gate changes the map the player is on, which is in the
	route's signature (Routes-Questie.lua), so the route is planned again from the other side without it
]]

local routes = ns.routes
local L = ns.L

local CITY_EXITS = ns.CITY_EXITS or {}
local CITY_ZONES = ns.CITY_ZONE_MAP_IDS

-- The arrow on a gate's marker (Routes-Stop-Look.lua), the one Leatrix Maps draws at zone crossings
routes.EXIT_ATLAS = "Garr_LevelUpgradeArrow"

local EXIT_STEP = 4 -- Yards between looks for the city map's edge, out from a gate
local EXIT_REACH = 400 -- Yards out from a gate to look for that edge at most
local EXIT_PAST = 10 -- Yards past the edge for the gate's hidden point
local EXIT_THROUGH = 10 -- Yards from a gate that count as at it, the Quest Arrow's own reach for one place

--[[
	The gates of every city in the zone, in world yards, worked out once per city: { x, y, facing } with
	the city and the zone each leads to
]]
local gatesByCity = {}

local function Gates(city)
	local gates = gatesByCity[city]
	if gates then
		return gates
	end
	gates = {}
	local hereBeDragons = routes.HereBeDragons()
	for index, gate in ipairs(CITY_EXITS[city] or {}) do
		local x, y, instance = nil, nil, nil
		if hereBeDragons then
			x, y, instance = hereBeDragons:GetWorldCoordinatesFromZone(gate[1] / 100, gate[2] / 100, city)
		end
		if x then
			gates[#gates + 1] = { x = x, y = y, instance = instance, facing = gate[3], index = index }
		end
	end
	if hereBeDragons then
		gatesByCity[city] = gates -- Not cached until HereBeDragons answers
	end
	return gates
end

-- The cities in the zone that have gates
local function CitiesIn(zone)
	local cities = {}
	for city in pairs(CITY_EXITS) do
		if CITY_ZONES[city] == zone then
			cities[#cities + 1] = city
		end
	end
	return cities
end

-- Whether a place in world yards is on the city's map
local function IsOnCityMap(city, x, y)
	local hereBeDragons = routes.HereBeDragons()
	if not (hereBeDragons and x) then
		return false
	end
	local cityX, cityY = hereBeDragons:GetZoneCoordinatesFromWorld(x, y, city)
	return cityX ~= nil and cityX >= 0 and cityX <= 1 and cityY >= 0 and cityY <= 1
end

-- The city a place is in, of the zone's, or nothing
local function CityAt(cities, x, y)
	for _, city in ipairs(cities) do
		if IsOnCityMap(city, x, y) then
			return city
		end
	end
	return nil
end

--[[
	The hidden point past a gate: out along its arrow until off the city's map, then EXIT_PAST more. The
	marker's turn (Routes-Stop-Look.lua) is counterclockwise from north, so out is (sin, cos) in world
	yards, where x grows west and y north (HereBeDragons). Nothing where no edge is within EXIT_REACH
]]
local function ExitAim(city, gate)
	if gate.aimX == nil then
		gate.aimX = false
		local stepX, stepY = math.sin(gate.facing), math.cos(gate.facing)
		for yards = EXIT_STEP, EXIT_REACH, EXIT_STEP do
			if not IsOnCityMap(city, gate.x + stepX * yards, gate.y + stepY * yards) then
				local past = yards + EXIT_PAST
				gate.aimX, gate.aimY = gate.x + stepX * past, gate.y + stepY * past
				break
			end
		end
	end
	return gate.aimX or nil, gate.aimY
end

local function MapName(mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	return info and info.name or ""
end

-- Of the city's gates, the one that adds the least to walking from one place to the other
local function BestGate(city, from, to, instance)
	local best, bestYards
	for _, gate in ipairs(Gates(city)) do
		if gate.instance == instance then
			local yards = math.sqrt((gate.x - from.x) ^ 2 + (gate.y - from.y) ^ 2)
				+ math.sqrt((gate.x - to.x) ^ 2 + (gate.y - to.y) ^ 2)
			if not bestYards or yards < bestYards then
				best, bestYards = gate, yards
			end
		end
	end
	return best
end

--[[
	A waypoint at the gate, its one task "Head to Durotar": out of the city to its zone, or into the city
	from it. The marker's arrow points the way through, out of the city or into it. Going out, the
	hidden point past the city map's edge too (ExitAim)
]]
local function GateStop(city, gate, out, start)
	local place = out and MapName(CITY_ZONES[city]) or MapName(city)
	local point = { x = gate.x, y = gate.y, radius = routes.MIN_STOP_RADIUS, count = 1, names = { place } }
	local aimX, aimY
	if out then
		aimX, aimY = ExitAim(city, gate)
	end
	local aim = aimX and { x = aimX, y = aimY, radius = point.radius, count = 1, names = { place } } or nil
	return {
		x = gate.x,
		y = gate.y,
		instance = start.instance,
		radius = point.radius,
		names = { place },
		mapID = start.zone,
		area = false,
		tasks = {
			{
				key = "exit:" .. city .. ":" .. gate.index .. ":" .. (out and "out" or "in"),
				kind = "exit",
				destination = place,
				facing = out and gate.facing or (gate.facing + math.pi),
				candidates = { point },
				choice = 1,
				aim = aim,
				ready = true,
			},
		},
	}
end

-- Adds the gates a leg goes through: out of the city it starts in, then into the city it ends in
local function AddGates(withGates, fromCity, toCity, from, to, start)
	if fromCity == toCity then
		return
	end
	if fromCity then
		local gate = BestGate(fromCity, from, to, start.instance)
		local stop = gate and GateStop(fromCity, gate, true, start)
		if stop and not routes.skipped[stop.tasks[1].key] then
			withGates[#withGates + 1] = stop
			from = stop
		end
	end
	if toCity then
		local gate = BestGate(toCity, from, to, start.instance)
		local stop = gate and GateStop(toCity, gate, false, start)
		if stop and not routes.skipped[stop.tasks[1].key] then
			withGates[#withGates + 1] = stop
		end
	end
end

--[[
	The stops with a gate waypoint before each one across a city's walls from the place before it. A
	fly waypoint's leg starts where it lands. Not a gate the player ignored
]]
function routes.AddCityExitStops(stops, start)
	local cities = CitiesIn(start.zone)
	if #cities == 0 or #stops == 0 then
		return stops
	end
	local withGates = {}
	local previous = start
	-- The player's own city, from the map the game puts them on; a ghost's corpse by where it lies
	local previousCity
	if start.corpse then
		previousCity = CityAt(cities, start.x, start.y)
	else
		previousCity = routes.PlayerCity()
	end
	for _, stop in ipairs(stops) do
		local city = CityAt(cities, stop.x, stop.y)
		AddGates(withGates, previousCity, city, previous, stop, start)
		withGates[#withGates + 1] = stop
		previous = stop.landing or stop
		previousCity = CityAt(cities, previous.x, previous.y)
	end
	return withGates
end

--[[
	Where the Quest Arrow points for a gate waypoint: the gate, or its hidden point once the player is
	within EXIT_THROUGH of the gate or through it, nearer the hidden point than the gate is
]]
function routes.ExitPlace(task, point, x, y)
	local aim = task.aim
	if not aim then
		return point
	end
	local gateYards = math.sqrt((point.x - x) ^ 2 + (point.y - y) ^ 2)
	local aimYards = math.sqrt((aim.x - x) ^ 2 + (aim.y - y) ^ 2)
	local gateToAim = math.sqrt((aim.x - point.x) ^ 2 + (aim.y - point.y) ^ 2)
	if gateYards <= EXIT_THROUGH or aimYards < gateToAim then
		return aim
	end
	return point
end

-- What a gate waypoint asks for, on the arrow and the map's tooltip: "Head to Durotar"
function routes.ExitText(task)
	return string.format(L["ROUTES_EXIT_TO"], task.destination or "")
end

-- What a gate waypoint is called on the Quest Arrow's menu and in chat: "Way to Durotar"
function routes.ExitLabel(task)
	return string.format(L["ROUTES_MENU_EXIT"], task.destination or "")
end

-- What the city adds to the route's signature: the one the player is in, so stepping through a gate plans again
function routes.CitySignature()
	return "city:" .. tostring(routes.PlayerCity() or "")
end
