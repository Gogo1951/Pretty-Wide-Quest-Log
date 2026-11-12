local _, ns = ...
local L = ns.L

--[[
	The Quest Route panel of the Options Interface, which Options.lua registers after Maps & Objectives where
	Routes (Features/Routes) is loaded. The settings are Routes' own, on the profile (routes.Settings). Its
	controls hide while the switch at the top of it is off, but Party, which shows while anything follows
	the route (the Waypoint Markers or the Quest Arrow). The Quest Route is drawn between the markers, so
	its switch is grayed out while they're off. The markers' switch, and their settings map by map, are
	under Maps & Objectives (Options-Maps.lua)
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
			spaceGroupUp = ns.OptionsSpacer(43.5, PartyHidden),
			groupUp = Toggle("groupUp", "GROUP_UP", 44, PartyHidden, GroupUpOff),
		},
	}
end
