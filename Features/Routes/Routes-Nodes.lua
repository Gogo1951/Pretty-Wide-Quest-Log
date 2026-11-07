local _, ns = ...

--[[
	Routes: the route's nodes, from Questie's quest log and database. Every objective not yet done becomes
	a node whose candidates are its blobs (Routes-Blobs.lua), and every done quest's turn-in a node too (a
	quest not yet done isn't routed to its turn-in). Dungeon and raid quests are left out, objectives and
	turn-in both. Routes-Solver.lua orders them; Routes-Stops.lua makes the stops.

	Only the zone the player is in counts, with the caves and cities inside it (routes.IsInZone): an
	objective's spawns or a turn-in elsewhere are left out, whichever zone the quest is filed under, so a
	quest from another zone with mobs in this one is on the route, and a quest of this zone's whose mobs
	are all elsewhere isn't
]]

local routes = ns.routes

local IsInstanceQuest = routes.IsInstanceQuest
local QuestLog = routes.QuestLog
local QuestState = routes.QuestState
local IsEscort = routes.IsEscort
local ForEachObjective = routes.ForEachObjective
local HasSpawns = routes.HasSpawns
local NewPoints = routes.NewPoints
local AddSpawns = routes.AddSpawns
local Cluster = routes.Cluster
local Candidates = routes.Candidates

local TURN_IN_REACH = 400 -- Yards to a done quest's turn-in that put it ahead of more questing
local WORKING_WINDOW = 180 -- Seconds after an objective's count last went up that the player counts as working on it
local WORKING_REACH = 400 -- Yards past the edge of its blob the player can be and still be working on it

--------------------------------------------------------------------------------
-- Nodes
--------------------------------------------------------------------------------

--[[
	Blobs already worked out, by objective (for its spawns) and by quest (for its turn-in), for the zone
	they were worked out in. Spawns don't move, so a later plan reuses them rather than gathering every
	spawn into blobs again. An objective's are worked out again only once Questie has changed its spawn
	list (how many entries it has). Weak keys, so a quest left behind lets go of its blobs
]]
local blobCache = setmetatable({}, { __mode = "k" })

local function CachedBlobs(owner, version, start, yield, Make)
	local cached = blobCache[owner]
	if cached and cached.zone == start.zone and cached.instance == start.instance and cached.version == version then
		return cached.blobs
	end
	local blobs = Make(owner, start, yield)
	blobCache[owner] = { zone = start.zone, instance = start.instance, version = version, blobs = blobs }
	return blobs
end

local function CountEntries(list)
	local count = 0
	for _ in pairs(list) do
		count = count + 1
	end
	return count
end

local function GatherObjectiveBlobs(objective, start, yield)
	local points = NewPoints()
	-- An event's spawns are a place, such as where an escort ends, and its name only the objective's text again
	local isEvent = objective.Type == "event"
	for _, spawnData in pairs(objective.spawnList) do
		if type(spawnData) == "table" then
			local event = isEvent or (Questie and spawnData.Icon ~= nil and spawnData.Icon == Questie.ICON_TYPE_EVENT)
			AddSpawns(points, spawnData.Spawns, not event and spawnData.Name or nil, start, yield)
		end
	end
	local blobs = Cluster(points, yield)
	-- The spawns themselves too, kept with the blobs, for telling whether the player is among them
	blobs.spawns = { x = points.x, y = points.y, count = points.count }
	return blobs
end

local function ObjectiveBlobs(objective, start, yield)
	return CachedBlobs(objective, CountEntries(objective.spawnList), start, yield, GatherObjectiveBlobs)
end

-- Where the quest is turned in: every spawn of every NPC and object that takes it
local function GatherTurnInBlobs(quest, start, yield)
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local finisher = type(quest.Finisher) == "table" and quest.Finisher
	if not (QuestieDB and finisher) then
		return {}
	end
	local points = NewPoints()
	for kind, query in pairs({ NPC = QuestieDB.QueryNPCSingle, GameObject = QuestieDB.QueryObjectSingle }) do
		if type(query) == "function" and type(finisher[kind]) == "table" then
			for _, id in ipairs(finisher[kind]) do
				local okSpawns, spawns = pcall(query, id, "spawns")
				local okName, name = pcall(query, id, "name")
				if okSpawns then
					AddSpawns(points, spawns, okName and name or nil, start, yield)
				end
			end
		end
	end
	return Cluster(points, yield)
