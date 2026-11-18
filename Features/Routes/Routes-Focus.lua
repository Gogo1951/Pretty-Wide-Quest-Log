local _, ns = ...

--[[
	Routes: What to Route's Route Focus (routeFocus), how the route chooses and orders what to pick up, on
	top of the solver's shortest order (Routes-Solver.lua). Quests already in the log are always on the
	route: Easiest First may only reorder them, and Most XP per Hour never drops them.

	Fastest Clear ("fastest"): the solver's order as it is, every quest the settings allow with the least
	walking.

	Easiest First ("easiest", the default): solved once as Fastest Clear, then again with each harder quest's
	pick-up and objectives (more than EASY_ABOVE levels over the player) waiting on every easier quest's
	objectives, the first route as its start. The second is kept where it walks at most EASIEST_SLACK more,
	else the first: easier quests first where it costs little. An easier objective that itself waits on a
	harder quest (a follow-up of one) doesn't hold the harder ones back, so nothing waits on itself.
	Turn-ins, timed quests, the party's nodes and quests the player asked for (IsAskedFor) keep their place.

	Most XP per Hour ("xp", experimental): solved once, then quests to pick up that pay less XP for the time
	they add than the route as a whole earns are dropped, worst first, each with everything planned after
	it (its objectives, turn-in and follow-ups), and the rest solved again from what's left. Time is the walk
	at RUN_SPEED and KILL_SECONDS a kill or item, counted from Questie's objective text; XP is Questie's for
	the quest at the player's level (QuestXP) and MobXP for each kill. A dropped quest that's available now
	is on the map only, saying why. One Zone Info's + asked for, one put on the route from its marker, and
	one the party has are never dropped. Played through the Barrens offline, the route earned 14% more XP an
	hour; how much depends on the seconds a kill really takes
]]

local routes = ns.routes

local EASY_ABOVE = 1 -- Levels over the player a quest can be and still be one of the easier ones
local EASIEST_SLACK = 1.1 -- Easiest First's route can cost this many times Fastest Clear's
local RUN_SPEED = 7 -- Yards a second, running
local KILL_SECONDS = 25 -- Seconds a kill or an item to collect takes, fighting and looting
local MOST_KILLS = 30 -- A number in an objective's text above this isn't a count

--------------------------------------------------------------------------------
-- Easiest First
--------------------------------------------------------------------------------

-- A node's quest level, nil for none or a quest at the player's own level whatever it is
local function NodeLevel(node)
	local level = node.quest and tonumber(node.quest.level)
	return level and level > 0 and level or nil
end

--[[
	Whether the player asked for a quest to pick up, or its planned objectives: one Zone Info's + asked for,
	one put on the route from its map marker, or one the party has. It keeps its place, however hard: held
	back behind every easier objective it would drop off the waypoints the map draws
]]
local function IsAskedFor(node)
	local pickUp = node.kind == "pickUp" and node or node.pickUpNode
	return pickUp ~= nil and (pickUp.wanted or pickUp.shared or routes.added[pickUp.key]) and true or false
end

local function Easiest(start, nodes, yield, previous)
	local Solver = ns.routesSolver
	local route, cost = Solver.Solve(start, nodes, yield, previous)
	local player = UnitLevel("player")
	local hard, easy, isHard = {}, {}, {}
	for _, node in ipairs(route) do
		local level = NodeLevel(node)
		if level and not node.party and not node.urgent and node.kind ~= "turnIn" and not IsAskedFor(node) then
			if level > player + EASY_ABOVE then
				hard[#hard + 1] = node
				isHard[node] = true
			elseif node.kind == "objective" then
				easy[#easy + 1] = node
			end
		end
	end
	if #hard == 0 or #easy == 0 then
		return route, cost
	end

	-- Whether a node waits, however far back, on a harder one: it can't hold the harder ones back
	local waitsOnHard = {}
	local function WaitsOnHard(node)
		if waitsOnHard[node] ~= nil then
			return waitsOnHard[node]
		end
		waitsOnHard[node] = false
		for _, required in ipairs(node.requires or {}) do
			if isHard[required] or WaitsOnHard(required) then
				waitsOnHard[node] = true
				return true
			end
		end
		return false
	end
	local gates = {}
	for _, node in ipairs(easy) do
		if not WaitsOnHard(node) then
			gates[#gates + 1] = node
		end
	end
	if #gates == 0 then
		return route, cost
	end

	local choices, kept = {}, {}
	for _, node in ipairs(route) do
		choices[node] = node.choice
	end
	local snapshot = Solver.Snapshot(route)
	for _, node in ipairs(hard) do
		kept[node] = node.requires or false
		local requires = {}
		for _, required in ipairs(node.requires or {}) do
			requires[#requires + 1] = required
		end
		for _, gate in ipairs(gates) do
			requires[#requires + 1] = gate
		end
		node.requires = requires
	end
	local banded, bandedCost = Solver.Solve(start, route, yield, snapshot)
	for node, requires in pairs(kept) do
		node.requires = requires or nil
	end
	if bandedCost <= cost * EASIEST_SLACK then
		return banded, bandedCost
	end
	for node, choice in pairs(choices) do
		node.choice = choice
	end
	return route, cost
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

local function Point(node)
	return node.candidates and node.candidates[node.choice or 1]
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
	local focus = routes.Settings().routeFocus
	if focus == "fastest" then
		return ns.routesSolver.Solve(start, nodes, yield, previous)
	elseif focus == "xp" then
		return MostXP(start, nodes, yield, previous)
	end
	return Easiest(start, nodes, yield, previous)
end
