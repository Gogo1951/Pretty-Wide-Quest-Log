local ADDON_NAME, ns = ...

--[[
	Routes: the route's line on the world map, a line of small dots marching from the player through every
	waypoint (Routes-Map.lua draws it). While joining up with the group (Routes-Group-Up.lua) it runs to the
	join-up spot first, and on from there
]]

local routes = ns.routes

local DOT_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Dot"
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

-- A leg's color, as see-through as the lineOpacity setting, and its width
function linePinMixin:DressLeg(leg)
	local red, green, blue = ns.GetColorRGB("ROUTE_LINE")
	leg.line:SetVertexColor(red, green, blue, routes.Settings().lineOpacity)
	leg.line:SetThickness(LINE_WIDTH / self:CanvasScale())
end

-- Every leg's width, the join-up leg's too (PlacePlayerLeg)
function linePinMixin:ApplyWidths()
	local thickness = LINE_WIDTH / self:CanvasScale()
	for _, leg in ipairs(self.legs) do
		leg.line:SetThickness(thickness)
	end
	if self.meetLeg then
		self.meetLeg.line:SetThickness(thickness)
	end
end

local function MarchLeg(leg, scale, phase)
	if leg.length then
		local dots = leg.length * scale / DOT_SPACING
		leg.line:SetTexCoord(-phase, dots - phase, 0, 1)
	end
end

-- Slides the dot art along every leg, the join-up leg too, by the time, so they march toward the next stop
function linePinMixin:MarchAnts()
	local scale = self:CanvasScale()
	local phase = (GetTime() * (self.speed or 0)) % 1
	for _, leg in ipairs(self.legs) do
		MarchLeg(leg, scale, phase)
	end
	if self.meetLeg then
		MarchLeg(self.meetLeg, scale, phase)
	end
end

-- One table each, reused: these run many times a second while the map is open
local playerPosition, meetPosition = {}, {}

-- A place in world yards on this pin's map, into the table given, or nothing off its continent
function linePinMixin:MapPoint(into, x, y, instance)
	local hereBeDragons = routes.HereBeDragons()
	if not (hereBeDragons and x) then
		return nil
	end
	local mapX, mapY = hereBeDragons:GetZoneCoordinatesFromWorldInstance(x, y, instance, self.mapID, true)
	if not (mapX and mapY) then
		return nil
	end
	into.x, into.y = mapX, mapY
	return into
end

--[[
	The player's end of the first leg moves with the player. While joining up, the first leg runs from the
	join-up spot instead, as it moves, and the join-up leg from the player to it
]]
function linePinMixin:PlacePlayerLeg()
	local leg, first = self.legs[1], self.positions[1]
	local player = first and self:MapPoint(playerPosition, routes.PlayerPosition())
	local target = routes.groupUpTarget
	local meet = player and target and self:MapPoint(meetPosition, target.x, target.y, target.instance)
	if meet then
		if not self.meetLeg then
			self.meetLeg = self:NewLeg()
			self:DressLeg(self.meetLeg) -- Made between draws, so it takes the line's look now
		end
		self:PlaceLeg(self.meetLeg, player, meet)
		self:PlaceLeg(leg, meet, first)
	elseif player then
		self:PlaceLeg(leg, player, first)
	else
		self:HideLeg(leg)
	end
	if self.meetLeg and not meet then
		self:HideLeg(self.meetLeg)
	end
end

-- Draws every leg: the player's to the first stop, then stop to stop. positions[i] is stop i's, or false
function linePinMixin:Draw(mapID, positions)
	local settings = routes.Settings()
	if not settings.showLine then
		positions = {} -- Quest Route off, Waypoint Markers only: no legs, and nothing to follow the player with
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
	elseif self.meetLeg then
		self:HideLeg(self.meetLeg)
	end
	for _, leg in ipairs(self.legs) do
		self:DressLeg(leg)
	end
	if self.meetLeg then
		self:DressLeg(self.meetLeg)
	end
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
