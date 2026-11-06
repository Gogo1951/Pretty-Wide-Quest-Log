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
local QUESTIE_TEMPLATE = "HereBeDragonsPinsTemplateQuestie" -- The pins Questie's icons sit on
local LINE_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_LINE" -- Under Questie's icons
local STOP_LEVEL = "PIN_FRAME_LEVEL_PWQL_ROUTE_STOP" -- Over them
local QUESTIE_LEVEL = "PIN_FRAME_LEVEL_AREA_POI" -- Where HereBeDragons-Pins puts Questie's icons

local DOT_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Dot"
-- A stop's disc: with its black ring, or the fill alone, under a party member's stop's white ring
local DISC_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Stop"
local PARTY_DISC_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Stop-Fill"
local CORPSE_ICON = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull" -- On a ghost's first stop, their corpse
local LINE_WIDTH = ns.LAYOUT.SPACE.NEAR -- On screen, whatever the zoom; the dot art is three quarters of it across
local DOT_SPACING = ns.LAYOUT.SPACE.GROUP -- On screen: one dot and its gap
local UPDATE_INTERVAL = 0.05 -- Seconds between moves of the ants and the player's end of the line

--[[
	The mixin of the route's pin templates in Routes.xml, which load after this file. The map canvas lets right
	clicks pass through every pin it makes, with SetPassThroughButtons, which WoW blocks in combat: opening the
	map in combat then blames this addon. The stop pins take their own right clicks (skipping the stop) and the
	line takes no mouse, so neither wants it, as HereBeDragons-Pins does for Questie's pins
]]
PrettyWideQuestLogRoutePinMixin = CreateFromMixins(MapCanvasPinMixin)
function PrettyWideQuestLogRoutePinMixin.SetPassThroughButtons() end

local HBD, HBDPins

local function Libraries()
	HBD = HBD or LibStub("HereBeDragonsQuestie-2.0", true)
	HBDPins = HBDPins or LibStub("HereBeDragonsQuestie-Pins-2.0", true)
	return HBD, HBDPins
end

-- Where a point in world yards falls on a map (0-1, or past it), or nothing on another continent
local function MapPosition(mapID, x, y, instance)
	local hbd = Libraries()
	if not (hbd and x) then
		return nil
	end
	local mapX, mapY = hbd:GetZoneCoordinatesFromWorldInstance(x, y, instance, mapID, true)
	if mapX and mapY then
		return { x = mapX, y = mapY }
	end
end

local function IsOnMap(position)
	return position and position.x >= 0 and position.x <= 1 and position.y >= 0 and position.y <= 1
end

local function IsRouteShown()
	local settings = routes.Settings()
	return settings.enabled and settings.showMap and #routes.stops > 0
end

--------------------------------------------------------------------------------
-- Questie's icons
--------------------------------------------------------------------------------

--[[
	Notes a task's objective or turn-in in the sets: a party objective by its quest and place in it too,
	as Questie's map icons for a party member's objective hold an objective of Questie's own making
]]
local function NoteTask(task, objectives, turnIns)
	if task.kind == "turnIn" then
		turnIns[task.questID] = true
	elseif task.objective then
		objectives[task.objective] = true
		if task.objective.party then
			objectives[routes.PartyObjectiveKey(task.questID, task.objective.Index)] = true
		end
	end
end

--[[
	What the route stands in for: each objective on it, and each quest it turns in. Questie's icons for
	these are hidden while the route shows, and lend the markers their look
]]
local function RouteTasks()
	local objectives, turnIns = {}, {}
	for _, stop in ipairs(routes.stops) do
		for _, task in ipairs(stop.tasks) do
			NoteTask(task, objectives, turnIns)
		end
	end
	return objectives, turnIns
end

-- The stop under the mouse, whose objectives' icons Questie shows again while it's hovered
local hoveredStop

local function HoveredTasks()
	local objectives, turnIns = {}, {}
	for _, task in ipairs(hoveredStop and hoveredStop.tasks or {}) do
		NoteTask(task, objectives, turnIns)
	end
	return objectives, turnIns
end

local function IsRouteIcon(data, objectives, turnIns)
	if data.Type == "complete" then
		return turnIns[data.Id]
	end
	local objective = data.Type ~= "available" and data.ObjectiveData
	if not objective then
		return false
	end
	return objectives[objective]
		or (objective.IsPartyObjective and objectives[routes.PartyObjectiveKey(objective.questId, objective.Index)])
end

--[[
	Hides the pins holding Questie's icons for what the route stands in for, but for the hovered stop's,
	and shows again any it hid before that no longer are. The pins are HereBeDragons', which Questie never shows or hides itself, so
	Questie's own icon state is left alone, and a pin handed out again shows on its own
]]
local function ApplyQuestieIcons()
	if not WorldMapFrame then
		return
	end
	local hide = IsRouteShown() and routes.Settings().hideQuestieIcons
	local objectives, turnIns = RouteTasks()
	local hoveredObjectives, hoveredTurnIns = HoveredTasks()
	for pin in WorldMapFrame:EnumeratePinsByTemplate(QUESTIE_TEMPLATE) do
		local data = pin.icon and pin.icon.data
		local hidden = hide
			and data
			and IsRouteIcon(data, objectives, turnIns)
			and not IsRouteIcon(data, hoveredObjectives, hoveredTurnIns)
		if hidden then
			pin:Hide()
			pin.hiddenByRoute = true
		elseif pin.hiddenByRoute then
			pin:Show()
			pin.hiddenByRoute = nil
		end
	end
