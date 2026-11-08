local _, ns = ...

--[[
	Routes: what the Quest Arrow sees around the player. Which tasks' areas the player is in, and whether
	each is work here or on the way, where the route goes next and after that, the note under "Current
	Objective Area", and the nearest place in a stop to point at
]]

local routes = ns.routes
local L = ns.L

local hereKeys = {} -- The tasks whose areas the player is in, by key, held until routes.AREA_GRACE further
local moreCache = {} -- MoreAhead's answers, for the plan they were worked out for (moreCache.stops)

-- Squared yards from a point to the nearest point on the line from a to b
local function SegmentDistanceSquared(px, py, ax, ay, bx, by)
	local dx, dy = bx - ax, by - ay
	local lengthSquared = dx * dx + dy * dy
	local share = 0
	if lengthSquared > 0 then
		share = math.max(0, math.min(1, ((px - ax) * dx + (py - ay) * dy) / lengthSquared))
	end
	local cx, cy = ax + share * dx - px, ay + share * dy - py
	return cx * cx + cy * cy
end

--[[
	Whether the route passes more of an objective's mobs or objects after the waypoint at index: any of its
	spawns within routes.AREA_REACH of the way on from there, leaving out those around that waypoint itself.
	Worked out once a plan
]]
local function MoreAhead(task, stops, index)
	if moreCache.stops ~= stops then
		moreCache = { stops = stops }
	end
	local cached = moreCache[task.key]
	if cached ~= nil then
		return cached
	end
	local found = false
	local spawns, from = task.spawns, stops[index]
	if spawns and from and stops[index + 1] then
		local reachSquared = routes.AREA_REACH * routes.AREA_REACH
		local around = (from.radius or 0) + routes.AREA_REACH
		for i = 1, spawns.count do
			local sx, sy = spawns.x[i], spawns.y[i]
			local dx, dy = sx - from.x, sy - from.y
			if dx * dx + dy * dy > around * around then
				for leg = index, #stops - 1 do
					local a, b = stops[leg], stops[leg + 1]
					if
						a.instance == b.instance
						and SegmentDistanceSquared(sx, sy, a.x, a.y, b.x, b.y) <= reachSquared
					then
						found = true
						break
					end
				end
				if found then
					break
				end
			end
		end
	end
	moreCache[task.key] = found
	return found
end

--[[
	What to say under "Current Objective Area": "Finish Here Before Moving On" where an objective here has
	all its spawns in one blob, so nowhere else will do; "More Along the Route" where the route passes more of
	every one of them; else nothing
]]
local function AreaNote(work, stops, index)
	local allAhead = true
	for _, task in ipairs(work) do
		if task.kind == "objective" and task.blobs and #task.blobs == 1 then
			return L["ROUTES_AREA_FINISH"]
		end
		if allAhead and not MoreAhead(task, stops, index) then
			allAhead = false
		end
	end
	return allAhead and L["ROUTES_AREA_MORE"] or nil
end

local function View(stop, tasks)
	return {
		tasks = tasks,
		x = stop.x,
		y = stop.y,
		instance = stop.instance,
		radius = stop.radius,
		corpse = stop.corpse,
	}
end

--[[
	Looks around. The waypoint the route sends the player to is its first stop with a task left. Every task
	whose area the player is in (routes.InArea) is either work, at that waypoint or pinned there for being
	worked (routes.engaged), or on the way, planned for a later waypoint. The next destination is the first
	stop with a task left that isn't work. Dead, there's only the corpse. Returns here and passing (each a
	stop's worth of tasks, or nil), the note under "Current Objective Area", the destination and the waypoint
	after it
]]
local function Survey(x, y)
	local stops = routes.stops
	local wasHere = hereKeys
	hereKeys = {}
	local sentTo
	for index, stop in ipairs(stops) do
		for _, task in ipairs(stop.tasks) do
			if routes.IsTaskLeft(task) then
				sentTo = index
				break
			end
		end
		if sentTo then
			break
		end
	end
	local work, onTheWay, workKeys = {}, {}, {}
	if not stops[1].corpse then
		local engaged = routes.engaged or {}
		for index, stop in ipairs(stops) do
			for _, task in ipairs(stop.tasks) do
				local key = task.key
				if
					key
					and not hereKeys[key]
					and routes.IsTaskLeft(task)
					and routes.InArea(task, x, y, wasHere[key])
				then
					hereKeys[key] = true
					if index == sentTo or engaged[key] then
						work[#work + 1] = task
						workKeys[key] = true
					else
						onTheWay[#onTheWay + 1] = task
					end
				end
			end
		end
	end
	local instance = stops[1].instance
	local here = #work > 0 and { tasks = work, instance = instance } or nil
	local passing = #onTheWay > 0 and { tasks = onTheWay, instance = instance } or nil
	local areaNote = here and AreaNote(work, stops, sentTo) or nil
	local destination, afterDestination
	for _, stop in ipairs(stops) do
		local rest = {}
		for _, task in ipairs(stop.tasks) do
			if not workKeys[task.key] and routes.IsTaskLeft(task) then
				rest[#rest + 1] = task
			end
		end
		if #rest > 0 then
			if destination then
				afterDestination = not stop.corpse and View(stop, rest) or nil
				break
			end
			destination = View(stop, rest)
			if stop.corpse then
				break -- Dead, nothing's next until the corpse is reached
			end
		end
	end
	return here, passing, areaNote, destination, afterDestination
end

-- Where in a stop the arrow points: its nearest place still to go to, or the nearest edge of an area
local function NearestPlace(stop, x, y)
	local nearest, nearestYards
	for _, task in ipairs(stop.tasks) do
		local point = routes.IsTaskLeft(task) and routes.TaskPoint(task)
		if point then
			local dx, dy = point.x - x, point.y - y
			local yards = math.sqrt(dx * dx + dy * dy)
			if routes.IsAreaPoint(point) then
				yards = math.max(0, yards - point.radius)
			end
			if not nearestYards or yards < nearestYards then
				nearest, nearestYards = point, yards
			end
		end
	end
	return nearest
end

-- Point asks these each second (Routes-Arrow.lua)
routes.ArrowSurvey = Survey
routes.ArrowNearestPlace = NearestPlace
