local _, ns = ...

--[[
	Routes: the route on the world map, as sketched in Questie issues #2498 and #2500. A
	line of small dark gray dots, a little see-through so it doesn't clutter the map, marches from the player
	through every stop. Each stop is one simple marker, a disc in its objective's Questie color with
	Questie's icon for the objective on it, in place of Questie's icon on every spawn, which are hidden
	for the objectives on the route. Hovering a marker brings back Questie's icons for its objectives,
	every place they can be done, and lists its quests. Drawn through a data provider, as Questie and HandyNotes draw theirs, on
	whatever map the world map shows, zone or continent
]]

local routes = ns.routes
local L = ns.L

-- The owner of this file's event handlers in Core.lua's EVENTS
local routesMap = {}
ns.routesMap = routesMap

local LINE_TEMPLATE = "PrettyWideQuestLogRouteLinePinTemplate"
local STOP_TEMPLATE = "PrettyWideQuestLogRouteStopPinTemplate"
--[[
	A marker and Questie's icon on it at Medium, as Routes.xml draws them. The disc's ring takes the outer
	eighth of it on each side, so its middle is three quarters across, room for the icon, corners and all
]]
local STOP_SIZE, STOP_ICON_SIZE = 32, 16
local LINE_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_LINE" -- Under Questie's icons
local STOP_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_STOP" -- Over them
local CAMP_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_CAMP" -- Over Questie's icons too, under the stops
local CAMP_ALPHA = 0.5 -- A camp in the route's zone the route doesn't go to, behind the waypoints
local GATHER_REACH = 800 -- Yards around an objective's busiest camp whose other camps its one marker gathers
local WIDE_MAP_SCALE = 0.6 -- Markers on a continent's or the world's map at Medium, which hold many zones' worth
local QUESTIE_LEVEL = "PIN_FRAME_LEVEL_AREA_POI" -- Where HereBeDragons-Pins puts Questie's icons

--[[
	The mixin of the route's pin templates in Routes.xml, which load after this file. The map canvas lets right
	clicks pass through every pin it makes, with SetPassThroughButtons, which WoW blocks in combat: opening the
	map in combat then blames this addon. The stop pins take their own right clicks (skipping the stop) and the
	line takes no mouse, so neither wants it, as HereBeDragons-Pins does for Questie's pins
]]
PrettyWideQuestLogRoutePinMixin = CreateFromMixins(MapCanvasPinMixin)
function PrettyWideQuestLogRoutePinMixin.SetPassThroughButtons() end

