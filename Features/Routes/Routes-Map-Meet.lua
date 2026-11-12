local _, ns = ...

--[[
	Routes: Group Up's marker on the world map, where the player is heading to join up with the group
	(Routes-Group-Up.lua). Routes-Map.lua's data provider adds it and takes it away with the route's pins
]]

local routes = ns.routes
local L = ns.L

local MEET_TEMPLATE = "PrettyWideQuestLogRouteMeetPinTemplate"
routes.MEET_TEMPLATE = MEET_TEMPLATE
local MEET_INTERVAL = 0.25 -- Seconds between moves of the join-up marker after the place it marks

-- Placed, sized and layered as a waypoint's marker (Routes-Map.lua)
local MapPosition, IsOnMap, IsWideMap = routes.MapPosition, routes.IsOnMap, routes.IsWideMap
local STOP_SIZE, STOP_ICON_SIZE, STOP_LEVEL = routes.STOP_SIZE, routes.STOP_ICON_SIZE, routes.STOP_LEVEL
local WIDE_MAP_SCALE = routes.WIDE_MAP_SCALE

-- Hovering it: Join Up with Group, as the Quest Arrow says
local function OnMeetEnter(pin)
	if not routes.groupUpTarget then
		return
	end
	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	GameTooltip:AddLine(L["ROUTES_GROUP_UP"], ns.GetColorRGB("TITLE"))
	GameTooltip:Show()
end

local function OnMeetLeave()
	GameTooltip:Hide()
end

--[[
	Follows the place as the group moves, every MEET_INTERVAL. Faded out, not hidden, while they're off this map:
	a hidden pin gets no OnUpdate to bring it back
]]
local function OnMeetUpdate(pin, elapsed)
	pin.sinceMove = (pin.sinceMove or 0) + elapsed
	if pin.sinceMove < MEET_INTERVAL then
		return
	end
	pin.sinceMove = 0
	local target = routes.groupUpTarget
	local position = target and MapPosition(pin:GetMap():GetMapID(), target.x, target.y, target.instance)
	local shown = IsOnMap(position)
	if shown then
		pin:SetPosition(position.x, position.y)
	end
	pin:SetAlpha(shown and 1 or 0)
	pin:EnableMouse(shown)
end

--[[
	Joining up (Routes-Group-Up.lua): a marker where the player is heading, the other member or the middle of
	everyone, a gold disc in a party marker's white ring with the quest log's party icon in blue, the
	size of a waypoint's and over them
]]
function routes.AddMeetPin(map, mapID)
	local target = routes.groupUpTarget
	local position = target and MapPosition(mapID, target.x, target.y, target.instance)
	if not IsOnMap(position) then
		return
	end
	local pin = map:AcquirePin(MEET_TEMPLATE)
	if not pin.routeReady then
		pin.routeReady = true
		pin:SetScript("OnEnter", OnMeetEnter)
		pin:SetScript("OnLeave", OnMeetLeave)
		pin:SetScript("OnUpdate", OnMeetUpdate)
		pin.Disc:SetVertexColor(ns.GetColorRGB("ROUTE_MEET"))
		pin.Ring:SetVertexColor(ns.GetColorRGB("ROUTE_PARTY_RING"))
		pin.Icon:SetVertexColor(ns.GetColorRGB("INFO"))
	end
	pin:SetScalingLimits(1, 1.0, 1.2) -- As a waypoint's (AddStopPin)
	local settings = routes.Settings()
	local size = settings.markerScale
	if IsWideMap(mapID) then
		size = settings.wideMarkerScale * WIDE_MAP_SCALE
	end
	size = size * UIParent:GetEffectiveScale() / map:GetEffectiveScale()
	pin:SetSize(STOP_SIZE * size, STOP_SIZE * size)
	pin.Icon:SetSize(STOP_ICON_SIZE * size, STOP_ICON_SIZE * size)
	pin:UseFrameLevelType(STOP_LEVEL)
	pin:ApplyFrameLevel()
	pin:SetPosition(position.x, position.y)
	pin:ApplyCurrentScale()
	pin:SetAlpha(1)
	pin:EnableMouse(true)
	pin.sinceMove = 0
end
