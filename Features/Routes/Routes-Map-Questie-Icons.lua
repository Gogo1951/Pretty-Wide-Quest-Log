local _, ns = ...

--[[
	Routes: Questie's own map icons for what the route's markers stand in for, and its ! for every quest to
	pick up but a many-source drop, hidden on every map while the Routes map shows, but for the hovered
	marker's, and those in other zones on a zone's map, and the textures the markers borrow from them
]]

local routes = ns.routes

--[[
	The template of the pins Questie's icons sit on. Questie 12.8.0 names it after the addon and says so on
	its HereBeDragons-Pins; before that it was a fixed name
]]
local OLD_QUESTIE_TEMPLATE = "HereBeDragonsPinsTemplateQuestie"
local function QuestieTemplate()
	local pins = ns.QuestieHereBeDragonsPins()
	return pins and pins.worldmapPinTemplate or OLD_QUESTIE_TEMPLATE
end

--------------------------------------------------------------------------------
-- Questie's icons
--------------------------------------------------------------------------------

--[[
	Notes a task's objective, turn-in or pick-up in the sets: a party objective by its quest and place in it too,
	as Questie's map icons for a party member's objective hold an objective of Questie's own making
]]
local function NoteTask(task, objectives, turnIns, pickUps)
	if task.kind == "turnIn" then
		turnIns[task.questID] = true
	elseif task.kind == "pickUp" then
		pickUps[task.questID] = true
	elseif task.objective then
		objectives[task.objective] = true
		if task.objective.party then
			objectives[routes.PartyObjectiveKey(task.questID, task.objective.Index)] = true
		end
	end
end

--[[
	What the route and the camps stand in for: each objective on them, each quest they turn in and each
	they pick up. Questie's icons for these are hidden on every map, and lend the markers their look
]]
local function RouteTasks()
	local objectives, turnIns, pickUps = {}, {}, {}
	for _, list in ipairs({ routes.stops, routes.camps }) do
		for _, stop in ipairs(list) do
			for _, task in ipairs(stop.tasks) do
				NoteTask(task, objectives, turnIns, pickUps)
			end
		end
	end
	return objectives, turnIns, pickUps
end

-- The stop under the mouse, whose objectives' icons Questie shows again while it's hovered
routes.hoveredStop = nil -- Set and cleared by the stop pins (Routes-Map.lua)

local function HoveredTasks()
	local objectives, turnIns, pickUps = {}, {}, {}
	for _, task in ipairs(routes.hoveredStop and routes.hoveredStop.tasks or {}) do
		NoteTask(task, objectives, turnIns, pickUps)
	end
	return objectives, turnIns, pickUps
end

local function IsRouteIcon(data, objectives, turnIns, pickUps)
	if data.Type == "complete" then
		return turnIns[data.Id]
	elseif data.Type == "available" then
		return pickUps[data.Id] or false
	end
	local objective = data.Type ~= "available" and data.ObjectiveData
	if not objective then
		return false
	end
	return objectives[objective]
		or (objective.IsPartyObjective and objectives[routes.PartyObjectiveKey(objective.questId, objective.Index)])
end

--[[
	Questie's dimmed icons for a party member's objective, on a quest the player doesn't have. The route
	draws the ones it plans for as white-ringed waypoints; the rest it leaves out on purpose (Include Party
	Members' Quests off, a member turned off in the Quest Arrow's menu or away from the zone, a dungeon
	quest), so Questie's icons for those are hidden as well rather than crowding the map
]]
local function IsPartyIcon(data)
	local objective = data.Type ~= "available" and data.Type ~= "complete" and data.ObjectiveData
	return objective and objective.IsPartyObjective == true or false
end

--[[
	Whether a quest's Questie ! stays while every other is hidden: one started by an item that several kinds
	of creature or object drop, which the route has no marker for (routes.pickUpHelpers.IsManySourceDrop).
	Kept by quest ID once Questie's database answers; the database doesn't change
]]
local keepsIcon = {}
local function KeepsQuestieIcon(questID)
	local kept = keepsIcon[questID]
	if kept == nil then
		local helpers = routes.pickUpHelpers
		local QuestieDB = ns.ImportQuestieModule("QuestieDB")
		if not (helpers and QuestieDB and type(QuestieDB.QueryQuestSingle) == "function" and questID) then
			return true -- Nothing to tell by yet: Questie's icon stays
		end
		kept = helpers.IsManySourceDrop(QuestieDB, questID)
		keepsIcon[questID] = kept
	end
	return kept
end

--[[
	Questie's ! for a quest to pick up, hidden whatever its kind while the route draws pick-ups (Nearby
	Pick-Ups or Plan Ahead): dungeon, raid, elite and group quests, ones below Lowest Quest Level and ones
	whose giver has no place, as much as those with a marker. Only a many-source drop's stays
	(KeepsQuestieIcon). With Your Quests Only the route draws none, so Questie's stay but for those on the route
]]
local function IsHiddenPickUp(data, current)
	return data.Type == "available" and current.allPickUps and not KeepsQuestieIcon(data.Id)
end

