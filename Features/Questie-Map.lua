local _, ns = ...

--[[
	Every client: the selected quest's icons from Questie's world map, its objectives and turn-in, drawn
	again on the map (Quest-Map.lua) larger, with a dropdown for a quest whose icons span several zones.
	An objective's icons give way to its areas where it has them (Questie-Map-Areas.lua), and hovering
	one shows its tooltip (Questie-Map-Tooltip.lua). Each client's own map file decides what the map
	shows when Questie has no icons for the quest
]]

ns.AddWideQuestLogPart(function()
	local questMap = ns.questMap
	local canvas = questMap.canvas

	-- Questie's own copies of HereBeDragons, which hold every icon it has placed on the world map
	local hereBeDragons = ns.QuestieHereBeDragons()
	local hereBeDragonsPins = ns.QuestieHereBeDragonsPins()

	local PIN_TEMPLATE = "PrettyWideQuestLogQuestiePinTemplate"
	questMap.QUESTIE_PIN_TEMPLATE = PIN_TEMPLATE -- For the pins' tooltip (Questie-Map-Tooltip.lua)
	local ICON_SIZE = 16 -- Sized for a UI scale of 1, on the doubling scale; before Questie's scale for the icon's kind
	local REFRESH_DELAY = 0.2 -- Questie draws in batches over several frames
	local ZONE_DROPDOWN_WIDTH = 180

	local shownQuestID

	--------------------------------------------------------------------------------
	-- Questie's icons
	--------------------------------------------------------------------------------

	--[[
		Leaves out route lines, Questie's manual icons (townsfolk, Show on Map), whose Id is an NPC's or
		object's rather than a quest's, and icons faded out entirely. Icons Questie's settings hide on its own maps
		are kept: this map shows the quest picked in the quest log, whatever Questie shows elsewhere
	]]
	local function IsShownIcon(icon)
		if icon.isManualIcon or icon.type == "line" or not (icon.data and icon.texture) then
			return false
		end
		local _, _, _, alpha = icon.texture:GetVertexColor()
		return alpha > 0
	end

	-- Calls back with each shown icon Questie has placed on a map for a quest, and where it sits on it (0-1)
	local function ForEachIcon(mapID, questID, callback)
		if not (hereBeDragons and hereBeDragonsPins and mapID and questID) then
			return
		end
		for icon, placement in pairs(hereBeDragonsPins.worldmapPins) do
			if placement.uiMapID == mapID and icon.data and icon.data.Id == questID and IsShownIcon(icon) then
				local x, y = hereBeDragons:GetZoneCoordinatesFromWorldInstance(
					placement.x,
					placement.y,
					placement.instanceID,
					mapID
				)
				if x and y then
					callback(icon, x, y)
				end
			end
		end
	end

	-- The zones a quest has icons in, most icons first
	local function QuestZones(questID)
		local counts = {}
		if hereBeDragonsPins and questID then
			for icon, placement in pairs(hereBeDragonsPins.worldmapPins) do
				if placement.uiMapID and icon.data and icon.data.Id == questID and IsShownIcon(icon) then
					counts[placement.uiMapID] = (counts[placement.uiMapID] or 0) + 1
				end
			end
		end
		local zones = {}
		for mapID in pairs(counts) do
			if questMap.CanShowMap(mapID) then
				zones[#zones + 1] = mapID
			end
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
	-- Map layer
	--------------------------------------------------------------------------------

	local GLOW_SCALE = 1.13 -- Of the icon, as Questie sizes its glow

	--[[
		The colored glow Questie draws behind an objective's icons, in the color it gave that objective. Taken
		from the icon's data rather than its glow texture, which Questie only shows once the world map has
		been opened
	]]
	local function SetGlow(pin, icon, size)
		local data = icon.data
		local color = data.ObjectiveData and data.ObjectiveData.Color
		local profile = Questie and Questie.db and Questie.db.profile
		local glowTexture = icon.glowTexture
		if
			not (color and glowTexture and profile and profile.alwaysGlowMap)
			or data.Type == "available"
			or data.Type == "complete"
		then
			pin.Glow:Hide()
			return
		end
		local _, _, _, alpha = icon.texture:GetVertexColor()
		pin.Glow:SetTexture(glowTexture:GetTexture())
		pin.Glow:SetVertexColor(color[1], color[2], color[3], alpha or 1)
		pin.Glow:SetSize(size * GLOW_SCALE, size * GLOW_SCALE)
		pin.Glow:Show()
	end

	--[[
		How large one of Questie's icons is drawn on this map, with the map zoomed all the way out. Questie's
		scale for the icon's kind keeps givers, objectives and turn-ins in proportion; its Global Scale,
		which sizes its own world map icons, is left out
	]]
	local function IconSize(icon)
		local data = icon.data
		return ICON_SIZE * (data.GetIconScale and data:GetIconScale() or 1)
	end

	--[[
		A giver's quests to pick up as the quest list names them, "[45] A Strange Request" in its level's
		color, under the giver's name, one space in as the add-on's tooltip rows are
	]]
	local function ShowGiverTooltip(pin)
		local giver = pin.giver
		GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
		if giver.name then
			GameTooltip:AddLine(giver.name, ns.GetColorRGB("TITLE"))
		end
		for _, quest in ipairs(giver.quests) do
			local tagID, isElite = ns.GetQuestTagByID(quest.Id)
			local title = ns.QuestListTitle(quest.level, quest.name, ns.QuestSuffix(tagID, isElite))
			local color = GetQuestDifficultyColor(quest.level or 0)
			GameTooltip:AddLine(" " .. title, color.r, color.g, color.b)
		end
		GameTooltip:Show()
	end

	--[[
		One of Questie's icons drawn again at x, y (0-1), a marker for an area in that icon's look, or with
		giver a quest giver's marker in a zone looked at from Zone Info (Givers, below)
	]]
	local function AddPin(map, icon, x, y, area, giver)
		local pin = map:AcquirePin(PIN_TEMPLATE)
		pin.data = icon.data
		pin.area = area
		pin.giver = giver
		local size = IconSize(icon)
		pin:SetSize(size, size)
		pin.Texture:SetTexture(icon.texture:GetTexture())
		pin.Texture:SetTexCoord(icon.texture:GetTexCoord())
		pin.Texture:SetVertexColor(icon.texture:GetVertexColor())
		SetGlow(pin, icon, size)
		pin:SetScript("OnEnter", giver and ShowGiverTooltip or questMap.ShowPinTooltip)
		pin:SetScript("OnLeave", GameTooltip_Hide)
		pin:UseFrameLevelType("PIN_FRAME_LEVEL_ACTIVE_QUEST")
		pin:ApplyFrameLevel()
		--[[
			The map draws its pins at its own zoom, which shrinks them with the map; these keep them the size
			set above, growing a little as the map zooms in, as Questie's world map pins do
		]]
		pin:SetScalingLimits(1, 1.0, 1.2)
		pin:SetPosition(x, y)
		pin:ApplyCurrentScale()
	end

	-- The objective an icon marks a spawn of, leaving out quest givers and turn-ins
	local function SpawnObjective(data)
		local objective = data.ObjectiveData
		if data.Type ~= "available" and data.Type ~= "complete" and objective and objective.spawnList then
			return objective
		end
	end

	local TURN_IN_COLOR = { ns.GetColorRGB("TITLE") } -- The gold of the turn-in's question mark, and a giver's exclamation mark

	--------------------------------------------------------------------------------
	-- Quest givers in a zone looked at from Zone Info
	--------------------------------------------------------------------------------

	local GIVER_MERGE = 0.01 -- Givers' icons this close, as a share of the map, are one giver with one marker

	local function QuestOrder(a, b)
		if (a.level or 0) ~= (b.level or 0) then
			return (a.level or 0) < (b.level or 0)
		end
		return (a.name or "") < (b.name or "")
	end

	--[[
		While Zone Info's menu has another zone picked (questMap.browseMapID), every quest the character could
		pick up there: Questie's own icons for its available quests on the zone's map, the same set its level,
		faction and class filters chose for its world map, less the gray ones, as Zone Info leaves those out
		too. Each giver is one entry, { icon, x, y, name, quests }, its quests lowest level first
	]]
	local function Givers(mapID)
		local givers = {}
		if not (hereBeDragons and hereBeDragonsPins and mapID) then
			return givers
		end
		local QuestieDB = ns.ImportQuestieModule("QuestieDB")
		local helpers = ns.routes and ns.routes.pickUpHelpers
		local gray = {}
		for icon, placement in pairs(hereBeDragonsPins.worldmapPins) do
			local data = icon.data
			if
				placement.uiMapID == mapID
				and data
				and data.Type == "available"
				and data.QuestData
				and IsShownIcon(icon)
			then
				local questID = data.Id
				if gray[questID] == nil then
					gray[questID] = (QuestieDB and helpers and helpers.IsTooLow(QuestieDB, questID, "green")) or false
				end
				local x, y = hereBeDragons:GetZoneCoordinatesFromWorldInstance(
					placement.x,
					placement.y,
					placement.instanceID,
					mapID
				)
				if x and y and not gray[questID] then
					local giver
					for _, other in ipairs(givers) do
						if math.abs(other.x - x) < GIVER_MERGE and math.abs(other.y - y) < GIVER_MERGE then
							giver = other
							break
						end
					end
					if not giver then
						giver = { icon = icon, x = x, y = y, name = data.Name, quests = {}, has = {} }
						givers[#givers + 1] = giver
					end
					if not giver.has[questID] then
						giver.has[questID] = true
						giver.quests[#giver.quests + 1] = data.QuestData
					end
				end
			end
		end
		for _, giver in ipairs(givers) do
			table.sort(giver.quests, QuestOrder)
		end
		return givers
	end

	--[[
		With Show Objective Areas on, each objective Questie has spawns for on the map is drawn as its areas
		(Questie-Map-Areas.lua), one marker in each in the look of one of its icons there, in place of its
		icons. The rest of the quest's icons, the turn-in among them, are drawn as Questie draws them, each
		in a small circle of its own so it stands out as well. In a zone looked at from Zone Info, every
		giver of a quest to pick up there gets a marker, in a gold circle as the turn-in has, under the quest's
		own icons. questMap.areaCount is how many areas and circles are shaded, for the Quest Map Context report
	]]
	local questieProvider = CreateFromMixins(MapCanvasDataProviderMixin)

	function questieProvider:RemoveAllData()
		local map = self:GetMap()
		map:RemoveAllPinsByTemplate(PIN_TEMPLATE)
		questMap.RemoveObjectiveAreas(map)
		questMap.areaCount = 0
	end

	function questieProvider:RefreshAllData()
		self:RemoveAllData()
		local map = self:GetMap()
		local mapID = map:GetMapID()
		local showAreas = ns.db.profile.showObjectiveAreas
		local shapes = {}

		-- While browsing, the map is on the zone looked at (ShowZone, below), or the nearest map of it with art
		self.showsGivers = questMap.browseMapID ~= nil
		if self.showsGivers then
			for _, giver in ipairs(Givers(mapID)) do
				AddPin(map, giver.icon, giver.x, giver.y, nil, giver)
				local outline = showAreas and questMap.SpotOutline(map, giver.x, giver.y, IconSize(giver.icon))
				if outline then
					shapes[#shapes + 1] = { color = TURN_IN_COLOR, x = giver.x, y = giver.y, outline = outline }
				end
			end
		end

		local icons, objectives, objectiveIcons = {}, {}, {}
		ForEachIcon(mapID, shownQuestID, function(icon, x, y)
			icons[#icons + 1] = { icon = icon, x = x, y = y }
			local objective = showAreas and SpawnObjective(icon.data)
			if objective then
				if not objectiveIcons[objective] then
					objectiveIcons[objective] = {}
					objectives[#objectives + 1] = objective
				end
				table.insert(objectiveIcons[objective], icon)
			end
		end)

		local areasByObjective = {}
		for _, objective in ipairs(objectives) do
			local objectiveIconList = objectiveIcons[objective]
			local areas = questMap.ObjectiveAreas(objective, map, IconSize(objectiveIconList[1]))
			if #areas > 0 then
				areasByObjective[objective] = areas
				for _, area in ipairs(areas) do
					local look = objectiveIconList[1]
					for _, icon in ipairs(objectiveIconList) do
						if icon.data.Icon == area.icon then
							look = icon
							break
						end
					end
					AddPin(map, look, area.x, area.y, area)
					shapes[#shapes + 1] = { color = objective.Color, x = area.x, y = area.y, outline = area.outline }
				end
			end
		end

		for _, entry in ipairs(icons) do
			local data = entry.icon.data
			local objective = SpawnObjective(data)
			if not (objective and areasByObjective[objective]) then
				AddPin(map, entry.icon, entry.x, entry.y)
				local outline = showAreas and questMap.SpotOutline(map, entry.x, entry.y, IconSize(entry.icon))
				if outline then
					local color = data.Type == "complete" and TURN_IN_COLOR
						or (data.ObjectiveData and data.ObjectiveData.Color)
					shapes[#shapes + 1] = { color = color, x = entry.x, y = entry.y, outline = outline }
				end
			end
		end

		questMap.DrawObjectiveAreas(map, shapes)
		questMap.areaCount = #shapes
	end

	canvas:AddDataProvider(questieProvider)

	--------------------------------------------------------------------------------
	-- Following the selected quest
	--------------------------------------------------------------------------------

	local zones, shownMapID, chosenMapID = {}, nil, nil

	local zoneChanged -- Whether ShowZone moved the map, which already redrew Questie's icons with every layer

	--[[
		A quest with icons in more than one zone gets a dropdown on the map to pick between them. With Zone
		Info on (Zone-Info.lua) it's always there, as Zone Info's zone menu too
	]]
	local zoneDropdown = CreateFrame("DropdownButton", nil, questMap.holder, "WowStyle2DropdownTemplate")
	zoneDropdown:SetPoint("TOPLEFT", canvas, "TOPLEFT", ns.LAYOUT.SPACE.NEAR, -ns.LAYOUT.SPACE.NEAR)
	zoneDropdown:SetWidth(ZONE_DROPDOWN_WIDTH)
	zoneDropdown:SetFrameLevel(canvas:GetFrameLevel() + 10)
	zoneDropdown:Hide()
	questMap.zoneDropdown = zoneDropdown

	local function ZoneName(mapID)
		local mapInfo = C_Map.GetMapInfo(mapID)
		return mapInfo and mapInfo.name or tostring(mapID)
	end

	--[[
		While Zone Info's menu has another zone picked (questMap.browseMapID), the map stays on it, and the
		selected quest's icons there still draw. questMap.onZoneShown, where set, hears each zone the map is put on.
		The dropdown names the zone shown, which one zone can be under several of Zone Info's groups at once
	]]
	local function ShowZone(mapID)
		mapID = questMap.browseMapID or mapID
		shownMapID = mapID
		if questMap.ShowMap(mapID) then
			zoneChanged = true
		elseif (questMap.browseMapID ~= nil) ~= (questieProvider.showsGivers == true) then
			-- A look at this same zone begun or ended: its givers' markers come or go with the map staying put
			questieProvider:RefreshAllData()
			zoneChanged = true
		end
		if zoneDropdown.OverrideText and mapID then
			zoneDropdown:OverrideText(ZoneName(mapID))
		end
		if questMap.onZoneShown then
			questMap.onZoneShown(mapID)
		end
	end

	-- The zone the map was last put on, by the quest or by Zone Info's menu
	function questMap.ShownZone()
		return shownMapID
	end

	--[[
		One of the selected quest's zones, from the dropdown or from Zone Info's menu: the map goes there and
		stays while the quest stays selected, ending any look at another zone. Returns whether it was one
	]]
	function questMap.PickQuestZone(mapID)
		if not tContains(zones, mapID) then
			return false
		end
		if questMap.browseMapID and questMap.EndBrowse then
			questMap.EndBrowse()
		end
		chosenMapID = mapID
		ShowZone(mapID)
		return true
	end

	--[[
		The quest's zones, and with Zone Info on (questMap.AddZoneInfoMenu, Zone-Info.lua) Back to Quest while
		it looks at another zone, This Quest over the quest's zones, then Zone Info's own groups of zones
	]]
	zoneDropdown:SetupMenu(function(_, rootDescription)
		local zoneInfo = questMap.zoneInfoShown and questMap.AddZoneInfoMenu
		if zoneInfo and questMap.browseMapID then
			rootDescription:CreateButton(ns.L["ZONE_INFO_BACK"], function()
				questMap.EndBrowse()
				questMap.FollowQuest()
			end)
			rootDescription:CreateDivider()
		end
		if zoneInfo and #zones > 0 then
			rootDescription:CreateTitle(ns.L["ZONE_INFO_MENU_QUEST"])
		end
		for _, mapID in ipairs(zones) do
			rootDescription:CreateRadio(ZoneName(mapID), function(data)
				return data == shownMapID and not questMap.browseMapID
			end, questMap.PickQuestZone, mapID)
		end
		if zoneInfo then
			questMap.AddZoneInfoMenu(rootDescription)
		end
	end)

	--[[
		The menu is worked out when it opens, or at once while it's open or as it comes into view, rather than
		on every refresh: with Zone Info on it reads every available quest's zone, and the map refreshes each
		time Questie moves an icon. The button's text is set apart (OverrideText in ShowZone)
	]]
	local menuStale = false
	local function FreshenMenu()
		if menuStale then
			menuStale = false
			zoneDropdown:GenerateMenu()
		end
	end
	if type(zoneDropdown.OpenMenu) == "function" then
		local OpenMenu = zoneDropdown.OpenMenu
		zoneDropdown.OpenMenu = function(self, ...)
			FreshenMenu()
			return OpenMenu(self, ...)
		end
	end
	local OnMouseDown = zoneDropdown:GetScript("OnMouseDown")
	if OnMouseDown then
		zoneDropdown:SetScript("OnMouseDown", function(self, ...)
			FreshenMenu()
			return OnMouseDown(self, ...)
		end)
	end
	local canWait = type(zoneDropdown.OpenMenu) == "function" and type(zoneDropdown.IsMenuOpen) == "function"

	-- Shown for a quest across zones, and always while Zone Info shows
	local function UpdateZoneDropdown()
		local wasShown = zoneDropdown:IsShown()
		zoneDropdown:SetShown(#zones > 1 or questMap.zoneInfoShown or false)
		menuStale = true
		if not canWait or zoneDropdown:IsMenuOpen() or (zoneDropdown:IsShown() and not wasShown) then
			FreshenMenu()
		end
	end
	hooksecurefunc(questMap, "SetZoneInfoShown", UpdateZoneDropdown)

	--[[
		Puts the map on a quest from Questie's icons: the zone picked from the dropdown while the quest stays
		selected, otherwise the player's zone when the quest has icons there, otherwise the zone holding most
		of them, otherwise fallbackMapID: a map ID, or a function returning one, asked only then.
		questMap.questieQuestID is the quest while Questie has icons for it. Returns whether it has any
	]]
	function questMap.FollowQuestieQuest(questID, fallbackMapID)
		if questID ~= shownQuestID then
			chosenMapID = nil
			-- Picking another quest in the log ends a look at another zone (Zone-Info.lua)
			if questMap.browseMapID and shownQuestID ~= nil and questMap.EndBrowse then
				questMap.EndBrowse()
			end
		end
		shownQuestID = questID
		zones = QuestZones(questID)

		local playerMapID = MapUtil.GetDisplayableMapForPlayer()
		local mapID = zones[1]
		if not mapID then
			mapID = type(fallbackMapID) == "function" and fallbackMapID() or fallbackMapID
		end
		if chosenMapID and tContains(zones, chosenMapID) then
			mapID = chosenMapID
		elseif tContains(zones, playerMapID) then
			mapID = playerMapID
		end
		ShowZone(mapID)
		UpdateZoneDropdown()

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
				zoneChanged = false
				questMap.FollowQuest()
				if not zoneChanged then
					questieProvider:RefreshAllData()
				end
			end
		end)
	end

	-- The circles around icons are sized for the map's size on screen, so a resized map draws them again
	canvas.ScrollContainer:HookScript("OnSizeChanged", questMap.RequestRefresh)

	if hereBeDragonsPins then
		for _, name in ipairs({
			"AddWorldMapIconMap",
			"AddWorldMapIconWorld",
			"RemoveWorldMapIcon",
			"RemoveAllWorldMapIcons",
		}) do
			if hereBeDragonsPins[name] then
				hooksecurefunc(hereBeDragonsPins, name, questMap.RequestRefresh)
			end
		end
	end
end)
