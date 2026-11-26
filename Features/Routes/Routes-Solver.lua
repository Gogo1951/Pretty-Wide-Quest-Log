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
	would make over 100 MB of garbage a plan. Only the moves round what last changed are weighed again
	(LocalSearch), and each leg's cost is worked out once a plan (Distance): played through offline, a
	plan of 100 stops took a third to a fifth of the time it did, for routes as short.

	The caller passes a yield function, called often, which can pause the work and pick it up on the next
	frame.

	Each node: { candidates = { { x, y, penalty }, ... }, requires = { node, ... } }. x and y are in
	yards; a candidate's penalty is added to the route's length when it is chosen, so a sparse spot loses
	out to a dense one unless it's on the way. Solve sets node.choice and returns the nodes in order.

	A leg costs its yards, and a trip somewhere else costs TRIP_COST more: a leg within a camp nothing
	more, one past TRIP_FAR all of it, between the two a share. The shortest route in yards alone will
	leave a camp half done for a turn-in or another camp and come back, when finishing the camp first is
	all but as short; this keeps it to finishing what's around before setting off

	Flight paths are shortcuts, and a flight costs nothing (start.flights, Routes-Flights.lua). A flight
	sets off from any flight master of the player's in the zone, as talking to one the character hasn't
	discovered discovers it, and lands at one whose flight path the character has. A leg costs the shorter
	of walking it and walking from its start to the nearest flight master, flying, and walking on from the
	known one nearest its end. So a flight path not yet discovered that's closer than the way back is
	walked on to and flown back from. The nearest at each end is always the best pair, so a leg stays a
	lookup however many flight masters there are. A flight the player ignored (start.skippedFlights) is
	walked instead. A flight can't always be flown back, so a leg can cost more one way than the other
]]

local Solver = {}
ns.routesSolver = Solver

local EPSILON = 0.01 -- Yards: a move has to save more than this to count
local MAX_SEGMENT = 3 -- Longest run of nodes or-opt moves at once
local MAX_MOVES = 1000 -- Moves at most one local search makes
local SHAKES = 32 -- Times the finished route is shaken up and improved again, for a short route
local MIN_SHAKES = 8 -- For a long one
local SHAKE_WORK = 1600 -- Shakes times nodes, which sets how many a route of some length gets
local THROWS = 2 -- Nodes thrown somewhere else in each shake
local WARM_SHAKES = 16 -- Shakes at most for a route started from the last one, which was shaken already
local WARM_REACH = 150 -- Yards a candidate can be from where the last route had a node and still be its place

local TRIP_NEAR = 100 -- Yards a leg can be and still be within one camp
local TRIP_FAR = 300 -- Yards past which a leg is a trip somewhere else
local TRIP_COST = 150 -- Yards a trip somewhere else counts for more than its length
local CAMP_SPAN = 200 -- Yards apart two places in a row can be and still be one camp, and yards out of the way a side trip from it can't be
local FLIGHT_COST = 0 -- Yards a flight counts for: none, so any flight that saves a step is taken

local sqrt = math.sqrt

--[[
	The flight masters the plan underway can fly from, each { x, y, known, ... } (known: it can be flown to
	as well), or nil, and a count that changes with each plan, so a place's nearest flight masters
	(FlightYards) are worked out again for it
]]
local flights, flightPlan = nil, 0

-- The flights the player ignored, from flight master NPC ID to a set of the ones to fly to, or nil
local skippedFlights = nil

--[[
	Yards from a place to the nearest flight master to fly from, and which, then to the nearest one to land
	at, and which: worked out once a plan
]]
local function FlightYards(point)
	if point.flightPlan ~= flightPlan then
		local fromYards, fromIndex, toYards, toIndex = math.huge, nil, math.huge, nil
		for i, flight in ipairs(flights) do
			local dx, dy = flight.x - point.x, flight.y - point.y
			local yards = sqrt(dx * dx + dy * dy)
			if yards < fromYards then
				fromYards, fromIndex = yards, i
			end
			if flight.known and yards < toYards then
				toYards, toIndex = yards, i
			end
		end
		point.flightFromYards, point.flightFrom = fromYards, fromIndex
		point.flightToYards, point.flightTo = toYards, toIndex
		point.flightPlan = flightPlan
	end
	return point.flightFromYards, point.flightFrom, point.flightToYards, point.flightTo
