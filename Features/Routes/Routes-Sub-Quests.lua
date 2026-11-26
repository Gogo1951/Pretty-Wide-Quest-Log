local _, ns = ...

--[[
	Routes: a quest whose item comes from another quest. Need for a Cure needs the Venomtail Antidote, and
	Finding the Antidote hands it out. While Need for a Cure isn't done and Finding the Antidote isn't
	turned in, Finding the Antidote is done first: picked up when it's not in the log, its objectives and
	turn-in when it is, and every node of Need for a Cure waits on it. On Need for a Cure's clock, Finding
	the Antidote in the log has the same time left (routes.TimedQuests), so the Quest Arrow lists it with
	that time, and its nodes go ahead of every other timed quest's
]]

local routes = ns.routes

local function IsTurnedIn(questID)
	local complete = Questie and Questie.db and Questie.db.char and Questie.db.char.complete
	return type(complete) == "table" and complete[questID] and true or false
end

--[[
	The quests to do first now, each one's quest ID to the quest it's for: that quest in the log and not done
	yet, this one not turned in
]]
function routes.SubQuests(log)
	local active = {}
	for parentID, subID in pairs(ns.SUB_QUEST_IDS) do
		local parent = log[parentID]
		if type(parent) == "table" and routes.QuestState(parent) == 0 and not IsTurnedIn(subID) then
			active[subID] = parentID
		end
	end
	return active
end

-- A copy of a node's requires with more added, leaving out any that already waits on the node
local function AddRequires(node, more)
	local requires = {}
	for _, required in ipairs(node.requires or {}) do
		requires[#requires + 1] = required
	end
	for _, required in ipairs(more) do
		if not routes.WaitsFor(required, node, {}) then
			requires[#requires + 1] = required
		end
	end
	node.requires = requires
end

--[[
	For each quest to do first (routes.SubQuests): a pick-up where its giver is in the zone when it's not in
	the log and not on the route already, its nodes urgent with its parent's clock and ahead of every other
	timed quest's (turnInDistance -1), and every node of the parent waiting on all of them
]]
function routes.AddSubQuestNodes(nodes, start, log, yield)
	local active = routes.SubQuests(log)
	if not next(active) then
		return
	end
	local timed = routes.TimedQuests()
	local helpers = routes.pickUpHelpers
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	for subID, parentID in pairs(active) do
		local subNodes, parentNodes = {}, {}
		local key = subID .. ":pickUp"
		local pickUp
		for _, node in ipairs(nodes) do
			if not node.party then
				if node.questID == subID then
					subNodes[#subNodes + 1] = node
					pickUp = pickUp or (node.key == key and node) or nil
				elseif node.questID == parentID then
					parentNodes[#parentNodes + 1] = node
				end
			end
		end
		if
			not pickUp
			and not log[subID]
			and not routes.skipped[key]
			and QuestieDB
			and type(QuestieDB.QueryQuestSingle) == "function"
			and not helpers.IsTakenOrDone(subID, log)
		then
			local blobs = helpers.StarterBlobs(QuestieDB, subID, start, yield)
			if #blobs > 0 then
				local info, name = helpers.QuestInfo(QuestieDB, subID)
				pickUp = {
					key = key,
					kind = "pickUp",
					questID = subID,
					questName = name,
					quest = info,
					ready = true,
					candidates = routes.Candidates(blobs, start, false),
					blobs = blobs,
				}
				nodes[#nodes + 1] = pickUp
				subNodes[#subNodes + 1] = pickUp
			end
		end
		if timed[parentID] then
			for _, node in ipairs(subNodes) do
				node.urgent = true
				node.turnInDistance = -1
			end
		end
		if #subNodes > 0 then
			for _, node in ipairs(parentNodes) do
				AddRequires(node, subNodes)
			end
		end
		yield()
	end
end
