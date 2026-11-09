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
	drags under both.

	The Player Icon on Maps feature (enablePlayerIcon) switches them off on the minimap and the world map,
	giving those back to Blizzard's own, at once (ns.ApplyPlayerIcon). The quest log's map keeps them, as
	nothing else draws the player there
]]

-- The owner of this file's event handlers in Core.lua's EVENTS
local playerMapPin = {}
ns.playerMapPin = playerMapPin

local PLAYER_TEMPLATE = "PrettyWideQuestLogPlayerPinTemplate"
local PARTY_TEMPLATE = "PrettyWideQuestLogPartyPinTemplate"
-- The levels they're drawn at, added last on each map so they're over everything, the player over the party
local PARTY_LEVEL = "PIN_FRAME_LEVEL_PWQL_PARTY"
local PLAYER_LEVEL = "PIN_FRAME_LEVEL_PWQL_PLAYER"
local PLAYER_SIZE, PARTY_SIZE = 32, 16 -- Their templates' sizes (Quest-Map.xml) at Medium
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

-- Whether the Player Icon on Maps feature is on; the default until the saved settings load
local function IsPlayerIconOn()
	if not ns.db then
		return ns.DATABASE_DEFAULTS.profile.enablePlayerIcon
	end
	return ns.db.profile.enablePlayerIcon and true or false
end

-- The Icon Size setting, times the sizes in Quest-Map.xml's templates and MINIMAP_SIZE
local function IconScale()
	local profile = ns.db and ns.db.profile or ns.DATABASE_DEFAULTS.profile
	return profile.playerIconScale or 1
end

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

--[[
	Its template's size (size) times Icon Size, growing a little as the map zooms in, like Questie's icons
	(Questie-Map.lua)
]]
local function SetUp(pin, level, place, size)
	pin:UseFrameLevelType(level)
	pin:ApplyFrameLevel()
	pin:SetSize(size * IconScale(), size * IconScale())
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
	if self.optional and not IsPlayerIconOn() then
		return
	end
	local map = self:GetMap()
	for _, unit in ipairs(PARTY_UNITS) do
		local pin = map:AcquirePin(PARTY_TEMPLATE)
		pin.unit = unit
		-- Motion only, for the name on hover; clicks and drags still reach the map
		pin:SetMouseMotionEnabled(true)
		pin:SetMouseClickEnabled(false)
		pin:SetScript("OnEnter", OnPartyEnter)
		pin:SetScript("OnLeave", OnPartyLeave)
		SetUp(pin, PARTY_LEVEL, PlacePartyMember, PARTY_SIZE)
	end
	local pin = map:AcquirePin(PLAYER_TEMPLATE)
	pin.Arrow:SetVertexColor(ClassColor("player"))
	SetUp(pin, PLAYER_LEVEL, PlacePlayer, PLAYER_SIZE)
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

-- Every map's provider, so the Player Icon on Maps settings can redraw them
local providers = {}

--[[
	optional: the map is one that has Blizzard's own player arrow and party dots to fall back on (the world
	map), so the pins follow the Player Icon on Maps switch. Without it they always show (the quest log's map),
	at the Icon Size set
]]
function ns.AddPlayerPin(map, optional)
	local provider = CreateFromMixins(providerMixin)
	provider.optional = optional
	map:AddDataProvider(provider)
	providers[#providers + 1] = provider
end

--[[
	Hides Blizzard's own player arrow and party dots on a map (the world map's GroupMembersPinTemplate),
	which would otherwise show around the edges of these. Raid members stay. Only the pin's own widget
	call, never its Lua fields, so nothing of Blizzard's map is tainted; it's done again whenever Blizzard
	works out who to show. With Player Icon on Maps off, Blizzard's are left as Blizzard set them
]]
local function HideBlizzardUnits(pin)
	if not IsPlayerIconOn() then
		return
	end
	pin:SetShouldShowUnits("player", false)
	pin:SetShouldShowUnits("party", false)
end

-- Gives Blizzard's player arrow and party dots back, as Blizzard shows them: the party only outside a raid
local function ShowBlizzardUnits(pin)
	pin:SetShouldShowUnits("player", true)
	pin:SetShouldShowUnits("party", not IsInRaid())
end

local blizzardGroupMaps = {}

