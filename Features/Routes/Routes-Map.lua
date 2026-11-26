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
local IMAGES = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\"

-- A zone's disc on a continent's or the world's map (Routes-Map-Zones.lua)
local ZONE_TEMPLATE = "PrettyWideQuestLogRouteZonePinTemplate"
local DISC_TEXTURE = IMAGES .. "Route-Stop" -- A waypoint's disc, its black ring and all
local ZONE_SCALE = 2 -- A zone's disc, times a marker's size on that map, so it stands out on the parchment

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
routes.MORE_LEVEL = MORE_LEVEL -- Routes-Map-More.lua
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

local ContinentOf = routes.ContinentOf -- Routes-Map-Zones.lua

--[[
	Whether a camp stands in the zone a zone's map is of (a cave's map counting as its zone's), with the
	cities and caves inside it and a zone linked to it (routes.IsInZone). A zone's map reaches over its
	neighbors' edges, and their markers there are theirs, not this map's: the Barrens' map shows none of
	Mulgore's, Durotar's or Stonetalon's. The map under the camp is asked of the continent's map, which
	knows where each zone ends, and kept on the camp; a camp nothing claims there, out at sea, stays
]]
local function IsInMapZone(camp, mapID)
	local continent = ContinentOf(mapID)
	if not continent then
		return true
	end
	if camp.mapAt == nil then
		local position = MapPosition(continent, camp.x, camp.y, camp.instance)
		local info = IsOnMap(position) and C_Map.GetMapInfoAtPosition(continent, position.x, position.y)
		camp.mapAt = info and info.mapID ~= continent and info.mapID or false
	end
	return not camp.mapAt or routes.IsInZone(camp.mapAt, routes.OutOfMicro(mapID))
end

routes.IsInMapZone = IsInMapZone -- Questie's icons keep to a zone's map too (Routes-Map-Questie-Icons.lua)

--------------------------------------------------------------------------------
-- The stops
--------------------------------------------------------------------------------

local provider

local function CampAlpha(pin)
	return pin.dimmable and not IsUntracked(pin.stop) and CAMP_ALPHA or 1
end

--[[
	Every marker on the map given its look again at once, its ring gray or black and a camp's dimming, from
	the ignore list as it is now: what a click changed shows on the marker right away, though the route
	isn't planned again till the clicks stop. A marker in the hidden tail stays unseen
]]
local function RestyleMarkers()
	if not (WorldMapFrame and WorldMapFrame:IsShown()) then
		return
	end
	for pin in WorldMapFrame:EnumeratePinsByTemplate(STOP_TEMPLATE) do
		if pin.stop and pin.routeTextures then
			routes.ApplyStopLook(pin, pin.stop, pin.routeTextures)
			if not pin.inTail then
				pin:SetAlpha(CampAlpha(pin))
			end
		end
	end
end
routes.RestyleMarkers = RestyleMarkers -- After a click on a marker (Routes-Map-Clicks.lua)

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
routes.MapMarkerSize = MarkerSize -- The "…" marker is sized as a waypoint's (Routes-Map-More.lua)

