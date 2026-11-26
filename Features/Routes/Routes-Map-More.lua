local ADDON_NAME, ns = ...

--[[
	Routes: Waypoints Shown on the world map. The zone map draws only the next few waypoints, then the "…"
	marker where it stops, on the first hidden waypoint and over every marker; hovering it brings in the rest
	of the route faintly, and clicking it draws the whole route till the map closes (Routes-Map.lua draws the rest)
]]

local routes = ns.routes
local L = ns.L

--[[
	The "…" marker: a pill MORE_HEIGHT tall and twice as wide at Medium, never nearer the last waypoint
	shown than MORE_GAP, middle to middle, so neither covers the other. Hovering it draws the rest of the
	route at TAIL_ALPHA
]]
local MORE_TEMPLATE = "PrettyWideQuestLogRouteMorePinTemplate"
local MORE_HEIGHT = ns.LAYOUT.SPACE.GROUP
local MORE_GAP = ns.LAYOUT.SPACE.SECTION
local TAIL_ALPHA = 0.5
local IMAGES = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\"

local MORE_LEVEL = routes.MORE_LEVEL -- Routes-Map.lua
local IsOnMap = routes.IsOnMap -- Routes-Map.lua
local MarkerSize = routes.MapMarkerSize -- Routes-Map.lua

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

-- Draws the whole route, every marker hoverable, the "…" gone, till the map closes
local function ShowWholeRoute()
	routes.CloseMapMenu()
	wholeRouteShown = true
	routes.RedrawRouteMap()
end

-- The "…" marker's menu: how many waypoints it hides as the header with PWQL on the right, what it's for, and Show the Whole Route as a row
local function MoreMenuEntries(pin, hidden)
	if pin.hidden ~= hidden then
		return nil
	end
	local rows = routes.MapMenuRows()
	local title = hidden == 1 and L["ROUTES_MORE_WAYPOINT"] or L["ROUTES_MORE_WAYPOINTS"]:format(hidden or 0)
	rows:AddLine(title, ns.GetColorRGB("TITLE"))
	rows:MakeHeader()
	local red, green, blue = ns.GetColorRGB("HELP")
	rows:AddLine(L["ROUTES_MORE_WAYPOINTS_DESCRIPTION"], red, green, blue, true)
	rows:AddHints({ { nil, L["ROUTES_CLICK_SHOW_ROUTE"], ShowWholeRoute } })
	return rows.entries
end

-- Opens its menu and draws the rest of the route faintly while it's open
local function OnMoreEnter(pin)
	local hidden = pin.hidden
	local opened = routes.OpenMapMenu(pin, hidden, function()
		return MoreMenuEntries(pin, hidden)
	end, function()
		ShowTail(0)
	end)
	if opened then
		ShowTail(TAIL_ALPHA)
	end
end

-- Clicking it shows the whole route, as its menu's row does
local function OnMoreMouseUp(_, button)
	if button == "LeftButton" then
		ShowWholeRoute()
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
	pin:SetScript("OnEnter", OnMoreEnter) -- Its menu closes itself, as a stop's does
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
	pin:SetScalingLimits(1, 1.0, 1.2) -- As a waypoint's (AddStopPin, Routes-Map.lua)
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
-- For the Data Provider
--------------------------------------------------------------------------------

routes.MORE_TEMPLATE = MORE_TEMPLATE
routes.LastShownWaypoint = LastShown
routes.AddMoreMarker = AddMorePin

-- A marker in the hidden tail, shown faintly while the "…" marker's menu is open
function routes.AddTailMarker(pin)
	tailPins[#tailPins + 1] = pin
end

-- The route's line, from this draw, for the "…" marker's hover
function routes.SetRouteLine(pin)
	routeLine = pin
end

--[[
	Forgotten before the pins go: releasing the "…" marker under the mouse hides it, and the "…" menu's
	close callback (ShowTail) would reach a line pin already released, off any map
]]
function routes.ForgetTail()
	wipe(tailPins)
	routeLine = nil
end

-- A click on the "…" marker shows the whole route only while the map stays open
function routes.ForgetWholeRoute()
	wholeRouteShown = false
end
