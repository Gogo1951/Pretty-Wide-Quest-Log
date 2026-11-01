local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

-- Reset Window, a quarter wider than a standard button for the longer locales, right-aligned
local RESET_WINDOW_WIDTH = 1.25
local RESET_WINDOW_INDENT_WIDTH = ns.OPTIONS_ROW_WIDTH - RESET_WINDOW_WIDTH

--[[
	Only a quest log that's a window of its own (WoW Forever and Mists) is dragged and saves its spot, which
	its reset puts back; Blizzard's on Classic Era and TBC has no spot to reset (ns.ResetWindow)
]]
local RESET_WINDOW_KIND = ns.questLogIsOwnWindow and "MOVE" or "SCALE"

-- The order dropdowns take more of their row than other controls, so their longest choice shows whole
local SORT_LABEL_WIDTH = 1.4
local SORT_CONTROL_WIDTH = ns.OPTIONS_ROW_WIDTH - SORT_LABEL_WIDTH

-- The Handy Clicks column fits the longest click across the locales (Spanish), with the rest for its description
local HANDY_CLICK_LABEL_WIDTH = 1.5
local HANDY_CLICK_DESCRIPTION_WIDTH = ns.OPTIONS_ROW_WIDTH - HANDY_CLICK_LABEL_WIDTH

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

-- The map's settings are hidden too on a client whose wide quest log has no map yet (Quest-Map.lua)
local function MapHidden()
	return Hidden() or not ns.hasQuestMap
end

local function QuestieLoaded()
	return C_AddOns.IsAddOnLoaded(ns.QUESTIE_ADDON_NAME)
end

--[[
	Show Objective Areas changes only the map, which redraws at once. The areas come from Questie, so
	without it the toggle is grayed out and its tooltip says why; the saved choice is kept for when it's back
]]
local function ObjectiveAreasToggle(order)
	local toggle = QuestLogToggle("showObjectiveAreas", "SHOW_OBJECTIVE_AREAS", nil, order)
	toggle.hidden = MapHidden
	toggle.disabled = function()
		return Inactive() or not QuestieLoaded()
	end
	toggle.desc = function()
		if QuestieLoaded() then
			return L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"]
		end
		return L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] .. "\n" .. GetColor("OFF") .. L["NEEDS_QUESTIE_HINT"] .. "|r"
	end
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
	return ns.OptionsSubRow(order, Hidden, { [key] = toggle })
end