end

-- Questie draws in batches, a pin at a time, so the icons are checked again once a batch is done
local applyPending
local function RequestApplyQuestieIcons()
	if applyPending then
		return
	end
	applyPending = true
	C_Timer.After(0, function()
		applyPending = nil
		ApplyQuestieIcons()
	end)
end

-- The texture of Questie's icon for each objective on the route, and for each quest's turn-in, on the map shown
local function QuestieTextures()
	local byObjective, byTurnIn = {}, {}
	for pin in WorldMapFrame:EnumeratePinsByTemplate(QUESTIE_TEMPLATE) do
		local icon = pin.icon
		local data = icon and icon.data
		if data and icon.texture then
			if data.Type == "complete" then
				byTurnIn[data.Id] = byTurnIn[data.Id] or icon.texture:GetTexture()
			elseif data.ObjectiveData and not byObjective[data.ObjectiveData] then
				byObjective[data.ObjectiveData] = icon.texture:GetTexture()
			end
		end
	end
	return byObjective, byTurnIn
end

--------------------------------------------------------------------------------
-- The line
--------------------------------------------------------------------------------

--[[
	One pin as large as the map. Each leg is a line of the dot art repeated along its length; sliding the
	art along makes the dots march. The pin zooms with the map, so the width and the dots' spacing are
	kept the same on screen
]]
local linePinMixin = {}

function linePinMixin:CanvasScale()
	return self:GetMap():GetCanvasScale()
end

function linePinMixin:NewLeg()
	local leg = {}
	leg.line = self:CreateLine(nil, "ARTWORK")
	leg.line:SetTexture(DOT_TEXTURE, "REPEAT", "CLAMP")
	return leg
end

-- Puts a leg between two map positions (0-1)
function linePinMixin:PlaceLeg(leg, from, to)
	local width, height = self:GetSize()
	local ax, ay, bx, by = from.x * width, -from.y * height, to.x * width, -to.y * height
	leg.line:SetStartPoint("TOPLEFT", self, ax, ay)
	leg.line:SetEndPoint("TOPLEFT", self, bx, by)
	leg.line:Show()
	leg.length = math.sqrt((bx - ax) ^ 2 + (by - ay) ^ 2)
end

function linePinMixin:HideLeg(leg)
	leg.line:Hide()
	leg.length = nil
end

function linePinMixin:ApplyWidths()
	local scale = self:CanvasScale()
	for _, leg in ipairs(self.legs) do
		leg.line:SetThickness(LINE_WIDTH / scale)
	end
end

-- Slides the dot art along every leg, by the time, so they march toward the next stop
function linePinMixin:MarchAnts()
	local scale = self:CanvasScale()
	local phase = (GetTime() * (self.speed or 0)) % 1
	for _, leg in ipairs(self.legs) do
		if leg.length then
			local dots = leg.length * scale / DOT_SPACING
			leg.line:SetTexCoord(-phase, dots - phase, 0, 1)
		end
	end
end

local playerPosition = {}

-- The player's end of the first leg moves with the player
function linePinMixin:PlacePlayerLeg()
	local leg, first = self.legs[1], self.positions[1]
	local x, y, instance = routes.PlayerPosition()
	local hbd = Libraries()
	local mapX, mapY
	if first and hbd and x then
		mapX, mapY = hbd:GetZoneCoordinatesFromWorldInstance(x, y, instance, self.mapID, true)
	end
	-- One table, reused: this runs many times a second while the map is open
	local player = mapX and mapY and playerPosition
	if player then
		player.x, player.y = mapX, mapY
		self:PlaceLeg(leg, player, first)
	else
		self:HideLeg(leg)
	end
end

-- Draws every leg: the player's to the first stop, then stop to stop. positions[i] is stop i's, or false
function linePinMixin:Draw(mapID, positions)
	local settings = routes.Settings()
	if not settings.showLine then
		positions = {} -- Markers only: no legs, and nothing to follow the player with
	end
	self.mapID, self.positions, self.speed = mapID, positions, settings.lineSpeed
	local needed = #positions
	for i = #self.legs + 1, needed do
		self.legs[i] = self:NewLeg()
	end
	for i = 2, needed do
		local from, to = positions[i - 1], positions[i]
		if from and to then
			self:PlaceLeg(self.legs[i], from, to)
		else
			self:HideLeg(self.legs[i])
		end
	end
	for i = needed + 1, #self.legs do
		self:HideLeg(self.legs[i])
	end
	if needed > 0 then
		self:PlacePlayerLeg()
	end
	local red, green, blue = ns.GetColorRGB("ROUTE_LINE") -- As see-through as the lineOpacity setting
	for _, leg in ipairs(self.legs) do
		leg.line:SetVertexColor(red, green, blue, settings.lineOpacity)
	end
	self:ApplyWidths()
	self:MarchAnts()
