local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

--[[
	The Quest Route panel of the Options Interface, which Options.lua registers after Maps & Objectives where
	Routes (Features/Routes) is loaded. The settings are Routes' own, on the profile (routes.Settings). The
	Route Line hides while the switch at the top of it is off; What to Route and Party, what the route
	takes in, show while anything follows the route (the Waypoint Markers or the Quest
	Arrow). The Quest Route is drawn between the markers, so its switch is grayed out while they're off.
	The markers' switch, and their settings map by map, are under Maps & Objectives (Options-Maps.lua)
]]

local function Settings()
	return ns.routes.Settings()
end

local function MarkersHidden()
	return not Settings().showMap
end

-- The route's line shows only with the markers it runs between
local function RouteHidden()
	return MarkersHidden() or not Settings().showLine
end

-- What the route takes in shows for anything that follows it: the markers (and so the route) or the Quest Arrow
local function TakenInHidden()
	return not (Settings().showMap or Settings().showArrow)
end

-- Group Up needs Party Objectives (Routes-Group-Up.lua), so it's their sub-option, hidden with them off
local function GroupUpHidden()
	return TakenInHidden() or not Settings().partyQuests
end

-- A full-width switch for a setting, hidden with its feature
local function Toggle(key, nameKey, order, hidden)
	return ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION", order, nil, hidden)
end

local function Choices(names)
	local values = {}
	for value, nameKey in pairs(names) do
		values[value] = L[nameKey]
	end
	return values
end

--------------------------------------------------------------------------------
-- Quest Route Panel
--------------------------------------------------------------------------------

-- Dots a second the line marches
local LINE_SPEEDS =
	{ [0] = "LINE_SPEED_STILL", [0.75] = "LINE_SPEED_SLOW", [1.5] = "LINE_SPEED_NORMAL", [3] = "LINE_SPEED_FAST" }
local LINE_SPEED_ORDER = { 0, 0.75, 1.5, 3 }

-- The silver line under the grayed-out switch, saying what turns it back on
local function NeedsMarkersText()
	if MarkersHidden() then
		return L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"]
	end
end

--[[
	What to Route: which quests the route guides the player to pick up (Routes-Pick-Ups.lua). Quests in the
	log are always on the route, so every setting here is about pick-ups
]]

--[[
	A dropdown for a setting, its caption beside it and the chosen choice's help (its name key and
	_DESCRIPTION) in silver under it, so each choice says what it does without a tooltip
]]
local function ChoiceRow(key, captionKey, descKey, order, nameKeys, sorting)
	local nameKey = nameKeys[Settings()[key]]
	return ns.OptionsRoutesLabelRow(order, TakenInHidden, L[captionKey], L[descKey], key, {
		type = "select",
		values = function()
			return Choices(nameKeys)
		end,
		sorting = sorting,
	}, nameKey and L[nameKey .. "_DESCRIPTION"] or nil)
end

-- Plan Ahead: how far ahead the route looks for quests to pick up
local PLAN_AHEAD = { yours = "PLAN_AHEAD_YOURS", nearby = "PLAN_AHEAD_NEARBY", zone = "PLAN_AHEAD_ZONE" }
local PLAN_AHEAD_ORDER = { "yours", "nearby", "zone" }

-- Route Focus: how the route chooses and orders what to pick up (Routes-Focus.lua)
local ROUTE_FOCUS = { fastest = "ROUTE_FOCUS_FASTEST", easiest = "ROUTE_FOCUS_EASIEST", xp = "ROUTE_FOCUS_XP" }
local ROUTE_FOCUS_ORDER = { "fastest", "easiest", "xp" }

-- The Search Range matters only where the route looks for pick-ups near the player
local function RangeHidden()
	return TakenInHidden() or Settings().planAhead == "yours"
end

-- Highest and Lowest Quest Level: levels above or below the player, not colors, which differ from game to game
-- 0 is Highest Quest Level's Your Level (nothing above the player) and Lowest Quest Level's No Limit (gray quests too)
local HIGHEST_LEVEL_STEPS = { 0, 3, 6, 9 }
local LOWEST_LEVEL_STEPS = { 3, 6, 9, 0 }

