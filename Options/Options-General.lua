local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local Kit = ns.OptionsKit

-- A key binding row: its caption in the label column, the bound key, and Set Key, filling the row
local KEY_STATUS_WIDTH = 0.75
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
	Kit.Section(args, "KeyBindings", order, L["OPTIONS_KEY_BINDINGS_HEADER"])
	args.rowKeyBinding = Kit.Row(order + 1, nil, {
		Kit.Label(GetColor("INFO") .. L["BINDING_USE_QUEST_ITEM"] .. "|r"),
		{
			type = "description",
			name = function()
				return BindingStatus(command)
			end,
			fontSize = "medium",
			width = KEY_STATUS_WIDTH,
		},
		{
			type = "execute",
			name = L["OPTIONS_KEY_SET"],
			desc = L["OPTIONS_KEY_SET_DESCRIPTION"],
			width = KEY_BUTTON_WIDTH,
			func = function()
				ns:OpenKeyBindings()
			end,
		},
	})
	args.descKeyBinding =
		Kit.Desc(GetColor("HELP") .. L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] .. "|r", order + 2)
end

local function AddCommands(args, order)
	Kit.Section(args, "Commands", order, L["OPTIONS_COMMANDS_HEADER"])
	args.descCommands = Kit.Desc(
		GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
		order + 1
	)
end

function ns.BuildGeneralOptions()
	local args = {
		addonDescription = Kit.Desc(L["OPTIONS_DESCRIPTION"], 1),
		spaceWelcome0 = Kit.Spacer(2),
		showWelcome = {
			type = "toggle",
			name = L["ENABLE_WELCOME_MESSAGE"],
			desc = L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"],
			width = "full",
			order = 3,
			get = Kit.Get("profile", "showWelcome"),
			set = Kit.Set("profile", "showWelcome"),
		},
		-- Each is also at the top of its own panel
		features = ns.FeatureSwitches(11),
	}
	Kit.Section(args, "Features", 10, L["OPTIONS_FEATURES_HEADER"])

	AddKeyBindings(args, 80)
	AddCommands(args, 100)

	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = args,
	}
end