--[[
	Where the route's pins sit among the world map's layers, by the level Blizzard gave Questie's layer: the line
	just under Questie's icons, camps just over them and the waypoints over the camps. Each pin works out its own
	level rather than the route adding layers to the map's list: adding one moves Blizzard's layers above or below
	it, which rewrites their levels from add-on code for the rest of the session. Every Blizzard pin reads those
	levels as it's placed, so each was then set up tainted, and a click or hover on one of Blizzard's quest
	markers marked the objective tracker dirty as add-on code, an error in combat (GitHub #23). On WoW Forever's
	map the levels either side of Questie's belong to layers it never draws (dragonriding races, gossip, debug)
]]
local LEVEL_OFFSETS = { [LINE_LEVEL] = -1, [CAMP_LEVEL] = 1, [STOP_LEVEL] = 2 }
local ABOVE_EVERY_LAYER = 2 -- On a map without Questie's layer, the line, camps and waypoints go over every layer

function PrettyWideQuestLogRoutePinMixin:ApplyFrameLevel()
	local levels = self:GetMap():GetPinFrameLevelsManager()
	local base
	if levels.definitions and levels.definitions[QUESTIE_LEVEL] then
		base = levels:GetValidFrameLevel(QUESTIE_LEVEL)
	else
		base = levels:GetValidFrameLevel("PIN_FRAME_LEVEL_TOPMOST") + ABOVE_EVERY_LAYER
	end
	self:SetFrameLevel(base + (LEVEL_OFFSETS[self.pinFrameLevelType] or 0))
end

local KeepFullSize = routes.KeepFullSize
local linePinMixin = routes.RouteLinePinMixin
local OnLinePinUpdate = routes.OnRouteLinePinUpdate
local ApplyQuestieIcons = routes.ApplyQuestieIcons
local RequestApplyQuestieIcons = routes.RequestApplyQuestieIcons
local QuestieTextures = routes.QuestieTextures
local ApplyBlizzardQuests = routes.ApplyBlizzardQuests
local HookBlizzardQuests = routes.HookBlizzardQuests

local hereBeDragonsPins

-- Questie's copies of HereBeDragons and its map pins
local function Libraries()
	hereBeDragonsPins = hereBeDragonsPins or LibStub("HereBeDragonsQuestie-Pins-2.0", true)
	return routes.HereBeDragons(), hereBeDragonsPins
end

-- Where a point in world yards falls on a map (0-1, or past it), or nothing on another continent
local function MapPosition(mapID, x, y, instance)
	local hereBeDragons = Libraries()
	if not (hereBeDragons and x) then
		return nil
	end
	local mapX, mapY = hereBeDragons:GetZoneCoordinatesFromWorldInstance(x, y, instance, mapID, true)
	if mapX and mapY then
		return { x = mapX, y = mapY }
	end
end

local function IsOnMap(position)
	return position and position.x >= 0 and position.x <= 1 and position.y >= 0 and position.y <= 1
end

-- The Group Up marker (Routes-Map-Meet.lua) is placed, sized and layered as a waypoint's marker
routes.MapPosition, routes.IsOnMap = MapPosition, IsOnMap
routes.STOP_SIZE, routes.STOP_ICON_SIZE, routes.STOP_LEVEL = STOP_SIZE, STOP_ICON_SIZE, STOP_LEVEL
routes.WIDE_MAP_SCALE = WIDE_MAP_SCALE

local IsWideMap = routes.IsWideMap
local IsUntracked = routes.IsUntrackedStop

--[[
	Whether a map shows the route: the zone it was planned in, or a cave, building or city inside it. Any
	other map, the continent's included, shows the camps alone
]]
local function IsRouteMap(mapID)
	local first = routes.stops[1]
	return first ~= nil and first.mapID ~= nil and mapID ~= nil and routes.IsInZone(mapID, first.mapID)
end

--------------------------------------------------------------------------------
-- The stops
--------------------------------------------------------------------------------

local provider

--[[
	What right-clicking a marker does, and its hint: a waypoint is ignored (routes.SkipStop); a camp's
	objective is ignored, or put back on the route once it is. Nothing for the corpse, or for a dungeon or
	raid quest's objective, which the route never takes anyway
]]
local function RightClick(stop)
	if stop.corpse then
		return nil
	end
	if not stop.camp then
		return L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"], function()
			routes.SkipStop(stop)
		end
	end
	local task = stop.tasks[1]
	if task.untracked then
		return nil
	end
	if routes.skipped[task.key] then
		return L["ROUTES_RIGHT_CLICK_UNIGNORE"], function()
			routes.UnignoreTask(task.key)
		end
	end
	return L["ROUTES_RIGHT_CLICK_IGNORE"], function()
		routes.IgnoreTask(task)
	end
end

-- Shows Questie's icons for the stop's objectives and lists its quests, each player's progress laid out as the quest log's
local function OnStopEnter(pin)
	routes.hoveredStop = pin.stop
	ApplyQuestieIcons()
	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	routes.AddStopTooltip(GameTooltip, pin.stop)
	if pin.stop.names and #pin.stop.names > 0 then
		-- A heading, then a name per row a space in, so a long list grows down instead of wide
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["ROUTES_LOOK_FOR"], ns.GetColorRGB("TITLE"))
		for _, name in ipairs(pin.stop.names) do
			GameTooltip:AddLine(" " .. name, ns.GetColorRGB("TEXT"))
		end
	end
	local hints = {}
	local rightClick = RightClick(pin.stop)
	if rightClick then
		hints[#hints + 1] = { L["ROUTES_CLICK_RIGHT"], rightClick }
	end
	hints[#hints + 1] = { L["ROUTES_CLICK_MIDDLE"], L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] }
	routes.AddClickHints(GameTooltip, hints)
	GameTooltip:Show()
end

local function OnStopLeave()
	if routes.hoveredStop then
		routes.hoveredStop = nil
		ApplyQuestieIcons()
	end
	GameTooltip:Hide()
end

local function OnStopMouseUp(pin, button)
	if button == "RightButton" then
		local _, action = RightClick(pin.stop)
		if action then
			OnStopLeave()
			action()
		end
	elseif button == "MiddleButton" then
		OnStopLeave()
		routes.ResetZone()
	end
end

-- A waypoint's marker, or a camp's: dim for one in the route's zone the route doesn't go to
local function AddStopPin(map, stop, position, textures, dim)
	local pin = map:AcquirePin(STOP_TEMPLATE)
	if not pin.routeReady then
		pin.routeReady = true
		pin:SetScript("OnEnter", OnStopEnter)
		pin:SetScript("OnLeave", OnStopLeave)
		pin:SetScript("OnMouseUp", OnStopMouseUp)
	end
	--[[
		Keeps its size on screen as the map zooms, as Questie's pins do (HereBeDragons-Pins scales them the
		same). The markerScale setting (wideMarkerScale on a continent's or the world's map) sizes the marker itself: SetScalingLimits' first number only sets how
		fast a pin grows as the map zooms in, not how big it is. The size is in the rest of the UI's scale,
		not the map's, so a marker looks the same size on every client: Classic Era and TBC draw their
		full-size map at about 1.8 times the UI's scale, which drew markers that much bigger there
	]]
	pin:SetScalingLimits(1, 1.0, 1.2)
	local settings = routes.Settings()
	local size = settings.markerScale
	if IsWideMap(map:GetMapID()) then
		size = settings.wideMarkerScale * WIDE_MAP_SCALE -- Its own size there (Maps & Objectives)
	end
	size = size * UIParent:GetEffectiveScale() / map:GetEffectiveScale()
	pin:SetSize(STOP_SIZE * size, STOP_SIZE * size)
	pin.Icon:SetSize(STOP_ICON_SIZE * size, STOP_ICON_SIZE * size)
	pin.stop = stop
	routes.ApplyStopLook(pin, stop, textures)

	pin:SetAlpha(dim and CAMP_ALPHA or 1) -- Pins are handed out again, so every one is set
	pin:UseFrameLevelType(stop.camp and CAMP_LEVEL or STOP_LEVEL)
	pin:ApplyFrameLevel()
	pin:SetPosition(position.x, position.y)
	pin:ApplyCurrentScale()
end

--------------------------------------------------------------------------------
-- Data provider
--------------------------------------------------------------------------------

local providerMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function providerMixin:RemoveAllData()
	local map = self:GetMap()
	map:RemoveAllPinsByTemplate(LINE_TEMPLATE)
	map:RemoveAllPinsByTemplate(STOP_TEMPLATE)
	map:RemoveAllPinsByTemplate(routes.MEET_TEMPLATE) -- Routes-Map-Meet.lua
	routes.hoveredStop = nil -- Its pin is gone, and the mouse may never leave it
end

-- The line and the waypoints, on a map of the route's zone
local function DrawRoute(map, mapID, textures)
	local positions = {}
	for i, stop in ipairs(routes.stops) do
		positions[i] = MapPosition(mapID, stop.x, stop.y, stop.instance) or false
	end

	-- No line pin, and so nothing running each frame, while Quest Route is off or there's no leg to draw
	if routes.Settings().showLine and #positions > 0 then
		local pin = map:AcquirePin(LINE_TEMPLATE)
		if not pin.legs then
			Mixin(pin, linePinMixin)
			pin.legs, pin.positions = {}, {}
			pin:SetScript("OnUpdate", OnLinePinUpdate)
		end
		pin:UseFrameLevelType(LINE_LEVEL)
		pin:ApplyFrameLevel()
		pin:SetSize(map:GetCanvas():GetSize())
		pin:SetPosition(0.5, 0.5)
		pin:Draw(mapID, positions)
	end

	for i, stop in ipairs(routes.stops) do
		if IsOnMap(positions[i]) then
			AddStopPin(map, stop, positions[i], textures)
		end
	end
end

--[[
	One marker for an objective's camps on a map: around the camp with the most of its spawns within
	GATHER_REACH, at the middle of those camps weighted by their spawns, naming what they name. So an
	objective spread thin, objects scattered over a zone, is one marker in the thick of them rather than
	one at a lone spawn
]]
local function Gathered(camps)
	if #camps == 1 then
		return camps[1]
	end
	local reachSquared = GATHER_REACH * GATHER_REACH
	local function Near(a, b)
		local dx, dy = a.x - b.x, a.y - b.y
		return a.instance == b.instance and dx * dx + dy * dy <= reachSquared
	end
	local center, bestScore
	for _, camp in ipairs(camps) do
		local score = 0
		for _, other in ipairs(camps) do
			if Near(camp, other) then
				score = score + other.count
			end
		end
		if not bestScore or score > bestScore then
			center, bestScore = camp, score
		end
	end
	local sumX, sumY, names, radius = 0, 0, {}, 0
	for _, camp in ipairs(camps) do
		if Near(center, camp) then
			sumX, sumY = sumX + camp.x * camp.count, sumY + camp.y * camp.count
			for _, name in ipairs(camp.names or {}) do
				if #names < routes.NAME_LIMIT and not tContains(names, name) then
					names[#names + 1] = name
				end
			end
		end
	end
	local x, y = sumX / bestScore, sumY / bestScore
	for _, camp in ipairs(camps) do
		if Near(center, camp) then
			local dx, dy = camp.x - x, camp.y - y
			radius = math.max(radius, math.sqrt(dx * dx + dy * dy) + (camp.radius or 0))
		end
	end
	return {
		x = x,
		y = y,
		instance = center.instance,
		radius = radius,
		count = bestScore,
		names = names,
		area = true,
		camp = true,
		tasks = center.tasks,
	}
end

-- The task keys the route has a waypoint for
local function RouteKeys()
	local keys = {}
	for _, stop in ipairs(routes.stops) do
		for _, task in ipairs(stop.tasks) do
			if task.key then
				keys[task.key] = true
			end
		end
	end
	return keys
end

--[[
	One marker for each objective or turn-in on a map, never one a camp: of its camps on the map, the
	densest, where the most of its mobs or objects are. Hovering it brings back Questie's icons for every
	one of its spawns. On the route's zone an objective the route goes to is its waypoint, so it has no
	camp marker, and one it doesn't (ignored, or the route running back to the corpse) is dimmed behind
	the waypoints. On every other map, the continent's too, each is at full strength and there's no route:
	the route is the zone the player is in. On a flight path no map has the route, as it's planned again
	from where the player lands, so every map shows each objective's marker alone
]]
function providerMixin:RefreshAllData()
	self:RemoveAllData()
	ApplyQuestieIcons()
	ApplyBlizzardQuests()
	local map = self:GetMap()
	local mapID = map:GetMapID()
	if not routes.IsMapShownOn(mapID) then
		return
	end

	local byObjective, byTurnIn, byPickUp = QuestieTextures()
	local textures = { objectives = byObjective, turnIns = byTurnIn, pickUps = byPickUp }
	local onRoute = IsRouteMap(mapID) and not routes.IsOnTaxi()
	local routeKeys = onRoute and RouteKeys() or {}
	if onRoute then
		DrawRoute(map, mapID, textures)
	end

	-- Each objective's camps on this map, in the order they come
	local byKey, order = {}, {}
	for _, camp in ipairs(routes.camps) do
		local key = camp.tasks[1].key
		if not routeKeys[key] and IsOnMap(MapPosition(mapID, camp.x, camp.y, camp.instance)) then
			if not byKey[key] then
				byKey[key] = {}
				order[#order + 1] = key
			end
			table.insert(byKey[key], camp)
		end
	end
	for _, key in ipairs(order) do
		local marker = Gathered(byKey[key])
		local position = MapPosition(mapID, marker.x, marker.y, marker.instance)
		if not IsOnMap(position) then -- The middle of camps near the map's edge can fall just past it
			marker = byKey[key][1]
			position = MapPosition(mapID, marker.x, marker.y, marker.instance)
		end
		--[[
			Dim on the route's zone only while the route could take it; one it won't has its ring instead.
			An escort to pick up later stays at full strength, its green the point of it
		]]
		local escort = marker.tasks[1].kind == "pickUp" and marker.tasks[1].escort
		AddStopPin(map, marker, position, textures, onRoute and not IsUntracked(marker) and not escort)
	end

	routes.AddMeetPin(map, mapID) -- Routes-Map-Meet.lua
end

-- Joining up starting or ending (Routes-Group-Up.lua): its marker comes or goes on the open map
function routes.RefreshGroupUpMarker()
	if provider and WorldMapFrame:IsShown() then
		provider:RefreshAllData()
	end
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

-- The route's pins place themselves among the map's layers (PrettyWideQuestLogRoutePinMixin:ApplyFrameLevel)
local function AddToWorldMap()
	if provider or not WorldMapFrame then
		return
	end
	WorldMapFrame:HookScript("OnHide", KeepFullSize)
	provider = CreateFromMixins(providerMixin)
	WorldMapFrame:AddDataProvider(provider)
	HookBlizzardQuests(WorldMapFrame) -- Blizzard's quest markers and objective areas, hidden for the route too

	-- Questie's pins come and go as it draws; the ones the route stands in for stay hidden
	local _, pins = Libraries()
	local questieProvider = pins and pins.worldmapProvider
	if questieProvider then
		if questieProvider.RefreshAllData then
			hooksecurefunc(questieProvider, "RefreshAllData", RequestApplyQuestieIcons)
		end
		if questieProvider.HandlePin then
			hooksecurefunc(questieProvider, "HandlePin", function(_, icon)
				routes.ApplyToPlacedQuestieIcon(icon)
				RequestApplyQuestieIcons()
			end)
		end
	end
end

local loggedIn = false
routes.OnLogin(function()
	loggedIn = true
	AddToWorldMap()
	KeepFullSize()
end)

-- Blizzard's world map loads on demand on some clients
function routesMap:OnAddonLoaded(name)
	if loggedIn and name == "Blizzard_WorldMap" then
		AddToWorldMap()
	end
end

routes.AddListener(function()
	KeepFullSize() -- A setting switched on, or a profile change
	if provider then
		if WorldMapFrame:IsShown() then
			provider:RefreshAllData()
		else
			ApplyQuestieIcons() -- So Questie's icons come back with the route turned off
			ApplyBlizzardQuests() -- And Blizzard's quest markers and objective areas
		end
	end
end)
