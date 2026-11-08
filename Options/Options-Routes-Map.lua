local _, ns = ...
local L = ns.L

--[[
	The Routes on Zone Map panel of the Options Interface, which Options.lua registers after Quality of Life,
	in the Features section's order, where Routes (Features/Routes) is loaded. The settings are Routes' own,
	on the profile (routes.Settings); each control hides while the switch at the top of the panel is off,
	but Party, which shows while either Routes feature (the zone map's route or the Quest Arrow) is on
]]

local function Settings()
	return ns.routes.Settings()
end

local function MapHidden()
	return not Settings().showMap
end

-- Another add-on sizing the map (Leatrix Maps, Mapster) leaves Open the Zone Map Full Size nothing to do
local function FullSizeHidden()
	return MapHidden() or ns.routes.MapSizedElsewhere() ~= nil
end

-- A full-width switch for a setting, hidden with its feature
local function Toggle(key, nameKey, order, hidden)
	return ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION", order, nil, hidden)
end

--------------------------------------------------------------------------------
-- Routes on Zone Map Panel
--------------------------------------------------------------------------------

-- Times the markers' 42 pixels and the icon on them (STOP_SIZE in Routes-Map.lua)
local MARKER_SIZES = {
	[0.75] = "MARKER_SIZE_SMALL",
	[1] = "MARKER_SIZE_MEDIUM",
	[1.25] = "MARKER_SIZE_LARGE",
	[1.5] = "MARKER_SIZE_HUGE",
}
local MARKER_ORDER = { 0.75, 1, 1.25, 1.5 }

-- Dots a second the line marches
local LINE_SPEEDS =
	{ [0] = "LINE_SPEED_STILL", [0.75] = "LINE_SPEED_SLOW", [1.5] = "LINE_SPEED_NORMAL", [3] = "LINE_SPEED_FAST" }
local LINE_SPEED_ORDER = { 0, 0.75, 1.5, 3 }

local function Choices(names)
	local values = {}
	for value, nameKey in pairs(names) do
		values[value] = L[nameKey]
	end
	return values
end

-- What the route takes in shows for either feature, as both follow the one route
local function RouteHidden()
	return not (Settings().showMap or Settings().showArrow)
end

local function LineHidden()
	return MapHidden() or not Settings().showLine
end

function ns.BuildRoutesMapOptions()
	return {
		type = "group",
		name = L["TAB_ROUTES_MAP"],
		args = {
			descIntro = ns.OptionsDesc(L["TAB_ROUTES_MAP_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			enableRoutesMap = ns.OptionsRoutesToggle(
				"showMap",
				"ENABLE_ROUTES_MAP",
				"FEATURE_ROUTES_MAP_DESCRIPTION",
				3
			),

			spaceMap0 = ns.OptionsSpacer(10, MapHidden),
			headerMap = ns.OptionsHeader(L["ROUTES_MAP_HEADER"], 11, MapHidden),
			spaceMap1 = ns.OptionsSpacer(12, MapHidden),
			descMap = ns.OptionsDesc(L["ROUTES_MAP_DESCRIPTION"], 12.1, MapHidden),
			spaceMap2 = ns.OptionsSpacer(12.2, MapHidden),
			fullSizeMap = Toggle("fullSizeMap", "FULL_SIZE_MAP", 13, FullSizeHidden),
			spaceQuestieIcons = ns.OptionsSpacer(13.5, FullSizeHidden),
			hideQuestieIcons = Toggle("hideQuestieIcons", "HIDE_QUESTIE_ICONS", 14, MapHidden),

			spaceMarkers0 = ns.OptionsSpacer(20, MapHidden),
			headerMarkers = ns.OptionsHeader(L["ROUTES_MARKERS_HEADER"], 21, MapHidden),
			spaceMarkers1 = ns.OptionsSpacer(22, MapHidden),
			descMarkers = ns.OptionsDesc(L["ROUTES_MARKERS_DESCRIPTION"], 22.1, MapHidden),
			spaceMarkers2 = ns.OptionsSpacer(22.2, MapHidden),
			markerScaleLabel = ns.OptionsRowLabel(L["MARKER_SIZE"], 23, nil, MapHidden, L["MARKER_SIZE_DESCRIPTION"]),
			markerScale = ns.OptionsRoutesControl("markerScale", {
				type = "select",
				desc = L["MARKER_SIZE_DESCRIPTION"],
				values = function()
					return Choices(MARKER_SIZES)
				end,
				sorting = MARKER_ORDER,
			}, 24, MapHidden),

			spaceLine0 = ns.OptionsSpacer(30, MapHidden),
			headerLine = ns.OptionsHeader(L["ROUTES_LINE_HEADER"], 31, MapHidden),
			spaceLine1 = ns.OptionsSpacer(32, MapHidden),
			descLine = ns.OptionsDesc(L["ROUTES_LINE_DESCRIPTION"], 32.1, MapHidden),
			spaceLine2 = ns.OptionsSpacer(32.2, MapHidden),
			showLine = Toggle("showLine", "SHOW_ROUTE_LINE", 33, MapHidden),
			spaceLineSpeed = ns.OptionsSpacer(33.5, LineHidden),
			lineSpeedLabel = ns.OptionsRowLabel(L["LINE_SPEED"], 34, nil, LineHidden, L["LINE_SPEED_DESCRIPTION"]),
			lineSpeed = ns.OptionsRoutesControl("lineSpeed", {
				type = "select",
				desc = L["LINE_SPEED_DESCRIPTION"],
				values = function()
					return Choices(LINE_SPEEDS)
				end,
				sorting = LINE_SPEED_ORDER,
			}, 35, LineHidden),
			spaceLineOpacity = ns.OptionsSpacer(35.5, LineHidden),
			lineOpacityLabel = ns.OptionsRowLabel(
				L["LINE_OPACITY"],
				36,
				nil,
				LineHidden,
				L["LINE_OPACITY_DESCRIPTION"]
			),
			lineOpacity = ns.OptionsRoutesControl("lineOpacity", {
				type = "range",
				desc = L["LINE_OPACITY_DESCRIPTION"],
				min = 0.2,
				max = 1,
				step = 0.1,
				isPercent = true,
			}, 37, LineHidden),

			spaceParty0 = ns.OptionsSpacer(40, RouteHidden),
			headerParty = ns.OptionsHeader(L["ROUTES_PARTY_HEADER"], 41, RouteHidden),
			spaceParty1 = ns.OptionsSpacer(42, RouteHidden),
			descParty = ns.OptionsDesc(L["ROUTES_PARTY_DESCRIPTION"], 42.1, RouteHidden),
			spaceParty2 = ns.OptionsSpacer(42.2, RouteHidden),
			partyQuests = Toggle("partyQuests", "PARTY_QUESTS", 43, RouteHidden),
		},
	}
end
