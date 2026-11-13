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
	local toggle = ns.OptionsRoutesToggle(key, nameKey, nameKey .. "_DESCRIPTION", 2)
	toggle.name = ns.OptionsSubLabel(L[nameKey])
	toggle.width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH
	return ns.OptionsSubRow(order, hidden, { [key] = toggle })
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
	return ns.RenderSample("PRINT", ns.routes.BuildIgnoredMessage(label, quest.questID, quest.title))
end

-- The ignore Example, for the whole arrow rather than any one switch, so not indented under one
local function IgnoredExample(order)
	return {
		type = "description",
		name = function()
			return ns.NoSampleQuests() and "" or IgnoredPrintExample()
		end,
		fontSize = "medium",
		order = order,
		hidden = function()
			return ArrowHidden() or ns.NoSampleQuests()
		end,
	}
end

function ns.BuildQuestArrowOptions()
	return {
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
			spaceIgnoredExample = ns.OptionsSpacer(22.12, ArrowHidden),
			ignoredExample = IgnoredExample(22.15),
			spaceText2 = ns.OptionsSpacer(22.2, ArrowHidden),
			showDistance = ShowDistanceToggle(),
			spaceShowQuests = ns.OptionsSpacer(23.5, ArrowHidden),
			showQuests = Toggle("showQuests", "SHOW_ARROW_QUESTS", 24, ArrowHidden),
			spaceQuestsListed = ns.OptionsSpacer(24.5, QuestsHidden),
			questsListedRow = ns.OptionsRoutesSubControlRow(
				25,
				QuestsHidden,
				L["QUESTS_LISTED"],
				QUESTS_LISTED_TEXT,
				"questsListed",
				{ type = "range", min = 1, max = 8, step = 1 }
			),
			spaceItemButtons = ns.OptionsSpacer(26.2, QuestsHidden),
			showItemButtons = SubToggle("showItemButtons", "SHOW_ITEM_BUTTONS", 26.3, QuestsHidden),
			spaceShowNext = ns.OptionsSpacer(26.5, ArrowHidden),
			showNextObjective = ShowNextToggle(),

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
end
