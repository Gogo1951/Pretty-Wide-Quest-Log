local _, ns = ...
local L = ns.L

--[[
	The Quest Arrow panel of the Options Interface, which Options.lua registers after Quest Route, in
	the Features section's order, where Routes (Features/Routes) is loaded. The settings are Routes' own, on
	the profile (routes.Settings); each control hides while the switch at the top of the panel is off
]]

local function Settings()
	return ns.routes.Settings()
end

local function ArrowHidden()
	return not Settings().showArrow
end

-- A full-width switch for a setting, hidden with its feature
local function Toggle(key, nameKey, order, hidden)
	return ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION", order, nil, hidden)
end

-- The tooltips quote the Quest Arrow's own lines, so a translation always matches what the arrow shows
local SHOW_DISTANCE_TEXT = L["SHOW_DISTANCE_DESCRIPTION"]:format(L["ROUTES_OBJECTIVE_AREA"], L["ROUTES_ARRIVED"])
local QUESTS_LISTED_TEXT = L["QUESTS_LISTED_DESCRIPTION"]:format(L["ROUTES_MORE_TASKS"]:format(2))
local SHOW_NEXT_TEXT =
	L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"]:format(L["ROUTES_OBJECTIVE_AREA"], L["ROUTES_NEXT_OBJECTIVE"])

-- How near a quest giver must be, the Search Range, in the Quest Arrow's own words for a distance (Routes-Pick-Ups.lua)
local function LocalQuestsToggle()
	local toggle = Toggle("showLocalQuests", "SHOW_LOCAL_QUESTS", 29.5, ArrowHidden)
	toggle.desc = function()
		local range = ns.routes and ns.routes.LocalQuestRange() or 400
		return L["SHOW_LOCAL_QUESTS_DESCRIPTION"]:format(L["ROUTES_YARDS"]:format(range))
	end
	return toggle
end

local function ShowDistanceToggle()
	local toggle = Toggle("showDistance", "SHOW_DISTANCE", 23, ArrowHidden)
	toggle.desc = SHOW_DISTANCE_TEXT
	return toggle
end

-- The same setting as the Quest Arrow menu's Show Next Objective
local function ShowNextToggle()
	local toggle = Toggle("showNextObjective", "SHOW_NEXT_OBJECTIVE", 27, ArrowHidden)
	toggle.desc = SHOW_NEXT_TEXT
	return toggle
end

--------------------------------------------------------------------------------
-- Quest Arrow Panel
--------------------------------------------------------------------------------

local function QuestsHidden()
	return ArrowHidden() or not Settings().showQuests
end

local function LocalHidden()
	return ArrowHidden() or not Settings().showLocalQuests
end

-- What a Local Available Quests choice does with a kind of quest (Routes-Pick-Ups.lua)
local LOCAL_CHOICES = { route = "LOCAL_CHOICE_ROUTE", map = "LOCAL_CHOICE_MAP", off = "LOCAL_CHOICE_OFF" }
local LOCAL_CHOICE_ORDER = { "route", "map", "off" }
local LOCAL_LEVELS = { questie = "LOCAL_LEVEL_QUESTIE", green = "LOCAL_LEVEL_GREEN", yellow = "LOCAL_LEVEL_YELLOW" }
local LOCAL_LEVEL_ORDER = { "questie", "green", "yellow" }

local function Choices(names)
	local values = {}
	for value, nameKey in pairs(names) do
		values[value] = L[nameKey]
	end
	return values
end

-- A row of the Local Available Quests section: its caption on the left, a dropdown of choices on the right
local function LocalRow(args, key, nameKey, order, names, sorting)
	local desc = L[nameKey .. "_DESCRIPTION"]
	args[key .. "Space"] = ns.OptionsSpacer(order - 0.02, LocalHidden)
	args[key .. "Label"] = ns.OptionsRowLabel(L[nameKey], order, nil, LocalHidden, desc)
	args[key] = ns.OptionsRoutesControl(key, {
		type = "select",
		desc = desc,
		values = function()
			return Choices(names)
		end,
		sorting = sorting,
	}, order + 0.01, LocalHidden)
