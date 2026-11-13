local ADDON_NAME, ns = ...

--[[
	Routes: the route on the world map, as sketched in Questie issues #2498 and #2500. A
	line of small dark gray dots, a little see-through so it doesn't clutter the map, marches from the player
	through every stop. Each stop is one simple marker, a disc in its objective's Questie color with
	Questie's icon for the objective on it, in place of Questie's icon on every spawn, which are hidden
	for the objectives on the route. Hovering a marker brings back Questie's icons for its objectives,
	every place they can be done, and lists its quests. Drawn through a data provider, as Questie and HandyNotes draw theirs, on
	whatever map the world map shows, zone or continent. The whole route is planned, but the zone map draws
	only the next few waypoints (Waypoints Shown) and then a "…" marker; hovering it brings in the rest
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
	Waypoints Shown: the "…" marker where the zone map stops drawing the route, on the first hidden waypoint
	and over every marker. A pill MORE_HEIGHT tall and twice as wide at Medium, never nearer the last waypoint
	shown than MORE_GAP, middle to middle, so neither covers the other. Hovering it draws the rest of the
	route at TAIL_ALPHA
]]
local MORE_TEMPLATE = "PrettyWideQuestLogRouteMorePinTemplate"
local MORE_HEIGHT = 20
local MORE_GAP = 40
local TAIL_ALPHA = 0.5
local IMAGES = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\"

--[[
	The mixin of the route's pin templates in Routes.xml, which load after this file. The map canvas lets right
	clicks pass through every pin it makes, with SetPassThroughButtons, which WoW blocks in combat: opening the
	map in combat then blames this addon. The stop pins take their own right clicks (skipping the stop) and the
	line takes no mouse, so neither wants it, as HereBeDragons-Pins does for Questie's pins
]]
PrettyWideQuestLogRoutePinMixin = CreateFromMixins(MapCanvasPinMixin)
function PrettyWideQuestLogRoutePinMixin.SetPassThroughButtons() end

--[[
	Where the route's pins sit among the world map's layers, by the level Blizzard gave Questie's layer: the
	line just under Questie's icons, camps just over them and the waypoints over the camps. Adding a layer to
	the map's list moves Blizzard's layers above or below it, which rewrites their levels from add-on code for
	the rest of the session. Every Blizzard pin reads those levels as it's placed, so each is then set up
	tainted, and a click or hover on one of Blizzard's quest markers marks the objective tracker dirty as
	add-on code, an error in combat (GitHub #23). So each pin works out its own level, and the route adds no
	layers. On WoW Forever's map the levels either side of Questie's belong to layers it never draws
	(dragonriding races, gossip, debug)
]]
local MORE_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_MORE" -- The "…" marker, over everything, the waypoints too
local LEVEL_OFFSETS = { [LINE_LEVEL] = -1, [CAMP_LEVEL] = 1, [STOP_LEVEL] = 2, [MORE_LEVEL] = 3 }
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
	hereBeDragonsPins = hereBeDragonsPins or ns.QuestieHereBeDragonsPins()
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

--[[
	A marker's size on a map, times its size at Medium. Keeps its size on screen as the map zooms, as
	Questie's pins do (HereBeDragons-Pins scales them the same). The markerScale setting (wideMarkerScale on
	a continent's or the world's map) sizes the marker itself: SetScalingLimits' first number only sets how
	fast a pin grows as the map zooms in, not how big it is. Classic Era and TBC draw their full-size map at
	about 1.8 times the UI's scale, so a size in the map's scale draws a marker that much bigger there. The
	size is in the rest of the UI's scale, so a marker looks the same size on every client
]]
local function MarkerSize(map)
	local settings = routes.Settings()
	local size = settings.markerScale
	if IsWideMap(map:GetMapID()) then
		size = settings.wideMarkerScale * WIDE_MAP_SCALE -- Its own size there (Maps & Objectives)
	end
	return size * UIParent:GetEffectiveScale() / map:GetEffectiveScale()
end

--[[
	A waypoint's marker, or a camp's: dim for one in the route's zone the route doesn't go to. One in the
	route's hidden tail (Waypoints Shown) is placed but unseen and takes no mouse, till the "…" marker is hovered
]]
local function AddStopPin(map, stop, position, textures, dim, tail)
	local pin = map:AcquirePin(STOP_TEMPLATE)
	if not pin.routeReady then
		pin.routeReady = true
		pin:SetScript("OnEnter", OnStopEnter)
		pin:SetScript("OnLeave", OnStopLeave)
		pin:SetScript("OnMouseUp", OnStopMouseUp)
	end
	pin:SetScalingLimits(1, 1.0, 1.2)
	local size = MarkerSize(map)
	pin:SetSize(STOP_SIZE * size, STOP_SIZE * size)
	pin.Icon:SetSize(STOP_ICON_SIZE * size, STOP_ICON_SIZE * size)
	pin.stop = stop
	routes.ApplyStopLook(pin, stop, textures)

	-- Pins are handed out again, so every one is set
	pin:SetAlpha(tail and 0 or dim and CAMP_ALPHA or 1)
	pin:EnableMouse(not tail)
	pin:UseFrameLevelType(stop.camp and CAMP_LEVEL or STOP_LEVEL)
	pin:ApplyFrameLevel()
	pin:SetPosition(position.x, position.y)
	pin:ApplyCurrentScale()
	return pin
