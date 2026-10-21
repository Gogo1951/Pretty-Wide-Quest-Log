local _, ns = ...
local L = ns.L

-- Reset Size and Position, a quarter wider than a standard button for the longer locales, right-aligned
local RESET_WINDOW_WIDTH = 1.25
local RESET_WINDOW_INDENT_WIDTH = ns.OPTIONS_ROW_WIDTH - RESET_WINDOW_WIDTH

-- The order dropdowns take more of their row than other controls, so their longest choice shows whole
local SORT_LABEL_WIDTH = 1.4
local SORT_CONTROL_WIDTH = ns.OPTIONS_ROW_WIDTH - SORT_LABEL_WIDTH

--[[
	One of the tracking marks as an inline icon, tinted as in the quest list, raised by offsetY. Blizzard's
	check sits high in its square while the eye fills its own, so the eye reads low beside the text
]]
local function TrackingMarkIcon(mark, offsetY)
	local red, green, blue = ns.HexToRGB(mark.color)
	return format(
		"|T%s:16:16:0:%d:32:32:0:32:0:32:%d:%d:%d|t",
		mark.texture,
		offsetY or 0,
		red * 255,
		green * 255,
		blue * 255
	)
end

-- What Mark Untracked Quests does, with both tracking marks shown in the sentence
local MARK_UNTRACKED_TEXT = L["MARK_UNTRACKED_DESCRIPTION"]:format(
	TrackingMarkIcon(ns.TRACKING_MARKS.tracked),
	TrackingMarkIcon(ns.TRACKING_MARKS.untracked, 3)
)

-- While the switch at the top of the panel is off, every setting under it is hidden
local function Hidden()
	return not ns.db.profile.enableWideQuestLog
end

--[[
	The wide quest log runs this session or it doesn't (Core.lua). With the switch turned on but the
	reload still to come, there's no quest log to apply the settings to, so they show grayed out
]]
local function Inactive()
	return not ns.wideQuestLogActive
end

-- The switch applies at the next reload, so while it differs from this session a line under it says so
local function ReloadPending()
	if ns.IsQuestLogReloadPending() then
		return L["FEATURE_QUEST_LOG_RELOAD_PENDING"]
	end
end

--------------------------------------------------------------------------------
-- Rows
--------------------------------------------------------------------------------

local function SortSelect(key, descriptionKey, values, sorting, order)
	return {
		type = "select",
		name = "",
		desc = L[descriptionKey],
		width = SORT_CONTROL_WIDTH,
		order = order,
		hidden = Hidden,
		disabled = Inactive,
		values = values,
		sorting = sorting,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			ns.RefreshQuestLog()
		end,
	}
end

-- A full-width toggle bound to a profile key, redrawing the list when changed
local function QuestLogToggle(key, nameKey, desc, order)
	return {
		type = "toggle",
		name = L[nameKey],
		desc = desc or L[nameKey .. "_DESCRIPTION"],
		width = "full",
		order = order,
		hidden = Hidden,
		disabled = Inactive,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			ns.RefreshQuestLog()
		end,
	}
end

-- Show Objective Areas changes only the map, which redraws at once
local function ObjectiveAreasToggle(order)
	local toggle = QuestLogToggle("showObjectiveAreas", "SHOW_OBJECTIVE_AREAS", nil, order)
	toggle.set = function(_, value)
		ns.db.profile.showObjectiveAreas = value
		ns.questMap.RequestRefresh()
	end
	return toggle
end

--[[
	A sub-option of the order dropdown above it, on its own indented row; the row hides it, not itself. Its
	silver caption would stay bright on a grayed-out checkbox, so it drops the silver while grayed out
]]
local function SortSubOption(key, nameKey, order)
	local toggle = QuestLogToggle(key, nameKey, nil, 2)
	toggle.name = function()
		return Inactive() and L[nameKey] or ns.OptionsSubLabel(L[nameKey])
	end
	toggle.width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH
	toggle.hidden = nil
	return ns.OptionsSubRow(order, { [key] = toggle }, Hidden)
end

--------------------------------------------------------------------------------
-- Quest Log Panel
--------------------------------------------------------------------------------