--[[
	A row of levels above or below the player (formatKey: "%d Levels Above You" or below), steps of 3, 6 and
	9, and 0 named by zeroKey (Your Level, No Limit)
]]
local function LevelRow(args, key, nameKey, order, formatKey, steps, zeroKey)
	args[key .. "Space"] = Kit.Spacer(order - 0.02, TakenInHidden)
	args[key] = ns.OptionsRoutesLabelRow(order, TakenInHidden, L[nameKey], L[nameKey .. "_DESCRIPTION"], key, {
		type = "select",
		values = function()
			local values = {}
			for _, levels in ipairs(steps) do
				values[levels] = levels == 0 and L[zeroKey] or L[formatKey]:format(levels)
			end
			return values
		end,
		sorting = steps,
	})
end

--[[
	Quest Types to Pick Up Along the Route, as this game tags quests (ns.QUEST_TAG_SUFFIXES): Elite on Era
	and Forever, Group from TBC on, both the tag with ID 1; Dungeon named with Heroic where the game has
	heroic quests (tag 85)
]]
local function EliteNameKey()
	return (ns.QUEST_TAG_SUFFIXES or {})[1] == "GROUP" and "PICK_UP_GROUP" or "PICK_UP_ELITE"
end

local function DungeonNameKey()
	return (ns.QUEST_TAG_SUFFIXES or {})[85] and "PICK_UP_DUNGEON_HEROIC" or "PICK_UP_DUNGEON"
end

local QUEST_TYPES = {
	{ key = "pickUpElite", nameKey = EliteNameKey },
	{ key = "pickUpPvP", nameKey = "PICK_UP_PVP" },
	{ key = "pickUpDungeon", nameKey = DungeonNameKey, descKey = "PICK_UP_INSTANCE_DESCRIPTION" },
	{ key = "pickUpRaid", nameKey = "PICK_UP_RAID", descKey = "PICK_UP_INSTANCE_DESCRIPTION" },
	{ key = "pickUpEscort", nameKey = "LOCAL_ESCORT_QUESTS" },
	{ key = "pickUpOtherZone", nameKey = "LOCAL_OTHER_ZONE_QUESTS" },
}