--[[
	The clicks that are easy to miss, one to a row with a spacer between, the click in a column wide enough
	for its longest locale so the descriptions all start in the same place. Only a quest log that's a window
	of its own has the add-on's quest menu; on Classic Era and TBC a right-click on a quest stays Blizzard's
]]
local function AddHandyClicks(args, order)
	local keys = { "HANDY_CLICK_ZONE", "HANDY_CLICK_TRACK" }
	if ns.questLogIsOwnWindow then
		keys[#keys + 1] = "HANDY_CLICK_MENU"
	end
	keys[#keys + 1] = "HANDY_CLICK_ID"

	for index, key in ipairs(keys) do
		if index > 1 then
			args[key .. "_SPACE"] = ns.OptionsSpacer(order, Hidden)
			order = order + 1
		end
		args[key] = ns.OptionsRowLabel(GetColor("INFO") .. L[key] .. "|r", order, HANDY_CLICK_LABEL_WIDTH, Hidden)
		args[key .. "_DESCRIPTION"] =
			ns.OptionsRowLabel(L[key .. "_DESCRIPTION"], order + 1, HANDY_CLICK_DESCRIPTION_WIDTH, Hidden)
		order = order + 2
	end
end

--------------------------------------------------------------------------------
-- Quest Log Panel
--------------------------------------------------------------------------------

function ns.BuildQuestLogOptions()
	local options = {
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

			spaceSorting0 = ns.OptionsSpacer(5, Hidden),
			headerSorting = ns.OptionsHeader(L["QUEST_LOG_SORTING_HEADER"], 6, Hidden),
			spaceSorting1 = ns.OptionsSpacer(7, Hidden),
			descSorting = ns.OptionsDesc(L["QUEST_LOG_SORTING_DESCRIPTION"], 8, Hidden),
			spaceSorting2 = ns.OptionsSpacer(9, Hidden),

			zoneSortLabel = ns.OptionsRowLabel(L["ZONE_ORDER"], 10, SORT_LABEL_WIDTH, Hidden),
			zoneSort = SortSelect("zoneSort", "ZONE_ORDER_DESCRIPTION", {
				LEVEL_HIGHEST_FIRST = L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"],
				LEVEL_LOWEST_FIRST = L["SORT_AVERAGE_LEVEL_LOWEST"],
				ALPHABETICAL = L["SORT_ALPHABETICAL"],
			}, { "LEVEL_HIGHEST_FIRST", "LEVEL_LOWEST_FIRST", "ALPHABETICAL" }, 11),
			currentZoneFirstRow = SortSubOption("currentZoneFirst", "CURRENT_ZONE_FIRST", 12),
			spaceQuestSort = ns.OptionsSpacer(13, Hidden),
			questSortLabel = ns.OptionsRowLabel(L["QUEST_ORDER"], 14, SORT_LABEL_WIDTH, Hidden),
			questSort = SortSelect("questSort", "QUEST_ORDER_DESCRIPTION", {
				LEVEL_HIGHEST_FIRST = L["SORT_LEVEL_HIGHEST_DEFAULT"],
				LEVEL_LOWEST_FIRST = L["SORT_LEVEL_LOWEST"],
				ALPHABETICAL = L["SORT_ALPHABETICAL"],
			}, { "LEVEL_HIGHEST_FIRST", "LEVEL_LOWEST_FIRST", "ALPHABETICAL" }, 15),
			completedFirstRow = SortSubOption("completedFirst", "COMPLETED_FIRST", 16),

			spaceQuestRows0 = ns.OptionsSpacer(20, Hidden),
			headerQuestRows = ns.OptionsHeader(L["QUEST_LOG_ROWS_HEADER"], 21, Hidden),
			spaceQuestRows1 = ns.OptionsSpacer(22, Hidden),
			descQuestRows = ns.OptionsDesc(L["QUEST_LOG_ROWS_DESCRIPTION"], 23, Hidden),
			spaceQuestRows2 = ns.OptionsSpacer(24, Hidden),

			zoneGap = QuestLogToggle("zoneGap", "ZONE_GAP", nil, 25),
			spaceShowQuestLevels = ns.OptionsSpacer(26, Hidden),
			showQuestLevels = QuestLogToggle(
				"showQuestLevels",
				"SHOW_QUEST_LEVELS",
				L["SHOW_QUEST_LEVELS_DESCRIPTION"]:format(ns.LevelTag(40, L["QUEST_SUFFIX_DUNGEON"]))
					.. " "
					.. ns.QuestLevelLegend(),
				27
			),
			spaceMarkUntracked = ns.OptionsSpacer(28, Hidden),
			markUntracked = QuestLogToggle("markUntracked", "MARK_UNTRACKED", MARK_UNTRACKED_TEXT, 29),

			spaceWindowMap0 = ns.OptionsSpacer(30, Hidden),
			headerWindowMap = ns.OptionsHeader(L["QUEST_LOG_WINDOW_MAP_HEADER"], 31, Hidden),
			spaceWindowMap1 = ns.OptionsSpacer(32, Hidden),
			descWindowMap = ns.OptionsDesc(L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"], 33, Hidden),
			spaceWindowMap2 = ns.OptionsSpacer(34, Hidden),

			closeInCombat = QuestLogToggle("closeInCombat", "CLOSE_IN_COMBAT", nil, 35),
			spaceObjectiveAreas = ns.OptionsSpacer(36, MapHidden),
			showObjectiveAreas = ObjectiveAreasToggle(37),

			spaceWindowScale = ns.OptionsSpacer(38, Hidden),
			windowScaleLabel = ns.OptionsRowLabel(L["WINDOW_SCALE"], 39, nil, Hidden),
			windowScale = {
				type = "range",
				name = "",
				desc = L["WINDOW_SCALE_DESCRIPTION"],
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 40,
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
			spaceMapScale = ns.OptionsSpacer(41, MapHidden),
			mapScaleLabel = ns.OptionsRowLabel(L["MAP_SCALE"], 42, nil, MapHidden),
			mapScale = {
				type = "range",
				name = "",
				desc = L["MAP_SCALE_DESCRIPTION"],
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 43,
				hidden = MapHidden,
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
			spaceResetWindow = ns.OptionsSpacer(44, Hidden),
			resetWindowIndent = ns.OptionsRowLabel(" ", 45, RESET_WINDOW_INDENT_WIDTH, Hidden),
			resetWindow = {
				type = "execute",
				name = L["RESET_WINDOW_BUTTON"],
				desc = L["RESET_WINDOW_" .. RESET_WINDOW_KIND .. "_DESCRIPTION"],
				width = RESET_WINDOW_WIDTH,
				order = 46,
				hidden = Hidden,
				disabled = Inactive,
				confirm = true,
				confirmText = L["RESET_WINDOW_" .. RESET_WINDOW_KIND .. "_CONFIRM"],
				func = function()
					ns.ResetWindow()
				end,
			},

			spaceHandyClicks0 = ns.OptionsSpacer(50, Hidden),
			headerHandyClicks = ns.OptionsHeader(L["HANDY_CLICKS_HEADER"], 51, Hidden),
			spaceHandyClicks1 = ns.OptionsSpacer(52, Hidden),
		},
	}
	AddHandyClicks(options.args, 53)
	return options
end
