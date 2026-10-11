local _, ns = ...

local GetClientHeader = ns.GetDiagnosticClientHeader
local CountKeys = ns.CountDiagnosticKeys

local IS_FOREVER = ns.FLAVOR == "Camelot"

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

--[[
	Existence and shape checks only: read-only, no side effects, no protected
	calls. One row per API the add-on calls or replaces, and per Blizzard frame
	or table its files reach for at load, wherever it lives. The two clients'
	quest logs share nothing, so each client checks the shared rows plus its own
	quest log's.
]]

local function Resolve(path)
	local value = _G
	for part in string.gmatch(path, "[^.]+") do
		if type(value) ~= "table" then
			return nil
		end
		value = value[part]
	end
	return value
end

local function Rows(kind, paths)
	local rows = {}
	for _, path in ipairs(paths) do
		rows[#rows + 1] = {
			path,
			function()
				return type(Resolve(path)) == kind
			end,
		}
	end
	return rows
end

local function Append(target, rows)
	for _, row in ipairs(rows) do
		target[#target + 1] = row
	end
end

local SHARED_FUNCTIONS = {
	"C_AddOns.GetAddOnMetadata",
	"C_AddOns.IsAddOnLoaded",
	"C_AddOns.GetAddOnInfo",
	"C_AddOns.GetNumAddOns",
	"C_Seasons.GetActiveSeason",
	"C_Timer.After",
	"Settings.OpenToCategory",
	"hooksecurefunc",
	"GetQuestDifficultyColor",
	"GetQuestID",
	"QuestFrameProgressItems_Update",
	"QuestInfo_Display",
	"CreateFromMixins",
	"CreateFont",
	"PlaySound",
	"GetCursorPosition",
	"IsMouseButtonDown",
	"tContains",
	"MapUtil.GetDisplayableMapForPlayer",
	"C_Map.GetMapInfo",
}

-- The quest giver window's pieces, the quest text fonts, and the map's canvas, built in Features/Quest-Map.xml
local SHARED_TABLES = {
	"Enum.SeasonID",
	"QuestDifficultyColors",
	"SOUNDKIT",
	"UIErrorsFrame",
	"QuestTitleFont",
	"QuestInfoRewardsFrame",
	"QuestInfoDescriptionText",
	"QuestDetailScrollChildFrame",
	"QuestProgressScrollChildFrame",
	"QuestProgressText",
	"QuestProgressRequiredItemsText",
	"QuestRewardScrollChildFrame",
	"MapCanvasMixin",
	"MapExplorationDataProviderMixin",
	"GroupMembersDataProviderMixin",
	"MapCanvasDataProviderMixin",
	"MapCanvasPinMixin",
	"WowStyle2DropdownMixin",
	"PrettyWideQuestLogMapFrame",
	"PrettyWideQuestLogMapFrame.ScrollContainer",
}

local CLASSIC_FUNCTIONS = {
	"QuestLog_Update",
	"QuestLog_UpdateQuestDetails",
	"QuestFrameItems_Update",
	"SetUIPanelAttribute",
	"GetNumQuestLogEntries",
	"GetQuestLogTitle",
	"GetQuestLogSelection",
	"GetQuestTagInfo",
	"GetNumQuestLeaderBoards",
	"GetQuestLogLeaderBoard",
	"FauxScrollFrame_Update",
	"FauxScrollFrame_GetOffset",
	"QuestLog_SetSelection",
	"IsQuestWatched",
	"IsUnitOnQuest",
	"GetNumSubgroupMembers",
	"AutoQuestWatch_Insert",
	"RemoveQuestWatch",
	"GetNumQuestWatches",
	"GetQuestIDFromLogIndex",
	"QuestWatch_Update",
	"QuestLogCollapseAllButton_OnClick",
}

-- Blizzard's quest log pieces the widened layout moves, resizes or restyles
local CLASSIC_TABLES = {
	"QuestLogFrame",
	"QuestLogTitleText",
	"QuestLogTitle1",
	"QuestLogListScrollFrame",
	"QuestLogDetailScrollFrame",
	"QuestLogDetailScrollChildFrame",
	"QuestLogHighlightFrame",
	"QuestLogSkillHighlight",
	"QuestLogNoQuestsText",
	"EmptyQuestLogFrame",
	"QuestLogQuestTitle",
	"QuestLogObjectivesText",
	"QuestLogDescriptionTitle",
	"QuestLogQuestDescription",
	"QuestLogRewardTitleText",
	"QuestLogItemReceiveText",
	"QuestLogMoneyFrame",
	"QuestLogSpacerFrame",
	"QuestLogCollapseAllButton",
	"QuestLogExpandButtonFrame",
	"QuestLogFrameAbandonButton",
	"QuestFramePushQuestButton",
	"QUEST_WATCH_LIST",
	"HIGHLIGHT_FONT_COLOR",
}

local FOREVER_FUNCTIONS = {
	"C_QuestLog.GetInfo",
	"C_QuestLog.GetNumQuestLogEntries",
	"C_QuestLog.GetQuestTagInfo",
	"C_QuestLog.IsEliteQuest",
	"C_QuestLog.IsComplete",
	"C_QuestLog.IsFailed",
	"C_QuestLog.GetTitleForQuestID",
	"C_QuestLog.GetLogIndexForQuestID",
	"C_QuestLog.GetHeaderIndexForQuest",
	"C_QuestLog.GetSelectedQuest",
	"C_QuestLog.SetSelectedQuest",
	"C_QuestLog.GetNextWaypointText",
	"C_QuestLog.AddQuestWatch",
	"C_QuestLog.RemoveQuestWatch",
	"C_QuestLog.GetNumQuestWatches",
	"C_QuestLog.CanAbandonQuest",
	"C_QuestLog.IsPushableQuest",
	"C_QuestLog.IsQuestDisabledForSession",
	"C_QuestLog.GetMaxNumQuestsCanAccept",
	"C_QuestLog.GetMaxNumQuests",
	"C_QuestLog.GetNextWaypointForMap",
	"ExpandQuestHeader",
	"CollapseQuestHeader",
	"GetNumQuestLeaderBoards",
	"GetQuestLogLeaderBoard",
	"QuestUtils_IsQuestWatched",
	"QuestUtil.CanRemoveQuestWatch",
	"QuestMapQuestOptions_AbandonQuest",
	"QuestMapQuestOptions_ShareQuest",
	"ToggleQuestLog",
	"QuestMapFrame_OpenToQuestDetails",
	"QuestInfo_ShowTitle",
	"QuestInfo_ShowObjectivesText",
	"QuestInfo_ShowDescriptionText",
	"QuestInfo_ShowDescriptionHeader",
	"QuestInfo_ShowRewards",
	"QuestInfo_ShowSpacer",
	"CreateScrollBoxListLinearView",
	"CreateDataProvider",
	"ScrollUtil.InitScrollBoxListWithScrollBar",
	"MenuUtil.CreateContextMenu",
	"ChatFrameUtil.TryInsertQuestLinkForQuestID",
	"QuestTextContrast.IsEnabled",
	"QuestTextContrast.GetDefaultBackgroundAtlas",
	"CopyTable",
	"IsCurrentQuestFailed",
	"GetQuestLink",
	"ShowUIPanel",
	"HideUIPanel",
	"GetUIPanel",
	"GetQuestUiMapID",
	"GetQuestsOnMapCached",
	"C_TaskQuest.DoesMapShowTaskQuestObjectives",
	"C_SuperTrack.GetSuperTrackedQuestID",
	"QuestMapFrame_GetFocusedQuestID",
}

local FOREVER_TABLES = {
	"QUEST_TEMPLATE_LOG",
	"QuestMapFrame",
	"QuestFrame",
	"QuestLogPopupDetailFrame",
	"QuestInfoFrame",
	"QuestInfoObjectivesFrame",
	"QuestInfoTitleHeader",
	"QuestDifficultyHighlightColors",
	"ScrollBoxConstants",
	"UIPanelWindows",
	"UISpecialFrames",
	"StaticPopupDialogs",
	"FogOfWarDataProviderMixin",
	"QuestBlobDataProviderMixin",
	"QuestDataProviderMixin",
	"DungeonEntranceDataProviderMixin",
	"FlightPointDataProviderMixin",
	"POIButtonHighlightManager",
}

ns.DIAGNOSTIC_API_CHECKS = {}
Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", SHARED_FUNCTIONS))
Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", SHARED_TABLES))
Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "QUEST_LOG" }))
if IS_FOREVER then
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", FOREVER_FUNCTIONS))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", FOREVER_TABLES))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("number", { "Constants.QuestWatchConsts.MAX_QUEST_WATCHES" }))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "QUEST_TITLE_FORMAT_FAILED", "PARENS_TEMPLATE" }))
else
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", CLASSIC_FUNCTIONS))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", CLASSIC_TABLES))
	Append(
		ns.DIAGNOSTIC_API_CHECKS,
		Rows("number", {
			"QUESTS_DISPLAYED",
			"QUESTLOG_QUEST_HEIGHT",
			"MAX_WATCHABLE_QUESTS",
			"QUEST_WATCH_NO_EXPIRE",
		})
	)
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "ELITE", "QUEST_WATCH_TOO_MANY" }))
	-- Only TBC has daily quests; Classic-Quest-List.lua skips the daily tag where this is nil
	if ns.FLAVOR == "TBC" then
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("number", { "LE_QUEST_FREQUENCY_DAILY" }))
	end
