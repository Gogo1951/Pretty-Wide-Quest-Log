local _, ns = ...

--[[
	Routes: What to Route's Route Focus (routeFocus), how the route chooses and orders what to pick up, on
	top of the solver's shortest order (Routes-Solver.lua). Quests already in the log are always on the
	route: Most XP per Hour never drops them.

	Fastest Clear ("fastest", the default): the solver's order as it is, every quest the settings allow with
	the least walking.

	Most XP per Hour ("xp", experimental): solved once, then quests to pick up that pay less XP for the time
	they add than the route as a whole earns are dropped, worst first, each with everything planned after
	it (its objectives, turn-in and follow-ups), and the rest solved again from what's left. Time is the walk
	at RUN_SPEED and KILL_SECONDS a kill or item, counted from Questie's objective text; XP is Questie's for
	the quest at the player's level (QuestXP) and MobXP for each kill. A dropped quest that's available now
	is on the map only, saying why. One Zone Info's + asked for, one put on the route from its marker, and
	one the party has are never dropped. Played through the Barrens offline, the route earned 14% more XP an
	hour; how much depends on the seconds a kill really takes.

	Either way, no area is worked before every quest planned there is taken (GatherAreas): pick-ups, then
	objectives, then turn-ins
]]

local routes = ns.routes

local AREA_SPAN = 200 -- Yards apart two objectives' places can be and still be one area
local MAX_AREA_DEPTH = 5 -- Quests deep along a chain whose pick-up an area waits for, as the maintainer chose
local RUN_SPEED = 7 -- Yards a second, running
local KILL_SECONDS = 25 -- Seconds a kill or an item to collect takes, fighting and looting
local MOST_KILLS = 30 -- A number in an objective's text above this isn't a count

--------------------------------------------------------------------------------
-- Every quest for an area before working it
--------------------------------------------------------------------------------

-- A node's place on the route as solved
local function Point(node)
	return node.candidates and node.candidates[node.choice or 1]
end

-- Whether two places are one area: within AREA_SPAN of each other, or their camps overlapping
local function IsSameArea(a, b)
	local dx, dy = a.x - b.x, a.y - b.y
	local reach = math.max(AREA_SPAN, (a.radius or 0) + (b.radius or 0))
	return dx * dx + dy * dy <= reach * reach
end

--[[
	How many quests deep a pick-up is: 1 for a quest available now, and one more than the quest whose
	turn-in unlocks it for a follow-up, a quest in the log counting 1
]]
local function Depth(pickUp, depths)
	if depths[pickUp] then
		return depths[pickUp]
	end
	depths[pickUp] = 1
	local depth = 1
	for _, required in ipairs(pickUp.requires or {}) do
		if required.kind == "turnIn" then
			local before = required.pickUpNode
			depth = math.max(depth, 1 + (before and Depth(before, depths) or 1))
		end
	end
	depths[pickUp] = depth
	return depth
end

