local _, ns = ...

local GetClientHeader = ns.GetDiagnosticClientHeader
local CountKeys = ns.CountDiagnosticKeys

-- WoW Forever and Mists: the quest log is a window of the add-on's own (Forever-Quest-Log.lua)
local OWN_WINDOW = ns.questLogIsOwnWindow == true
-- Classic Era and TBC: Blizzard's quest log, widened (Core.lua)
local IS_WIDENED_BLIZZARD_LOG = not OWN_WINDOW and ns.hasWideQuestLog == true
-- WoW Forever: the quest log calls by quest ID. The other clients have only the older calls by quest log index
local QUEST_ID_API = C_QuestLog.GetInfo ~= nil

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

--[[
	Existence and shape checks only: read-only, no side effects, no protected
	calls. One row per API the add-on calls or replaces, and per Blizzard frame
	or table its files reach for at load, wherever it lives. Each client checks
	the shared rows plus its own quest log's: the window of the add-on's own
	(WoW Forever and Mists) or the Blizzard quest log it widens (Classic Era and
	TBC), and the quest log calls by quest ID (WoW Forever) or by quest log index.
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
	"Mixin",
	"CreateFont",
	"PlaySound",
	"GetCursorPosition",
	"IsMouseButtonDown",
	"tContains",
	"MapUtil.GetDisplayableMapForPlayer",
	"C_Map.GetMapInfo",
	"GetRealZoneText",
	"HideUIPanel",
	"GetActiveLevel",
	"GetAvailableLevel",
	"GetAvailableQuestInfo",
	"GetMaxPlayerLevel",
	"UnitLevel",
	"GetMoneyString",
	"StaticPopup_Show",
	"StaticPopup_Hide",
	"MenuUtil.CreateContextMenu",
	"GameTooltip_SetTitle",
	"GameTooltip_AddNormalLine",
	"C_ChatInfo.SendChatMessage",
	"C_ChatInfo.InChatMessagingLockdown",
	"GetTime",
	"UnitGUID",
	"UnitIsUnit",
	"GetNumGroupMembers",
	"GetNumSubgroupMembers",
	"IsInGroup",
	"IsInRaid",
	"IsInInstance",
	"GetInstanceInfo",
	"C_Map.GetAreaInfo",
	"C_Map.GetMapArtID",
	"C_Map.GetMapArtLayers",
	"C_MapExplorationInfo.GetExploredMapTextures",
	"QuestLogPushQuest",
	"ExpandQuestHeader",
	"C_QuestLog.IsQuestFlaggedCompleted",
	"InCombatLockdown",
	"ReloadUI",
	"GameTooltip_Hide",
	-- The map's OnShow calls Blizzard's own (Quest-Map.lua); the quest giver tags hook the gossip buttons' Setup (Quest-Giver.lua)
	"MapCanvasMixin.OnShow",
	"GossipSharedAvailableQuestButtonMixin.Setup",
	"GossipSharedActiveQuestButtonMixin.Setup",
	-- The Example lines ask for a sample quest's title that hasn't loaded (Options-Quality-of-Life.lua)
	"C_QuestLog.RequestLoadQuestByID",
}

-- The quest giver window's pieces, the quest text fonts, and the mixins the map's canvas is built from
local SHARED_TABLES = {
	"Enum.SeasonID",
	"QuestDifficultyColors",
	"SOUNDKIT",
	"UIErrorsFrame",
	"QuestTitleFont",
	"QuestFontNormalSmall",
	"QuestInfoRewardsFrame",
	"QuestInfoDescriptionText",
	"QuestDetailScrollChildFrame",
	"QuestProgressScrollChildFrame",
	"QuestProgressText",
	"QuestProgressRequiredItemsText",
	"QuestRewardScrollChildFrame",
	"MapCanvasMixin",
	"MapExplorationDataProviderMixin",
	"MapCanvasDataProviderMixin",
	"MapCanvasPinMixin",
	"WowStyle2DropdownMixin",
	"GossipSharedAvailableQuestButtonMixin",
	"GossipSharedActiveQuestButtonMixin",
	"QuestFrameGreetingPanel",
	"QuestProgressRequiredMoneyText",
	"QuestProgressItem1",
	"QuestProgressScrollFrame",
	"QuestInfoRewardsFrame.XPFrame.ValueText",
	"StaticPopupDialogs",
	"GameTooltip",
	"NORMAL_FONT_COLOR",
	"RED_FONT_COLOR",
	-- The chat colors the Example lines take; without it they fall back to the default colors
	"ChatTypeInfo",
}

-- The quest log index calls the zone menu (Classic-Zone-Actions.lua) and these reports read the log with
local LOG_INDEX_FUNCTIONS = {
	"QuestLog_Update",
	"GetNumQuestLogEntries",
	"GetQuestLogTitle",
	"GetQuestLogSelection",
	"GetQuestTagInfo",
	"GetNumQuestLeaderBoards",
	"IsQuestWatched",
	"GetNumQuestWatches",
	"SelectQuestLogEntry",
	"GetQuestLogPushable",
	"CollapseQuestHeader",
	"SetAbandonQuest",
	"AbandonQuest",
}

local CLASSIC_FUNCTIONS = {
	"QuestLog_UpdateQuestDetails",
	"QuestFrameItems_Update",
	"SetUIPanelAttribute",
	"QuestFrameGreetingPanel_OnShow",
	"GetQuestLogLeaderBoard",
	"FauxScrollFrame_Update",
	"FauxScrollFrame_GetOffset",
	"QuestLog_SetSelection",
	"IsUnitOnQuest",
	"AutoQuestWatch_Insert",
	"RemoveQuestWatch",
	"GetQuestIDFromLogIndex",
	"QuestWatch_Update",
	"QuestLogCollapseAllButton_OnClick",
}

-- Blizzard's quest log pieces the widened layout moves, resizes or restyles
local CLASSIC_TABLES = {
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
	"QuestLogItemChooseText",
	"QuestLogSpellLearnText",
	"QuestLogTimerText",
	"QuestLogObjective1",
	"QuestLogItem1",
	"QuestLogMoneyFrame",
	"QuestLogSpacerFrame",
	"QuestLogCollapseAllButton",
	"QuestLogExpandButtonFrame",
	"QuestLogFrameAbandonButton",
	"QuestFramePushQuestButton",
	"QuestLogTrack",
	"QuestTitleButton1",
	"QUEST_WATCH_LIST",
	"HIGHLIGHT_FONT_COLOR",
}

-- The window of its own on WoW Forever and Mists (Forever-Quest-Log.lua and the files after it)
local OWN_WINDOW_FUNCTIONS = {
	"C_QuestLog.GetMaxNumQuestsCanAccept",
	"GetNumQuestLeaderBoards",
	"GetQuestLogLeaderBoard",
	"ToggleQuestLog",
	"QuestInfo_ShowTitle",
	"QuestInfo_ShowObjectivesText",
	"QuestInfo_ShowDescriptionText",
	"QuestInfo_ShowDescriptionHeader",
	"QuestInfo_ShowRewards",
	"QuestInfo_ShowSpacer",
	"CreateScrollBoxListLinearView",
	"CreateDataProvider",
	"ScrollUtil.InitScrollBoxListWithScrollBar",
	"ScrollUtil.InitScrollFrameWithScrollBar",
	"ChatFrameUtil.TryInsertQuestLinkForQuestID",
	"QuestTextContrast.IsEnabled",
	"QuestTextContrast.GetDefaultBackgroundAtlas",
	"CopyTable",
	"IsCurrentQuestFailed",
	"ShowUIPanel",
	"GetUIPanel",
	"IsShiftKeyDown",
	-- The quest log key, bound over to the window's own button (Quest-Log-Key.lua)
	"GetBindingKey",
	"ClearOverrideBindings",
	"SetOverrideBindingClick",
}

local OWN_WINDOW_TABLES = {
	"QUEST_TEMPLATE_LOG",
	"QuestMapFrame",
	"QuestMapFrame.DetailsFrame",
	"QuestFrame",
	"QuestInfoFrame",
	"QuestInfoObjectivesFrame",
	"QuestInfoTitleHeader",
	"QuestInfoObjectivesHeader",
	"QuestInfoObjectivesText",
	"QuestInfoDescriptionHeader",
	"QuestInfoRewardText",
	"QuestInfoSpacerFrame",
	"QuestInfoRewardsFrame.MoneyFrame",
	"QuestInfoRewardsFrame.ItemReceiveText",
	"QuestInfoRewardsFrame.XPFrame.ReceiveText",
	"QuestDifficultyHighlightColors",
	"ScrollBoxConstants",
	"UIPanelWindows",
	"UISpecialFrames",
}

-- WoW Forever's quest log calls by quest ID (Utilities.lua, Forever-Tracking.lua, Forever-Zone-Actions.lua)
local QUEST_ID_FUNCTIONS = {
	"C_QuestLog.GetInfo",
	"C_QuestLog.GetNumQuestLogEntries",
	"C_QuestLog.GetQuestTagInfo",
	"GetActiveQuestID",
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
	"C_QuestLog.SetAbandonQuest",
	"C_QuestLog.AbandonQuest",
	"C_QuestLog.IsPushableQuest",
	"C_QuestLog.IsQuestDisabledForSession",
	"C_PlayerInfo.GetContentDifficultyQuestForPlayer",
	"GetDifficultyColor",
	"CollapseQuestHeader",
	"QuestUtils_IsQuestWatched",
	"QuestUtil.CanRemoveQuestWatch",
	"QuestMapQuestOptions_AbandonQuest",
	"QuestMapQuestOptions_ShareQuest",
	"GetQuestLink",
}

local QUEST_ID_TABLES = {
	"QuestLogPopupDetailFrame",
	"QuestFrameGreetingPanel.titleButtonPool",
	"Enum.RelativeContentDifficulty",
}

-- The window on Mists, over the quest log index calls above (Utilities.lua, Mists-Tracking.lua, Mists-Quest-Portrait.lua)
local INDEX_WINDOW_FUNCTIONS = {
	"AddQuestWatch",
	"RemoveQuestWatch",
	"WatchFrame_Update",
	"CanAbandonQuest",
	"GetAbandonQuestItems",
	"GetAbandonQuestName",
	"GetQuestLogPortraitGiver",
	-- Without it, every quest with a giver shows the giver's model
	"QuestLogShouldShowPortrait",
}

-- Blizzard's quest log on Mists, which the window takes over from (Mists-Quest-Log-Key.lua), and the giver model's template
local INDEX_WINDOW_TABLES = {
	"QuestLogDetailFrame",
	"QuestLogDetailScrollChildFrame",
	"PanningModelSceneMixin",
}

local function IsFunction(path)
	return type(Resolve(path)) == "function"
end

--[[
	The quest title and tag by quest ID, on every client but WoW Forever, take whichever call the client
	has (Utilities.lua), so each row passes where one of them is there
]]
local QUEST_LOOKUP_ROUTES = {
	{
		"C_QuestLog.GetTitleForQuestID or C_QuestLog.GetQuestInfo",
		function()
			return IsFunction("C_QuestLog.GetTitleForQuestID") or IsFunction("C_QuestLog.GetQuestInfo")
		end,
	},
	{
		"C_QuestLog.GetQuestTagInfo with C_QuestLog.IsEliteQuest, or GetQuestTagInfo",
		function()
			if C_QuestLog.GetQuestTagInfo then
				return IsFunction("C_QuestLog.IsEliteQuest")
			end
			return IsFunction("GetQuestTagInfo")
		end,
	},
}

-- The map's layers beside the window (Forever-Quest-Map.lua)
local OWN_WINDOW_MAP_FUNCTIONS = {
	"C_QuestLog.GetMaxNumQuests",
	"GetQuestUiMapID",
	"C_TaskQuest.DoesMapShowTaskQuestObjectives",
	"QuestBlobPinMixin.TryDrawQuest",
}

local OWN_WINDOW_MAP_TABLES = {
	"QuestBlobDataProviderMixin",
	"QuestDataProviderMixin",
	"DungeonEntranceDataProviderMixin",
	"FlightPointDataProviderMixin",
}

-- WoW Forever's quest markers, and its takeover from Blizzard's map (Forever-Quest-Map.lua, Forever-Quest-Log-Key.lua)
local FOREVER_MAP_FUNCTIONS = {
	"QuestMapFrame_OpenToQuestDetails",
	"C_QuestLog.GetNextWaypointForMap",
	"GetQuestsOnMapCached",
	"QuestDataProviderMixin.UpdatePing",
}

-- Mists' numbered quest markers (Forever-Quest-Map.lua)
local MISTS_MAP_FUNCTIONS = {
	"C_QuestLog.GetQuestsOnMap",
	"QuestDataProviderMixin.AssignMissingNumbersToPins",
}

ns.DIAGNOSTIC_API_CHECKS = {}
Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", SHARED_FUNCTIONS))
Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", SHARED_TABLES))
Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "QUEST_LOG" }))
-- Group chat goes to the instance group only where this exists; without it, raid or party (Announcements.lua)
Append(ns.DIAGNOSTIC_API_CHECKS, Rows("number", { "LE_PARTY_CATEGORY_INSTANCE" }))
-- The map's frame, built in Features/Quest-Map.xml, which only a client with the map lists (Quest-Map.lua)
if ns.hasQuestMap then
	Append(
		ns.DIAGNOSTIC_API_CHECKS,
		Rows("table", {
			"PrettyWideQuestLogMapFrame",
			"PrettyWideQuestLogMapFrame.ScrollContainer",
			-- The map's border, and the giver model's box on Mists
			"BackdropTemplateMixin",
		})
	)
