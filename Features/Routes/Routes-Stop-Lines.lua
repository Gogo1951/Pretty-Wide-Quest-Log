local _, ns = ...

--[[
	Routes: what a stop holds, as the Quest Arrow (Routes-Arrow.lua) and the map's tooltip
	(Routes-Map.lua) list it
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

-- Where a task is done: the place the route chose for it
function routes.TaskPoint(task)
	return task.candidates and task.candidates[task.choice or 1]
end

-- Whether a task's place is an area (a camp of mobs, a field of objects) rather than one place
function routes.IsAreaPoint(point)
	return point ~= nil and IsArea(point)
end

-- Whether a task is still to do: an objective not yet done, or a turn-in
function routes.IsTaskLeft(task)
	return not (task.objective and task.objective.Completed)
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

--[[
	The quests at a stop, each { task, here, turnIn, distance }: task the first of its tasks there, here
	the set of its objectives done at the stop, turnIn whether it's turned in there. Given the player's
	position, nearest first, each with distance[objective] for its objectives' places; else in route order
]]
function routes.QuestsAt(stop, x, y)
	local quests, byID = {}, {}
	for index, task in ipairs(stop.tasks) do
		local entry = byID[task.questID]
		if not entry then
			entry = { task = task, here = {}, distance = {}, order = index, nearest = math.huge }
			byID[task.questID] = entry
			quests[#quests + 1] = entry
		end
		if task.kind == "turnIn" then
			entry.turnIn = true
		elseif task.objective then
			entry.here[task.objective] = true
		end
		local yards = routes.IsTaskLeft(task) and routes.TaskDistance(task, x, y)
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

--[[
	Calls back with each line describing the stop's quests: isTitle, text, then r, g, b. Under each quest,
	only what's to do at the stop: its objectives there not yet done. Where it's only turned in there, the
	quest is one line, "Turn in [2] Wayward Weapons". At most maxQuests quests, then a count of the rest.
	A corpse is one line too, "Run back to your corpse"
]]
function routes.ForEachStopLine(stop, maxQuests, callback)
	if stop.corpse then
		callback(true, L["ROUTES_CORPSE"], ns.GetColorRGB("TEXT"))
		return
	end
	local quests = routes.QuestsAt(stop, PositionAt(stop))
	for i, entry in ipairs(quests) do
		if i > maxQuests then
			callback(false, string.format(L["ROUTES_MORE_TASKS"], #quests - maxQuests), ns.GetColorRGB("HELP"))
			return
		end
		-- Its objectives here, nearest first, else in the quest log's order
		local toDo, logOrder = {}, {}
		for index, objective in ipairs(routes.QuestObjectives(entry)) do
			if entry.here[objective] and not objective.Completed then
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
			The turn-in comes after the quest's objectives, so once none are left here it's the one line, in
			the turn-in's gold (routes.TaskColor) rather than the quest's difficulty color
		]]
		if entry.turnIn and #toDo == 0 then
			local title = routes.QuestTitle(entry.task)
			callback(true, string.format(L["ROUTES_TURN_IN_QUEST"], title), ns.GetColorRGB("TITLE"))
		else
			callback(true, routes.QuestTitle(entry.task))
			for _, objective in ipairs(toDo) do
				callback(false, routes.ObjectiveText(objective), ns.GetColorRGB("TEXT"))
			end
		end
	end
end

--------------------------------------------------------------------------------
-- The map's tooltip
--------------------------------------------------------------------------------

--[[
	A stop's quests on the map's tooltip, as the other add-ons lay out a tooltip's rows: a space in from the
	title, the name on the left and its count ("4 / 12") on the right. Each objective leads with the quest
	log's check once it's done (or a blank the same size, so the names line up), in line with the name of
	the player it's under. In a party each quest is split by who has it: the player first, where they have
	it, then each member Questie shares a quest log for, with their own progress. Alone, the player's name
	is left off and the checks sit where it would
]]
local ROW_INDENT = " "

-- A name in its class color, where the client says the class
local function PlayerName(unit, name)
	local ok, _, class = pcall(UnitClass, unit)
	local color = ok
		and ns.IsReadable(class)
		and type(class) == "string"
		and RAID_CLASS_COLORS
		and RAID_CLASS_COLORS[class]
	return color and color:WrapTextInColorCode(name) or name
end

-- One objective line: its check, name, and "4 / 12" on the right, where it has a count
local function AddObjective(tooltip, objective, have, need, done)
	local left = ROW_INDENT .. ns.CheckIcon(GameTooltipText, done) .. " " .. (objective.Description or "")
	local red, green, blue = ns.GetColorRGB(done and "HELP" or "TEXT")
	if need then
		local count = string.format("%s / %s", tostring(have or 0), tostring(need))
		tooltip:AddDoubleLine(left, count, red, green, blue, red, green, blue)
	else
		tooltip:AddLine(left, red, green, blue)
	end
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
	local inParty = routes.IsInParty()
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
		shown = AddPlayer(tooltip, PlayerName("player", UnitName("player")), rows, inParty, shown)
	end
	for _, member in ipairs(inParty and routes.MemberProgress(entry.task.questID) or {}) do
		local rows = {}
		for _, objective in ipairs(objectives) do
			local remote = MemberObjective(quest, member, objective)
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
	one line, "Turn in [2] Wayward Weapons". A corpse is one line too, "Run back to your corpse"
]]
function routes.AddStopTooltip(tooltip, stop)
	if stop.corpse then
		tooltip:AddLine(L["ROUTES_CORPSE"], ns.GetColorRGB("TEXT"))
		return
	end
	for _, entry in ipairs(routes.QuestsAt(stop, PositionAt(stop))) do
		if tooltip:NumLines() > 0 then
			tooltip:AddLine(" ")
		end
		local objectives, anyLeft = {}, false
		for _, objective in ipairs(routes.QuestObjectives(entry)) do
			if entry.here[objective] then
				objectives[#objectives + 1] = objective
				anyLeft = anyLeft or not objective.Completed
			end
		end
		if entry.turnIn and not anyLeft then
			local title = routes.QuestTitle(entry.task)
			tooltip:AddLine(string.format(L["ROUTES_TURN_IN_QUEST"], title), ns.GetColorRGB("TITLE"))
		else
			tooltip:AddLine(routes.QuestTitle(entry.task))
			AddProgress(tooltip, entry, objectives)
		end
	end
end