--[[
	The solved route again, with no area worked before every quest planned there is taken: each objective
	waits on the pick-up of every other quest with an objective planned in its area, up to MAX_AREA_DEPTH
	quests deep along its chain (Routes-Chains.lua, with Plan Ahead), so the area is done once, for all of
	them, and no kill there goes to waste. Not where that pick-up already waits on the objective, as a
	follow-up waits on the quest before it, nor for a timed or escort quest's objective, which won't wait.
	Solved again from the first route; as it was where nothing has to wait
]]
local function GatherAreas(start, route, cost, yield)
	local depths, planned = {}, {}
	for _, node in ipairs(route) do
		local pickUp = node.kind == "objective" and node.predicted and node.pickUpNode
		if pickUp and Point(node) and Depth(pickUp, depths) <= MAX_AREA_DEPTH then
			planned[#planned + 1] = node
		end
	end
	if #planned == 0 then
		return route, cost
	end
	local gated = false
	for _, node in ipairs(route) do
		local point = Point(node)
		if node.kind == "objective" and not node.urgent and point then
			local requires
			for _, other in ipairs(planned) do
				local pickUp = other.pickUpNode
				if
					other.questID ~= node.questID
					and IsSameArea(point, Point(other))
					and not routes.WaitsFor(node, pickUp, {})
					and not routes.WaitsFor(pickUp, node, {})
				then
					if not requires then
						requires = {}
						for _, required in ipairs(node.requires or {}) do
							requires[#requires + 1] = required
						end
						node.requires = requires
					end
					requires[#requires + 1] = pickUp
					gated = true
				end
			end
		end
		yield()
	end
	if not gated then
		return route, cost
	end
	local Solver = ns.routesSolver
	return Solver.Solve(start, route, yield, Solver.Snapshot(route))
end

--------------------------------------------------------------------------------
-- Most XP per Hour
--------------------------------------------------------------------------------

-- Questie's XP for a quest at the player's level, 0 where it has none
local function QuestRewardXP(questID)
	local QuestXP = ns.ImportQuestieModule("QuestXP")
	if QuestXP and type(QuestXP.GetQuestLogRewardXP) == "function" then
		local ok, xp = pcall(QuestXP.GetQuestLogRewardXP, QuestXP, questID, false)
		if ok and tonumber(xp) then
			return tonumber(xp)
		end
	end
	return 0
end

-- XP for a kill of a creature at the player's level, as Classic gives it
local function MobXP()
	return 45 + 5 * UnitLevel("player")
end

-- The counts in a quest's objective text ("Bring 8 Zhevra Hooves"), in order, from Questie's database, once a quest
local countsCache = {}

local function Counts(questID)
	if countsCache[questID] then
		return countsCache[questID]
	end
	local counts = {}
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local ok, text = false, nil
	if QuestieDB and type(QuestieDB.QueryQuestSingle) == "function" then
		ok, text = pcall(QuestieDB.QueryQuestSingle, questID, "objectivesText")
	end
	if ok and type(text) == "table" then
		for _, line in ipairs(text) do
			for number in tostring(line):gmatch("(%d+)") do
				number = tonumber(number)
				if number and number <= MOST_KILLS then
					counts[#counts + 1] = number
				end
			end
		end
	end
	countsCache[questID] = counts
	return counts
end

-- Kills or items an objective node still takes: the log's own count, else the objective text's, at least 1
local function Kills(node)
	local objective = node.objective
	local needed = objective and tonumber(objective.Needed)
	if needed then
		return math.max(1, math.min(MOST_KILLS, needed - (tonumber(objective.Collected) or 0)))
	end
	local counts = Counts(node.questID)
	local index = objective and tonumber(objective.Index) or 1
	return counts[index] or counts[1] or 1
end

-- The whole of a quest's work in kills, for one to pick up whose objectives aren't planned
local function AllKills(questID)
	local total = 0
	for _, count in ipairs(Counts(questID)) do
		total = total + count
	end
	return math.max(1, total)
end

local function Seconds(a, b)
	local dx, dy = b.x - a.x, b.y - a.y
	return math.sqrt(dx * dx + dy * dy) / RUN_SPEED
end

--[[
	A node's XP and the seconds of work it takes there: a turn-in pays the quest's XP, an objective its
	kills' and takes their time. A quest to pick up whose objectives aren't planned (one not planned whole,
	Routes-Chains.lua) counts its quest's XP and work at its pick-up, as it'll be done once it's taken
]]
local function Worth(node, planned)
	if node.kind == "turnIn" then
		return QuestRewardXP(node.questID), 0
	elseif node.kind == "objective" then
		local kills = Kills(node)
		return kills * MobXP(), kills * KILL_SECONDS
	elseif node.kind == "pickUp" and not planned[node.questID] then
		return QuestRewardXP(node.questID), AllKills(node.questID) * KILL_SECONDS
	end
	return 0, 0
end

-- Seconds saved by taking the gone nodes out of the route, the legs mended around each gap
local function Saving(start, route, gone, work)
	local saved, previous, index = 0, start, 1
	while index <= #route do
		local node = route[index]
		if gone[node] then
			local from = previous
			while index <= #route and gone[route[index]] do
				local point = Point(route[index]) or from
				saved = saved + Seconds(from, point) + work[route[index]]
				from = point
				index = index + 1
			end
			local nextPoint = route[index] and Point(route[index])
			if nextPoint then
				saved = saved + Seconds(from, nextPoint) - Seconds(previous, nextPoint)
			end
		else
			previous = Point(node) or previous
			index = index + 1
		end
	end
	return saved
end

-- Whether a quest to pick up may be dropped: not one asked for, put on the route by hand, or the party's
local function IsDroppable(node)
	return node.kind == "pickUp"
		and not node.party
		and not node.wanted
		and not node.shared
		and not routes.added[node.key]
end

local function MostXP(start, nodes, yield, previous)
	local Solver = ns.routesSolver
	local route, cost = Solver.Solve(start, nodes, yield, previous)

	-- What waits on each node, so a quest dropped takes everything planned after it
	local dependents = {}
	local planned = {} -- Quests planned whole: their objectives are nodes of their own
	for _, node in ipairs(route) do
		for _, required in ipairs(node.requires or {}) do
			dependents[required] = dependents[required] or {}
			table.insert(dependents[required], node)
		end
		if node.predicted and node.kind ~= "pickUp" then
			planned[node.questID] = true
		end
	end
	local xp, work = {}, {}
	for _, node in ipairs(route) do
		xp[node], work[node] = Worth(node, planned)
	end

	local dropped, current = {}, route
	while true do
		local totalXP, totalSeconds, previousPoint = 0, 0, start
		for _, node in ipairs(current) do
			local point = Point(node) or previousPoint
			totalXP = totalXP + xp[node]
			totalSeconds = totalSeconds + Seconds(previousPoint, point) + work[node]
			previousPoint = point
		end
		if totalSeconds <= 0 then
			break
		end
		local rate = totalXP / totalSeconds
		local present = {}
		for _, node in ipairs(current) do
			present[node] = true
		end
		local worstRate, worstUnit, worstRoot
		for _, node in ipairs(current) do
			if IsDroppable(node) then
				local unit, stack, unitXP = { [node] = true }, { node }, 0
				while #stack > 0 do
					local item = table.remove(stack)
					unitXP = unitXP + xp[item]
					for _, dependent in ipairs(dependents[item] or {}) do
						if present[dependent] and not unit[dependent] and not dependent.party then
							unit[dependent] = true
							stack[#stack + 1] = dependent
						end
					end
				end
				local saved = Saving(start, current, unit, work)
				local unitRate = saved > 0 and unitXP / saved or math.huge
				if unitRate < rate and (not worstRate or unitRate < worstRate) then
					worstRate, worstUnit, worstRoot = unitRate, unit, node
				end
			end
		end
		yield()
		if not worstUnit then
			break
		end
		local rest = {}
		for _, node in ipairs(current) do
			if not worstUnit[node] then
				rest[#rest + 1] = node
			end
		end
		current = rest
		dropped[#dropped + 1] = worstRoot
	end
	if #dropped == 0 then
		return route, cost
	end

	--[[
		A dropped quest available now is on the map only, saying why, so Questie's own icon for it is hidden
		as for every other pick-up; a right-click puts it back on the route. A follow-up dropped isn't
		available yet, so it's simply left out
	]]
	local mapOnly = routes.mapOnlyPickUps
	for _, node in ipairs(dropped) do
		if not node.predicted and node.blobs then
			node.offRoute = "xp"
			node.chained = nil
			mapOnly[#mapOnly + 1] = { task = node, blobs = node.blobs, instance = start.instance }
		end
	end
	return Solver.Solve(start, current, yield, Solver.Snapshot(current))
end

--------------------------------------------------------------------------------
-- The route, by its focus
--------------------------------------------------------------------------------

--[[
	The nodes in route order and the route's cost, as Solver.Solve returns them, ordered and chosen by Route
	Focus. previous is the last route's Snapshot, as Solve takes it
]]
function routes.SolveForFocus(start, nodes, yield, previous)
	local route, cost
	if routes.Settings().routeFocus == "xp" then
		route, cost = MostXP(start, nodes, yield, previous)
	else
		route, cost = ns.routesSolver.Solve(start, nodes, yield, previous)
	end
	return GatherAreas(start, route, cost, yield)
end
