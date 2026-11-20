local _, ns = ...

--[[
	Routes: each zone's disc on a continent's or the world's map (Routes-Map.lua), in place of a marker for
	every quest, which pile up there past reading. One disc in the middle of each zone with quests to pick
	up, in the level color most of them have, as WoW colors a quest by its level against the player's: red
	5 or more above, orange 3 or 4 above, yellow 2 below to 2 above, green below that down to Questie's
	green range, gray past it. A tie goes to the color nearest the player's level (TIE_ORDER). A zone with
	nothing to pick up has no disc. Hovering it lists how many of each color, then the player's objectives
	there; clicking it opens the zone's map. Turn-ins have their own markers, and objectives are the zone
	map's alone.

	The quests to pick up are the ones a zone's map draws a marker for (routes.ZonePickUps): every one Questie
	shows as available (its AvailableQuests module, so its own level, repeatable, dungeon and hidden filters
	hold) but one below Lowest Quest Level, and none with What to Route on Your Quests Only. A group,
	dungeon or raid quest has its marker but isn't counted in a level color: the menu counts those on a row
	of their own, in the dungeon marker's ring blue, and leaves the disc's color to the rest. A zone with
	only those has a blue disc. A quest or objective is in the zone where the
	continent's map has its giver's or its mobs' place, as a zone's map decides which markers are its own
	(ZoneAt), a city counting as its zone: so a disc never counts a quest its zone's map has no marker for
]]

local routes = ns.routes
local L = ns.L

local ROW_INDENT = " " -- A row a space in from its heading, as a stop's menu has them
local OBJECTIVE_LIMIT = 5 -- Objectives listed before the rest are counted, in gray, as "And 3 more..."

--[[
	The level colors, as the menu lists them, each with its label and the client's quest difficulty color
	(QuestDifficultyColors) the disc and row take
]]
local COLORS = {
	{ key = "red", label = "ROUTES_ZONE_AVAILABLE_RED", difficulty = "impossible" },
	{ key = "orange", label = "ROUTES_ZONE_AVAILABLE_ORANGE", difficulty = "verydifficult" },
	{ key = "yellow", label = "ROUTES_ZONE_AVAILABLE_YELLOW", difficulty = "difficult" },
	{ key = "green", label = "ROUTES_ZONE_AVAILABLE_GREEN", difficulty = "standard" },
	{ key = "gray", label = "ROUTES_ZONE_AVAILABLE_GRAY", difficulty = "trivial" },
}
local TIE_ORDER = { "yellow", "green", "orange", "red", "gray" }

-- Levels above the player's a quest is red or orange from, and below it is still yellow
local RED_FROM, ORANGE_FROM, YELLOW_BELOW = 5, 3, 2

-- Quest tags (routes.QuestTagKind) that make a quest a group's, a dungeon's or a raid's, never counted
local GROUP_TAGS = { ELITE = true, GROUP = true, DUNGEON = true, RAID = true }

--[[
	The quests the last continent's or world's map drew discs for, or a zone's map the route isn't planned in
	drew markers for, quest ID to true: Questie's ! icons for them are hidden there
	(Routes-Map-Questie-Icons.lua). Set as they're drawn, cleared with them
]]
routes.zoneDiscQuests = {}

--[[
	The color of a disc whose zone has only group, dungeon and raid quests to pick up: the dungeon marker's
	ring blue, as the menu's row for them is
]]
local GROUP_COLOR = "group"

-- A level color's red, green and blue, from the client's quest difficulty colors; the group color's blue
function routes.ZoneColorRGB(key)
	if key == GROUP_COLOR then
		return ns.GetColorRGB("ROUTE_DUNGEON_RING")
	end
	for _, color in ipairs(COLORS) do
		if color.key == key then
			local difficulty = QuestDifficultyColors and QuestDifficultyColors[color.difficulty]
			if difficulty then
				return difficulty.r, difficulty.g, difficulty.b
			end
		end
	end
	return ns.GetColorRGB("TITLE")
end

