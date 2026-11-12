local _, ns = ...

--[[
	Routes: quest chains planned ahead, with Predictive Questing Routes (predictiveRoutes) on, whether
	Local Available Quests is on or not. A quest the player doesn't have yet is planned whole: its pick-up (Routes-Pick-Ups.lua), then
	its objectives, then its turn-in, and then the quests its turn-in unlocks, each one's pick-up waiting
	on that turn-in. The route then knows a follow-up waits in the north before the player goes there,
	and does the south first, so the north is one trip.

	Only quests the zone can finish count (routes.IsChainQuest): an NPC or object that starts it, every
	objective and the turn-in all in the zone. An objective with nowhere to go, such as cloth or anything
	else bought or made, never counts against a quest, as it's done wherever the player is. A chain
	stops at the first quest that leads elsewhere, or is started by an item, or asks for anything this
	can't tell from Questie's database (a profession, reputation, a spell).

	Questie's database has no counts, so a planned objective is its name alone. Each is a node of its own
	(keyed questID:f<index>, its turn-in questID:ft), predicted, on a gray disc with Questie's icon for
	its kind; the pick-up's own node stands for it when ignored. Taking the quest replaces them with its
	real objectives on the next plan.

	In a party, with Party Objectives on, a member's quest the player doesn't have grows follow-ups the same
	way from its turn-in (questID:pt, Routes-Nodes.lua): each one a member who has the quest could take, by
	their level, race and class (MemberCouldTake), keyed questID:pp, its objectives questID:pf<index> and its
	turn-in questID:pft, all marked party, so the route plans the trip once for the whole party. Questie
	shares only what members have now, not what they've done, so a follow-up that needs more than the quest
	before it is left out
]]

local routes = ns.routes
local helpers = routes.pickUpHelpers -- Routes-Pick-Ups.lua

local Candidates = routes.Candidates
local QueryQuest = helpers.QueryQuest
local QuestPlan = routes.QuestPlan -- Routes-Quest-Plans.lua

local MAX_CHAIN_STARTS = 16 -- Quests available now that are planned whole, nearest giver first
local MAX_PLANNED_QUESTS = 24 -- Quests planned whole at most, those and their follow-ups, so a plan stays quick
local MAX_CHAIN_DEPTH = 6 -- Follow-ups planned at most after any one quest

routes.MAX_CHAIN_STARTS = MAX_CHAIN_STARTS

-- Fields that make a quest one this can't plan ahead, as Questie checks them against the character
local UNPLANNABLE = {
	"requiredSkill",
	"requiredMinRep",
	"requiredMaxRep",
	"requiredSpell",
	"requiredSpecialization",
	"requiredRanks",
	"parentQuest",
	"availableStartingWith",
	"disabledByQuest",
}

--------------------------------------------------------------------------------
-- What follows what
--------------------------------------------------------------------------------

--[[
	Every quest's follow-ups, quest ID to a list of the quests that name it as one to do first
	(preQuestSingle or preQuestGroup), read from every quest Questie has once a session. It's read a few
	quests a frame (yield), and a plan stopped partway leaves it for the next to go on with
]]
local index = { position = 0 }

