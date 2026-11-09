local _, ns = ...
local L = ns.L

--[[
	The Waypoint Markers and Quest Route panels of the Options Interface, which Options.lua registers after
	Quality of Life, in the Features section's order, where Routes (Features/Routes) is loaded. The settings
	are Routes' own, on the profile (routes.Settings). Each panel's controls hide while the switch at the top
	of it is off, but Party, on the Quest Route panel, which shows while anything follows the route (the
	Waypoint Markers or the Quest Arrow). The Quest Route is drawn between the markers, so its switch is
	grayed out while they're off
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
local function PartyHidden()
	return not (Settings().showMap or Settings().showArrow)
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
-- Waypoint Markers Panel
--------------------------------------------------------------------------------

-- Marker Size is times the markers' 42 pixels and the icon on them (STOP_SIZE in Routes-Map.lua)
function ns.BuildWaypointMarkersOptions()
	return {
		type = "group",
		name = L["TAB_WAYPOINT_MARKERS"],
		args = {
			descIntro = ns.OptionsDesc(L["TAB_WAYPOINT_MARKERS_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			enableWaypointMarkers = ns.OptionsRoutesToggle(
				"showMap",
				"ENABLE_WAYPOINT_MARKERS",
				"FEATURE_WAYPOINT_MARKERS_DESCRIPTION",
				3
			),

			spaceMap0 = ns.OptionsSpacer(10, MarkersHidden),
			headerMap = ns.OptionsHeader(L["ROUTES_MAP_HEADER"], 11, MarkersHidden),
			spaceMap1 = ns.OptionsSpacer(12, MarkersHidden),
			descMap = ns.OptionsDesc(L["ROUTES_MAP_DESCRIPTION"], 12.1, MarkersHidden),
			spaceMap2 = ns.OptionsSpacer(12.2, MarkersHidden),
			fullSizeMap = Toggle("fullSizeMap", "FULL_SIZE_MAP", 13, MarkersHidden),
			spaceQuestieIcons = ns.OptionsSpacer(13.5, MarkersHidden),
			hideQuestieIcons = Toggle("hideQuestieIcons", "HIDE_QUESTIE_ICONS", 14, MarkersHidden),

			spaceMarkers0 = ns.OptionsSpacer(20, MarkersHidden),
			headerMarkers = ns.OptionsHeader(L["ROUTES_MARKERS_HEADER"], 21, MarkersHidden),
			spaceMarkers1 = ns.OptionsSpacer(22, MarkersHidden),
			descMarkers = ns.OptionsDesc(L["ROUTES_MARKERS_DESCRIPTION"], 22.1, MarkersHidden),
			spaceMarkers2 = ns.OptionsSpacer(22.2, MarkersHidden),
			markerScaleLabel = ns.OptionsRowLabel(
				L["MARKER_SIZE"],
				23,
				nil,
				MarkersHidden,
				L["MARKER_SIZE_DESCRIPTION"]
			),
			markerScale = ns.OptionsRoutesControl("markerScale", {
				type = "select",
				desc = L["MARKER_SIZE_DESCRIPTION"],
				values = ns.OptionsSizeValues,
				sorting = ns.OPTIONS_SIZE_ORDER,
			}, 24, MarkersHidden),
		},
	}
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

function ns.BuildQuestRouteOptions()
	return {
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

			spaceParty0 = ns.OptionsSpacer(40, PartyHidden),
			headerParty = ns.OptionsHeader(L["ROUTES_PARTY_HEADER"], 41, PartyHidden),
			spaceParty1 = ns.OptionsSpacer(42, PartyHidden),
			descParty = ns.OptionsDesc(L["ROUTES_PARTY_DESCRIPTION"], 42.1, PartyHidden),
			spaceParty2 = ns.OptionsSpacer(42.2, PartyHidden),
			partyQuests = Toggle("partyQuests", "PARTY_QUESTS", 43, PartyHidden),
		},
	}
end
