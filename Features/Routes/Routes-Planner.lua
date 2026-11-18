local _, ns = ...

--[[
	Routes, every client: planning the route a few milliseconds a frame, and when to plan it again: the
	quest log or Questie's data changing, the player walking into a blob or far from where it was planned,
	a new zone, a landing, the end of a fight. Nothing plans on a flight path or in combat
]]

local routes = ns.routes
local Notify = routes.Notify

local QUEST_LOG_DELAY = 1 -- Seconds after the quest log settles before checking whether the route changed
local CHECK_INTERVAL = 2 -- Seconds between checks for Questie's quest data changing
local GROUP_SETTLE_DELAY = 5 -- Seconds after someone joins or leaves the group before Questie's data replans
local REPLAN_DISTANCE = 400 -- Yards the player moves from where the route was planned before it's planned again
local REPLAN_INTERVAL = 30 -- Seconds at least between plans for moving
local EMPTY_HOLD = 5 -- Seconds after the quest log changes that an empty plan is checked once more before it's drawn
--[[
	Planning takes a share of each frame, not a fixed time: 4 milliseconds at 60 frames a second,
	and less on a faster screen, which a fixed 4 would slow to half its frame rate while a plan runs
]]
local FRAME_SHARE = 0.25 -- Of the last frame's length
local MIN_BUDGET = 1 -- Milliseconds of planning a frame at least
local MAX_BUDGET = 4 -- And at most

--------------------------------------------------------------------------------
-- Planning, a few milliseconds a frame
--------------------------------------------------------------------------------

local planner = CreateFrame("Frame")
planner:Hide()
local job, sliceStarted, replanQueued
local budget = MAX_BUDGET -- Milliseconds this frame's slice may take
local onTaxi = false -- On a flight path: nothing is planned until the player lands

