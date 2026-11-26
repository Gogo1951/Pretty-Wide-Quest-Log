local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local Kit = ns.OptionsKit

--[[
	Only a quest log that's a window of its own (WoW Forever and Mists) is dragged and saves its spot, which
	its reset puts back; Blizzard's on Classic Era and TBC has no spot to reset (ns.ResetWindow)
]]
local RESET_WINDOW_KIND = ns.questLogIsOwnWindow and "MOVE" or "SCALE"

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

--[[
	While the Quest Log switch (atop the Wide Quest Log panel) is off, its Handy Clicks hide. The panels under
	it keep their settings in view and editable, under a line saying where the switch is, so they can be set
	up first
]]
local function QuestLogOff()
	return not ns.db.profile.enableWideQuestLog
end

--[[
	The wide quest log runs this session or it doesn't (Core.lua). With the switch turned on but the
	reload still to come, its settings show grayed out until it runs
]]
local function ReloadPending()
	return ns.db.profile.enableWideQuestLog and not ns.wideQuestLogActive
end

--[[
	A setting changed while the quest log isn't running is only saved: on Classic Era and TBC what applies
	it (ns.RefreshQuestLog and the rest) exists only once the quest log has run
]]
local function Running()
	return ns.wideQuestLogActive
end

--------------------------------------------------------------------------------
-- Rows
--------------------------------------------------------------------------------

-- An order dropdown, its caption beside it
local function SortRow(key, nameKey, values, sorting, order)
	return Kit.LabelRow(order, nil, L[nameKey], {
		type = "select",
		desc = L[nameKey .. "_DESCRIPTION"],
		disabled = ReloadPending,
		values = values,
		sorting = sorting,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			if Running() then
				ns.RefreshQuestLog()
			end
			ns.RefreshSettings()
		end,
	})
end

-- A full-width toggle bound to a profile key, redrawing the list when changed
local function QuestLogToggle(key, nameKey, desc, order)
	return {
		type = "toggle",
		name = L[nameKey],
		desc = desc or L[nameKey .. "_DESCRIPTION"],
		width = "full",
		order = order,
		disabled = ReloadPending,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			if Running() then
				ns.RefreshQuestLog()
			end
			ns.RefreshSettings()
		end,
	}
end

-- The map's settings are hidden on a client whose wide quest log has no map yet (Quest-Map.lua)
local function MapHidden()
	return not ns.hasQuestMap
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
		return ReloadPending() or not QuestieLoaded()
	end
	toggle.desc = function()
		if QuestieLoaded() then
			return L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"]
		end
		return L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] .. "\n" .. GetColor("OFF") .. L["NEEDS_QUESTIE_HINT"] .. "|r"
	end
	toggle.set = function(_, value)
		ns.db.profile.showObjectiveAreas = value
		if Running() then
			ns.questMap.RequestRefresh()
		end
		ns.RefreshSettings()
	end
	return toggle
end

--[[
	Show Zone Info changes only the map and the box under it, which lay out again at once. Its lists come
	from Questie, so without it the toggle is grayed out and its tooltip says why, as Show Objective Areas does
]]
local function ZoneInfoToggle(order)
	local toggle = QuestLogToggle("showZoneInfo", "SHOW_ZONE_INFO", nil, order)
	toggle.hidden = MapHidden
	toggle.disabled = function()
		return ReloadPending() or not QuestieLoaded()
	end
	toggle.desc = function()
		if QuestieLoaded() then
			return L["SHOW_ZONE_INFO_DESCRIPTION"]
		end
		return L["SHOW_ZONE_INFO_DESCRIPTION"] .. "\n" .. GetColor("OFF") .. L["NEEDS_QUESTIE_HINT"] .. "|r"
	end
	toggle.set = function(_, value)
		ns.db.profile.showZoneInfo = value
		if ns.zoneInfo.Apply then
			ns.zoneInfo.Apply()
		end
		ns.RefreshSettings()
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
		return ReloadPending() and L[nameKey] or Kit.SubLabel(L[nameKey])
	end
	toggle.width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH - 0.2
	return Kit.SubRow(order, nil, { toggle })
end

