local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- WoW Forever Quest Log
--------------------------------------------------------------------------------

-- The Quest Log section of the General panel goes while the wide quest log is off
function ns.QuestLogOptionsHidden()
	return not ns.db.profile.enableWideQuestLog
end

-- Merged into the General panel under Enable Welcome Message; only the Camelot TOC loads this file.
function ns.BuildForeverQuestLogOptions()
	return {
		enableWideQuestLog = {
			type = "toggle",
			name = L["ENABLE_WIDE_QUEST_LOG"],
			desc = L["ENABLE_WIDE_QUEST_LOG_DESCRIPTION"],
			width = "full",
			order = 4,
			get = function()
				return ns.db.profile.enableWideQuestLog
			end,
			set = function(_, value)
				ns.db.profile.enableWideQuestLog = value
			end,
		},
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
	The quest log key is taken over only at load (Forever-Quest-Log.lua), so when the Options window
	closes with the profile asking for the other quest log, offer the reload that switches it. Comparing
	against the load-time state covers a profile switch too, and stays quiet after a toggle flipped back.

	The game's Options window may not exist yet when this file loads, so it is hooked the first time one
	of the add-on's panels shows inside it. Watching the window rather than the panels means the prompt
	still comes when the player has moved on to another category before closing.
]]
function ns.WatchOptionsForReload(panels)
	local hookedWindow
	local function PromptIfClosed()
		if ns.db.profile.enableWideQuestLog ~= (ns.questLogTakenOver == true) then
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
