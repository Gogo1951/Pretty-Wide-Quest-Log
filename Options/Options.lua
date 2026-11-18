local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
	A sub-panel: listed in the tree by its own name, under its parent, with a page title naming the parent too.
	Returns its frame
]]
local function RegisterSubPanel(key, builder, parentKey, parentNameKey, nameKey)
	local frame = Kit.RegisterPanel(key, builder, L[nameKey], parentKey)
	if frame and frame.obj and frame.obj.SetTitle then
		frame.obj:SetTitle(Kit.SubPanelTitle(L[parentNameKey], L[nameKey]))
	end
	return frame
end

-- Called from Core once AceDB:New has run, before any feature sets up, since the Profiles builder reads ns.db.
function ns.RegisterOptionsPanels()
	local frames = {}
	local function Keep(frame)
		frames[#frames + 1] = frame
	end

	Keep(Kit.RegisterPanel("General", ns.BuildGeneralOptions, L["ADDON_TITLE"]))

	-- Wide Quest Log, with its Quest List, Quest Details, Window & Map and NPC Dialogue panels under it
	Keep(Kit.RegisterPanel("QuestLog", ns.BuildQuestLogOptions, L["TAB_WIDE_QUEST_LOG"]))
	for _, panel in ipairs({
		{ "QuestList", ns.BuildQuestListOptions, "TAB_QUEST_LIST" },
		{ "QuestDetails", ns.BuildQuestDetailsOptions, "TAB_QUEST_DETAILS" },
		{ "WindowMap", ns.BuildWindowMapOptions, "TAB_WINDOW_MAP" },
		{ "NPCDialogue", ns.BuildNPCDialogueOptions, "TAB_NPC_DIALOGUE" },
	}) do
		Keep(RegisterSubPanel(panel[1], panel[2], "QuestLog", "TAB_WIDE_QUEST_LOG", panel[3]))
	end

	--[[
		Maps & Objectives, with a panel for each kind of map under it, then Quest Route and Quest Arrow, where
		Routes is loaded. The game lists panels in the order they're registered
	]]
	if ns.routes then
		Keep(Kit.RegisterPanel("MapsObjectives", ns.BuildMapsObjectivesOptions, L["TAB_MAPS_OBJECTIVES"]))
		for _, panel in ipairs({
			{ "Minimap", ns.BuildMinimapOptions, "TAB_MINIMAP" },
			{ "ZoneMap", ns.BuildZoneMapOptions, "TAB_ZONE_MAP" },
			{ "WideMap", ns.BuildWideMapOptions, "TAB_WIDE_MAP" },
		}) do
			Keep(RegisterSubPanel(panel[1], panel[2], "MapsObjectives", "TAB_MAPS_OBJECTIVES", panel[3]))
		end
		Keep(Kit.RegisterPanel("QuestRoute", ns.BuildQuestRouteOptions, L["TAB_QUEST_ROUTE"]))
		Keep(Kit.RegisterPanel("QuestArrow", ns.BuildQuestArrowOptions, L["TAB_QUEST_ARROW"]))
	end

	Keep(Kit.RegisterPanel("QualityOfLife", ns.BuildQualityOfLifeOptions, L["TAB_QUALITY_OF_LIFE"]))

	Keep(Kit.RegisterPanel("Profiles", ns.BuildProfilesOptions, ns.BuildProfilesOptions().name))
	Keep(Kit.RegisterPanel("FeedbackSupport", ns.BuildFeedbackSupportOptions, L["OPTIONS_FEEDBACK"]))
	Keep(Kit.RegisterPanel("Diagnostics", ns.BuildDiagnosticsOptions, ns.DiagnosticsStrings.TAB))

	-- The Quest Log switch's reload prompt (Options-Utilities.lua), over every panel
	ns.WatchOptionsForReload(frames)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

SLASH_PRETTYWIDEQUESTLOGOPTIONS1 = "/pwql"
SlashCmdList.PRETTYWIDEQUESTLOGOPTIONS = function()
	ns:OpenOptionsPanel()
end
