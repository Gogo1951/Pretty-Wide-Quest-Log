local _, ns = ...
local L = ns.L

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

--------------------------------------------------------------------------------
-- Panels Under a Panel
--------------------------------------------------------------------------------

--[[
	AceConfigDialog:AddToBlizOptions finds a parent by Settings.GetCategory, which finds only the
	categories on the AddOns list itself, so it can hang a panel under the add-on's but not under one of
	its panels. This registers a panel under any category object, and returns its frame and category:
	the same Blizzard options group AceConfigDialog makes, filled from the options table as it shows and
	emptied the frame after it hides, and kept in AceConfigDialog's own list of them, so NotifyChange
	refreshes it as it does the others
]]
local function AddPanel(appName, name, parentCategory)
	local group = AceGUI:Create("BlizOptionsGroup")
	group:SetTitle(name)
	group:SetUserData("appName", appName)
	group:SetCallback("OnShow", function(widget)
		AceConfigDialog:Open(appName, widget)
	end)
	group:SetCallback("OnHide", function(widget)
		C_Timer.After(0, function()
			if not widget.frame:IsVisible() then
				widget:ReleaseChildren()
			end
		end)
	end)
	local category = Settings.RegisterCanvasLayoutSubcategory(parentCategory, group.frame, name)
	group:SetName(category.ID, parentCategory.ID)
	-- Listed in AceConfigDialog's own list of its groups, so NotifyChange refreshes it
	AceConfigDialog.BlizOptions[appName] = AceConfigDialog.BlizOptions[appName] or {}
	AceConfigDialog.BlizOptions[appName][appName] = group
	return group.frame, category
end

--[[
	A panel under parentCategory, or, on a client without the Settings panel's subcategories, under the
	add-on's own panel as AceConfigDialog would hang it, so the panel is always there to open
]]
local function AddPanelUnder(appName, name, parentCategory)
	if type(parentCategory) == "table" and Settings and Settings.RegisterCanvasLayoutSubcategory then
		return AddPanel(appName, name, parentCategory)
	end
	return AceConfigDialog:AddToBlizOptions(appName, name, L["ADDON_TITLE"])
end

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