end

-- Whether the plan may fly between two of its flight masters, by index: two different ones, not ignored
local function CanFly(from, to)
	if not (from and to) or from == to then
		return false
	end
	local skippedFrom = skippedFlights and skippedFlights[flights[from].npcID]
	return not (skippedFrom and skippedFrom[flights[to].npcID])
end

-- What a leg costs: its yards, walked or partly flown, plus a share of TRIP_COST for setting off somewhere else
local function LegCost(a, b)
	local dx, dy = a.x - b.x, a.y - b.y
	local yards = sqrt(dx * dx + dy * dy)
	if flights then
		local fromYards, from = FlightYards(a)
		local _, _, toYards, to = FlightYards(b)
		local flown = fromYards + toYards + FLIGHT_COST
		if flown < yards and CanFly(from, to) then
			yards = flown
		end
	end
	if yards <= TRIP_NEAR then
		return yards
	elseif yards >= TRIP_FAR then
		return yards + TRIP_COST
	end
	return yards + TRIP_COST * (yards - TRIP_NEAR) / (TRIP_FAR - TRIP_NEAR)
end

--[[
	Each leg's cost, by its two places, for the plan underway: the searches weigh the same legs over and
	over, and with flight paths a leg is more than a square root. Kept for every Solve of one plan (Route
	Focus solves twice), as its legs cost the same; a new plan starts it again
]]
local legs, legsFor

local function Distance(a, b)
	local row = legs[a]
	if row then
		local d = row[b]
		if d then
			return d
		end
	else
		row = {}
		legs[a] = row
	end
	local d = LegCost(a, b)
	row[b] = d
	return d
end

local function NoYield() end

local function Point(node)
	return node.candidates[node.choice]
end

local NONE = {} -- For a node that requires nothing, so the loops over requirements make no table

--[[
	Each node's place in the route. The searches ask for it thousands of times a plan, so each plan's
	coroutine (the planner yields between frames) fills one table over and over rather than making a new
	one each time; a coroutine done with is let go (weak keys). Each caller is done with it before the next
	asks, and none holds it across a call that asks again
]]
local positionsFor = setmetatable({}, { __mode = "k" })
local MAIN_THREAD = {}

local function Positions(route)
	local thread = coroutine.running() or MAIN_THREAD
	local positions = positionsFor[thread]
	if positions then
		wipe(positions)
	else
		positions = {}
		positionsFor[thread] = positions
	end
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
	for _, required in ipairs(node.requires or NONE) do
		if not placed[required] then
			return false
		end
	end
	return true
end

-- The first place a node may go: after the last node it requires
local function FirstSlot(node, positions)
	local slot = 1
	for _, required in ipairs(node.requires or NONE) do
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

--[[
	Gives the node at index i the candidate that fits best between its neighbors. Returns whether it changed
]]
local function ImproveChoice(start, route, i)
	local node = route[i]
	if #node.candidates < 2 then
		return false
	end
	local previous = i == 1 and start or Point(route[i - 1])
	local nextPoint = route[i + 1] and Point(route[i + 1])
	local bestChoice, bestCost = node.choice, LocalCost(previous, Point(node), nextPoint)
	for choice, candidate in ipairs(node.candidates) do
		local cost = LocalCost(previous, candidate, nextPoint)
		if cost < bestCost - EPSILON then
			bestChoice, bestCost = choice, cost
		end
	end
	if bestChoice == node.choice then
		return false
	end
	node.choice = bestChoice
	return true
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
	What reversing the stretch first..last adds to its own legs: walked backward less walked forward. Nothing
	where every leg costs the same either way; a flight can't always be taken back (Distance)
]]
local function Reversal(route, first, last)
	local added = 0
	for i = first, last - 1 do
		local a, b = Point(route[i]), Point(route[i + 1])
		added = added + Distance(b, a) - Distance(a, b)
	end
	return added
end

