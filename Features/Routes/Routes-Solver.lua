local _, ns = ...

--[[
	Routes: orders the route's stops, the way QuestHelper did, as a travelling salesman
	problem with two twists. Each stop is a node with several candidate places (an objective's mobs may
	gather in a few spots, and the route only needs one), and some nodes must come after others (a quest's
	turn-in after its objectives). The route is open: it starts at the player and ends at the last stop.

	Cheapest insertion builds a first route, then three moves improve it until none helps: pick another
	candidate for a node, move a run of one to three nodes elsewhere (or-opt), and reverse a stretch (2-opt).
	A move that would put a turn-in before one of its objectives is refused. Last, nothing far off is left
	between two places of one camp (KeepCampsWhole). Moves are weighed without
	building the routes they'd make: a route of 90 stops weighs hundreds of thousands, and building each
	would make over 100 MB of garbage a plan.

	The caller passes a yield function, called often, which can pause the work and pick it up on the next
	frame.

	Each node: { candidates = { { x, y, penalty }, ... }, requires = { node, ... } }. x and y are in
	yards; a candidate's penalty is added to the route's length when it is chosen, so a sparse spot loses
	out to a dense one unless it's on the way. Solve sets node.choice and returns the nodes in order.

	A leg costs its yards, and a trip somewhere else costs TRIP_COST more: a leg within a camp nothing
	more, one past TRIP_FAR all of it, between the two a share. The shortest route in yards alone will
	leave a camp half done for a turn-in or another camp and come back, when finishing the camp first is
	all but as short; this keeps it to finishing what's around before setting off
]]

local Solver = {}
ns.routesSolver = Solver

local EPSILON = 0.01 -- Yards: a move has to save more than this to count
local MAX_SEGMENT = 3 -- Longest run of nodes or-opt moves at once
local MAX_PASSES = 300 -- Improvement passes at most; each makes at most one or-opt and one 2-opt move
local SHAKES = 16 -- Times the finished route is shaken up and improved again, for a short route
local MIN_SHAKES = 4 -- For a long one
local SHAKE_WORK = 800 -- Shakes times nodes, which sets how many a route of some length gets
local THROWS = 2 -- Nodes thrown somewhere else in each shake
local WARM_SHAKES = 8 -- Shakes at most for a route started from the last one, which was shaken already
local WARM_REACH = 150 -- Yards a candidate can be from where the last route had a node and still be its place

local TRIP_NEAR = 100 -- Yards a leg can be and still be within one camp, as stops within it merge (Routes-Stops.lua)
local TRIP_FAR = 300 -- Yards past which a leg is a trip somewhere else
local TRIP_COST = 150 -- Yards a trip somewhere else counts for more than its length
local CAMP_SPAN = 200 -- Yards apart two places in a row can be and still be one camp, and yards out of the way a side trip from it can't be

local sqrt = math.sqrt

-- What a leg costs: its yards, plus a share of TRIP_COST for setting off somewhere else
local function Distance(a, b)
	local dx, dy = a.x - b.x, a.y - b.y
	local yards = sqrt(dx * dx + dy * dy)
	if yards <= TRIP_NEAR then
		return yards
	elseif yards >= TRIP_FAR then
		return yards + TRIP_COST
	end
	return yards + TRIP_COST * (yards - TRIP_NEAR) / (TRIP_FAR - TRIP_NEAR)
end

local function NoYield() end

local function Point(node)
	return node.candidates[node.choice]
end

-- Each node's place in the route
local function Positions(route)
	local positions = {}
	for i, node in ipairs(route) do
		positions[node] = i
	end
	return positions
end

-- The route's cost from the start: each leg's (Distance), plus the penalty of every chosen candidate
function Solver.Cost(start, route)
	local cost, previous = 0, start
	for _, node in ipairs(route) do
		local point = Point(node)
		cost = cost + Distance(previous, point) + (point.penalty or 0)
		previous = point
	end
	return cost
end

--------------------------------------------------------------------------------
-- First route
--------------------------------------------------------------------------------

local function IsReady(node, placed)
	for _, required in ipairs(node.requires or {}) do
		if not placed[required] then
			return false
		end
	end
	return true
end

-- The first place a node may go: after the last node it requires
local function FirstSlot(node, positions)
	local slot = 1
	for _, required in ipairs(node.requires or {}) do
		local position = positions[required]
		if position and position + 1 > slot then
			slot = position + 1
		end
	end
	return slot
