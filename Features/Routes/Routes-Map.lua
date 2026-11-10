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
local STOP_SIZE, STOP_ICON_SIZE = 42, 24
local LINE_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_LINE" -- Under Questie's icons
local STOP_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_STOP" -- Over them
local CAMP_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_CAMP" -- Over Questie's icons too, under the stops
local CAMP_ALPHA = 0.5 -- A camp in the route's zone the route doesn't go to, behind the waypoints
local GATHER_REACH = 800 -- Yards around an objective's busiest camp whose other camps its one marker gathers
local WIDE_MAP_SCALE = 0.6 -- Markers on a continent's or the world's map, which hold many zones' worth
local QUESTIE_LEVEL = "PIN_FRAME_LEVEL_AREA_POI" -- Where HereBeDragons-Pins puts Questie's icons

-- A stop's disc: with its black ring, or the fill alone, under a tinted ring (a party member's, a dungeon's, an ignored one)
local DISC_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Stop"
local PARTY_DISC_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Stop-Fill"
local CORPSE_ICON = routes.CORPSE_ICON -- On a ghost's first stop, their corpse

--[[
	The mixin of the route's pin templates in Routes.xml, which load after this file. The map canvas lets right
	clicks pass through every pin it makes, with SetPassThroughButtons, which WoW blocks in combat: opening the
	map in combat then blames this addon. The stop pins take their own right clicks (skipping the stop) and the
	line takes no mouse, so neither wants it, as HereBeDragons-Pins does for Questie's pins
]]
PrettyWideQuestLogRoutePinMixin = CreateFromMixins(MapCanvasPinMixin)
function PrettyWideQuestLogRoutePinMixin.SetPassThroughButtons() end

local IsMapShown = routes.IsMapShown
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

-- Whether a map is a continent's, the world's or the cosmos', not a zone's or one inside a zone
local function IsWideMap(mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	return info ~= nil and info.mapType ~= nil and info.mapType <= Enum.UIMapType.Continent
end

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

local function IsEveryTask(stop, test)
	for _, task in ipairs(stop.tasks) do
		if not test(task) then
			return false
		end
	end
	return true
end

-- An objective the route won't take: a dungeon or raid quest's, inside the instance, or one ignored
local function IsUntrackedTask(task)
	return task.untracked or (task.key ~= nil and routes.skipped[task.key] ~= nil)
end

-- A marker whose every objective the route won't take, a dungeon's or one ignored
local function IsUntracked(stop)
	return not stop.corpse and IsEveryTask(stop, IsUntrackedTask)
end

-- Not a dungeon or raid quest's: what the route won't take there is only ignored, for the gray ring over the red
local function IsUntrackedOnlyIgnored(stop)
	return IsEveryTask(stop, function(task)
		return not task.untracked
	end)
end

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
	Questie's icon for an objective, or a turn-in, from the icon type it draws them with, in the user's
	Questie icon theme. For a stop whose Questie pins aren't on the map yet: Questie draws them a while
	after a quest is taken or changes, and the route can be drawn first
]]
local function QuestieIcon(task)
	local icons = Questie and Questie.usedIcons
	if not icons then
		return nil
	end
	if task.kind == "pickUp" then
		return icons[Questie.ICON_TYPE_AVAILABLE]
	end
	if task.kind == "turnIn" then
		-- Questie's gray question mark for a quest not done yet, planned ahead of its objectives being done
		local incomplete = not task.ready and Questie.ICON_TYPE_INCOMPLETE
		return incomplete and icons[incomplete] or icons[Questie.ICON_TYPE_COMPLETE]
	end
	local objective = task.objective or {}
	local iconType = objective.Icon
	if not iconType and type(objective.spawnList) == "table" then
		for _, spawn in pairs(objective.spawnList) do
			if type(spawn) == "table" and spawn.Icon then
				iconType = spawn.Icon
				break
			end
		end
	end
	return iconType and icons[iconType]
end