end

-- The Local Available Quests section, between Under the Arrow and Hiding: which nearby quests count
local function AddLocalQuestsSection(args)
	args.spaceLocal0 = ns.OptionsSpacer(29, ArrowHidden)
	args.headerLocal = ns.OptionsHeader(L["LOCAL_QUESTS_HEADER"], 29.1, ArrowHidden)
	args.spaceLocal1 = ns.OptionsSpacer(29.2, ArrowHidden)
	args.descLocal = ns.OptionsDesc(L["LOCAL_QUESTS_DESCRIPTION"], 29.3, ArrowHidden)
	args.spaceLocal2 = ns.OptionsSpacer(29.4, ArrowHidden)
	-- The same setting as the Quest Arrow menu's Local Available Quests
	args.showLocalQuests = LocalQuestsToggle()
	args.spaceLocalRange = ns.OptionsSpacer(29.55, LocalHidden)
	args.localQuestRangeLabel =
		ns.OptionsRowLabel(L["LOCAL_QUEST_RANGE"], 29.6, nil, LocalHidden, L["LOCAL_QUEST_RANGE_DESCRIPTION"])
	args.localQuestRange = ns.OptionsRoutesControl("localQuestRange", {
		type = "range",
		desc = L["LOCAL_QUEST_RANGE_DESCRIPTION"],
		min = 200,
		max = 800,
		step = 50,
	}, 29.61, LocalHidden)
	args.spaceLocalCounts = ns.OptionsSpacer(29.63, LocalHidden)
	args.localCountsLabel =
		ns.OptionsDesc(ns.GetColor("TITLE") .. L["LOCAL_QUESTS_WHAT_COUNTS"] .. "|r", 29.64, LocalHidden)
	LocalRow(args, "localEscortQuests", "LOCAL_ESCORT_QUESTS", 29.7, LOCAL_CHOICES, LOCAL_CHOICE_ORDER)
	LocalRow(args, "localGroupQuests", "LOCAL_GROUP_QUESTS", 29.75, LOCAL_CHOICES, LOCAL_CHOICE_ORDER)
	LocalRow(args, "localOtherZoneQuests", "LOCAL_OTHER_ZONE_QUESTS", 29.8, LOCAL_CHOICES, LOCAL_CHOICE_ORDER)
	LocalRow(args, "localQuestLevel", "LOCAL_QUEST_LEVEL", 29.85, LOCAL_LEVELS, LOCAL_LEVEL_ORDER)
end

-- What ignoring a waypoint from the Quest Arrow's menu prints, for the flavor's first sample quest's turn-in
local function IgnoredPrintExample()
	local quest = ns.SampleQuests()[1]
	local label = L["ROUTES_MENU_TURN_IN"]:format(quest.title)
	return ns.RenderSample("PRINT", ns.routes.BuildIgnoredMessage(label, quest.questID, quest.title))
end