end

--[[
	Cheapest insertion: of every node whose required nodes are in, every candidate and every place it may
	go, adds the one that lengthens the route least, until all are in. From an empty route, or from route,
	a start already made (WarmRoute) with placed the set of its nodes, adding only the rest
]]
local function Construct(start, nodes, yield, route, placed)
	route, placed = route or {}, placed or {}
	for _ = 1, #nodes - #route do
		local positions = Positions(route)
		local bestDelta, bestNode, bestChoice, bestSlot
		for _, node in ipairs(nodes) do
			if not placed[node] and IsReady(node, placed) then
				local firstSlot = FirstSlot(node, positions)
				for choice, candidate in ipairs(node.candidates) do
					local penalty = candidate.penalty or 0
					for slot = firstSlot, #route + 1 do
						local previous = slot == 1 and start or Point(route[slot - 1])
						local nextNode = route[slot]
						local delta = Distance(previous, candidate) + penalty
						if nextNode then
							local nextPoint = Point(nextNode)
							delta = delta + Distance(candidate, nextPoint) - Distance(previous, nextPoint)
						end
						if not bestDelta or delta < bestDelta then
							bestDelta, bestNode, bestChoice, bestSlot = delta, node, choice, slot
						end
					end
				end
			end
			yield()
		end
		if not bestNode then
			break -- Only a cycle of requirements is left, which the caller never builds
		end
		bestNode.choice = bestChoice
		placed[bestNode] = true
		table.insert(route, bestSlot, bestNode)
	end
	return route
end

--------------------------------------------------------------------------------
-- Improving it
--------------------------------------------------------------------------------

-- What a candidate costs between its neighbors
local function LocalCost(previous, candidate, nextPoint)
	local cost = Distance(previous, candidate) + (candidate.penalty or 0)
	if nextPoint then
		cost = cost + Distance(candidate, nextPoint)
	end
	return cost
end

-- Gives each node the candidate that fits best between its neighbors
local function ImproveChoices(start, route, yield)
	local improved = false
	for i, node in ipairs(route) do
		if #node.candidates > 1 then
			local previous = i == 1 and start or Point(route[i - 1])
			local nextPoint = route[i + 1] and Point(route[i + 1])
			local bestChoice, bestCost = node.choice, LocalCost(previous, Point(node), nextPoint)
			for choice, candidate in ipairs(node.candidates) do
				local cost = LocalCost(previous, candidate, nextPoint)
				if cost < bestCost - EPSILON then
					bestChoice, bestCost = choice, cost
				end
			end
			if bestChoice ~= node.choice then
				node.choice = bestChoice
				improved = true
			end
		end
		yield()
	end
	return improved
end

--[[
	Where the node at index i lands when or-opt moves the run first..last into the gap after the rest's
	node gap (the rest being the route without the run), reversed or not
]]
local function OrOptIndex(i, first, last, gap, reverse)
	if i >= first and i <= last then
		return gap + 1 + (reverse and last - i or i - first)
	end
	local length = last - first + 1
	local j = i < first and i or i - length
	return j <= gap and j or j + length
end

-- Where the node at index i lands when 2-opt reverses first..last; gap and reverse are unused
local function TwoOptIndex(i, first, last)
	return (i >= first and i <= last) and first + last - i or i
end

--[[
	Whether every node would still come after all it requires, were each node at index i moved to
	NewIndex(i, ...). positions is each node's index now. Checks a move without building the moved
	route, as the searches below weigh thousands of moves a pass and building each makes a lot of garbage
]]
local function IsValidMove(route, positions, NewIndex, first, last, gap, reverse)
	for i, node in ipairs(route) do
		local requires = node.requires
		if requires and #requires > 0 then
			local at = NewIndex(i, first, last, gap, reverse)
			for _, required in ipairs(requires) do
				local position = positions[required]
				if position and NewIndex(position, first, last, gap, reverse) >= at then
					return false
				end
			end
		end
	end
	return true
end