local function FollowUpIndex(QuestieDB, yield)
	if index.done then
		return index.followUps
	end
	if not index.ids then
		local ids = {}
		if type(QuestieDB.QuestPointers) == "table" then
			for questID in pairs(QuestieDB.QuestPointers) do
				if type(questID) == "number" then
					ids[#ids + 1] = questID
				end
			end
		end
		table.sort(ids)
		index.ids, index.followUps = ids, {}
	end
	local ids, followUps = index.ids, index.followUps
	while index.position < #ids do
		index.position = index.position + 1
		local questID = ids[index.position]
		for _, field in ipairs({ "preQuestSingle", "preQuestGroup" }) do
			local before = QueryQuest(QuestieDB, questID, field)
			if type(before) == "table" then
				for _, raw in ipairs(before) do
					-- A negative one in a group is still done first; Questie's sign only skips an exclusive check
					local first = type(raw) == "number" and math.abs(raw)
					if first then
						local list = followUps[first]
						if not list then
							list = {}
							followUps[first] = list
						end
						list[#list + 1] = questID
					end
				end
			end
		end
		yield()
	end
	index.done = true
	return followUps
end

--------------------------------------------------------------------------------
-- Which quests count
--------------------------------------------------------------------------------

-- Whether the turn-in of the quest a breadcrumb leads to waits on it; one that doesn't is only a walk
local function IsNeededBreadcrumb(QuestieDB, questID, target)
	for _, field in ipairs({ "preQuestSingle", "preQuestGroup" }) do
		for _, raw in ipairs(QueryQuest(QuestieDB, target, field) or {}) do
			if type(raw) == "number" and math.abs(raw) == questID then
				return true
			end
		end
	end
	return false
end

--[[
	Whether the zone can finish a quest: nothing it needs, objective or turn-in, only in another zone
	(Routes-Pick-Ups.lua's IsElsewhere, where a thing with nowhere to go counts as here), and not a
	breadcrumb that only walks the player to a quest they can pick up anyway. Its giver being in the zone
	is the caller's to check. Questie's data doesn't move, so it's worked out once a quest and zone
]]
local chainCache = {}

function routes.IsChainQuest(QuestieDB, questID, start, yield)
	local byZone = chainCache[start.zone]
	if not byZone then
		wipe(chainCache) -- A new zone: the last one's answers go, so they don't pile up over a session
		byZone = {}
		chainCache[start.zone] = byZone
	end
	if byZone[questID] ~= nil then
		return byZone[questID]
	end
	local target = QueryQuest(QuestieDB, questID, "breadcrumbForQuestId")
	local counts = not helpers.IsElsewhere(QuestieDB, questID, start.zone, yield)
	if counts and type(target) == "number" and target > 0 then
		counts = IsNeededBreadcrumb(QuestieDB, questID, target)
	end
	byZone[questID] = counts
	return counts
end

-- Whether anything Questie checks of a quest that's the same for everyone rules it out of planning ahead
local function IsPlannable(QuestieDB, questID)
	for _, field in ipairs(UNPLANNABLE) do
		local value = QueryQuest(QuestieDB, questID, field)
		if value and value ~= 0 then
			return false
		end
	end
	if type(QuestieDB.IsRepeatable) == "function" then
		local ok, repeatable = pcall(QuestieDB.IsRepeatable, questID)
		if ok and repeatable then
			return false
		end
	end
	local hidden = Questie and Questie.db and Questie.db.char and Questie.db.char.hidden
	if type(hidden) == "table" and hidden[questID] then
		return false
	end
	local corrections = ns.ImportQuestieModule("QuestieCorrections")
	if corrections and type(corrections.hiddenQuests) == "table" and corrections.hiddenQuests[questID] then
		return false
	end
	return true
end

--[[
	Whether the character could take a quest once the quests before it are done: their race and class,
	nothing Questie checks that this can't (UNPLANNABLE), not repeatable, not hidden in Questie, not
	above their level, and none of the quests it shuts out taken, done or planned
]]
local function CouldTake(QuestieDB, questID, complete, planned, log)
	if not IsPlannable(QuestieDB, questID) then
		return false
	end
	local required = tonumber(QueryQuest(QuestieDB, questID, "requiredLevel"))
	if required and required > UnitLevel("player") then
		return false
	end
	local player = ns.ImportQuestieModule("QuestiePlayer")
	for field, check in pairs({ requiredRaces = "HasRequiredRace", requiredClasses = "HasRequiredClass" }) do
		local value = QueryQuest(QuestieDB, questID, field)
		if value and value ~= 0 then
			local fits = player and player[check]
			local ok, yes = false, false
			if type(fits) == "function" then
				ok, yes = pcall(fits, value)
			end
			if not (ok and yes) then
				return false
			end
		end
	end
	for _, other in ipairs(QueryQuest(QuestieDB, questID, "exclusiveTo") or {}) do
		if complete[other] or log[other] or planned[other] then
			return false
		end
	end
	return true
end

-- Whether a bit flag is in a mask of Questie's, as QuestiePlayer tests it; nothing required fits everyone
local function HasFlag(mask, flag)
	return not mask or mask == 0 or (flag ~= nil and (mask % (2 * flag)) >= flag)
end

--[[
	Whether a party member who has the quest before it (units, party units) could take a quest: one of them
	of its level, race (LibQuestieDB's race masks, as Questie reads them) and class, and none of the quests it
	shuts out taken or planned by anyone. What they've done is Questie's to know and not shared, so it's
	taken as nothing that matters
]]
local function MemberCouldTake(QuestieDB, questID, units, planned, log)
	if not IsPlannable(QuestieDB, questID) then
		return false
	end
	for _, other in ipairs(QueryQuest(QuestieDB, questID, "exclusiveTo") or {}) do
		if log[other] or planned[other] or routes.PartyHasQuest(other) then
			return false
		end
	end
	local required = tonumber(QueryQuest(QuestieDB, questID, "requiredLevel")) or 0
	local races = QueryQuest(QuestieDB, questID, "requiredRaces")
	local classes = QueryQuest(QuestieDB, questID, "requiredClasses")
	local masks = LibQuestieDB and LibQuestieDB.Enum and LibQuestieDB.Enum.raceMaskById
	for _, unit in ipairs(units) do
		local raceID, classID = select(3, UnitRace(unit)), select(3, UnitClass(unit))
		local raceFlag = type(masks) == "table" and raceID and masks[raceID] or nil
		local classFlag = classID and 2 ^ (classID - 1) or nil
		if (UnitLevel(unit) or 0) >= required and HasFlag(races, raceFlag) and HasFlag(classes, classFlag) then
			return true
		end
	end
	return false
end

--[[
	The turn-ins a follow-up waits on, nodes from turnInOf by quest ID: for preQuestSingle, any one of the
	quests (none once one is done), for preQuestGroup every one not yet done. Nil where one it waits on
	isn't on the route, or where it waits on nothing planned, as it's either available now (Questie's own
	set, which Routes-Pick-Ups.lua reads) or held back by something else
]]
local function WaitsOn(QuestieDB, questID, complete, turnInOf)
	local requires = {}
	local single = QueryQuest(QuestieDB, questID, "preQuestSingle")
	if type(single) == "table" and #single > 0 then
		local via
		for _, first in ipairs(single) do
			if complete[first] then
				return nil
			end
			via = via or turnInOf[first]
		end
		requires[1] = via
	else
		for _, raw in ipairs(QueryQuest(QuestieDB, questID, "preQuestGroup") or {}) do
			local first = type(raw) == "number" and math.abs(raw)
			if first and not complete[first] then
				if not turnInOf[first] then
					return nil
				end
				requires[#requires + 1] = turnInOf[first]
			end
		end
	end
	return #requires > 0 and requires or nil
end

--------------------------------------------------------------------------------
-- Nodes
--------------------------------------------------------------------------------

--[[
	Adds a pick-up's quest to nodes: a predicted objective node for each of its objectives here, waiting
	on the pick-up, and its turn-in, waiting on them all, hidden with Predictive Questing Routes off as a turn-in
	planned ahead is (Routes-Nodes.lua). Returns the turn-in node, nil where nothing in the zone takes it
]]
local function PlanQuest(QuestieDB, pickUp, start, yield, nodes)
	local plan = QuestPlan(QuestieDB, pickUp.questID, start, yield)
	local color = { ns.GetColorRGB("ROUTE_PREDICTED") }
	local waits = { pickUp }
	-- A party member's follow-up (pickUp.party): keys of its own, and every node the party's
	local prefix = pickUp.party and ":pf" or ":f"
	for position, entry in ipairs(plan.objectives) do
		local node = {
			key = pickUp.questID .. prefix .. position,
			kind = "objective",
			questID = pickUp.questID,
			questName = pickUp.questName,
			quest = pickUp.quest,
			-- Shaped as Questie's own, for the arrow, the map and their tooltips: a name, no count
			objective = {
				Description = entry.text,
				Icon = entry.icon,
				Color = color,
				Index = position,
				Completed = false,
				predicted = true,
			},
			candidates = Candidates(entry.blobs, start, true),
			blobs = entry.blobs,
			spawns = entry.blobs.spawns,
			requires = { pickUp },
			predicted = true,
			pickUpNode = pickUp,
			party = pickUp.party,
			holdersOf = pickUp.holdersOf,
		}
		nodes[#nodes + 1] = node
		waits[#waits + 1] = node
	end
	if #plan.turnIn == 0 then
		return nil
	end
	local turnIn = {
		key = pickUp.questID .. prefix .. "t",
		kind = "turnIn",
		questID = pickUp.questID,
		questName = pickUp.questName,
		quest = pickUp.quest,
		candidates = Candidates(plan.turnIn, start, false),
		blobs = plan.turnIn,
		hidden = not routes.Settings().predictiveRoutes or nil,
		requires = waits,
		predicted = true,
		pickUpNode = pickUp,
		party = pickUp.party,
		holdersOf = pickUp.holdersOf,
	}
	nodes[#nodes + 1] = turnIn
	return turnIn
end

--[[
	The quests the route knows a turn-in for, quest ID to its node: the log's (ready, or planned ahead of
	its objectives), and apart, the party's quests the player doesn't have, whose follow-ups are theirs
]]
local function LoggedTurnIns(nodes)
	local turnInOf, partyTurnInOf = {}, {}
	for _, node in ipairs(nodes) do
		if node.kind == "turnIn" then
			if node.party then
				partyTurnInOf[node.questID] = node -- A party member's quest (Routes-Nodes.lua)
			else
				turnInOf[node.questID] = node
			end
		end
	end
	return turnInOf, partyTurnInOf
end

--[[
	With Predictive Questing Routes on, plans whole each quest Routes-Pick-Ups.lua put on the route from across the
	zone (chainStarts, nearest first), and then the quests that follow the log's quests and those, each
	follow-up's pick-up waiting on the turn-in that unlocks it (WaitsOn), up to MAX_PLANNED_QUESTS in all
	and MAX_CHAIN_DEPTH after any one quest. A follow-up is the zone's to finish (routes.IsChainQuest),
	its giver in the zone, one the character could take (CouldTake), and one the Local Available Quests
	settings put on the route. Then, in a party, the same from the party's own quests' turn-ins, for a member
	who has the quest: those follow-ups are theirs (MemberCouldTake), and one the player's own chains plan
	already isn't planned twice
]]
function routes.AddChainNodes(nodes, start, log, chainStarts, yield)
	local settings = routes.Settings()
	if not settings.predictiveRoutes then
		return
	end
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not (QuestieDB and type(QuestieDB.QueryQuestSingle) == "function") then
		return
	end
	local complete = Questie and Questie.db and Questie.db.char and Questie.db.char.complete
	complete = type(complete) == "table" and complete or {}
	local followUps = FollowUpIndex(QuestieDB, yield)
	local turnInOf, partyTurnInOf = LoggedTurnIns(nodes)
	local onRoute = {}
	for _, node in ipairs(nodes) do
		onRoute[node.key] = true
	end

	--[[
		The quests whose follow-ups come next, each { questID, depth }: the log's first, by quest ID, then the
		chain starts, then the party's, each also with the units who have the quest it grew from and that
		quest (holdersOf), whose holders an ignore is for
	]]
	local queue, planned, count = {}, {}, 0
	local logged = {}
	for questID in pairs(turnInOf) do
		logged[#logged + 1] = questID
	end
	table.sort(logged)
	for _, questID in ipairs(logged) do
		queue[#queue + 1] = { questID = questID, depth = 0 }
	end
	for _, pickUp in ipairs(chainStarts) do
		if count < MAX_PLANNED_QUESTS then
			count = count + 1
			planned[pickUp.questID] = true
			local turnIn = PlanQuest(QuestieDB, pickUp, start, yield, nodes)
			if turnIn then
				turnInOf[pickUp.questID] = turnIn
				queue[#queue + 1] = { questID = pickUp.questID, depth = 0 }
			end
		end
	end
	local partyQuests = {}
	for questID in pairs(partyTurnInOf) do
		partyQuests[#partyQuests + 1] = questID
	end
	table.sort(partyQuests)
	for _, questID in ipairs(partyQuests) do
		local units = routes.PartyQuestHolderUnits(questID)
		if #units > 0 then
			queue[#queue + 1] = { questID = questID, depth = 0, party = true, units = units, holdersOf = questID }
		end
	end

	local head = 1
	while head <= #queue and count < MAX_PLANNED_QUESTS do
		local item = queue[head]
		head = head + 1
		local list = {}
		for _, questID in ipairs(followUps[item.questID] or {}) do
			list[#list + 1] = questID
		end
		local nextInChain = QueryQuest(QuestieDB, item.questID, "nextQuestInChain")
		if type(nextInChain) == "number" and nextInChain > 0 and not tContains(list, nextInChain) then
			list[#list + 1] = nextInChain
		end
		table.sort(list)
		local party = item.party
		for _, questID in ipairs(list) do
			--[[
				The player's follow-up, or a party member's (questID:pp): not one the player has or plans, nor one
				anyone in the party has already. The party knows only what they have, so for theirs the quest
				before it is the only one taken as done
			]]
			local key = questID .. (party and ":pp" or ":pickUp")
			if
				count < MAX_PLANNED_QUESTS
				and not planned[questID]
				and not onRoute[key]
				and not onRoute[questID .. ":pickUp"]
				and not routes.skipped[key]
				and not helpers.IsTakenOrDone(questID, log)
				and not (party and routes.PartyHasQuest(questID))
				and not routes.IsInstanceQuest(questID)
				and not helpers.IsTooLow(QuestieDB, questID, settings.localQuestLevel)
			then
				-- A party member's done quests aren't shared: their follow-up waits only on the quest before it
				local done, turnIns = complete, turnInOf
				if party then
					done, turnIns = {}, partyTurnInOf
				end
				local requires = WaitsOn(QuestieDB, questID, done, turnIns)
				local starters = requires and helpers.StarterBlobs(QuestieDB, questID, start, yield)
				local could
				if party then
					could = MemberCouldTake(QuestieDB, questID, item.units, planned, log)
				else
					could = CouldTake(QuestieDB, questID, complete, planned, log)
				end
				if
					starters
					and #starters > 0
					and could
					and routes.IsChainQuest(QuestieDB, questID, start, yield)
					and helpers.Handling(QuestieDB, questID, start.zone, settings, yield) == helpers.ROUTE
				then
					local info, name = helpers.QuestInfo(QuestieDB, questID)
					local unlocker = requires[1]
					local pickUp = {
						key = key,
						kind = "pickUp",
						questID = questID,
						questName = name,
						quest = info,
						ready = true,
						escort = routes.IsEscort(questID) or nil,
						candidates = Candidates(starters, start, false),
						blobs = starters,
						requires = requires,
						predicted = true,
						party = party or nil,
						holdersOf = item.holdersOf,
						-- The quest whose turn-in unlocks it, for the map's tooltip
						after = {
							questID = unlocker.questID,
							questName = unlocker.questName,
							quest = unlocker.quest,
							party = party or nil,
						},
					}
					nodes[#nodes + 1] = pickUp
					onRoute[key] = true
					planned[questID] = true
					count = count + 1
					local turnIn = PlanQuest(QuestieDB, pickUp, start, yield, nodes)
					if turnIn then
						if party then
							partyTurnInOf[questID] = turnIn
						else
							turnInOf[questID] = turnIn
						end
						if item.depth + 1 < MAX_CHAIN_DEPTH then
							queue[#queue + 1] = {
								questID = questID,
								depth = item.depth + 1,
								party = party,
								units = item.units,
								holdersOf = item.holdersOf,
							}
						end
					end
				end
			end
		end
		yield()
	end
end
