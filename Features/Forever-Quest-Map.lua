local _, ns = ...

--[[
	WoW Forever: a map docked to the right of the quest log, showing the selected quest's
	zone with Blizzard's own quest objective areas and quest markers on it. It's Blizzard's map canvas with
	a handful of the world map's data providers, as the Battlefield Map does it, so nothing of the world
	map itself is touched
]]

local window = ns.questLogFrame
local canvas = PrettyWideQuestLogMapFrame
local state = ns.questLog

local MAP_ASPECT = 1002 / 668 -- Width over height of Blizzard's map art
local BORDER_INSET = 11 -- Edge of the dialog border to the map inside it
local TITLE_HEIGHT = 22
local OFFSET_X = -34 -- From the window's right edge to where its art ends
local OFFSET_TOP, OFFSET_BOTTOM = -9, 45 -- Level with the art's top and bottom borders, measured in game
local HEIGHT_SHARE = 0.66 -- Of the window art's height, from its top

--------------------------------------------------------------------------------
-- Frame
--------------------------------------------------------------------------------

local holder = CreateFrame("Frame", nil, window, "BackdropTemplate")
holder:SetPoint("TOPLEFT", window, "TOPRIGHT", OFFSET_X, OFFSET_TOP)
holder:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 32,
	insets = { left = BORDER_INSET, right = BORDER_INSET, top = BORDER_INSET, bottom = BORDER_INSET },
})
holder:EnableMouse(true)

local zoneText = holder:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
zoneText:SetPoint("TOP", 0, -BORDER_INSET - 5)

canvas:SetParent(holder)
canvas:ClearAllPoints()
canvas:SetPoint("TOPLEFT", BORDER_INSET, -(BORDER_INSET + TITLE_HEIGHT))
canvas:SetPoint("BOTTOMRIGHT", -BORDER_INSET, BORDER_INSET)
canvas:SetFrameLevel(holder:GetFrameLevel() + 1)

-- Same proportions as Blizzard's map art, HEIGHT_SHARE as tall as the window's art
local function LayOut()
	local height = (window:GetHeight() + OFFSET_TOP - OFFSET_BOTTOM) * HEIGHT_SHARE
	local mapHeight = height - 2 * BORDER_INSET - TITLE_HEIGHT
	holder:SetSize(mapHeight * MAP_ASPECT + 2 * BORDER_INSET, height)
end
window:HookScript("OnSizeChanged", LayOut)

-- The map art is fitted to the scroll frame's size once the new size has taken, not when it's asked for
canvas.ScrollContainer:HookScript("OnSizeChanged", function()
	canvas:OnFrameSizeChanged()
end)

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
AddProvider(GroupMembersDataProviderMixin)

--[[
	Blizzard draws objective areas and quest markers only while the questPOI setting is on, and Questie
	turns it off when its own objectives are chosen. Questie draws only on the world map and minimap, so
	this map would be left with none. These two are Blizzard's own, less that check, on this map's copies
	only; the setting itself and the world map are left alone
]]
if blobProvider and blobProvider.pin then
	function blobProvider.pin:Refresh()
		self:DrawNone()
		if not self.mapAllowsBlobs then
			return
		end
		if not self.focusedQuestID then
			self:TryDrawQuest(self.questID)
		end
		self:TryDrawQuest(self.highlightedQuestID)
		self:TryDrawQuest(self.focusedQuestID)
		self:TryDrawQuest(POIButtonHighlightManager:GetQuestID())
	end
end

