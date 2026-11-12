local _, ns = ...
local L = ns.L

--[[
	Every client: the fonts of the add-on's text, set apart by area (ns.FONT_AREAS), each with its own
	font, size, outline, shadow and Slug settings (profile.fonts, the font sections of the Wide Quest Log
	panels). An area's text takes a font object of the add-on's own for each of Blizzard's it would use
	(ns.AreaFont): a copy of Blizzard's with the area's settings on top. Left at their defaults the copy
	matches Blizzard's but for Slug, which is on by default, so the text follows the game's fonts and any
	add-on (ElvUI, a font add-on) that changes them; a change to Blizzard's is copied again at once. A FontString on one of these takes a
	change of settings as it's made, with nothing to set up again; only what measures text lays out again
	(ns.ApplyFontSettings)
]]

--[[
	list: the quest list's rows. details: the quest log's details on the parchment. dialogue: the quest
	giver and gossip windows' text, while the quest giver window cleanup is on. window: the quest log
	window's own lines, its title, quest count and Turn-In line
]]
ns.FONT_AREAS = { "list", "details", "dialogue", "window" }

-- The outline choices, in the dropdown's order. DEFAULT keeps whatever outline Blizzard's font has
ns.FONT_OUTLINES = { "DEFAULT", "NONE", "OUTLINE", "THICKOUTLINE" }

-- How far the Size slider moves an area's text from the game's size, either way, and the smallest it ever draws
ns.FONT_SIZE_MIN, ns.FONT_SIZE_MAX = -4, 6
local SMALLEST_SIZE = 6

--------------------------------------------------------------------------------
-- Font Files
--------------------------------------------------------------------------------

-- SharedMedia, shipped with the add-on: its own fonts, Blizzard's among them, and every font other add-ons register with it
local SharedMedia = LibStub("LibSharedMedia-3.0")

--[[
	The game's fonts every client has, read from the globals each locale points at its own files, so a
	Korean, Chinese or Russian client gets fonts with its letters in them
]]
local GAME_FONTS = {
	{ key = "GAME_STANDARD", global = "STANDARD_TEXT_FONT", nameKey = "FONT_GAME_STANDARD" },
	{ key = "GAME_NAMES", global = "UNIT_NAME_FONT", nameKey = "FONT_GAME_NAMES" },
	{ key = "GAME_DAMAGE", global = "DAMAGE_TEXT_FONT", nameKey = "FONT_GAME_DAMAGE" },
}

