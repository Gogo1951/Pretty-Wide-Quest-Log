local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

--[[
	The Maps & Objectives panel of the Options Interface, with the Enable Waypoint Markers switch and its
	Mini-Map, Zone Map and Continent & World Map panels under it, which Options.lua registers right after
	Wide Quest Log where Routes (Features/Routes) is loaded. Each map's panel says whether the Waypoint
	Markers show on it and how big. The settings are Routes' own, on the profile (routes.Settings). Every
	marker is a Waypoint Marker, so while Enable Waypoint Markers is off a line over each map's settings says
	they aren't being used and where the switch is; the settings stay in view to set up beforehand
]]

local function Settings()
	return ns.routes.Settings()
end

local function MarkersOff()
	return not Settings().showMap
end

-- A full-width switch for a Routes setting
local function Toggle(key, nameKey, order)
	return ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION", order)
end

-- What right-clicking a waypoint on the world map prints (routes.SkipStop), for the flavor's first sample quest
local function SkippedExample()
	local quest = ns.SampleQuests()[1]
	local link = ns.routes.QuestLink(quest.questID, quest.title)
	return ns.PrintedExample(ns.routes.BuildSkippedMessage({ link }))
end

-- The silver line under a map panel's intro while the markers are off, saying where their switch is
local function NeedsMarkersText()
	if MarkersOff() then
		return L["MAPS_NEED_MARKERS"]
	end
end

--[[
	A map's markers switch with its one setting, Marker Size, beside it in the control column; the size leaves
	while the switch is off
]]
local function SwitchWithSize(switchKey, nameKey, sizeKey, desc, order)
	local switch = Toggle(switchKey, nameKey)
	return Kit.ToggleRow(order, switch, {
		control = ns.OptionsRoutesControl(sizeKey, {
			type = "select",
			desc = desc,
			values = ns.OptionsSizeValues,
			sorting = ns.OPTIONS_SIZE_ORDER,
		}),
	})
end

-- A caption beside its select, for a Routes setting
local function SelectRow(key, nameKey, desc, values, sorting, order)
	return ns.OptionsRoutesLabelRow(order, nil, L[nameKey], desc, key, {
		type = "select",
		values = values,
		sorting = sorting,
	})
end

-- The intro every map's panel opens with, and the line under it while the markers are off
local function Panel(nameKey, descKey)
	return {
		type = "group",
		name = L[nameKey],
		args = {
			descIntro = Kit.Desc(L[descKey], 1),
			spaceIntro = Kit.Spacer(2),
			needsMarkers = Kit.StatusLine(NeedsMarkersText, 3),
		},
	}
end

--------------------------------------------------------------------------------
-- Maps & Objectives Panel
--------------------------------------------------------------------------------

function ns.BuildMapsObjectivesOptions()
	return {
		type = "group",
		name = L["TAB_MAPS_OBJECTIVES"],
		args = {
			descIntro = Kit.Desc(L["TAB_WAYPOINT_MARKERS_DESCRIPTION"], 1),
			spaceIntro = Kit.Spacer(2),
			-- The same setting as the root panel's Waypoint Markers switch
			enableWaypointMarkers = ns.FeatureSwitch("routes.showMap", 3),
			needsQuestie = ns.RoutesNeedQuestieLine(3.1),
			skippedExample = ns.OptionsExample(3.6, MarkersOff, SkippedExample),
			spaceSubPanels = Kit.Spacer(4),
			descSubPanels = Kit.Desc(L["MAPS_SUB_PANELS_DESCRIPTION"], 5),
		},
	}
end

--------------------------------------------------------------------------------
-- Mini-Map Panel
--------------------------------------------------------------------------------

-- Off by default: Questie's minimap icons show each spawn and drop exactly, and are never hidden (Routes-Minimap.lua)
function ns.BuildMinimapOptions()
	local options = Panel("TAB_MINIMAP", "TAB_MINIMAP_DESCRIPTION")
	options.args.showMinimapMarkers = SwitchWithSize(
		"showMinimapMarkers",
		"SHOW_MINIMAP_MARKERS",
		"minimapMarkerScale",
		L["MINIMAP_MARKER_SIZE_DESCRIPTION"],
		10
	)
	return options
end

--------------------------------------------------------------------------------
-- Zone Map Panel
--------------------------------------------------------------------------------

-- Waypoints Shown's choices: the next 5, 10 or 20, or the whole route (0)
local WAYPOINTS_SHOWN_ORDER = { 5, 10, 20, 0 }

-- Marker Size is times the markers' 32 pixels and the icon on them (STOP_SIZE in Routes-Map.lua)
function ns.BuildZoneMapOptions()
	local options = Panel("TAB_ZONE_MAP", "TAB_ZONE_MAP_DESCRIPTION")
	local args = options.args
	args.fullSizeMap = Toggle("fullSizeMap", "FULL_SIZE_MAP", 10)
	args.spaceQuestieIcons = Kit.Spacer(10.5)
	args.hideQuestieIcons = Toggle("hideQuestieIcons", "HIDE_QUESTIE_ICONS", 11)
	args.markerScaleSpace = Kit.Spacer(11.5)
	args.markerScale = SelectRow(
		"markerScale",
		"MARKER_SIZE",
		L["MARKER_SIZE_DESCRIPTION"],
		ns.OptionsSizeValues,
		ns.OPTIONS_SIZE_ORDER,
		12
	)
	-- How much of the route the zone map draws before its "…" marker (Routes-Map.lua)
	args.waypointsShownSpace = Kit.Spacer(12.5)
	args.waypointsShown = SelectRow("waypointsShown", "WAYPOINTS_SHOWN", L["WAYPOINTS_SHOWN_DESCRIPTION"], function()
		local values = { [0] = L["WAYPOINTS_SHOWN_ALL"] }
		for _, count in ipairs(WAYPOINTS_SHOWN_ORDER) do
			if count > 0 then
				values[count] = L["WAYPOINTS_SHOWN_NEXT"]:format(count)
			end
		end
		return values
	end, WAYPOINTS_SHOWN_ORDER, 13)
	return options
end

--------------------------------------------------------------------------------
-- Continent & World Map Panel
--------------------------------------------------------------------------------

-- Marker Size is times the zone map's markers at Medium, shrunk for a map of many zones (WIDE_MAP_SCALE in Routes-Map.lua)
function ns.BuildWideMapOptions()
	local options = Panel("TAB_WIDE_MAP", "TAB_WIDE_MAP_DESCRIPTION")
	options.args.showWideMapMarkers = SwitchWithSize(
		"showWideMapMarkers",
		"SHOW_WIDE_MAP_MARKERS",
		"wideMarkerScale",
		L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"],
		10
	)
	return options
end
