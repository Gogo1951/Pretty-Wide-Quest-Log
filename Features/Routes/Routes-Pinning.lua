local _, ns = ...

--[[
	Routes: what the player has started and what goes first. Each objective's progress and the camps worked
	and left (routes.NoteProgress, routes.NoteLeftCamps), whether the player is in an objective's area
	(routes.InArea), and the node the route pins first: the one being worked on, or a timed or escort quest
	(routes.PinEngaged), with the signatures that say when that changes. Then, once the route is solved, a
	done quest's turn-in close by brought forward where it doesn't pull the player out of work they'd come
	back to (routes.BringTurnInsForward)
]]

local routes = ns.routes

local QuestLog = routes.QuestLog
local ForEachObjective = routes.ForEachObjective
local BlobKey = routes.BlobKey

local TURN_IN_REACH = 300 -- Yards from where the player is to a done quest's turn-in that can bring it forward
local TURN_IN_SLACK = 100 -- Yards out of the way a turn-in brought forward may always cost
local WORKING_WINDOW = 180 -- Seconds after an objective's count last went up that the player counts as working on it
local WORKING_REACH = 400 -- Yards past the edge of its blob the player can be and still be working on it

--------------------------------------------------------------------------------
-- Finishing what's started
--------------------------------------------------------------------------------

--[[
	When each objective's count last went up, by node key, and the count then. Being in a camp says the
	player is working on it only while they stand in it; objects to loot or mobs that wander are spread
	wider than that, so progress says it too
]]
routes.progress = {}

-- Notes every objective whose count has gone up since last asked. Called with each check for changes
function routes.NoteProgress()
	if not routes.IsQuestieReady() then
		return
	end
	local now = GetTime()
	for questID, quest in pairs(QuestLog()) do
		if type(quest) == "table" then
			ForEachObjective(quest, function(objectiveKey, objective)
				local collected = type(objective) == "table" and tonumber(objective.Collected)
				if collected then
					local key = questID .. ":" .. objectiveKey
					local seen = routes.progress[key]
					if not seen then
						routes.progress[key] = { collected = collected } -- A first look isn't progress
					elseif collected > seen.collected then
						seen.collected, seen.at = collected, now
					else
						seen.collected = collected
					end
				end
			end)
		end
	end
end

local function IsWorkingOn(node)
	local seen = routes.progress[node.key]
	return seen and seen.at and GetTime() - seen.at <= WORKING_WINDOW
end

--[[
	Whether the player is in an objective's area: within routes.AREA_REACH of any of its spawns, and,
	once in, until routes.AREA_GRACE further. Its spawns, not the blobs the route picks between, so mobs
	spread over a whole zone count wherever the player meets them, with no gaps between blobs. An
	objective of one spawn, a chest or an NPC, is a place, not an area. The route and the Quest Arrow
	both ask this
]]
function routes.InArea(node, x, y, wasIn)
	local spawns = node.spawns
	if not (spawns and spawns.count > 1 and x) then
		return false
	end
	local reach = routes.AREA_REACH + (wasIn and routes.AREA_GRACE or 0)
	local reachSquared = reach * reach
	local xs, ys = spawns.x, spawns.y
	for i = 1, spawns.count do
		local dx, dy = xs[i] - x, ys[i] - y
		if dx * dx + dy * dy <= reachSquared then
			return true
		end
	end
	return false
end

--[[
	The blob of a node the player is in, nearest first, or nothing. In its area (routes.InArea), the
	nearest of its blobs; else, for a place such as a turn-in NPC, inside the blob, until
	routes.AREA_GRACE past its edge. An area's blob is a circle round its spawns' middle, often well past
	the spawns themselves, so for an area only routes.InArea's measure from the spawns counts, as the
	Quest Arrow's does. An objective whose count went up in the last WORKING_WINDOW counts within
	WORKING_REACH: the player is working on it, even walking between its spread-out spawns. Any node
	counts, but a turn-in planned ahead, which waits on its objectives and IsPinnable turns down
]]
local function EngagedBlob(node, x, y, wasEngaged)
	local inArea = routes.InArea(node, x, y, wasEngaged)
	local isArea = node.spawns and node.spawns.count > 1
	local margin = not isArea and (wasEngaged and routes.AREA_GRACE or 0) or nil
	if IsWorkingOn(node) then
		margin = math.max(margin or 0, WORKING_REACH)
	end
	local best, bestDistance
	for _, blob in ipairs(node.blobs or {}) do
		local dx, dy = blob.x - x, blob.y - y
		local distance = math.sqrt(dx * dx + dy * dy)
		local within = inArea or (margin and distance <= blob.radius + margin)
		if within and (not bestDistance or distance < bestDistance) then
			best, bestDistance = blob, distance
		end
	end
	return best
