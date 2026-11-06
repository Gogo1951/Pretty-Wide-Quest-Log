local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

-- The Features switches, two to a line
local FEATURE_WIDTH = ns.OPTIONS_ROW_WIDTH / 2

-- Under the Features switches while the Quest Log switch waits for its reload, as on the Quest Log panel
local function QuestLogReloadPending()
	if ns.IsQuestLogReloadPending() then
		return L["FEATURE_QUEST_LOG_RELOAD_PENDING"]
	end
end

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

local function AddCommands(args, order)
	args.spaceCommands0 = ns.OptionsSpacer(order)
	args.headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], order + 1)
	args.spaceCommands1 = ns.OptionsSpacer(order + 2)
	args.descCommands = ns.OptionsDesc(
		GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
		order + 3
	)
end

function ns.BuildGeneralOptions()
	local args = {
		addonDescription = ns.OptionsDesc(L["OPTIONS_DESCRIPTION"], 1),
		spaceWelcome0 = ns.OptionsSpacer(2),
		showWelcome = {
			type = "toggle",
			name = L["ENABLE_WELCOME_MESSAGE"],
			desc = L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"],
			width = "full",
			order = 3,
			get = function()
				return ns.db.profile.showWelcome
			end,
			set = function(_, value)
				ns.db.profile.showWelcome = value
			end,
		},

		spaceFeatures0 = ns.OptionsSpacer(10),
		headerFeatures = ns.OptionsHeader(L["OPTIONS_FEATURES_HEADER"], 11),
		spaceFeatures1 = ns.OptionsSpacer(12),
		-- Each is also at the top of its own panel. The Quest Log's takes effect at the next /reload, which the Options window offers on close (below)
		enableWideQuestLog = ns.OptionsFeatureToggle(
			"enableWideQuestLog",
			"ENABLE_WIDE_QUEST_LOG",
			"FEATURE_QUEST_LOG_DESCRIPTION",
			13,
			FEATURE_WIDTH
		),
		enableQualityOfLife = ns.OptionsFeatureToggle(
			"enableQualityOfLife",
			"ENABLE_QUALITY_OF_LIFE",
			"FEATURE_QUALITY_OF_LIFE_SUMMARY",
			14,
			FEATURE_WIDTH,
			ns.ApplyQuestGiverCleanup
		),
		enableRoutesMap = ns.OptionsRoutesToggle(
			"showMap",
			"ENABLE_ROUTES_MAP",
			"FEATURE_ROUTES_MAP_DESCRIPTION",
			15,
			FEATURE_WIDTH
		),
		enableQuestArrow = ns.OptionsRoutesToggle(
			"showArrow",
			"ENABLE_QUEST_ARROW",
			"FEATURE_QUEST_ARROW_DESCRIPTION",
			16,
			FEATURE_WIDTH
		),
		questLogReloadPending = ns.OptionsStatusLine(QuestLogReloadPending, 17),
	}

	AddCommands(args, 100)

	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = args,
	}
end