--[[
	Or-opt for one run: takes the nodes first..last out and puts them back, either way round, in the first
	gap from fromGap to toGap (in the route without the run) where that shortens the route; a lone node may
	also change candidate there. Returns the moved route and the nodes whose legs changed, or nil.

	The route without the run is never built: its node at index j is the route's at j, or at j + length
	past the run. Nor is a moved route, until a move is taken
]]
local function TrySegment(start, route, positions, first, last, fromGap, toGap)
	local count = #route
	local length = last - first + 1
	local restCount = count - length
	local firstPoint, lastPoint = Point(route[first]), Point(route[last])
	local previous = first == 1 and start or Point(route[first - 1])
	local following = route[last + 1] and Point(route[last + 1])

	-- What taking the run out saves
	local saving = Distance(previous, firstPoint)
	if following then
		saving = saving + Distance(lastPoint, following) - Distance(previous, following)
	end
	local reversal = length > 1 and Reversal(route, first, last) or 0

	-- A lone node may also change candidate where it lands
	local single = length == 1 and route[first]
	local currentPenalty = firstPoint.penalty or 0

	for gap = math.max(0, fromGap), math.min(restCount, toGap) do
		local before = gap == 0 and start or Point(route[gap < first and gap or gap + length])
		local afterNode = gap < restCount and route[gap + 1 < first and gap + 1 or gap + 1 + length]
		local after = afterNode and Point(afterNode)
		local join = after and Distance(before, after) or 0
		local forward = Distance(before, firstPoint) + (after and Distance(lastPoint, after) or 0) - join
		local backward = Distance(before, lastPoint) + (after and Distance(firstPoint, after) or 0) - join + reversal
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
				local touched = { route[first - 1], route[last + 1], afterNode }
				if gap > 0 then
					touched[#touched + 1] = route[gap < first and gap or gap + length]
				end
				local moved = {}
				for i = 1, count do
					moved[OrOptIndex(i, first, last, gap, reverse)] = route[i]
				end
				for i = first, last do
					touched[#touched + 1] = route[i]
				end
				if choice then
					single.choice = choice
				end
				return moved, touched
			end
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

--[[
	2-opt for one stretch: reverses first..last where that shortens the route. Returns the nodes whose legs
	changed, or nil
]]
local function TryReverse(start, route, positions, first, last)
	local previous = first == 1 and start or Point(route[first - 1])
	local firstPoint, lastPoint = Point(route[first]), Point(route[last])
	local following = route[last + 1] and Point(route[last + 1])
	local delta = Distance(previous, lastPoint) - Distance(previous, firstPoint)
	if following then
		delta = delta + Distance(firstPoint, following) - Distance(lastPoint, following)
	end
	if delta >= -EPSILON or delta + Reversal(route, first, last) >= -EPSILON then
		return nil
	end
	if not IsValidMove(route, positions, TwoOptIndex, first, last) then
		return nil
	end
	local touched = { route[first - 1], route[first], route[last], route[last + 1] }
	Reverse(route, first, last)
	return touched
end

--[[
	Every move that changes a leg of the node at index p: a new candidate for it, a run of one to
	MAX_SEGMENT nodes starting or ending with it moved anywhere (or-opt), any such run moved in beside it, and
	a stretch reversed (2-opt) whose ends meet it. The first that helps is taken. Returns the route, the
	nodes whose legs changed, nil when no move helped
]]
local function TryNode(start, route, positions, p)
	local count = #route
	if ImproveChoice(start, route, p) then
		return route, { route[p - 1], route[p], route[p + 1] }
	end
	for length = 1, math.min(MAX_SEGMENT, count - 1) do
		for side = 1, length == 1 and 1 or 2 do
			local first = side == 1 and p or p - length + 1 -- The run starting with it, then ending with it
			local last = first + length - 1
			if first >= 1 and last <= count then
				local moved, touched = TrySegment(start, route, positions, first, last, 0, count)
				if moved then
					return moved, touched
				end
			end
		end
	end
	for length = 1, math.min(MAX_SEGMENT, count - 1) do
		for first = 1, count - length + 1 do
			local last = first + length - 1
			if p < first or p > last then
				local at = p < first and p or p - length -- Its index in the route without the run
				local moved, touched = TrySegment(start, route, positions, first, last, at - 1, at)
				if moved then
					return moved, touched
				end
			end
		end
	end
	for first = p, p + 1 do
		for last = first + 1, count do
			local touched = TryReverse(start, route, positions, first, last)
			if touched then
				return route, touched
			end
		end
	end
	for last = p - 1, p do
		for first = 1, last - 1 do
			local touched = TryReverse(start, route, positions, first, last)
			if touched then
				return route, touched
			end
		end
	end
	return route, nil
end

--[[
	Every move, over and over, until none helps. Only the nodes in active (all of them without it) are looked
	at first, and then each whose legs a move changed: a move far from any change was weighed already and
	still doesn't help. A shake throws a couple of nodes elsewhere, so it weighs the moves round those and not
	every move of the whole route again
]]
local function LocalSearch(start, route, yield, active)
	local queue, queued, head, tail = {}, {}, 1, 0
	local function Activate(node)
		if node and not queued[node] then
			queued[node] = true
			tail = tail + 1
			queue[tail] = node
		end
	end
	for _, node in ipairs(route) do
		if not active or active[node] then
			Activate(node)
		end
	end
	local positions, moves = Positions(route), 0
	while head <= tail and moves < MAX_MOVES do
		local node = queue[head]
		queue[head], queued[node], head = nil, nil, head + 1
		local moved, touched = TryNode(start, route, positions, positions[node])
		if touched then
			moves = moves + 1
			route = moved
			positions = Positions(route)
			Activate(node)
			for _, other in pairs(touched) do
				Activate(other)
			end
		end
		yield()
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
		for _, required in ipairs(node.requires or NONE) do
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
		local thrown = {} -- Each node thrown and its neighbors, before and after, for the search to start from
		for _ = 1, THROWS do
			local index = Random(count)
			local node = table.remove(trial, index)
			node.choice = Random(#node.candidates)
			local positions = Positions(trial)
			local firstSlot, lastSlot = FirstSlot(node, positions), #trial + 1
			for _, dependent in ipairs(dependents[node] or NONE) do
				lastSlot = math.min(lastSlot, positions[dependent])
			end
			local slot = firstSlot + Random(lastSlot - firstSlot + 1) - 1
			table.insert(trial, slot, node)
			for _, other in pairs({ trial[index - 1], trial[index], trial[slot - 1], node, trial[slot + 1] }) do
				thrown[other] = true
			end
		end
		trial = LocalSearch(start, trial, yield, thrown)
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
					for _, required in ipairs(other.requires or NONE) do
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
	The nodes of a route started from the last one (WarmRoute) whose legs aren't the last route's: next to a
	node new since, or done since, or moved to wait on another, and the first, as the player has moved. The
	rest of the route was searched already, so the local search starts from these
]]
local function Changed(start, route, previous)
	local order = {}
	for index, key in pairs(previous.keys) do
		order[key] = index
	end
	-- Nothing left to route (the last waypoint done since): nothing changed
	local changed = {}
	if not route[1] then
		return changed
	end
	changed[route[1]] = true
	for i = 1, #route - 1 do
		local a, b = order[route[i].key], order[route[i + 1].key]
		if not (a and b and b == a + 1) then
			changed[route[i]], changed[route[i + 1]] = true, true
		end
	end
	for i, node in ipairs(route) do
		if ImproveChoice(start, route, i) then
			changed[route[i - 1] or node], changed[node] = true, true
			if route[i + 1] then
				changed[route[i + 1]] = true
			end
		end
	end
	return changed
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
	flights = start.flights
	skippedFlights = start.skippedFlights
	flightPlan = flightPlan + 1
	if start ~= legsFor then
		legs, legsFor = {}, start
	end
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
		route = Construct(start, usable, yield, WarmRoute(usable, previous))
		route = LocalSearch(start, route, yield, Changed(start, route, previous))
		route = KeepCampsWhole(start, Shake(start, route, yield, WARM_SHAKES), yield)
	else
		route = LocalSearch(start, Construct(start, usable, yield), yield)
		route = KeepCampsWhole(start, Shake(start, route, yield), yield)
	end
	return route, Solver.Cost(start, route)
end

--[[
	Where a leg between two places flies, as the last plan weighed it (Distance): the flight master to fly
	from and the one to fly to, or nothing where walking is shorter or the flight was ignored
]]
function Solver.FlightLeg(a, b)
	if not flights then
		return nil
	end
	local fromYards, from = FlightYards(a)
	local _, _, toYards, to = FlightYards(b)
	local dx, dy = a.x - b.x, a.y - b.y
	if CanFly(from, to) and fromYards + toYards + FLIGHT_COST < sqrt(dx * dx + dy * dy) then
		return flights[from], flights[to]
	end
end