end

--------------------------------------------------------------------------------
-- Data Sources
--------------------------------------------------------------------------------

-- The add-on ships no static game data, so there is nothing to validate (README-Notes: No Data tab).
ns.DIAGNOSTIC_DATA_SOURCES = {}

--------------------------------------------------------------------------------
-- Name Lookups
--------------------------------------------------------------------------------

--[[
	Every Blizzard UI label the add-on shows or matches, for the Localization
	tab's Game Names report, read exactly as the features read it: the global
	itself, so each one's id is its own constant name. ELITE is matched as well
	as shown on Classic Era and TBC, where it is how the list tells an elite
	quest from its tag. The add-on stores no other game record by ID.
]]
local function UiLabel(constant)
	return {
		constant = constant,
		kind = "uiLabel",
		id = constant,
		lookup = function()
			return _G[constant]
		end,
	}
end

local SHARED_LABELS = { "QUEST_LOG", "FAILED", "COMPLETE", "ELITE", "SHOW_MAP" }

local CLASSIC_LABELS = { "QUEST_WATCH_TOO_MANY" }

local FOREVER_LABELS = {
	"QUEST_LOG_COUNT_TEMPLATE",
	"QUESTLOG_NO_QUESTS_TEXT",
	"TRACK_QUEST_ABBREV",
	"UNTRACK_QUEST_ABBREV",
	"TRACK_QUEST",
	"UNTRACK_QUEST",
	"ABANDON_QUEST",
	"SHARE_QUEST",
	"EXIT",
	"OBJECTIVES_WATCH_TOO_MANY",
	"PARENS_TEMPLATE",
	"QUEST_TITLE_FORMAT_FAILED",
	"RELOADUI",
	"CANCEL",
}

