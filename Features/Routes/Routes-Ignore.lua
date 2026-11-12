local _, ns = ...

--[[
	Routes: the ignore list. Objectives, turn-ins and party members left out of the route from the Quest
	Arrow's menu or a right-click on a map marker. The player's own are saved for the character and last
	until the zone they were ignored in is reset (a middle-click on the Quest Arrow). A party member's
	objective, and a member switched off, are for that group only: gone once the member leaves it
]]

local routes = ns.routes

local L = ns.L

--------------------------------------------------------------------------------
-- Skipping
--------------------------------------------------------------------------------

local ignoredCount = 0 -- How many tasks have been ignored, for each one's place in the list

--[[
	A party member's task, for a quest the player doesn't have: an objective (questID:p<index>), its turn-in
	(questID:pt), or one planned ahead from their turn-ins (Routes-Chains.lua): a follow-up's pick-up
	(questID:pp), objectives (questID:pf<index>) and turn-in (questID:pft)
]]
local PARTY_KEYS = { ":p%d+$", ":pt$", ":pp$", ":pf%d+$", ":pft$" }
local PARTY_FOLLOW_UP_KEYS = { ":pp$", ":pf%d+$", ":pft$" }

local function MatchesAny(key, patterns)
	for _, pattern in ipairs(patterns) do
		if key:find(pattern) then
			return true
		end
	end
	return false
end

local function IsPartyKey(key)
	return MatchesAny(key, PARTY_KEYS)
end

-- The player's own ignores, saved for the character, by task key, each as routes.skipped has it
local function Saved()
	return ns.db and ns.db.char.routesIgnored
end

