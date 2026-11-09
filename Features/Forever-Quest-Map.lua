local _, ns = ...

--[[
	WoW Forever and Mists: the map's layers and the quest it follows (Quest-Map.lua builds the map itself).
	The selected quest comes from Questie's icons when it has any (Questie-Map.lua), otherwise from
	Blizzard's own quest objective area and a marker of the window's own
]]

local questMap = ns.questMap
local canvas = questMap.canvas
local state = ns.questLog

local shownQuestID

-- The quest Blizzard's objective area and the marker are drawn for: the shown one, unless Questie's icons have it
local function BlizzardQuestID()
	if shownQuestID ~= questMap.questieQuestID then
		return shownQuestID
	end
end

--------------------------------------------------------------------------------
-- Map layers
--------------------------------------------------------------------------------

--[[
	Blizzard's explored areas, fog, quest objective area, dungeon entrances and flight points. The
	entrances and flight points are Blizzard's own pins with Blizzard's own mouse handling, their names on
	hover. The explored areas and fog take no mouse, and the objective area shows only a tooltip on hover.
	The objective area draws the shown quest when Questie has no icons for it (below)
]]
local providers = {}

-- Each is added only if this client has it
local function AddProvider(mixin)
	if mixin then
		local provider = CreateFromMixins(mixin)
		canvas:AddDataProvider(provider)
		providers[#providers + 1] = provider
		return provider
	end
end

AddProvider(MapExplorationDataProviderMixin)
-- Mists has the fog layer but not the frame it draws with
AddProvider(FogOfWarFrameMixin and FogOfWarDataProviderMixin)
local blobProvider = AddProvider(QuestBlobDataProviderMixin)
AddProvider(DungeonEntranceDataProviderMixin)
AddProvider(FlightPointDataProviderMixin)

--[[
	A stopgap until Questie has icons for every quest: Blizzard draws objective areas only while the
	questPOI setting is on, and Questie turns it off when its own objectives are chosen, so this map would
	show a quest Questie has no icons for with no area at all. This is Blizzard's own redraw, less that
	check, on this map's copy only; the setting itself and the world map are left alone. It draws the
	shown quest only, and nothing while Questie's icons are drawing it (BlizzardQuestID). It acquires no
	pins, so it draws in combat too
]]
if blobProvider and blobProvider.pin then
	function blobProvider.pin:Refresh()
		self:DrawNone()
		if not self.mapAllowsBlobs then
			return
		end
		local questID = BlizzardQuestID()
		if questID then
			self:TryDrawQuest(questID)
		end
	end
end

--[[
	The canvas calls SetPassThroughButtons on every pin these layers acquire, which WoW blocks in combat
	when add-on code runs it, so their redraws wait out combat on this map's copies and run once it ends
]]
local heldProviders = {}
for _, provider in ipairs(providers) do
	local refresh = provider.RefreshAllData
	provider.RefreshAllData = function(self, ...)
		if InCombatLockdown() then
			heldProviders[self] = true
			return
		end
		return refresh(self, ...)
	end
end

function questMap:OnPlayerRegenEnabled()
	for provider in pairs(heldProviders) do
		heldProviders[provider] = nil
		provider:RefreshAllData()
	end
end

--[[
	The shown quest's marker, a pin of the window's own that takes no mouse (Quest-Map.xml): at the quest's
	place on the shown map, or on WoW Forever where to head next when its objectives are in another zone. A
	question mark once the quest is ready to turn in, an exclamation mark before. Its pins use the window's
	own pin mixin, so it draws in combat too
]]
local MARKER_TEMPLATE = "PrettyWideQuestLogQuestMarkerPinTemplate"
local MARKER_TEXTURE = "Interface\\GossipFrame\\AvailableQuestIcon"
local MARKER_TEXTURE_COMPLETE = "Interface\\GossipFrame\\ActiveQuestIcon"
local GetNextWaypointForMap = C_QuestLog.GetNextWaypointForMap -- WoW Forever only

local function MarkerPosition(questID, mapID)
	for _, info in ipairs(C_QuestLog.GetQuestsOnMap(mapID) or {}) do
		if info.questID == questID then
			return info.x, info.y
		end
	end
	if GetNextWaypointForMap then
		return GetNextWaypointForMap(questID, mapID)
	end
end

local markerProvider = CreateFromMixins(MapCanvasDataProviderMixin)

function markerProvider:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(MARKER_TEMPLATE)
end

function markerProvider:RefreshAllData()
	self:RemoveAllData()
	local map = self:GetMap()
	local mapID, questID = map:GetMapID(), BlizzardQuestID()
	local x, y
	if mapID and questID then
		x, y = MarkerPosition(questID, mapID)
	end
	if not (x and y) then
		return
	end
	local pin = map:AcquirePin(MARKER_TEMPLATE)
	pin.Texture:SetTexture(ns.IsQuestComplete(questID) and MARKER_TEXTURE_COMPLETE or MARKER_TEXTURE)
	pin:UseFrameLevelType("PIN_FRAME_LEVEL_QUEST_MARKER")
	pin:ApplyFrameLevel()
	-- The size set in its template, growing a little as the map zooms in, like Questie's icons (Questie-Map.lua)
	pin:SetScalingLimits(1, 1.0, 1.2)
	pin:SetPosition(x, y)
	pin:ApplyCurrentScale()
end

canvas:AddDataProvider(markerProvider)

-- Bottom to top, in the world map's order, the marker over Questie's icons and the player over everything
local levels = canvas:GetPinFrameLevelsManager()
levels:AddFrameLevel("PIN_FRAME_LEVEL_MAP_EXPLORATION")
levels:AddFrameLevel("PIN_FRAME_LEVEL_FOG_OF_WAR")
levels:AddFrameLevel("PIN_FRAME_LEVEL_QUEST_BLOB")
levels:AddFrameLevel("PIN_FRAME_LEVEL_DUNGEON_ENTRANCE")
levels:AddFrameLevel("PIN_FRAME_LEVEL_FLIGHT_POINT")
levels:AddFrameLevel("PIN_FRAME_LEVEL_ACTIVE_QUEST")
levels:AddFrameLevel("PIN_FRAME_LEVEL_QUEST_MARKER")
ns.AddPlayerPinLevel(canvas) -- The player (Player-Map-Pin.lua)

--------------------------------------------------------------------------------
-- Following the selected quest
--------------------------------------------------------------------------------

--[[
	Questie's icons for the quest when it has any, otherwise the quest's zone (the zone it was given in
	when it has none, then the player's) with Blizzard's objective area and the marker on it
]]
local function ShowQuest(questID)
	shownQuestID = questID
	local mapID = questID and GetQuestUiMapID(questID)
	if not mapID or mapID == 0 then
		mapID = questMap.QuestGiverMapID(questID) or MapUtil.GetDisplayableMapForPlayer()
	end

	if questMap.FollowQuestieQuest(questID, mapID) or not questID then
		canvas:TriggerEvent("ClearFocusedQuestID")
	else
		canvas:TriggerEvent("SetFocusedQuestID", questID)
	end
	if blobProvider and blobProvider.pin then
		blobProvider.pin:Refresh()
	end
	markerProvider:RefreshAllData()
end

function questMap.FollowQuest()
	ShowQuest(state.selectedQuestID)
end

hooksecurefunc(ns, "DisplayQuestDetails", function()
	if state.selectedQuestID ~= shownQuestID then
		ShowQuest(state.selectedQuestID)
	end
	questMap.RequestRefresh() -- Questie's icons can arrive after the quest log changes
end)
