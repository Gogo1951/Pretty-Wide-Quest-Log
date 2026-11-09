local _, ns = ...

--[[
	Where the player and their party are, on the world map (Routes-Map.lua adds them there), the quest map
	docked to the quest log (Quest-Map.lua), and for the player the minimap. The player is the Quest Arrow's
	arrow (Routes-Arrow.lua) in their class color, turned the way they face; each party member a disc in
	theirs, the one the route's waypoints are drawn on (Route-Stop, black ring and all). They stand in for
	Blizzard's own player arrow and party dots, hidden where they can be. In a raid, Blizzard's raid dots
	are left as they are, as forty of these would bury the map.

	On the maps each is hidden while its unit is off the shown map, or where the game won't say where they
	are, as in instances. They move while their units do, every INTERVAL. Only the art hides, never the pin,
	so its OnUpdate keeps watching. Their templates are in Quest-Map.xml. The arrow takes no mouse; a disc
	takes only the mouse's motion, to name its member on hover as Blizzard's dots did, so the map still
	drags under both
]]

-- The owner of this file's event handlers in Core.lua's EVENTS
local playerMapPin = {}
ns.playerMapPin = playerMapPin

local PLAYER_TEMPLATE = "PrettyWideQuestLogPlayerPinTemplate"
local PARTY_TEMPLATE = "PrettyWideQuestLogPartyPinTemplate"
-- The levels they're drawn at, added last on each map so they're over everything, the player over the party
local PARTY_LEVEL = "PIN_FRAME_LEVEL_PWQL_PARTY"
local PLAYER_LEVEL = "PIN_FRAME_LEVEL_PWQL_PLAYER"
local INTERVAL = 0.03 -- Seconds between moves, as often as the Quest Arrow turns
local PARTY_UNITS = { "party1", "party2", "party3", "party4" }
-- The arrow already in each class's color, one file per class (WARRIOR.tga), for the minimap, which can't tint it
local CLASS_ARROWS = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Player-Arrow\\"
local CLASS_ARROW_FILES = {
	WARRIOR = true,
	PALADIN = true,
	HUNTER = true,
	ROGUE = true,
	PRIEST = true,
	DEATHKNIGHT = true,
	SHAMAN = true,
	MAGE = true,
	WARLOCK = true,
	MONK = true,
	DRUID = true,
	DEMONHUNTER = true,
	EVOKER = true,
}

local function UnitClassFile(unit)
	local _, class = UnitClass(unit)
	if class and ns.IsReadable(class) then
		return class
	end
end

local function ClassColor(unit)
	local class = UnitClassFile(unit)
	local color = class and RAID_CLASS_COLORS[class]
	if color then
		return color.r, color.g, color.b
	end
	return 1, 1, 1
end

--[[
	Where a unit is on a map, 0 to 1 across it, or past it when they're off it. Found the way the Quest
	Arrow and the route's markers find the player (HereBeDragons, Routes-Geography.lua), with Blizzard's own
	answer when Questie's copy of it isn't loaded or has none
]]
local function UnitMapPosition(mapID, unit)
	local routes = ns.routes
	local hereBeDragons = routes and routes.HereBeDragons()
	if hereBeDragons then
		local x, y, instance
		if unit == "player" then
			x, y, instance = routes.PlayerPosition()
		else
			x, y, instance = hereBeDragons:GetUnitWorldPosition(unit)
		end
		if x and ns.IsReadable(x, y, instance) then
			local mapX, mapY = hereBeDragons:GetZoneCoordinatesFromWorldInstance(x, y, instance, mapID, true)
			if mapX and mapY then
				return mapX, mapY
			end
		end
	end
	local position = C_Map.GetPlayerMapPosition(mapID, unit)
	if position then
		local x, y = position:GetXY()
		if ns.IsReadable(x, y) then
			return x, y
		end
	end
end

-- Puts a pin where its unit is on its map, and returns whether it's on it
local function PlaceOnMap(pin, unit)
	local mapID = pin:GetMap():GetMapID()
	local x, y
	if mapID then
		x, y = UnitMapPosition(mapID, unit)
	end
	if not (x and y) or x < 0 or x > 1 or y < 0 or y > 1 then
		return false
	end
	pin:SetPosition(x, y)
	return true
end

local function PlacePlayer(pin)
	if not PlaceOnMap(pin, "player") then
		pin.Arrow:Hide()
		return
	end
	pin.Arrow:SetRotation(GetPlayerFacing() or 0)
	pin.Arrow:Show()
end

-- A party member's disc, in their class color; none in a raid, where Blizzard's raid dots show them
local function PlacePartyMember(pin)
	local unit = pin.unit
	if IsInRaid() or not UnitExists(unit) or not PlaceOnMap(pin, unit) then
		pin.Disc:Hide()
		return
	end
	pin.Disc:SetVertexColor(ClassColor(unit))
	pin.Disc:Show()
end

local function OnUpdate(pin, elapsed)
	pin.sinceMove = (pin.sinceMove or 0) + elapsed
	if pin.sinceMove >= INTERVAL then
		pin.sinceMove = 0
		pin.Place(pin)
	end
end

-- The member's name in their class color, as Blizzard's dots showed it
local function OnPartyEnter(pin)
	if not pin.Disc:IsShown() then
		return
	end
	local name = UnitName(pin.unit)
	if not (name and ns.IsReadable(name)) then
		return
	end
	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	GameTooltip:SetText(name, ClassColor(pin.unit))
	GameTooltip:Show()
end

