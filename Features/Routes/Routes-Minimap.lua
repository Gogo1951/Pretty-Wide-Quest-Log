local ADDON_NAME, ns = ...

--[[
	Routes: the route's waypoints on the minimap, the zone map's markers made small, while Show Waypoint
	Markers on the Mini-Map is on (Maps & Objectives > Mini-Map). Off by default: Questie's own minimap icons
	show each spawn and drop exactly, where a waypoint stands for a whole camp, so Questie's icons are never
	hidden here. Placed through Questie's copy of HereBeDragons-Pins, as Questie places its own, so they turn
	and zoom with the minimap. Hovering one lists its quests, as the zone map's markers do; the minimap takes
	no clicks for them, so a click still pings the minimap
]]

local routes = ns.routes

local PIN_REF = "PrettyWideQuestLogRouteMinimap" -- HereBeDragons-Pins keeps each add-on's icons under its own name
--[[
	A marker and its icon at Medium: three quarters of the zone map's 32 and 16 pixels, as big as Questie's
	own minimap icons beside them, picked by eye as the zone map's were. The disc's ring takes the outer
	eighth on each side, so the icon's half of it clears the ring, corners and all
]]
local MARKER_SIZE, MARKER_ICON_SIZE = 24, 12
local NO_TEXTURES = { objectives = {}, turnIns = {}, pickUps = {} } -- Questie's icon for each kind, not its pins'

local markers = {} -- Every marker made, handed out again in order
local hereBeDragonsPins

local function Pins()
	hereBeDragonsPins = hereBeDragonsPins or ns.QuestieHereBeDragonsPins()
	return hereBeDragonsPins
end

local function OnMarkerEnter(marker)
	GameTooltip:SetOwner(marker, "ANCHOR_RIGHT")
	routes.AddStopTooltip(GameTooltip, marker.stop)
	GameTooltip:Show()
end

local function OnMarkerLeave()
	GameTooltip:Hide()
end

-- A marker as the zone map's stop template draws one (Routes.xml): the disc, the ring over it, the icon on top
local function NewMarker()
	local marker = CreateFrame("Frame")
	marker.Disc = marker:CreateTexture(nil, "ARTWORK", nil, 0)
	marker.Disc:SetAllPoints()
	marker.Ring = marker:CreateTexture(nil, "ARTWORK", nil, 1)
	marker.Ring:SetTexture("Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Stop-Ring")
	marker.Ring:SetAllPoints()
	marker.Ring:Hide()
	marker.Icon = marker:CreateTexture(nil, "ARTWORK", nil, 2)
	marker.Icon:SetPoint("CENTER")
	marker:SetScript("OnEnter", OnMarkerEnter)
	marker:SetScript("OnLeave", OnMarkerLeave)
	marker:EnableMouseMotion(true) -- Hovered for its tooltip, clicked through to the minimap
	marker:Hide() -- HereBeDragons-Pins shows it, once it's placed
	return marker
end

-- Whether the minimap shows the route: with the Waypoint Markers on, and never on a flight path, where it's planned again on landing
local function IsShown()
	local settings = routes.Settings()
	return routes.IsMapShown() and settings.showMinimapMarkers and not routes.IsOnTaxi()
end

-- Places a marker on the minimap for each waypoint on the route, and takes away the last ones
local function Refresh()
	local pins = Pins()
	if not pins then
		return
	end
	pins:RemoveAllMinimapIcons(PIN_REF)
	if not IsShown() then
		return
	end
	local size = routes.Settings().minimapMarkerScale
	local count = 0
	for _, stop in ipairs(routes.stops) do
		if stop.x and stop.y and stop.instance then
			count = count + 1
			local marker = markers[count] or NewMarker()
			markers[count] = marker
			marker:SetSize(MARKER_SIZE * size, MARKER_SIZE * size)
			marker.Icon:SetSize(MARKER_ICON_SIZE * size, MARKER_ICON_SIZE * size)
			marker.stop = stop
			routes.ApplyStopLook(marker, stop, NO_TEXTURES)
			-- Placed, shown and hidden by HereBeDragons-Pins as the player moves, so a reused one keeps no old spot
			marker:ClearAllPoints()
			pins:AddMinimapIconWorld(PIN_REF, marker, stop.instance, stop.x, stop.y, false)
		end
	end
end

routes.AddListener(Refresh)
routes.OnLogin(Refresh)
