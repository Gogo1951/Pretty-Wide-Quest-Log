local _, ns = ...

--[[
	Routes: the ordered nodes as stops, close ones on the finished route becoming one stop, and what
	each task at a stop asks for
]]

local routes = ns.routes
local L = ns.L

local MIN_STOP_RADIUS, NAME_LIMIT = routes.MIN_STOP_RADIUS, routes.NAME_LIMIT -- Routes-Blobs.lua

local MERGE_RADIUS = 100 -- Yards apart two stops in a row can be and still become one
local SAME_PLACE = 1 -- Yards apart two turn-ins can be and still be at the same NPC
local CORPSE_RADIUS = 30 -- Yards from the corpse that count as being there, inside the client's reach to resurrect

--------------------------------------------------------------------------------
-- Stops
--------------------------------------------------------------------------------

--[[
	A stop is an area where one of its blobs is spawns spread out, as a camp of mobs is: the arrow turns
	into an eye there. Anywhere else it's a point, one NPC or object, or a few in one spot, and the arrow
	points all the way to it
]]
local function IsArea(point)
	return (point.count or 1) > 1 and point.radius > MIN_STOP_RADIUS
end
routes.IsArea = IsArea

-- A turn-in, a quest to pick up or a flight path: at one NPC or object, which only others at the same one join
local function AtQuestGiver(node)
	return node.kind == "turnIn" or node.kind == "pickUp" or node.kind == "flightPath"
end

--[[
	Whether a task joins the stop before it: objectives within MERGE_RADIUS, as one trip, and every
	objective whose area the player is standing in, however far apart the areas' middles, as the player
	works them all at once; a turn-in only with turn-ins at the same NPC, so the route hands in one quest
	giver's quests at a time
]]
local function JoinsStop(stop, node, point)
	if not stop or stop.corpse then
		return false
	end
	local dx, dy = point.x - stop.x, point.y - stop.y
	local distanceSquared = dx * dx + dy * dy
	if AtQuestGiver(node) or stop.turnIns then
		return AtQuestGiver(node) and stop.turnIns and distanceSquared <= SAME_PLACE * SAME_PLACE
	end
	return (node.inArea and stop.inArea) or distanceSquared <= MERGE_RADIUS * MERGE_RADIUS
end

--[[
	The ordered nodes as stops on start's continent. A node joins the stop before it as JoinsStop allows:
	an objective within MERGE_RADIUS, or one whose area the player stands in too, so several quests'
	objectives in one camp make one stop; a turn-in only with turn-ins within SAME_PLACE, at the same NPC.
	A ghost's route starts at their corpse, a stop of its own
]]
function routes.MakeStops(order, start)
	local stops = {}
	local instance, zone = start.instance, start.zone
	if start.corpse then
		stops[1] = {
			x = start.x,
			y = start.y,
			instance = instance,
			radius = CORPSE_RADIUS,
			mapID = zone,
			corpse = true,
			tasks = { { key = "corpse", kind = "corpse" } },
		}
	end
	for _, node in ipairs(order) do
		local point = node.candidates[node.choice]
		local stop = stops[#stops]
		if JoinsStop(stop, node, point) then
			stop.tasks[#stop.tasks + 1] = node
			stop.radius = math.max(stop.radius, point.radius)
			stop.area = stop.area or IsArea(point)
			for _, name in ipairs(point.names or {}) do
				if #stop.names < NAME_LIMIT and not tContains(stop.names, name) then
					stop.names[#stop.names + 1] = name
				end
			end
		else
			stops[#stops + 1] = {
				x = point.x,
				y = point.y,
				instance = instance,
				radius = point.radius,
				names = { unpack(point.names or {}) }, -- Its own list: names from stops merged in join it
				mapID = zone,
				area = IsArea(point),
				turnIns = AtQuestGiver(node) or nil, -- Turn-ins and pick-ups at one NPC, which nothing else joins
				inArea = node.inArea, -- The areas the player stands in, which all join it
				tasks = { node },
			}
		end
	end
	return stops
end

-- An objective as it stands now, its count first as the quest log writes it: "3/8 Boar"
function routes.ObjectiveText(objective)
	local text = objective.Description or ""
	if objective.Needed then
		text = string.format("%s/%s %s", tostring(objective.Collected or 0), tostring(objective.Needed), text)
	end
	return text
end

-- What a task asks for: its objective, the turn-in, the pick-up, the flight path, or the way back to the corpse
function routes.TaskText(task)
	if task.kind == "turnIn" then
		return L["ROUTES_TURN_IN"]
	elseif task.kind == "pickUp" then
		return L["ROUTES_PICK_UP"]
	elseif task.kind == "flightPath" then
		return L["ROUTES_FLIGHT_PATH"]
	elseif task.kind == "corpse" then
		return L["ROUTES_CORPSE"]
	end
	return routes.ObjectiveText(task.objective or {})
end

-- The color Questie gave the task's objective, the turn-in's gold, an escort pick-up's or a flight path's green, or the corpse's white
function routes.TaskColor(task)
	if task.kind == "corpse" then
		return ns.GetColorRGB("TEXT")
	end
	if task.kind == "pickUp" and task.escort then
		return ns.GetColorRGB("ROUTE_ESCORT")
	end
	if task.kind == "flightPath" then
		return ns.GetColorRGB("ROUTE_FLIGHT")
	end
	local color = task.objective and task.objective.Color
	if type(color) == "table" and color[1] then
		return color[1], color[2], color[3]
	end
	return ns.GetColorRGB("TITLE")
end
