local _, ns = ...

--[[
	Routes: a stop's tooltip on the world map (Routes-Map.lua), from what the stop holds (Routes-Stop-Lines.lua)
]]

local routes = ns.routes
local L = ns.L

--[[
	A stop's quests on the map's tooltip, as the other add-ons lay out a tooltip's rows: a space in from the
	title, the name on the left and its count ("4 / 12") on the right. Each objective leads with the quest
	log's check once it's done (or a blank the same size, so the names line up), in line with the name of
	the player it's under. In a party each quest is split by who has it: the player first, where they have
	it, then each member Questie shares a quest log for, with their own progress. Alone, the player's name
	is left off and the checks sit where it would
]]
local ROW_INDENT = " "

-- Why a quest to pick up is on the map but not the route, by its task's offRoute (Routes-Pick-Ups.lua)
local OFF_ROUTE_REASONS = {
	dungeon = "ROUTES_OFF_ROUTE_DUNGEON",
	raid = "ROUTES_OFF_ROUTE_RAID",
	escort = "ROUTES_OFF_ROUTE_ESCORT",
	elsewhere = "ROUTES_OFF_ROUTE_ELSEWHERE",
	full = "ROUTES_OFF_ROUTE_LOG_FULL",
	far = "ROUTES_OFF_ROUTE_FAR",
	elite = "ROUTES_OFF_ROUTE_ELITE",
	group = "ROUTES_OFF_ROUTE_GROUP",
	pvp = "ROUTES_OFF_ROUTE_PVP",
	level = "ROUTES_OFF_ROUTE_LEVEL", -- Formatted with the level it goes on the route at (task.opensAt)
	xp = "ROUTES_OFF_ROUTE_XP",
	zone = "ROUTES_OFF_ROUTE_ZONE", -- In a zone the route isn't planned in (Routes-Map-Zones.lua)
}

-- A name in its class color, where the client says the class
local function PlayerName(unit, name)
	local red, green, blue = routes.ClassColor(unit)
	return string.format("|cff%02x%02x%02x%s|r", red * 255, green * 255, blue * 255, name)
end

--[[
	One objective line: its check, name, and "4 / 12" on the right, where it has a count. In the world map's
	menu (routes.MapMenuRows) a count not yet done is light yellow, as a menu's values are; on a tooltip it's
	white, as the name is
]]
local function AddObjective(tooltip, objective, have, need, done)
	local left = ROW_INDENT .. ns.CheckIcon(GameTooltipText, done) .. " " .. routes.ObjectiveName(objective)
	local red, green, blue = ns.GetColorRGB(done and "HELP" or "TEXT")
	if need then
		local count = routes.CountText(have, need)
		local countRed, countGreen, countBlue = red, green, blue
		if tooltip.isMenu and not done then
			countRed, countGreen, countBlue = ns.GetColorRGB("VALUE")
		end
		tooltip:AddDoubleLine(left, count, red, green, blue, countRed, countGreen, countBlue)
	else
		tooltip:AddLine(left, red, green, blue)
	end
end

--[[
	A player's name, in a party, then their progress on the objectives here; nothing where they have none of
	them. A blank line comes before every player's but the quest's first (shown). Returns whether it added any
]]
local function AddPlayer(tooltip, name, rows, inParty, shown)
	if #rows == 0 then
		return false
	end
	if inParty then
		if shown then
			tooltip:AddLine(" ")
		end
		tooltip:AddLine(ROW_INDENT .. name, ns.GetColorRGB("TEXT"))
	end
	for _, row in ipairs(rows) do
		AddObjective(tooltip, row.objective, row.have, row.need, row.done)
	end
	return true
end

