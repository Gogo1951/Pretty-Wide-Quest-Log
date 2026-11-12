local _, ns = ...
local L = ns.L

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Opening Key Bindings
--------------------------------------------------------------------------------

--[[
	The General panel's Set Key button. The clients disagree on how the game's Key Bindings list is reached,
	so the routes are tried in order at click time, since a Settings category can register after login: the
	category the client names outright, then the Settings panel's category carrying the game's Key Bindings
	title, then the older KeyBindingFrame, loaded on demand. When none works, a line says where to look
]]
local function FindKeyBindingsCategoryID()
	if Settings and Settings.KEYBINDINGS_CATEGORY_ID then
		return Settings.KEYBINDINGS_CATEGORY_ID
	end
	if not (SettingsPanel and SettingsPanel.GetCategoryList) then
		return nil
	end
	local list = SettingsPanel:GetCategoryList()
	local categories = list and list.GetAllCategories and list:GetAllCategories()
	for _, category in ipairs(categories or {}) do
		local name = category.GetName and category:GetName()
		if name and (name == KEY_BINDINGS or name == SETTINGS_KEYBINDINGS_LABEL) and category.GetID then
			return category:GetID()
		end
	end
end

-- The fallback line names the menus by the client's own labels, so it matches what the player sees
local KEY_BINDINGS_LABEL = SETTINGS_KEYBINDINGS_LABEL ~= nil and SETTINGS_KEYBINDINGS_LABEL or KEY_BINDINGS

function ns:OpenKeyBindings()
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_KEY_BINDINGS_IN_COMBAT"])
		return
	end
	local categoryID = FindKeyBindingsCategoryID()
	if categoryID and Settings and Settings.OpenToCategory then
		Settings.OpenToCategory(categoryID)
		return
	end
	if not KeyBindingFrame and type(KeyBindingFrame_LoadUI) == "function" then
		KeyBindingFrame_LoadUI()
	end
	if type(KeyBindingFrame) == "table" then
		ShowUIPanel(KeyBindingFrame)
		return
	end
	ns:PrintMessage(L["KEY_BINDINGS_LOCATION"]:format(GAMEMENU_OPTIONS, KEY_BINDINGS_LABEL))
end

--[[
	Core's EVENTS (owner "keyBindings"): the General panel shows each binding's key, and the player changes
	it in the game's own list, so the panel repaints when they come back from it
]]
ns.keyBindings = {}

function ns.keyBindings:OnUpdateBindings()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
end
