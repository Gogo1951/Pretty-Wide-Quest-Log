local _, ns = ...

--[[
	Routes: the camps, every place each objective can be done, in every zone, which the world map shows as
	markers on every map, zone or continent, in place of Questie's icon on every spawn (Routes-Map.lua).
	The route is only the zone the player is in; the camps are everywhere, so a quest's mobs in the next
	zone over, or anywhere while the player is a ghost, are one marker a camp rather than Questie's
	scatter of icons.

	A camp is a blob (Routes-Blobs.lua) of an objective's spawns, gathered across the whole continent, and
	every done quest's turn-in is a camp too, where its NPC or object stands. Each is shaped as a stop is
	(Routes-Stops.lua), with the one task, so the map draws and lists it as it does a waypoint. Worked out
	with each plan (Routes-Core.lua), from blobs cached by objective until Questie changes its spawn list
]]

local routes = ns.routes

local QuestLog = routes.QuestLog
local QuestState = routes.QuestState
local IsInstanceQuest = routes.IsInstanceQuest
local ForEachObjective = routes.ForEachObjective
local HasSpawns = routes.HasSpawns
local Cluster = routes.Cluster
local IsArea = routes.IsArea

--[[
	Blobs by continent (world instance), by objective (for its spawns) or by quest (for its turn-in), with
	the version they were worked out for. Weak keys, so a quest left behind lets go of its camps
]]
local cache = setmetatable({}, { __mode = "k" })

local function Cached(owner, version, yield, Gather)
	local cached = cache[owner]
	if cached and cached.version == version then
		return cached.blobs
	end
	local byInstance = {}
	Gather(owner, byInstance, yield)
	local blobs = {}
	for instance, points in pairs(byInstance) do
		blobs[instance] = Cluster(points, yield)
	end
	cache[owner] = { version = version, blobs = blobs }
	return blobs
end

local function GatherObjective(objective, byInstance, yield)
	for _, spawnData in pairs(objective.spawnList) do
		if type(spawnData) == "table" then
			routes.AddWorldSpawns(byInstance, spawnData.Spawns, routes.SpawnName(objective, spawnData), yield)
		end
	end
end

local function GatherTurnIn(quest, byInstance, yield)
	routes.ForEachFinisher(quest, function(spawns, name)
		routes.AddWorldSpawns(byInstance, spawns, name, yield)
	end)
end

-- Each blob as a camp, shaped as a stop with its one task, which has the camp as its place
local function AddCamps(camps, blobs, task)
	for instance, list in pairs(blobs) do
		for _, blob in ipairs(list) do
			local camp = {
				x = blob.x,
				y = blob.y,
				instance = instance,
				radius = blob.radius,
				count = blob.count,
				names = blob.names,
				area = IsArea(blob),
				camp = true,
			}
			local own = setmetatable({ candidates = { camp }, choice = 1 }, { __index = task })
			camp.tasks = { own }
			camps[#camps + 1] = camp
		end
	end
end

local function ObjectiveTask(key, questID, quest, objective, party)
	return {
		key = key,
		kind = "objective",
		questID = questID,
		questName = quest.name or tostring(questID),
		quest = quest,
		objective = objective,
		party = party,
	}
end

--[[
	Every camp: each objective not yet done of the player's quests, a dungeon or raid quest's at the
	instance's entrance and marked untracked, as the route never goes in; each done quest's turn-in; and
	with the partyQuests setting, the objectives of the party's quests the player doesn't have, from members
	not left out. An ignored objective still has its camps: ignoring leaves it off the route, not off the map
]]
function routes.BuildCamps(yield)
	local camps = {}
	if not routes.IsQuestieReady() then
		return camps
	end
	local log = QuestLog()
	for questID, quest in pairs(log) do
		if type(quest) == "table" then
			local state = QuestState(quest)
			if state == 0 then
				-- A dungeon or raid quest's objectives are inside the instance: camps at its entrance, untracked
				local untracked = IsInstanceQuest(questID) or nil
				ForEachObjective(quest, function(objectiveKey, objective)
					if type(objective) == "table" and not objective.Completed and HasSpawns(objective) then
						local blobs =
							Cached(objective, routes.CountEntries(objective.spawnList), yield, GatherObjective)
						local key = questID .. ":" .. objectiveKey
						local task = ObjectiveTask(key, questID, quest, objective)
						task.untracked = untracked
						AddCamps(camps, blobs, task)
					end
				end)
			elseif state == 1 and routes.IsOnQuest(questID) then
				local blobs = Cached(quest, 1, yield, GatherTurnIn)
				AddCamps(camps, blobs, {
					key = questID .. ":turnIn",
					kind = "turnIn",
					questID = questID,
					questName = quest.name or tostring(questID),
					quest = quest,
					ready = true,
				})
			end
		end
		yield()
	end
	for questID, quest in pairs(routes.PartyQuests(log, yield)) do
		if not IsInstanceQuest(questID) then
			for index, objective in pairs(quest.Objectives) do
				if not objective.Completed and HasSpawns(objective) then
					local blobs = Cached(objective, routes.CountEntries(objective.spawnList), yield, GatherObjective)
					local key = questID .. ":p" .. tostring(index)
					AddCamps(camps, blobs, ObjectiveTask(key, questID, quest, objective, true))
				end
			end
		end
		yield()
	end
	return camps
end