end

--[[
	The camps the last plan pinned that the player has now walked out of, having made progress there, for a
	spread-out objective with other camps: each goes on routes.worked, so this plan doesn't point back
	(Unworked). Out of it is past the reach EngagedBlob gives a camp being worked. A one-place objective
	never goes on it; there's nowhere else to do it
]]
function routes.NoteLeftCamps(x, y)
	local engaged = routes.engaged
	if not (engaged and routes.nodes) then
		return
	end
	local now = GetTime()
	for _, node in ipairs(routes.nodes) do
		local pin = engaged[node.key]
		local objective = node.objective
		if
			type(pin) == "table"
			and pin.blob
			and objective
			and not objective.Completed
			and #(node.blobs or {}) > 1
			and (tonumber(objective.Collected) or 0) > pin.collected
			and not EngagedBlob(node, x, y, true)
		then
			routes.worked[node.key] = routes.worked[node.key] or {}
			routes.worked[node.key][BlobKey(pin.blob)] = now
		end
	end
end

--------------------------------------------------------------------------------
-- What goes first
--------------------------------------------------------------------------------

-- The keys of the tasks at the waypoint the last plan sent the player to: its first with anything left
local function DestinationKeys()
	local keys = {}
	for _, stop in ipairs(routes.stops or {}) do
		local any = false
		for _, task in ipairs(stop.tasks) do
			if task.key and routes.IsTaskLeft(task) then
				keys[task.key] = true
				any = true
			end
		end
		if any then
			break
		end
	end
	return keys
end

--[[
	Where the last plan does each task, by key: the blob it chose (BlobKey), for telling a camp the route
	was coming back to from one it planned elsewhere
]]
local function PlannedPlaces()
	local places = {}
	for _, stop in ipairs(routes.stops or {}) do
		for _, task in ipairs(stop.tasks) do
			local point = task.key and task.candidates and task.candidates[task.choice or 1]
			if point then
				places[task.key] = BlobKey(point)
			end
		end
	end
	return places
end

--[[
	Whether a node the player is in may be pinned first. An objective spread over an area is pinned when
	the player was sent there (the last plan's waypoint), is already pinned there, is working it (its
	count went up lately), or has walked into the very camp the route planned it at further on: the route
	was coming back here, so it's done now, not after a trip elsewhere and back. Riding through a camp of
	an objective planned elsewhere doesn't take over the route; the Quest Arrow lists it under While
	You're Here instead. A rider is pinned only where it was sent, as what drops on the way isn't working
	it. One place (an NPC, a chest), a timed or escort quest's node, and the first plan in a zone pin
	whenever the player is in them
]]
local function IsPinnable(node, wasPinned, destination, planned, blob)
	-- A turn-in planned ahead waits on its objectives, so standing at its NPC can't put it first
	if node.kind == "turnIn" and not node.ready then
		return false
	end
	--[[
		Nor can anything of a quest not taken yet (Routes-Chains.lua): its objectives wait on its pick-up, and
		a follow-up's pick-up on the turn-in that unlocks it
	]]
	if node.predicted then
		return false
	end
	if node.urgent or not (node.spawns and node.spawns.count > 1) or routes.start == nil then
		return true
	end
	if wasPinned or destination[node.key] then
		return true
	end
	if node.rider then
		return false
	end
	return IsWorkingOn(node) or (blob ~= nil and planned[node.key] == BlobKey(blob))
end