--------------------------------------------------------------------------------
-- Which zones a quest is in
--------------------------------------------------------------------------------

--[[
	A quest's givers as blobs across every continent, by world instance, worked out once by quest ID: spawns
	don't move
]]
local starterBlobs = {}

local function NoYield() end

local function StarterWorldBlobs(QuestieDB, questID)
	local cached = starterBlobs[questID]
	if not cached then
		local byInstance = {}
		routes.pickUpHelpers.ForEachStarter(QuestieDB, questID, function(spawns, name)
			routes.AddWorldSpawns(byInstance, spawns, name, NoYield)
		end)
		cached = {}
		for instance, points in pairs(byInstance) do
			cached[instance] = routes.Cluster(points, NoYield)
		end
		starterBlobs[questID] = cached
	end
	return cached
end

--[[
	The zone a point in world yards stands in, as a zone's map decides which markers are its own
	(IsInMapZone, Routes-Map.lua): the zone under it on its continent's map, a city counting as the zone it's
	in (routes.ZoneOf). Nothing out at sea, or on no continent the client knows
]]
local function ZoneAt(x, y, instance)
	local data = ns.zoneInfoData
	if not (data and x) then
		return nil
	end
	for _, continent in ipairs(data.Continents()) do
		local position = routes.MapPosition(continent.mapID, x, y, instance)
		if routes.IsOnMap(position) then
			local info = C_Map.GetMapInfoAtPosition(continent.mapID, position.x, position.y)
			local zone = info and info.mapID ~= continent.mapID and data.ZoneOf(info.mapID)
			return zone and routes.ZoneOf(zone) or nil
		end
	end
	return nil
end

--[[
	The zones a quest's givers stand in (ZoneAt, each blob's middle, as its marker is placed), each once,
	worked out once by quest ID: spawns don't move. Nothing kept till HereBeDragons is there to place them
]]
local questZones = {}

local function QuestZones(QuestieDB, questID)
	local cached = questZones[questID]
	if cached then
		return cached
	end
	cached = {}
	if not routes.HereBeDragons() then
		return cached
	end
	local seen = {}
	for instance, blobs in pairs(StarterWorldBlobs(QuestieDB, questID)) do
		for _, blob in ipairs(blobs) do
			local zone = ZoneAt(blob.x, blob.y, instance)
			if zone and not seen[zone] then
				seen[zone] = true
				cached[#cached + 1] = zone
			end
		end
	end
	questZones[questID] = cached
	return cached
end

routes.ZoneAt = ZoneAt -- For the zone a right-click on another zone's marker is for (Routes-Map.lua)

--[[
	Whether a quest has a giver in the route's zone, a city in it or a zone linked to it (QuestZones,
	routes.IsChangeHere): tracking it with Zone Info's + plans the route only then, and the route's signature
	counts it only then (Zone-Info-Data.lua, Routes-Pick-Ups.lua). Yes while its givers can't be placed yet
]]
function routes.HasGiverHere(questID)
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not (QuestieDB and routes.HereBeDragons()) then
		return true
	end
	for _, zone in ipairs(QuestZones(QuestieDB, questID)) do
		if routes.IsChangeHere(zone) then
			return true
		end
	end
	return false
end

-- The zone a camp stands in (ZoneAt), kept on the camp: camps are made anew with each plan
local function CampZone(camp)
	if camp.discZone == nil then
		camp.discZone = ZoneAt(camp.x, camp.y, camp.instance) or false
	end
	return camp.discZone or nil
end

-- Whether a map is the one given or lies inside it, its parents followed up
local function IsUnder(zoneID, mapID)
	local seen = {}
	while zoneID and zoneID > 0 and not seen[zoneID] do
		if zoneID == mapID then
			return true
		end
		seen[zoneID] = true
		local info = C_Map.GetMapInfo(zoneID)
		zoneID = info and info.parentMapID
	end
	return false
end