function ns.BuildQuestLogOptions()
	return {
		type = "group",
		name = QUEST_LOG,
		args = {
			descIntro = ns.OptionsDesc(L["TAB_QUEST_LOG_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			enableWideQuestLog = ns.OptionsFeatureToggle(
				"enableWideQuestLog",
				"ENABLE_WIDE_QUEST_LOG",
				"FEATURE_QUEST_LOG_DESCRIPTION",
				3
			),
			reloadPending = ns.OptionsStatusLine(ReloadPending, 4),

			spaceLayout0 = ns.OptionsSpacer(5, Hidden),
			headerLayout = ns.OptionsHeader(L["QUEST_LOG_LAYOUT_HEADER"], 6, Hidden),
			spaceLayout1 = ns.OptionsSpacer(7, Hidden),
			descLayout = ns.OptionsDesc(L["QUEST_LOG_LAYOUT_DESCRIPTION"], 8, Hidden),
			spaceLayout2 = ns.OptionsSpacer(9, Hidden),

			zoneSortLabel = ns.OptionsRowLabel(L["ZONE_ORDER"], 10, SORT_LABEL_WIDTH, Hidden),
			zoneSort = SortSelect("zoneSort", "ZONE_ORDER_DESCRIPTION", {
				LEVEL_HIGHEST_FIRST = L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"],
				LEVEL_LOWEST_FIRST = L["SORT_AVERAGE_LEVEL_LOWEST"],
				ALPHABETICAL = L["SORT_ALPHABETICAL"],
			}, { "LEVEL_HIGHEST_FIRST", "LEVEL_LOWEST_FIRST", "ALPHABETICAL" }, 11),
			currentZoneFirstRow = SortSubOption("currentZoneFirst", "CURRENT_ZONE_FIRST", 12),
			spaceZoneGap = ns.OptionsSpacer(13, Hidden),
			zoneGap = QuestLogToggle("zoneGap", "ZONE_GAP", nil, 14),

			spaceQuestSort = ns.OptionsSpacer(20, Hidden),
			questSortLabel = ns.OptionsRowLabel(L["QUEST_ORDER"], 21, SORT_LABEL_WIDTH, Hidden),
			questSort = SortSelect("questSort", "QUEST_ORDER_DESCRIPTION", {
				LEVEL_HIGHEST_FIRST = L["SORT_LEVEL_HIGHEST_DEFAULT"],
				LEVEL_LOWEST_FIRST = L["SORT_LEVEL_LOWEST"],
				ALPHABETICAL = L["SORT_ALPHABETICAL"],
			}, { "LEVEL_HIGHEST_FIRST", "LEVEL_LOWEST_FIRST", "ALPHABETICAL" }, 22),
			completedFirstRow = SortSubOption("completedFirst", "COMPLETED_FIRST", 23),
			spaceShowQuestLevels = ns.OptionsSpacer(24, Hidden),
			showQuestLevels = QuestLogToggle("showQuestLevels", "SHOW_QUEST_LEVELS", nil, 25),
			spaceMarkUntracked = ns.OptionsSpacer(26, Hidden),
			markUntracked = QuestLogToggle("markUntracked", "MARK_UNTRACKED", MARK_UNTRACKED_TEXT, 27),
			spaceCloseInCombat = ns.OptionsSpacer(28, Hidden),
			closeInCombat = QuestLogToggle("closeInCombat", "CLOSE_IN_COMBAT", nil, 29),
			spaceObjectiveAreas = ns.OptionsSpacer(30, Hidden),
			showObjectiveAreas = ObjectiveAreasToggle(31),

			spaceWindowScale = ns.OptionsSpacer(32, Hidden),
			windowScaleLabel = ns.OptionsRowLabel(L["WINDOW_SCALE"], 33, nil, Hidden),
			windowScale = {
				type = "range",
				name = "",
				desc = L["WINDOW_SCALE_DESCRIPTION"],
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 34,
				hidden = Hidden,
				disabled = Inactive,
				min = 0.7,
				max = 1.3,
				step = 0.05,
				isPercent = true,
				get = function()
					return ns.db.global.scale
				end,
				set = function(_, value)
					ns.db.global.scale = value
					ns.ApplyWindowScale()
				end,
			},
			spaceMapScale = ns.OptionsSpacer(35, Hidden),
			mapScaleLabel = ns.OptionsRowLabel(L["MAP_SCALE"], 36, nil, Hidden),
			mapScale = {
				type = "range",
				name = "",
				desc = L["MAP_SCALE_DESCRIPTION"],
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 37,
				hidden = Hidden,
				disabled = Inactive,
				min = 0.7,
				max = 1.3,
				step = 0.05,
				isPercent = true,
				get = function()
					return ns.db.global.mapScale
				end,
				set = function(_, value)
					ns.db.global.mapScale = value
					ns.ApplyMapScale()
				end,
			},
			spaceResetWindow = ns.OptionsSpacer(38, Hidden),
			resetWindowIndent = ns.OptionsRowLabel(" ", 39, RESET_WINDOW_INDENT_WIDTH, Hidden),
			resetWindow = {
				type = "execute",
				name = L["RESET_WINDOW"],
				desc = L["RESET_WINDOW_DESCRIPTION"],
				width = RESET_WINDOW_WIDTH,
				order = 40,
				hidden = Hidden,
				disabled = Inactive,
				confirm = true,
				confirmText = L["RESET_WINDOW_CONFIRM"],
				func = function()
					ns.ResetWindow()
				end,
			},
		},
	}
end
