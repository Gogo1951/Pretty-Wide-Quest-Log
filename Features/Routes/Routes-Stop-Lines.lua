local _, ns = ...

--[[
	Routes: what a stop holds, as the Quest Arrow (Routes-Arrow.lua) and the map's tooltip
	(Routes-Map-Tooltip.lua) list it
]]

local routes = ns.routes
local L = ns.L

local IsArea = routes.IsArea

--------------------------------------------------------------------------------
-- What a stop holds, for the arrow and the map's tooltip
--------------------------------------------------------------------------------

--[[
	"[13] Quest Name" and its difficulty color, or "[13D]" and so on for a dungeon quest: the letter comes
	as the quest list's does, from the tag ID and the client's elite flag (ns.GetQuestTagByID), with
	Questie's tag ID for a quest the client has no tag for
]]
function routes.QuestTitle(task)
	local level = task.quest and tonumber(task.quest.level)
	if not level or level <= 0 then
		return task.questName or "", ns.GetColorRGB("TITLE")
	end
	local tagID, isElite = ns.GetQuestTagByID(task.questID)
	if not tagID then
		local QuestieDB = ns.ImportQuestieModule("QuestieDB")
		if QuestieDB and type(QuestieDB.GetQuestTagInfo) == "function" then
			local found, questieTagID = pcall(QuestieDB.GetQuestTagInfo, task.questID)
			if found then
				tagID = questieTagID
			end
		end
	end
	local suffix = ns.QuestSuffix(tagID, isElite)
	local color = GetQuestDifficultyColor(level)
	return ns.LevelTitle(level, task.questName, suffix), color.r, color.g, color.b
end

--[[
	The title line over a quest's objectives: routes.QuestTitle, or for a quest not taken yet, whose
	objectives are planned ahead (Routes-Chains.lua), "After you pick up [12] Quest Name" in the same color,
	or for a party member's, "After your party picks up"
]]
function routes.ObjectivesTitle(task)
	local title, red, green, blue = routes.QuestTitle(task)
	if task.predicted then
		title = string.format(L[task.party and "ROUTES_AFTER_PARTY_PICK_UP" or "ROUTES_AFTER_PICK_UP"], title)
	end
	return title, red, green, blue
end

-- Where a task is done: the place the route chose for it
function routes.TaskPoint(task)
	return task.candidates and task.candidates[task.choice or 1]
end

-- Whether a task's place is an area (a camp of mobs, a field of objects) rather than one place
function routes.IsAreaPoint(point)
	return point ~= nil and IsArea(point)
end

--[[
	Whether a task is still to do: an objective not yet done, a turn-in, or a flight path not yet
	discovered, which is done the moment the flight master says so, not at the next plan. An objective of
	the player's that they've done but someone in the party still needs (helping, Routes-Nodes.lua) is
	left until nobody does
]]
function routes.IsTaskLeft(task)
	if task.kind == "flightPath" then
		return not routes.IsFlightMasterKnown(task.npcID)
	end
	local objective = task.objective
	if not (objective and objective.Completed) then
		return true
	end
	return task.helping == true and routes.IsHelpNeeded(task)
end

-- Yards from a point to a task's place, or past the edge of its area, nothing when it has none
function routes.TaskDistance(task, x, y)
	local point = routes.TaskPoint(task)
	if not (point and x) then
		return nil
	end
	local dx, dy = point.x - x, point.y - y
	local yards = math.sqrt(dx * dx + dy * dy)
	if IsArea(point) then
		yards = math.max(0, yards - point.radius)
	end
	return yards
end

-- The player's position where it's on the stop's map, for sorting what's there by distance
local function PositionAt(stop)
	local x, y, instance = routes.PlayerPosition()
	if x and instance == stop.instance then
		return x, y
	end
end
routes.PositionAt = PositionAt

