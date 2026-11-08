local _, ns = ...

--[[
	Every client: the selected quest's icons from Questie's world map, its objectives and turn-in, drawn
	again on the map (Quest-Map.lua) larger, with a dropdown for a quest whose icons span several zones.
	An objective's icons give way to its areas where it has them (Questie-Map-Areas.lua). Each client's
	own map file decides what the map shows when Questie has no icons for the quest
]]

ns.AddWideQuestLogPart(function()
	local questMap = ns.questMap
	local canvas = questMap.canvas

	-- Questie's own copies of HereBeDragons, which hold every icon it has placed on the world map
	local HBD = LibStub("HereBeDragonsQuestie-2.0", true)
	local HBDPins = LibStub("HereBeDragonsQuestie-Pins-2.0", true)

	local PIN_TEMPLATE = "PrettyWideQuestLogQuestiePinTemplate"
	local ICON_SIZE = 24 -- Near the size of Blizzard's quest markers, before Questie's scale for the icon's kind
	local CLUSTER_DISTANCE = 0.015 -- Icons this close, as a share of the map, share one tooltip
	local REFRESH_DELAY = 0.2 -- Questie draws in batches over several frames
	local ZONE_DROPDOWN_WIDTH = 180

	local shownQuestID

	--------------------------------------------------------------------------------
	-- Questie's icons
	--------------------------------------------------------------------------------

	--[[
		Leaves out route lines, and icons faded out entirely. Icons Questie's settings hide on its own maps
		are kept: this map shows the quest picked in the quest log, whatever Questie shows elsewhere
	]]
	local function IsShownIcon(icon)
		if icon.type == "line" or not (icon.data and icon.texture) then
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
			if placement.uiMapID == mapID and icon.data and icon.data.Id == questID and IsShownIcon(icon) then
				local x, y =
					HBD:GetZoneCoordinatesFromWorldInstance(placement.x, placement.y, placement.instanceID, mapID)
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
	-- Tooltip
	--------------------------------------------------------------------------------

	-- One space a row, as every list under a heading in the add-on's tooltips is indented
	local ROW_INDENT = " "

	-- An icon's objective: its description, its progress where it counts something, and whether it's done
	local function ObjectiveRow(data)
		local objective = data.ObjectiveData
		if not (objective and objective.Description) then
			return nil
		end
		local have, need = objective.Collected or 0, objective.Needed
		return {
			description = objective.Description,
			count = need and string.format("%s / %s", tostring(have), tostring(need)) or nil,
			done = objective.Completed or (need ~= nil and have >= need) or false,
		}
	end

	local function HasObjective(objectives, row)
		for _, other in ipairs(objectives) do
			if other.description == row.description then
				return true
			end
		end
		return false
	end

	--[[
		The quest, then every NPC or object around the hovered icon with its objectives, as Questie's world
		map groups them. An area's marker stands for every NPC or object in the area
	]]
	local function ShowPinTooltip(pin)
		local x, y = pin:GetPosition()
		local entries, byName = {}, {}
		for other in canvas:EnumeratePinsByTemplate(PIN_TEMPLATE) do
			local otherX, otherY = other:GetPosition()
			if math.abs(otherX - x) < CLUSTER_DISTANCE and math.abs(otherY - y) < CLUSTER_DISTANCE then
				local objective = ObjectiveRow(other.data)
				for _, name in ipairs(other.area and other.area.names or { other.data.Name or "" }) do
					local entry = byName[name]
					if not entry then
						entry = { name = name, objectives = {} }
						byName[name] = entry
						entries[#entries + 1] = entry
					end
					if objective and not HasObjective(entry.objectives, objective) then
						entry.objectives[#entry.objectives + 1] = objective
					end
				end
			end
		end

		GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
		local quest = pin.data.QuestData
		if quest and quest.name then
			GameTooltip:AddLine(quest.name)
		end
		for _, entry in ipairs(entries) do
			GameTooltip:AddLine(entry.name, ns.GetColorRGB("TEXT"))
			-- Each objective leads with the quest log's check once it's done, and its count sits on the right
			for _, objective in ipairs(entry.objectives) do
				local left = ROW_INDENT .. ns.CheckIcon(GameTooltipText, objective.done) .. " " .. objective.description
				local red, green, blue = ns.GetColorRGB(objective.done and "HELP" or "TEXT")
				if objective.count then
					GameTooltip:AddDoubleLine(left, objective.count, red, green, blue, red, green, blue)
				else
					GameTooltip:AddLine(left, red, green, blue)
				end
			end
		end
		GameTooltip:Show()
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

	-- One of Questie's icons drawn again at x, y (0-1), or a marker for an area in that icon's look
	local function AddPin(map, icon, x, y, area)
		local pin = map:AcquirePin(PIN_TEMPLATE)
		pin.data = icon.data
		pin.area = area
		local size = IconSize(icon)
		pin:SetSize(size, size)
		pin.Texture:SetTexture(icon.texture:GetTexture())
		pin.Texture:SetTexCoord(icon.texture:GetTexCoord())
		pin.Texture:SetVertexColor(icon.texture:GetVertexColor())
		SetGlow(pin, icon, size)
		pin:SetScript("OnEnter", ShowPinTooltip)
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

	local TURN_IN_COLOR = { ns.GetColorRGB("TITLE") } -- The gold of the turn-in's question mark

	--[[
		With Show Objective Areas on, each objective Questie has spawns for on the map is drawn as its areas
		(Questie-Map-Areas.lua), one marker in each in the look of one of its icons there, in place of its
		icons. The rest of the quest's icons, the turn-in among them, are drawn as Questie draws them, each
		in a small circle of its own so it stands out as well. questMap.areaCount is how many areas and
		circles are shaded, for the Quest Map Context report
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

		local areasByObjective, shapes = {}, {}
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

	local function ShowZone(mapID)
		shownMapID = mapID
		if questMap.ShowMap(mapID) then
			zoneChanged = true
		end
	end

	-- A quest with icons in more than one zone gets a dropdown on the map to pick between them
	local zoneDropdown = CreateFrame("DropdownButton", nil, questMap.holder, "WowStyle2DropdownTemplate")
	zoneDropdown:SetPoint("TOPLEFT", canvas, "TOPLEFT", ns.LAYOUT.SPACE.NEAR, -ns.LAYOUT.SPACE.NEAR)
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
		of them, otherwise fallbackMapID: a map ID, or a function returning one, asked only then.
		questMap.questieQuestID is the quest while Questie has icons for it. Returns whether it has any
	]]
	function questMap.FollowQuestieQuest(questID, fallbackMapID)
		if questID ~= shownQuestID then
			chosenMapID = nil
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
end)
