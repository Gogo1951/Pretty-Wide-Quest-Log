local _, ns = ...

--[[
	Every client: the selected quest's icons from Questie's world map, its objectives and turn-in, drawn
	again on the map (Quest-Map.lua) larger, with a dropdown for a quest whose icons span several zones.
	Each client's own map file decides what the map shows when Questie has no icons for the quest
]]

local questMap = ns.questMap
local canvas = questMap.canvas

-- Questie's own copies of HereBeDragons, which hold every icon it has placed on the world map
local HBD = LibStub("HereBeDragonsQuestie-2.0", true)
local HBDPins = LibStub("HereBeDragonsQuestie-Pins-2.0", true)

local PIN_TEMPLATE = "PrettyWideQuestLogQuestiePinTemplate"
local DEFAULT_ICON_SIZE = 16
local ICON_SCALE = 1.75 -- Of the size Questie gives its world map icons, which reads small on a smaller map
local CLUSTER_DISTANCE = 0.015 -- Icons this close, as a share of the map, share one tooltip
local REFRESH_DELAY = 0.2 -- Questie draws in batches over several frames
local ZONE_DROPDOWN_WIDTH = 180

local shownQuestID

--------------------------------------------------------------------------------
-- Questie's icons
--------------------------------------------------------------------------------

-- Leaves out route lines, and icons Questie's settings hide or fade out entirely
local function IsShownIcon(icon)
	if icon.type == "line" or icon.hidden or not (icon.data and icon.texture) then
		return false
	end
	local _, _, _, alpha = icon.texture:GetVertexColor()
	return alpha > 0
end

-- Calls back with each shown icon Questie has placed on a map for a quest, and where it sits on it (0-1)
local function ForEachIcon(mapID, questID, callback)
	if not (HBD and HBDPins and mapID and questID) then
		return
	end
	for icon, placement in pairs(HBDPins.worldmapPins) do
		if placement.uiMapID == mapID and IsShownIcon(icon) and icon.data.Id == questID then
			local x, y = HBD:GetZoneCoordinatesFromWorldInstance(placement.x, placement.y, placement.instanceID, mapID)
			if x and y then
				callback(icon, x, y)
			end
		end
	end
end

