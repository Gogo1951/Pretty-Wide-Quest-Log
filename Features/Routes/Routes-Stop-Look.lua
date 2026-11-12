local ADDON_NAME, ns = ...

--[[
	Routes: how a marker looks, its disc, ring and icon, for the zone map's waypoints and camps
	(Routes-Map.lua) and the minimap's markers (Routes-Minimap.lua) alike
]]

local routes = ns.routes

-- A stop's disc: with its black ring, or the fill alone, under a tinted ring (a party member's, a dungeon's, an ignored one)
local DISC_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Stop"
local PARTY_DISC_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Stop-Fill"

--[[
	The corpse's gravestone, the one the game marks it with on the world map and minimap (Blizzard's
	CorpsePinTemplate: a cell of the POI icons), on its waypoint's marker. The cell differs by client, so
	its coords are each flavor's data (Data/{Game}/Map-Icons)
]]
routes.CORPSE_ICON = "Interface\\Minimap\\POIIcons"
routes.CORPSE_ICON_COORDS = ns.CORPSE_ICON_COORDS

local function IsEveryTask(stop, test)
	for _, task in ipairs(stop.tasks) do
		if not test(task) then
			return false
		end
	end
	return true
end

-- An objective the route won't take: a dungeon or raid quest's, inside the instance, or one ignored
local function IsUntrackedTask(task)
	return task.untracked or (task.key ~= nil and routes.skipped[task.key] ~= nil)
end

-- A marker whose every objective the route won't take, a dungeon's or one ignored
local function IsUntracked(stop)
	return not stop.corpse and IsEveryTask(stop, IsUntrackedTask)
end

-- Not a dungeon or raid quest's: what the route won't take there is only ignored, for the gray ring over the red
local function IsUntrackedOnlyIgnored(stop)
	return IsEveryTask(stop, function(task)
		return not task.untracked
	end)
end

-- For the camp markers' dimming on the zone map (Routes-Map.lua)
routes.IsUntrackedStop = IsUntracked

--[[
	Questie's icon for an objective, or a turn-in, from the icon type it draws them with, in the user's
	Questie icon theme. For a stop whose Questie pins aren't on the map yet: Questie draws them a while
	after a quest is taken or changes, and the route can be drawn first
]]
local function QuestieIcon(task)
	local icons = Questie and Questie.usedIcons
	if not icons then
		return nil
	end
	if task.kind == "pickUp" then
		return icons[Questie.ICON_TYPE_AVAILABLE]
	end
	if task.kind == "turnIn" then
		-- Questie's gray question mark for a quest not done yet, planned ahead of its objectives being done
		local incomplete = not task.ready and Questie.ICON_TYPE_INCOMPLETE
		return incomplete and icons[incomplete] or icons[Questie.ICON_TYPE_COMPLETE]
	end
	local objective = task.objective or {}
	local iconType = objective.Icon
	if not iconType and type(objective.spawnList) == "table" then
		for _, spawn in pairs(objective.spawnList) do
			if type(spawn) == "table" and spawn.Icon then
				iconType = spawn.Icon
				break
			end
		end
	end
	return iconType and icons[iconType]
end

--[[
	Whether every task at a stop is a party member's, whose marker has a white ring in place of the black
	one. A stop with any of the player's own on it is the player's, party objectives merged in or not
]]
local function IsPartyStop(stop)
	return IsEveryTask(stop, function(task)
		return task.party
	end)
end

--[[
	A marker's disc, ring and icon, on the zone map's pins and the minimap's markers (Routes-Minimap.lua)
	alike: anything with the Disc, Ring and Icon textures of the stop template in Routes.xml. textures are
	the icons on Questie's own world map pins; where one is missing, Questie's icon for that kind
]]
function routes.ApplyStopLook(marker, stop, textures)
	--[[
		The first task's look: its objective's color and Questie's icon for it, or the turn-in's: the one on
		Questie's own pins, else the one Questie draws that kind with
	]]
	local task = stop.tasks[1]
	marker.Disc:SetVertexColor(routes.TaskColor(task))
	--[[
		A ring for one the route won't take: red, to stand out, for a dungeon or raid quest's, light gray for
		one ignored. A white one for a party member's, a quest the player doesn't have; else the disc's black ring
	]]
	local ringColor
	if IsUntracked(stop) then
		ringColor = IsUntrackedOnlyIgnored(stop) and "ROUTE_IGNORED_RING" or "ROUTE_ALERT_RING"
	elseif IsPartyStop(stop) then
		ringColor = "ROUTE_PARTY_RING"
	end
	marker.Disc:SetTexture(ringColor and PARTY_DISC_TEXTURE or DISC_TEXTURE)
	marker.Ring:SetShown(ringColor ~= nil)
	if ringColor then
		marker.Ring:SetVertexColor(ns.GetColorRGB(ringColor))
	end
	local texture
	if task.kind == "corpse" then
		texture = routes.CORPSE_ICON
	elseif task.kind == "turnIn" then
		texture = textures.turnIns[task.questID]
	elseif task.kind == "pickUp" then
		texture = textures.pickUps[task.questID]
	elseif task.kind == "flightPath" then
		texture = routes.FLIGHT_ICON -- The minimap tracking menu's flight master icon
	else
		texture = textures.objectives[task.objective]
	end
	texture = texture or (task.kind ~= "corpse" and QuestieIcon(task)) or nil
	marker.Icon:SetTexture(texture)
	-- The corpse's gravestone is a cell of a sheet of icons; Questie's are whole textures
	if task.kind == "corpse" then
		marker.Icon:SetTexCoord(unpack(routes.CORPSE_ICON_COORDS))
	else
		marker.Icon:SetTexCoord(0, 1, 0, 1)
	end
	marker.Icon:SetShown(texture ~= nil)
end