--[[
	A waypoint's marker, or a camp's: dimmable for a camp in the route's zone, dim while the route could still
	take it (CampAlpha). One in the route's hidden tail (Waypoints Shown) is placed but unseen and takes no
	mouse, till the "…" marker is hovered, and isn't moved off others (routes.SpreadMarker). landing: a flight's marker
	where it lands
]]
local function AddStopPin(map, stop, position, textures, dimmable, tail, landing)
	position = routes.LockedMarkerPosition(map:GetMapID(), stop, position, landing) -- Routes-Map-Placement.lua
	local pin = map:AcquirePin(STOP_TEMPLATE)
	if not pin.routeReady then
		pin.routeReady = true
		-- Routes-Map-Clicks.lua; the menu closes itself once the mouse has left it and the pin
		pin:SetScript("OnEnter", routes.OnStopEnter)
		pin:SetScript("OnMouseUp", routes.OnStopMouseUp)
	end
	pin:SetScalingLimits(1, 1.0, 1.2)
	local size = MarkerSize(map)
	pin:SetSize(STOP_SIZE * size, STOP_SIZE * size)
	pin.Icon:SetSize(STOP_ICON_SIZE * size, STOP_ICON_SIZE * size)
	pin.stop = stop
	pin.routeTextures = textures -- For RestyleMarkers
	routes.ApplyStopLook(pin, stop, textures)

	-- Pins are handed out again, so every one is set
	pin.dimmable, pin.inTail = dimmable or nil, tail or nil
	pin:SetAlpha(tail and 0 or CampAlpha(pin))
	pin:EnableMouse(not tail)
	pin:UseFrameLevelType(stop.camp and CAMP_LEVEL or STOP_LEVEL)
	pin:ApplyFrameLevel()
	pin:SetPosition(position.x, position.y)
	pin:ApplyCurrentScale()
	pin.baseX, pin.baseY = position.x, position.y
	pin.markerKey = routes.MarkerKey(stop, landing)
	if not tail then
		routes.SpreadMarker(pin)
	end
	return pin
end

--------------------------------------------------------------------------------
-- A zone's disc, on a continent's or the world's map
--------------------------------------------------------------------------------

--[[
	Opens a zone's map from its disc, or its menu's row; nothing in combat, where the map's layers would make
	their pins from add-on code and SetPassThroughButtons on them is blocked
]]
local function OpenZoneMap(zoneID)
	return function()
		routes.CloseMapMenu()
		if InCombatLockdown() then
			return
		end
		WorldMapFrame:SetMapID(zoneID)
	end
end

-- Opens the zone's menu (routes.ZoneMenuEntries); nothing once the pin shows another zone, which closes it
local function OnZoneEnter(pin)
	local group = pin.zoneGroup
	routes.OpenMapMenu(pin, group, function()
		if pin.zoneGroup ~= group then
			return nil
		end
		return routes.ZoneMenuEntries(group, OpenZoneMap(group.zoneID))
	end)
end

local function OnZoneMouseUp(pin, button)
	if button == "LeftButton" and pin.zoneGroup then
		OpenZoneMap(pin.zoneGroup.zoneID)()
	end
end

-- Questie's icon of a type (Questie.ICON_TYPE_AVAILABLE and the rest), in the user's Questie icon theme
local function QuestieIconOfType(name)
	local icons = Questie and Questie.usedIcons
	return icons and Questie[name] and icons[Questie[name]] or nil
end

--[[
	A zone's disc, in its level color with Questie's ! on it: sized, layered and moved off others as one marker
	is, ZONE_SCALE times a marker's size. Its disc and icon are made the first time the pin is
]]
local function AddZonePin(map, group)
	local pin = map:AcquirePin(ZONE_TEMPLATE)
	if not pin.routeReady then
		pin.routeReady = true
		pin:SetScript("OnEnter", OnZoneEnter) -- The menu closes itself once the mouse has left it and the pin
		pin:SetScript("OnMouseUp", OnZoneMouseUp)
		pin.disc = pin:CreateTexture(nil, "ARTWORK", nil, 0)
		pin.disc:SetTexture(DISC_TEXTURE)
		pin.disc:SetAllPoints()
		pin.icon = pin:CreateTexture(nil, "ARTWORK", nil, 1)
		pin.icon:SetPoint("CENTER")
	end
	pin:SetScalingLimits(1, 1.0, 1.2)
	local size = MarkerSize(map) * ZONE_SCALE
	pin:SetSize(STOP_SIZE * size, STOP_SIZE * size)
	pin.icon:SetSize(STOP_ICON_SIZE * size, STOP_ICON_SIZE * size)
	pin.disc:SetVertexColor(routes.ZoneColorRGB(group.color))
	pin.icon:SetTexture(QuestieIconOfType("ICON_TYPE_AVAILABLE"))
	pin.icon:SetShown(pin.icon:GetTexture() ~= nil)
	pin.stop, pin.zoneGroup = { tasks = {} }, group -- No task: placement never takes it for a flight's marker

	pin:SetAlpha(1)
	pin:EnableMouse(true)
	pin:UseFrameLevelType(CAMP_LEVEL)
	pin:ApplyFrameLevel()
	pin:SetPosition(group.position.x, group.position.y)
	pin:ApplyCurrentScale()
	pin.baseX, pin.baseY = group.position.x, group.position.y
	pin.markerKey = "zone:" .. group.zoneID
	routes.SpreadMarker(pin)
	return pin
