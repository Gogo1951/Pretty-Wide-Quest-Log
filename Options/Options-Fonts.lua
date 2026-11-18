local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

--[[
	The Font section at the foot of each Wide Quest Log panel, one text area's settings (Fonts.lua): the
	font, its size against the game's, the outline, the shadow and Blizzard's Slug renderer, with a Reset
	putting them back. Each change shows at once (ns.ApplyFontSettings)
]]

local OUTLINE_NAMES = {
	DEFAULT = "FONT_OUTLINE_DEFAULT",
	NONE = "FONT_OUTLINE_NONE",
	OUTLINE = "FONT_OUTLINE_THIN",
	THICKOUTLINE = "FONT_OUTLINE_THICK",
}

local function OutlineValues()
	local values = {}
	for value, nameKey in pairs(OUTLINE_NAMES) do
		values[value] = L[nameKey]
	end
	return values
end

--[[
	Adds the Font section for area to a panel's args from order up (it takes 20). hidden hides the whole
	section; disabled grays out its controls
]]
function ns.AddFontOptions(args, area, order, hidden, disabled)
	local function Get(key)
		return ns.FontSettings(area)[key]
	end
	local function Set(key, value)
		ns.db.profile.fonts[area][key] = value
		ns.ApplyFontSettings()
		ns.RefreshSettings()
	end
	local function Control(control, key)
		control.disabled = disabled
		control.get = function()
			return Get(key)
		end
		control.set = function(_, value)
			Set(key, value)
		end
		return control
	end

	args.spaceFont0 = Kit.Spacer(order, hidden)
	args.headerFont = Kit.Header(L["FONT_HEADER"], order + 1, hidden)
	args.spaceFont1 = Kit.Spacer(order + 2, hidden)
	args.descFont = Kit.Desc(L["FONT_" .. area:upper() .. "_DESCRIPTION"], order + 3, hidden)
	args.spaceFont2 = Kit.Spacer(order + 4, hidden)

	args.fontFace = Kit.LabelRow(
		order + 5,
		hidden,
		L["FONT_FACE"],
		Control({
			type = "select",
			desc = L["FONT_FACE_DESCRIPTION"],
			values = function()
				return (ns.FontChoices(Get("face")))
			end,
			sorting = function()
				local _, sorting = ns.FontChoices(Get("face"))
				return sorting
			end,
		}, "face")
	)

	args.spaceFontSize = Kit.Spacer(order + 7, hidden)
	args.fontSize = Kit.LabelRow(
		order + 8,
		hidden,
		L["FONT_SIZE"],
		Control({
			type = "range",
			desc = L["FONT_SIZE_DESCRIPTION"],
			min = ns.FONT_SIZE_MIN,
			max = ns.FONT_SIZE_MAX,
			step = 1,
		}, "size")
	)

	args.spaceFontOutline = Kit.Spacer(order + 10, hidden)
	args.fontOutline = Kit.LabelRow(
		order + 11,
		hidden,
		L["FONT_OUTLINE"],
		Control({
			type = "select",
			desc = L["FONT_OUTLINE_DESCRIPTION"],
			values = OutlineValues,
			sorting = ns.FONT_OUTLINES,
		}, "outline")
	)

	args.spaceFontShadow = Kit.Spacer(order + 13, hidden)
	args.fontShadow = Control({
		type = "toggle",
		name = L["FONT_SHADOW"],
		desc = L["FONT_SHADOW_DESCRIPTION"],
		width = "full",
		order = order + 14,
		hidden = hidden,
	}, "shadow")
	args.spaceFontSlug = Kit.Spacer(order + 15, hidden)
	args.fontSlug = Control({
		type = "toggle",
		name = L["FONT_SLUG"],
		desc = L["FONT_SLUG_DESCRIPTION"],
		width = "full",
		order = order + 16,
		hidden = hidden,
	}, "slug")

	-- Reset Font discards every setting in the section, so it asks first; gray while there's nothing to reset
	args.spaceFontReset = Kit.Spacer(order + 17, hidden)
	args.fontReset = Kit.ResetRow(order + 18, hidden, L["FONT_RESET"], L["FONT_RESET_DESCRIPTION"], function()
		if disabled and disabled() then
			return true
		end
		local settings = ns.FontSettings(area)
		for key, value in pairs(ns.DATABASE_DEFAULTS.profile.fonts[area]) do
			if settings[key] ~= value then
				return false
			end
		end
		return true
	end, function()
		local settings = ns.db.profile.fonts[area]
		for key, value in pairs(ns.DATABASE_DEFAULTS.profile.fonts[area]) do
			settings[key] = value -- AceDB leaves a default out of the saved file
		end
		ns.ApplyFontSettings()
	end, L["FONT_RESET_CONFIRM"])
end
