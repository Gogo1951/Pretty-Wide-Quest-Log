local _, ns = ...

--[[
	Routes, every client: a route through every quest in the log, the way QuestHelper drew one. Each
	objective's spawns in Questie's database are gathered into blobs, one blob per objective is picked, and
	the blobs and turn-ins are put in the shortest order (Routes-Solver.lua), a few milliseconds a frame
	(Routes-Planner.lua). The route is drawn on the world map (Routes-Map.lua), and an arrow points at the
	first stop with tasks left outside the area the player is in (Routes-Arrow.lua).

	Routes' own files live in Features/Routes, listed by one line in each TOC (Routes.xml), so it can be left
	out of a release with that line. It reads the add-on's shared pieces from outside that folder, from
	Utilities, Quest-Display, Quest-Objectives, Quest-Log-API, Announcements and Data. Its events come
	through Core's EVENTS table, its strings from Locales, and its settings live on the profile
	(ns.db.profile.routes), the arrow's spot in ns.db.global.routesArrowPoint
]]

local routes = {}
ns.routes = routes

--[[
	Being in an objective's area means being among its mobs or objects, not on the way to them. Questie's
	spawns in a camp lie about 22 yards apart (the middle of every hostile camp in Tirisfal Glades), 40 for
	nine in ten, and up to 75 for the most spread out, as darkhounds and duskbats are. 60 yards from the
	nearest spawn covers the gaps of almost every camp, and the eye shows a few seconds' run from the edge
	of it, never from across the zone. Once in, AREA_GRACE more, so its edge doesn't flicker in and out
]]
routes.AREA_REACH = 60 -- Yards from an objective's nearest spawn that count as being in its area
routes.AREA_GRACE = 30 -- Yards past an objective area's edge the player can stray and still be in it

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

--[[
	MIGRATION (remove after 2026-12-11): Show Future Turn-Ins (showUpcomingTurnIns) is part of Predictive
	Questing Routes (predictiveRoutes) now, so it's dropped from the profile, and
	planQuestChains, from test builds
]]
local function DropPredictiveSettings()
	local settings = ns.db.profile.routes
	settings.showUpcomingTurnIns = nil
	settings.planQuestChains = nil
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
local hereBeDragons
function routes.HereBeDragons()
	hereBeDragons = hereBeDragons or ns.QuestieHereBeDragons()
	return hereBeDragons
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
	Task keys left off the route, each { label, questID, order, zone }: what the Quest Arrow's menu lists it
	as, its quest, when it was ignored, so the list keeps that order, and the zone whose reset clears it
	(Routes-Ignore.lua). The player's own are saved for the character (char.routesIgnored), so they last
	through a logout and a group change; a party member's go once everyone who had its quest leaves the group
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
routes.Notify = Notify -- For the planner (Routes-Planner.lua)

-- Puts the Quest Arrow back where it starts, near the top middle of the screen
function routes.ResetArrowPosition()
	routes.SetArrowPoint(nil)
	if routes.ResetArrow then
		routes.ResetArrow()
	end
end

--[[
	Whether anything shows the route: the Waypoint Markers on the zone map or the Quest Arrow. The Quest
	Route (showLine) is drawn only between the markers, so it never needs a plan of its own
]]
function routes.IsWanted()
	local settings = routes.Settings()
	return (settings.showMap or settings.showArrow) and true or false
end

-- Whether the map shows the route at all: the Waypoint Markers, the camps, and the Quest Route between them
function routes.IsMapShown()
	local settings = routes.Settings()
	return settings.showMap
end

-- Whether a map is a continent's, the world's or the cosmos', not a zone's or one inside a zone
function routes.IsWideMap(mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	return info ~= nil and info.mapType ~= nil and info.mapType <= Enum.UIMapType.Continent
end

--[[
	Whether a world map shows the markers: any zone's while the Waypoint Markers are on, a continent's or the
	world's only with Show Markers on Continent and World Maps too. Where it doesn't, Questie's icons and
	Blizzard's quest markers stay, as nothing stands in for them
]]
function routes.IsMapShownOn(mapID)
	if not routes.IsMapShown() then
		return false
	end
	return routes.Settings().showWideMapMarkers or not routes.IsWideMap(mapID)
end

-- A switch that brings the route back into view plans it, rather than waiting for the next change
local function PlanIfShownAgain(key)
	if (key == "showMap" or key == "showArrow") and routes.Settings()[key] and #routes.stops == 0 then
		routes.RequestPlan()
	end
end

--[[
	Changes a setting and redraws what shows it, as the Options Interface's switches do; a route nothing
	shows any more is cleared
]]
function routes.SetSetting(key, value)
	routes.Settings()[key] = value
	routes.UpdateWatcher()
	if routes.IsWanted() then
		Notify()
		PlanIfShownAgain(key)
	else
		routes.Clear()
	end
end

function routes.Clear()
	routes.CancelPlan()
	routes.stops = {}
	routes.camps = {}
	routes.signature = nil
	Notify()
end

-- After a profile reset, switch or copy (ns:ApplyProfile): redraws with the new settings and plans or clears
function routes.ApplySettings()
	routes.UpdateWatcher()
	if routes.IsWanted() then
		Notify()
		routes.RequestPlan()
	else
		routes.Clear()
	end
end

-- Events arrive through Core's dispatcher (Core.lua's EVENTS, owner "routes"); the planner's are in Routes-Planner.lua

function routes:OnPlayerLogin()
	MigrateSettings() -- MIGRATION (remove after 2026-12-06)
	DropRetiredSettings() -- MIGRATION (remove after 2026-12-07)
	DropPredictiveSettings() -- MIGRATION (remove after 2026-12-11)
	for _, handler in ipairs(routes.loginHandlers) do
		handler()
	end
end