-- Under a quest's title: the player's progress on its objectives here, then each party member's
local function AddProgress(tooltip, entry, objectives)
	local quest = entry.task.quest or {}
	local inParty = routes.ShowsParty()
	local shown = false
	if not quest.party then
		local rows = {}
		for _, objective in ipairs(objectives) do
			rows[#rows + 1] = {
				objective = objective,
				have = objective.Collected,
				need = objective.Needed,
				done = objective.Completed,
			}
		end
		shown = AddPlayer(
			tooltip,
			PlayerName("player", routes.UnitFullName("player") or UnitName("player")),
			rows,
			inParty,
			shown
		)
	end
	for _, member in ipairs(inParty and routes.MemberProgress(entry.task.questID) or {}) do
		local rows = {}
		for _, objective in ipairs(objectives) do
			local remote = routes.MemberObjective(quest, member, objective)
			if remote then
				rows[#rows + 1] = {
					objective = objective,
					have = remote.fulfilled,
					need = remote.required,
					done = remote.finished,
				}
			end
		end
		shown = AddPlayer(tooltip, PlayerName(member.name, member.shortName), rows, inParty, shown) or shown
	end
end

--[[
	Adds a stop's quests to the tooltip, a blank line between them: each quest's title, then its objectives
	at the stop, done or not, in the quest log's order. Where nothing's left but the turn-in, the quest is
	one line, "Turn in [2] Wayward Weapons" ("Future Turn in" while it can't be handed in yet). A corpse is one line too, "Run Back to Your Corpse"
]]
function routes.AddStopTooltip(tooltip, stop)
	if stop.corpse then
		tooltip:AddLine(L["ROUTES_CORPSE"], ns.GetColorRGB("TEXT"))
		return
	end
	for _, entry in ipairs(routes.QuestsAt(stop, routes.PositionAt(stop))) do
		if tooltip:NumLines() > 0 then
			tooltip:AddLine(" ")
		end
		local objectives, anyLeft = {}, false
		for _, objective in ipairs(routes.QuestObjectives(entry)) do
			if entry.here[objective] then
				objectives[#objectives + 1] = objective
				anyLeft = anyLeft or entry.left[objective] == true
			end
		end
		if entry.flightPath then
			local text = string.format(L["ROUTES_FLIGHT_PATH_FROM"], entry.task.flightMaster or "")
			tooltip:AddLine(text, ns.GetColorRGB("TITLE"))
		elseif entry.fly then
			tooltip:AddLine(routes.TaskText(entry.task), ns.GetColorRGB("TITLE"))
		elseif entry.pickUp then
			local title, red, green, blue = routes.QuestTitle(entry.task)
			tooltip:AddLine(string.format(L["ROUTES_PICK_UP_QUEST"], title), red, green, blue)
			-- Why a map-only pick-up isn't on the route (Routes-Pick-Ups.lua), indented a space as objectives are
			local reason = OFF_ROUTE_REASONS[entry.task.offRoute or ""]
			if reason then
				tooltip:AddLine(ROW_INDENT .. L[reason]:format(entry.task.opensAt or 0), ns.GetColorRGB("HELP"))
			end
			-- A follow-up planned ahead (Routes-Chains.lua): the turn-in that unlocks it, the party's for theirs
			local after = entry.task.after
			if after then
				local unlocker = routes.QuestTitle(after)
				local text = L[after.party and "ROUTES_AFTER_PARTY_TURN_IN" or "ROUTES_AFTER_TURN_IN"]
				tooltip:AddLine(ROW_INDENT .. string.format(text, unlocker), ns.GetColorRGB("HELP"))
			end
		elseif entry.turnIn and not anyLeft then
			-- One not done yet is planned ahead: "Future Turn in", as it can't be handed in now
			local title = routes.QuestTitle(entry.task)
			local format = L[entry.turnInReady and "ROUTES_TURN_IN_QUEST" or "ROUTES_FUTURE_TURN_IN_QUEST"]
			tooltip:AddLine(string.format(format, title), ns.GetColorRGB("TITLE"))
		else
			tooltip:AddLine(routes.ObjectivesTitle(entry.task))
			AddProgress(tooltip, entry, objectives)
		end
	end
end