-- The sets a pin is checked against, worked out at most once a frame: Questie places pins a batch at a time
local sets, setsTime = {}, nil
local function Sets()
	local now = GetTime()
	if setsTime ~= now then
		setsTime = now
		-- Not on a continent's or the world's map while it has no markers to stand in for them
		local mapID = WorldMapFrame and WorldMapFrame:GetMapID()
		sets.hide = routes.IsMapShownOn(mapID) and routes.Settings().hideQuestieIcons
		sets.zoneMapID = mapID and not routes.IsWideMap(mapID) and mapID or nil -- A zone's map keeps to its zone
		sets.allPickUps = routes.PlansPickUps() -- Every Questie ! but a many-source drop's hides (IsHiddenPickUp)
		sets.objectives, sets.turnIns, sets.pickUps = RouteTasks()
		--[[
			Every quest to pick up the map's zone discs count, on a continent's or the world's map, or that has
			a marker on a zone's map in place of the route's (Routes-Map-Zones.lua)
		]]
		for questID in pairs(routes.zoneDiscQuests or {}) do
			sets.pickUps[questID] = true
		end
		sets.hoveredObjectives, sets.hoveredTurnIns, sets.hoveredPickUps = HoveredTasks()
	end
	return sets
end

--[[
	Whether a pin stands outside the zone a zone's map is of, as the route's markers keep to it
	(routes.IsInMapZone): a zone's map reaches over its neighbors' edges, and their icons there are theirs.
	A city in it or a zone linked to it counts as in it, so Thunder Bluff's show on Mulgore's map. Worked
	out once for each pin's place on the map, a pin being handed out again for another icon
]]
local function IsOtherZonePin(pin, mapID)
	local x, y = pin:GetPosition()
	if not (mapID and x and y) then
		return false
	end
	local place = pin.routeZonePlace
	if not (place and place.mapID == mapID and place.x == x and place.y == y) then
		local hereBeDragons = routes.HereBeDragons()
		local worldX, worldY, instance
		if hereBeDragons then
			worldX, worldY, instance = hereBeDragons:GetWorldCoordinatesFromZone(x, y, mapID)
		end
		place = place or {}
		place.mapID, place.x, place.y = mapID, x, y
		place.outside = worldX ~= nil and not routes.IsInMapZone({ x = worldX, y = worldY, instance = instance }, mapID)
		pin.routeZonePlace = place
	end
	return place.outside
end

--[[
	Hides the pins holding Questie's icons for what the route stands in for, for every party member's
	objective and for every quest to pick up but a many-source drop (IsHiddenPickUp), but for the hovered
	stop's, and every one in another zone on a zone's map (IsOtherZonePin), and shows again any it hid
	before that no longer are. The pins are HereBeDragons', which Questie never shows or hides itself, so
	Questie's own icon state is left alone, and a pin handed out again shows on its own
]]
local function ApplyToPin(pin, current)
	local data = pin.icon and pin.icon.data
	local covered = false
	if data then
		local onRoute = IsRouteIcon(data, current.objectives, current.turnIns, current.pickUps)
		local hovered = IsRouteIcon(data, current.hoveredObjectives, current.hoveredTurnIns, current.hoveredPickUps)
		covered = (onRoute or IsPartyIcon(data) or IsHiddenPickUp(data, current)) and not hovered
	end
	local hidden = current.hide and (covered or IsOtherZonePin(pin, current.zoneMapID))
	if hidden then
		pin:Hide()
		pin.hiddenByRoute = true
	elseif pin.hiddenByRoute then
		pin:Show()
		pin.hiddenByRoute = nil
	end
end

local function ApplyQuestieIcons()
	if not WorldMapFrame then
		return
	end
	setsTime = nil -- The route or the hovered marker may have changed this frame
	local current = Sets()
	for pin in WorldMapFrame:EnumeratePinsByTemplate(QuestieTemplate()) do
		ApplyToPin(pin, current)
	end
end

--[[
	The pin Questie just placed for an icon, checked as it lands rather than a frame later: Questie redraws
	a party member's objectives whenever their progress comes in, and a frame is long enough to see them
	flash. HereBeDragons parents the icon to its pin
]]
local function ApplyToPlacedIcon(icon)
	local pin = icon and icon.GetParent and icon:GetParent()
	if pin and pin.icon == icon then
		ApplyToPin(pin, Sets())
	end
end

-- Questie draws in batches, a pin at a time, so the icons are checked again once a batch is done
local applyPending
local function RequestApplyQuestieIcons()
	if applyPending then
		return
	end
	applyPending = true
	C_Timer.After(0, function()
		applyPending = nil
		ApplyQuestieIcons()
	end)
end

-- The texture of Questie's icon for each objective on the route, each quest's turn-in and pick-up, on the map shown
local function QuestieTextures()
	local byObjective, byTurnIn, byPickUp = {}, {}, {}
	for pin in WorldMapFrame:EnumeratePinsByTemplate(QuestieTemplate()) do
		local icon = pin.icon
		local data = icon and icon.data
		if data and icon.texture then
			if data.Type == "complete" then
				byTurnIn[data.Id] = byTurnIn[data.Id] or icon.texture:GetTexture()
			elseif data.Type == "available" then
				byPickUp[data.Id] = byPickUp[data.Id] or icon.texture:GetTexture()
			elseif data.ObjectiveData and not byObjective[data.ObjectiveData] then
				byObjective[data.ObjectiveData] = icon.texture:GetTexture()
			end
		end
	end
	return byObjective, byTurnIn, byPickUp
end

-- The route and its markers call these as they draw (Routes-Map.lua)
routes.ApplyQuestieIcons = ApplyQuestieIcons
routes.RequestApplyQuestieIcons = RequestApplyQuestieIcons
routes.ApplyToPlacedQuestieIcon = ApplyToPlacedIcon
routes.QuestieTextures = QuestieTextures
