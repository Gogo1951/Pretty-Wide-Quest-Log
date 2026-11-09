local _, ns = ...

--[[
	Where the player is on the quest map docked to the quest log (Quest-Map.lua), which has no player arrow
	of its own: Blizzard's world map arrow, at the size Blizzard draws it, turned the way the player faces.
	The world map and the minimap are left to Blizzard's own player arrow and party dots.

	It's hidden while the player is off the shown map, or where the game won't say where they are or which
	way they face, as in instances. It moves while they do, every INTERVAL. Only the art hides, never the
	pin, so its OnUpdate keeps watching. Its template is in Quest-Map.xml, and it takes no mouse, so the map
	still drags under it
]]

local PLAYER_TEMPLATE = "PrettyWideQuestLogPlayerPinTemplate"
-- The level it's drawn at, added last on the map so it's over everything
local PLAYER_LEVEL = "PIN_FRAME_LEVEL_PWQL_PLAYER"
local INTERVAL = 0.03 -- Seconds between moves, as often as the Quest Arrow turns

--[[
	Where the player is on a map, 0 to 1 across it, or past it when they're off it. Found the way the Quest
	Arrow and the route's markers find the player (HereBeDragons, Routes-Geography.lua), with Blizzard's own
	answer when Questie's copy of it isn't loaded or has none
]]
local function PlayerMapPosition(mapID)
	local routes = ns.routes
	local hereBeDragons = routes and routes.HereBeDragons()
	if hereBeDragons then
		local x, y, instance = routes.PlayerPosition()
		if x and ns.IsReadable(x, y, instance) then
			local mapX, mapY = hereBeDragons:GetZoneCoordinatesFromWorldInstance(x, y, instance, mapID, true)
			if mapX and mapY then
				return mapX, mapY
			end
		end
	end
	local position = C_Map.GetPlayerMapPosition(mapID, "player")
	if position then
		local x, y = position:GetXY()
		if ns.IsReadable(x, y) then
			return x, y
		end
	end
end

local function PlacePlayer(pin)
	local mapID = pin:GetMap():GetMapID()
	local x, y
	if mapID then
		x, y = PlayerMapPosition(mapID)
	end
	local facing = GetPlayerFacing()
	if not (x and y) or x < 0 or x > 1 or y < 0 or y > 1 or not (facing and ns.IsReadable(facing)) then
		pin.Arrow:Hide()
		return
	end
	pin:SetPosition(x, y)
	pin.Arrow:SetRotation(facing)
	pin.Arrow:Show()
end

local function OnUpdate(pin, elapsed)
	pin.sinceMove = (pin.sinceMove or 0) + elapsed
	if pin.sinceMove >= INTERVAL then
		pin.sinceMove = 0
		PlacePlayer(pin)
	end
end

local providerMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function providerMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(PLAYER_TEMPLATE)
end

function providerMixin:RefreshAllData()
	self:RemoveAllData()
	local pin = self:GetMap():AcquirePin(PLAYER_TEMPLATE)
	pin:UseFrameLevelType(PLAYER_LEVEL)
	pin:ApplyFrameLevel()
	pin:SetScript("OnUpdate", OnUpdate)
	PlacePlayer(pin)
	pin:ApplyCurrentScale()
end

--[[
	The level the player is drawn at, added on top of a map's others. The quest map calls it once it has
	added its own, before the map first draws
]]
function ns.AddPlayerPinLevel(map)
	map:GetPinFrameLevelsManager():AddFrameLevel(PLAYER_LEVEL)
end

function ns.AddPlayerPin(map)
	map:AddDataProvider(CreateFromMixins(providerMixin))
end