end

local function TurnInBlobs(quest, start, yield)
	return CachedBlobs(quest, 1, start, yield, GatherTurnInBlobs)
end

local function ByKey(a, b)
	return a.key < b.key
end

-- Yards from the start to the nearest of a quest's turn-in places in the zone, or math.huge for none here
local function TurnInDistance(quest, start, yield)
	local nearest = math.huge
	for _, blob in ipairs(TurnInBlobs(quest, start, yield)) do
		local dx, dy = blob.x - start.x, blob.y - start.y
		nearest = math.min(nearest, math.sqrt(dx * dx + dy * dy))
	end
	return nearest
end

--[[
	Every node for the route, and the player's position it starts from ({ x, y, instance, zone }). Nil while
	Questie isn't ready or the client won't give the player's position. Each node is
	{ key, kind, questID, questName, quest, objective, candidates, blobs }: kind is "objective" or
	"turnIn", quest and objective Questie's live tables (for the level and progress), and blobs every
	place in the zone it can be done. A timed or escort quest's nodes are urgent too, with turnInDistance,
	how far its turn-in is. routes.PinEngaged adds requires, the nodes one must wait on
]]
function routes.BuildNodes(yield)
	if not routes.IsQuestieReady() then
		return nil
	end
	local x, y, instance, zone, corpse = routes.Origin()
	if not (x and instance and zone) then
		return nil
	end
	local start = { x = x, y = y, instance = instance, zone = zone, corpse = corpse }
	local skipped = routes.skipped
	local timed = routes.TimedQuests()

	local nodes = {}
	for questID, quest in pairs(QuestLog()) do
		-- A dungeon or raid quest isn't on the route at all, only on the map (routes.IsInstanceQuest)
		if type(quest) == "table" and not IsInstanceQuest(questID) then
			local state = QuestState(quest)
			local questName = quest.name or tostring(questID)
			-- Timed and escort quests go ahead of the rest, the one turned in nearest first
			local urgent = state ~= -1 and (timed[questID] or IsEscort(questID)) or nil
			local turnInDistance = urgent and TurnInDistance(quest, start, yield) or nil
			if state == 0 then
				ForEachObjective(quest, function(objectiveKey, objective)
					if type(objective) == "table" and not objective.Completed then
						local key = questID .. ":" .. objectiveKey
						local blobs = HasSpawns(objective)
							and not skipped[key]
							and ObjectiveBlobs(objective, start, yield)
						if blobs and #blobs > 0 then
							nodes[#nodes + 1] = {
								key = key,
								kind = "objective",
								questID = questID,
								questName = questName,
								quest = quest,
								objective = objective,
								candidates = Candidates(blobs, start, true),
								blobs = blobs,
								spawns = blobs.spawns,
								urgent = urgent,
								turnInDistance = turnInDistance,
							}
						end
					end
				end)
			end

			-- The turn-in, only once the quest is done: until then the route is its objectives
			local key = questID .. ":turnIn"
			if state == 1 and not skipped[key] then
				local blobs = TurnInBlobs(quest, start, yield)
				if #blobs > 0 then
					nodes[#nodes + 1] = {
						key = key,
						kind = "turnIn",
						questID = questID,
						questName = questName,
						quest = quest,
						candidates = Candidates(blobs, start, false),
						blobs = blobs,
						ready = true, -- Done: it can be turned in now
						urgent = urgent,
						turnInDistance = turnInDistance,
					}
				end
			end
		end
		yield()
	end

	-- The party's quests the player doesn't have, their objectives planned as the player's own
	for questID, quest in pairs(routes.PartyQuests(QuestLog())) do
		if not IsInstanceQuest(questID) then
			for index, objective in pairs(quest.Objectives) do
				local key = questID .. ":p" .. tostring(index)
				if not objective.Completed and HasSpawns(objective) and not skipped[key] then
					local blobs = ObjectiveBlobs(objective, start, yield)
					if #blobs > 0 then
						nodes[#nodes + 1] = {
							key = key,
							kind = "objective",
							questID = questID,
							questName = quest.name or tostring(questID),
							quest = quest,
							objective = objective,
							candidates = Candidates(blobs, start, true),
							blobs = blobs,
							spawns = blobs.spawns,
							party = true,
						}
					end
				end
			end
		end
		yield()
	end

	-- Questie's log is a hash, so its order changes; the same quests always make the same route
	table.sort(nodes, ByKey)
	return nodes, start, routes.PinEngaged(nodes, start)
