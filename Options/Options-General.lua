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
			"FEATURE_QUALITY_OF_LIFE_DESCRIPTION",
			14,
			FEATURE_WIDTH,
			ns.ApplyQuestGiverCleanup
		),
		questLogReloadPending = ns.OptionsStatusLine(QuestLogReloadPending, 15),
	}

	AddCommands(args, 100)

	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = args,
	}
end

--------------------------------------------------------------------------------
-- Reload Prompt
--------------------------------------------------------------------------------

StaticPopupDialogs.PRETTYWIDEQUESTLOG_RELOAD = {
	text = L["RELOAD_PROMPT"],
	button1 = RELOADUI,
	button2 = CANCEL,
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

-- The topmost frame under UIParent holding the panel: the Options window, once the panel is shown in it
local function OptionsWindow(panel)
	local window = panel
	while window:GetParent() and window:GetParent() ~= UIParent do
		window = window:GetParent()
	end
	return window
end

--[[
	The Quest Log switch applies only as the saved settings load (Core.lua), so when the Options window
	closes with the profile asking for the other quest log, offer the reload that switches it. Comparing
	against this session's state covers a profile switch too, and stays quiet after a switch flipped back.

	The game's Options window may not exist yet when this file loads, so it is hooked the first time one
	of the add-on's panels shows inside it. Watching the window rather than the panels means the prompt
	still comes when the player has moved on to another category before closing.
]]
function ns.WatchOptionsForReload(panels)
	local hookedWindow
	local function PromptIfClosed()
		if ns.IsQuestLogReloadPending() then
			StaticPopup_Show("PRETTYWIDEQUESTLOG_RELOAD")
		end
	end
	for _, panel in ipairs(panels) do
		panel:HookScript("OnShow", function()
			local window = OptionsWindow(panel)
			if window ~= hookedWindow then
				hookedWindow = window
				window:HookScript("OnHide", function()
					C_Timer.After(0, PromptIfClosed)
				end)
			end
		end)
	end
end