function ns.HideBlizzardGroupPins(map)
	blizzardGroupMaps[#blizzardGroupMaps + 1] = map
	for pin in map:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
		if pin.SetShouldShowUnits then
			HideBlizzardUnits(pin)
			if pin.UpdateShownUnits then
				hooksecurefunc(pin, "UpdateShownUnits", HideBlizzardUnits)
			end
		end
	end
end

-- Blizzard's group pins on every map that hid them, hidden again or given back to match the switch
local function ApplyToBlizzardGroupPins()
	local on = IsPlayerIconOn()
	for _, map in ipairs(blizzardGroupMaps) do
		for pin in map:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
			if pin.SetShouldShowUnits then
				if on then
					HideBlizzardUnits(pin)
				else
					ShowBlizzardUnits(pin)
				end
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
	arrow is drawn over Blizzard's instead, at the minimap's middle where the player always is: the same
	file and size as the player pin on the maps (Quest-Map.xml), so the player looks the same everywhere,
	pointing up when the minimap turns with the player (the rotateMinimap setting), otherwise turned the
	way they face. It sits MINIMAP_BACK behind the middle, along the way it points, so its body covers the
	tail of Blizzard's arrow, which would otherwise show through the notch at its back. Where the game
	won't say which way the player faces, as in instances, it hides and Blizzard's shows
]]

local MINIMAP_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Arrow"
local MINIMAP_SIZE = 32 -- PrettyWideQuestLogPlayerPinTemplate's
local MINIMAP_BACK = 3 -- Enough to cover Blizzard's arrow's tail with the notch's sides
local MINIMAP_LEVELS_UP = 20 -- Over the minimap's own pins, Questie's icons among them
local BLIZZARD_MINIMAP_ARROW = "Interface\\Minimap\\MinimapArrow" -- The minimap's own, for Player Icon on Maps off

local minimapArrow, minimapFrame
--[[
	Whether the game's own arrow was given a size other than Medium. The game can't say what size it draws
	it at, so it's only ever sized for Small, Large or Huge, and put back to MINIMAP_SIZE after
]]
local minimapResized = false

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
	-- Facing turns counterclockwise from north, so straight back is (sin, -cos)
	local back = MINIMAP_BACK * IconScale()
	minimapArrow:SetPoint("CENTER", frame, "CENTER", back * math.sin(facing), -back * math.cos(facing))
	minimapArrow:Show()
end

local function DrawOverMinimap(minimap)
	local frame = CreateFrame("Frame", nil, minimap)
	frame:SetSize(MINIMAP_SIZE, MINIMAP_SIZE)
	frame:SetPoint("CENTER")
	frame:SetFrameLevel(minimap:GetFrameLevel() + MINIMAP_LEVELS_UP)
	minimapArrow = frame:CreateTexture(nil, "OVERLAY")
	minimapArrow:SetTexture(MINIMAP_TEXTURE)
	minimapArrow:SetSize(MINIMAP_SIZE, MINIMAP_SIZE)
	minimapArrow:SetPoint("CENTER")
	minimapArrow:SetVertexColor(ClassColor("player"))
	frame:SetScript("OnUpdate", TurnMinimapArrow)
	minimapFrame = frame
end

--[[
	The minimap's arrow to match the switch: the class-colored file, or the minimap's own back; where the
	arrow is drawn over Blizzard's, that frame shown or hidden. Only a file this add-on set is ever put back,
	so a class without one leaves the minimap as it was
]]
local function ApplyToMinimap()
	local minimap = _G.Minimap
	if not minimap then
		return
	end
	local on = IsPlayerIconOn()
	local size = MINIMAP_SIZE * IconScale()
	if minimap.SetPlayerTexture then
		local class = UnitClassFile("player")
		if class and CLASS_ARROW_FILES[class] then
			minimap:SetPlayerTexture(on and (CLASS_ARROWS .. class) or BLIZZARD_MINIMAP_ARROW)
		end
		-- Icon Size, where the client can size the game's arrow; off, it's back to the game's own
		local resize = on and IconScale() ~= 1
		if (resize or minimapResized) and minimap.SetPlayerTextureWidth and minimap.SetPlayerTextureHeight then
			local applied = resize and size or MINIMAP_SIZE
			minimap:SetPlayerTextureWidth(applied)
			minimap:SetPlayerTextureHeight(applied)
			minimapResized = resize
		end
	else
		if on and not minimapFrame then
			DrawOverMinimap(minimap)
		end
		if minimapFrame then
			minimapFrame:SetSize(size, size)
			minimapArrow:SetSize(size, size)
			minimapFrame:SetShown(on)
		end
	end
end

--[[
	The Player Icon on Maps settings, as they change or a profile loads: the minimap's arrow, every map's
	pins redrawn at Icon Size, and Blizzard's player arrow and party dots on the world map hidden or given back
]]
function ns.ApplyPlayerIcon()
	ApplyToMinimap()
	--[[
		Only a map on screen with a map loaded: the quest log's map counts as shown while its window is closed,
		and before its first map it has no zoom levels for a pin's scale (ApplyCurrentScale). A hidden map
		redraws every provider as it next shows
	]]
	for _, provider in ipairs(providers) do
		local map = provider:GetMap()
		if map and map:IsVisible() and map:GetMapID() then
			provider:RefreshAllData()
		end
	end
	ApplyToBlizzardGroupPins()
end

function playerMapPin:OnPlayerLogin()
	ApplyToMinimap()
end