end
if OWN_WINDOW then
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", OWN_WINDOW_FUNCTIONS))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", OWN_WINDOW_TABLES))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "RED_FONT_COLOR_CODE", "HIGHLIGHT_FONT_COLOR_CODE" }))
	-- The window's failed quest title and the list's tag fall back to their own text without these
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "QUEST_TITLE_FORMAT_FAILED", "PARENS_TEMPLATE" }))
end
if QUEST_ID_API then
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", QUEST_ID_FUNCTIONS))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", QUEST_ID_TABLES))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("number", { "Constants.QuestWatchConsts.MAX_QUEST_WATCHES" }))
else
	Append(ns.DIAGNOSTIC_API_CHECKS, QUEST_LOOKUP_ROUTES)
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", LOG_INDEX_FUNCTIONS))
	-- The zone menu redraws Blizzard's quest log only while it's open
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", { "QuestLogFrame" }))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("number", { "MAX_WATCHABLE_QUESTS" }))
	if OWN_WINDOW then
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", INDEX_WINDOW_FUNCTIONS))
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", INDEX_WINDOW_TABLES))
		-- The quest giver's model, posed as Blizzard poses its own (Mists-Quest-Portrait.lua)
		Append(
			ns.DIAGNOSTIC_API_CHECKS,
			Rows(
				"number",
				{ "QUEST_FRAME_MODEL_SCENE_ID", "CAMERA_TRANSITION_TYPE_IMMEDIATE", "CAMERA_MODIFICATION_TYPE_DISCARD" }
			)
		)
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "QUEST_WATCH_TOO_MANY" }))
	end
end
if OWN_WINDOW and ns.hasQuestMap then
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", OWN_WINDOW_MAP_FUNCTIONS))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", OWN_WINDOW_MAP_TABLES))
	if QUEST_ID_API then
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", FOREVER_MAP_FUNCTIONS))
		-- The micro menu button and tracker clicks open it first, and the window takes over from it; Mists has no fog layer to draw
		Append(
			ns.DIAGNOSTIC_API_CHECKS,
			Rows("table", { "WorldMapFrame", "FogOfWarDataProviderMixin", "FogOfWarFrameMixin" })
		)
	else
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", MISTS_MAP_FUNCTIONS))
	end
end
if IS_WIDENED_BLIZZARD_LOG then
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", CLASSIC_FUNCTIONS))
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("table", CLASSIC_TABLES))
	Append(
		ns.DIAGNOSTIC_API_CHECKS,
		Rows("number", {
			"QUESTS_DISPLAYED",
			"QUESTLOG_QUEST_HEIGHT",
			"QUEST_WATCH_NO_EXPIRE",
		})
	)
	Append(ns.DIAGNOSTIC_API_CHECKS, Rows("string", { "ELITE", "QUEST_WATCH_TOO_MANY" }))
	-- Only TBC has daily quests; Classic-Quest-List.lua skips the daily tag where this is nil
	if ns.FLAVOR == "TBC" then
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("number", { "LE_QUEST_FREQUENCY_DAILY" }))
		-- The daily reset line under a daily quest's title (Classic-Quest-Details.lua)
		Append(ns.DIAGNOSTIC_API_CHECKS, Rows("function", { "GetQuestResetTime", "SecondsToTime" }))
	end
end

--------------------------------------------------------------------------------
-- Data Sources
--------------------------------------------------------------------------------

--[[
	One entry per data file, and one report row per entry on the Data tab. Each entry's label is the
	table-name part of its file name. The map reveal tables are keyed by map art ID, which no client API
	looks up, so they're checked against the art the client's own maps are drawn on ("mapArt"). The quest
	tags are keyed by QuestInfo ID, which nothing on the client lists, so they print their row count
	("other"). The sample dungeon is a single area ID beside the sample quests rather than a table of its
	own, so its source reaches it through the quest table's file and names the constant in a DATA_ column.
]]
local function KeyId(id)
	return id
