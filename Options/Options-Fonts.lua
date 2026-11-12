local _, ns = ...
local L = ns.L

--[[
	The Font section at the foot of each Wide Quest Log panel, one text area's settings (Fonts.lua): the
	font, its size against the game's, the outline, the shadow and Blizzard's Slug renderer, with a button
	putting them back. Each change shows at once (ns.ApplyFontSettings)
]]

-- Reset Font, a quarter wider than a standard button for the longer locales, right-aligned
local RESET_WIDTH = 1.25
local RESET_INDENT_WIDTH = ns.OPTIONS_ROW_WIDTH - RESET_WIDTH

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
	section; disabled grays out its controls, and note, a function, gives the silver line under its
	description saying why
]]
function ns.AddFontOptions(args, area, order, hidden, disabled, note)
	local function Get(key)
		return ns.FontSettings(area)[key]
	end
	local function Set(key, value)
		ns.db.profile.fonts[area][key] = value
		ns.ApplyFontSettings()
	end

	args.spaceFont0 = ns.OptionsSpacer(order, hidden)
	args.headerFont = ns.OptionsHeader(L["FONT_HEADER"], order + 1, hidden)
	args.spaceFont1 = ns.OptionsSpacer(order + 2, hidden)
	args.descFont = ns.OptionsDesc(L["FONT_" .. area:upper() .. "_DESCRIPTION"], order + 3, hidden)
	if note then
		args.noteFont = ns.OptionsStatusLine(function()
			return (not (hidden and hidden())) and note() or nil
		end, order + 3.5)
	end
	args.spaceFont2 = ns.OptionsSpacer(order + 4, hidden)

	args.fontFaceLabel = ns.OptionsRowLabel(L["FONT_FACE"], order + 5, nil, hidden, L["FONT_FACE_DESCRIPTION"])
	args.fontFace = {
		type = "select",
		name = "",
		desc = L["FONT_FACE_DESCRIPTION"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = order + 6,
		hidden = hidden,
		disabled = disabled,
		values = function()
			return (ns.FontChoices(Get("face")))
		end,
		sorting = function()
			local _, sorting = ns.FontChoices(Get("face"))
			return sorting
		end,
		get = function()
			return Get("face")
		end,
		set = function(_, value)
			Set("face", value)
		end,
	}

	args.spaceFontSize = ns.OptionsSpacer(order + 7, hidden)
	args.fontSizeLabel = ns.OptionsRowLabel(L["FONT_SIZE"], order + 8, nil, hidden, L["FONT_SIZE_DESCRIPTION"])
	args.fontSize = {
		type = "range",
		name = "",
		desc = L["FONT_SIZE_DESCRIPTION"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = order + 9,
		hidden = hidden,
		disabled = disabled,
		min = ns.FONT_SIZE_MIN,
		max = ns.FONT_SIZE_MAX,
		step = 1,
		get = function()
			return Get("size")
		end,
		set = function(_, value)
			Set("size", value)
		end,
	}

	args.spaceFontOutline = ns.OptionsSpacer(order + 10, hidden)
	args.fontOutlineLabel =
		ns.OptionsRowLabel(L["FONT_OUTLINE"], order + 11, nil, hidden, L["FONT_OUTLINE_DESCRIPTION"])
	args.fontOutline = {
		type = "select",
		name = "",
		desc = L["FONT_OUTLINE_DESCRIPTION"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = order + 12,
		hidden = hidden,
		disabled = disabled,
		values = OutlineValues,
		sorting = ns.FONT_OUTLINES,
		get = function()
			return Get("outline")
		end,
		set = function(_, value)
			Set("outline", value)
		end,
	}

	args.spaceFontShadow = ns.OptionsSpacer(order + 13, hidden)
	args.fontShadow = {
		type = "toggle",
		name = L["FONT_SHADOW"],
		desc = L["FONT_SHADOW_DESCRIPTION"],
		width = "full",
		order = order + 14,
		hidden = hidden,
		disabled = disabled,
		get = function()
			return Get("shadow")
		end,
		set = function(_, value)
			Set("shadow", value)
		end,
	}
	args.spaceFontSlug = ns.OptionsSpacer(order + 15, hidden)
	args.fontSlug = {
		type = "toggle",
		name = L["FONT_SLUG"],
		desc = L["FONT_SLUG_DESCRIPTION"],
		width = "full",
		order = order + 16,
		hidden = hidden,
		disabled = disabled,
		get = function()
			return Get("slug")
		end,
		set = function(_, value)
			Set("slug", value)
		end,
	}

	args.spaceFontReset = ns.OptionsSpacer(order + 17, hidden)
	args.fontResetIndent = ns.OptionsRowLabel(" ", order + 18, RESET_INDENT_WIDTH, hidden)
	args.fontReset = {
		type = "execute",
		name = L["FONT_RESET_BUTTON"],
		desc = L["FONT_RESET_DESCRIPTION"],
		width = RESET_WIDTH,
		order = order + 19,
		hidden = hidden,
		disabled = disabled,
		func = function()
			local settings = ns.db.profile.fonts[area]
			for key, value in pairs(ns.DATABASE_DEFAULTS.profile.fonts[area]) do
				settings[key] = value -- AceDB leaves a default out of the saved file
			end
			ns.ApplyFontSettings()
		end,
	}
end
