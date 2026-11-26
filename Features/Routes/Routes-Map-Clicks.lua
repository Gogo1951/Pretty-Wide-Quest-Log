local _, ns = ...

--[[
	Routes: what hovering and clicking a waypoint's or camp's marker on the world map does: its menu, a
	right-click's ignore or put back, and a middle-click's Reset This Zone (Routes-Map.lua draws the markers)
]]

local routes = ns.routes
local L = ns.L

local RestyleMarkers = routes.RestyleMarkers -- Routes-Map.lua
local IsInMapZone = routes.IsInMapZone -- Routes-Map.lua
local ApplyQuestieIcons = routes.ApplyQuestieIcons

--[[
	A click on a marker that changes the route: done now, its chat line said and every marker's look
	(RestyleMarkers), but planned only once the clicks have stopped for a few seconds
	(routes.HoldPlanForMapClick), so the next marker is clicked with no plan or redraw in between. The markers
	stay where they are till then
]]
local function MapClick(action)
	return function()
		routes.HoldPlanForMapClick()
		action()
		RestyleMarkers()
	end
end
local ResetZone = MapClick(function()
	routes.ResetZone()
end)

--[[
	A waypoint right-clicked while the map is open, its route not planned again yet: the keys it ignored, as
	routes.SkipStop ignores them (a quest not taken yet by its pick-up), once every one of them is ignored.
	Nothing while any is still on the route, or for the corpse
]]
local function WaypointIgnoredKeys(stop)
	local keys, seen = {}, {}
	for _, task in ipairs(stop.tasks) do
		if task.kind ~= "corpse" then
			local key = (task.pickUpNode or task).key
			if not (key and routes.skipped[key]) then
				return nil
			end
			if not seen[key] then
				seen[key] = true
				keys[#keys + 1] = key
			end
		end
	end
	return #keys > 0 and keys or nil
end

--[[
	The zone a right-click on a camp's marker is for: none (the player's) while the route has the task or a
	camp of it stands in the player's zone, as the route may take it there; else the zone the marker stands
	in (routes.ZoneAt), so the change waits till the player gets there (routes.IsChangeHere)
]]
local function ClickZone(stop, task)
	local here = routes.PlayerZone()
	for _, routeStop in ipairs(routes.stops) do
		for _, routeTask in ipairs(routeStop.tasks) do
			if routeTask.key == task.key then
				return nil
			end
		end
	end
	for _, camp in ipairs(routes.camps) do
		if here and camp.tasks[1] and camp.tasks[1].key == task.key and IsInMapZone(camp, here) then
			return nil
		end
	end
	return routes.ZoneAt(stop.x, stop.y, stop.instance)
end

--[[
	What right-clicking a marker does, and its hint: a waypoint is ignored (routes.SkipStop), or put back on
	the route once it is (gray, its route not planned again yet); a camp's
	objective is ignored, or put back on the route once it is; a map-only pick-up (a dungeon quest's, an
	escort's, one leading to another zone) is put on the route (routes.AddPickUp), and one in a zone the route
	isn't planned in taken back off it once it is (routes.RemovePickUp). Nothing for the corpse,
	or for a dungeon or raid quest's objective, which the route never takes anyway
]]
local function RightClick(stop)
	if stop.corpse then
		return nil
	end
	if not stop.camp then
		local ignored = WaypointIgnoredKeys(stop)
		if ignored then
			return L["ROUTES_RIGHT_CLICK_UNIGNORE"],
				MapClick(function()
					for _, key in ipairs(ignored) do
						routes.UnignoreTask(key)
					end
				end)
		end
		return L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"], MapClick(function()
			routes.SkipStop(stop)
		end)
	end
	local task = stop.tasks[1]
	-- A quest to pick up on the route's zone the route can't plan (routes.ZonePickUps): a marker alone
	if task.untracked or task.unplanned then
		return nil
	end
	--[[
		A quest to pick up on a zone's map the route isn't planned in (routes.ZonePickUps): put on the route for
		when the player gets there, or taken back off it. Its look changes at once, the task being every camp's
	]]
	if task.elsewhere then
		if routes.added[task.key] then
			return L["ROUTES_TAKE_OFF_ROUTE"],
				MapClick(function()
					routes.RemovePickUp(task)
					task.offRoute = "zone"
				end)
		end
		return L["ROUTES_ADD_TO_ROUTE"], MapClick(function()
			routes.AddPickUp(task)
			task.offRoute = nil
		end)
	end
	if task.kind == "pickUp" and task.offRoute then
		return L["ROUTES_ADD_TO_ROUTE"], MapClick(function()
			routes.AddPickUp(task)
		end)
	end
	if routes.skipped[task.key] then
		return L["ROUTES_RIGHT_CLICK_UNIGNORE"], MapClick(function()
			routes.UnignoreTask(task.key)
		end)
	end
	return L["ROUTES_RIGHT_CLICK_IGNORE"], MapClick(function()
		routes.IgnoreTask(task, ClickZone(stop, task))
	end)
end

--[[
	A stop's menu (Routes-Map-Menu.lua): its first quest's title as the header with PWQL on the right, its
	quests, each player's progress laid out as the quest log's, Look
	For, then its clicks as rows, Ignore and Reset This Zone, each clicked or done with its click on the
	marker. Nothing once the pin shows another stop, which closes it
]]
local function StopMenuEntries(pin, stop)
	if pin.stop ~= stop then
		return nil
	end
	local rows = routes.MapMenuRows()
	routes.AddStopTooltip(rows, stop)
	rows:MakeHeader()
	if stop.names and #stop.names > 0 then
		-- A heading, then a name per row a space in, so a long list grows down instead of wide
		rows:AddSection(L["ROUTES_LOOK_FOR"])
		for _, name in ipairs(stop.names) do
			rows:AddLine(" " .. name, ns.GetColorRGB("TEXT"))
		end
	end
	local hints = {}
	local rightClick, action = RightClick(stop)
	if rightClick then
		hints[#hints + 1] = { L["ROUTES_CLICK_RIGHT"], rightClick, action }
	end
	hints[#hints + 1] = { L["ROUTES_CLICK_MIDDLE"], L["ROUTES_MIDDLE_CLICK_RESET_ZONE"], ResetZone }
	rows:AddHints(hints)
	return rows.entries
end

-- Questie's icons for the hovered stop's objectives come back while its menu is open, and go with it
local function OnStopMenuClose()
	if routes.hoveredStop then
		routes.hoveredStop = nil
		ApplyQuestieIcons()
	end
end

--------------------------------------------------------------------------------
-- The Markers' Scripts
--------------------------------------------------------------------------------

-- Opens the stop's menu and shows Questie's icons for its objectives
function routes.OnStopEnter(pin)
	local stop = pin.stop
	local opened = routes.OpenMapMenu(pin, stop, function()
		return StopMenuEntries(pin, stop)
	end, OnStopMenuClose)
	if opened then
		routes.hoveredStop = stop
		ApplyQuestieIcons()
	end
end

function routes.OnStopMouseUp(pin, button)
	if button == "RightButton" then
		local _, action = RightClick(pin.stop)
		if action then
			routes.CloseMapMenu()
			action()
		end
	elseif button == "MiddleButton" then
		routes.CloseMapMenu()
		ResetZone()
	end
end