end

local function ListedId(_, questID)
	return questID
end

-- The sample dungeon, and the sample zone where the flavor has one
local function CollectSampleAreas()
	local areaID = ns.SAMPLE_DUNGEON_AREA_ID
	local rows = { { id = areaID, key = "SAMPLE_DUNGEON_AREA_ID", row = areaID } }
	if ns.SAMPLE_ZONE_AREA_ID then
		rows[#rows + 1] = { id = ns.SAMPLE_ZONE_AREA_ID, key = "SAMPLE_ZONE_AREA_ID", row = ns.SAMPLE_ZONE_AREA_ID }
	end
	return rows
end

ns.DIAGNOSTIC_DATA_SOURCES = {
	-- { label, sources = { { table, kind, rowId or collect, dataColumns } } }
	{
		label = "Map-Reveal",
		sources = { { table = "MAP_REVEAL_OVERLAYS", kind = "mapArt", rowId = KeyId } },
	},
	{
		label = "Quest-Tags",
		sources = { { table = "QUEST_TAG_SUFFIXES", kind = "other" } },
	},
	{
		label = "Sample-Quests",
		sources = {
			{ table = "SAMPLE_QUEST_IDS", kind = "quest", rowId = ListedId },
			{
				table = "SAMPLE_QUEST_IDS",
				kind = "area",
				collect = CollectSampleAreas,
				dataColumns = {
					{
						"DATA_CONSTANT",
						function(key)
							return key
						end,
					},
				},
			},
		},
	},
}

--------------------------------------------------------------------------------
-- Name Lookups
--------------------------------------------------------------------------------

--[[
	Every Blizzard UI label the add-on shows or matches, for the Localization
	tab's Game Names report, read exactly as the features read it: the global
	itself, so each one's id is its own constant name. ELITE is matched as well
	as shown on Classic Era and TBC, where it is how the list tells an elite
	quest from its tag. The Quality of Life panel's Example lines also name the
	flavor's sample quests, dungeon and zone by ID (Sample-Quests data), read through
	the same calls the panel makes.
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

local SHARED_LABELS = {
	"QUEST_LOG",
	"FAILED",
	"COMPLETE",
	"ELITE",
	"SHOW_MAP",
	"CLOSE",
	"CANCEL",
	"ACCEPT",
	"ERR_NOT_IN_GROUP",
	"RELOADUI",
	-- The zone heading for quests outside any zone in the turn-in line's tooltip, and its thousands separator
	"OTHER",
	"LARGE_NUMBER_SEPERATOR",
	-- The share results a whisper answers (Share-Reminders.lua)
	"ERR_QUEST_PUSH_BUSY_S",
	"ERR_QUEST_PUSH_TOO_FAR_S",
	"ERR_QUEST_PUSH_LOG_FULL_S",
	-- How the Example lines lead a whisper and a line of party chat (Options-Quality-of-Life.lua)
	"CHAT_WHISPER_GET",
	"CHAT_PARTY_GET",
}

-- The window's own text (WoW Forever and Mists)
local OWN_WINDOW_LABELS = {
	"QUEST_LOG_COUNT_TEMPLATE",
	"QUESTLOG_NO_QUESTS_TEXT",
	"TRACK_QUEST_ABBREV",
	"UNTRACK_QUEST_ABBREV",
	"TRACK_QUEST",
	"UNTRACK_QUEST",
	"ABANDON_QUEST",
	"SHARE_QUEST",
	"EXIT",
	"PARENS_TEMPLATE",
	"QUEST_TITLE_FORMAT_FAILED",
}

-- A full watch list's message on WoW Forever (Forever-Tracking.lua)
local QUEST_ID_LABELS = {
	"OBJECTIVES_WATCH_TOO_MANY",
}

ns.DIAGNOSTIC_NAME_LOOKUPS = {}
local function AddLabels(constants)
	for _, constant in ipairs(constants) do
		ns.DIAGNOSTIC_NAME_LOOKUPS[#ns.DIAGNOSTIC_NAME_LOOKUPS + 1] = UiLabel(constant)
	end
end

AddLabels(SHARED_LABELS)
if OWN_WINDOW then
	AddLabels(OWN_WINDOW_LABELS)
end
if QUEST_ID_API then
	AddLabels(QUEST_ID_LABELS)
elseif ns.hasWideQuestLog then
	-- A full watch list's message (Classic-Tracking.lua, Mists-Tracking.lua)
	AddLabels({ "QUEST_WATCH_TOO_MANY" })
end
-- The daily tag, on the client that has daily quests (see LE_QUEST_FREQUENCY_DAILY above)
if IS_WIDENED_BLIZZARD_LOG and ns.FLAVOR == "TBC" then
	AddLabels({ "DAILY", "DAILY_QUEST_TAG_TEMPLATE" })
end

-- The sample quests' titles load late, so each row asks for its quest the way the panel does
for _, questID in ipairs(ns.SAMPLE_QUEST_IDS or {}) do
	ns.DIAGNOSTIC_NAME_LOOKUPS[#ns.DIAGNOSTIC_NAME_LOOKUPS + 1] = {
		constant = "SAMPLE_QUEST_IDS",
		kind = "quest",
		id = questID,
		lookup = function()
			return ns.GetQuestTitleByID(questID)
		end,
		request = function()
			if C_QuestLog.RequestLoadQuestByID then
				C_QuestLog.RequestLoadQuestByID(questID)
			end
		end,
	}
end

if ns.SAMPLE_DUNGEON_AREA_ID then
	ns.DIAGNOSTIC_NAME_LOOKUPS[#ns.DIAGNOSTIC_NAME_LOOKUPS + 1] = {
		constant = "SAMPLE_DUNGEON_AREA_ID",
		kind = "area",
		id = ns.SAMPLE_DUNGEON_AREA_ID,
		lookup = function()
			return C_Map.GetAreaInfo(ns.SAMPLE_DUNGEON_AREA_ID)
		end,
	}
end

if ns.SAMPLE_ZONE_AREA_ID then
	ns.DIAGNOSTIC_NAME_LOOKUPS[#ns.DIAGNOSTIC_NAME_LOOKUPS + 1] = {
		constant = "SAMPLE_ZONE_AREA_ID",
		kind = "area",
		id = ns.SAMPLE_ZONE_AREA_ID,
		lookup = function()
			return C_Map.GetAreaInfo(ns.SAMPLE_ZONE_AREA_ID)
		end,
	}
end

--------------------------------------------------------------------------------
-- Context Probes
--------------------------------------------------------------------------------

-- The add-on's own example reports, appended to the shared Event Log intro.
ns.DiagnosticsStrings.EVENT_LOG_EXAMPLES =
	"Best for 'no whisper went out' or 'the dungeon quests weren't announced' reports, and on WoW Forever 'the quest log didn't update', 'tracking didn't change' or 'the quest log key opened the world map'."

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

--[[
	The quest selected in the quest log, as the features read it: its ID and title, and its quest log index
	where the log is read by index; or nil
]]
local function SelectedQuest()
	if OWN_WINDOW then
		local questID = ns.questLog and ns.questLog.selectedQuestID
		local index = questID and not QUEST_ID_API and ns.GetLogIndexForQuestID(questID) or nil
		return questID, questID and ns.GetQuestTitleByID(questID), index
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

--[[
	Every quest in the log as ns.LogQuests lists them, read without touching the quest log, and how many
	zones are collapsed. On Classic Era and TBC ns.LogQuests opens every zone and selects each quest in
	turn to ask whether it can be shared, which a probe must never do, so this lists only the open zones'
	quests and knows only the selected quest's pushable (nil for the rest)
]]
local function LogQuests()
	if QUEST_ID_API then
		return ns.LogQuests(), 0
	end
	local quests, zoneTitle, collapsed = {}, nil, 0
	local selected = GetQuestLogSelection()
	for index = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader, isCollapsed, isComplete, _, questID = GetQuestLogTitle(index)
		if isHeader then
			zoneTitle = title
			if isCollapsed then
				collapsed = collapsed + 1
			end
		elseif questID then
			local pushable
			if index == selected then
				pushable = GetQuestLogPushable() and true or false
			end
			quests[#quests + 1] = {
				questID = questID,
				title = title,
				zoneTitle = zoneTitle,
				isComplete = (isComplete or 0) > 0,
				isFailed = (isComplete or 0) < 0,
				pushable = pushable,
			}
		end
	end
	return quests, collapsed
end

ns.DiagnosticLogQuests = LogQuests

--[[
	ns.DungeonQuests, matching exactly as the feature does, over LogQuests above: on Classic Era and TBC
	the feature's own list, which selects every quest, is swapped out for the length of the call
]]
local function DungeonQuests(dungeon)
	if QUEST_ID_API then
		return ns.DungeonQuests(dungeon)
	end
	local featureLogQuests = ns.LogQuests
	ns.LogQuests = function()
		return (LogQuests())
	end
	local found, quests = pcall(ns.DungeonQuests, dungeon)
	ns.LogQuests = featureLogQuests
	if not found then
		error(quests, 0)
	end
	return quests
end

local function Shareable(pushable)
	if pushable == nil then
		return "sharing not checked (select it to check)"
	end
	return pushable and "can be shared" or "can't be shared"
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
	if IS_WIDENED_BLIZZARD_LOG then
		lines[#lines + 1] =
			string.format("ElvUI backdrop on the quest log: %s", YesNo(QuestLogFrame and QuestLogFrame.backdrop))
	end
end

-- The overlay's pieces each client's quest list calls (Classic-VoiceOver.lua, Forever-VoiceOver.lua)
local VOICEOVER_OVERLAY_PIECES = OWN_WINDOW and { "MakePlayButton", "BindPlayButton", "SetPlayButtonState" }
	or {
		"Update",
		"displayedButtons",
		"questPlayButtons",
		"CreatePlayButton",
		"UpdatePlayButton",
		"UpdateQuestTitle",
		"UpdatePlayButtonTexture",
	}

local function MissingPieces(owner, pieces)
	local missing = {}
	for _, name in ipairs(pieces) do
		if owner[name] == nil then
			missing[#missing + 1] = name
		end
	end
	return #missing == 0 and "all present" or ("missing " .. table.concat(missing, ", "))
end

local function VoiceOverContext(lines)
	local voiceOver = type(VoiceOver) == "table" and VoiceOver
	local overlay = voiceOver and rawget(voiceOver, "QuestOverlayUI")
	local addon = voiceOver and rawget(voiceOver, "Addon")
	lines[#lines + 1] = string.format("VoiceOver global: %s", voiceOver and "found" or "not found")
	if voiceOver then
		lines[#lines + 1] = string.format("VoiceOver quest overlay: %s", overlay and "found" or "not found")
		lines[#lines + 1] = string.format(
			"VoiceOver sound data / enums: %s / %s",
			rawget(voiceOver, "DataModules") and "found" or "not found",
			rawget(voiceOver, "Enums") and "found" or "not found"
		)
		if type(overlay) == "table" then
			lines[#lines + 1] = string.format(
				"VoiceOver overlay pieces the quest list uses: %s",
				MissingPieces(overlay, VOICEOVER_OVERLAY_PIECES)
			)
		end
		local partOn = "(no switch)"
		if addon and addon.IsPartOn then
			partOn = tostring(addon:IsPartOn())
		end
		lines[#lines + 1] = string.format("VoiceOver quest log part on: %s", partOn)
	end
	-- What the quest list goes by: VoiceOver or Spoken Quests loaded, its pieces present and its quest log part on
	lines[#lines + 1] = string.format("Play buttons in the quest list: %s", YesNo(ns.GetVoiceOver()))
end

-- Whether any zone header in the quest log is the player's zone
local function CurrentZoneHeaderListed()
	for index = 1, ns.GetNumQuestLogEntries() do
		local entry = ns.GetQuestLogEntry(index)
		if entry and entry.isHeader and ns.IsCurrentZone(entry.title) then
			return true
		end
	end
	return false
end

-- The state behind "the quest log looks wrong", "it won't open" and "the details are blank" reports. Reads only.
function ns:BuildQuestLogContextReport()
	local lines = { GetClientHeader(), "" }

	-- Sorting, the zone gaps and the tracking marks all read the saved settings, and skip their work without them
	lines[#lines + 1] = string.format("Saved settings loaded: %s", YesNo(ns.db))
	-- The Quest Log switch applies as settings load (Core.lua); the rest of this report assumes it's on
	Setting(lines, "Quest Log switch (this profile)", "enableWideQuestLog")
	lines[#lines + 1] = string.format("Wide quest log running this session: %s", YesNo(ns.wideQuestLogActive))
	local wanted = ns.db and ns.db.profile.enableWideQuestLog
	if ns.hasWideQuestLog and ns.db and (wanted and true or false) ~= (ns.wideQuestLogActive == true) then
		lines[#lines + 1] = "  The switch and this session differ: it takes effect at the next /reload."
	end
	if OWN_WINDOW then
		lines[#lines + 1] = "Quest log: the add-on's own window"
		lines[#lines + 1] = string.format(
			"Quest log key and tracker clicks taken over this session: %s",
			YesNo(ns.questLogTakenOver == true)
		)
		--[[
			While taken over, each quest log key opens the window's own button, which can't be set in combat
			(Quest-Log-Key.lua); the micro menu button and tracker clicks open the world map (WoW Forever) or
			Blizzard's quest log (Mists), which the window takes over from only out of combat
			(Forever-Quest-Log-Key.lua, Mists-Quest-Log-Key.lua)
		]]
		local keys = { GetBindingKey("TOGGLEQUESTLOG") }
		lines[#lines + 1] = string.format("Quest log key: %s", #keys > 0 and table.concat(keys, ", ") or "(not bound)")
		for _, key in ipairs(keys) do
			lines[#lines + 1] = string.format("  %s opens: %s", key, tostring(_G.GetBindingAction(key, true)))
		end
		lines[#lines + 1] = string.format("World map: %s", Shown(WorldMapFrame))
		lines[#lines + 1] = string.format("Quest log window: %s", Shown(ns.questLogFrame))
		-- The quest log closes as one of Blizzard's windows opens on the left (Forever-Quest-Log.lua)
		local leftPanel = GetUIPanel("left") or GetUIPanel("doublewide")
		lines[#lines + 1] = string.format(
			"Blizzard window open on the left: %s",
			leftPanel and tostring(leftPanel:GetName() or "unnamed") or "(none)"
		)
		lines[#lines + 1] = string.format("Quest log entries: %d", ns.GetNumQuestLogEntries())
		local GetEntryCounts = C_QuestLog.GetNumQuestLogEntries or GetNumQuestLogEntries
		lines[#lines + 1] = string.format(
			"Quests held / most allowed: %s / %s",
			tostring(select(2, GetEntryCounts())),
			tostring(C_QuestLog.GetMaxNumQuestsCanAccept and C_QuestLog.GetMaxNumQuestsCanAccept())
		)
	elseif IS_WIDENED_BLIZZARD_LOG then
		lines[#lines + 1] = "Quest log: Blizzard's quest log, widened"
		lines[#lines + 1] = string.format("Quest log window: %s", Shown(QuestLogFrame))
		lines[#lines + 1] = string.format("Quest log entries: %d", GetNumQuestLogEntries())
		lines[#lines + 1] = string.format("List rows (QUESTS_DISPLAYED): %s", tostring(QUESTS_DISPLAYED))
		-- The parchment hides for good as the window opens with ElvUI's quest skin drawn on it (Classic-ElvUI.lua)
		local E = type(ElvUI) == "table" and ElvUI[1]
		local elvSkin = QuestLogFrame and QuestLogFrame.backdrop and E and E.GetModule and E:GetModule("Skins", true)
		lines[#lines + 1] = string.format(
			"Own parchment drawn: %s (not once the quest log opens with ElvUI's quest skin on it)",
			YesNo(not elvSkin)
		)
	else
		lines[#lines + 1] =
			"Quest log: Blizzard's own (no wide quest log on this client yet, so the switch does nothing)"
		lines[#lines + 1] = string.format("Quest log window: %s", Shown(QuestLogFrame))
		lines[#lines + 1] = string.format("Quest log entries: %d", ns.GetNumQuestLogEntries())
	end
	SelectedQuestLine(lines)
	if OWN_WINDOW then
		-- The quest ID under the details is Blizzard's selection, which the add-on sets as it shows a quest
		lines[#lines + 1] = string.format("Blizzard's selected quest: %s", tostring(ns.GetSelectedQuestID()))
	end

	-- The quest giver window shows no quest ID while the game gives it none (0)
	lines[#lines + 1] = ""
	lines[#lines + 1] = string.format("Quest giver window: %s", Shown(QuestFrame))
	if QuestFrame and QuestFrame:IsShown() then
		lines[#lines + 1] = string.format("  Its quest ID: %s", tostring(GetQuestID and GetQuestID()))
	end

	if OWN_WINDOW then
		--[[
			The quest details share Blizzard's quest text pieces, so they stay
			blank while the quest giver window or any of these has them
			(Forever-Quest-Details.lua). The detail popup is WoW Forever's;
			Blizzard's quest log and its details window are Mists'.
		]]
		local mapDetails = QuestMapFrame and QuestMapFrame.DetailsFrame
		if QUEST_ID_API then
			lines[#lines + 1] = string.format("Quest detail popup: %s", Shown(QuestLogPopupDetailFrame))
		else
			lines[#lines + 1] = string.format("Blizzard's quest log: %s", Shown(QuestLogFrame))
			lines[#lines + 1] = string.format("Blizzard's quest details window: %s", Shown(QuestLogDetailFrame))
		end
		lines[#lines + 1] =
			string.format("World map quest details visible: %s", YesNo(mapDetails and mapDetails:IsVisible()))
		lines[#lines + 1] = string.format(
			"Quest Text Contrast on: %s",
			tostring(QuestTextContrast and QuestTextContrast.IsEnabled and QuestTextContrast.IsEnabled())
		)
	end
	if OWN_WINDOW and not QUEST_ID_API then
		--[[
			Mists: the giver's model beside the window shows for Blizzard's selected quest, once the details
			show that quest too, while the game gives it a model (portrait not 0) and lets it show. It goes
			under the map while the map is open, and hides when there's too little room there
			(Mists-Quest-Portrait.lua)
		]]
		local portrait, _, name, mount, modelSceneID
		if GetQuestLogPortraitGiver then
			portrait, _, name, mount, modelSceneID = GetQuestLogPortraitGiver()
		end
		lines[#lines + 1] = string.format(
			"Quest giver model for Blizzard's selected quest: %s (%s), mount %s, scene %s",
			tostring(portrait),
			tostring(name),
			tostring(mount),
			tostring(modelSceneID)
		)
		lines[#lines + 1] = string.format(
			"Blizzard lets the giver show: %s",
			QuestLogShouldShowPortrait and YesNo(QuestLogShouldShowPortrait()) or "yes (no check on this client)"
		)
		local holder = ns.questMap and ns.questMap.holder
		lines[#lines + 1] = string.format("Map open beside the window: %s", YesNo(holder and holder:IsShown()))
	end

	-- /pwql refuses to open the options in combat; on WoW Forever the quest log also can't close the windows on the left
	lines[#lines + 1] = ""
	lines[#lines + 1] = string.format("In combat: %s", YesNo(InCombatLockdown()))
	lines[#lines + 1] = string.format(
		"Options panel registered: %s (category %s)",
		YesNo(ns.optionsFrames),
		tostring(ns.optionsFrames and ns.optionsFrames.categoryID)
	)

	lines[#lines + 1] = ""
	Setting(lines, "Zone order", "zoneSort")
	Setting(lines, "Current zone first", "currentZoneFirst")
	-- Your Zone First and the zone mark match this name against the zone headers (Utilities.lua)
	lines[#lines + 1] = string.format("Player's zone: %s", tostring(GetRealZoneText()))
	lines[#lines + 1] = string.format("Zone header matching it: %s", YesNo(CurrentZoneHeaderListed()))
	Setting(lines, "Space above zone names", "zoneGap")
	Setting(lines, "Quest levels in the quest list", "showQuestLevels")
	Setting(lines, "Quest order", "questSort")
	Setting(lines, "Completed quests first", "completedFirst")
	Setting(lines, "Close when combat starts", "closeInCombat")
	Setting(lines, "Welcome message", "showWelcome")
	Setting(lines, "Quality of Life switch", "enableQualityOfLife")
	Setting(lines, "Quest giver window cleanup", "giverCleanup")
	Setting(lines, "Quest levels at quest givers", "giverLevels")
	-- Both switches above have to be on (Quest-Giver.lua)
	lines[#lines + 1] = string.format("Quest giver window cleanup in effect: %s", YesNo(ns.IsQuestGiverCleanupOn()))
	-- Quest ID lines link to Wowhead only on a client with a Wowhead address (Wowhead-Link.lua)
	lines[#lines + 1] = string.format("Wowhead quest address: %s", tostring(ns.WOWHEAD_QUEST_URL or "(none)"))

	lines[#lines + 1] = ""
	lines[#lines + 1] = string.format(
		"Wide Quest Log Plus: %s (it hooks the same quest log, so it must be off)",
		Loaded(ns.PREDECESSOR_ADDON_NAME)
	)
	lines[#lines + 1] = string.format("Questie: %s", Loaded(ns.QUESTIE_ADDON_NAME))
	-- The XP waiting to be turned in reads these; the line is hidden without them (Turn-In-Line.lua)
	local questXP = ns.ImportQuestieModule("QuestXP")
	lines[#lines + 1] = string.format(
		"Questie quest XP and money: %s",
		(
			questXP
			and type(questXP.GetQuestLogRewardXP) == "function"
			and type(questXP.GetQuestRewardMoney) == "function"
		)
				and "found"
			or "not found"
	)
	-- At the level cap the turn-in line leaves out the XP, as quest XP stops there
	lines[#lines + 1] = string.format("Level: %d of %d", UnitLevel("player"), GetMaxPlayerLevel())
	local logQuests, collapsed = LogQuests()
	local ready = 0
	for _, quest in ipairs(logQuests) do
		if quest.isComplete then
			ready = ready + 1
		end
	end
	lines[#lines + 1] = string.format(
		"Quests ready to turn in: %d%s",
		ready,
		collapsed > 0 and string.format(" (not counting %d collapsed zones)", collapsed) or ""
	)
	-- The Quest Chain section reads Questie's database; it's hidden without it (Quest-Chain.lua)
	local questieDB = ns.ImportQuestieModule("QuestieDB")
	lines[#lines + 1] = string.format(
		"Questie quest database: %s",
		(questieDB and type(questieDB.QueryQuestSingle) == "function") and "found" or "not found"
	)
	-- A chain row's tooltip is Questie's own; without it hovering a row shows nothing (Quest-Chain.lua)
	local chainLink = ns.ImportQuestieModule("QuestieLink")
	lines[#lines + 1] = string.format(
		"Questie quest tooltips on chain rows: %s",
		(chainLink and type(chainLink.CreateQuestTooltip) == "function") and "found" or "not found"
	)
	local selectedID = SelectedQuest()
	if selectedID then
		local parts, position = ns.GetQuestChain(selectedID)
		lines[#lines + 1] = string.format(
			"Selected quest's chain: %s",
			parts and string.format("part %d of %d", position, #parts) or "(none)"
		)
		-- The letter after its level comes from its tag through this flavor's tag table (Quest-Display.lua)
		local tagID, isElite = ns.GetQuestTagByID(selectedID)
		local suffix = ns.QuestSuffix(tagID, isElite)
		lines[#lines + 1] = string.format(
			"Selected quest's tag: %s, elite: %s, letter after its level: %s",
			tostring(tagID),
			YesNo(isElite),
			suffix ~= "" and suffix or "(none)"
		)
	end
	lines[#lines + 1] = string.format(
		"Quest tags with a letter on this client: %s",
		type(ns.QUEST_TAG_SUFFIXES) == "table" and CountKeys(ns.QUEST_TAG_SUFFIXES) or "missing"
	)
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
	and "the Track button is grayed out" reports. Questie's tracker, once
	enabled, hides every mark until it starts (Quest-Display.lua), and on WoW
	Forever decides which quests can be tracked at all (Forever-Tracking.lua).
	Reads only.
]]
function ns:BuildTrackingContextReport()
	local lines = { GetClientHeader(), "" }

	Setting(lines, "Mark untracked quests", "markUntracked")
	if QUEST_ID_API then
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
	lines[#lines + 1] = string.format("Questie: %s", Loaded(ns.QUESTIE_ADDON_NAME))
	lines[#lines + 1] = string.format("Questie tracker enabled: %s", tostring(profile and profile.trackerEnabled))
	lines[#lines + 1] = string.format("QuestieTracker module: %s", tracker and "found" or "not found")
	if tracker then
		lines[#lines + 1] = string.format("Questie tracker started: %s", tostring(tracker.started))
	end
	if profile and profile.trackerEnabled and tracker and not tracker.started then
		lines[#lines + 1] = "  Questie's tracker hasn't started yet, so no tracking marks are drawn."
	end
	if tracker then
		-- The marks come back the moment the tracker starts through this hook; without it, at the next redraw
		lines[#lines + 1] =
			string.format("QuestieTracker HookBaseTracker: %s", YesNo(type(tracker.HookBaseTracker) == "function"))
	end
	-- The tracking marks and Untrack All go by Questie's tracker once it has taken over (Tracking-Mark.lua)
	lines[#lines + 1] = string.format("Questie's tracker has taken over: %s", YesNo(ns.IsQuestieTracking()))
	if QUEST_ID_API then
		local player = ns.ImportQuestieModule("QuestiePlayer")
		local log = player and player.currentQuestlog
		lines[#lines + 1] = string.format("QuestiePlayer module: %s", player and "found" or "not found")
		lines[#lines + 1] = string.format("Quests in Questie's quest log: %s", log and CountKeys(log) or "n/a")
		if tracker then
			lines[#lines + 1] = string.format(
				"QuestieTracker IsTrackedByQuestie / Update: %s / %s",
				YesNo(type(tracker.IsTrackedByQuestie) == "function"),
				YesNo(type(tracker.Update) == "function")
			)
		end
		-- Forever-Tracking.lua's test: Questie decides only with its tracker on and every piece it reads present
		local questieDecides = profile
			and profile.trackerEnabled
			and tracker
			and tracker.IsTrackedByQuestie
			and player
			and true
		lines[#lines + 1] =
			string.format("Tracking decided by: %s", questieDecides and "Questie's tracker" or "Blizzard's watch list")
	end

	lines[#lines + 1] = ""
	local questID, _, index = SelectedQuest()
	SelectedQuestLine(lines)
	if questID and QUEST_ID_API then
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
-- Sharing Context
--------------------------------------------------------------------------------

-- The share results a whisper answers; Share-Reminders.lua skips any this client lacks
local SHARE_RESULTS = { "ERR_QUEST_PUSH_BUSY_S", "ERR_QUEST_PUSH_TOO_FAR_S", "ERR_QUEST_PUSH_LOG_FULL_S" }

-- The QuestieDB lookups that place a quest in a dungeon when its header doesn't (Dungeon-Quest-Lookup.lua)
local DUNGEON_QUESTIE_QUERIES = { "QueryQuestSingle", "QueryNPCSingle", "QueryObjectSingle", "QueryItemSingle" }

-- How many of these QuestieDB lookups are present, naming any missing
local function QuestieQueries(names)
	local questieDB = ns.ImportQuestieModule("QuestieDB")
	if not questieDB then
		return "QuestieDB not found"
	end
	local missing = {}
	for _, name in ipairs(names) do
		if type(questieDB[name]) ~= "function" then
			missing[#missing + 1] = name
		end
	end
	return string.format("%d of %d present", #names - #missing, #names)
		.. (#missing > 0 and (", missing " .. table.concat(missing, ", ")) or "")
end

local function QuestState(quest)
	if quest.isComplete then
		return "ready to turn in, so not announced"
	elseif quest.isFailed then
		return "failed, so not announced"
	end
	return "to do"
end

--[[
	The state behind "the dungeon quests weren't announced or shared" reports
	(Dungeon-Quests.lua): the switches, the dungeon as Questie knows it, which
	quests count and why, and the announcement as it would go out
]]
local function DungeonQuestLines(lines)
	lines[#lines + 1] = ""
	Setting(lines, "Announce dungeon quests", "dungeonAnnounce")
	Setting(lines, "Share dungeon quests", "dungeonShare")
	lines[#lines + 1] = string.format("Group chat channel: %s", ns:GetGroupChatChannel() or "none (not in a group)")
	-- Without ZoneDB the dungeon is known by name alone; without these queries only the quest log header places a quest (Dungeon-Quest-Lookup.lua)
	local zoneDB = ns.ImportQuestieModule("ZoneDB")
	lines[#lines + 1] = string.format(
		"Questie ZoneDB instance table / GetDungeons: %s / %s",
		YesNo(zoneDB and type(zoneDB.instanceIdToAreaId) == "table"),
		YesNo(zoneDB and type(zoneDB.GetDungeons) == "function")
	)
	lines[#lines + 1] =
		string.format("Questie lookups the dungeon match uses: %s", QuestieQueries(DUNGEON_QUESTIE_QUERIES))
	-- World event quests never count for a dungeon, though Questie can place one there (Dungeon-Quest-Lookup.lua)
	local questieEvent = ns.ImportQuestieModule("QuestieEvent")
	if questieEvent and type(questieEvent.IsEventQuest) == "function" then
		local eventQuests = 0
		for _, quest in ipairs((LogQuests())) do
			local found, isEvent = pcall(questieEvent.IsEventQuest, quest.questID)
			if found and isEvent == true then
				eventQuests = eventQuests + 1
			end
		end
		lines[#lines + 1] = string.format("Quests in the log left out as world event quests: %d", eventQuests)
	else
		lines[#lines + 1] = "Questie world event quest list: not found, so no quest is left out as one"
	end
	local dungeon = ns.CurrentDungeon()
	local _, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
	if not dungeon then
		-- Only "party" and "raid" count (Dungeon-Quest-Lookup.lua)
		lines[#lines + 1] = string.format("In a dungeon or raid: no (instance type %s)", tostring(instanceType))
		return
	end
	lines[#lines + 1] = string.format("Instance ID: %s", tostring(instanceID))

	local areaIDs = {}
	for areaID in pairs(dungeon.areaIDs) do
		areaIDs[#areaIDs + 1] = areaID
	end
	table.sort(areaIDs)
	lines[#lines + 1] = string.format("Dungeon: %s (key %s)", tostring(dungeon.name), tostring(dungeon.key))
	lines[#lines + 1] = string.format(
		"Questie zone IDs: %s",
		#areaIDs > 0 and table.concat(areaIDs, ", ") or "none, so only the quest log header decides"
	)
	lines[#lines + 1] = string.format("Already done for this group: %s", YesNo(ns.IsDungeonDone(dungeon)))

	local quests = DungeonQuests(dungeon)
	lines[#lines + 1] = string.format("Quests for this dungeon: %d", #quests)
	local _, collapsed = LogQuests()
	if collapsed > 0 then
		lines[#lines + 1] = string.format(
			"  Not counting the quests in %d collapsed zones, which the run on arrival opens to look in",
			collapsed
		)
	end
	for _, quest in ipairs(quests) do
		lines[#lines + 1] = string.format(
			"  %d %s: found by %s, %s, %s",
			quest.questID,
			tostring(quest.title),
			quest.matchedBy,
			QuestState(quest),
			Shareable(quest.pushable)
		)
	end
	local messages = ns.BuildDungeonAnnouncement(quests)
	lines[#lines + 1] = string.format("Announcement (%d messages):", #messages)
	for _, message in ipairs(messages) do
		lines[#lines + 1] = string.format("  %s (%d bytes)", message, #message)
	end
end

--[[
	The zone header a quest is listed under, or nil. By quest log index, a quest under a zone collapsed in
	Blizzard's log isn't listed at all, which on Mists can be every zone while the window is shut, so the
	log is read with every zone open (ns.LogQuests)
]]
local function QuestZone(questID)
	if QUEST_ID_API then
		local headerIndex = C_QuestLog.GetHeaderIndexForQuest(questID)
		local header = headerIndex and C_QuestLog.GetInfo(headerIndex)
		return header and header.title
	end
	for _, quest in ipairs(ns.LogQuests()) do
		if quest.questID == questID then
			return quest.zoneTitle
		end
	end
end

--[[
	What the zone menu offers for a zone (Zone-Menu.lua): Share is left out with nothing to share, and
	Abandon Gray Quests grayed out with nothing gray. On Classic Era and TBC the menu selects each quest to
	ask whether it can be shared, so only the zone's gray quests are counted here, with the list's own test
]]
local function ZoneMenuLines(lines, zoneTitle)
	lines[#lines + 1] = string.format("  Its zone: %s", tostring(zoneTitle))
	if not zoneTitle then
		return
	end
	if QUEST_ID_API then
		local shareable, total = ns.ShareableZoneQuests(zoneTitle)
		lines[#lines + 1] = string.format(
			"  Zone menu: %d of %d quests can be shared, %d gray",
			#shareable,
			total,
			#ns.GrayQuests(zoneTitle)
		)
		return
	end
	local inZone, total, gray = false, 0, 0
	for entry = 1, GetNumQuestLogEntries() do
		local title, level, _, isHeader, _, _, _, entryID = GetQuestLogTitle(entry)
		if isHeader then
			if inZone then
				break
			end
			inZone = title == zoneTitle
		elseif inZone and entryID then
			total = total + 1
			if GetQuestDifficultyColor(level) == QuestDifficultyColors.trivial then
				gray = gray + 1
			end
		end
	end
	lines[#lines + 1] = string.format(
		"  Zone menu: %d quests, %d gray; which can be shared is only checked as the menu opens",
		total,
		gray
	)
end

--[[
	The state behind "Share is grayed out or missing in the zone menu",
	"Abandon Gray Quests is grayed out", "no whisper went out when a share
	failed" and dungeon quest reports. Reads only: nothing is shared or sent,
	and the quest log's selection and zones are left as they are.
]]
function ns:BuildSharingContextReport()
	local lines = { GetClientHeader(), "" }

	-- The zone menu's Share is grayed out while solo and while a run of shares is still going (Zone-Menu.lua)
	lines[#lines + 1] = string.format("In a group: %s", YesNo(IsInGroup()))
	lines[#lines + 1] = string.format("Share run in progress: %s", YesNo(ns.sharingQuests))
	lines[#lines + 1] = string.format("Seconds between shares in use: %s", tostring(ns.db and ns.GetShareInterval()))
	local questID = SelectedQuest()
	SelectedQuestLine(lines)
	if questID then
		local pushable
		if QUEST_ID_API then
			pushable = C_QuestLog.IsPushableQuest(questID)
		elseif ns.GetSelectedQuestID() == questID then
			-- Reads Blizzard's selected quest, which on Mists can be another than the window's
			pushable = GetQuestLogPushable() and true or false
		end
		lines[#lines + 1] = string.format(
			"  The game lets you share it: %s",
			pushable == nil and "not checked (Blizzard's selected quest is another)" or YesNo(pushable)
		)
		ZoneMenuLines(lines, QuestZone(questID))
	end

	-- A whisper goes out only with both switches on, for a result within the share interval of the share
	lines[#lines + 1] = ""
	Setting(lines, "Quality of Life switch", "enableQualityOfLife")
	Setting(lines, "Whisper when a share fails", "shareWhispers")
	Setting(lines, "Seconds between shares", "shareInterval")
	-- Party only: no whisper in a raid, a battleground or an arena (Share-Reminders.lua)
	local _, instanceType = IsInInstance()
	lines[#lines + 1] = string.format("In a raid / instance type: %s / %s", YesNo(IsInRaid()), tostring(instanceType))
	lines[#lines + 1] = string.format(
		"Whispers can go out here: %s",
		YesNo(IsInGroup() and not IsInRaid() and instanceType ~= "pvp" and instanceType ~= "arena")
	)
	-- In chat lockdown on WoW Forever the share result can't be read, so no whisper goes out (Share-Reminders.lua)
	lines[#lines + 1] = string.format(
		"Chat messaging lockdown: %s",
		YesNo(C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown())
	)
	for _, result in ipairs(SHARE_RESULTS) do
		lines[#lines + 1] = string.format(
			"Share result %s: %s",
			result,
			type(_G[result]) == "string" and "found" or "missing, so no whisper for it"
		)
	end
	-- Without Questie's links a whisper names the quest in brackets instead
	local questieLink = ns.ImportQuestieModule("QuestieLink")
	local hasLinks = questieLink
		and (
			type(questieLink.GetNativeQuestLinkStringById) == "function"
			or type(questieLink.GetQuestLinkStringById) == "function"
		)
	lines[#lines + 1] = string.format("Questie quest links: %s", hasLinks and "found" or "not found")

	-- The Example lines under the sharing settings name these; a client with no sample quests shows none (Options-Quality-of-Life.lua)
	local samples, titled = ns.SAMPLE_QUEST_IDS or {}, 0
	for _, sampleID in ipairs(samples) do
		if ns.GetQuestTitleByID(sampleID) then
			titled = titled + 1
		end
	end
	lines[#lines + 1] = string.format("Example lines' sample quests: %d, titles loaded: %d", #samples, titled)
	lines[#lines + 1] = string.format(
		"Example lines' sample dungeon: %s (%s)",
		tostring(ns.SAMPLE_DUNGEON_AREA_ID),
		tostring(ns.SAMPLE_DUNGEON_AREA_ID and C_Map.GetAreaInfo(ns.SAMPLE_DUNGEON_AREA_ID))
	)
	lines[#lines + 1] = string.format(
		"Example lines' sample zone: %s (%s)",
		tostring(ns.SAMPLE_ZONE_AREA_ID),
		tostring(ns.SAMPLE_ZONE_AREA_ID and C_Map.GetAreaInfo(ns.SAMPLE_ZONE_AREA_ID))
	)

	DungeonQuestLines(lines)

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Quest Map Context
--------------------------------------------------------------------------------

local function MapLine(label, mapID)
	local info = mapID and C_Map.GetMapInfo(mapID)
	return string.format("%s: %s (%s)", label, tostring(mapID), tostring(info and info.name))
end

-- The areas Quest-Map-Reveal.lua can draw for the map's art, and how many of them the character has explored
local function MapRevealLine(mapID)
	local artID = mapID and C_Map.GetMapArtID(mapID)
	local areas = artID and ns.MAP_REVEAL_OVERLAYS and ns.MAP_REVEAL_OVERLAYS[artID]
	if not areas then
		return string.format("Map art: %s, no unexplored areas listed for it", tostring(artID))
	end
	local listed = 0
	for _ in pairs(areas) do
		listed = listed + 1
	end
	local explored = C_MapExplorationInfo.GetExploredMapTextures(mapID)
	return string.format("Map art: %s, areas listed: %d, explored: %d", artID, listed, explored and #explored or 0)
end

-- The map draws only these: no route lines, and nothing faded out entirely, though Questie may hide them itself (Questie-Map.lua)
-- Why the map leaves an icon out, or nil when it draws it (Questie-Map.lua's IsShownIcon)
local function SkipReason(icon)
	local texture = icon.texture
	if icon.type == "line" then
		return "route line"
	elseif type(texture) ~= "table" or not texture.GetVertexColor then
		return "no texture"
	end
	local _, _, _, alpha = texture:GetVertexColor()
	if (alpha or 0) <= 0 then
		return "faded out entirely"
	end
end

--[[
	Questie's icons on the world map for a quest, as Questie-Map.lua finds
	them: the total, per map how many the map draws and how many it leaves
	out, how many of the quest's carry Questie's scale for their kind (the
	map draws the rest at its base size), and why the left-out ones were,
	by Questie's kind of icon ("complete", "monster").
]]
local function QuestieIcons(pins, questID)
	local total, drawn, skipped, scaled, reasons = 0, {}, {}, 0, {}
	for icon, placement in pairs(pins) do
		if type(icon) == "table" and type(icon.data) == "table" and type(placement) == "table" then
			total = total + 1
			local mapID = placement.uiMapID
			if questID and icon.data.Id == questID and mapID then
				local reason = SkipReason(icon)
				local counts = reason and skipped or drawn
				counts[mapID] = (counts[mapID] or 0) + 1
				if reason then
					local key = string.format("%s (%s)", reason, tostring(icon.data.Type))
					reasons[key] = (reasons[key] or 0) + 1
				end
				if icon.data.GetIconScale then
					scaled = scaled + 1
				end
			end
		end
	end
	return total, drawn, skipped, scaled, reasons
end

-- Questie's calls that Questie-Map.lua hooks, so the map redraws as icons come and go
local QUESTIE_PIN_CALLS =
	{ "AddWorldMapIconMap", "AddWorldMapIconWorld", "RemoveWorldMapIcon", "RemoveAllWorldMapIcons" }

-- An objective's spawns in the map's zone, and how many of them Questie-Map-Areas.lua would place
local function ObjectiveSpawns(objective, mapID, zoneDB, phasing)
	local inZone, placed = 0, 0
	for _, spawnData in pairs(objective.spawnList) do
		local spawnsByArea = type(spawnData) == "table" and spawnData.Spawns or {}
		for areaID, spawns in pairs(spawnsByArea) do
			if zoneDB:GetUiMapIdByAreaId(areaID) == mapID then
				for _, spawn in ipairs(spawns) do
					inZone = inZone + 1
					local x, y = spawn[1], spawn[2]
					local visible = not (phasing and phasing.IsSpawnVisible) or phasing.IsSpawnVisible(spawn[3])
					if x and y and x >= 0 and y >= 0 and visible then
						placed = placed + 1
					end
				end
			end
		end
	end
	return inZone, placed
end

--[[
	Why the selected quest gets no objective areas on the map shown: the Questie pieces
	Questie-Map-Areas.lua places spawns with, the zone's size in yards, and for each objective with an icon
	drawn here, how many of its spawns are in the zone and placed (in your phase, with a position). An
	objective with none placed keeps Questie's icons.
]]
local function ObjectiveAreaLines(lines, pins, questID, mapID)
	local zoneDB = ns.ImportQuestieModule("ZoneDB")
	local phasing = ns.ImportQuestieModule("Phasing")
	local hasAreaLookup = zoneDB and type(zoneDB.GetUiMapIdByAreaId) == "function"
	lines[#lines + 1] = string.format("Questie ZoneDB GetUiMapIdByAreaId: %s", hasAreaLookup and "found" or "not found")
	lines[#lines + 1] = string.format(
		"Questie Phasing IsSpawnVisible: %s",
		(phasing and type(phasing.IsSpawnVisible) == "function") and "found" or "not found, so every spawn counts"
	)
	local zoneLibrary = LibStub("HereBeDragonsQuestie-2.0", true)
	local width, height
	if mapID and zoneLibrary and type(zoneLibrary.GetZoneSize) == "function" then
		width, height = zoneLibrary:GetZoneSize(mapID)
	end
	lines[#lines + 1] = string.format("Zone size in yards: %s x %s", tostring(width), tostring(height))
	if not (hasAreaLookup and questID and mapID and type(pins) == "table") then
		return
	end

	local seen, objectives = {}, {}
	for icon, placement in pairs(pins) do
		local data = type(icon) == "table" and icon.data
		local objective = type(data) == "table" and data.ObjectiveData
		if
			data
			and data.Id == questID
			and data.Type ~= "available"
			and data.Type ~= "complete"
			and type(objective) == "table"
			and type(objective.spawnList) == "table"
			and type(placement) == "table"
			and placement.uiMapID == mapID
			and not SkipReason(icon)
			and not seen[objective]
		then
			seen[objective] = true
			objectives[#objectives + 1] = objective
		end
	end
	lines[#lines + 1] = string.format("Selected quest's objectives with spawns drawn here: %d", #objectives)
	for _, objective in ipairs(objectives) do
		local inZone, placed = ObjectiveSpawns(objective, mapID, zoneDB, phasing)
		lines[#lines + 1] =
			string.format("  %s: %d spawns in this zone, %d placed", tostring(objective.Description), inZone, placed)
	end
end

--[[
	The state behind "the map is missing", "the map shows the wrong zone" and
	"the zone is bare parchment" reports. The map follows the selected quest through Questie's world map
	icons, and on WoW Forever falls back to Blizzard's own quest areas. Reads
	only.
]]
function ns:BuildMapContextReport()
	local lines = { GetClientHeader(), "" }
	local questMap = ns.questMap
	local canvas = questMap and questMap.canvas

	lines[#lines + 1] =
		string.format("Map closed with Hide Map (remembered): %s", YesNo(ns.db and ns.db.global.mapHidden))
	lines[#lines + 1] = string.format(
		"Map hidden as the quest log is empty: %s",
		YesNo(questMap and questMap.IsLogEmpty and questMap.IsLogEmpty())
	)
	lines[#lines + 1] = string.format("Map frame built: %s", YesNo(questMap and questMap.holder))
	if questMap and questMap.holder then
		lines[#lines + 1] = string.format("Map: %s", Shown(questMap.holder))
		lines[#lines + 1] = string.format("Map visible on screen: %s", YesNo(canvas and canvas:IsVisible()))
		lines[#lines + 1] = MapLine("Map showing", canvas and canvas:GetMapID())
		lines[#lines + 1] = MapRevealLine(canvas and canvas:GetMapID())
		lines[#lines + 1] = string.format("Zone picker: %s", Shown(questMap.zoneDropdown))
		-- Quest-Map-Reveal.lua hooks these as the map is built; with none, unexplored areas stay bare
		local pins, withRefresh = 0, 0
		for pin in canvas:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
			pins = pins + 1
			if type(pin.RefreshOverlays) == "function" then
				withRefresh = withRefresh + 1
			end
		end
		lines[#lines + 1] = string.format("Exploration pins: %d, with RefreshOverlays: %d", pins, withRefresh)
	end
	lines[#lines + 1] = string.format(
		"Map reveal table: %s",
		type(ns.MAP_REVEAL_OVERLAYS) == "table"
				and string.format("%d map arts listed", CountKeys(ns.MAP_REVEAL_OVERLAYS))
			or "missing"
	)
	lines[#lines + 1] = MapLine("Your zone", MapUtil.GetDisplayableMapForPlayer())

	lines[#lines + 1] = ""
	local questID = SelectedQuest()
	SelectedQuestLine(lines)
	if questID and OWN_WINDOW then
		lines[#lines + 1] = MapLine("  Blizzard's zone for it", GetQuestUiMapID(questID))
	end
	-- Where the map goes without Questie's icons; on WoW Forever only where Blizzard's zone above is 0 (Questie-Map.lua)
	if questID and questMap and questMap.QuestGiverMapID then
		lines[#lines + 1] = MapLine("  Quest giver's zone in Questie", questMap.QuestGiverMapID(questID))
	end

	lines[#lines + 1] = ""
	local pinsLibrary = LibStub("HereBeDragonsQuestie-Pins-2.0", true)
	lines[#lines + 1] = string.format("Questie: %s", Loaded(ns.QUESTIE_ADDON_NAME))
	lines[#lines + 1] = string.format(
		"Questie's map libraries: HereBeDragonsQuestie-2.0 %s, HereBeDragonsQuestie-Pins-2.0 %s",
		LibStub("HereBeDragonsQuestie-2.0", true) and "found" or "not found",
		pinsLibrary and "found" or "not found"
	)
	if pinsLibrary then
		local present = 0
		for _, name in ipairs(QUESTIE_PIN_CALLS) do
			if type(pinsLibrary[name]) == "function" then
				present = present + 1
			end
		end
		lines[#lines + 1] =
			string.format("Questie icon calls the map redraws on: %d of %d present", present, #QUESTIE_PIN_CALLS)
	end
	local pins = pinsLibrary and pinsLibrary.worldmapPins
	if type(pins) == "table" then
		local total, drawn, skipped, scaled, reasons = QuestieIcons(pins, questID)
		lines[#lines + 1] = string.format("Questie world map icons placed: %d", total)
		local maps, seen = {}, {}
		for _, counts in ipairs({ drawn, skipped }) do
			for mapID in pairs(counts) do
				if not seen[mapID] then
					seen[mapID] = true
					maps[#maps + 1] = mapID
				end
			end
		end
		table.sort(maps)
		lines[#lines + 1] = "Selected quest's icons, by zone (drawn / left out):" .. (#maps == 0 and " (none)" or "")
		for _, mapID in ipairs(maps) do
			lines[#lines + 1] = MapLine(string.format("  %d / %d in", drawn[mapID] or 0, skipped[mapID] or 0), mapID)
		end
		if #maps > 0 then
			lines[#lines + 1] = string.format("  Sized by Questie's scale for their kind: %d", scaled)
		end
		for reason, count in pairs(reasons) do
			lines[#lines + 1] = string.format("  Left out, %s: %d", reason, count)
		end
	end
	local questieProfile = QuestieProfile()
	if questieProfile then
		-- The colored glow behind objective icons shows only with Questie's own always-glow setting on
		lines[#lines + 1] = string.format("Questie always glow on map: %s", tostring(questieProfile.alwaysGlowMap))
		-- Questie hides or fades its own icons by these; the map still draws the ones it hides (Questie-Map.lua)
		-- Questie's icon switch, which its world map button, its minimap button and /questie toggle all flip
		lines[#lines + 1] = string.format("Questie icons on: %s", tostring(questieProfile.enabled))
		lines[#lines + 1] = string.format(
			"Questie map icons / objectives / turn-ins: %s / %s / %s",
			tostring(questieProfile.enableMapIcons),
			tostring(questieProfile.enableObjectives),
			tostring(questieProfile.enableTurnins)
		)
		lines[#lines + 1] = string.format(
			"Questie hides untracked / unexplored icons: %s / %s, fade level %s",
			tostring(questieProfile.hideUntrackedQuestsMapIcons),
			tostring(questieProfile.hideUnexploredMapIcons),
			tostring(questieProfile.iconFadeLevel)
		)
	end
	lines[#lines + 1] = string.format(
		"Map follows Questie's icons for: %s",
		tostring(questMap and questMap.questieQuestID or "(no quest)")
	)
	if OWN_WINDOW then
		--[[
			Blizzard's objective area and quest marker draw the selected quest only, and nothing while Questie's
			icons have it, with a marker at its next waypoint when its objectives are in another zone (WoW
			Forever only) (Forever-Quest-Map.lua). On Mists they draw only for quests it has map data for
		]]
		local blizzardID = questID ~= (questMap and questMap.questieQuestID) and questID or nil
		lines[#lines + 1] =
			string.format("Blizzard's objective area and quest marker drawn for: %s", tostring(blizzardID or "(none)"))
		local mapID = canvas and canvas:GetMapID()
		if blizzardID and mapID and C_QuestLog.GetNextWaypointForMap then
			local x, y = C_QuestLog.GetNextWaypointForMap(blizzardID, mapID)
			lines[#lines + 1] = string.format(
				"  Next waypoint on the map shown: %s",
				(x and y) and string.format("%.3f, %.3f", x, y) or "(none)"
			)
		end
	end
	-- Built from Questie's spawns for each objective on the map shown (Questie-Map-Areas.lua)
	Setting(lines, "Show objective areas", "showObjectiveAreas")
	lines[#lines + 1] = string.format("Objective areas shaded: %s", tostring(questMap and questMap.areaCount))
	ObjectiveAreaLines(lines, pins, questID, canvas and canvas:GetMapID())

	return table.concat(lines, "\n")
end