-- The zone ignores are kept by, and reset by: the one the player is in (0 where the client won't say)
local function CurrentZone()
	return routes.PlayerZone() or 0
end

--[[
	Puts one task on the ignore list, as the Quest Arrow's menu lists it, with the zone the player is in. A
	party member's also keeps who has its quest, so it goes once they've all left the group; the player's
	own is saved
]]
local function Ignore(task)
	-- A planned objective or turn-in of a quest not taken yet goes with its pick-up (Routes-Chains.lua)
	task = task.pickUpNode or task
	if routes.skipped[task.key] then
		return
	end
	ignoredCount = ignoredCount + 1
	local entry = {
		label = routes.TaskLabel(task),
		questID = task.questID,
		npcID = task.npcID, -- A flight path's flight master, which has no quest
		order = ignoredCount,
		zone = CurrentZone(),
	}
	if IsPartyKey(task.key) then
		-- Who has the quest, or for a follow-up planned ahead, the quest it follows (holdersOf)
		entry.holders = routes.PartyQuestHolders(task.holdersOf or task.questID)
	elseif Saved() then
		Saved()[task.key] = entry
	end
	routes.skipped[task.key] = entry
end

-- Takes one task off the ignore list, saved or not
local function Forget(key)
	routes.skipped[key] = nil
	if Saved() then
		Saved()[key] = nil
	end
end

-- The saved ignores back on the list at login, ahead of the first plan
routes.OnLogin(function()
	for key, entry in pairs(Saved() or {}) do
		if type(key) == "string" and type(entry) == "table" and not IsPartyKey(key) then
			routes.skipped[key] = entry
			ignoredCount = math.max(ignoredCount, tonumber(entry.order) or 0)
		end
	end
end)

-- Leaves the stop's tasks out of the route until the zone is reset (a right-click on a world map waypoint)
function routes.SkipStop(stop)
	if not stop then
		return
	end
	local names, seen = {}, {}
	for _, task in ipairs(stop.tasks) do
		if task.kind == "flightPath" or task.kind == "fly" then
			Ignore(task)
			names[#names + 1] = routes.TaskLabel(task)
		elseif task.kind ~= "corpse" then
			Ignore(task)
			if not seen[task.questID] then
				seen[task.questID] = true
				names[#names + 1] = routes.QuestLink(task.questID, task.questName)
			end
		end
	end
	if #names == 0 then
		return -- Nothing to skip: the way back to the player's corpse
	end
	routes.Print(string.format(L["ROUTES_SKIPPED"], table.concat(names, L["LIST_SEPARATOR"])))
	routes.RequestPlan()
end

-- What a task is called in chat and the Quest Arrow's menu: its objective, "Wayward Weapons Turn-In", "Devrak Flight Path" or "Flight to Camp Taurajo"
function routes.TaskLabel(task)
	if task.kind == "turnIn" then
		return string.format(L["ROUTES_MENU_TURN_IN"], task.questName or "")
	elseif task.kind == "pickUp" then
		return string.format(L["ROUTES_MENU_PICK_UP"], task.questName or "")
	elseif task.kind == "flightPath" then
		return routes.FlightPathLabel(task)
	elseif task.kind == "fly" then
		return routes.FlightLabel(task)
	end
	return task.objective and task.objective.Description or ""
end

--[[
	What ignoring an objective or turn-in prints; the Quest Arrow panel's Example draws it too. A party
	member's lasts while they're in the group, the player's own until the zone is reset
]]
function routes.BuildIgnoredMessage(label, questID, questName, party)
	return string.format(
		L[party and "ROUTES_IGNORED_PARTY" or "ROUTES_IGNORED"],
		label,
		routes.QuestLink(questID, questName)
	)
end

-- Leaves one objective or turn-in out of the route, from the Quest Arrow's menu or a right-click
function routes.IgnoreTask(task)
	if not (task and task.key) or task.kind == "corpse" then
		return
	end
	task = task.pickUpNode or task -- One of a quest not taken yet goes with its pick-up, and says so
	Ignore(task)
	if task.kind == "flightPath" or task.kind == "fly" then
		-- No quest to name: "Ignoring Devrak Flight Path until you reset the zone."
		routes.Print(string.format(L["ROUTES_SKIPPED"], routes.TaskLabel(task)))
	else
		routes.Print(
			routes.BuildIgnoredMessage(routes.TaskLabel(task), task.questID, task.questName, IsPartyKey(task.key))
		)
	end
	routes.RequestPlan()
end

-- Puts one ignored objective or turn-in back on the route, from the Quest Arrow's menu
function routes.UnignoreTask(key)
	local entry = routes.skipped[key]
	if not entry then
		return
	end
	Forget(key)
	routes.Print(string.format(L["ROUTES_UNIGNORED"], entry.label))
	routes.RequestPlan()
end

--[[
	The ignore list as the Quest Arrow's menu shows it, in the order they were ignored: each { key, label }.
	Only those still in play: a quest the player or the party still has, so a quest turned in or dropped
	leaves it; a pick-up of a quest not yet taken or done; a party follow-up while someone it's for is in the
	group (PruneGroupIgnores drops it once they've all gone); and flight paths not yet discovered
]]
function routes.IgnoredTasks()
	local log = routes.IsQuestieReady() and routes.QuestLog() or {}
	local partyLog
	local list = {}
	for key, entry in pairs(routes.skipped) do
		local held = entry.questID ~= nil and log[entry.questID]
		if entry.npcID then
			held = not routes.IsFlightMasterKnown(entry.npcID)
		elseif MatchesAny(key, PARTY_FOLLOW_UP_KEYS) then
			held = true
		elseif IsPartyKey(key) then
			partyLog = partyLog or routes.PartyProgress(log)
			held = partyLog[entry.questID]
		elseif key:find(":pickUp$") and entry.questID then
			held = not routes.pickUpHelpers.IsTakenOrDone(entry.questID, log)
		end
		if held then
			list[#list + 1] = { key = key, label = entry.label, order = entry.order }
		end
	end
	table.sort(list, function(a, b)
		return a.order < b.order
	end)
	return list
end

--[[
	Resets the zone the player is in, a middle-click on the Quest Arrow or a map marker: every objective
	and turn-in ignored here back on the route, saved or a party member's, and no camp held first for having
	been in it, so only one the player stands in now goes first again. Other zones' ignores, and party
	members switched off, stay
]]
function routes.ResetZone()
	local zone = CurrentZone()
	for key, entry in pairs(routes.skipped) do
		if (entry.zone or 0) == zone then
			Forget(key)
		end
	end
	routes.engaged = nil
	routes.worked = {}
	routes.Print(L["ROUTES_ZONE_RESET"])
	routes.CancelPlan() -- A plan underway was made with the old lists and would put them back
	routes.ForgetLastSolve() -- And the route is planned fresh, not from the one it had
	routes.RequestPlan()
end

--[[
	A quest turned in or dropped takes its saved ignores with it, so they don't pile up. An ignored pick-up
	stays when the quest is dropped, as it's back to one that could be picked up, and goes once it's turned in
]]
local function ForgetQuest(questID, turnedIn)
	if type(questID) ~= "number" then
		return
	end
	for key, entry in pairs(routes.skipped) do
		if entry.questID == questID and not IsPartyKey(key) and (turnedIn or not key:find(":pickUp$")) then
			Forget(key)
		end
	end
end

function routes:OnQuestRemoved(questID)
	ForgetQuest(questID, false)
end

function routes:OnQuestTurnedIn(questID)
	ForgetQuest(questID, true)
end

-- Leaves a party member's quests out of the route, or takes them back in, from the Quest Arrow's menu
function routes.SetMemberIgnored(name, ignored)
	routes.ignoredMembers[name] = ignored or nil
	routes.Print(string.format(L[ignored and "ROUTES_MEMBER_IGNORED" or "ROUTES_MEMBER_INCLUDED"], name))
	routes.RequestPlan()
end

--[[
	A member leaving the group takes the ignores that were for them: their objectives switch back on, and a
	party objective goes once everyone who had its quest is gone. Said in chat, by name, only when something
	was ignored. Nothing while a member's name is still unknown, so a roster still loading clears nothing
]]
function routes.PruneGroupIgnores()
	local names = routes.GroupNames()
	if not names then
		return
	end
	local gone, changed = {}, false
	for name in pairs(routes.ignoredMembers) do
		if not names[Ambiguate(name, "short")] then
			routes.ignoredMembers[name] = nil
			gone[#gone + 1], changed = name, true
		end
	end
	for key, entry in pairs(routes.skipped) do
		if IsPartyKey(key) then
			local holders, stays = entry.holders or {}, false
			for _, holder in ipairs(holders) do
				stays = stays or names[holder] == true
			end
			if not stays then
				routes.skipped[key], changed = nil, true
				for _, holder in ipairs(holders) do
					if not tContains(gone, holder) then
						gone[#gone + 1] = holder
					end
				end
			end
		end
	end
	if changed then
		table.sort(gone)
		routes.Print(string.format(L["ROUTES_MEMBER_LEFT_CLEARED"], table.concat(gone, L["LIST_SEPARATOR"])))
		routes.RequestPlan()
	end
end

-- Leaving the group takes every ignore that was for it; the player's own stay
function routes:OnGroupLeft()
	local had = next(routes.ignoredMembers) ~= nil
	routes.ignoredMembers = {}
	for key in pairs(routes.skipped) do
		if IsPartyKey(key) then
			routes.skipped[key], had = nil, true
		end
	end
	if had then
		routes.Print(L["ROUTES_GROUP_LEFT_CLEARED"])
		routes.RequestPlan()
	end
end

--[[
	The partyQuests setting, as the Quest Arrow's menu switches it, planned again at once. Options sets it
	through routes.SetSetting
]]
function routes.SetPartyQuests(on)
	routes.SetSetting("partyQuests", on)
	routes.RequestPlan()
end