end

--------------------------------------------------------------------------------
-- Data provider
--------------------------------------------------------------------------------

local providerMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function providerMixin:RemoveAllData()
	routes.ForgetTail() -- Routes-Map-More.lua
	routes.ForgetSpreadMarkers() -- Routes-Map-Placement.lua
	local map = self:GetMap()
	map:RemoveAllPinsByTemplate(LINE_TEMPLATE)
	map:RemoveAllPinsByTemplate(STOP_TEMPLATE)
	map:RemoveAllPinsByTemplate(routes.MORE_TEMPLATE)
	map:RemoveAllPinsByTemplate(ZONE_TEMPLATE)
	routes.zoneDiscQuests = {} -- Questie's ! icons the zone discs stood in for come back, till discs are drawn again
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
		-- Where its marker was drawn for since the map opened, so the line runs to the marker (routes.LockedMarkerPosition)
		positions[i] = routes.LockedMarkerPosition(mapID, stop, MapPosition(mapID, stop.x, stop.y, stop.instance))
			or false
		-- A fly waypoint: the leg after it runs from the flight master it lands at (Routes-Flights.lua)
		local landing = stop.landing
		if landing then
			landings[i] =
				routes.LockedMarkerPosition(mapID, stop, MapPosition(mapID, landing.x, landing.y, stop.instance), true)
		end
	end

	local lastShown, stub = routes.LastShownWaypoint(stops), nil -- Routes-Map-More.lua
	if lastShown < #stops then
		local from = landings[lastShown] or positions[lastShown]
		stub = routes.AddMoreMarker(map, from, positions[lastShown + 1] or nil, #stops - lastShown)
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
		--[[
			Out of a city through the first waypoint's gate: its hidden point past the city map's edge, which
			the line runs through once the player is at or through the gate (Routes-Cities.lua)
		]]
		local exit
		local gateTask = stops[1] and stops[1].tasks[1]
		if gateTask and gateTask.kind == "exit" and gateTask.aim then
			local position = MapPosition(mapID, gateTask.aim.x, gateTask.aim.y, stops[1].instance)
			local gate = routes.TaskPoint(gateTask)
			exit = position and gate and { task = gateTask, gate = gate, position = position } or nil
		end
		pin:Draw(mapID, positions, landings, lastShown, stub, exit)
		routes.SetRouteLine(pin)
	end

	--[[
		A fly waypoint has its marker at both ends of the flight, the flight master it leaves from and the one
		it lands at, so the leg after it starts at a marker rather than out of nothing
	]]
	for i, stop in ipairs(stops) do
		local tail = i > lastShown
		for end_, position in ipairs({ positions[i], landings[i] or false }) do
			if IsOnMap(position) then
				local pin = AddStopPin(map, stop, position, textures, nil, tail, end_ == 2)
				if tail then
					routes.AddTailMarker(pin)
				end
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

--[[
	The task keys the route draws a waypoint for: those up to the last one Waypoints Shown lets it draw. An
	objective further on keeps its camp marker, so nothing the route will take is missing from the map
]]
local function RouteKeys()
	local keys = {}
	for i, stop in ipairs(routes.stops) do
		if i > routes.LastShownWaypoint(routes.stops) then
			break
		end
		for _, task in ipairs(stop.tasks) do
			if task.key then
				keys[task.key] = true
			end
		end
	end
	return keys
end

--[[
	The route's quests to pick up with no waypoint drawn on this map: past Waypoints Shown, on another zone's
	map, or on a flight. A pick-up has no camp, and Questie's icon for it is hidden, so each is drawn here as
	a camp marker of its own rather than left off the map
]]
local function UndrawnPickUps(routeKeys)
	local markers = {}
	for _, stop in ipairs(routes.stops) do
		for _, task in ipairs(stop.tasks) do
			if task.kind == "pickUp" and task.key and not routeKeys[task.key] then
				markers[#markers + 1] = {
					x = stop.x,
					y = stop.y,
					instance = stop.instance,
					names = stop.names,
					camp = true,
					tasks = { task },
				}
			end
		end
	end
	return markers
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

	-- Each objective's camps on this map, in the order they come, then the pick-ups the route draws no waypoint for here
	local byKey, order, shown = {}, {}, {}
	local camps = {}
	for _, camp in ipairs(routes.camps) do
		camps[#camps + 1] = camp
	end
	for _, marker in ipairs(UndrawnPickUps(routeKeys)) do
		camps[#camps + 1] = marker
	end
	local wide = IsWideMap(mapID)
	--[[
		A zone's map has a marker for each quest to pick up there its zone's disc counts (Routes-Map-Zones.lua),
		the route's zone's too, for those the route has no marker for
	]]
	local elsewhere = {}
	if not wide then
		local have = {}
		for _, camp in ipairs(camps) do
			have[camp.tasks[1].key or ""] = true
		end
		for key in pairs(routeKeys) do
			have[key] = true
		end
		elsewhere = routes.ZonePickUps(mapID, have, IsRouteMap(mapID))
		for _, camp in ipairs(elsewhere) do
			camps[#camps + 1] = camp
		end
	end
	for _, camp in ipairs(camps) do
		local key = camp.tasks[1].key
		if
			not routeKeys[key]
			and IsOnMap(MapPosition(mapID, camp.x, camp.y, camp.instance))
			and (wide or IsInMapZone(camp, mapID))
		then
			shown[#shown + 1] = camp
			if not byKey[key] then
				byKey[key] = {}
				order[#order + 1] = key
			end
			table.insert(byKey[key], camp)
		end
	end
	--[[
		A continent's or the world's map has each zone's disc in place of its pick-ups and objectives
		(Routes-Map-Zones.lua), and a marker for each turn-in alone; Questie's ! icons for the quests the
		discs count are hidden too, now they're known. A zone's map shows only its own markers (IsInMapZone)
	]]
	if wide then
		for _, group in ipairs(routes.ZoneGroups(mapID, shown)) do
			AddZonePin(map, group)
		end
		ApplyQuestieIcons()
		local turnIns = {}
		for _, key in ipairs(order) do
			if byKey[key][1].tasks[1].kind == "turnIn" then
				turnIns[#turnIns + 1] = key
			end
		end
		order = turnIns
	elseif #elsewhere > 0 then
		ApplyQuestieIcons() -- Questie's ! icons for the zone's quests to pick up hide, now they're known
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
			An escort to pick up later stays at full strength
		]]
		local escort = marker.tasks[1].kind == "pickUp" and marker.tasks[1].escort
		AddStopPin(map, marker, position, textures, onRoute and not escort)
	end
	routes.SpreadMarkers(map) -- Routes-Map-Placement.lua

	routes.AddMeetPin(map, mapID) -- Routes-Map-Meet.lua
end

-- Moved markers laid out again as the map zooms or resizes (routes.RespreadMarkers, Routes-Map-Placement.lua)
function providerMixin:OnCanvasScaleChanged()
	routes.RespreadMarkers(self:GetMap())
end
providerMixin.OnCanvasSizeChanged = providerMixin.OnCanvasScaleChanged

-- The route drawn again on the open map: the whole route once the "…" marker is clicked (Routes-Map-More.lua)
function routes.RedrawRouteMap()
	if provider then
		provider:RefreshAllData()
	end
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
		routes.ForgetWholeRoute() -- Routes-Map-More.lua
		routes.UnlockMarkerPlaces() -- Markers are placed afresh the next time it opens
		routes.ReleasePlanHold() -- No more clicks on its markers to wait for: the route is planned now
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