-- Every node not in the set waits on every node in it
local function WaitOn(nodes, set, members)
	if #members == 0 then
		return
	end
	for _, node in ipairs(nodes) do
		if not set[node] then
			local requires = {}
			for _, required in ipairs(node.requires or {}) do
				requires[#requires + 1] = required
			end
			for _, required in ipairs(members) do
				requires[#requires + 1] = required
			end
			node.requires = requires
		end
	end
end

-- Whether any node is a timed or escort quest's (node.urgent)
local function IsHurrying(nodes)
	for _, node in ipairs(nodes) do
		if node.urgent then
			return true
		end
	end
	return false
end

-- Timed and escort quests, each { questID, distance, nodes }, the one turned in nearest first
local function UrgentQuests(nodes)
	local quests, byQuest = {}, {}
	for _, node in ipairs(nodes) do
		if node.urgent then
			local quest = byQuest[node.questID]
			if not quest then
				quest = { questID = node.questID, distance = node.turnInDistance or math.huge, nodes = {} }
				byQuest[node.questID] = quest
				quests[#quests + 1] = quest
			end
			quest.nodes[#quest.nodes + 1] = node
		end
	end
	table.sort(quests, function(a, b)
		if a.distance ~= b.distance then
			return a.distance < b.distance
		end
		return a.questID < b.questID
	end)
	return quests
end

--[[
	What goes first on the route, ahead of the rest, which waits on it. First of all:

	Every timed or escort quest (node.urgent), its objectives then its turn-in, or once done, its turn-in.
	A timer won't wait while the route sends the player around the zone, nor will an escorted NPC, so
	nothing else is planned until they're all done. With more than one, the quest whose turn-in is nearest goes first,
	then the next nearest, each waiting on the one before; one turned in outside the zone goes last. Of
	these, only their own nodes are pinned to the blob the player is in. A failed one is Questie's -1 and
	isn't on the route at all.

	Otherwise every objective or turn-in whose blob the player is in and may be pinned (IsPinnable: sent
	there, or working it), at that blob, so the route finishes the camp the player is working before it
	sends them anywhere else, even where the shortest trip would come back to it later or a denser camp
	elsewhere has the same mobs. Each such node gets that blob as its only candidate.

	A done quest's turn-in close by isn't pinned here: whether it goes ahead depends on where the rest of
	the route goes, so routes.BringTurnInsForward decides once it's solved.

	Returns the nodes pinned to the blob the player is in, by key, each { blob, collected }: the blob and
	the objective's count when first pinned. They become routes.engaged when the plan is drawn, for the
	next plan, for noticing the player walking into or out of one, and for routes.NoteLeftCamps
]]
function routes.PinEngaged(nodes, start)
	local engaged, first, isFirst = {}, {}, {}
	local previous = routes.engaged or {}
	local destination, planned = DestinationKeys(), PlannedPlaces()
	local hurrying = IsHurrying(nodes)
	for _, node in ipairs(nodes) do
		-- During a timed or escort quest only its own nodes are pinned to the blob the player is in
		local wasPinned = previous[node.key]
		local blob = (node.urgent or not hurrying) and EngagedBlob(node, start.x, start.y, wasPinned)
		if blob and not IsPinnable(node, wasPinned, destination, planned, blob) then
			blob = nil
		end
		node.inArea = nil
		if blob then
			blob.penalty = 0
			node.candidates = { blob }
			-- The count when first pinned, kept while it stays pinned, so leaving after progress is noticed
			local collected = node.objective and tonumber(node.objective.Collected) or 0
			engaged[node.key] = {
				blob = blob,
				collected = type(wasPinned) == "table" and wasPinned.collected or collected,
			}
			-- Standing in its area, not just working on it from further off: areas overlapping here are one stop
			node.inArea = routes.InArea(node, start.x, start.y, previous[node.key]) or nil
		end
		if blob and not hurrying then
			first[#first + 1] = node
			isFirst[node] = true
		end
	end

	-- Each timed or escort quest ahead of the ones turned in further off, and all of them ahead of the rest
	local before = {}
	if hurrying then
		for _, quest in ipairs(UrgentQuests(nodes)) do
			for _, node in ipairs(quest.nodes) do
				before[node] = true
			end
			WaitOn(nodes, before, quest.nodes)
		end
		return engaged
	end

	-- Everything else after what's first
	for node in pairs(isFirst) do
		before[node] = true
	end
	WaitOn(nodes, before, first)
	return engaged
end

--------------------------------------------------------------------------------
-- Turning in on the way
--------------------------------------------------------------------------------

local function Yards(a, b)
	local dx, dy = a.x - b.x, a.y - b.y
	return math.sqrt(dx * dx + dy * dy)
end

local function Point(node)
	return node.candidates[node.choice or 1]
end

local function IndexOf(list, value)
	for index, item in ipairs(list) do
		if item == value then
			return index
		end
	end
end

-- The candidate of a node nearest a point, and the yards to it
local function NearestCandidate(node, from)
	local best, bestYards
	for index, candidate in ipairs(node.candidates) do
		local yards = Yards(from, candidate)
		if not bestYards or yards < bestYards then
			best, bestYards = index, yards
		end
	end
	return best, bestYards
end

--[[
	A done quest's turn-in, moved up the solved route to the first place it's worth handing in on the way:
	a turn-in usually opens the next quest in its chain, which the shortest trip, saving it for last,
	doesn't weigh. Moved in place, in order, each ready turn-in in turn, nowhere before what it waits on (a
	camp pinned first, a timed or escort quest).

	Worth it where the player will be within TURN_IN_REACH of it, and the walk there and on to where the
	route goes next costs no more out of the way than that next leg itself, or TURN_IN_SLACK, whichever is
	more. So between camps, with the next one far off, a turn-in close by goes first; but in the middle of
	a camp, with more to do a few steps on, it waits until the camp is done, rather than sending the player
	out to the NPC and back. Further off, it stays where the route has it, last with the quests handed in
	at the same place
]]
function routes.BringTurnInsForward(order, start)
	if IsHurrying(order) then
		return
	end
	local turnIns = {}
	for _, node in ipairs(order) do
		if node.kind == "turnIn" and node.ready then
			turnIns[#turnIns + 1] = node
		end
	end
	for _, turnIn in ipairs(turnIns) do
		local from = IndexOf(order, turnIn)
		table.remove(order, from)
		local first = 1
		for _, required in ipairs(turnIn.requires or {}) do
			local position = IndexOf(order, required)
			if position and position + 1 > first then
				first = position + 1
			end
		end
		local slot
		for at = first, from - 1 do
			local previous = at == 1 and start or Point(order[at - 1])
			local choice, yards = NearestCandidate(turnIn, previous)
			if yards <= TURN_IN_REACH then
				local nextPoint = Point(order[at])
				local leg = Yards(previous, nextPoint)
				local detour = yards + Yards(turnIn.candidates[choice], nextPoint) - leg
				if detour <= math.max(TURN_IN_SLACK, leg) then
					turnIn.choice, slot = choice, at
					break
				end
			end
		end
		table.insert(order, slot or from, turnIn)
	end
end

--[[
	The keys of the last plan's nodes the player is in now, as text, to compare with what the plan
	pinned. Different means the player has walked into a camp or left one, and the route should know
]]
function routes.EngagedSignature(nodes)
	local x, y = routes.Origin()
	local keys = {}
	if x and nodes then
		local hurrying = IsHurrying(nodes)
		local destination, planned = DestinationKeys(), PlannedPlaces()
		for _, node in ipairs(nodes) do
			-- During a timed or escort quest, walking through a camp of another quest's doesn't change the route
			local counts = node.urgent or not hurrying
			local wasPinned = routes.engaged and routes.engaged[node.key]
			local blob = counts and EngagedBlob(node, x, y, wasPinned)
			if blob and IsPinnable(node, wasPinned, destination, planned, blob) then
				keys[#keys + 1] = node.key
			end
		end
	end
	table.sort(keys)
	return table.concat(keys, ",")
end

-- The same, for what the plan pinned
function routes.PinnedSignature()
	local keys = {}
	for key in pairs(routes.engaged or {}) do
		keys[#keys + 1] = key
	end
	table.sort(keys)
	return table.concat(keys, ",")
end