--[[
	The clicks that are easy to miss, one to a row with a spacer between, the click in a column wide enough
	for its longest locale so the descriptions all start in the same place. Only a quest log that's a window
	of its own has the add-on's quest menu; on Classic Era and TBC a right-click on a quest stays Blizzard's
]]
local function AddHandyClicks(args, order)
	local keys = { "HANDY_CLICK_TRACK" }
	if ns.questLogIsOwnWindow then
		keys[#keys + 1] = "HANDY_CLICK_MENU"
	end
	keys[#keys + 1] = "HANDY_CLICK_ID"

	for index, key in ipairs(keys) do
		if index > 1 then
			args[key .. "_SPACE"] = Kit.Spacer(order, QuestLogOff)
			order = order + 1
		end
		args[key] = Kit.Row(order, QuestLogOff, {
			Kit.Label(GetColor("INFO") .. L[key] .. "|r", nil, HANDY_CLICK_LABEL_WIDTH),
			Kit.Label(L[key .. "_DESCRIPTION"], nil, HANDY_CLICK_DESCRIPTION_WIDTH),
		})
		order = order + 1
	end
end

--[[
	On a sub-panel, the silver line over its settings while the Quest Log switch (on the Wide Quest Log panel)
	is off, or waiting for its reload
]]
local function NeedsWideQuestLogText()
	if QuestLogOff() then
		return L["NEEDS_WIDE_QUEST_LOG"]
	end
	return ns.QuestLogReloadPendingText()
end

-- A sub-panel's opening: its description, then the line saying the switch is off or its reload is to come
local function SubPanelIntro(args, descriptionKey)
	args.descIntro = Kit.Desc(L[descriptionKey], 1)
	args.needsWideQuestLog = Kit.StatusLine(NeedsWideQuestLogText, 2)
end

--------------------------------------------------------------------------------
-- Wide Quest Log Panel
--------------------------------------------------------------------------------

--[[
	The Quest Log switch and the clicks that are easy to miss. The settings are on the panels under this
	one: Quest List, Quest Details, Window & Map and NPC Dialogue
]]
function ns.BuildQuestLogOptions()
	local options = {
		type = "group",
		name = L["TAB_WIDE_QUEST_LOG"],
		args = {
			descIntro = Kit.Desc(L["TAB_QUEST_LOG_DESCRIPTION"], 1),
			spaceIntro = Kit.Spacer(2),
			enableWideQuestLog = Kit.FeatureSwitch("enableWideQuestLog", 3),
			reloadPending = Kit.StatusLine(ns.QuestLogReloadPendingText, 4),
			spaceSubPanels = Kit.Spacer(5),
			descSubPanels = Kit.Desc(L["QUEST_LOG_SUB_PANELS_DESCRIPTION"], 6),
		},
	}
	Kit.Section(options.args, "HandyClicks", 50, L["HANDY_CLICKS_HEADER"], nil, QuestLogOff)
	AddHandyClicks(options.args, 53)
	return options
end

--------------------------------------------------------------------------------
-- Quest List Panel
--------------------------------------------------------------------------------

local SORT_ORDER = { "LEVEL_HIGHEST_FIRST", "LEVEL_LOWEST_FIRST", "ALPHABETICAL" }

function ns.BuildQuestListOptions()
	local args = {
		zoneSort = SortRow("zoneSort", "ZONE_ORDER", {
			LEVEL_HIGHEST_FIRST = L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"],
			LEVEL_LOWEST_FIRST = L["SORT_AVERAGE_LEVEL_LOWEST"],
			ALPHABETICAL = L["SORT_ALPHABETICAL"],
		}, SORT_ORDER, 11),
		currentZoneFirstRow = SortSubOption("currentZoneFirst", "CURRENT_ZONE_FIRST", 12),
		spaceQuestSort = Kit.Spacer(13),
		questSort = SortRow("questSort", "QUEST_ORDER", {
			LEVEL_HIGHEST_FIRST = L["SORT_LEVEL_HIGHEST_DEFAULT"],
			LEVEL_LOWEST_FIRST = L["SORT_LEVEL_LOWEST"],
			ALPHABETICAL = L["SORT_ALPHABETICAL"],
		}, SORT_ORDER, 15),
		completedFirstRow = SortSubOption("completedFirst", "COMPLETED_FIRST", 16),

		zoneGap = QuestLogToggle("zoneGap", "ZONE_GAP", nil, 25),
		spaceShowQuestLevels = Kit.Spacer(26),
		showQuestLevels = QuestLogToggle(
			"showQuestLevels",
			"SHOW_QUEST_LEVELS",
			L["SHOW_QUEST_LEVELS_DESCRIPTION"]:format(ns.LevelTag(40, L["QUEST_SUFFIX_DUNGEON"]))
				.. " "
				.. ns.QuestLevelLegend(),
			27
		),
		spaceMarkUntracked = Kit.Spacer(28),
		markUntracked = QuestLogToggle("markUntracked", "MARK_UNTRACKED", MARK_UNTRACKED_TEXT, 29),
	}
	SubPanelIntro(args, "TAB_QUEST_LIST_DESCRIPTION")
	Kit.Section(args, "Sorting", 5, L["QUEST_LOG_SORTING_HEADER"], L["QUEST_LOG_SORTING_DESCRIPTION"])
	Kit.Section(args, "QuestRows", 20, L["QUEST_LOG_ROWS_HEADER"], L["QUEST_LOG_ROWS_DESCRIPTION"])
	ns.AddFontOptions(args, "list", 30, nil, ReloadPending)
	return { type = "group", name = L["TAB_QUEST_LIST"], args = args }
end

--------------------------------------------------------------------------------
-- Quest Details Panel
--------------------------------------------------------------------------------

function ns.BuildQuestDetailsOptions()
	local args = {}
	SubPanelIntro(args, "TAB_QUEST_DETAILS_DESCRIPTION")
	ns.AddFontOptions(args, "details", 10, nil, ReloadPending)
	return { type = "group", name = L["TAB_QUEST_DETAILS"], args = args }
end

--------------------------------------------------------------------------------
-- Window & Map Panel
--------------------------------------------------------------------------------

-- A scale slider, its caption beside it, applied by the quest log's ns[apply]; global, so every profile shares the window's size
local function ScaleRow(key, nameKey, order, hidden, apply)
	return Kit.LabelRow(order, hidden, L[nameKey], {
		type = "range",
		desc = L[nameKey .. "_DESCRIPTION"],
		disabled = ReloadPending,
		min = 0.7,
		max = 1.3,
		step = 0.05,
		isPercent = true,
		get = function()
			return ns.db.global[key]
		end,
		set = function(_, value)
			ns.db.global[key] = value
			if Running() then
				ns[apply]()
			end
			ns.RefreshSettings()
		end,
	})
end

function ns.BuildWindowMapOptions()
	local args = {
		spaceWindowMap = Kit.Spacer(34),

		closeInCombat = QuestLogToggle("closeInCombat", "CLOSE_IN_COMBAT", nil, 35),
		spaceObjectiveAreas = Kit.Spacer(36, MapHidden),
		showObjectiveAreas = ObjectiveAreasToggle(37),
		spaceZoneInfo = Kit.Spacer(37.1, MapHidden),
		showZoneInfo = ZoneInfoToggle(37.2),

		spaceWindowScale = Kit.Spacer(38),
		windowScale = ScaleRow("scale", "WINDOW_SCALE", 39, nil, "ApplyWindowScale"),
		spaceMapScale = Kit.Spacer(41, MapHidden),
		mapScale = ScaleRow("mapScale", "MAP_SCALE", 42, MapHidden, "ApplyMapScale"),
		spaceResetWindow = Kit.Spacer(44),
		resetWindow = Kit.ResetRow(
			45,
			nil,
			L["RESET_WINDOW"],
			L["RESET_WINDOW_" .. RESET_WINDOW_KIND .. "_DESCRIPTION"],
			-- Gray while a reload is pending, and while the window's size, place and scales are as a reset leaves them
			function()
				if ReloadPending() then
					return true
				end
				local saved, defaults = ns.db.global, ns.DATABASE_DEFAULTS.global
				return saved.height == nil
					and saved.point == nil
					and saved.scale == defaults.scale
					and saved.mapScale == defaults.mapScale
			end,
			function()
				if Running() then
					ns.ResetWindow()
				else
					-- Height and point have no default, so clearing restores them
					local saved, defaults = ns.db.global, ns.DATABASE_DEFAULTS.global
					saved.height, saved.point = nil, nil
					saved.scale, saved.mapScale = defaults.scale, defaults.mapScale
				end
			end,
			L["RESET_WINDOW_" .. RESET_WINDOW_KIND .. "_CONFIRM"]
		),
	}
	SubPanelIntro(args, "QUEST_LOG_WINDOW_MAP_DESCRIPTION")
	ns.AddFontOptions(args, "window", 50, nil, ReloadPending)
	return { type = "group", name = L["TAB_WINDOW_MAP"], args = args }
end