--[[
	The quests at a stop, each { task, here, turnIn, pickUp, flightPath, distance }: task the first of its
	tasks there, here the set of its objectives done at the stop, left those of them still to do
	(routes.IsTaskLeft), turnIn whether it's turned in there, pickUp whether it's picked up there. A flight
	path, which has no quest, is an entry of its own with flightPath set. Given the player's position,
	nearest first, each with distance[objective] for its objectives' places; else in route order
]]
function routes.QuestsAt(stop, x, y)
	local quests, byID = {}, {}
	for index, task in ipairs(stop.tasks) do
		local id = task.questID or task.key
		local entry = byID[id]
		if not entry then
			entry = { task = task, here = {}, left = {}, distance = {}, order = index, nearest = math.huge }
			byID[id] = entry
			quests[#quests + 1] = entry
		end
		if task.kind == "turnIn" then
			entry.turnIn = true
		elseif task.kind == "pickUp" then
			entry.pickUp = true
		elseif task.kind == "flightPath" then
			entry.flightPath = true
		elseif task.objective then
			entry.here[task.objective] = true
		end
		local left = routes.IsTaskLeft(task)
		if left and task.objective then
			entry.left[task.objective] = true
		end
		local yards = left and routes.TaskDistance(task, x, y)
		if yards then
			if task.objective then
				entry.distance[task.objective] = yards
			end
			entry.nearest = math.min(entry.nearest, yards)
		end
	end
	table.sort(quests, function(a, b)
		if a.nearest ~= b.nearest then
			return a.nearest < b.nearest
		end
		return a.order < b.order
	end)
	return quests
end

-- Every objective of a quest at a stop, in the quest log's order, then Questie's own extra ones it has there
function routes.QuestObjectives(entry)
	local quest, objectives = entry.task.quest or {}, {}
	if type(quest.Objectives) == "table" then
		local indexes = {}
		for index in pairs(quest.Objectives) do
			indexes[#indexes + 1] = index
		end
		table.sort(indexes)
		for _, index in ipairs(indexes) do
			objectives[#objectives + 1] = quest.Objectives[index]
		end
	end
	for objective in pairs(entry.here) do
		if not tContains(objectives, objective) then
			objectives[#objectives + 1] = objective
		end
	end
	return objectives
end

-- A count as the quest log writes it, "4 / 12"
function routes.CountText(have, need)
	return string.format("%s / %s", tostring(have or 0), tostring(need))
end

-- A player's class color, where the client says the class; white otherwise
function routes.ClassColor(unit)
	local ok, _, class = pcall(UnitClass, unit)
	local color = ok
		and ns.IsReadable(class)
		and type(class) == "string"
		and RAID_CLASS_COLORS
		and RAID_CLASS_COLORS[class]
	if color then
		return color.r, color.g, color.b
	end
	return ns.GetColorRGB("TEXT")
end

--[[
	A member's progress on an objective, from Questie's share of their quest log, by the objective's place
	in the quest. Questie's own extra objectives (SpecialObjectives) aren't shared, so they have none
]]
local function MemberObjective(quest, member, objective)
	local index = objective.Index
	if index and type(quest.Objectives) == "table" and quest.Objectives[index] == objective then
		local remote = member.objectives[index]
		return type(remote) == "table" and remote or nil
	end
end
routes.MemberObjective = MemberObjective -- For the map's tooltip (Routes-Map-Tooltip.lua)

--[[
	Who still needs an objective, in a party, each { name, unit, have, need }: the player first, where it's
	their quest, then each of members (routes.MemberProgress for the quest, worked out once per quest), by
	name. Anyone done with it is left off
]]
local function StillNeeded(entry, objective, members)
	local quest = entry.task.quest or {}
	local rows = {}
	if not quest.party and not objective.Completed then
		rows[1] = {
			name = routes.UnitFullName("player") or UnitName("player"),
			unit = "player",
			have = objective.Collected,
			need = objective.Needed,
		}
	end
	for _, member in ipairs(members) do
		local remote = MemberObjective(quest, member, objective)
		if remote and not remote.finished then
			rows[#rows + 1] =
				{ name = member.shortName, unit = member.name, have = remote.fulfilled, need = remote.required }
		end
	end
	return rows
end

--[[
	Calls back with each line describing the stop's quests: kind ("title", "objective", "name" or "more"),
	text, r, g, b, then the count on the right, if any, and on a quest's title its quest ID, which the
	Quest Arrow's item buttons go by (Routes-Arrow-Items.lua). Under each quest, only what's to do at the stop: its
	objectives there still to do (routes.IsTaskLeft, so a done one the party needs too), each with its count, "4 / 12", as the quest log writes it. In a party,
	with Show Party Objectives on (routes.ShowsParty), who still needs each objective is listed under it with their own count, the player first, the rest by
	name, each in their class color; the objective has no count of its own then. Where it's only turned in
	there, the quest is one line, "Turn in [2] Wayward Weapons". At most maxQuests quests, then a count of
	the rest. A corpse is one line too, "Run Back to Your Corpse", in the same gold as a turn-in
]]
function routes.ForEachStopLine(stop, maxQuests, callback)
	if stop.corpse then
		callback("title", L["ROUTES_CORPSE"], ns.GetColorRGB("TITLE"))
		return
	end
	local inParty = routes.ShowsParty()
	local quests = routes.QuestsAt(stop, PositionAt(stop))
	for i, entry in ipairs(quests) do
		if i > maxQuests then
			callback("more", string.format(L["ROUTES_MORE_TASKS"], #quests - maxQuests), ns.GetColorRGB("HELP"))
			return
		end
		-- Its objectives here, nearest first, else in the quest log's order
		local toDo, logOrder = {}, {}
		for index, objective in ipairs(routes.QuestObjectives(entry)) do
			if entry.left[objective] then
				toDo[#toDo + 1] = objective
				logOrder[objective] = index
			end
		end
		table.sort(toDo, function(a, b)
			local yardsA, yardsB = entry.distance[a] or math.huge, entry.distance[b] or math.huge
			if yardsA ~= yardsB then
				return yardsA < yardsB
			end
			return logOrder[a] < logOrder[b]
		end)
		--[[
			A flight path to discover is one line, "Get the Flight Path from Devrak", in the turn-in's gold. A
			quest to pick up is one line too, "Pick up [12] Quest Name", in its difficulty color, so how worth the
			walk it is shows at a glance. The turn-in comes after the quest's objectives, so once none are left
			here it's the one line, in the turn-in's gold (routes.TaskColor) rather than the quest's difficulty
			color. Otherwise the quest's objectives, each under its title
		]]
		if entry.flightPath then
			local text = string.format(L["ROUTES_FLIGHT_PATH_FROM"], entry.task.flightMaster or "")
			callback("title", text, ns.GetColorRGB("TITLE"))
		elseif entry.pickUp then
			local title, red, green, blue = routes.QuestTitle(entry.task)
			callback("title", string.format(L["ROUTES_PICK_UP_QUEST"], title), red, green, blue)
		elseif entry.turnIn and #toDo == 0 then
			local text = string.format(L["ROUTES_TURN_IN_QUEST"], routes.QuestTitle(entry.task))
			local red, green, blue = ns.GetColorRGB("TITLE")
			callback("title", text, red, green, blue, nil, entry.task.questID)
		else
			local text, red, green, blue = routes.ObjectivesTitle(entry.task)
			-- No quest ID for one not taken yet: it has no item to use until it's in the log
			callback("title", text, red, green, blue, nil, not entry.task.predicted and entry.task.questID or nil)
			local members = inParty and #toDo > 0 and routes.MemberProgress(entry.task.questID)
			for _, objective in ipairs(toDo) do
				local rows = members and StillNeeded(entry, objective, members) or {}
				local count = #rows == 0
					and objective.Needed
					and routes.CountText(objective.Collected, objective.Needed)
				red, green, blue = ns.GetColorRGB("TEXT")
				callback("objective", objective.Description or "", red, green, blue, count or nil)
				for _, row in ipairs(rows) do
					red, green, blue = routes.ClassColor(row.unit)
					callback("name", row.name, red, green, blue, row.need and routes.CountText(row.have, row.need))
				end
			end
		end
	end
end
