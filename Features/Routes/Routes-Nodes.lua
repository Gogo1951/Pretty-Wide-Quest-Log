local _, ns = ...

--[[
	Routes: the route's nodes, from Questie's quest log and database. Every objective not yet done becomes
	a node whose candidates are its blobs (Routes-Blobs.lua), and every done quest's turn-in a node too (a
	quest not yet done isn't routed to its turn-in). A dungeon or raid quest's objectives are left out, as
	they're inside the instance, but its turn-in is a node like any other's, where the NPC or object is out
	in the world: one inside the instance is left out too. Routes-Solver.lua orders them; Routes-Stops.lua
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
	rather than pointing back. routes.ResetObjectives clears it
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
	how far its turn-in is. requires are the nodes one must wait on: a turn-in planned ahead its quest's
	objectives, and routes.PinEngaged adds the rest
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
				ignored), in which case the route can't finish the quest and plans no turn-in ahead for it
			]]
			local objectiveNodes, unplanned = {}, false
			if state == 0 and not instanceQuest then
				ForEachObjective(quest, function(objectiveKey, objective)
					if type(objective) == "table" and not objective.Completed then
						local key = questID .. ":" .. objectiveKey
						local blobs = HasSpawns(objective)
							and not skipped[key]
							and ObjectiveBlobs(objective, start, yield)
						if not (blobs and #blobs > 0) then
							unplanned = true
						else
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
							}
						end
					end
				end)
			end

			for _, node in ipairs(objectiveNodes) do
				nodes[#nodes + 1] = node
			end

			--[[
				The turn-in: once the quest is done, ready now; before then, planned ahead, waiting on every
				one of its objectives' nodes (requires), so the route and the Quest Arrow's Next Objective show
				it where it falls once they're done. None ahead with Show Upcoming Turn-Ins (showUpcomingTurnIns)
		off, nor for a quest with an objective the route can't
				do, nor a dungeon or raid quest's until it's done. A dungeon or raid quest's only where it's out
				in the world, not at the end of the instance
			]]
			local key = questID .. ":turnIn"
			local ready = state == 1
			local ahead = state == 0
				and routes.Settings().showUpcomingTurnIns
				and not instanceQuest
				and not unplanned
				and #objectiveNodes > 0
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
						requires = not ready and objectiveNodes or nil,
						urgent = urgent,
						turnInDistance = turnInDistance,
					}
				end
			end
		end
		yield()
	end

	-- The party's quests the player doesn't have, their objectives planned as the player's own; none of a dungeon's
	for questID, quest in pairs(routes.PartyQuests(QuestLog(), yield)) do
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
							candidates = Candidates(Unworked(key, blobs), start, true),
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
	routes.LinkOverlaps(nodes, yield)
	return nodes, start, routes.PinEngaged(nodes, start)
end