--[[
	The What to Route sections, under the Quest Route switch, then Party, then the Route Line: the big choices
	first, What to Route's own Plan Ahead and Route Focus dropdowns, then the pick-up filters, Quest Types and
	Quest Difficulty
]]
local function AddWhatToRouteSection(args)
	--[[
		What to Route: Plan Ahead, the same setting as the Quest Arrow menu's What to Route, with its Search
		Range under it, then Route Focus and Flight Paths
	]]
	args.spaceWhat0 = Kit.Spacer(38, TakenInHidden)
	args.headerWhat = Kit.Header(L["WHAT_TO_ROUTE_HEADER"], 38.01, TakenInHidden)
	args.spaceWhat1 = Kit.Spacer(38.02, TakenInHidden)
	args.descWhat = Kit.Desc(L["WHAT_TO_ROUTE_DESCRIPTION"], 38.03, TakenInHidden)
	args.spacePlanAhead = Kit.Spacer(38.04, TakenInHidden)
	args.planAhead =
		ChoiceRow("planAhead", "PLAN_AHEAD_HEADER", "PLAN_AHEAD_DESCRIPTION", 38.05, PLAN_AHEAD, PLAN_AHEAD_ORDER)
	args.localQuestRangeRow = ns.OptionsRoutesSubControlRow(
		38.075,
		RangeHidden,
		L["LOCAL_QUEST_RANGE"],
		L["LOCAL_QUEST_RANGE_DESCRIPTION"],
		"localQuestRange",
		{ type = "range", min = 200, max = 800, step = 50 }
	)
	args.spaceFocus = Kit.Spacer(38.078, TakenInHidden)
	args.routeFocus =
		ChoiceRow("routeFocus", "ROUTE_FOCUS_HEADER", "ROUTE_FOCUS_DESCRIPTION", 38.079, ROUTE_FOCUS, ROUTE_FOCUS_ORDER)
	args.spaceFlightPaths = Kit.Spacer(38.08, TakenInHidden)
	-- The same setting as the Quest Arrow menu's Flight Paths
	args.showFlightPaths = Toggle("showFlightPaths", "SHOW_FLIGHT_PATHS", 38.085, TakenInHidden)

	-- Quest Types to Pick Up Along the Route
	args.spaceTypes0 = Kit.Spacer(38.2, TakenInHidden)
	args.headerTypes = Kit.Header(L["QUEST_TYPES_HEADER"], 38.21, TakenInHidden)
	args.spaceTypes1 = Kit.Spacer(38.22, TakenInHidden)
	args.descTypes = Kit.Desc(L["QUEST_TYPES_DESCRIPTION"], 38.23, TakenInHidden)
	args.spaceTypes2 = Kit.Spacer(38.24, TakenInHidden)
	for index, questType in ipairs(QUEST_TYPES) do
		local nameKey = type(questType.nameKey) == "function" and questType.nameKey() or questType.nameKey
		local toggle = ns.OptionsRoutesToggle(
			questType.key,
			nameKey,
			questType.descKey or (nameKey .. "_DESCRIPTION"),
			38.25 + index / 1000,
			nil,
			TakenInHidden
		)
		args[questType.key] = toggle
	end

	-- Quest Difficulty
	args.spaceLevels0 = Kit.Spacer(38.3, TakenInHidden)
	args.headerLevels = Kit.Header(L["QUEST_DIFFICULTY_HEADER"], 38.31, TakenInHidden)
	args.spaceLevels1 = Kit.Spacer(38.32, TakenInHidden)
	args.descLevels = Kit.Desc(L["QUEST_DIFFICULTY_DESCRIPTION"], 38.33, TakenInHidden)
	LevelRow(
		args,
		"highestQuestLevel",
		"LOCAL_HIGHEST_QUEST_LEVEL",
		38.36,
		"LOCAL_LEVELS_ABOVE",
		HIGHEST_LEVEL_STEPS,
		"LOCAL_LEVELS_YOUR_LEVEL"
	)
	LevelRow(
		args,
		"lowestQuestLevel",
		"LOCAL_QUEST_LEVEL",
		38.39,
		"LOCAL_LEVELS_BELOW",
		LOWEST_LEVEL_STEPS,
		"LOCAL_LEVELS_NO_LIMIT"
	)
end

function ns.BuildQuestRouteOptions()
	local options = {
		type = "group",
		name = L["TAB_QUEST_ROUTE"],
		args = {
			descIntro = Kit.Desc(L["TAB_QUEST_ROUTE_DESCRIPTION"], 1),
			spaceIntro = Kit.Spacer(2),
			enableQuestRoute = ns.FeatureSwitch("routes.showLine", 3),
			needsMarkers = Kit.StatusLine(NeedsMarkersText, 4),
			needsQuestie = ns.RoutesNeedQuestieLine(4.1),

			lineSpeed = ns.OptionsRoutesLabelRow(
				54,
				RouteHidden,
				L["LINE_SPEED"],
				L["LINE_SPEED_DESCRIPTION"],
				"lineSpeed",
				{
					type = "select",
					values = function()
						return Choices(LINE_SPEEDS)
					end,
					sorting = LINE_SPEED_ORDER,
				}
			),
			spaceLineOpacity = Kit.Spacer(55.5, RouteHidden),
			lineOpacity = ns.OptionsRoutesLabelRow(
				56,
				RouteHidden,
				L["LINE_OPACITY"],
				L["LINE_OPACITY_DESCRIPTION"],
				"lineOpacity",
				{ type = "range", min = 0.2, max = 1, step = 0.1, isPercent = true }
			),

			partyQuests = Toggle("partyQuests", "PARTY_QUESTS", 43, TakenInHidden),
			groupUp = Kit.SubToggleRow(
				44,
				GroupUpHidden,
				ns.OptionsRoutesToggle("groupUp", "GROUP_UP", "GROUP_UP_DESCRIPTION")
			),
		},
	}
	local args = options.args
	Kit.Section(args, "Party", 40, L["ROUTES_PARTY_HEADER"], L["ROUTES_PARTY_DESCRIPTION"], TakenInHidden)
	Kit.Section(args, "Line", 50, L["ROUTES_LINE_HEADER"], L["ROUTES_LINE_DESCRIPTION"], RouteHidden)
	AddWhatToRouteSection(args)
	return options
end
