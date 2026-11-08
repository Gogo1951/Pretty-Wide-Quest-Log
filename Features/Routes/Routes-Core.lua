local _, ns = ...

--[[
	Routes, every client: a route through every quest in the log, the way QuestHelper drew one. Each
	objective's spawns in Questie's database are gathered into blobs, one blob per objective is picked, and
	the blobs and turn-ins are put in the shortest order (Routes-Solver.lua). The route is drawn on the
	world map (Routes-Map.lua), and an arrow points at the first stop with tasks left outside the area the
	player is in (Routes-Arrow.lua).

	Routes' own files live in Features/Routes, listed by one line in each TOC (Routes.xml), so it can be left
	out of a release with that line. It reads the add-on's shared pieces from outside that folder, from
	Utilities, Quest-Display, Quest-Objectives, Quest-Log-API, Announcements and Data. Its events come
	through Core's EVENTS table, its strings from Locales, and its settings live on the profile
	(ns.db.profile.routes), the arrow's spot in ns.db.global.routesArrowPoint
]]

local routes = {}
ns.routes = routes

local QUEST_LOG_DELAY = 1 -- Seconds after the quest log settles before checking whether the route changed
local CHECK_INTERVAL = 2 -- Seconds between checks for Questie's quest data changing
local GROUP_SETTLE_DELAY = 5 -- Seconds after someone joins or leaves the group before Questie's data replans
routes.AREA_REACH = 200 -- Yards from an objective's nearest spawn that count as being in its area
routes.AREA_GRACE = 20 -- Yards past an objective area's edge the player can stray and still be in it
local REPLAN_DISTANCE = 400 -- Yards the player moves from where the route was planned before it's planned again
local REPLAN_INTERVAL = 30 -- Seconds at least between plans for moving
local FRAME_BUDGET = 4 -- Milliseconds of planning a frame

--------------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------------

-- On the profile, so Reset Profile restores them; the defaults until the saved settings load
function routes.Settings()
	if not ns.db then
		return ns.DATABASE_DEFAULTS.profile.routes
	end
	return ns.db.profile.routes
end

-- Where the Quest Arrow was dragged to, kept for the whole account so no profile change moves it
function routes.ArrowPoint()
	return ns.db and ns.db.global.routesArrowPoint
end

function routes.SetArrowPoint(point)
	ns.db.global.routesArrowPoint = point
end

--[[
	MIGRATION (remove after 2026-12-06): Routes settings move from ns.db.global.routes to the profile, and
	the arrow's spot to ns.db.global.routesArrowPoint. Keys Routes no longer has (planTurnIns) are dropped
]]
local function MigrateSettings()
	local old = ns.db.global.routes
	if type(old) ~= "table" then
		return
	end
	local settings, defaults = ns.db.profile.routes, ns.DATABASE_DEFAULTS.profile.routes
	for key, value in pairs(old) do
		if key == "arrowPoint" then
			if ns.db.global.routesArrowPoint == nil then
				ns.db.global.routesArrowPoint = value
			end
		elseif defaults[key] ~= nil then
			settings[key] = value
		end
	end
	ns.db.global.routes = nil
end

--[[
	MIGRATION (remove after 2026-12-07): settings Routes no longer has are dropped from the profile: the
	Quest Arrow's cycleSeconds, and enabled, which no control could change
]]
local function DropRetiredSettings()
	local settings = ns.db.profile.routes
	settings.cycleSeconds = nil
	settings.enabled = nil
end

-- A line in chat the way the rest of the add-on writes them: its name, a separator, the message
function routes.Print(message)
	ns:PrintMessage(message)
end

--[[
	A tooltip's click hints, two columns in the add-on's blue, a blank line between each and between them
	and anything above: each { action, what it does }, such as { "Right-Click", "Ignore This Waypoint" }
]]
function routes.AddClickHints(tooltip, hints)
	local red, green, blue = ns.GetColorRGB("INFO")
	if tooltip:NumLines() > 0 then
		tooltip:AddLine(" ")
	end
	for index, hint in ipairs(hints) do
		if index > 1 then
			tooltip:AddLine(" ") -- A blank line between hints, as the options panels space their rows
		end
		tooltip:AddDoubleLine(hint[1], hint[2], red, green, blue, red, green, blue)
	end
