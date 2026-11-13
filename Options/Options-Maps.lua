local _, ns = ...
local L = ns.L

--[[
	The Maps & Objectives panel of the Options Interface, with the Enable Waypoint Markers switch and its
	Mini-Map, Zone Map and Continent & World Map panels under it, which Options.lua registers right after
	Wide Quest Log where Routes (Features/Routes) is loaded. Each map's panel says whether the Waypoint
	Markers show on it and how big. The settings are Routes' own, on the profile (routes.Settings). Every
	marker is a Waypoint Marker, so each panel's controls hide while Enable Waypoint Markers is off, and a
	line says what turns them back on
]]

local function Settings()
	return ns.routes.Settings()
end

local function MarkersHidden()
	return not Settings().showMap
end

local function MinimapHidden()
	return MarkersHidden() or not Settings().showMinimapMarkers
end

local function WideMapHidden()
	return MarkersHidden() or not Settings().showWideMapMarkers
end

-- A full-width switch for a setting, hidden with its feature
local function Toggle(key, nameKey, order, hidden)
	return ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION", order, nil, hidden)
end

--[[
	What right-clicking a waypoint on the world map prints (routes.SkipStop), for the flavor's first sample
	quest. For the markers as a whole rather than one map, so not indented under the switch
]]
local function SkippedExample(order)
	return {
		type = "description",
		name = function()
			if ns.NoSampleQuests() then
				return ""
			end
			local quest = ns.SampleQuests()[1]
			local link = ns.routes.QuestLink(quest.questID, quest.title)
			return ns.RenderSample("PRINT", ns.routes.BuildSkippedMessage({ link }))
		end,
		fontSize = "medium",
		order = order,
		hidden = function()
			return MarkersHidden() or ns.NoSampleQuests()
		end,
	}
end

-- The silver line under a panel's intro, saying what turns its markers back on
local function NeedsMarkersText()
	if MarkersHidden() then
		return L["MAPS_NEED_MARKERS"]
	end
end

--[[
	A map's markers switch with its one setting, Marker Size, beside it (Build Reference → Sub-Option Rows),
	hidden while the switch is off
]]
local function AddSwitchWithSize(args, switchKey, nameKey, sizeKey, desc, order, hidden)
	args[switchKey] = Toggle(switchKey, nameKey, order, MarkersHidden)
	args[switchKey].width = ns.OPTIONS_LABEL_WIDTH
	args[sizeKey] = ns.OptionsRoutesControl(sizeKey, {
		type = "select",
		desc = desc,
		values = ns.OptionsSizeValues,
		sorting = ns.OPTIONS_SIZE_ORDER,
	}, order + 0.01, hidden)
end

-- A Marker Size row: its caption on the left, the four sizes on the right
local function AddSizeRow(args, key, desc, order, hidden)
	args[key .. "Space"] = ns.OptionsSpacer(order - 0.02, hidden)
	args[key .. "Label"] = ns.OptionsRowLabel(L["MARKER_SIZE"], order, nil, hidden, desc)
	args[key] = ns.OptionsRoutesControl(key, {
		type = "select",
		desc = desc,
		values = ns.OptionsSizeValues,
		sorting = ns.OPTIONS_SIZE_ORDER,
	}, order + 0.01, hidden)
end

-- The intro every map's panel opens with, and the line under it while the markers are off
local function Panel(nameKey, descKey)
	return {
		type = "group",
		name = L[nameKey],
		args = {
			descIntro = ns.OptionsDesc(L[descKey], 1),
			spaceIntro = ns.OptionsSpacer(2),
			needsMarkers = ns.OptionsStatusLine(NeedsMarkersText, 3),
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
			descIntro = ns.OptionsDesc(L["TAB_WAYPOINT_MARKERS_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			-- The same setting as the root panel's Waypoint Markers switch
			enableWaypointMarkers = ns.OptionsRoutesToggle(
				"showMap",
				"ENABLE_WAYPOINT_MARKERS",
				"FEATURE_WAYPOINT_MARKERS_DESCRIPTION",
				3
			),
			spaceSkippedExample = ns.OptionsSpacer(3.5, MarkersHidden),
			skippedExample = SkippedExample(3.6),
			spaceSubPanels = ns.OptionsSpacer(4),
			descSubPanels = ns.OptionsDesc(L["MAPS_SUB_PANELS_DESCRIPTION"], 5),
		},
	}
end

--------------------------------------------------------------------------------
-- Mini-Map Panel
--------------------------------------------------------------------------------

-- Off by default: Questie's minimap icons show each spawn and drop exactly, and are never hidden (Routes-Minimap.lua)
function ns.BuildMinimapOptions()
	local options = Panel("TAB_MINIMAP", "TAB_MINIMAP_DESCRIPTION")
	local args = options.args
	AddSwitchWithSize(
		args,
		"showMinimapMarkers",
		"SHOW_MINIMAP_MARKERS",
		"minimapMarkerScale",
		L["MINIMAP_MARKER_SIZE_DESCRIPTION"],
		10,
		MinimapHidden
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
	args.fullSizeMap = Toggle("fullSizeMap", "FULL_SIZE_MAP", 10, MarkersHidden)
	args.spaceQuestieIcons = ns.OptionsSpacer(10.5, MarkersHidden)
	args.hideQuestieIcons = Toggle("hideQuestieIcons", "HIDE_QUESTIE_ICONS", 11, MarkersHidden)
	AddSizeRow(args, "markerScale", L["MARKER_SIZE_DESCRIPTION"], 12, MarkersHidden)
	-- How much of the route the zone map draws before its "…" marker (Routes-Map.lua)
	args.waypointsShownSpace = ns.OptionsSpacer(12.98, MarkersHidden)
	args.waypointsShownLabel =
		ns.OptionsRowLabel(L["WAYPOINTS_SHOWN"], 13, nil, MarkersHidden, L["WAYPOINTS_SHOWN_DESCRIPTION"])
	args.waypointsShown = ns.OptionsRoutesControl("waypointsShown", {
		type = "select",
		desc = L["WAYPOINTS_SHOWN_DESCRIPTION"],
		values = function()
			local values = { [0] = L["WAYPOINTS_SHOWN_ALL"] }
			for _, count in ipairs(WAYPOINTS_SHOWN_ORDER) do
				if count > 0 then
					values[count] = L["WAYPOINTS_SHOWN_NEXT"]:format(count)
				end
			end
			return values
		end,
		sorting = WAYPOINTS_SHOWN_ORDER,
	}, 13.01, MarkersHidden)
	return options
end

--------------------------------------------------------------------------------
-- Continent & World Map Panel
--------------------------------------------------------------------------------

-- Marker Size is times the zone map's markers at Medium, shrunk for a map of many zones (WIDE_MAP_SCALE in Routes-Map.lua)
function ns.BuildWideMapOptions()
	local options = Panel("TAB_WIDE_MAP", "TAB_WIDE_MAP_DESCRIPTION")
	local args = options.args
	AddSwitchWithSize(
		args,
		"showWideMapMarkers",
		"SHOW_WIDE_MAP_MARKERS",
		"wideMarkerScale",
		L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"],
		10,
		WideMapHidden
	)
	return options
end
