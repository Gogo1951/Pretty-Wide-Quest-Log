local _, ns = ...
local L = ns.L

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

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

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QuestLog, ns.BuildQuestLogOptions)
	local questLogPanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.QuestLog, L["TAB_WIDE_QUEST_LOG"], L["ADDON_TITLE"])

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QualityOfLife, ns.BuildQualityOfLifeOptions)
	local qualityOfLifePanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.QualityOfLife, L["TAB_QUALITY_OF_LIFE"], L["ADDON_TITLE"])

	-- Waypoint Markers, Quest Route and Quest Arrow, in the Features section's order, where Routes is loaded
	local waypointMarkersPanel, questRoutePanel, questArrowPanel
	if ns.routes then
		AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.WaypointMarkers, ns.BuildWaypointMarkersOptions)
		waypointMarkersPanel = AceConfigDialog:AddToBlizOptions(
			ns.OPTIONS_REGISTRY.WaypointMarkers,
			L["TAB_WAYPOINT_MARKERS"],
			L["ADDON_TITLE"]
		)
		AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QuestRoute, ns.BuildQuestRouteOptions)
		questRoutePanel =
			AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.QuestRoute, L["TAB_QUEST_ROUTE"], L["ADDON_TITLE"])
		AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.QuestArrow, ns.BuildQuestArrowOptions)
		questArrowPanel =
			AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.QuestArrow, L["TAB_QUEST_ARROW"], L["ADDON_TITLE"])
	end

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
		qualityOfLifePanel,
		waypointMarkersPanel or false,
		questRoutePanel or false,
		questArrowPanel or false,
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
