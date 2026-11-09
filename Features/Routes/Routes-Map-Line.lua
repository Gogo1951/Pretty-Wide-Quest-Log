local _, ns = ...

--[[
	Routes: the route's line on the world map, a line of small dots marching from the player through every
	waypoint (Routes-Map.lua draws it)
]]

local routes = ns.routes

local DOT_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Dot"
local LINE_WIDTH = ns.LAYOUT.SPACE.NEAR -- On screen, whatever the zoom; the dot art is three quarters of it across
local DOT_SPACING = ns.LAYOUT.SPACE.GROUP -- On screen: one dot and its gap
local UPDATE_INTERVAL = 0.05 -- Seconds between moves of the ants and the player's end of the line

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
	local hereBeDragons = routes.HereBeDragons()
	local mapX, mapY
	if first and hereBeDragons and x then
		mapX, mapY = hereBeDragons:GetZoneCoordinatesFromWorldInstance(x, y, instance, self.mapID, true)
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

-- The line pin takes these as Routes-Map.lua acquires it
routes.RouteLinePinMixin = linePinMixin
routes.OnRouteLinePinUpdate = OnLinePinUpdate
