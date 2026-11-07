local _, ns = ...

-- The map comes with the wide quest log on every client whose TOC loads this file
ns.hasQuestMap = true

--[[
	The mixin of the quest map's own pin templates (Questie-Map.xml, which loads after this file). The map
	canvas calls SetPassThroughButtons on every pin it acquires, which WoW blocks in combat, so these pins
	skip it, as HereBeDragons-Pins does for Questie's
]]
PrettyWideQuestLogPinMixin = CreateFromMixins(MapCanvasPinMixin)
function PrettyWideQuestLogPinMixin.SetPassThroughButtons() end

ns.AddWideQuestLogPart(function()
	local L = ns.L
	local LAYOUT = ns.LAYOUT

	--[[
		A map docked to the right of the quest log, showing the selected quest's zone. It's Blizzard's map
		canvas with a handful of the world map's data providers, as the Battlefield Map does it, so nothing of
		the world map itself is touched. Each client's own file adds the layers and defines
		ns.questMap.FollowQuest, which puts the map on the selected quest
	]]

	local window = ns.questLogFrame
	local canvas = PrettyWideQuestLogMapFrame

	local questMap = { canvas = canvas }
	ns.questMap = questMap

	local MAP_ASPECT = 1002 / 668 -- Width over height of Blizzard's map art
	local HEIGHT_SHARE = 0.66 -- Of the visible window's height, from its top

	--[[
		Where the map sits: its left edge against the window art's right edge and its top level with the art's
		top border, measured in game. A skin that draws the window its own way restyles it (questMap.SetStyle)
	]]
	local style = {
		edge = window, -- The region whose right edge, top and bottom the offsets below are measured from
		x = -34,
		top = -9,
		bottom = 45,
		inset = 11, -- Edge of the map's border to the map inside it
	}

	--------------------------------------------------------------------------------
	-- Frame
	--------------------------------------------------------------------------------

	local holder = CreateFrame("Frame", nil, window, "BackdropTemplate")
	holder:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = style.inset, right = style.inset, top = style.inset, bottom = style.inset },
	})
	holder:EnableMouse(true)
	questMap.holder = holder

	canvas:SetParent(holder)
	canvas:SetFrameLevel(holder:GetFrameLevel() + 1)

	-- The map always shows the whole zone. The wheel stays enabled, so it doesn't zoom the camera instead
	canvas.ScrollContainer:SetMouseWheelZoomMode(MAP_CANVAS_MOUSE_WHEEL_ZOOM_BEHAVIOR_NONE)

	-- Same proportions as Blizzard's map art, HEIGHT_SHARE as tall as the visible window
	local function LayOut()
		holder:ClearAllPoints()
		holder:SetPoint("TOPLEFT", style.edge, "TOPRIGHT", style.x, style.top)
		local height = (style.edge:GetHeight() + style.top - style.bottom) * HEIGHT_SHARE
		local mapHeight = height - 2 * style.inset
		holder:SetSize(mapHeight * MAP_ASPECT + 2 * style.inset, height)

		canvas:ClearAllPoints()
		canvas:SetPoint("TOPLEFT", style.inset, -style.inset)
		canvas:SetPoint("BOTTOMRIGHT", -style.inset, style.inset)
	end
	window:HookScript("OnSizeChanged", LayOut)

	-- Map Scale, on top of the quest log's own scale, which the map follows as the window's child
	function ns.ApplyMapScale()
		holder:SetScale(ns.db.global.mapScale)
	end
	window:HookScript("OnShow", ns.ApplyMapScale)

	function questMap.SetStyle(changes)
		for key, value in pairs(changes) do
			style[key] = value
		end
		LayOut()
	end

	-- The map art is fitted to the scroll frame's size once the new size has taken, not when it's asked for
	canvas.ScrollContainer:HookScript("OnSizeChanged", function()
		canvas:OnFrameSizeChanged()
	end)

	-- A client can know a map it has no art for, as with some dungeons Questie names, and the canvas can't draw one
	function questMap.CanShowMap(mapID)
		local layers = mapID and C_Map.GetMapArtLayers(mapID)
		return layers and #layers > 0 or false
	end

	-- The map itself when it has art, otherwise the nearest map above it that does (a dungeon's zone, a zone's continent)
	local function DrawableMap(mapID)
		local seen = {}
		while mapID and mapID > 0 and not seen[mapID] do
			if questMap.CanShowMap(mapID) then
				return mapID
			end
			seen[mapID] = true
			local info = C_Map.GetMapInfo(mapID)
			mapID = info and info.parentMapID
		end
		return nil
	end

	--[[
		The map the canvas was given, or nil before its first. Blizzard's canvas:GetMapID() answers the player's
		map until one is set, so it can't tell whether the canvas has a map yet
	]]
	local function CanvasMap()
		return canvas.mapID
	end

	-- Set while the canvas is showing but hasn't drawn yet, for want of a map (the canvas's OnShow below)
	local drawPending = false

	-- Returns whether the map moved, which redraws every layer
	function questMap.ShowMap(mapID)
		mapID = DrawableMap(mapID)
		if not mapID or CanvasMap() == mapID then
			return false
		end
		canvas:SetMapID(mapID)
		if drawPending then
			drawPending = false
			MapCanvasMixin.OnShow(canvas)
		end
		return true
	end

	--[[
		A map is needed before the canvas first draws, as the Battlefield Map does it: drawing with none breaks
		Blizzard's map code, whose layers ask for zoom levels it only builds for a map. When the quest's map and
		the player's have no art to climb to, as in some dungeons, the world map's own fallback stands in. If
		even that finds none, the drawing waits for the first map to arrive (questMap.ShowMap)
	]]
	canvas:SetScript("OnShow", function(self)
		questMap.FollowQuest()
		if not CanvasMap() then
			if not questMap.ShowMap(MapUtil.GetDisplayableMapForPlayer()) and C_Map.GetFallbackWorldMapID then
				questMap.ShowMap(C_Map.GetFallbackWorldMapID())
			end
		end
		if CanvasMap() then
			MapCanvasMixin.OnShow(self)
		else
			drawPending = true
		end
	end)
	canvas:HookScript("OnHide", function()
		drawPending = false
	end)

	--------------------------------------------------------------------------------
	-- Showing and hiding
	--------------------------------------------------------------------------------

	-- Show Map / Hide Map, in the bar above the quest list after Expand All and Track All
	local toggleButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
	toggleButton:SetSize(LAYOUT.BUTTON_WIDTH, LAYOUT.BUTTON_HEIGHT)
	toggleButton:SetPoint("LEFT", ns.listButtons[#ns.listButtons], "RIGHT", LAYOUT.LIST_BUTTONS_GAP, 0)
	questMap.toggleButton = toggleButton

	-- Wide enough for the longer of its two labels, once the font is ready
	local fitted
	toggleButton:HookScript("OnShow", function(self)
		if fitted then
			return
		end
		fitted = true
		local current, width = self:GetText(), LAYOUT.BUTTON_WIDTH
		for _, label in ipairs({ SHOW_MAP, L["HIDE_MAP"] }) do
			self:SetText(label)
			width = math.max(width, self:GetTextWidth() + LAYOUT.LABEL_PADDING)
		end
		self:SetText(current)
		self:SetWidth(width)
	end)

	-- On the map itself, in its top-right corner
	local closeButton = CreateFrame("Button", nil, holder, "UIPanelCloseButtonNoScripts")
	closeButton:SetPoint("TOPRIGHT", canvas, "TOPRIGHT")
	closeButton:SetFrameLevel(canvas:GetFrameLevel() + 10)
	questMap.closeButton = closeButton

	--[[
		Remembered across sessions; shown unless it was closed. With no quests in the log there's nothing
		to map, so the map and its button are hidden then, leaving what was remembered as it is
	]]
	local logEmpty = false

	local function ApplyShown()
		local shown = not ns.db.global.mapHidden
		holder:SetShown(shown and not logEmpty)
		toggleButton:SetShown(not logEmpty)
		toggleButton:SetText(shown and L["HIDE_MAP"] or SHOW_MAP)
	end

	-- Each client's quest list says whether the log has any quests each time it updates
	function questMap.SetLogEmpty(isEmpty)
		isEmpty = isEmpty and true or false
		if isEmpty ~= logEmpty then
			logEmpty = isEmpty
			ApplyShown()
		end
	end

	function questMap.IsLogEmpty()
		return logEmpty
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
end)