end

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
	routes.AREA_GRACE past its edge. An objective whose count went up in the last WORKING_WINDOW counts
	within WORKING_REACH: the player is working on it, even walking between its spread-out spawns. Any
	node counts, as none waits on another until routes.PinEngaged: a quest's turn-in is a node only once
	its objectives are done
]]
local function EngagedBlob(node, x, y, wasEngaged)
	local inArea = routes.InArea(node, x, y, wasEngaged)
	local margin = wasEngaged and routes.AREA_GRACE or 0
	if IsWorkingOn(node) then
		margin = math.max(margin, WORKING_REACH)
	end
	local best, bestDistance
	for _, blob in ipairs(node.blobs or {}) do
		local dx, dy = blob.x - x, blob.y - y
		local distance = math.sqrt(dx * dx + dy * dy)
		if (inArea or distance <= blob.radius + margin) and (not bestDistance or distance < bestDistance) then
			best, bestDistance = blob, distance
		end
	end
	return best
end

-- The candidate of a node nearest a point, within reach, or nothing
local function NearestWithin(node, x, y, reach)
	local best, bestDistance
	for _, blob in ipairs(node.blobs or {}) do
		local dx, dy = blob.x - x, blob.y - y
		local distance = math.sqrt(dx * dx + dy * dy)
		if distance <= reach and (not bestDistance or distance < bestDistance) then
			best, bestDistance = blob, distance
		end
	end
	return best
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

--[[
	What goes first on the route, ahead of the rest, which waits on it. First of all:

	Every timed or escort quest (node.urgent), its objectives or, once done, its turn-in. A timer won't
	wait while the route sends the player around the zone, nor will an escorted NPC, so nothing else is
	planned until they're all done. With more than one, the quest whose turn-in is nearest goes first,
	then the next nearest, each waiting on the one before; one turned in outside the zone goes last. Of
	these, only their own nodes are pinned to the blob the player is in. A failed one is Questie's -1 and
	isn't on the route at all.

	Otherwise every objective or turn-in whose blob the player is in, at that blob, so the route
	finishes the camp the player is working before it sends them anywhere else, even where the
	shortest trip would come back to it later or a denser camp elsewhere has the same mobs. Each such
	node gets that blob as its only candidate.

	Then, but for a timed or escort quest, every done quest turned in within TURN_IN_REACH, at the place nearest. The
	shortest trip would often save it for last, but a turn-in usually opens the next quest in its chain,
	and that's worth a short walk now. One across the zone still waits until the route passes it.

	Returns the keys of the nodes pinned to the blob the player is in, which become routes.engaged when the
	plan is drawn, for the next plan and for noticing the player walking into or out of one
]]
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

function routes.PinEngaged(nodes, start)
	local engaged, first, isFirst = {}, {}, {}
	local previous = routes.engaged or {}
	local hurrying = IsHurrying(nodes)
	for _, node in ipairs(nodes) do
		-- During a timed or escort quest only its own nodes are pinned to the blob the player is in
		local blob = (node.urgent or not hurrying) and EngagedBlob(node, start.x, start.y, previous[node.key])
		node.inArea = nil
		if blob then
			blob.penalty = 0
			node.candidates = { blob }
			engaged[node.key] = true
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

	local turnIns, isTurnIn = {}, {}
	for _, node in ipairs(nodes) do
		local blob = node.ready and not isFirst[node] and NearestWithin(node, start.x, start.y, TURN_IN_REACH)
		if blob then
			blob.penalty = 0
			node.candidates = { blob }
			turnIns[#turnIns + 1] = node
			isTurnIn[node] = true
		end
	end

	-- The nearby turn-ins after what's first, everything else after both
	for node in pairs(isFirst) do
		before[node] = true
	end
	WaitOn(nodes, before, first)
	for node in pairs(isTurnIn) do
		before[node] = true
	end
	WaitOn(nodes, before, turnIns)
	return engaged
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
		for _, node in ipairs(nodes) do
			-- During a timed or escort quest, walking through a camp of another quest's doesn't change the route
			local counts = node.urgent or not hurrying
			if counts and EngagedBlob(node, x, y, routes.engaged and routes.engaged[node.key]) then
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