end

--------------------------------------------------------------------------------
-- Waypoints Shown: the "…" marker and the route's hidden tail
--------------------------------------------------------------------------------

-- The tail's markers and the line, from the last draw, for the "…" marker's hover
local tailPins = {}
local routeLine
-- Clicking the "…" marker draws the whole route till the map closes
local wholeRouteShown = false

-- The last waypoint the zone map draws, by the Waypoints Shown setting: the whole route at 0, or once the "…" is clicked
local function LastShown(stops)
	local limit = routes.Settings().waypointsShown or 0
	if limit <= 0 or wholeRouteShown then
		return #stops
	end
	return math.min(limit, #stops)
end

local function ShowTail(alpha)
	for _, pin in ipairs(tailPins) do
		pin:SetAlpha(alpha)
	end
	if routeLine then
		routeLine:ShowTail(alpha)
	end
end

local function OnMoreEnter(pin)
	ShowTail(TAIL_ALPHA)
	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	local hidden = pin.hidden or 0
	local title = hidden == 1 and L["ROUTES_MORE_WAYPOINT"] or L["ROUTES_MORE_WAYPOINTS"]:format(hidden)
	GameTooltip:AddLine(title, ns.GetColorRGB("TITLE"))
	GameTooltip:AddLine(L["ROUTES_MORE_WAYPOINTS_DESCRIPTION"], ns.GetColorRGB("HELP"))
	routes.AddClickHints(GameTooltip, { { L["ROUTES_CLICK"], L["ROUTES_CLICK_SHOW_ROUTE"] } })
	GameTooltip:Show()
end

local function OnMoreLeave()
	ShowTail(0)
	GameTooltip:Hide()
end

-- Clicking it draws the whole route, every marker hoverable, the "…" gone, till the map closes
local function OnMoreMouseUp(_, button)
	if button ~= "LeftButton" then
		return
	end
	OnMoreLeave()
	wholeRouteShown = true
	if provider then
		provider:RefreshAllData()
	end
end

-- One half of a pill, or its middle stretched between them, from a disc's art
local function PillPart(pin, file, subLevel, left, right)
	local texture = pin:CreateTexture(nil, "ARTWORK", nil, subLevel)
	texture:SetTexture(file)
	texture:SetTexCoord(left, right, 0, 1)
	return texture
end

--[[
	A pill from the waypoint's disc art cut in half, its middle the disc's middle column stretched across: a
	white fill and the line's dark ring and three dots, so it reads as part of the line, not a waypoint
]]
local function BuildMorePin(pin)
	pin.caps, pin.dots = {}, {}
	local layers = {
		{ IMAGES .. "Route-Stop-Fill", 0, { ns.GetColorRGB("ROUTE_MORE") } },
		{ IMAGES .. "Route-Stop-Ring", 1, { ns.GetColorRGB("ROUTE_LINE") } },
	}
	for _, layer in ipairs(layers) do
		local file, subLevel, color = layer[1], layer[2], layer[3]
		local left = PillPart(pin, file, subLevel, 0, 0.5)
		left:SetPoint("TOPLEFT")
		left:SetPoint("BOTTOMLEFT")
		local right = PillPart(pin, file, subLevel, 0.5, 1)
		right:SetPoint("TOPRIGHT")
		right:SetPoint("BOTTOMRIGHT")
		local middle = PillPart(pin, file, subLevel, 0.49, 0.51)
		middle:SetPoint("TOPLEFT", left, "TOPRIGHT")
		middle:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT")
		for _, texture in ipairs({ left, right, middle }) do
			texture:SetVertexColor(unpack(color))
		end
		table.insert(pin.caps, left)
		table.insert(pin.caps, right)
	end
	for i = 1, 3 do
		local dot = pin:CreateTexture(nil, "ARTWORK", nil, 2)
		dot:SetTexture(IMAGES .. "Route-Stop-Fill")
		dot:SetVertexColor(ns.GetColorRGB("ROUTE_LINE"))
		pin.dots[i] = dot
	end
	pin:SetScript("OnEnter", OnMoreEnter)
	pin:SetScript("OnLeave", OnMoreLeave)
	pin:SetScript("OnMouseUp", OnMoreMouseUp)
end

--[[
	The "…" marker where the first hidden waypoint is, so the route runs on to where it really goes next. One
	that close to the last waypoint shown would cover it, so it's pushed out along that leg to MORE_GAP on
	screen. With the next waypoint off this map, just right of the last one shown; with that off it too,
	nothing. Returns where it sits, for the line's stub
]]
local function AddMorePin(map, from, to, hidden)
	if not IsOnMap(to) then
		to = nil
	end
	if not IsOnMap(from) then
		from = nil
	end
	local anchor = to or from
	if not anchor then
		return nil
	end
	local pin = map:AcquirePin(MORE_TEMPLATE)
	if not pin.caps then
		BuildMorePin(pin)
	end
	pin:SetScalingLimits(1, 1.0, 1.2) -- As a waypoint's (AddStopPin)
	local size = MarkerSize(map)
	local height = MORE_HEIGHT * size
	pin:SetSize(height * 2, height)
	for _, cap in ipairs(pin.caps) do
		cap:SetWidth(height / 2)
	end
	for i, dot in ipairs(pin.dots) do
		dot:SetSize(height * 0.2, height * 0.2)
		dot:ClearAllPoints()
		dot:SetPoint("CENTER", (i - 2) * height * 0.4, 0)
	end
	pin.hidden = hidden
	pin:UseFrameLevelType(MORE_LEVEL)
	pin:ApplyFrameLevel()
	pin:SetPosition(anchor.x, anchor.y)
	pin:ApplyCurrentScale()
	if not from then
		return { x = to.x, y = to.y }
	end

	-- MORE_GAP on screen, in the canvas's pixels at this zoom
	local width, canvasHeight = map:GetCanvas():GetSize()
	local gap = MORE_GAP * size * pin:GetScale()
	local place
	if to then
		local dx, dy = (to.x - from.x) * width, (to.y - from.y) * canvasHeight
		local length = math.sqrt(dx * dx + dy * dy)
		if length >= gap then
			place = { x = to.x, y = to.y }
		elseif length > 0 then
			local share = gap / length
			place = { x = from.x + (to.x - from.x) * share, y = from.y + (to.y - from.y) * share }
		end
	end
	place = place or { x = from.x + gap / width, y = from.y }
	pin:SetPosition(place.x, place.y)
	return place
end

--------------------------------------------------------------------------------
-- Data provider
--------------------------------------------------------------------------------

local providerMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function providerMixin:RemoveAllData()
	--[[
		Forgotten before the pins go: releasing the "…" marker under the mouse hides it, and its OnLeave would
		reach a line pin already released, off any map
	]]
	wipe(tailPins)
	routeLine = nil
	local map = self:GetMap()
	map:RemoveAllPinsByTemplate(LINE_TEMPLATE)
	map:RemoveAllPinsByTemplate(STOP_TEMPLATE)
	map:RemoveAllPinsByTemplate(MORE_TEMPLATE)
	map:RemoveAllPinsByTemplate(routes.MEET_TEMPLATE) -- Routes-Map-Meet.lua
	routes.hoveredStop = nil -- Its pin is gone, and the mouse may never leave it
end

--[[
	The line and the waypoints, on a map of the route's zone. Past the last one Waypoints Shown lets it draw,
	a "…" marker, and the rest placed unseen for its hover
]]
local function DrawRoute(map, mapID, textures)
	local stops = routes.stops
	local positions, landings = {}, {}
	for i, stop in ipairs(stops) do
		positions[i] = MapPosition(mapID, stop.x, stop.y, stop.instance) or false
		-- A fly waypoint: the leg after it runs from the flight master it lands at (Routes-Flights.lua)
		local landing = stop.landing
		if landing then
			landings[i] = MapPosition(mapID, landing.x, landing.y, stop.instance)
		end
	end

	local lastShown, stub = LastShown(stops), nil
	if lastShown < #stops then
		local from = landings[lastShown] or positions[lastShown]
		stub = AddMorePin(map, from, positions[lastShown + 1] or nil, #stops - lastShown)
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
		pin:Draw(mapID, positions, landings, lastShown, stub)
		routeLine = pin
	end

	for i, stop in ipairs(stops) do
		if IsOnMap(positions[i]) then
			local tail = i > lastShown
			local pin = AddStopPin(map, stop, positions[i], textures, nil, tail)
			if tail then
				tailPins[#tailPins + 1] = pin
			end
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
	-- A click on the "…" marker shows the whole route only while the map stays open
	WorldMapFrame:HookScript("OnHide", function()
		wholeRouteShown = false
	end)
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