-- Called from Core once AceDB:New has run, before any feature sets up, since the Profiles builder reads ns.db.
function ns.RegisterOptionsPanels()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions)

	--[[
		AddToBlizOptions returns (frame, categoryID), and the category ID is the only dependable way
		back to this panel: on clients where it's a number assigned at registration, a lookup by
		title finds nothing and the panel opens as a floating window instead.
	]]
	local mainPanel, mainCategoryID = AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])
	ns.optionsFrames = { main = mainPanel, categoryID = mainCategoryID }

	--[[
		Wide Quest Log, with its Quest List, Quest Details, Window & Map and NPC Dialogue panels under it.
		It's registered here rather than by AceConfigDialog, for its category to hang them from
	]]
	local mainCategory = Settings and Settings.GetCategory and Settings.GetCategory(mainCategoryID)
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QuestLog, ns.BuildQuestLogOptions)
	local questLogPanel, questLogCategory =
		AddPanelUnder(ns.OPTIONS_REGISTRY.QuestLog, L["TAB_WIDE_QUEST_LOG"], mainCategory)
	if type(questLogCategory) ~= "table" then
		questLogCategory = nil -- Hung by AceConfigDialog, which returns the category's ID, not the category
	end
	local subPanels = {}
	for _, panel in ipairs({
		{ ns.OPTIONS_REGISTRY.QuestList, ns.BuildQuestListOptions, L["TAB_QUEST_LIST"] },
		{ ns.OPTIONS_REGISTRY.QuestDetails, ns.BuildQuestDetailsOptions, L["TAB_QUEST_DETAILS"] },
		{ ns.OPTIONS_REGISTRY.WindowMap, ns.BuildWindowMapOptions, L["TAB_WINDOW_MAP"] },
		{ ns.OPTIONS_REGISTRY.NPCDialogue, ns.BuildNPCDialogueOptions, L["TAB_NPC_DIALOGUE"] },
	}) do
		local appName, build, name = unpack(panel)
		AceConfig:RegisterOptionsTable(appName, build)
		subPanels[#subPanels + 1] = (AddPanelUnder(appName, name, questLogCategory))
	end

	--[[
		Maps & Objectives, with the Waypoint Markers switch and a panel for each kind of map under it, right
		under Wide Quest Log, where Routes is loaded. The game lists panels in the order they're registered
	]]
	local mapPanels = {}
	if ns.routes then
		AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.MapsObjectives, ns.BuildMapsObjectivesOptions)
		local mapsPanel, mapsCategory =
			AddPanelUnder(ns.OPTIONS_REGISTRY.MapsObjectives, L["TAB_MAPS_OBJECTIVES"], mainCategory)
		if type(mapsCategory) ~= "table" then
			mapsCategory = nil -- Hung by AceConfigDialog, which returns the category's ID, not the category
		end
		mapPanels[1] = mapsPanel
		for _, panel in ipairs({
			{ ns.OPTIONS_REGISTRY.Minimap, ns.BuildMinimapOptions, L["TAB_MINIMAP"] },
			{ ns.OPTIONS_REGISTRY.ZoneMap, ns.BuildZoneMapOptions, L["TAB_ZONE_MAP"] },
			{ ns.OPTIONS_REGISTRY.WideMap, ns.BuildWideMapOptions, L["TAB_WIDE_MAP"] },
		}) do
			local appName, build, name = unpack(panel)
			AceConfig:RegisterOptionsTable(appName, build)
			mapPanels[#mapPanels + 1] = (AddPanelUnder(appName, name, mapsCategory))
		end
	end

	-- Quest Route and Quest Arrow after Maps & Objectives, where Routes is loaded, then Quality of Life
	local questRoutePanel, questArrowPanel
	if ns.routes then
		AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QuestRoute, ns.BuildQuestRouteOptions)
		questRoutePanel =
			AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.QuestRoute, L["TAB_QUEST_ROUTE"], L["ADDON_TITLE"])
		AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QuestArrow, ns.BuildQuestArrowOptions)
		questArrowPanel =
			AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.QuestArrow, L["TAB_QUEST_ARROW"], L["ADDON_TITLE"])
	end

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QualityOfLife, ns.BuildQualityOfLifeOptions)
	local qualityOfLifePanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.QualityOfLife, L["TAB_QUALITY_OF_LIFE"], L["ADDON_TITLE"])

	local profilesOptions = ns.BuildProfilesOptions()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	local profilesPanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, L["ADDON_TITLE"])

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.FeedbackSupport, ns.BuildFeedbackSupportOptions)
	local feedbackSupportPanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.FeedbackSupport, L["OPTIONS_FEEDBACK"], L["ADDON_TITLE"])

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions)
	local diagnosticsPanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, ns.DiagnosticsStrings.TAB, L["ADDON_TITLE"])

	-- The Quest Log switch's reload prompt (Options-General.lua), over the panels this client registered
	local watched = {}
	for _, panel in ipairs({
		mainPanel,
		questLogPanel,
		subPanels[1] or false,
		subPanels[2] or false,
		subPanels[3] or false,
		subPanels[4] or false,
		mapPanels[1] or false,
		mapPanels[2] or false,
		mapPanels[3] or false,
		mapPanels[4] or false,
		questRoutePanel or false,
		questArrowPanel or false,
		qualityOfLifePanel,
		profilesPanel,
		feedbackSupportPanel,
		diagnosticsPanel,
	}) do
		if panel then
			watched[#watched + 1] = panel
		end
	end
	ns.WatchOptionsForReload(watched)
end

--------------------------------------------------------------------------------
-- Opening the Panel
--------------------------------------------------------------------------------

function ns:OpenOptionsPanel()
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_OPTIONS_IN_COMBAT"])
		return
	end
	if not ns.optionsFrames then
		return
	end
	if Settings and Settings.OpenToCategory and ns.optionsFrames.categoryID then
		Settings.OpenToCategory(ns.optionsFrames.categoryID)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

SLASH_PRETTYWIDEQUESTLOGOPTIONS1 = "/pwql"
SlashCmdList.PRETTYWIDEQUESTLOGOPTIONS = function()
	ns:OpenOptionsPanel()
end