--[[
	Whether every task at a stop is a party member's, whose marker has a white ring in place of the black
	one. A stop with any of the player's own on it is the player's, party objectives merged in or not
]]
local function IsPartyStop(stop)
	return IsEveryTask(stop, function(task)
		return task.party
	end)
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
		same). The markerScale setting sizes the marker itself: SetScalingLimits' first number only sets how
		fast a pin grows as the map zooms in, not how big it is. The size is in the rest of the UI's scale,
		not the map's, so a marker looks the same size on every client: Classic Era and TBC draw their
		full-size map at about 1.8 times the UI's scale, which drew markers that much bigger there
	]]
	pin:SetScalingLimits(1, 1.0, 1.2)
	local size = routes.Settings().markerScale * UIParent:GetEffectiveScale() / map:GetEffectiveScale()
	if IsWideMap(map:GetMapID()) then
		size = size * WIDE_MAP_SCALE
	end
	pin:SetSize(STOP_SIZE * size, STOP_SIZE * size)
	pin.Icon:SetSize(STOP_ICON_SIZE * size, STOP_ICON_SIZE * size)
	pin.stop = stop

	--[[
		The first task's look: its objective's color and Questie's icon for it, or the turn-in's: the one on
		Questie's own pins, else the one Questie draws that kind with
	]]
	local task = stop.tasks[1]
	pin.Disc:SetVertexColor(routes.TaskColor(task))
	--[[
		A ring for one the route won't take: red, to stand out, for a dungeon or raid quest's, light gray for
		one ignored. A white one for a party member's, a quest the player doesn't have; else the disc's black ring
	]]
	local ringColor
	if IsUntracked(stop) then
		ringColor = IsUntrackedOnlyIgnored(stop) and "ROUTE_IGNORED_RING" or "ROUTE_ALERT_RING"
	elseif IsPartyStop(stop) then
		ringColor = "ROUTE_PARTY_RING"
	end
	pin.Disc:SetTexture(ringColor and PARTY_DISC_TEXTURE or DISC_TEXTURE)
	pin.Ring:SetShown(ringColor ~= nil)
	if ringColor then
		pin.Ring:SetVertexColor(ns.GetColorRGB(ringColor))
	end
	local texture
	if task.kind == "corpse" then
		texture = CORPSE_ICON
	elseif task.kind == "turnIn" then
		texture = textures.turnIns[task.questID]
	elseif task.kind == "pickUp" then
		texture = textures.pickUps[task.questID]
	else
		texture = textures.objectives[task.objective]
	end
	texture = texture or (task.kind ~= "corpse" and QuestieIcon(task)) or nil
	pin.Icon:SetTexture(texture)
	-- The corpse's gravestone is a cell of a sheet of icons; Questie's are whole textures
	if task.kind == "corpse" then
		pin.Icon:SetTexCoord(unpack(routes.CORPSE_ICON_COORDS))
	else
		pin.Icon:SetTexCoord(0, 1, 0, 1)
	end
	pin.Icon:SetShown(texture ~= nil)

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
	routes.hoveredStop = nil -- Its pin is gone, and the mouse may never leave it
end

-- The line and the waypoints, on a map of the route's zone
local function DrawRoute(map, mapID, textures)
	local positions = {}
	for i, stop in ipairs(routes.stops) do
		positions[i] = MapPosition(mapID, stop.x, stop.y, stop.instance) or false
	end

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
	if not IsMapShown() then
		return
	end

	local map = self:GetMap()
	local mapID = map:GetMapID()
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
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

-- The route's two frame levels, one under Questie's icons and one over, where the map has the levels for it
local function AddFrameLevels(map)
	local levels = map:GetPinFrameLevelsManager()
	if not pcall(levels.InsertFrameLevelBelow, levels, LINE_LEVEL, QUESTIE_LEVEL) then
		levels:AddFrameLevel(LINE_LEVEL)
	end
	if not pcall(levels.InsertFrameLevelAbove, levels, STOP_LEVEL, QUESTIE_LEVEL) then
		levels:AddFrameLevel(STOP_LEVEL)
	end
	if not pcall(levels.InsertFrameLevelBelow, levels, CAMP_LEVEL, STOP_LEVEL) then
		levels:AddFrameLevel(CAMP_LEVEL)
	end
end

local function AddToWorldMap()
	if provider or not WorldMapFrame then
		return
	end
	WorldMapFrame:HookScript("OnHide", KeepFullSize)
	AddFrameLevels(WorldMapFrame)
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
