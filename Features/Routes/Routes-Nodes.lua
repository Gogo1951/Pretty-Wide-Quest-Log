local _, ns = ...

--[[
	Routes: the route's nodes, from Questie's quest log and database. Every objective not yet done becomes
	a node whose candidates are its blobs (Routes-Blobs.lua), and every done quest's turn-in a node too (a
	quest not yet done has its turn-in planned ahead, shown only with Predictive Questing Routes on). A
	dungeon or raid quest's objectives are left out, as they're inside the instance, but its turn-in is a
	node like any other's, where the NPC or object is out in the world: one inside the instance is left out
	too. Routes-Solver.lua orders them; Routes-Stops.lua
	makes the stops.

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

local WORKED_MEMORY = 600 -- Seconds a spread-out objective's camp, worked and left, stays off the route for it

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

local function GatherObjectiveBlobs(objective, start, yield)
	local points = NewPoints()
	for _, spawnData in pairs(objective.spawnList) do
		if type(spawnData) == "table" then
			AddSpawns(points, spawnData.Spawns, routes.SpawnName(objective, spawnData), start, yield)
		end
	end
	local blobs = Cluster(points, yield)
	-- The spawns themselves too, kept with the blobs, for telling whether the player is among them
	blobs.spawns = { x = points.x, y = points.y, count = points.count }
	return blobs
end

local function ObjectiveBlobs(objective, start, yield)
	return CachedBlobs(objective, routes.CountEntries(objective.spawnList), start, yield, GatherObjectiveBlobs)
end

-- Calls add(spawns, name) for every NPC and object that takes the quest, as Questie's database has them
local function ForEachFinisher(quest, add)
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local finisher = type(quest.Finisher) == "table" and quest.Finisher
	if not (QuestieDB and finisher) then
		return
	end
	for kind, query in pairs({ NPC = QuestieDB.QueryNPCSingle, GameObject = QuestieDB.QueryObjectSingle }) do
		if type(query) == "function" and type(finisher[kind]) == "table" then
			for _, id in ipairs(finisher[kind]) do
				local okSpawns, spawns = pcall(query, id, "spawns")
				local okName, name = pcall(query, id, "name")
				if okSpawns then
					add(spawns, okName and name or nil)
				end
			end
		end
	end
end
routes.ForEachFinisher = ForEachFinisher

--[[
	Where the quest is turned in: every spawn of every NPC and object that takes it. With outdoors, only
	those out in the world, for a dungeon or raid quest whose turn-in can be at the end of the instance
]]
local function GatherTurnInBlobs(quest, start, yield, outdoors)
	local points = NewPoints()
	ForEachFinisher(quest, function(spawns, name)
		AddSpawns(points, spawns, name, start, yield, outdoors)
	end)
	return Cluster(points, yield)
end

local function GatherOutdoorTurnInBlobs(quest, start, yield)
	return GatherTurnInBlobs(quest, start, yield, true)
end

-- Its own version outdoors, so a quest whose dungeon tag loads late doesn't keep the blobs from before
local function TurnInBlobs(quest, start, yield, outdoors)
	if outdoors then
		return CachedBlobs(quest, 2, start, yield, GatherOutdoorTurnInBlobs)
	end
	return CachedBlobs(quest, 1, start, yield, GatherTurnInBlobs)
end

local function ByKey(a, b)
	return a.key < b.key
end

--[[
	Camps of a spread-out objective the player worked (its count went up there) and then walked out of, by
	node key, each blob's place (BlobKey) to when they left. Leaving one says "more along the route will do":
	for WORKED_MEMORY the route plans that objective at another of its camps, or picks it up on the way,
	rather than pointing back. routes.ResetZone clears it
]]
routes.worked = {}

local function BlobKey(blob)
	return math.floor(blob.x) .. ":" .. math.floor(blob.y)
end
routes.BlobKey = BlobKey -- The camps left lately, by place (Routes-Pinning.lua)

-- An objective's blobs without the camps it was worked in and left lately; all of them if that leaves none
local function Unworked(key, blobs)
	local worked = routes.worked[key]
	if not worked then
		return blobs
	end
	local now, kept = GetTime(), {}
	for _, blob in ipairs(blobs) do
		local leftAt = worked[BlobKey(blob)]
		if not (leftAt and now - leftAt <= WORKED_MEMORY) then
			kept[#kept + 1] = blob
		end
	end
	return #kept > 0 and kept or blobs
end
routes.Unworked = Unworked -- For the camps Routes-Overlaps.lua shares

-- Yards from the start to the nearest of a quest's turn-in places in the zone, or math.huge for none here
local function TurnInDistance(quest, start, yield, outdoors)
	local nearest = math.huge
	for _, blob in ipairs(TurnInBlobs(quest, start, yield, outdoors)) do
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
	how far its turn-in is. In a party, an objective the player has done that a member still needs
	(routes.PartyNeeds) is a node too, helping, and holds back the turn-in as one not done would. requires
	are the nodes one must wait on: a turn-in planned ahead its quest's objectives, and routes.PinEngaged
	adds the rest
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
	routes.NoteLeftCamps(x, y)
	local skipped = routes.skipped
	local timed = routes.TimedQuests()

	local nodes = {}
	local log = QuestLog()
	for _, questID in ipairs(routes.LoggedQuestIDs(log)) do
		local quest = log[questID]
		if type(quest) == "table" then
			-- A dungeon or raid quest's objectives are inside the instance, so only its turn-in is on the route
			local instanceQuest = IsInstanceQuest(questID)
			local state = QuestState(quest)
			local questName = quest.name or tostring(questID)
			-- Timed and escort quests go ahead of the rest, the one turned in nearest first
			local urgent = state ~= -1 and (timed[questID] or IsEscort(questID)) or nil
			local turnInDistance = urgent and TurnInDistance(quest, start, yield, instanceQuest) or nil
			--[[
				Its objectives' nodes, and whether any objective left has none (no spawns to go to, or
				ignored), in which case the route can't finish the quest and plans no turn-in ahead for it.
				One the player has done that the party still needs is helping; one the route can't plan is
				simply left off, and the player turns in
			]]
			local objectiveNodes, unplanned, helping = {}, false, false
			local needs = state ~= -1 and not instanceQuest and routes.PartyNeeds(questID) or nil
			if (state == 0 or needs) and not instanceQuest then
				ForEachObjective(quest, function(objectiveKey, objective)
					if type(objective) ~= "table" then
						return
					end
					local helps = objective.Completed
						and needs
						and objective.Index
						and needs[objective.Index]
						and quest.Objectives[objective.Index] == objective
					if not objective.Completed or helps then
						local key = questID .. ":" .. objectiveKey
						local blobs = HasSpawns(objective)
							and not skipped[key]
							and ObjectiveBlobs(objective, start, yield)
						if not (blobs and #blobs > 0) then
							unplanned = unplanned or not helps
						else
							helping = helping or helps == true
							objectiveNodes[#objectiveNodes + 1] = {
								key = key,
								kind = "objective",
								questID = questID,
								questName = questName,
								quest = quest,
								objective = objective,
								candidates = Candidates(Unworked(key, blobs), start, true),
								blobs = blobs,
								spawns = blobs.spawns,
								urgent = urgent,
								turnInDistance = turnInDistance,
								helping = helps == true or nil, -- Done by the player, still needed by the party
							}
						end
					end
				end)
			end

			for _, node in ipairs(objectiveNodes) do
				nodes[#nodes + 1] = node
			end

			--[[
				The turn-in: once the quest is done and the party needs none of it, ready now; before then
				(or while helping), planned ahead, waiting on every one of its objectives' nodes (requires),
				so the route and the Quest Arrow's Next Objective show it where it falls once they're done.
				With Predictive Questing Routes (predictiveRoutes) off it's still planned, hidden: the player
				walks back to hand the quest in either way, and a route planned as if they didn't would end
				out in the fields, sending them to town first for a turn-in that's ready and then back out
				again. The planner drops hidden ones from what's drawn (Routes-Planner.lua). None ahead for a
				quest with an objective the route can't do, nor a dungeon or raid quest's until it's done. A
				dungeon or raid quest's only where it's out in the world, not at the end of the instance
			]]
			local key = questID .. ":turnIn"
			local ready = state == 1 and not helping
			local ahead = (state == 0 or helping) and not instanceQuest and not unplanned and #objectiveNodes > 0
			if (ready or ahead) and not skipped[key] and routes.IsOnQuest(questID) then
				local blobs = TurnInBlobs(quest, start, yield, instanceQuest)
				if #blobs > 0 then
					nodes[#nodes + 1] = {
						key = key,
						kind = "turnIn",
						questID = questID,
						questName = questName,
						quest = quest,
						candidates = Candidates(blobs, start, false),
						blobs = blobs,
						ready = ready, -- Done: it can be turned in now
						hidden = not ready and not routes.Settings().predictiveRoutes or nil, -- Planned, not drawn
						requires = not ready and objectiveNodes or nil,
						urgent = urgent,
						turnInDistance = turnInDistance,
					}
				end
			end
		end
		yield()
	end

	--[[
		The party's quests the player doesn't have, their objectives planned as the player's own, and their
		turn-ins (questID:pt), from Questie's database: ready once nobody needs any of it, else planned ahead
		of the objectives and hidden with Predictive Questing Routes off, as the player's own are. The route
		then heads back to town with the party rather than ending out where their last objective is, and the
		party's follow-ups grow from these (Routes-Chains.lua). None of a dungeon's, and no turn-in ahead
		while an objective the party still needs has nowhere to go
	]]
	local predictive = routes.Settings().predictiveRoutes
	for questID, quest in pairs(routes.PartyQuests(QuestLog(), yield)) do
		if not IsInstanceQuest(questID) then
			local questName = quest.name or tostring(questID)
			local objectiveNodes, unplanned = {}, false
			for index, objective in pairs(quest.Objectives) do
				local key = questID .. ":p" .. tostring(index)
				if not objective.Completed then
					local blobs = HasSpawns(objective) and not skipped[key] and ObjectiveBlobs(objective, start, yield)
					if blobs and #blobs > 0 then
						local node = {
							key = key,
							kind = "objective",
							questID = questID,
							questName = questName,
							quest = quest,
							objective = objective,
							candidates = Candidates(Unworked(key, blobs), start, true),
							blobs = blobs,
							spawns = blobs.spawns,
							party = true,
						}
						nodes[#nodes + 1] = node
						objectiveNodes[#objectiveNodes + 1] = node
					else
						unplanned = true
					end
				end
			end
			local key = questID .. ":pt"
			local ready = #objectiveNodes == 0
			if not unplanned and not skipped[key] then
				local blobs = routes.QuestTurnInBlobs(questID, start, yield)
				if blobs and #blobs > 0 then
					nodes[#nodes + 1] = {
						key = key,
						kind = "turnIn",
						questID = questID,
						questName = questName,
						quest = quest,
						candidates = Candidates(blobs, start, false),
						blobs = blobs,
						ready = ready,
						hidden = not ready and not predictive or nil,
						requires = not ready and objectiveNodes or nil,
						party = true,
					}
				end
			end
		end
		yield()
	end

	-- Quests to pick up, nearby with Local Available Quests on, across the zone with Predictive Questing Routes (Routes-Pick-Ups.lua)
	local chainStarts = routes.AddLocalQuestNodes(nodes, start, log, yield)

	-- Quests the zone can finish, planned whole with their follow-ups, with Predictive Questing Routes on (Routes-Chains.lua)
	routes.AddChainNodes(nodes, start, log, chainStarts, yield)

	--[[
		A quest the party has that the player is to pick up: its party objectives wait on the pick-up, so the
		two do them together once both have it, rather than the player helping before they'd get the credit
	]]
	local pickUpOf = {}
	for _, node in ipairs(nodes) do
		if node.kind == "pickUp" and not node.party then
			pickUpOf[node.questID] = node
		end
	end
	for _, node in ipairs(nodes) do
		local pickUp = node.party and node.kind == "objective" and pickUpOf[node.questID]
		if pickUp then
			local requires = { pickUp }
			for _, required in ipairs(node.requires or {}) do
				requires[#requires + 1] = required
			end
			node.requires = requires
		end
	end

	-- Flight paths not yet discovered, with Discover Flight Paths on (Routes-Flights.lua)
	routes.AddFlightPathNodes(nodes, start, yield)

	-- Questie's log is a hash, so its order changes; the same quests always make the same route
	table.sort(nodes, ByKey)
	routes.LinkOverlaps(nodes, yield)
	return nodes, start, routes.PinEngaged(nodes, start)
end
