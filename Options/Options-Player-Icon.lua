local _, ns = ...
local L = ns.L

--[[
	The Player Icon on Maps panel of the Options Interface, which Options.lua registers after Quest Arrow, in
	the Features section's order. Its settings are on the profile and take effect at once
	(ns.ApplyPlayerIcon, Player-Map-Pin.lua); each control hides while the switch at the top of it is off
]]

local function IconHidden()
	return not ns.db.profile.enablePlayerIcon
end

--------------------------------------------------------------------------------
-- Player Icon on Maps Panel
--------------------------------------------------------------------------------

function ns.BuildPlayerIconOptions()
	return {
		type = "group",
		name = L["TAB_PLAYER_ICON"],
		args = {
			descIntro = ns.OptionsDesc(L["TAB_PLAYER_ICON_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			enablePlayerIcon = ns.OptionsFeatureToggle(
				"enablePlayerIcon",
				"ENABLE_PLAYER_ICON",
				"FEATURE_PLAYER_ICON_DESCRIPTION",
				3,
				nil,
				ns.ApplyPlayerIcon
			),

			spaceIcon0 = ns.OptionsSpacer(10, IconHidden),
			headerIcon = ns.OptionsHeader(L["PLAYER_ICON_HEADER"], 11, IconHidden),
			spaceIcon1 = ns.OptionsSpacer(12, IconHidden),
			descIcon = ns.OptionsDesc(L["PLAYER_ICON_DESCRIPTION"], 12.1, IconHidden),
			spaceIcon2 = ns.OptionsSpacer(12.2, IconHidden),
			-- Times the arrow's 32 pixels and the discs' 16 (Player-Map-Pin.lua)
			iconScaleLabel = ns.OptionsRowLabel(
				L["PLAYER_ICON_SIZE"],
				13,
				nil,
				IconHidden,
				L["PLAYER_ICON_SIZE_DESCRIPTION"]
			),
			iconScale = {
				type = "select",
				name = "",
				desc = L["PLAYER_ICON_SIZE_DESCRIPTION"],
				values = ns.OptionsSizeValues,
				sorting = ns.OPTIONS_SIZE_ORDER,
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 14,
				hidden = IconHidden,
				get = function()
					return ns.db.profile.playerIconScale
				end,
				set = function(_, value)
					ns.db.profile.playerIconScale = value
					ns.ApplyPlayerIcon()
				end,
			},
		},
	}
end