ns.DIAGNOSTIC_NAME_LOOKUPS = {}
local function AddLabels(constants)
	for _, constant in ipairs(constants) do
		ns.DIAGNOSTIC_NAME_LOOKUPS[#ns.DIAGNOSTIC_NAME_LOOKUPS + 1] = UiLabel(constant)
	end
end

AddLabels(SHARED_LABELS)
if IS_FOREVER then
	AddLabels(FOREVER_LABELS)
else
	AddLabels(CLASSIC_LABELS)
	-- The daily tag, on the client that has daily quests (see LE_QUEST_FREQUENCY_DAILY above)
	if ns.FLAVOR == "TBC" then
		AddLabels({ "DAILY", "DAILY_QUEST_TAG_TEMPLATE" })
	end
end

--------------------------------------------------------------------------------
-- Context Probes
--------------------------------------------------------------------------------

-- The add-on's own example reports, appended to the shared Event Log intro.
ns.DiagnosticsStrings.EVENT_LOG_EXAMPLES =
	"Best for 'the quest log didn't update' or 'tracking didn't change' reports on WoW Forever."

local function YesNo(value)
	return value and "yes" or "no"
end

local function Setting(lines, label, key)
	local value = ns.db and ns.db.profile[key]
	lines[#lines + 1] = string.format("%s: %s", label, tostring(value))
end

local function Loaded(name)
	return C_AddOns.IsAddOnLoaded(name) and "loaded" or "not loaded"
end

local function Shown(frame)
	if not frame then
		return "missing"
	end
	return frame:IsShown() and "shown" or "hidden"
end

-- The quest selected in the quest log, as the features read it: its ID and title, or nil
local function SelectedQuest()
	if IS_FOREVER then
		local questID = ns.questLog and ns.questLog.selectedQuestID
		return questID, questID and C_QuestLog.GetTitleForQuestID(questID)
	end
	local index = GetQuestLogSelection()
	local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(index)
	if title and not isHeader then
		return questID, title, index
	end
	return nil
end

local function SelectedQuestLine(lines)
	local questID, title, index = SelectedQuest()
	if questID then
		lines[#lines + 1] = string.format(
			"Selected quest: %s (%s)%s",
			tostring(questID),
			tostring(title),
			index and string.format(", log index %d", index) or ""
		)
	else
		lines[#lines + 1] = "Selected quest: (none)"
	end
end

-- Questie's settings and modules, read the way the features read them; nil where Questie isn't loaded
local function QuestieProfile()
	return type(Questie) == "table" and type(Questie.db) == "table" and Questie.db.profile or nil
end

--------------------------------------------------------------------------------
-- Quest Log Context
--------------------------------------------------------------------------------

--[[
	ElvUI's own switches for skinning Blizzard's quest log. Classic-ElvUI.lua
	does nothing while the window has no ElvUI backdrop, which these decide.
]]
local function ElvUIQuestSkin(lines)
	local E = type(ElvUI) == "table" and ElvUI[1]
	if not E then
		return
	end
	local skins = E.GetModule and E:GetModule("Skins", true)
	local private = type(E.private) == "table" and E.private.skins
	local blizzard = type(private) == "table" and private.blizzard
	lines[#lines + 1] = string.format("ElvUI Skins module: %s", skins and "found" or "not found")
	lines[#lines + 1] = string.format(
		"ElvUI Blizzard skins / quest skin: %s / %s",
		tostring(type(blizzard) == "table" and blizzard.enable),
		tostring(type(blizzard) == "table" and blizzard.quest)
	)
	if not IS_FOREVER then
		lines[#lines + 1] =
			string.format("ElvUI backdrop on the quest log: %s", YesNo(QuestLogFrame and QuestLogFrame.backdrop))
	end
end

local function VoiceOverContext(lines)
	local voiceOver = type(VoiceOver) == "table" and VoiceOver
	local overlay = voiceOver and rawget(voiceOver, "QuestOverlayUI")
	local addon = voiceOver and rawget(voiceOver, "Addon")
	lines[#lines + 1] = string.format("VoiceOver global: %s", voiceOver and "found" or "not found")
	if voiceOver then
		lines[#lines + 1] = string.format("VoiceOver quest overlay: %s", overlay and "found" or "not found")
		local partOn = "(no switch)"
		if addon and addon.IsPartOn then
			partOn = tostring(addon:IsPartOn())
		end
		lines[#lines + 1] = string.format("VoiceOver quest log part on: %s", partOn)
	end
	-- What the quest list goes by: VoiceOver or Spoken Quests loaded, its pieces present and its quest log part on
	lines[#lines + 1] = string.format("Play buttons in the quest list: %s", YesNo(ns.GetVoiceOver()))
end

-- The state behind "the quest log looks wrong", "it won't open" and "the details are blank" reports. Reads only.
function ns:BuildQuestLogContextReport()
	local lines = { GetClientHeader(), "" }

	if IS_FOREVER then
		lines[#lines + 1] = "Quest log: the add-on's own window (WoW Forever)"
		Setting(lines, "Wide quest log enabled (this profile)", "enableWideQuestLog")
		lines[#lines + 1] = string.format(
			"Quest log key and tracker clicks taken over this session: %s",
			YesNo(ns.questLogTakenOver == true)
		)
		local wanted = ns.db and ns.db.profile.enableWideQuestLog
		if ns.db and (wanted and true or false) ~= (ns.questLogTakenOver == true) then
			lines[#lines + 1] = "  The setting and this session differ: it takes effect at the next /reload."
		end
		lines[#lines + 1] = string.format("Quest log window: %s", Shown(ns.questLogFrame))
		lines[#lines + 1] = string.format("Quest log entries: %d", C_QuestLog.GetNumQuestLogEntries())
		lines[#lines + 1] = string.format(
			"Quests held / most allowed: %s / %s",
			tostring(C_QuestLog.GetNumQuestLogEntries and select(2, C_QuestLog.GetNumQuestLogEntries())),
			tostring(C_QuestLog.GetMaxNumQuestsCanAccept and C_QuestLog.GetMaxNumQuestsCanAccept())
		)
	else
		lines[#lines + 1] = "Quest log: Blizzard's quest log, widened"
		lines[#lines + 1] = string.format("Quest log window: %s", Shown(QuestLogFrame))
		lines[#lines + 1] = string.format("Quest log entries: %d", GetNumQuestLogEntries())
		lines[#lines + 1] = string.format("List rows (QUESTS_DISPLAYED): %s", tostring(QUESTS_DISPLAYED))
		lines[#lines + 1] = string.format(
			"Own parchment drawn: %s (off while ElvUI is loaded)",
			YesNo(not C_AddOns.IsAddOnLoaded("ElvUI"))
		)
	end
	SelectedQuestLine(lines)

	if IS_FOREVER then
		--[[
			The quest details share Blizzard's quest text pieces, so they stay
			blank while any of these has them (Forever-Quest-Details.lua).
		]]
		local mapDetails = QuestMapFrame and QuestMapFrame.DetailsFrame
		lines[#lines + 1] = ""
		lines[#lines + 1] = string.format("Quest giver window: %s", Shown(QuestFrame))
		lines[#lines + 1] = string.format("Quest detail popup: %s", Shown(QuestLogPopupDetailFrame))
		lines[#lines + 1] =
			string.format("World map quest details visible: %s", YesNo(mapDetails and mapDetails:IsVisible()))
		lines[#lines + 1] = string.format(
			"Quest Text Contrast on: %s",
			tostring(QuestTextContrast and QuestTextContrast.IsEnabled and QuestTextContrast.IsEnabled())
		)
	end

	-- /wide refuses to open the options in combat; on WoW Forever the quest log also can't close the windows on the left
	lines[#lines + 1] = ""
	lines[#lines + 1] = string.format("In combat: %s", YesNo(InCombatLockdown()))
	lines[#lines + 1] = string.format(
		"Options panel registered: %s (category %s)",
		YesNo(ns.optionsFrames),
		tostring(ns.optionsFrames and ns.optionsFrames.categoryID)
	)

	lines[#lines + 1] = ""
	Setting(lines, "Zone order", "zoneSort")
	Setting(lines, "Space above zone names", "zoneGap")
	Setting(lines, "Quest order", "questSort")
	Setting(lines, "Welcome message", "showWelcome")

	lines[#lines + 1] = ""
	lines[#lines + 1] = string.format(
		"Wide Quest Log Plus: %s (it hooks the same quest log, so it must be off)",
		Loaded(ns.PREDECESSOR_ADDON_NAME)
	)
	lines[#lines + 1] = string.format("Questie: %s", Loaded("Questie"))
	lines[#lines + 1] = string.format("ElvUI: %s", Loaded("ElvUI"))
	ElvUIQuestSkin(lines)
	lines[#lines + 1] = string.format("VoiceOver: %s", Loaded("AI_VoiceOver"))
	lines[#lines + 1] = string.format("Spoken Quests: %s", Loaded("Spoken_Quests"))
	VoiceOverContext(lines)

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Tracking Context
--------------------------------------------------------------------------------

--[[
	The state behind "the tracking marks are missing", "Track All does nothing"
	and "the Track button is greyed out" reports. Questie's tracker, once
	enabled, hides every mark until it starts (Quest-Display.lua), and on WoW
	Forever decides which quests can be tracked at all (Forever-Tracking.lua).
	Reads only.
]]
function ns:BuildTrackingContextReport()
	local lines = { GetClientHeader(), "" }

	Setting(lines, "Mark untracked quests", "markUntracked")
	if IS_FOREVER then
		lines[#lines + 1] = string.format(
			"Watch list: %s / %s",
			tostring(C_QuestLog.GetNumQuestWatches()),
			tostring(Constants.QuestWatchConsts.MAX_QUEST_WATCHES)
		)
		lines[#lines + 1] =
			string.format("A watch can be removed now: %s", YesNo(QuestUtil and QuestUtil.CanRemoveQuestWatch()))
	else
		lines[#lines + 1] =
			string.format("Watch list: %s / %s", tostring(GetNumQuestWatches()), tostring(MAX_WATCHABLE_QUESTS))
	end

	lines[#lines + 1] = ""
	local profile = QuestieProfile()
	local tracker = ns.ImportQuestieModule("QuestieTracker")
	lines[#lines + 1] = string.format("Questie: %s", Loaded("Questie"))
	lines[#lines + 1] = string.format("Questie tracker enabled: %s", tostring(profile and profile.trackerEnabled))
	lines[#lines + 1] = string.format("QuestieTracker module: %s", tracker and "found" or "not found")
	if tracker then
		lines[#lines + 1] = string.format("Questie tracker started: %s", tostring(tracker.started))
	end
	if profile and profile.trackerEnabled and tracker and not tracker.started then
		lines[#lines + 1] = "  Questie's tracker hasn't started yet, so no tracking marks are drawn."
	end
	if IS_FOREVER then
		local player = ns.ImportQuestieModule("QuestiePlayer")
		local log = player and player.currentQuestlog
		lines[#lines + 1] = string.format("QuestiePlayer module: %s", player and "found" or "not found")
		lines[#lines + 1] = string.format("Quests in Questie's quest log: %s", log and CountKeys(log) or "n/a")
	end

	lines[#lines + 1] = ""
	local questID, _, index = SelectedQuest()
	SelectedQuestLine(lines)
	if questID and IS_FOREVER then
		lines[#lines + 1] = string.format("  Tracked: %s", YesNo(ns.IsTracked(questID)))
		lines[#lines + 1] = string.format("  Can be tracked (Questie can show it): %s", YesNo(ns.CanTrack(questID)))
		lines[#lines + 1] = string.format("  Room on the watch list: %s", YesNo(ns.HasRoomToTrack(questID)))
		lines[#lines + 1] =
			string.format("  Disabled this session: %s", YesNo(C_QuestLog.IsQuestDisabledForSession(questID)))
	elseif index then
		lines[#lines + 1] = string.format("  Tracked: %s", YesNo(IsQuestWatched(index)))
		-- A quest with no objectives can't be tracked, so Track All passes over it
		lines[#lines + 1] = string.format("  Objectives: %d", GetNumQuestLeaderBoards(index))
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Quest Map Context
--------------------------------------------------------------------------------

local function MapLine(label, mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	return string.format("%s: %s (%s)", label, tostring(mapID), tostring(info and info.name))
end

-- Questie's icons on the world map for a quest, as Questie-Map.lua finds them: the total, and how many per map
local function QuestieIcons(pins, questID)
	local total, perMap = 0, {}
	for icon, placement in pairs(pins) do
		if type(icon) == "table" and type(icon.data) == "table" and type(placement) == "table" then
			total = total + 1
			if questID and icon.data.Id == questID and placement.uiMapID then
				perMap[placement.uiMapID] = (perMap[placement.uiMapID] or 0) + 1
			end
		end
	end
	return total, perMap
end

--[[
	The state behind "the map is missing" and "the map shows the wrong zone"
	reports. The map follows the selected quest through Questie's world map
	icons, and on WoW Forever falls back to Blizzard's own quest areas. Reads
	only.
]]
function ns:BuildMapContextReport()
	local lines = { GetClientHeader(), "" }
	local questMap = ns.questMap
	local canvas = questMap and questMap.canvas

	lines[#lines + 1] =
		string.format("Map closed with Hide Map (remembered): %s", YesNo(ns.db and ns.db.global.mapHidden))
	lines[#lines + 1] = string.format("Map frame built: %s", YesNo(questMap and questMap.holder))
	if questMap and questMap.holder then
		lines[#lines + 1] = string.format("Map: %s", Shown(questMap.holder))
		lines[#lines + 1] = string.format("Map visible on screen: %s", YesNo(canvas and canvas:IsVisible()))
		lines[#lines + 1] = MapLine("Map showing", canvas and canvas:GetMapID())
		lines[#lines + 1] = string.format("Zone picker: %s", Shown(questMap.zoneDropdown))
	end
	lines[#lines + 1] = MapLine("Your zone", MapUtil.GetDisplayableMapForPlayer())

	lines[#lines + 1] = ""
	local questID = SelectedQuest()
	SelectedQuestLine(lines)
	if questID and IS_FOREVER then
		lines[#lines + 1] = MapLine("  Blizzard's zone for it", GetQuestUiMapID(questID))
	end

	lines[#lines + 1] = ""
	local pinsLibrary = LibStub("HereBeDragonsQuestie-Pins-2.0", true)
	lines[#lines + 1] = string.format("Questie: %s", Loaded("Questie"))
	lines[#lines + 1] = string.format(
		"Questie's map libraries: HereBeDragonsQuestie-2.0 %s, HereBeDragonsQuestie-Pins-2.0 %s",
		LibStub("HereBeDragonsQuestie-2.0", true) and "found" or "not found",
		pinsLibrary and "found" or "not found"
	)
	local pins = pinsLibrary and pinsLibrary.worldmapPins
	if type(pins) == "table" then
		local total, perMap = QuestieIcons(pins, questID)
		lines[#lines + 1] = string.format("Questie world map icons placed: %d", total)
		local maps = {}
		for mapID in pairs(perMap) do
			maps[#maps + 1] = mapID
		end
		table.sort(maps)
		lines[#lines + 1] = "Selected quest's icons, by zone:" .. (#maps == 0 and " (none)" or "")
		for _, mapID in ipairs(maps) do
			lines[#lines + 1] = MapLine(string.format("  %d icon(s) in", perMap[mapID]), mapID)
		end
	end
	lines[#lines + 1] = string.format(
		"Map follows Questie's icons for: %s",
		tostring(questMap and questMap.questieQuestID or "(no quest)")
	)

	return table.concat(lines, "\n")
end