--[[
	The middle of a zone on the map shown, from the rectangle it fills there; nothing for a zone on another
	continent, or off the map
]]
local function ZoneCenter(zoneID, mapID)
	if not IsUnder(zoneID, mapID) then
		return nil
	end
	local minX, maxX, minY, maxY = C_Map.GetMapRectOnMap(zoneID, mapID)
	if not (minX and maxX and minY and maxY and maxX > minX and maxY > minY) then
		return nil
	end
	local center = { x = (minX + maxX) / 2, y = (minY + maxY) / 2 }
	return routes.IsOnMap(center) and center or nil
end

-- The continent a map is on, its parents followed up, or nothing above the continents
function routes.ContinentOf(mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	while info do
		if info.mapType == Enum.UIMapType.Continent then
			return mapID
		end
		if info.mapType < Enum.UIMapType.Continent or not (info.parentMapID and info.parentMapID > 0) then
			return nil
		end
		mapID = info.parentMapID
		info = C_Map.GetMapInfo(mapID)
	end
end

--------------------------------------------------------------------------------
-- Each zone's quests
--------------------------------------------------------------------------------

-- A quest's level color: gray past Questie's green range, else by how far its level is from the player's
local function ColorOf(QuestieDB, questID)
	local helpers = routes.pickUpHelpers
	if helpers.IsGray(QuestieDB, questID) then
		return "gray"
	end
	local info = helpers.QuestInfo(QuestieDB, questID)
	local above = (tonumber(info.level) or UnitLevel("player")) - UnitLevel("player")
	if above >= RED_FROM then
		return "red"
	elseif above >= ORANGE_FROM then
		return "orange"
	elseif above >= -YELLOW_BELOW then
		return "yellow"
	end
	return "green"
end

--[[
	A quest's level color (ColorOf), for its pick-up marker's disc on a zone's map and the minimap
	(routes.TaskColor), the same a zone's disc counts it in. Nothing without Questie's database
]]
function routes.QuestColorKey(questID)
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if not (QuestieDB and routes.pickUpHelpers and questID) then
		return nil
	end
	return ColorOf(QuestieDB, questID)
end

-- The color most of a zone's quests have, a tie going to the one nearest the player's level
local function MostCommon(counts)
	local best
	for _, key in ipairs(TIE_ORDER) do
		if counts[key] > 0 and (not best or counts[key] > counts[best]) then
			best = key
		end
	end
	return best
end

--[[
	Each zone on a continent's or the world's map with any quest to pick up: { zoneID, name, position, color,
	counts, groupCount, objectives }, at the zone's middle. counts by level color (COLORS); groupCount the
	group, dungeon and raid quests, counted apart (GROUP_TAGS); color the most common, or GROUP_COLOR;
	objectives the player's objectives still to do there, from camps (Routes-Camps.lua)
]]
function routes.ZoneGroups(mapID, camps)
	local byZone, groups = {}, {}
	local discQuests = {}
	routes.zoneDiscQuests = discQuests -- The quests a disc counts, whose Questie ! icons hide on these maps
	local function Group(zoneID)
		local group = byZone[zoneID]
		if group == nil then
			local position = ZoneCenter(zoneID, mapID)
			if position then
				local info = C_Map.GetMapInfo(zoneID)
				group = {
					zoneID = zoneID,
					name = info and info.name or "",
					position = position,
					counts = {},
					groupCount = 0,
				}
				group.objectives, group.seen = {}, {}
				for _, color in ipairs(COLORS) do
					group.counts[color.key] = 0
				end
				groups[#groups + 1] = group
			end
			byZone[zoneID] = group or false
		end
		return group or nil
	end

	local helpers = routes.pickUpHelpers
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local available = helpers and helpers.AvailableQuestIDs()
	if available and QuestieDB then
		local log, settings, plans = routes.QuestLog(), routes.Settings(), routes.PlansPickUps()
		for questID, shown in pairs(available) do
			if shown and not helpers.IsTakenOrDone(questID, log) then
				local zones = QuestZones(QuestieDB, questID)
				-- As a zone's map draws them (routes.ZonePickUps), less the group, dungeon and raid quests
				if
					plans
					and helpers.IsOutsideLevels(QuestieDB, questID, settings) ~= "low"
					and not GROUP_TAGS[routes.QuestTagKind(questID) or ""]
				then
					local color = ColorOf(QuestieDB, questID)
					for _, zone in ipairs(zones) do
						local group = Group(zone)
						if group then
							group.counts[color] = group.counts[color] + 1
							discQuests[questID] = true
						end
					end
				elseif plans and helpers.IsOutsideLevels(QuestieDB, questID, settings) ~= "low" then
					-- A group, dungeon or raid quest: its own blue row in the menu, the disc's color left alone
					for _, zone in ipairs(zones) do
						local group = Group(zone)
						if group then
							group.groupCount = group.groupCount + 1
						end
					end
				end
			end
		end
	end

	-- A zone with nothing to pick up has no disc, so only those already found list objectives
	for _, group in ipairs(groups) do
		-- One with only group, dungeon and raid quests is blue
		group.color = MostCommon(group.counts) or (group.groupCount > 0 and GROUP_COLOR) or nil
	end
	for _, camp in ipairs(camps) do
		local task = camp.tasks[1]
		local objective = task and task.objective
		if objective and not task.party and not task.predicted and routes.IsTaskLeft(task) then
			local group = byZone[CampZone(camp) or 0]
			if group and not group.seen[objective] then
				group.seen[objective] = true
				table.insert(group.objectives, task)
			end
		end
	end

	local withDisc = {}
	for _, group in ipairs(groups) do
		if group.color then
			group.seen = nil
			withDisc[#withDisc + 1] = group
		end
	end
	return withDisc
end

--------------------------------------------------------------------------------
-- Pick-ups on a zone's map
--------------------------------------------------------------------------------

--[[
	The quests to pick up on a zone's map the route has no marker for, as camps (Routes-Camps.lua). On a
	zone's map the route isn't planned in, each
	gets its marker, hover and right-click as a map-only pick-up in the route's zone does: every quest
	Questie shows as available with a giver in the zone (QuestZones), a city in it or a zone linked to it
	(routes.IsInZone, so Thunder Bluff's on Mulgore's map), but one below Lowest Quest Level, as the route's
	zone leaves those off too. Each is off the route ("zone", the gray ring) till a right-click puts it on
	(routes.AddPickUp, kept to that zone by homeZone), then on it once the player gets there, its ring black
	and a right-click taking it back off. have: task keys the map already has a marker for, left out.
	Questie's ! icons for them are hidden (routes.zoneDiscQuests). Nothing with What to Route on Your Quests
	Only, which leaves every pick-up off the map.

	On the route's zone's map (routeZone), the ones left are those the route can't plan, Questie filing
	their giver under another zone though it stands in this one (Routes-Blobs.lua's AddSpawns): each gets
	its marker and hover, gray-ringed, but no right-click (unplanned), as the route couldn't take it there
]]
function routes.ZonePickUps(mapID, have, routeZone)
	local camps, quests = {}, {}
	routes.zoneDiscQuests = quests
	local helpers = routes.pickUpHelpers
	local zone = routes.ZoneOf(mapID) -- A city's map counts as its zone's, as the route does
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local available = helpers and helpers.AvailableQuestIDs()
	if not (zone and QuestieDB and available and routes.PlansPickUps()) then
		return camps
	end
	local log, settings = routes.QuestLog(), routes.Settings()
	for questID, shown in pairs(available) do
		local key = questID .. ":pickUp"
		if shown and not have[key] and not helpers.IsTakenOrDone(questID, log) then
			local inZone = false
			for _, starterZone in ipairs(QuestZones(QuestieDB, questID)) do
				inZone = inZone or routes.IsInZone(starterZone, zone)
			end
			if inZone and helpers.IsOutsideLevels(QuestieDB, questID, settings) ~= "low" then
				local info, name = helpers.QuestInfo(QuestieDB, questID)
				local task = {
					key = key,
					kind = "pickUp",
					questID = questID,
					questName = name,
					quest = info,
					ready = true,
					escort = routes.IsEscort(questID) or nil,
				}
				if routeZone then
					task.offRoute, task.unplanned = "unplanned", true -- No reason line (Routes-Map-Tooltip.lua)
				else
					task.offRoute = not routes.added[key] and "zone" or nil
					task.homeZone, task.elsewhere = zone, true
				end
				for instance, blobs in pairs(StarterWorldBlobs(QuestieDB, questID)) do
					for _, blob in ipairs(blobs) do
						camps[#camps + 1] = {
							x = blob.x,
							y = blob.y,
							instance = instance,
							radius = blob.radius,
							count = blob.count,
							names = blob.names,
							area = routes.IsArea(blob),
							camp = true,
							tasks = { task }, -- The one task, not a copy, so a right-click's change shows on every camp
						}
					end
				end
				quests[questID] = true
			end
		end
	end
	return camps
end

--------------------------------------------------------------------------------
-- A zone's menu
--------------------------------------------------------------------------------

-- Lowest quest level first, then A to Z
local function ByLevel(a, b)
	local levelA, levelB = tonumber(a.quest and a.quest.level) or 0, tonumber(b.quest and b.quest.level) or 0
	if levelA ~= levelB then
		return levelA < levelB
	end
	return routes.ObjectiveName(a.objective) < routes.ObjectiveName(b.objective)
end

--[[
	A zone's menu: its name with PWQL on the right, then a spacer; how many quests of each level color there are to pick up,
	each in its color, then the group, dungeon and raid quests in blue; the objectives still to do there, the first OBJECTIVE_LIMIT by quest level with their
	counts on the right and the rest counted; then Open Zone Map as a row, done with a click on the disc too.
	openZone opens the zone's map
]]
function routes.ZoneMenuEntries(group, openZone)
	local rows = routes.MapMenuRows()
	rows:Add({ kind = "header", left = group.name, right = L["ADDON_SHORT_NAME"], rightColor = "MUTED" })
	rows:Add({ kind = "spacer" })
	local textRed, textGreen, textBlue = ns.GetColorRGB("TEXT")
	for _, color in ipairs(COLORS) do
		local red, green, blue = routes.ZoneColorRGB(color.key)
		local count = tostring(group.counts[color.key])
		rows:AddDoubleLine(ROW_INDENT .. L[color.label], count, red, green, blue, textRed, textGreen, textBlue)
	end
	-- The group, dungeon and raid quests, in the dungeon marker's ring blue, as Questie's ! for them is hidden
	local groupRed, groupGreen, groupBlue = ns.GetColorRGB("ROUTE_DUNGEON_RING")
	rows:AddDoubleLine(
		ROW_INDENT .. L["ROUTES_ZONE_AVAILABLE_GROUP"],
		tostring(group.groupCount or 0),
		groupRed,
		groupGreen,
		groupBlue,
		textRed,
		textGreen,
		textBlue
	)
	local objectives = group.objectives
	if #objectives > 0 then
		rows:AddSection(L["ROUTES_ZONE_OBJECTIVES"])
		table.sort(objectives, ByLevel)
		for index = 1, math.min(#objectives, OBJECTIVE_LIMIT) do
			local objective = objectives[index].objective
			local name = ROW_INDENT .. routes.ObjectiveName(objective)
			if objective.Needed then
				local count = routes.CountText(objective.Collected, objective.Needed)
				rows:AddDoubleLine(name, count, textRed, textGreen, textBlue, textRed, textGreen, textBlue)
			else
				rows:AddLine(name, textRed, textGreen, textBlue)
			end
		end
		if #objectives > OBJECTIVE_LIMIT then
			local more = L["ROUTES_ZONE_MORE"]:format(#objectives - OBJECTIVE_LIMIT)
			rows:AddLine(ROW_INDENT .. more, ns.GetColorRGB("MUTED"))
		end
	end
	rows:AddHints({ { L["ROUTES_CLICK"], L["ROUTES_CLICK_OPEN_ZONE_MAP"], openZone } })
	return rows.entries
end