local function OnPartyLeave(pin)
	if GameTooltip:GetOwner() == pin then
		GameTooltip:Hide()
	end
end

-- The size set in its template, growing a little as the map zooms in, like Questie's icons (Questie-Map.lua)
local function SetUp(pin, level, place)
	pin:UseFrameLevelType(level)
	pin:ApplyFrameLevel()
	pin:SetScalingLimits(1, 1.0, 1.2)
	pin.Place = place
	pin:SetScript("OnUpdate", OnUpdate)
	place(pin)
	pin:ApplyCurrentScale()
end

local providerMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function providerMixin:RemoveAllData()
	local map = self:GetMap()
	map:RemoveAllPinsByTemplate(PARTY_TEMPLATE)
	map:RemoveAllPinsByTemplate(PLAYER_TEMPLATE)
end

function providerMixin:RefreshAllData()
	self:RemoveAllData()
	local map = self:GetMap()
	for _, unit in ipairs(PARTY_UNITS) do
		local pin = map:AcquirePin(PARTY_TEMPLATE)
		pin.unit = unit
		-- Motion only, for the name on hover; clicks and drags still reach the map
		pin:SetMouseMotionEnabled(true)
		pin:SetMouseClickEnabled(false)
		pin:SetScript("OnEnter", OnPartyEnter)
		pin:SetScript("OnLeave", OnPartyLeave)
		SetUp(pin, PARTY_LEVEL, PlacePartyMember)
	end
	local pin = map:AcquirePin(PLAYER_TEMPLATE)
	pin.Arrow:SetVertexColor(ClassColor("player"))
	SetUp(pin, PLAYER_LEVEL, PlacePlayer)
end

--[[
	The levels the player and their party are drawn at, added on top of a map's others. Each map calls it
	once it has added its own, before the map first draws
]]
function ns.AddGroupPinLevels(map)
	local levels = map:GetPinFrameLevelsManager()
	levels:AddFrameLevel(PARTY_LEVEL)
	levels:AddFrameLevel(PLAYER_LEVEL)
end

function ns.AddPlayerPin(map)
	map:AddDataProvider(CreateFromMixins(providerMixin))
end

--[[
	Hides Blizzard's own player arrow and party dots on a map (the world map's GroupMembersPinTemplate),
	which would otherwise show around the edges of these. Raid members stay. Only the pin's own widget
	call, never its Lua fields, so nothing of Blizzard's map is tainted; it's done again whenever Blizzard
	works out who to show
]]
local function HideBlizzardUnits(pin)
	pin:SetShouldShowUnits("player", false)
	pin:SetShouldShowUnits("party", false)
end

function ns.HideBlizzardGroupPins(map)
	for pin in map:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
		if pin.SetShouldShowUnits then
			HideBlizzardUnits(pin)
			if pin.UpdateShownUnits then
				hooksecurefunc(pin, "UpdateShownUnits", HideBlizzardUnits)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- The minimap
--------------------------------------------------------------------------------

--[[
	The minimap's arrow is drawn by the game, which turns it, in instances too, but takes only a file and
	can't tint one, so where the client lets an add-on change it (Minimap:SetPlayerTexture) it gets the file
	in the player's class color.

	Clients from 12.0.7 on, WoW Forever among them, took that away and give no way to hide it. There the
	arrow is drawn over Blizzard's instead, solid at the back, at the minimap's middle where the player
	always is, the size it is on the maps: pointing up when the minimap turns with the player (the
	rotateMinimap setting), otherwise turned the way they face. Where the game won't say which way that is, as in instances, it
	hides and Blizzard's shows
]]

--[[
	The Quest Arrow's arrow with the notch at its back filled in, so Blizzard's arrow under it can't show
	through there
]]
local MINIMAP_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Arrow-Solid"
local MINIMAP_SIZE = 32
local MINIMAP_LEVELS_UP = 20 -- Over the minimap's own pins, Questie's icons among them

local minimapArrow

local function TurnMinimapArrow(frame, elapsed)
	frame.sinceTurn = (frame.sinceTurn or 0) + elapsed
	if frame.sinceTurn < INTERVAL then
		return
	end
	frame.sinceTurn = 0
	local facing = 0
	if not GetCVarBool("rotateMinimap") then
		facing = GetPlayerFacing()
		if not (facing and ns.IsReadable(facing)) then
			minimapArrow:Hide()
			return
		end
	end
	minimapArrow:SetRotation(facing)
	minimapArrow:Show()
end

local function DrawOverMinimap(minimap)
	local frame = CreateFrame("Frame", nil, minimap)
	frame:SetSize(MINIMAP_SIZE, MINIMAP_SIZE)
	frame:SetPoint("CENTER")
	frame:SetFrameLevel(minimap:GetFrameLevel() + MINIMAP_LEVELS_UP)
	minimapArrow = frame:CreateTexture(nil, "OVERLAY")
	minimapArrow:SetTexture(MINIMAP_TEXTURE)
	minimapArrow:SetAllPoints()
	minimapArrow:SetVertexColor(ClassColor("player"))
	frame:SetScript("OnUpdate", TurnMinimapArrow)
end

function playerMapPin:OnPlayerLogin()
	local minimap = _G.Minimap
	if not minimap then
		return
	end
	local class = UnitClassFile("player")
	if minimap.SetPlayerTexture then
		if class and CLASS_ARROW_FILES[class] then
			minimap:SetPlayerTexture(CLASS_ARROWS .. class)
		end
	else
		DrawOverMinimap(minimap)
	end
end