--[[
	Or-opt: takes a run of one to MAX_SEGMENT nodes out and puts it back, either way round, wherever it
	shortens the route most. Returns the new route, or nil when no move helps.

	The route without the run is never built: its node at index j is the route's at j, or at j + length
	past the run. Nor is a moved route, until a move is taken
]]
local function TryOrOpt(start, route, yield)
	local count = #route
	local positions = Positions(route)
	for length = 1, math.min(MAX_SEGMENT, count - 1) do
		for first = 1, count - length + 1 do
			local last = first + length - 1
			local firstPoint, lastPoint = Point(route[first]), Point(route[last])
			local previous = first == 1 and start or Point(route[first - 1])
			local following = route[last + 1] and Point(route[last + 1])

			-- What taking the run out saves
			local saving = Distance(previous, firstPoint)
			if following then
				saving = saving + Distance(lastPoint, following) - Distance(previous, following)
			end

			local restCount = count - length

			-- A lone node may also change candidate where it lands
			local single = length == 1 and route[first]
			local currentPenalty = firstPoint.penalty or 0

			for gap = 0, restCount do
				local before = gap == 0 and start or Point(route[gap < first and gap or gap + length])
				local afterNode = gap < restCount and route[gap + 1 < first and gap + 1 or gap + 1 + length]
				local after = afterNode and Point(afterNode)
				local join = after and Distance(before, after) or 0
				local forward = Distance(before, firstPoint) + (after and Distance(lastPoint, after) or 0) - join
				local backward = Distance(before, lastPoint) + (after and Distance(firstPoint, after) or 0) - join
				local reverse = backward < forward
				local cost = reverse and backward or forward
				local choice
				if single then
					for index, candidate in ipairs(single.candidates) do
						local candidateCost = Distance(before, candidate)
							+ (after and Distance(candidate, after) or 0)
							- join
							+ (candidate.penalty or 0)
							- currentPenalty
						if candidateCost < cost - EPSILON then
							cost, choice = candidateCost, index
						end
					end
				end
				local unchanged = gap == first - 1 and not reverse and not choice
				if not unchanged and cost < saving - EPSILON then
					if IsValidMove(route, positions, OrOptIndex, first, last, gap, reverse) then
						local moved = {}
						for i = 1, count do
							moved[OrOptIndex(i, first, last, gap, reverse)] = route[i]
						end
						if choice then
							single.choice = choice
						end
						return moved
					end
				end
			end
			yield()
		end
	end
	return nil
end

local function Reverse(route, first, last)
	while first < last do
		route[first], route[last] = route[last], route[first]
		first, last = first + 1, last - 1
	end
end

-- 2-opt: reverses the first stretch whose reversal shortens the route. Returns whether it found one
local function TryTwoOpt(start, route, yield)
	local count = #route
	local positions = Positions(route)
	for first = 1, count - 1 do
		local previous = first == 1 and start or Point(route[first - 1])
		local firstPoint = Point(route[first])
		for last = first + 1, count do
			local lastPoint = Point(route[last])
			local following = route[last + 1] and Point(route[last + 1])
			local delta = Distance(previous, lastPoint) - Distance(previous, firstPoint)
			if following then
				delta = delta + Distance(firstPoint, following) - Distance(lastPoint, following)
			end
			if delta < -EPSILON then
				if IsValidMove(route, positions, TwoOptIndex, first, last) then
					Reverse(route, first, last)
					return true
				end
			end
		end
		yield()
	end
	return false
end

-- Every move, over and over, until none helps
local function LocalSearch(start, route, yield)
	for _ = 1, MAX_PASSES do
		local improved = ImproveChoices(start, route, yield)
		local moved = TryOrOpt(start, route, yield)
		if moved then
			route = moved
			improved = true
		end
		if TryTwoOpt(start, route, yield) then
			improved = true
		end
		if not improved then
			break
		end
	end
	return route
end

--------------------------------------------------------------------------------
-- Shaking it loose
--------------------------------------------------------------------------------

local function SaveChoices(route)
	local choices = {}
	for i, node in ipairs(route) do
		choices[i] = node.choice
	end
	return choices
end

local function RestoreChoices(route, choices)
	for i, node in ipairs(route) do
		node.choice = choices[i]
	end
end

local function Copy(route)
	local copy = {}
	for i, node in ipairs(route) do
		copy[i] = node
	end
	return copy
end

