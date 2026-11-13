local _, ns = ...
local L = ns.L

--[[
	The Quest Route panel of the Options Interface, which Options.lua registers after Maps & Objectives where
	Routes (Features/Routes) is loaded. The settings are Routes' own, on the profile (routes.Settings). The
	Route Line hides while the switch at the top of it is off; Planning, Local Available Quests and Party,
	what the route takes in, show while anything follows the route (the Waypoint Markers or the Quest
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

local function LocalHidden()
	return TakenInHidden() or not Settings().showLocalQuests
end

-- Join Up with Group needs Party Objectives (Routes-Group-Up.lua), so it's grayed out with them off
local function GroupUpOff()
	return not Settings().partyQuests
end

-- A full-width switch for a setting, hidden with its feature
local function Toggle(key, nameKey, order, hidden, disabled)
	return ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION", order, nil, hidden, disabled)
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

-- How near a quest giver must be, the Search Range, in the Quest Arrow's own words for a distance (Routes-Pick-Ups.lua)
local function LocalQuestsToggle()
	local toggle = Toggle("showLocalQuests", "SHOW_LOCAL_QUESTS", 39.5, TakenInHidden)
	toggle.desc = function()
		local range = ns.routes and ns.routes.LocalQuestRange() or 400
		return L["SHOW_LOCAL_QUESTS_DESCRIPTION"]:format(L["ROUTES_YARDS"]:format(range))
	end
	return toggle
end

-- What a Local Available Quests choice does with a kind of quest (Routes-Pick-Ups.lua)
local LOCAL_CHOICES = { route = "LOCAL_CHOICE_ROUTE", map = "LOCAL_CHOICE_MAP", off = "LOCAL_CHOICE_OFF" }
local LOCAL_CHOICE_ORDER = { "route", "map", "off" }
local LOCAL_LEVELS = { questie = "LOCAL_LEVEL_QUESTIE", green = "LOCAL_LEVEL_GREEN", yellow = "LOCAL_LEVEL_YELLOW" }
local LOCAL_LEVEL_ORDER = { "questie", "green", "yellow" }

-- A row of the Local Available Quests section, a sub-option of its switch: a dropdown of choices
local function LocalRow(args, key, nameKey, order, names, sorting)
	args[key .. "Space"] = ns.OptionsSpacer(order - 0.02, LocalHidden)
	args[key .. "Row"] =
		ns.OptionsRoutesSubControlRow(order, LocalHidden, L[nameKey], L[nameKey .. "_DESCRIPTION"], key, {
			type = "select",
			values = function()
				return Choices(names)
			end,
			sorting = sorting,
		})
end

-- The Local Available Quests section, between Planning and Party: which nearby quests count
local function AddLocalQuestsSection(args)
	args.spaceLocal0 = ns.OptionsSpacer(39, TakenInHidden)
	args.headerLocal = ns.OptionsHeader(L["LOCAL_QUESTS_HEADER"], 39.1, TakenInHidden)
	args.spaceLocal1 = ns.OptionsSpacer(39.2, TakenInHidden)
	args.descLocal = ns.OptionsDesc(L["LOCAL_QUESTS_DESCRIPTION"], 39.3, TakenInHidden)
	args.spaceLocal2 = ns.OptionsSpacer(39.4, TakenInHidden)
	-- The same setting as the Quest Arrow menu's Local Available Quests
	args.showLocalQuests = LocalQuestsToggle()
	args.spaceLocalRange = ns.OptionsSpacer(39.55, LocalHidden)
	args.localQuestRangeRow = ns.OptionsRoutesSubControlRow(
		39.6,
		LocalHidden,
		L["LOCAL_QUEST_RANGE"],
		L["LOCAL_QUEST_RANGE_DESCRIPTION"],
		"localQuestRange",
		{ type = "range", min = 200, max = 800, step = 50 }
	)
	LocalRow(args, "localEscortQuests", "LOCAL_ESCORT_QUESTS", 39.7, LOCAL_CHOICES, LOCAL_CHOICE_ORDER)
	LocalRow(args, "localGroupQuests", "LOCAL_GROUP_QUESTS", 39.75, LOCAL_CHOICES, LOCAL_CHOICE_ORDER)
	LocalRow(args, "localOtherZoneQuests", "LOCAL_OTHER_ZONE_QUESTS", 39.8, LOCAL_CHOICES, LOCAL_CHOICE_ORDER)
	LocalRow(args, "localQuestLevel", "LOCAL_QUEST_LEVEL", 39.85, LOCAL_LEVELS, LOCAL_LEVEL_ORDER)
end

function ns.BuildQuestRouteOptions()
	local options = {
		type = "group",
		name = L["TAB_QUEST_ROUTE"],
		args = {
			descIntro = ns.OptionsDesc(L["TAB_QUEST_ROUTE_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			enableQuestRoute = ns.OptionsQuestRouteToggle(3),
			needsMarkers = ns.OptionsStatusLine(NeedsMarkersText, 4),

			spaceLine0 = ns.OptionsSpacer(30, RouteHidden),
			headerLine = ns.OptionsHeader(L["ROUTES_LINE_HEADER"], 31, RouteHidden),
			spaceLine1 = ns.OptionsSpacer(32, RouteHidden),
			descLine = ns.OptionsDesc(L["ROUTES_LINE_DESCRIPTION"], 32.1, RouteHidden),
			spaceLine2 = ns.OptionsSpacer(32.2, RouteHidden),
			lineSpeedLabel = ns.OptionsRowLabel(L["LINE_SPEED"], 34, nil, RouteHidden, L["LINE_SPEED_DESCRIPTION"]),
			lineSpeed = ns.OptionsRoutesControl("lineSpeed", {
				type = "select",
				desc = L["LINE_SPEED_DESCRIPTION"],
				values = function()
					return Choices(LINE_SPEEDS)
				end,
				sorting = LINE_SPEED_ORDER,
			}, 35, RouteHidden),
			spaceLineOpacity = ns.OptionsSpacer(35.5, RouteHidden),
			lineOpacityLabel = ns.OptionsRowLabel(
				L["LINE_OPACITY"],
				36,
				nil,
				RouteHidden,
				L["LINE_OPACITY_DESCRIPTION"]
			),
			lineOpacity = ns.OptionsRoutesControl("lineOpacity", {
				type = "range",
				desc = L["LINE_OPACITY_DESCRIPTION"],
				min = 0.2,
				max = 1,
				step = 0.1,
				isPercent = true,
			}, 37, RouteHidden),

			spacePlanning0 = ns.OptionsSpacer(38, TakenInHidden),
			headerPlanning = ns.OptionsHeader(L["ROUTES_PLANNING_HEADER"], 38.1, TakenInHidden),
			spacePlanning1 = ns.OptionsSpacer(38.2, TakenInHidden),
			descPlanning = ns.OptionsDesc(L["ROUTES_PLANNING_DESCRIPTION"], 38.3, TakenInHidden),
			spacePlanning2 = ns.OptionsSpacer(38.4, TakenInHidden),
			-- The same setting as the Quest Arrow menu's Predictive Questing Routes (Routes-Chains.lua)
			predictiveRoutes = Toggle("predictiveRoutes", "PREDICTIVE_ROUTES", 38.5, TakenInHidden),
			spaceFlightPaths = ns.OptionsSpacer(38.6, TakenInHidden),
			-- The same setting as the Quest Arrow menu's Flight Paths
			showFlightPaths = Toggle("showFlightPaths", "SHOW_FLIGHT_PATHS", 38.7, TakenInHidden),

			spaceParty0 = ns.OptionsSpacer(40, TakenInHidden),
			headerParty = ns.OptionsHeader(L["ROUTES_PARTY_HEADER"], 41, TakenInHidden),
			spaceParty1 = ns.OptionsSpacer(42, TakenInHidden),
			descParty = ns.OptionsDesc(L["ROUTES_PARTY_DESCRIPTION"], 42.1, TakenInHidden),
			spaceParty2 = ns.OptionsSpacer(42.2, TakenInHidden),
			partyQuests = Toggle("partyQuests", "PARTY_QUESTS", 43, TakenInHidden),
			spaceGroupUp = ns.OptionsSpacer(43.5, TakenInHidden),
			groupUp = Toggle("groupUp", "GROUP_UP", 44, TakenInHidden, GroupUpOff),
		},
	}
	AddLocalQuestsSection(options.args)
	return options
end