if questProvider then
	function questProvider:RefreshAllData()
		self:RemoveAllData()

		local mapID = self:GetMap():GetMapID()
		if not mapID then
			return
		end

		local pinsToQuantize = {}
		local mapInfo = C_Map.GetMapInfo(mapID)
		local questsOnMap = GetQuestsOnMapCached(mapID)
		local doesMapShowTaskObjectives = C_TaskQuest.DoesMapShowTaskQuestObjectives(mapID)

		local function CheckAddQuest(questID, x, y, isMapIndicatorQuest, frameLevelOffset, isWaypoint)
			if self:ShouldShowQuest(questID, mapInfo.mapType, doesMapShowTaskObjectives, isMapIndicatorQuest) then
				pinsToQuantize[#pinsToQuantize + 1] = self:AddQuest(questID, x, y, frameLevelOffset, isWaypoint)
			end
		end

		if questsOnMap then
			for i, info in ipairs(questsOnMap) do
				CheckAddQuest(info.questID, info.x, info.y, info.isMapIndicatorQuest, i)
			end
		end

		local waypointQuestID = QuestMapFrame_GetFocusedQuestID() or C_SuperTrack.GetSuperTrackedQuestID()
		if waypointQuestID then
			local x, y = C_QuestLog.GetNextWaypointForMap(waypointQuestID, mapID)
			if x and y then
				CheckAddQuest(waypointQuestID, x, y, false, questsOnMap and (#questsOnMap + 1) or 0, true)
			end
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
levels:AddFrameLevel("PIN_FRAME_LEVEL_GROUP_MEMBER")

--------------------------------------------------------------------------------
-- Following the selected quest
--------------------------------------------------------------------------------

local shownQuestID

-- The quest's zone, or the player's when it has none, with its objective area picked out
local function ShowQuest(questID)
	shownQuestID = questID
	local mapID = questID and GetQuestUiMapID(questID)
	if not mapID or mapID == 0 then
		mapID = MapUtil.GetDisplayableMapForPlayer()
	end
	canvas:SetMapID(mapID)

	if questID then
		canvas:TriggerEvent("SetFocusedQuestID", questID)
	else
		canvas:TriggerEvent("ClearFocusedQuestID")
	end

	local mapInfo = C_Map.GetMapInfo(mapID)
	zoneText:SetText(mapInfo and mapInfo.name or "")
end

-- A map is needed before the canvas first draws, as the Battlefield Map does it
canvas:SetScript("OnShow", function(self)
	ShowQuest(state.selectedQuestID)
	MapCanvasMixin.OnShow(self)
end)

hooksecurefunc(ns, "DisplayQuestDetails", function()
	if state.selectedQuestID ~= shownQuestID then
		ShowQuest(state.selectedQuestID)
	end
end)

--------------------------------------------------------------------------------
-- Showing and hiding
--------------------------------------------------------------------------------

local LAYOUT = ns.LAYOUT
local L = ns.L

-- Show Map / Hide Map, centred in the gap between Abandon Quest and Share Quest
local gap = CreateFrame("Frame", nil, window)
gap:SetPoint("TOPLEFT", ns.abandonButton, "TOPRIGHT")
gap:SetPoint("BOTTOMRIGHT", ns.shareButton, "BOTTOMLEFT")

local toggleButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
toggleButton:SetSize(LAYOUT.BUTTON_WIDTH, LAYOUT.BUTTON_HEIGHT)
toggleButton:SetPoint("CENTER", gap)

-- Wide enough for the longer of its two labels, once the font is ready
local fitted
toggleButton:HookScript("OnShow", function(self)
	if fitted then
		return
	end
	fitted = true
	local current, width = self:GetText(), LAYOUT.BUTTON_WIDTH
	for _, label in ipairs({ L["SHOW_MAP"], L["HIDE_MAP"] }) do
		self:SetText(label)
		width = math.max(width, self:GetTextWidth() + LAYOUT.LABEL_PADDING)
	end
	self:SetText(current)
	self:SetWidth(width)
end)

local closeButton = CreateFrame("Button", nil, holder, "UIPanelCloseButtonNoScripts")
closeButton:SetPoint("TOPRIGHT", -4, -4)
closeButton:SetFrameLevel(canvas:GetFrameLevel() + 10)

-- Remembered across sessions; shown unless it was closed
local function ApplyShown()
	local shown = not ns.db.global.mapHidden
	holder:SetShown(shown)
	toggleButton:SetText(shown and L["HIDE_MAP"] or L["SHOW_MAP"])
end

local function SetShown(shown)
	ns.db.global.mapHidden = (not shown) or nil
	PlaySound(shown and SOUNDKIT.IG_QUEST_LOG_OPEN or SOUNDKIT.IG_QUEST_LOG_CLOSE)
	ApplyShown()
end

toggleButton:SetScript("OnClick", function()
	SetShown(not holder:IsShown())
end)
closeButton:SetScript("OnClick", function()
	SetShown(false)
end)
window:HookScript("OnShow", ApplyShown)

canvas:Show() -- The template starts hidden; from here it shows and hides with the holder
LayOut()
