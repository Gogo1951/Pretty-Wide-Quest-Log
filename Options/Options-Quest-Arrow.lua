local _, ns = ...
local L = ns.L

--[[
	The Quest Arrow panel of the Options Interface, which Options.lua registers after Routes on Zone Map, in
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

local function ShowDistanceToggle()
	local toggle = Toggle("showDistance", "SHOW_DISTANCE", 23, ArrowHidden)
	toggle.desc = SHOW_DISTANCE_TEXT
	return toggle
end

--------------------------------------------------------------------------------
-- Quest Arrow Panel
--------------------------------------------------------------------------------

local function QuestsHidden()
	return ArrowHidden() or not Settings().showQuests
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
			arrowScaleLabel = ns.OptionsRowLabel(L["ARROW_SIZE"], 13, nil, ArrowHidden, L["ARROW_SIZE_DESCRIPTION"]),
			arrowScale = ns.OptionsRoutesControl("arrowScale", {
				type = "range",
				desc = L["ARROW_SIZE_DESCRIPTION"],
				min = 0.5,
				max = 2,
				step = 0.05,
				isPercent = true,
			}, 14, ArrowHidden),
			spaceCycle = ns.OptionsSpacer(14.05, ArrowHidden),
			cycleLabel = ns.OptionsRowLabel(L["ARROW_CYCLE"], 14.1, nil, ArrowHidden, L["ARROW_CYCLE_DESCRIPTION"]),
			cycleSeconds = ns.OptionsRoutesControl("cycleSeconds", {
				type = "range",
				desc = L["ARROW_CYCLE_DESCRIPTION"],
				min = 4,
				max = 30,
				step = 1,
			}, 14.2, ArrowHidden),
			spaceLock = ns.OptionsSpacer(15, ArrowHidden),
			lockArrow = Toggle("lockArrow", "LOCK_ARROW", 16, ArrowHidden),
			spaceReset = ns.OptionsSpacer(16.5, ArrowHidden),
			resetArrowLabel = ns.OptionsRowLabel(L["RESET_ARROW"], 17, nil, ArrowHidden, L["RESET_ARROW_DESCRIPTION"]),
			resetArrow = ns.OptionsRoutesControl("questsListed", {
				type = "execute",
				name = L["RESET_ARROW_BUTTON"],
				desc = L["RESET_ARROW_DESCRIPTION"],
				func = function()
					ns.routes.ResetArrowPosition()
				end,
			}, 18, ArrowHidden),

			spaceText0 = ns.OptionsSpacer(20, ArrowHidden),
			headerText = ns.OptionsHeader(L["QUEST_ARROW_TEXT_HEADER"], 21, ArrowHidden),
			spaceText1 = ns.OptionsSpacer(22, ArrowHidden),
			showDistance = ShowDistanceToggle(),
			spaceShowQuests = ns.OptionsSpacer(23.5, ArrowHidden),
			showQuests = Toggle("showQuests", "SHOW_ARROW_QUESTS", 24, ArrowHidden),
			spaceQuestsListed = ns.OptionsSpacer(24.5, QuestsHidden),
			questsListedLabel = ns.OptionsRowLabel(L["QUESTS_LISTED"], 25, nil, QuestsHidden, QUESTS_LISTED_TEXT),
			questsListed = ns.OptionsRoutesControl(nil, {
				type = "range",
				desc = QUESTS_LISTED_TEXT,
				min = 1,
				max = 8,
				step = 1,
			}, 26, QuestsHidden),

			spaceHiding0 = ns.OptionsSpacer(30, ArrowHidden),
			headerHiding = ns.OptionsHeader(L["QUEST_ARROW_HIDING_HEADER"], 31, ArrowHidden),
			spaceHiding1 = ns.OptionsSpacer(32, ArrowHidden),
			hideInRaids = Toggle("hideInRaids", "HIDE_IN_RAIDS", 33, ArrowHidden),
			spaceHideInInstances = ns.OptionsSpacer(33.5, ArrowHidden),
			hideInInstances = Toggle("hideInInstances", "HIDE_IN_INSTANCES", 34, ArrowHidden),
		},
	}
end
