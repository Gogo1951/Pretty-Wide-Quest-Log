local _, ns = ...

--[[
	Routes, every client: a route through every quest in the log, the way QuestHelper drew one. Each
	objective's spawns in Questie's database are gathered into blobs, one blob per objective is picked, and
	the blobs and turn-ins are put in the shortest order (Routes-Solver.lua). The route is drawn on the
	world map (Routes-Map.lua) and an arrow points at its first stop (Routes-Arrow.lua).

	Everything Routes needs lives in Features/Routes, listed by one line in each TOC (Routes.xml), so it
	can be left out of a release with that line. Its events come through Core's EVENTS table, its strings
	from Locales, and its settings live on the profile (ns.db.profile.routes), the arrow's spot in
	ns.db.global.routesArrowPoint
]]

local routes = {}
ns.routes = routes

local L = ns.L

local QUEST_LOG_DELAY = 1 -- Seconds after the quest log settles before checking whether the route changed
local CHECK_INTERVAL = 2 -- Seconds between checks for Questie's quest data changing
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

-- A line in chat the way the rest of the add-on writes them: its name, a separator, the message
function routes.Print(message)
	ns:PrintMessage(message)
end

--[[
	A tooltip's click hints, two columns in the add-on's blue, a blank line between each and between them
	and anything above: each { action, what it does }, such as { "Right-Click", "Reroute Current Objective" }
]]
local restoreHeaderHooked = {}

--[[
	A tooltip's first line is drawn in the larger header font. Where a hint is that first line (the arrow's
	tooltip has no title), it's set to the body font like the others, and put back once the tooltip clears
]]
local function UseBodyFontOnFirstLine(tooltip, red, green, blue)
	local name = tooltip:GetName()
	local left, right = name and _G[name .. "TextLeft1"], name and _G[name .. "TextRight1"]
	if not (left and right and GameTooltipText) then
		return
	end
	left:SetFontObject(GameTooltipText)
	right:SetFontObject(GameTooltipText)
	-- Setting a font object takes its color too, so the hint's blue goes back on after
	left:SetTextColor(red, green, blue)
	right:SetTextColor(red, green, blue)
	if not restoreHeaderHooked[tooltip] then
		restoreHeaderHooked[tooltip] = true
		tooltip:HookScript("OnTooltipCleared", function()
			left:SetFontObject(GameTooltipHeaderText)
			right:SetFontObject(GameTooltipHeaderText)
		end)
	end
end

function routes.AddClickHints(tooltip, hints)
	local red, green, blue = ns.GetColorRGB("INFO")
	local first = tooltip:NumLines() == 0
	if not first then
		tooltip:AddLine(" ")
	end
	for index, hint in ipairs(hints) do
		if index > 1 then
			tooltip:AddLine(" ") -- A blank line between hints, as the options panels space their rows
		end
		tooltip:AddDoubleLine(hint[1], hint[2], red, green, blue, red, green, blue)
	end
	if first then
		UseBodyFontOnFirstLine(tooltip, red, green, blue)
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

--------------------------------------------------------------------------------
-- The route
--------------------------------------------------------------------------------

--[[
	routes.stops is the route as drawn: each stop { x, y, instance, radius, tasks }, x and y in world
	yards, radius how far its blob reaches, tasks the objectives and turn-ins done there. routes.start is
	where the player stood when it was planned. Listeners run whenever it changes
]]
routes.stops = {}
routes.skipped = {}
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

-- Whether anything shows the route: the whole route on, and the zone map's route or the Quest Arrow with it
function routes.IsWanted()
	local settings = routes.Settings()
	return settings.enabled and (settings.showMap or settings.showArrow) and true or false
end

-- A switch that brings the route back into view plans it, rather than waiting for the next change
local function PlanIfShownAgain(key)
	if (key == "showMap" or key == "showArrow") and routes.Settings()[key] and #routes.stops == 0 then
		routes.RequestPlan()
	end
end

-- Changes a setting and redraws what shows it, as the Options Interface's switches do
function routes.SetSetting(key, value)
	routes.Settings()[key] = value
	Notify()
	PlanIfShownAgain(key)
end

function routes.Clear()
	routes.stops = {}
	routes.signature = nil
	Notify()
end

-- After a profile reset, switch or copy (ns:ApplyProfile): redraws with the new settings and plans or clears
function routes.ApplySettings()
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
	return routes.MakeStops(order, start), start, nodes, engaged
end

-- A plan waits out combat, picking up where it left off once the fight ends
planner:SetScript("OnUpdate", function(self)
	if InCombatLockdown() then
		return
	end
	sliceStarted = debugprofilestop()
	local ok, stops, start, nodes, engaged = coroutine.resume(job)
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
		Notify()
	end
	if replanQueued then
		replanQueued = nil
		routes.RequestPlan()
	end
end)

-- Plans the route again, now or as soon as the plan underway is done
function routes.RequestPlan()
	if not routes.IsWanted() then
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

--[[
	Every CHECK_INTERVAL: plans again when what's in the log has changed in a way that moves the route (a
	quest picked up, dropped or done, an objective done, Questie having placed an objective's spawns), when
	the player has walked into or out of one of the route's blobs (routes.PinEngaged), and every
	REPLAN_INTERVAL when the player has moved far from where the route was planned
]]
local checkElapsed, sincePlan = 0, 0
local watcher = CreateFrame("Frame")
watcher:SetScript("OnUpdate", function(_, elapsed)
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
	if routes.Signature() ~= routes.signature or walkedIn or (sincePlan >= REPLAN_INTERVAL and PlayerMovedFar()) then
		sincePlan = 0
		routes.RequestPlan()
	end
end)

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
	MigrateSettings()
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

-- A new zone or continent: the old route may not be on it
local function OnNewArea()
	routes.start = nil
	checkElapsed = CHECK_INTERVAL
	sincePlan = REPLAN_INTERVAL
end
routes.OnPlayerEnteringWorld = OnNewArea
routes.OnZoneChangedNewArea = OnNewArea

--------------------------------------------------------------------------------
-- Skipping
--------------------------------------------------------------------------------

-- Leaves the stop's tasks out of the route until Reset All Routes (a middle-click on the Quest Arrow)
function routes.SkipStop(stop)
	if not stop then
		return
	end
	local names, seen = {}, {}
	for _, task in ipairs(stop.tasks) do
		if task.kind ~= "corpse" then
			routes.skipped[task.key] = true
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

--[[
	Back to the route as it plans from scratch: every skipped stop back on it, and no camp held first for
	having been in it, so only one the player stands in now goes first again
]]
function routes.ResetObjectives()
	routes.skipped = {}
	routes.engaged = nil
	routes.Print(L["ROUTES_RESET"])
	routes.RequestPlan()
end
