local _, ns = ...

--[[
	Routes: Questie's own map icons for what the route's markers stand in for, hidden on every map while the
	Routes map shows, but for the hovered marker's, and the textures the markers borrow from them
]]

local routes = ns.routes

local QUESTIE_TEMPLATE = "HereBeDragonsPinsTemplateQuestie" -- The pins Questie's icons sit on

--------------------------------------------------------------------------------
-- Questie's icons
--------------------------------------------------------------------------------

--[[
	Notes a task's objective or turn-in in the sets: a party objective by its quest and place in it too,
	as Questie's map icons for a party member's objective hold an objective of Questie's own making
]]
local function NoteTask(task, objectives, turnIns)
	if task.kind == "turnIn" then
		turnIns[task.questID] = true
	elseif task.objective then
		objectives[task.objective] = true
		if task.objective.party then
			objectives[routes.PartyObjectiveKey(task.questID, task.objective.Index)] = true
		end
	end
end

--[[
	What the route and the camps stand in for: each objective on them, and each quest they turn in.
	Questie's icons for these are hidden on every map, and lend the markers their look
]]
local function RouteTasks()
	local objectives, turnIns = {}, {}
	for _, list in ipairs({ routes.stops, routes.camps }) do
		for _, stop in ipairs(list) do
			for _, task in ipairs(stop.tasks) do
				NoteTask(task, objectives, turnIns)
			end
		end
	end
	return objectives, turnIns
end

-- The stop under the mouse, whose objectives' icons Questie shows again while it's hovered
routes.hoveredStop = nil -- Set and cleared by the stop pins (Routes-Map.lua)

local function HoveredTasks()
	local objectives, turnIns = {}, {}
	for _, task in ipairs(routes.hoveredStop and routes.hoveredStop.tasks or {}) do
		NoteTask(task, objectives, turnIns)
	end
	return objectives, turnIns
end

local function IsRouteIcon(data, objectives, turnIns)
	if data.Type == "complete" then
		return turnIns[data.Id]
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
	draws the ones it plans for as red-ringed waypoints; the rest it leaves out on purpose (Include Party
	Members' Quests off, a member turned off in the Quest Arrow's menu or away from the zone, a dungeon
	quest), so Questie's icons for those are hidden as well rather than crowding the map
]]
local function IsPartyIcon(data)
	local objective = data.Type ~= "available" and data.Type ~= "complete" and data.ObjectiveData
	return objective and objective.IsPartyObjective == true or false
end

--[[
	Hides the pins holding Questie's icons for what the route stands in for, and for every party member's
	objective, but for the hovered stop's, and shows again any it hid before that no longer are. The pins
	are HereBeDragons', which Questie never shows or hides itself, so Questie's own icon state is left
	alone, and a pin handed out again shows on its own
]]
-- The sets a pin is checked against, worked out at most once a frame: Questie places pins a batch at a time
local sets, setsTime = {}, nil
local function Sets()
	local now = GetTime()
	if setsTime ~= now then
		setsTime = now
		sets.hide = routes.IsMapShown() and routes.Settings().hideQuestieIcons
		sets.objectives, sets.turnIns = RouteTasks()
		sets.hoveredObjectives, sets.hoveredTurnIns = HoveredTasks()
	end
	return sets
end

local function ApplyToPin(pin, current)
	local data = pin.icon and pin.icon.data
	local hidden = current.hide
		and data
		and (IsRouteIcon(data, current.objectives, current.turnIns) or IsPartyIcon(data))
		and not IsRouteIcon(data, current.hoveredObjectives, current.hoveredTurnIns)
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
	for pin in WorldMapFrame:EnumeratePinsByTemplate(QUESTIE_TEMPLATE) do
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

-- The texture of Questie's icon for each objective on the route, and for each quest's turn-in, on the map shown
local function QuestieTextures()
	local byObjective, byTurnIn = {}, {}
	for pin in WorldMapFrame:EnumeratePinsByTemplate(QUESTIE_TEMPLATE) do
		local icon = pin.icon
		local data = icon and icon.data
		if data and icon.texture then
			if data.Type == "complete" then
				byTurnIn[data.Id] = byTurnIn[data.Id] or icon.texture:GetTexture()
			elseif data.ObjectiveData and not byObjective[data.ObjectiveData] then
				byObjective[data.ObjectiveData] = icon.texture:GetTexture()
			end
		end
	end
	return byObjective, byTurnIn
end

-- The route and its markers call these as they draw (Routes-Map.lua)
routes.ApplyQuestieIcons = ApplyQuestieIcons
routes.RequestApplyQuestieIcons = RequestApplyQuestieIcons
routes.ApplyToPlacedQuestieIcon = ApplyToPlacedIcon
routes.QuestieTextures = QuestieTextures
