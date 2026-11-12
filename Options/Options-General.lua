local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

-- The Features switches, two to a line
local FEATURE_WIDTH = ns.OPTIONS_ROW_WIDTH / 2

-- A key binding row: its caption, the bound key, and Set Key
local KEY_LABEL_WIDTH = 1.9
local KEY_STATUS_WIDTH = 0.85
local KEY_BUTTON_WIDTH = 0.55

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

local function BindingStatus(command)
	local key = GetBindingKey(command)
	if not key then
		return GetColor("MUTED") .. NOT_BOUND .. "|r"
	end
	return GetColor("TEXT") .. GetBindingText(key) .. "|r"
end

--[[
	The Quest Arrow's Use Quest Item key, where Routes is loaded. A binding can't be set from an AceConfig
	panel, so the row shows the key and Set Key opens the game's list (ns:OpenKeyBindings, Key-Bindings.lua)
]]
local function AddKeyBindings(args, order)
	if not ns.routes then
		return
	end
	local command = ns.routes.USE_ITEM_COMMAND
	args.spaceKeyBindings0 = ns.OptionsSpacer(order)
	args.headerKeyBindings = ns.OptionsHeader(L["OPTIONS_KEY_BINDINGS_HEADER"], order + 1)
	args.spaceKeyBindings1 = ns.OptionsSpacer(order + 2)
	args.rowKeyBinding = {
		type = "group",
		name = "",
		inline = true,
		order = order + 3,
		args = {
			caption = ns.OptionsRowLabel(GetColor("INFO") .. L["BINDING_USE_QUEST_ITEM"] .. "|r", 1, KEY_LABEL_WIDTH),
			status = {
				type = "description",
				name = function()
					return BindingStatus(command)
				end,
				fontSize = "medium",
				width = KEY_STATUS_WIDTH,
				order = 2,
			},
			setKey = {
				type = "execute",
				name = L["OPTIONS_KEY_SET"],
				desc = L["OPTIONS_KEY_SET_DESCRIPTION"],
				width = KEY_BUTTON_WIDTH,
				order = 3,
				func = function()
					ns:OpenKeyBindings()
				end,
			},
		},
	}
	args.descKeyBinding =
		ns.OptionsDesc(GetColor("HELP") .. L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] .. "|r", order + 4)
end

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
		--[[
			Each is also at the top of its own panel. The Quest Log's takes effect at the next /reload, which
			the Options window offers on close (below)
		]]
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
			ns.ApplyQualityOfLifeSettings
		),
		enableWaypointMarkers = ns.OptionsRoutesToggle(
			"showMap",
			"ENABLE_WAYPOINT_MARKERS",
			"FEATURE_WAYPOINT_MARKERS_DESCRIPTION",
			15,
			FEATURE_WIDTH
		),
		enableQuestRoute = ns.OptionsQuestRouteToggle(16, FEATURE_WIDTH),
		enableQuestArrow = ns.OptionsRoutesToggle(
			"showArrow",
			"ENABLE_QUEST_ARROW",
			"FEATURE_QUEST_ARROW_DESCRIPTION",
			17,
			FEATURE_WIDTH
		),
		questLogReloadPending = ns.OptionsStatusLine(ns.QuestLogReloadPendingText, 19),
	}

	AddKeyBindings(args, 80)
	AddCommands(args, 100)

	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = args,
	}
end