--[[
	The quest IDs in a quest log, listed first: on Questie before 12.6.3 the log is Questie's own table, which
	can change while a plan's yield waits, and a pairs walk can't take that
]]
function routes.LoggedQuestIDs(log)
	local questIDs = {}
	for questID in pairs(log) do
		questIDs[#questIDs + 1] = questID
	end
	return questIDs
end

-- Drops a plan underway and any asked for after it, so it can't put back what was just cleared or reset
function routes.CancelPlan()
	job, replanQueued = nil, nil
	planner:Hide()
end

-- Whether the player is on a flight path, as the watcher last saw
function routes.IsOnTaxi()
	return onTaxi
end

local function Yield()
	if debugprofilestop() - sliceStarted > budget then
		coroutine.yield()
	end
end

--[[
	The route as drawn: the solved order without the turn-ins planned but hidden (Plan Ahead
	off, Routes-Nodes.lua), which still shaped it, so it heads back where the quests are handed in last
]]
local function Shown(order)
	local shown = {}
	for _, node in ipairs(order) do
		if not node.hidden then
			shown[#shown + 1] = node
		end
	end
	return shown
end

--[[
	The last plan's solved order, hidden turn-ins and all (Solver.Snapshot), with the zone and instance it was
	planned in. The next plan there starts from it (Solver.Solve), so a replan after an objective or a quest
	taken costs a fraction of a fresh one and keeps the route as it was where nothing changed. A new zone, a
	landing or a reset starts fresh
]]
local lastSolve

--[[
	The last route in each zone the character planned one in, kept over a logout (routesWarmStarts), so the
	first plan on coming back starts from it as a replan does from lastSolve. Only where most of the nodes
	are the ones it had (SAVED_MATCH): played through offline, a plan started from the zone's own route with
	the same quests walked under 1% more for a third to a sixth of the time, but one started from a route
	whose quests were mostly done since walked 4% more on average, so that one starts fresh. Kept for the
	same Questie version only, as its data sets the nodes, and for MAX_SAVED_ZONES zones, the oldest dropped
]]
local SAVED_MATCH = 0.7 -- Share of this plan's nodes the saved route must have
local MAX_SAVED_ZONES = 10
local freshStart = false -- A zone reset: the next plan starts fresh, not from a saved route

local function QuestieVersion()
	return C_AddOns.GetAddOnMetadata("Questie", "Version") or "?"
end

local function SavedKey(start)
	return tostring(start.zone) .. ":" .. tostring(start.instance or 0)
end

local function SavedStart(start, nodes)
	local saved = ns.db.char.routesWarmStarts
	local entry = type(saved) == "table" and saved[SavedKey(start)]
	if
		type(entry) ~= "table"
		or entry.questie ~= QuestieVersion()
		or type(entry.keys) ~= "table"
		or type(entry.points) ~= "table"
	then
		return nil
	end
	local total, known = 0, 0
	for _, node in ipairs(nodes) do
		if node.key and node.candidates and #node.candidates > 0 then
			total = total + 1
			if entry.points[node.key] then
				known = known + 1
			end
		end
	end
	if total == 0 or known < total * SAVED_MATCH then
		return nil
	end
	return entry
end

local function SaveStart(snapshot)
	if type(ns.db.char.routesWarmStarts) ~= "table" then
		ns.db.char.routesWarmStarts = {}
	end
	local saved = ns.db.char.routesWarmStarts
	-- at counts up with each save, the newest highest, so the oldest is the one to drop
	local newest = 0
	for _, entry in pairs(saved) do
		newest = math.max(newest, type(entry) == "table" and tonumber(entry.at) or 0)
	end
	local key = SavedKey(snapshot)
	saved[key] = { questie = QuestieVersion(), keys = snapshot.keys, points = snapshot.points, at = newest + 1 }
	local count, oldestKey, oldestAt = 0, nil, math.huge
	for savedKey, entry in pairs(saved) do
		count = count + 1
		local at = type(entry) == "table" and tonumber(entry.at) or 0
		if at < oldestAt then
			oldestKey, oldestAt = savedKey, at
		end
	end
	if count > MAX_SAVED_ZONES and oldestKey then
		saved[oldestKey] = nil
	end
end

function routes.ForgetLastSolve()
	lastSolve = nil
	freshStart = true
end

local function Plan()
	local nodes, start, engaged = routes.BuildNodes(Yield)
	if not nodes then
		return nil
	end
	local previous = lastSolve and lastSolve.zone == start.zone and lastSolve.instance == start.instance and lastSolve
		or nil
	if not previous and not freshStart then
		previous = SavedStart(start, nodes)
	end
	start.flights = routes.KnownFlights(start, Yield) -- Flight paths as shortcuts (Routes-Flights.lua)
	start.skippedFlights = routes.SkippedFlights() -- Fly waypoints the player ignored, walked instead
	local solved = routes.SolveForFocus(start, nodes, Yield, previous) -- By What to Route's Route Focus (Routes-Focus.lua)
	local snapshot = ns.routesSolver.Snapshot(solved)
	snapshot.zone, snapshot.instance = start.zone, start.instance
	local order = Shown(solved)
	routes.BringTurnInsForward(order, start)
	local stops = routes.AddFlightStops(routes.MakeStops(order, start), start)
	stops = routes.AddCityExitStops(stops, start) -- Through a city's gate, not its walls (Routes-Cities.lua)
	return stops, start, nodes, engaged, routes.BuildCamps(Yield), snapshot
end

--[[
	An empty plan just after the quest log changed, while the route drawn still has a turn-in for a quest
	that's in the game's log and not ignored, is held once: the route drawn stays and it's planned again
	CHECK_INTERVAL later, which draws whatever that plan finds. Why: turning in a quest, Questie can update
	its log a moment behind the game, and a plan read from it meanwhile finds nothing to turn in, so the
	Quest Arrow would hide and come back a plan later. A turn-in handed in or ignored, a new zone or a
	route with nothing left to do here still empties it at once
]]
local questLogChangedAt = -math.huge
local heldEmpty = false

local function HasTurnInLeft(stops)
	for _, stop in ipairs(stops or {}) do
		for _, task in ipairs(stop.tasks or {}) do
			if
				task.kind == "turnIn"
				and task.questID
				and not routes.skipped[task.key]
				and routes.IsOnQuest(task.questID)
			then
				return true
			end
		end
	end
	return false
end

local function HoldEmpty(stops, start)
	local drawn = routes.start
	local hold = #stops == 0
		and not heldEmpty
		and GetTime() - questLogChangedAt <= EMPTY_HOLD
		and drawn ~= nil
		and start ~= nil
		and drawn.zone == start.zone
		and drawn.instance == start.instance
		and HasTurnInLeft(routes.stops)
	heldEmpty = hold
	if hold then
		C_Timer.After(CHECK_INTERVAL, routes.RequestPlan)
	end
	return hold
end

-- Nothing plans in combat (the watcher drops a plan underway as the fight starts); this covers the frame between
planner:SetScript("OnUpdate", function(self, elapsed)
	if InCombatLockdown() then
		return
	end
	budget = math.min(MAX_BUDGET, math.max(MIN_BUDGET, elapsed * 1000 * FRAME_SHARE))
	sliceStarted = debugprofilestop()
	local ok, stops, start, nodes, engaged, camps, snapshot = coroutine.resume(job)
	if coroutine.status(job) ~= "dead" then
		return
	end
	self:Hide()
	job = nil
	if not ok then
		geterrorhandler()(stops)
	elseif stops and not HoldEmpty(stops, start) then
		-- Together, so the watcher never compares a new plan's pins with the old plan's nodes
		routes.stops, routes.start, routes.nodes, routes.engaged = stops, start, nodes, engaged
		routes.camps = camps
		if snapshot then
			lastSolve, freshStart = snapshot, false
			SaveStart(snapshot)
		end
		Notify()
	end
	if replanQueued then
		replanQueued = nil
		routes.RequestPlan()
	end
end)

--[[
	Plans the route again, now or as soon as the plan underway is done; on a flight path, once it lands; in
	combat, once the fight ends. The route never changes mid-fight: the arrow keeps turning toward the stop it
	has, and a skip or reset asked for in combat is planned once it's over
]]
local planAfterCombat = false

function routes.RequestPlan()
	if onTaxi or not routes.IsWanted() then
		return
	end
	if InCombatLockdown() then
		planAfterCombat = true
		return
	end
	if job then
		replanQueued = true
		return
	end
	routes.signature = routes.Signature()
	job = coroutine.create(Plan)
	planner:Show()
end

--[[
	On a flight path with no markers yet, as after logging in mid-flight: each objective's markers alone,
	so the map has them in place of Questie's icons. The route is left as it is, undrawn, until the landing
	plans it from there
]]
local function PlanCamps()
	return routes.stops, routes.start, routes.nodes, routes.engaged, routes.BuildCamps(Yield)
end

local function RequestCamps()
	if job or InCombatLockdown() or not routes.IsWanted() then
		return
	end
	job = coroutine.create(PlanCamps)
	planner:Show()
end

--------------------------------------------------------------------------------
-- When to plan again
--------------------------------------------------------------------------------

local function PlayerMovedFar()
	local start = routes.start
	if not start then
		return true
	elseif start.corpse then
		return false -- A ghost's route sets out from the corpse, which stays put
	end
	local x, y, instance = routes.PlayerPosition()
	if not x then
		return false
	elseif instance ~= start.instance then
		return true
	end
	local dx, dy = x - start.x, y - start.y
	return dx * dx + dy * dy > REPLAN_DISTANCE * REPLAN_DISTANCE
end

local checkElapsed, sincePlan = 0, 0

-- A new zone or continent, or a landing: the old route may not be on it, so it's planned from here
local function OnNewArea()
	routes.CancelPlan()
	routes.start = nil
	lastSolve = nil
	checkElapsed = CHECK_INTERVAL
	sincePlan = REPLAN_INTERVAL
end

--[[
	Taking off drops any plan underway, as it would set out from where the flight began, and none starts in
	the air. Landing plans from where the player came down. Listeners hear either way (the arrow hides while
	flying)
]]
local function SetOnTaxi(now)
	if now == onTaxi then
		return
	end
	onTaxi = now
	if now then
		job, replanQueued = nil, nil
		planner:Hide()
	else
		OnNewArea()
	end
	Notify()
end

--[[
	Combat freezes the route: a plan underway is dropped, as it would set out from where the fight began,
	and nothing is checked or planned until it ends. Then it's checked at once, and planned if a plan was
	dropped or asked for meanwhile. Nothing is said in chat either way
]]
local inCombat = false
local function SetInCombat(now)
	if now == inCombat then
		return
	end
	inCombat = now
	if now then
		if job or replanQueued then
			planAfterCombat = true
		end
		job, replanQueued = nil, nil
		planner:Hide()
	else
		checkElapsed = CHECK_INTERVAL
		if planAfterCombat then
			planAfterCombat = false
			routes.RequestPlan()
		end
	end
end

--[[
	Questie's data comes in pieces, most of all a party's quest logs as someone joins, so a change to it
	plans only once it has held still for a whole check: settling is the changed signature seen at the
	last check. Someone joining or leaving holds it off GROUP_SETTLE_DELAY seconds more (groupSettleUntil),
	while their quest log arrives
]]
local settling
local groupSettleUntil, groupSize = 0, nil

--[[
	Every CHECK_INTERVAL: plans again when what's in the log has changed in a way that moves the route (a
	quest picked up, dropped or done, an objective done, Questie having placed an objective's spawns) and
	settled, when the player has walked into or out of one of the route's blobs (routes.PinEngaged), and
	every REPLAN_INTERVAL when the player has moved far from where the route was planned. Every frame,
	whether the player is on a flight path, which no event says reliably (PLAYER_CONTROL_LOST comes before
	UnitOnTaxi turns true, and for fears and stuns too), and, as that check runs anyway, whether they're in
	combat. On a flight path nothing is planned, but a check with no markers yet builds them (RequestCamps).
	It runs only while something shows the route (routes.IsWanted), from login on (UpdateWatcher)
]]
local watcher = CreateFrame("Frame")
watcher:Hide()

-- Starts or stops the check for changes as the route comes into or out of view
local function UpdateWatcher()
	local wanted = routes.IsWanted()
	if not wanted then
		onTaxi, inCombat = false, false
	end
	watcher:SetShown(wanted)
end
routes.UpdateWatcher = UpdateWatcher -- For the settings (Routes-Core.lua)
routes.OnLogin(UpdateWatcher) -- First of the login handlers, as this file loads right after Routes-Core.lua

watcher:SetScript("OnUpdate", function(_, elapsed)
	SetOnTaxi(UnitOnTaxi("player") and true or false)
	SetInCombat(InCombatLockdown() and true or false)
	if inCombat then
		return
	end
	checkElapsed, sincePlan = checkElapsed + elapsed, sincePlan + elapsed
	if checkElapsed < CHECK_INTERVAL then
		return
	end
	checkElapsed = 0
	if not (routes.IsWanted() and routes.IsQuestieReady()) then
		return
	elseif onTaxi then
		if #routes.camps == 0 then
			RequestCamps()
		end
		return
	end
	routes.NoteProgress()
	local walkedIn = routes.nodes and routes.EngagedSignature(routes.nodes) ~= routes.PinnedSignature()
	local signature = routes.Signature()
	local changed = signature ~= routes.signature
	local settled = changed and signature == settling and GetTime() >= groupSettleUntil
	settling = changed and signature or nil
	if settled or walkedIn or (sincePlan >= REPLAN_INTERVAL and PlayerMovedFar()) then
		sincePlan, settling = 0, nil
		routes.RequestPlan()
	end
end)

--[[
	Someone joined or left: their quest log takes Questie a few seconds to share. One who left takes the
	ignores that were for them (Routes-Ignore.lua)
]]
function routes:OnGroupRosterUpdate()
	local size = GetNumGroupMembers()
	if size ~= groupSize then
		groupSize = size
		groupSettleUntil = GetTime() + GROUP_SETTLE_DELAY
	end
	routes.PruneGroupIgnores()
end

-- Some time after the quest log last changed, so Questie has caught up
local questLogTimer
local function OnQuestLogUpdate()
	questLogChangedAt = GetTime()
	if questLogTimer then
		questLogTimer:Cancel()
	end
	questLogTimer = C_Timer.NewTimer(QUEST_LOG_DELAY, function()
		questLogTimer = nil
		routes.ForgetQuestTags()
		checkElapsed = CHECK_INTERVAL
	end)
end

-- Events arrive through Core's dispatcher (Core.lua's EVENTS, owner "routes")

function routes:OnQuestLogUpdate()
	OnQuestLogUpdate()
end

-- A ghost's route runs back to the corpse first
local function CheckSoon()
	checkElapsed = CHECK_INTERVAL
end
routes.OnPlayerDead = CheckSoon
routes.OnPlayerAlive = CheckSoon -- Released to a ghost, or resurrected before releasing
routes.OnPlayerUnghost = CheckSoon

routes.OnPlayerEnteringWorld = OnNewArea
routes.OnZoneChangedNewArea = OnNewArea
