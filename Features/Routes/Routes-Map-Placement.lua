local _, ns = ...

--[[
	Routes: where each marker on the world map sits. Markers that overlap are moved apart, and every marker
	stays where it was first put till the map closes, so nothing moves under the mouse (Routes-Map.lua draws them)
]]

local routes = ns.routes

local SPREAD_OVERLAP = 0.75 -- Marker widths apart, middle to middle, two markers can be before one is moved off the other
local SPREAD_RINGS = 2 -- Rings of honeycomb cells around its own place a covered marker is tried in, at most

-- The markers drawn this time, in the order drawn, where each really is, for SpreadPins
local spreadPins = {}
--[[
	The map spreadPins were drawn for. Changing maps zooms the canvas out to the new map before its pins are
	drawn again, so a zoom can come while spreadPins still hold the last map's markers
]]
local spreadMapID

--[[
	Where each marker was put since the map opened, by map and marker: { x, y, offsetX, offsetY }, the place
	it was drawn for and how many marker widths across and down SpreadPins moved it. A redraw while the map is open (an
	ignore, a replan) puts every marker it has here back where it was, so nothing moves under the mouse;
	closing the map forgets them all
]]
local lockedPlaces = {}

local function LockedPlaces(mapID)
	local key = mapID or 0
	lockedPlaces[key] = lockedPlaces[key] or {}
	return lockedPlaces[key]
end

-- A marker by its tasks, the same whether it's drawn as a waypoint or a camp; a flight's landing end is its own
local function MarkerKey(stop, landing)
	local keys = {}
	for i, task in ipairs(stop.tasks or {}) do
		keys[i] = task.key or task.kind or ""
	end
	return table.concat(keys, ",") .. (landing and "@landing" or "")
end

-- Where a marker is drawn on this map: where it was first put since the map opened, or else its own place
local function LockedPosition(mapID, stop, position, landing)
	local place = position and LockedPlaces(mapID)[MarkerKey(stop, landing)]
	if place then
		return { x = place.x, y = place.y }
	end
	return position
end

-- A flight path, flight or change of zone: one place you travel from, whose markers may stack
local function IsTravel(pin)
	local kind = pin.stop.tasks[1] and pin.stop.tasks[1].kind
	return kind == "flightPath" or kind == "fly" or kind == "exit"
end

--[[
	Markers that overlap are moved apart, so each keeps its own hover and right-click: in the order drawn
	(the route's waypoints, then the camps), one whose middle comes within SPREAD_OVERLAP of a marker already
	placed takes the first clear cell of a honeycomb around its own place (HONEYCOMB), so a pile packs into
	a tight blob round the spot rather than a row off to one side. Flight paths, flights and changes of zone
	stay where they are, stacked, placed first so the rest move off them. Worked out in the canvas's pixels
	at this zoom. Only a marker new since the map opened is placed: every other goes back where it was
	(lockedPlaces), the same number of marker widths off at any zoom, so a click, a replan or a zoom never
	moves one. The line still runs to where each was drawn for. It runs on every frame of a zoom, so its
	working lists are kept and wiped rather than made anew
]]
local newPins, placedX, placedY, placedSize = {}, {}, {}, {}

--[[
	The honeycomb's cells, in marker widths from the marker's own place, neighbors one width apart: the
	place itself, then each ring out to SPREAD_RINGS, every ring from the right going clockwise
]]
local HONEYCOMB = { { 0, 0 } }
do
	local ROW = math.sqrt(3) / 2
	local steps = { { -1, 1 }, { -1, 0 }, { 0, -1 }, { 1, -1 }, { 1, 0 }, { 0, 1 } } -- Axial, clockwise from lower left
	for ring = 1, SPREAD_RINGS do
		local q, r = ring, 0
		for _, step in ipairs(steps) do
			for _ = 1, ring do
				HONEYCOMB[#HONEYCOMB + 1] = { q + r / 2, r * ROW }
				q, r = q + step[1], r + step[2]
			end
		end
	end
end

local function Place(x, y, size)
	local index = #placedX + 1
	placedX[index], placedY[index], placedSize[index] = x, y, size
end

local function SpreadPins(map)
	local width, height = map:GetCanvas():GetSize()
	if not (width and height and width > 0 and height > 0) then
		return
	end
	local locked = LockedPlaces(map:GetMapID())
	wipe(newPins)
	wipe(placedX)
	wipe(placedY)
	wipe(placedSize)
	for _, pin in ipairs(spreadPins) do
		pin:ApplyCurrentScale()
		local size = pin:GetWidth() * pin:GetScale()
		local place = locked[pin.markerKey]
		if not place and IsTravel(pin) then
			place = { x = pin.baseX, y = pin.baseY, offsetX = 0, offsetY = 0 }
			locked[pin.markerKey] = place
		end
		if place then
			local x, y = place.x * width + place.offsetX * size, place.y * height + place.offsetY * size
			pin:SetPosition(x / width, y / height)
			Place(x, y, size)
		else
			newPins[#newPins + 1] = pin
		end
	end
	for _, pin in ipairs(newPins) do
		local size = pin:GetWidth() * pin:GetScale()
		local x, y = pin.baseX * width, pin.baseY * height
		local offsetX, offsetY = 0, 0 -- No cell clear: it stays on its own place, over the others
		for _, cell in ipairs(HONEYCOMB) do
			local clear = true
			for index = 1, #placedX do
				local dx, dy = x + cell[1] * size - placedX[index], y + cell[2] * size - placedY[index]
				local reach = SPREAD_OVERLAP * (size + placedSize[index]) / 2
				if dx * dx + dy * dy < reach * reach then
					clear = false
					break
				end
			end
			if clear then
				offsetX, offsetY = cell[1], cell[2]
				break
			end
		end
		locked[pin.markerKey] = { x = pin.baseX, y = pin.baseY, offsetX = offsetX, offsetY = offsetY }
		x, y = x + offsetX * size, y + offsetY * size
		Place(x, y, size)
		pin:SetPosition(x / width, y / height)
	end
end

--------------------------------------------------------------------------------
-- For the Data Provider
--------------------------------------------------------------------------------

routes.MarkerKey = MarkerKey
routes.LockedMarkerPosition = LockedPosition

-- A marker drawn this time that's moved off others (a tail marker isn't)
function routes.SpreadMarker(pin)
	spreadPins[#spreadPins + 1] = pin
end

-- The markers of the last draw, gone with their pins
function routes.ForgetSpreadMarkers()
	wipe(spreadPins)
	spreadMapID = nil
end

-- Every marker drawn on this map placed: each new one moved off the others, the rest back where they were
function routes.SpreadMarkers(map)
	spreadMapID = map:GetMapID()
	SpreadPins(map)
end

--[[
	A moved marker is moved in marker widths, so its move is laid out again as the map zooms or resizes, never
	worked out anew. Not while the canvas is already on another map with the last map's markers still up: they'd
	be locked in at that map's places on this one, and drawn there once this map's are (spreadMapID)
]]
function routes.RespreadMarkers(map)
	if #spreadPins > 0 and spreadMapID == map:GetMapID() then
		SpreadPins(map)
	end
end

-- The map closing: markers are placed afresh the next time it opens
function routes.UnlockMarkerPlaces()
	wipe(lockedPlaces)
end
