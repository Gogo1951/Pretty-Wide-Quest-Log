local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Standard Helpers
--------------------------------------------------------------------------------

function ns.OptionsHeader(text, order, hidden)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = hidden }
end

function ns.OptionsDesc(text, order, hidden)
	return { type = "description", name = text, fontSize = "medium", order = order, hidden = hidden }
end

function ns.OptionsSpacer(order, hidden)
	return { type = "description", name = " ", order = order, hidden = hidden }
end

--[[
	A row's caption on the left of its control. Given desc, the caption shows the same tooltip as its
	control, titled with the caption: AceConfig wires every row to its tooltip, and InteractiveLabel is the
	label that takes the mouse
]]
function ns.OptionsRowLabel(text, order, width, hidden, desc)
	return {
		type = "description",
		name = text,
		desc = desc,
		dialogControl = desc and "InteractiveLabel" or nil,
		fontSize = "medium",
		width = width or ns.OPTIONS_LABEL_WIDTH,
		order = order,
		hidden = hidden,
	}
end

--[[
	A feature's on/off switch, the same widget on the root panel's Features section and at the top of the
	feature's own panel
]]
function ns.OptionsFeatureToggle(key, nameKey, descKey, order, width, onSet)
	return {
		type = "toggle",
		name = ns.L[nameKey],
		desc = ns.L[descKey],
		width = width or "full",
		order = order,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			if onSet then
				onSet(value)
			end
		end,
	}
end

--[[
	A Routes setting's switch. Routes is one line to leave out of the TOC (Features/Routes), so the switch
	hides without it. hidden, if given, hides it too
]]
function ns.OptionsRoutesToggle(key, nameKey, descKey, order, width, hidden)
	return {
		type = "toggle",
		name = ns.L[nameKey],
		desc = ns.L[descKey],
		width = width or "full",
		order = order,
		hidden = function()
			return ns.routes == nil or (hidden ~= nil and hidden())
		end,
		get = function()
			return ns.routes.Settings()[key]
		end,
		set = function(_, value)
			ns.routes.SetSetting(key, value)
		end,
	}
end

--[[
	A control on the right of a row for a Routes setting (key; nil for a button), its caption on its own row
	label to the left, as the other panels lay out sliders and choices. hidden hides it
]]
function ns.OptionsRoutesControl(key, control, order, hidden)
	control.name = control.name or ""
	control.width = ns.OPTIONS_CONTROL_WIDTH
	control.order = order
	control.hidden = hidden
	if key then
		control.get = function()
			return ns.routes.Settings()[key]
		end
		control.set = function(_, value)
			ns.routes.SetSetting(key, value)
		end
	end
	return control
end

--[[
	Whether the Quest Log switch asks for the other quest log than this session runs: it applies only as the
	saved settings load (Core.lua), so it waits for a reload. A client with no wide quest log yet has none to wait for
]]
function ns.IsQuestLogReloadPending()
	return ns.hasWideQuestLog == true and (ns.db.profile.enableWideQuestLog and true or false) ~= ns.wideQuestLogActive
end

-- A silver line shown only while getText returns something
function ns.OptionsStatusLine(getText, order)
	return {
		type = "description",
		name = function()
			local text = getText()
			return text and (GetColor("HELP") .. text .. "|r") or ""
		end,
		fontSize = "medium",
		order = order,
		hidden = function()
			return getText() == nil
		end,
	}
end

-- A sub-option's caption, in silver (Build Reference → Sub-Option Rows)
function ns.OptionsSubLabel(text)
	return GetColor("HELP") .. text .. "|r"
end

--[[
	A sub-option: an indented control on a line of its own, in an unnamed inline group (Build Reference →
	Sub-Option Rows). hidden goes on the group, so the indent collapses with it
]]
function ns.OptionsSubRow(order, hidden, controls)
	local args = {
		indent = { type = "description", name = " ", width = ns.OPTIONS_SUB_INDENT_WIDTH, order = 1 },
	}
	for key, control in pairs(controls) do
		args[key] = control
	end
	return { type = "group", name = "", inline = true, order = order, hidden = hidden, args = args }
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