--[[
	The file a saved font choice draws with: "" (the game's) gives nil, one of GAME_FONTS its global, and
	anything else a SharedMedia font by name. One SharedMedia doesn't have (the add-on that registered it
	is off, or hasn't loaded yet) gives nil too, so the text keeps the game's font until it's back
]]
local function FontFile(face)
	if not face or face == "" then
		return nil
	end
	for _, font in ipairs(GAME_FONTS) do
		if font.key == face then
			return _G[font.global]
		end
	end
	if SharedMedia:IsValid("font", face) then
		return SharedMedia:Fetch("font", face, true)
	end
end

--[[
	The Font dropdown's choices and their order: the game's own first, then SharedMedia's by name. A saved
	choice SharedMedia no longer has stays listed, so the dropdown never shows blank
]]
function ns.FontChoices(saved)
	local values, sorting = { [""] = L["FONT_GAME_DEFAULT"] }, { "" }
	for _, font in ipairs(GAME_FONTS) do
		values[font.key] = L[font.nameKey]
		sorting[#sorting + 1] = font.key
	end
	for _, name in ipairs(SharedMedia:List("font")) do
		if not values[name] then
			values[name] = name
			sorting[#sorting + 1] = name
		end
	end
	if saved and saved ~= "" and not values[saved] then
		values[saved] = saved
		sorting[#sorting + 1] = saved
	end
	return values, sorting
end

--------------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------------

-- An area's saved font settings, or nil before the saved settings load
function ns.FontSettings(area)
	local profile = ns.db and ns.db.profile
	return profile and profile.fonts and profile.fonts[area]
end

--[[
	The flags a font draws with: the outline the area asks for (or Blizzard's), Blizzard's MONOCHROME kept,
	and SLUG, Blizzard's sharper text renderer, while the area asks for it. Slug doesn't draw a thick
	outline, monochrome or a shadow, so it's left off any font with one of those rather than losing it
]]
local function Flags(blizzardFlags, settings, shadowed)
	blizzardFlags = (blizzardFlags or ""):upper()
	local outline = settings and settings.outline or "DEFAULT"
	if outline == "DEFAULT" then
		if blizzardFlags:find("THICK", 1, true) then
			outline = "THICKOUTLINE"
		elseif blizzardFlags:find("OUTLINE", 1, true) then
			outline = "OUTLINE"
		else
			outline = "NONE"
		end
	end
	local monochrome = blizzardFlags:find("MONOCHROME", 1, true) ~= nil
	local slug
	if settings then
		slug = settings.slug
	else
		slug = blizzardFlags:find("SLUG", 1, true) ~= nil
	end

	local flags = {}
	if outline ~= "NONE" then
		flags[#flags + 1] = outline
	end
	if monochrome then
		flags[#flags + 1] = "MONOCHROME"
	end
	if slug and outline ~= "THICKOUTLINE" and not monochrome and not shadowed then
		flags[#flags + 1] = "SLUG"
	end
	return table.concat(flags, ",")
end

-- Whether a font draws a shadow anyone would see
local function HasShadow(font)
	local x, y = font:GetShadowOffset()
	local _, _, _, alpha = font:GetShadowColor()
	return ((x or 0) ~= 0 or (y or 0) ~= 0) and (alpha or 0) > 0
end

--------------------------------------------------------------------------------
-- Area Fonts
--------------------------------------------------------------------------------

local areaFonts = {} -- [area][Blizzard's font object] = the area's copy
local copies = {} -- [an area's copy] = { blizzard = Blizzard's font object, area = area }
local followed = {} -- Blizzard's font objects whose changes are copied
local copyCount = 0

-- Copies Blizzard's font into an area's font object, with the area's settings on top
local function Sync(copy, blizzard, area)
	local file, size, flags = blizzard:GetFont()
	if not file or not size then
		return
	end
	copy:CopyFontObject(blizzard)
	local settings = ns.FontSettings(area)
	if settings then
		file = FontFile(settings.face) or file
		size = math.max(SMALLEST_SIZE, size + (settings.size or 0))
		if settings.shadow == false then
			copy:SetShadowOffset(0, 0)
			copy:SetShadowColor(0, 0, 0, 0)
		end
	end
	copy:SetFont(file, size, Flags(flags, settings, HasShadow(copy)))
end

local function SyncCopiesOf(blizzard)
	for area, fonts in pairs(areaFonts) do
		if fonts[blizzard] then
			Sync(fonts[blizzard], blizzard, area)
		end
	end
end

--[[
	A change to Blizzard's font object (a skin's, a font add-on's) is copied into every area's copy of it.
	Only Blizzard's object is hooked; the copies change only through Sync
]]
local FOLLOWED_METHODS = { "SetFont", "SetShadowColor", "SetShadowOffset" }

local function Follow(blizzard)
	if followed[blizzard] then
		return
	end
	followed[blizzard] = true
	for _, method in ipairs(FOLLOWED_METHODS) do
		if blizzard[method] then
			hooksecurefunc(blizzard, method, function()
				SyncCopiesOf(blizzard)
			end)
		end
	end
end

-- The Blizzard font object an area's copy stands in for, or the font object itself if it's no copy
function ns.FontBase(fontObject)
	local copy = fontObject and copies[fontObject]
	return copy and copy.blizzard or fontObject
end

--[[
	The area's copy of one of Blizzard's font objects (the object or its global name), made the first time
	it's asked for. Given a copy, it's the area's copy of the same Blizzard font. A font object with no font
	set yet has nothing to copy, so it comes back as it is
]]
function ns.AreaFont(area, blizzard)
	if type(blizzard) == "string" then
		blizzard = _G[blizzard]
	end
	if not blizzard then
		return nil
	end
	blizzard = ns.FontBase(blizzard)
	local fonts = areaFonts[area]
	if not fonts then
		fonts = {}
		areaFonts[area] = fonts
	end
	local copy = fonts[blizzard]
	if copy then
		return copy
	end
	if not blizzard:GetFont() then
		return blizzard
	end
	copyCount = copyCount + 1
	local areaName = area:gsub("^%l", string.upper)
	copy = CreateFont(("PrettyWideQuestLog%sFont%d"):format(areaName, copyCount))
	fonts[blizzard] = copy
	copies[copy] = { blizzard = blizzard, area = area }
	Follow(blizzard)
	Sync(copy, blizzard, area)
	return copy
end

--[[
	Sets a FontString to its area's copy of the font it has, keeping its color. blizzard, if given, is the
	Blizzard font object to copy instead, for one whose font was already changed
]]
function ns.SetAreaFont(region, area, blizzard)
	if not region then
		return
	end
	local copy = ns.AreaFont(area, blizzard or region:GetFontObject())
	if copy and region:GetFontObject() ~= copy then
		local red, green, blue, alpha = region:GetTextColor()
		region:SetFontObject(copy)
		region:SetTextColor(red, green, blue, alpha)
	end
end

-- A button's font getters and setters: its normal, highlight and disabled fonts
local BUTTON_FONT_METHODS = {
	{ "GetNormalFontObject", "SetNormalFontObject" },
	{ "GetHighlightFontObject", "SetHighlightFontObject" },
	{ "GetDisabledFontObject", "SetDisabledFontObject" },
}

-- A button's normal, highlight and disabled fonts as its area's copies
function ns.SetButtonAreaFonts(button, area)
	for _, methods in ipairs(BUTTON_FONT_METHODS) do
		local current = button[methods[1]](button)
		local copy = current and ns.AreaFont(area, current)
		if copy and copy ~= current then
			button[methods[2]](button, copy)
		end
	end
end

--------------------------------------------------------------------------------
-- Applying Settings
--------------------------------------------------------------------------------

-- Copies every area's fonts again from Blizzard's and the saved settings, as they load and when a profile changes
function ns.SyncFonts()
	for area, fonts in pairs(areaFonts) do
		for blizzard, copy in pairs(fonts) do
			Sync(copy, blizzard, area)
		end
	end
end

--[[
	After a font setting changes: the fonts first, then what measures its text lays out again, the quest
	log and the quest giver window. The text itself already shows the change
]]
function ns.ApplyFontSettings()
	ns.SyncFonts()
	if ns.wideQuestLogActive and ns.RefreshQuestLog then
		ns.RefreshQuestLog()
	end
	if ns.ApplyQuestGiverCleanup then
		ns.ApplyQuestGiverCleanup()
	end
end

-- Whether any area draws with a SharedMedia font by this name
local function FontInUse(name)
	for _, area in ipairs(ns.FONT_AREAS) do
		local settings = ns.FontSettings(area)
		if settings and settings.face == name then
			return true
		end
	end
	return false
end

--[[
	A SharedMedia font can be registered after the saved settings load (the add-on registering it loads
	later), and until then the text keeps the game's font. Once one in use turns up, the fonts are copied
	again
]]
SharedMedia.RegisterCallback(ns, "LibSharedMedia_Registered", function(_, mediaType, name)
	if mediaType == "font" and ns.db and FontInUse(name) then
		ns.ApplyFontSettings()
	end
end)