--[[
	The local search stops at the first route no single move improves, which can be well short of the
	best. So a few times over, a couple of nodes are thrown somewhere else (anywhere their requirements
	allow, on any candidate) and the search runs again from there, keeping whichever route is shortest.
	The throws come from a fixed seed, so the same quests always give the same route, and the route
	doesn't flicker between equally good answers each time it's worked out again
]]
local function Shake(start, route, yield, most)
	local count = #route
	if count < 3 or most == 0 then
		return route
	end

	local seed = 20261105
	local function Random(n)
		seed = (seed * 1103515245 + 12345) % 2147483648
		return math.floor(seed / 65536) % n + 1
	end

	local dependents = {}
	for _, node in ipairs(route) do
		for _, required in ipairs(node.requires or {}) do
			dependents[required] = dependents[required] or {}
			table.insert(dependents[required], node)
		end
	end

	-- Each shake costs more the longer the route, so a long one gets fewer
	local shakes = math.min(most or SHAKES, SHAKES, math.max(MIN_SHAKES, math.floor(SHAKE_WORK / count)))
	local best, bestCost, bestChoices = route, Solver.Cost(start, route), SaveChoices(route)
	for _ = 1, shakes do
		local trial = Copy(best)
		RestoreChoices(trial, bestChoices)
		for _ = 1, THROWS do
			local node = table.remove(trial, Random(count))
			node.choice = Random(#node.candidates)
			local positions = Positions(trial)
			local firstSlot, lastSlot = FirstSlot(node, positions), #trial + 1
			for _, dependent in ipairs(dependents[node] or {}) do
				lastSlot = math.min(lastSlot, positions[dependent])
			end
			table.insert(trial, firstSlot + Random(lastSlot - firstSlot + 1) - 1, node)
		end
		trial = LocalSearch(start, trial, yield)
		local cost = Solver.Cost(start, trial)
		if cost < bestCost - EPSILON then
			best, bestCost, bestChoices = trial, cost, SaveChoices(trial)
		end
	end
	RestoreChoices(best, bestChoices)
	return best
end

--------------------------------------------------------------------------------
-- Keeping a camp whole
--------------------------------------------------------------------------------

local function Yards(a, b)
	local dx, dy = a.x - b.x, a.y - b.y
	return sqrt(dx * dx + dy * dy)
end

--[[
	Whether the node at index splits a camp: the places either side of it within CAMP_SPAN of each other,
	and going out to it and back more than CAMP_SPAN out of the way, and more than twice the walk it
	interrupts, so a place of the camp's own between two others never counts
]]
local function SplitsCamp(start, route, index)
	local previous = index == 1 and start or Point(route[index - 1])
	local nextNode = route[index + 1]
	if not nextNode then
		return false
	end
	local point, nextPoint = Point(route[index]), Point(nextNode)
	local leg = Yards(previous, nextPoint)
	local detour = Yards(previous, point) + Yards(point, nextPoint) - leg
	return leg <= CAMP_SPAN and detour > CAMP_SPAN and detour > 2 * leg
end

--[[
	The route never leaves a camp half done to come back to it: a node between two places within CAMP_SPAN
	of each other, when the trip out to it and back is more than that out of the way, a turn-in in town
	between two camps of mobs in the hills, moves to where it costs least without splitting one, nowhere before what it waits on or
	after what waits on it. The shortest route in yards will do it now and then, when the walk out and back
	is only a little shorter than going on and coming to it later, and nothing reads worse on the map.
	Where no other place will do, it stays
]]
local function KeepCampsWhole(start, route, yield)
	for _ = 1, #route do
		local moved = false
		for index = 1, #route do
			if SplitsCamp(start, route, index) then
				local node = table.remove(route, index)
				local positions = Positions(route)
				local firstSlot, lastSlot = FirstSlot(node, positions), #route + 1
				for _, other in ipairs(route) do
					for _, required in ipairs(other.requires or {}) do
						if required == node then
							lastSlot = math.min(lastSlot, positions[other])
						end
					end
				end
				local point, bestSlot, bestCost = Point(node), nil, nil
				for slot = firstSlot, lastSlot do
					table.insert(route, slot, node)
					if not SplitsCamp(start, route, slot) then
						local previous = slot == 1 and start or Point(route[slot - 1])
						local nextNode = route[slot + 1]
						local cost = Distance(previous, point)
						if nextNode then
							local nextPoint = Point(nextNode)
							cost = cost + Distance(point, nextPoint) - Distance(previous, nextPoint)
						end
						if not bestCost or cost < bestCost then
							bestSlot, bestCost = slot, cost
						end
					end
					table.remove(route, slot)
				end
				table.insert(route, bestSlot or index, node)
				moved = bestSlot ~= nil and bestSlot ~= index
				if moved then
					break
				end
			end
		end
		yield()
		if not moved then
			break
		end
	end
	return route
end

--------------------------------------------------------------------------------
-- Starting from the last route
--------------------------------------------------------------------------------

--[[
	What Solve needs of a route to start the next one from it: its nodes' keys in order, and the place each
	was chosen at
]]
function Solver.Snapshot(route)
	local keys, points = {}, {}
	for index, node in ipairs(route) do
		if node.key then
			keys[index] = node.key
			local point = Point(node)
			points[node.key] = point and { x = point.x, y = point.y } or nil
		end
	end
	return { keys = keys, points = points }
end

-- The candidate nearest a place, nil when there's none within WARM_REACH of it
local function NearestCandidate(node, place)
	local best, bestSquared
	for choice, candidate in ipairs(node.candidates) do
		local dx, dy = candidate.x - place.x, candidate.y - place.y
		local squared = dx * dx + dy * dy
		if not bestSquared or squared < bestSquared then
			best, bestSquared = choice, squared
		end
	end
	return bestSquared and bestSquared <= WARM_REACH * WARM_REACH and best or nil
end

--[[
	The last route (previous, a Snapshot) as the start of this one: its nodes still here, in its order, each
	at the candidate nearest where it was. A node whose required nodes aren't all in yet waits, and goes in
	as soon as they are; one still waiting at the end, and every node new since, Construct adds. Returns the
	route and the set of its nodes
]]
local function WarmRoute(nodes, previous)
	local byKey = {}
	for _, node in ipairs(nodes) do
		if node.key then
			byKey[node.key] = node
		end
	end
	local route, placed, waiting = {}, {}, {}
	local function Place(node)
		local place = previous.points[node.key]
		node.choice = place and NearestCandidate(node, place) or node.choice
		route[#route + 1] = node
		placed[node] = true
	end
	for index = 1, #previous.keys do
		local node = byKey[previous.keys[index]]
		if node and not placed[node] then
			if IsReady(node, placed) then
				Place(node)
				-- Whatever was waiting on it, and on those, goes in now, in the order it came
				local placedOne = true
				while placedOne do
					placedOne = false
					for position, other in ipairs(waiting) do
						if IsReady(other, placed) then
							table.remove(waiting, position)
							Place(other)
							placedOne = true
							break
						end
					end
				end
			else
				waiting[#waiting + 1] = node
			end
		end
	end
	return route, placed
end

--[[
	The nodes in route order, each with node.choice set to the candidate it uses, and the route's cost.
	start is { x, y }. Nodes with no candidates are left out.

	With previous, the last route's Snapshot, it starts from that route (WarmRoute), adds only what's new,
	and shakes it at most WARM_SHAKES times rather than up to SHAKES: between two plans little changes, an
	objective done or a quest taken, and the last route was shaken already. Played through eight zones
	offline, a plan took about 40% less time for 1% more walking, within what cold plans vary by, and the
	route doesn't reshuffle between equally good answers
]]
function Solver.Solve(start, nodes, yield, previous)
	yield = yield or NoYield
	local usable = {}
	for _, node in ipairs(nodes) do
		if node.candidates and #node.candidates > 0 then
			node.choice = 1
			usable[#usable + 1] = node
		end
	end

	-- A node can't wait on one that was left out
	local kept = {}
	for _, node in ipairs(usable) do
		kept[node] = true
	end
	for _, node in ipairs(usable) do
		if node.requires then
			local requires = {}
			for _, required in ipairs(node.requires) do
				if kept[required] then
					requires[#requires + 1] = required
				end
			end
			node.requires = requires
		end
	end

	local route
	if previous then
		route = LocalSearch(start, Construct(start, usable, yield, WarmRoute(usable, previous)), yield)
		route = KeepCampsWhole(start, Shake(start, route, yield, WARM_SHAKES), yield)
	else
		route = LocalSearch(start, Construct(start, usable, yield), yield)
		route = KeepCampsWhole(start, Shake(start, route, yield), yield)
	end
	return route, Solver.Cost(start, route)
end
