local _, ns = ...

--[[
	WoW Forever: the map's layers and the quest it follows (Quest-Map.lua builds the map itself). The
	selected quest comes from Questie's icons when it has any (Questie-Map.lua), otherwise from
	Blizzard's own quest objective area and quest marker
]]

local questMap = ns.questMap
local canvas = questMap.canvas
local state = ns.questLog

local shownQuestID

-- The quest Blizzard's objective area and quest marker are drawn for: the shown one, unless Questie's icons have it
local function BlizzardQuestID()
	if shownQuestID ~= questMap.questieQuestID then
		return shownQuestID
	end
end

--------------------------------------------------------------------------------
-- Map layers
--------------------------------------------------------------------------------

-- Each is added only if this client has it
local function AddProvider(mixin)
	if mixin then
		local provider = CreateFromMixins(mixin)
		canvas:AddDataProvider(provider)
		return provider
	end
end

AddProvider(MapExplorationDataProviderMixin)
AddProvider(FogOfWarDataProviderMixin)
local blobProvider = AddProvider(QuestBlobDataProviderMixin)
local questProvider = AddProvider(QuestDataProviderMixin)
AddProvider(DungeonEntranceDataProviderMixin)
AddProvider(FlightPointDataProviderMixin)

--[[
	Blizzard draws objective areas and quest markers only while the questPOI setting is on, and Questie
	turns it off when its own objectives are chosen, so this map would be left with none for a quest
	Questie has no icons for. These two are Blizzard's own, less that check, on this map's copies only;
	the setting itself and the world map are left alone. Both draw the shown quest only, and nothing
	while Questie's icons are drawing it (BlizzardQuestID)
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

if questProvider then
	function questProvider:RefreshAllData()
		self:RemoveAllData()

		local mapID = self:GetMap():GetMapID()
		local shownID = BlizzardQuestID()
		if not mapID or not shownID then
			return
		end

		local pinsToQuantize = {}
		local mapInfo = C_Map.GetMapInfo(mapID)
		local questsOnMap = GetQuestsOnMapCached(mapID)
		local doesMapShowTaskObjectives = C_TaskQuest.DoesMapShowTaskQuestObjectives(mapID)

		local function CheckAddQuest(questID, x, y, isMapIndicatorQuest, frameLevelOffset, isWaypoint)
			if
				questID == shownID
				and self:ShouldShowQuest(questID, mapInfo.mapType, doesMapShowTaskObjectives, isMapIndicatorQuest)
			then
				pinsToQuantize[#pinsToQuantize + 1] = self:AddQuest(questID, x, y, frameLevelOffset, isWaypoint)
			end
		end

		if questsOnMap then
			for i, info in ipairs(questsOnMap) do
				CheckAddQuest(info.questID, info.x, info.y, info.isMapIndicatorQuest, i)
			end
		end

		-- Where to head next when the quest's objectives are in another zone
		local x, y = C_QuestLog.GetNextWaypointForMap(shownID, mapID)
		if x and y then
			CheckAddQuest(shownID, x, y, false, questsOnMap and (#questsOnMap + 1) or 0, true)
		end

		self.poiQuantizer:ClearAndQuantize(pinsToQuantize)
		for _, pin in pairs(pinsToQuantize) do
			pin:SetPosition(pin.quantizedX or pin.normalizedX, pin.quantizedY or pin.normalizedY)
		end

		self:UpdatePing()
	end
end

-- Bottom to top, in the world map's order
local levels = canvas:GetPinFrameLevelsManager()
levels:AddFrameLevel("PIN_FRAME_LEVEL_MAP_EXPLORATION")
levels:AddFrameLevel("PIN_FRAME_LEVEL_FOG_OF_WAR")
levels:AddFrameLevel("PIN_FRAME_LEVEL_QUEST_BLOB")
levels:AddFrameLevel("PIN_FRAME_LEVEL_DUNGEON_ENTRANCE")
levels:AddFrameLevel("PIN_FRAME_LEVEL_FLIGHT_POINT")
levels:AddFrameLevel("PIN_FRAME_LEVEL_QUEST_PING")
levels:AddFrameLevel("PIN_FRAME_LEVEL_ACTIVE_QUEST", C_QuestLog.GetMaxNumQuests())
levels:AddFrameLevel("PIN_FRAME_LEVEL_SUPER_TRACKED_QUEST")

--------------------------------------------------------------------------------
-- Following the selected quest
--------------------------------------------------------------------------------

--[[
	Questie's icons for the quest when it has any, otherwise the quest's zone (the zone it was given in
	when it has none, then the player's) with Blizzard's objective area picked out
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
	if questProvider then
		questProvider:RefreshAllData()
	end
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
