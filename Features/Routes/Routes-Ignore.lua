local _, ns = ...

--[[
	Routes: the ignore list. Objectives, turn-ins and party members left out of the route from the Quest
	Arrow's menu or a right-click on a map marker, cleared on joining or leaving a group, and put back all
	at once with a middle-click
]]

local routes = ns.routes

local L = ns.L

--------------------------------------------------------------------------------
-- Skipping
--------------------------------------------------------------------------------

local ignoredCount = 0 -- How many tasks have been ignored, for each one's place in the list

-- Puts one task on the ignore list, as the Quest Arrow's menu lists it
local function Ignore(task)
	if not routes.skipped[task.key] then
		ignoredCount = ignoredCount + 1
		routes.skipped[task.key] = { label = routes.TaskLabel(task), questID = task.questID, order = ignoredCount }
	end
end

-- Leaves the stop's tasks out of the route until the ignore list is cleared (a right-click on a world map waypoint)
function routes.SkipStop(stop)
	if not stop then
		return
	end
	local names, seen = {}, {}
	for _, task in ipairs(stop.tasks) do
		if task.kind ~= "corpse" then
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

-- What a task is called in chat and the Quest Arrow's menu: its objective, or "Wayward Weapons Turn-In"
function routes.TaskLabel(task)
	if task.kind == "turnIn" then
		return string.format(L["ROUTES_MENU_TURN_IN"], task.questName or "")
	elseif task.kind == "pickUp" then
		return string.format(L["ROUTES_MENU_PICK_UP"], task.questName or "")
	end
	return task.objective and task.objective.Description or ""
end

-- What ignoring an objective or turn-in prints; the Quest Arrow panel's Example draws it too
function routes.BuildIgnoredMessage(label, questID, questName)
	return string.format(L["ROUTES_IGNORED"], label, routes.QuestLink(questID, questName))
end

-- Leaves one objective or turn-in out of the route until the ignore list is cleared, from the Quest Arrow's menu
function routes.IgnoreTask(task)
	if not (task and task.key) or task.kind == "corpse" then
		return
	end
	Ignore(task)
	routes.Print(routes.BuildIgnoredMessage(routes.TaskLabel(task), task.questID, task.questName))
	routes.RequestPlan()
end

-- Puts one ignored objective or turn-in back on the route, from the Quest Arrow's menu
function routes.UnignoreTask(key)
	local entry = routes.skipped[key]
	if not entry then
		return
	end
	routes.skipped[key] = nil
	routes.Print(string.format(L["ROUTES_UNIGNORED"], entry.label))
	routes.RequestPlan()
end

--[[
	The ignore list as the Quest Arrow's menu shows it, in the order they were ignored: each { key, label }.
	Only those whose quest the player or the party still has, so a quest turned in or dropped leaves it
]]
function routes.IgnoredTasks()
	local log = routes.IsQuestieReady() and routes.QuestLog() or {}
	local partyLog
	local list = {}
	for key, entry in pairs(routes.skipped) do
		local held = log[entry.questID]
		if key:find(":p%d+$") then
			partyLog = partyLog or routes.PartyProgress(log)
			held = partyLog[entry.questID]
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

-- Every ignored objective and turn-in back on the route (a middle-click on the Quest Arrow)
function routes.ClearIgnored()
	routes.skipped = {}
	routes.Print(L["ROUTES_IGNORE_CLEARED"])
	routes.RequestPlan()
end

-- Leaves a party member's quests out of the route, or takes them back in, from the Quest Arrow's menu
function routes.SetMemberIgnored(name, ignored)
	routes.ignoredMembers[name] = ignored or nil
	routes.Print(string.format(L[ignored and "ROUTES_MEMBER_IGNORED" or "ROUTES_MEMBER_INCLUDED"], name))
	routes.RequestPlan()
end

--[[
	Joining or leaving a group starts the ignore list over: every ignored objective and turn-in back on the
	route, and no party member left out, as the party they were ignored in is gone. Said in chat only when
	something was ignored
]]
local function ClearForGroup(message)
	local had = next(routes.skipped) ~= nil or next(routes.ignoredMembers) ~= nil
	routes.skipped = {}
	routes.ignoredMembers = {}
	if had then
		routes.Print(L[message])
		routes.RequestPlan()
	end
end

function routes:OnGroupJoined()
	ClearForGroup("ROUTES_GROUP_JOINED_CLEARED")
end

function routes:OnGroupLeft()
	ClearForGroup("ROUTES_GROUP_LEFT_CLEARED")
end

-- The partyQuests setting, as the Quest Arrow's menu and Options both switch it, planned again at once
function routes.SetPartyQuests(on)
	routes.SetSetting("partyQuests", on)
	routes.RequestPlan()
end

--[[
	Back to the route as it plans from scratch (a middle-click on the world map's route): every ignored task
	back on it, no party member's quests ignored, and no camp held first for having been in it, so only one
	the player stands in now goes first again
]]
function routes.ResetObjectives()
	routes.skipped = {}
	routes.ignoredMembers = {}
	routes.engaged = nil
	routes.worked = {}
	routes.Print(L["ROUTES_RESET"])
	routes.CancelPlan()
	routes.RequestPlan()
end