end

function linePinMixin:OnCanvasScaleChanged()
	self:ApplyWidths()
	self:MarchAnts()
end

local function OnLinePinUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < UPDATE_INTERVAL then
		return
	end
	self.elapsed = 0
	if #self.positions > 0 then
		self:PlacePlayerLeg()
	end
	self:MarchAnts()
end

--------------------------------------------------------------------------------
-- The stops
--------------------------------------------------------------------------------

local provider

-- Shows Questie's icons for the stop's objectives and lists its quests, each player's progress laid out as the quest log's
local function OnStopEnter(pin)
	hoveredStop = pin.stop
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
	if not pin.stop.corpse then
		hints[#hints + 1] = { L["ROUTES_CLICK_RIGHT"], L["ROUTES_RIGHT_CLICK_REROUTE"] }
	end
	hints[#hints + 1] = { L["ROUTES_CLICK_MIDDLE"], L["ROUTES_MIDDLE_CLICK_RESET"] }
	routes.AddClickHints(GameTooltip, hints)
	GameTooltip:Show()
end

local function OnStopLeave()
	if hoveredStop then
		hoveredStop = nil
		ApplyQuestieIcons()
	end
	GameTooltip:Hide()
end

local function OnStopMouseUp(pin, button)
	if button == "RightButton" then
		OnStopLeave()
		routes.SkipStop(pin.stop)
	elseif button == "MiddleButton" then
		OnStopLeave()
		routes.ResetObjectives()
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
	if task.kind == "turnIn" then
		return icons[Questie.ICON_TYPE_COMPLETE]
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
	for _, task in ipairs(stop.tasks) do
		if not task.party then
			return false
		end
	end
	return true
end

local function AddStopPin(map, stop, position, textures)
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
	pin:SetSize(STOP_SIZE * size, STOP_SIZE * size)
	pin.Icon:SetSize(STOP_ICON_SIZE * size, STOP_ICON_SIZE * size)
	pin.stop = stop

	--[[
		The first task's look: its objective's color and Questie's icon for it, or the turn-in's: the one on
		Questie's own pins, else the one Questie draws that kind with
	]]
	local task = stop.tasks[1]
	pin.Disc:SetVertexColor(routes.TaskColor(task))
	local isParty = IsPartyStop(stop)
	pin.Disc:SetTexture(isParty and PARTY_DISC_TEXTURE or DISC_TEXTURE)
	pin.Ring:SetShown(isParty)
	local texture
	if task.kind == "corpse" then
		texture = CORPSE_ICON
	elseif task.kind == "turnIn" then
		texture = textures.turnIns[task.questID]
	else
		texture = textures.objectives[task.objective]
	end
	texture = texture or (task.kind ~= "corpse" and QuestieIcon(task)) or nil
	pin.Icon:SetTexture(texture)
	pin.Icon:SetShown(texture ~= nil)

	pin:UseFrameLevelType(STOP_LEVEL)
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
	hoveredStop = nil -- Its pin is gone, and the mouse may never leave it
end

function providerMixin:RefreshAllData()
	self:RemoveAllData()
	ApplyQuestieIcons()
	if not IsRouteShown() then
		return
	end

	local map = self:GetMap()
	local mapID = map:GetMapID()
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

	local byObjective, byTurnIn = QuestieTextures()
	local textures = { objectives = byObjective, turnIns = byTurnIn }
	for i, stop in ipairs(routes.stops) do
		if IsOnMap(positions[i]) then
			AddStopPin(map, stop, positions[i], textures)
		end
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
end

--[[
	The map opens full size through its own miniWorldMap setting, which every client's map reads as it
	opens and maximizes itself by: calling its Maximize from here would run Blizzard's panel layout
	(SetUIPanelAttribute, MaximizeUIPanel) as add-on code. Kept off while the option is on, set again after
	the player shrinks the map, and never written in combat
]]
local function KeepFullSize()
	local settings = routes.Settings()
	if not (settings.fullSizeMap and settings.enabled and settings.showMap) or InCombatLockdown() then
		return
	end
	if GetCVarBool("miniWorldMap") then
		SetCVar("miniWorldMap", "0")
		routes.Print(L["CHAT_FULL_SIZE_MAP_SET"])
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

	-- Questie's pins come and go as it draws; the ones the route stands in for stay hidden
	local _, pins = Libraries()
	local questieProvider = pins and pins.worldmapProvider
	if questieProvider then
		for _, name in ipairs({ "RefreshAllData", "HandlePin" }) do
			if questieProvider[name] then
				hooksecurefunc(questieProvider, name, RequestApplyQuestieIcons)
			end
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
		end
	end
end)