-- The zones a quest has icons in, most icons first
local function QuestZones(questID)
	local counts = {}
	if HBDPins and questID then
		for icon, placement in pairs(HBDPins.worldmapPins) do
			if placement.uiMapID and IsShownIcon(icon) and icon.data.Id == questID then
				counts[placement.uiMapID] = (counts[placement.uiMapID] or 0) + 1
			end
		end
	end
	local zones = {}
	for mapID in pairs(counts) do
		zones[#zones + 1] = mapID
	end
	table.sort(zones, function(a, b)
		if counts[a] ~= counts[b] then
			return counts[a] > counts[b]
		end
		return a < b
	end)
	return zones
end

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

-- An icon's objective, with its progress where it counts something
local function ObjectiveText(data)
	local objective = data.ObjectiveData
	if not (objective and objective.Description) then
		return nil
	end
	if objective.Needed then
		return string.format(
			"%s: %s/%s",
			objective.Description,
			tostring(objective.Collected or 0),
			tostring(objective.Needed)
		)
	end
	return objective.Description
end

--[[
	The quest, then every NPC or object around the hovered icon with its objectives, as Questie's world
	map groups them
]]
local function ShowPinTooltip(pin)
	local x, y = pin:GetPosition()
	local entries, byName = {}, {}
	for other in canvas:EnumeratePinsByTemplate(PIN_TEMPLATE) do
		local otherX, otherY = other:GetPosition()
		if math.abs(otherX - x) < CLUSTER_DISTANCE and math.abs(otherY - y) < CLUSTER_DISTANCE then
			local name = other.data.Name or ""
			local entry = byName[name]
			if not entry then
				entry = { name = name, objectives = {} }
				byName[name] = entry
				entries[#entries + 1] = entry
			end
			local objective = ObjectiveText(other.data)
			if objective and not tContains(entry.objectives, objective) then
				entry.objectives[#entry.objectives + 1] = objective
			end
		end
	end

	GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
	local quest = pin.data.QuestData
	if quest and quest.name then
		GameTooltip:AddLine(quest.name)
	end
	for _, entry in ipairs(entries) do
		GameTooltip:AddLine(entry.name, 1, 1, 1)
		for _, objective in ipairs(entry.objectives) do
			GameTooltip:AddLine(objective, 0.8, 0.8, 0.8, true)
		end
	end
	GameTooltip:Show()
end

--------------------------------------------------------------------------------
-- Map layer
--------------------------------------------------------------------------------

local questieProvider = CreateFromMixins(MapCanvasDataProviderMixin)

function questieProvider:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(PIN_TEMPLATE)
end

function questieProvider:RefreshAllData()
	self:RemoveAllData()
	local map = self:GetMap()
	ForEachIcon(map:GetMapID(), shownQuestID, function(icon, x, y)
		local pin = map:AcquirePin(PIN_TEMPLATE)
		pin.data = icon.data
		local size = icon:GetWidth()
		size = ICON_SCALE * (size > 0 and size or DEFAULT_ICON_SIZE)
		pin:SetSize(size, size)
		pin.Texture:SetTexture(icon.texture:GetTexture())
		pin.Texture:SetTexCoord(icon.texture:GetTexCoord())
		pin.Texture:SetVertexColor(icon.texture:GetVertexColor())
		pin:SetScript("OnEnter", ShowPinTooltip)
		pin:SetScript("OnLeave", GameTooltip_Hide)
		pin:UseFrameLevelType("PIN_FRAME_LEVEL_ACTIVE_QUEST")
		pin:ApplyFrameLevel()
		--[[
			The map draws its pins at its own zoom, which shrinks them with the map; these keep them the
			size set above, growing a little as the map zooms in, as Questie's world map pins do
		]]
		pin:SetScalingLimits(1, 1.0, 1.2)
		pin:SetPosition(x, y)
		pin:ApplyCurrentScale()
	end)
end

canvas:AddDataProvider(questieProvider)

--------------------------------------------------------------------------------
-- Following the selected quest
--------------------------------------------------------------------------------

local zones, shownMapID, chosenMapID = {}, nil, nil

local function ShowZone(mapID)
	shownMapID = mapID
	questMap.ShowMap(mapID)
end

-- A quest with icons in more than one zone gets a dropdown on the map to pick between them
local zoneDropdown = CreateFrame("DropdownButton", nil, questMap.holder, "WowStyle2DropdownTemplate")
zoneDropdown:SetPoint("TOPLEFT", canvas, "TOPLEFT", 8, -8)
zoneDropdown:SetWidth(ZONE_DROPDOWN_WIDTH)
zoneDropdown:SetFrameLevel(canvas:GetFrameLevel() + 10)
zoneDropdown:Hide()
questMap.zoneDropdown = zoneDropdown

zoneDropdown:SetupMenu(function(_, rootDescription)
	for _, mapID in ipairs(zones) do
		local mapInfo = C_Map.GetMapInfo(mapID)
		rootDescription:CreateRadio(mapInfo and mapInfo.name or tostring(mapID), function(data)
			return data == shownMapID
		end, function(data)
			chosenMapID = data
			ShowZone(data)
		end, mapID)
	end
end)

--[[
	Puts the map on a quest from Questie's icons: the zone picked from the dropdown while the quest stays
	selected, otherwise the player's zone when the quest has icons there, otherwise the zone holding most
	of them, otherwise fallbackMapID. questMap.questieQuestID is the quest while Questie has icons for it.
	Returns whether it has any
]]
function questMap.FollowQuestieQuest(questID, fallbackMapID)
	if questID ~= shownQuestID then
		chosenMapID = nil
	end
	shownQuestID = questID
	zones = QuestZones(questID)

	local playerMapID = MapUtil.GetDisplayableMapForPlayer()
	local mapID = zones[1] or fallbackMapID
	if chosenMapID and tContains(zones, chosenMapID) then
		mapID = chosenMapID
	elseif tContains(zones, playerMapID) then
		mapID = playerMapID
	end
	ShowZone(mapID)

	zoneDropdown:SetShown(#zones > 1)
	zoneDropdown:GenerateMenu()

	local hasIcons = #zones > 0
	questMap.questieQuestID = hasIcons and questID or nil
	return hasIcons
end

--[[
	Questie adds and removes its icons a little after the quest log changes, and a batch at a time, so
	the map follows the quest log and Questie's icons both, once per REFRESH_DELAY at most
]]
local refreshPending
function questMap.RequestRefresh()
	if refreshPending or not canvas:IsVisible() then
		return
	end
	refreshPending = true
	C_Timer.After(REFRESH_DELAY, function()
		refreshPending = nil
		if canvas:IsVisible() then
			questMap.FollowQuest()
			questieProvider:RefreshAllData()
		end
	end)
end

if HBDPins then
	for _, name in ipairs({
		"AddWorldMapIconMap",
		"AddWorldMapIconWorld",
		"RemoveWorldMapIcon",
		"RemoveAllWorldMapIcons",
	}) do
		if HBDPins[name] then
			hooksecurefunc(HBDPins, name, questMap.RequestRefresh)
		end
	end
end