function ns.BuildQuestArrowOptions()
	local options = {
		type = "group",
		name = L["TAB_QUEST_ARROW"],
		args = {
			descIntro = ns.OptionsDesc(L["TAB_QUEST_ARROW_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			enableQuestArrow = ns.OptionsRoutesToggle(
				"showArrow",
				"ENABLE_QUEST_ARROW",
				"FEATURE_QUEST_ARROW_DESCRIPTION",
				3
			),

			spaceArrow0 = ns.OptionsSpacer(10, ArrowHidden),
			headerArrow = ns.OptionsHeader(L["QUEST_ARROW_HEADER"], 11, ArrowHidden),
			spaceArrow1 = ns.OptionsSpacer(12, ArrowHidden),
			descArrow = ns.OptionsDesc(L["QUEST_ARROW_DESCRIPTION"], 12.1, ArrowHidden),
			spaceArrow2 = ns.OptionsSpacer(12.2, ArrowHidden),
			arrowScaleLabel = ns.OptionsRowLabel(L["ARROW_SIZE"], 13, nil, ArrowHidden, L["ARROW_SIZE_DESCRIPTION"]),
			arrowScale = ns.OptionsRoutesControl("arrowScale", {
				type = "range",
				desc = L["ARROW_SIZE_DESCRIPTION"],
				min = 0.5,
				max = 2,
				step = 0.05,
				isPercent = true,
			}, 14, ArrowHidden),
			spaceLock = ns.OptionsSpacer(15, ArrowHidden),
			lockArrow = Toggle("lockArrow", "LOCK_ARROW", 16, ArrowHidden),
			spaceReset = ns.OptionsSpacer(16.5, ArrowHidden),
			resetArrowLabel = ns.OptionsRowLabel(L["RESET_ARROW"], 17, nil, ArrowHidden, L["RESET_ARROW_DESCRIPTION"]),
			resetArrow = ns.OptionsRoutesControl(nil, {
				type = "execute",
				name = L["RESET_ARROW_BUTTON"],
				desc = L["RESET_ARROW_DESCRIPTION"],
				confirm = true,
				confirmText = L["RESET_ARROW_CONFIRM"],
				func = function()
					ns.routes.ResetArrowPosition()
				end,
			}, 18, ArrowHidden),

			spaceText0 = ns.OptionsSpacer(20, ArrowHidden),
			headerText = ns.OptionsHeader(L["QUEST_ARROW_TEXT_HEADER"], 21, ArrowHidden),
			spaceText1 = ns.OptionsSpacer(22, ArrowHidden),
			descText = ns.OptionsDesc(L["QUEST_ARROW_TEXT_DESCRIPTION"], 22.1, ArrowHidden),
			spaceText2 = ns.OptionsSpacer(22.2, ArrowHidden),
			showDistance = ShowDistanceToggle(),
			spaceShowQuests = ns.OptionsSpacer(23.5, ArrowHidden),
			showQuests = Toggle("showQuests", "SHOW_ARROW_QUESTS", 24, ArrowHidden),
			ignoredExampleRow = ns.OptionsExampleRow(24.2, IgnoredPrintExample, ArrowHidden),
			spaceQuestsListed = ns.OptionsSpacer(24.5, QuestsHidden),
			questsListedLabel = ns.OptionsRowLabel(L["QUESTS_LISTED"], 25, nil, QuestsHidden, QUESTS_LISTED_TEXT),
			questsListed = ns.OptionsRoutesControl("questsListed", {
				type = "range",
				desc = QUESTS_LISTED_TEXT,
				min = 1,
				max = 8,
				step = 1,
			}, 26, QuestsHidden),
			spaceItemButtons = ns.OptionsSpacer(26.2, QuestsHidden),
			showItemButtons = Toggle("showItemButtons", "SHOW_ITEM_BUTTONS", 26.3, QuestsHidden),
			spaceShowNext = ns.OptionsSpacer(26.5, ArrowHidden),
			showNextObjective = ShowNextToggle(),
			spaceUpcomingTurnIns = ns.OptionsSpacer(27.5, ArrowHidden),
			-- The same setting as the Quest Arrow menu's Future Turn-Ins
			showUpcomingTurnIns = Toggle("showUpcomingTurnIns", "SHOW_UPCOMING_TURN_INS", 28, ArrowHidden),

			spaceHiding0 = ns.OptionsSpacer(30, ArrowHidden),
			headerHiding = ns.OptionsHeader(L["QUEST_ARROW_HIDING_HEADER"], 31, ArrowHidden),
			spaceHiding1 = ns.OptionsSpacer(32, ArrowHidden),
			descHiding = ns.OptionsDesc(L["QUEST_ARROW_HIDING_DESCRIPTION"], 32.1, ArrowHidden),
			spaceHiding2 = ns.OptionsSpacer(32.2, ArrowHidden),
			hideInRaids = Toggle("hideInRaids", "HIDE_IN_RAIDS", 33, ArrowHidden),
			spaceHideInInstances = ns.OptionsSpacer(33.5, ArrowHidden),
			hideInInstances = Toggle("hideInInstances", "HIDE_IN_INSTANCES", 34, ArrowHidden),
		},
	}
	AddLocalQuestsSection(options.args)
	return options
end