end

--[[
	A quest as printed in chat: Questie's quest link, clickable for its tooltip, then the message's own
	white again; or its name, where Questie can't make one
]]
function routes.QuestLink(questID, name)
	local QuestieLink = ns.ImportQuestieModule("QuestieLink")
	if questID and QuestieLink and type(QuestieLink.GetQuestHyperLink) == "function" then
		local ok, link = pcall(QuestieLink.GetQuestHyperLink, QuestieLink, questID)
		if ok and type(link) == "string" and link ~= "" then
			return link .. ns.GetColor("TEXT")
		end
	end
	return name or tostring(questID or "")
end

-- Questie's copy of HereBeDragons, for world positions and distances in yards; nil until Questie has loaded it
local HBD
function routes.HereBeDragons()
	HBD = HBD or LibStub("HereBeDragonsQuestie-2.0", true)
	return HBD
end

-- How many entries a table holds, its keys as well as its list: an objective's spawn list, for the blob caches
function routes.CountEntries(list)
	local count = 0
	for _ in pairs(list) do
		count = count + 1
	end
	return count
end

--[[
	The name an entry of an objective's spawn list lends its blob: none for an event's, whose spawns are a
	place, such as where an escort ends, and whose name is only the objective's text again
]]
function routes.SpawnName(objective, spawnData)
	local event = objective.Type == "event"
		or (Questie and spawnData.Icon ~= nil and spawnData.Icon == Questie.ICON_TYPE_EVENT)
	return not event and spawnData.Name or nil
end

--------------------------------------------------------------------------------
-- The route
--------------------------------------------------------------------------------

--[[
	routes.stops is the route as drawn: each stop { x, y, instance, radius, tasks }, x and y in world
	yards, radius how far its blob reaches, tasks the objectives and turn-ins done there. routes.start is
	where the player stood when it was planned. Listeners run whenever it changes
]]
routes.stops = {}
-- Every place each objective can be done, in every zone, shaped as stops, for the map (Routes-Camps.lua)
routes.camps = {}
--[[
	Task keys ignored until the ignore list is cleared, each { label, questID, order }: what the Quest Arrow's
	menu lists it as, its quest, and when it was ignored, so the list keeps that order. Never saved, so a
	logout clears it, and joining or leaving a group does too (ClearForGroup), with ignoredMembers
]]
routes.skipped = {}
routes.ignoredMembers = {} -- Party members whose quests are left out, by name as routes.UnitFullName gives it
routes.loginHandlers = {} -- Run at PLAYER_LOGIN, once the saved settings exist
local listeners = {}

