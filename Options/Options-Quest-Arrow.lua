local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

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

-- A switch that's a sub-option of the switch above it, on its own indented row in silver
local function SubToggle(key, nameKey, order, hidden)
	local toggle = ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION")
	toggle.hidden = nil
	return Kit.SubToggleRow(order, hidden, toggle)
end

--------------------------------------------------------------------------------
-- Quest Arrow Panel
--------------------------------------------------------------------------------

local function QuestsHidden()
	return ArrowHidden() or not Settings().showQuests
end

-- What ignoring a waypoint from the Quest Arrow's menu prints, for the flavor's first sample quest's turn-in
local function IgnoredPrintExample()
	local quest = ns.SampleQuests()[1]
	local label = L["ROUTES_MENU_TURN_IN"]:format(quest.title)
	return ns.PrintedExample(ns.routes.BuildIgnoredMessage(label, quest.questID, quest.title))
end

function ns.BuildQuestArrowOptions()
	local options = {
		type = "group",
		name = L["TAB_QUEST_ARROW"],
		args = {
			descIntro = Kit.Desc(L["TAB_QUEST_ARROW_DESCRIPTION"], 1),
			spaceIntro = Kit.Spacer(2),
			enableQuestArrow = ns.FeatureSwitch("routes.showArrow", 3),
			needsQuestie = ns.RoutesNeedQuestieLine(3.1),
			-- Ignoring comes from the arrow as a whole, so its Example closes the arrow's own switch
			ignoredExample = ns.OptionsExample(3.2, ArrowHidden, IgnoredPrintExample),

			arrowScale = ns.OptionsRoutesLabelRow(
				13,
				ArrowHidden,
				L["ARROW_SIZE"],
				L["ARROW_SIZE_DESCRIPTION"],
				"arrowScale",
				{
					type = "range",
					min = 0.5,
					max = 2,
					step = 0.05,
					isPercent = true,
				}
			),
			spaceLock = Kit.Spacer(15, ArrowHidden),
			lockArrow = Toggle("lockArrow", "LOCK_ARROW", 16, ArrowHidden),
			spaceReset = Kit.Spacer(16.5, ArrowHidden),
			resetArrow = Kit.ResetRow(17, ArrowHidden, L["RESET_ARROW"], L["RESET_ARROW_DESCRIPTION"], nil, function()
				ns.routes.ResetArrowPosition()
			end, L["RESET_ARROW_CONFIRM"]),

			showDistance = ShowDistanceToggle(),
			spaceShowQuests = Kit.Spacer(23.5, ArrowHidden),
			showQuests = Toggle("showQuests", "SHOW_ARROW_QUESTS", 24, ArrowHidden),
			spaceQuestsListed = Kit.Spacer(24.5, QuestsHidden),
			questsListedRow = ns.OptionsRoutesSubControlRow(
				25,
				QuestsHidden,
				L["QUESTS_LISTED"],
				QUESTS_LISTED_TEXT,
				"questsListed",
				{ type = "range", min = 1, max = 8, step = 1 }
			),
			spaceItemButtons = Kit.Spacer(26.2, QuestsHidden),
			showItemButtons = SubToggle("showItemButtons", "SHOW_ITEM_BUTTONS", 26.3, QuestsHidden),
			spaceShowNext = Kit.Spacer(26.5, ArrowHidden),
			showNextObjective = ShowNextToggle(),

			hideInRaids = Toggle("hideInRaids", "HIDE_IN_RAIDS", 33, ArrowHidden),
			spaceHideInInstances = Kit.Spacer(33.5, ArrowHidden),
			hideInInstances = Toggle("hideInInstances", "HIDE_IN_INSTANCES", 34, ArrowHidden),
		},
	}
	local args = options.args
	Kit.Section(args, "Arrow", 10, L["QUEST_ARROW_HEADER"], L["QUEST_ARROW_DESCRIPTION"], ArrowHidden)
	Kit.Section(args, "Text", 20, L["QUEST_ARROW_TEXT_HEADER"], L["QUEST_ARROW_TEXT_DESCRIPTION"], ArrowHidden)
	Kit.Section(args, "Hiding", 30, L["QUEST_ARROW_HIDING_HEADER"], L["QUEST_ARROW_HIDING_DESCRIPTION"], ArrowHidden)
	return options
end