function routes.AddListener(listener)
	listeners[#listeners + 1] = listener
end

function routes.OnLogin(handler)
	routes.loginHandlers[#routes.loginHandlers + 1] = handler
end

local function Notify()
	for _, listener in ipairs(listeners) do
		local ok, problem = pcall(listener)
		if not ok then
			geterrorhandler()(problem)
		end
	end
end

-- Puts the Quest Arrow back where it starts, near the top middle of the screen
function routes.ResetArrowPosition()
	routes.SetArrowPoint(nil)
	if routes.ResetArrow then
		routes.ResetArrow()
	end
end

-- Whether anything shows the route: the zone map's route or the Quest Arrow
function routes.IsWanted()
	local settings = routes.Settings()
	return (settings.showMap or settings.showArrow) and true or false
end

-- Whether the map shows the route and the camps at all
function routes.IsMapShown()
	local settings = routes.Settings()
	return settings.showMap
end

-- A switch that brings the route back into view plans it, rather than waiting for the next change
local function PlanIfShownAgain(key)
	if (key == "showMap" or key == "showArrow") and routes.Settings()[key] and #routes.stops == 0 then
		routes.RequestPlan()
	end
end

-- Starts or stops the check for changes as the route comes into or out of view, once it's defined below
local UpdateWatcher

--[[
	Changes a setting and redraws what shows it, as the Options Interface's switches do; a route nothing
	shows any more is cleared
]]
function routes.SetSetting(key, value)
	routes.Settings()[key] = value
	UpdateWatcher()
	if routes.IsWanted() then
		Notify()
		PlanIfShownAgain(key)
	else
		routes.Clear()
	end
end

function routes.Clear()
	routes.stops = {}
	routes.camps = {}
	routes.signature = nil
	Notify()
end

-- After a profile reset, switch or copy (ns:ApplyProfile): redraws with the new settings and plans or clears
function routes.ApplySettings()
	UpdateWatcher()
	if routes.IsWanted() then
		Notify()
		routes.RequestPlan()
	else
		routes.Clear()
	end
end

--------------------------------------------------------------------------------
-- Planning, a few milliseconds a frame
--------------------------------------------------------------------------------

local planner = CreateFrame("Frame")
planner:Hide()
local job, sliceStarted, replanQueued
local onTaxi = false -- On a flight path: nothing is planned until the player lands

-- Whether the player is on a flight path, as the watcher last saw
function routes.IsOnTaxi()
	return onTaxi
end

local function Yield()
	if debugprofilestop() - sliceStarted > FRAME_BUDGET then
		coroutine.yield()
	end
end

local function Plan()
	local nodes, start, engaged = routes.BuildNodes(Yield)
	if not nodes then
		return nil
	end
	local order = ns.routesSolver.Solve(start, nodes, Yield)
	local stops = routes.MakeStops(order, start)
	return stops, start, nodes, engaged, routes.BuildCamps(Yield)
end

-- Nothing plans in combat (the watcher drops a plan underway as the fight starts); this covers the frame between
planner:SetScript("OnUpdate", function(self)
	if InCombatLockdown() then
		return
	end
	sliceStarted = debugprofilestop()
	local ok, stops, start, nodes, engaged, camps = coroutine.resume(job)
	if coroutine.status(job) ~= "dead" then
		return
	end
	self:Hide()
	job = nil
	if not ok then
		geterrorhandler()(stops)
	elseif stops then
		-- Together, so the watcher never compares a new plan's pins with the old plan's nodes
		routes.stops, routes.start, routes.nodes, routes.engaged = stops, start, nodes, engaged
		routes.camps = camps
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
	routes.start = nil
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
	combat. It runs only while something shows the route (routes.IsWanted), from login on (UpdateWatcher)
]]
local watcher = CreateFrame("Frame")
watcher:Hide()

UpdateWatcher = function()
	local wanted = routes.IsWanted()
	if not wanted then
		onTaxi, inCombat = false, false
	end
	watcher:SetShown(wanted)
end

watcher:SetScript("OnUpdate", function(_, elapsed)
	SetOnTaxi(UnitOnTaxi("player") and true or false)
	SetInCombat(InCombatLockdown() and true or false)
	if onTaxi or inCombat then
		return
	end
	checkElapsed, sincePlan = checkElapsed + elapsed, sincePlan + elapsed
	if checkElapsed < CHECK_INTERVAL then
		return
	end
	checkElapsed = 0
	if not (routes.IsWanted() and routes.IsQuestieReady()) then
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

-- Someone joined or left: their quest log takes Questie a few seconds to share
function routes:OnGroupRosterUpdate()
	local size = GetNumGroupMembers()
	if size ~= groupSize then
		groupSize = size
		groupSettleUntil = GetTime() + GROUP_SETTLE_DELAY
	end
end

-- Some time after the quest log last changed, so Questie has caught up
local questLogTimer
local function OnQuestLogUpdate()
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

function routes:OnPlayerLogin()
	MigrateSettings() -- MIGRATION (remove after 2026-12-06)
	DropRetiredSettings() -- MIGRATION (remove after 2026-12-07)
	UpdateWatcher()
	for _, handler in ipairs(routes.loginHandlers) do
		handler()
	end
end

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
