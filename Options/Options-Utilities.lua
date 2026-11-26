local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

-- Every string the kit draws (Options-Kit.lua)
Kit.SetText({
	example = L["SAMPLE_EXAMPLE"],
	soundPreview = L["OPTIONS_SOUND_PREVIEW_DESCRIPTION"],
	inCombat = L["CHAT_OPTIONS_IN_COMBAT"],
	reset = L["OPTIONS_RESET"],
})

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

-- A Routes switch writes through Routes, which redraws what follows it (Routes-Core.lua)
local function RoutesApply(key)
	return function(value)
		ns.routes.SetSetting(key, value)
	end
end

-- A Quality of Life setting takes effect at once: the dungeon quests' checks
function ns.ApplyQualityOfLifeSettings()
	if ns.dungeonQuests then
		ns.dungeonQuests.Watch()
	end
end

--[[
	The root panel's Features switches and each feature's own Enable switch, in tree order. The Wide Quest
	Log's takes effect at the next /reload, which the Options window offers on close (below). The Routes
	switches are listed only where Routes (Features/Routes) is loaded
]]
ns.FEATURES = {
	{
		store = "profile",
		setting = "enableWideQuestLog",
		name = "TAB_WIDE_QUEST_LOG",
		caption = "ENABLE_WIDE_QUEST_LOG",
		desc = "FEATURE_QUEST_LOG_DESCRIPTION",
	},
}
if ns.routes then
	for _, feature in ipairs({
		{ key = "showMap", name = "TAB_MAPS_OBJECTIVES", feature = "WAYPOINT_MARKERS" },
		-- The Quest Route is drawn between the Waypoint Markers, so its switch is grayed out while they're off
		{
			key = "showLine",
			name = "TAB_QUEST_ROUTE",
			feature = "QUEST_ROUTE",
			disabled = function()
				return not ns.routes.Settings().showMap
			end,
		},
		{ key = "showArrow", name = "TAB_QUEST_ARROW", feature = "QUEST_ARROW" },
	}) do
		ns.FEATURES[#ns.FEATURES + 1] = {
			store = "profile",
			setting = "routes." .. feature.key,
			name = feature.name,
			caption = "ENABLE_" .. feature.feature,
			desc = "FEATURE_" .. feature.feature .. "_DESCRIPTION",
			apply = RoutesApply(feature.key),
			disabled = feature.disabled,
		}
	end
end
ns.FEATURES[#ns.FEATURES + 1] = {
	store = "profile",
	setting = "enableQualityOfLife",
	name = "TAB_QUALITY_OF_LIFE",
	caption = "ENABLE_QUALITY_OF_LIFE",
	desc = "FEATURE_QUALITY_OF_LIFE_SUMMARY",
	apply = function(value)
		ns.db.profile.enableQualityOfLife = value
		ns.ApplyQualityOfLifeSettings()
	end,
}
-- Read at each hover (Questie-Tooltips.lua), so it needs no apply
ns.FEATURES[#ns.FEATURES + 1] = {
	store = "profile",
	setting = "questTooltips",
	name = "QUEST_TOOLTIPS",
	caption = "ENABLE_QUEST_TOOLTIPS",
	desc = "FEATURE_QUEST_TOOLTIPS_DESCRIPTION",
}

--------------------------------------------------------------------------------
-- Routes Settings
--------------------------------------------------------------------------------

--[[
	A Routes setting's switch. Routes is one line to leave out of the TOC (Features/Routes), so the switch
	hides without it. hidden, if given, hides it too; disabled, if given, grays it out
]]
function ns.OptionsRoutesToggle(key, nameKey, descKey, order, width, hidden, disabled)
	return {
		type = "toggle",
		name = L[nameKey],
		desc = L[descKey],
		width = width or "full",
		order = order,
		hidden = function()
			return ns.routes == nil or (hidden ~= nil and hidden())
		end,
		disabled = disabled,
		get = function()
			return ns.routes.Settings()[key]
		end,
		set = function(_, value)
			ns.routes.SetSetting(key, value)
			ns.RefreshSettings()
		end,
	}
end

--[[
	A control for a Routes setting (key; nil for a button), for a row that sets its width and caption. hidden
	hides it
]]
function ns.OptionsRoutesControl(key, control, order, hidden)
	control.name = control.name or ""
	control.width = ns.OPTIONS_CONTROL_WIDTH
	control.order = order
	control.hidden = hidden
	if key then
		control.get = function()
			return ns.routes.Settings()[key]
		end
		control.set = function(_, value)
			ns.routes.SetSetting(key, value)
			ns.RefreshSettings()
		end
	end
	return control
end

-- A Routes setting's caption beside its control, on a row of its own
function ns.OptionsRoutesLabelRow(order, hidden, caption, desc, key, control, helper)
	control.desc = desc
	return Kit.LabelRow(order, hidden, caption, ns.OptionsRoutesControl(key, control), desc, helper)
end

-- A Routes setting that's a sub-option of the control above it: its silver caption and its control, indented
function ns.OptionsRoutesSubControlRow(order, hidden, caption, desc, key, control)
	control.desc = desc
	return Kit.SubLabelRow(order, hidden, caption, ns.OptionsRoutesControl(key, control), desc)
end

--[[
	The four sizes a Waypoint Marker comes in, each times its size at Medium, for a select
	control's values and sorting
]]
local SIZE_NAMES = {
	[0.75] = "MARKER_SIZE_SMALL",
	[1] = "MARKER_SIZE_MEDIUM",
	[1.25] = "MARKER_SIZE_LARGE",
	[1.5] = "MARKER_SIZE_HUGE",
}
ns.OPTIONS_SIZE_ORDER = { 0.75, 1, 1.25, 1.5 }

function ns.OptionsSizeValues()
	local values = {}
	for value, nameKey in pairs(SIZE_NAMES) do
		values[value] = L[nameKey]
	end
	return values
end

--[[
	The route is planned from Questie's quest data, so without Questie there's none: a silver line under the
	Maps & Objectives, Quest Route and Quest Arrow switches says why nothing shows
]]
function ns.RoutesNeedQuestieLine(order)
	return Kit.StatusLine(function()
		if not C_AddOns.IsAddOnLoaded(ns.QUESTIE_ADDON_NAME) then
			return L["ROUTES_NEED_QUESTIE"]
		end
	end, order)
end

--------------------------------------------------------------------------------
-- Wide Quest Log Reload
--------------------------------------------------------------------------------

--[[
	Whether the Quest Log switch asks for the other quest log than this session runs: it applies only as the
	saved settings load (Core.lua), so it waits for a reload. A client with no wide quest log yet has none to wait for
]]
function ns.IsQuestLogReloadPending()
	return ns.hasWideQuestLog == true and (ns.db.profile.enableWideQuestLog and true or false) ~= ns.wideQuestLogActive
end

-- The silver line under the Quest Log switch, on the Wide Quest Log panel and the panels under it, while it waits for its reload
function ns.QuestLogReloadPendingText()
	if ns.IsQuestLogReloadPending() then
		return L["FEATURE_QUEST_LOG_RELOAD_PENDING"]
	end
end

--------------------------------------------------------------------------------
-- Example Lines
--------------------------------------------------------------------------------

-- The flavor's sample quests as the features take them; a title the client hasn't loaded yet is asked for
function ns.SampleQuests()
	local quests = {}
	for _, questID in ipairs(ns.SAMPLE_QUEST_IDS) do
		local title = ns.GetQuestTitleByID(questID)
		if not title then
			if C_QuestLog.RequestLoadQuestByID then
				C_QuestLog.RequestLoadQuestByID(questID)
			end
			title = L["SAMPLE_QUEST_LOADING"]:format(questID)
		end
		quests[#quests + 1] = { questID = questID, title = title }
	end
	return quests
end

-- A client with no sample quests shows no Example lines
function ns.NoSampleQuests()
	return #ns.SAMPLE_QUEST_IDS == 0
end

--[[
	An Example closing its control's field set, shown only while hidden() is false and the client has sample
	quests. getLine returns the finished line (Kit.PrintedLine, Kit.SentLine)
]]
function ns.OptionsExample(order, hidden, getLine)
	return Kit.Example(order, function()
		return (hidden ~= nil and hidden()) or ns.NoSampleQuests()
	end, getLine)
end

-- What the add-on prints, as the player's own chat window shows it
function ns.PrintedExample(message)
	return Kit.PrintedLine(ns.BuildPrintLine(message))
end

--------------------------------------------------------------------------------
-- Reload Prompt
--------------------------------------------------------------------------------

StaticPopupDialogs.PRETTYWIDEQUESTLOG_RELOAD = {
	text = L["RELOAD_PROMPT"],
	button1 = RELOADUI,
	button2 = CANCEL,
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

-- The topmost frame under UIParent holding the panel: the Options window, once the panel is shown in it
local function OptionsWindow(panel)
	local window = panel
	while window:GetParent() and window:GetParent() ~= UIParent do
		window = window:GetParent()
	end
	return window
end

--[[
	The Quest Log switch applies only as the saved settings load (Core.lua), so when the Options window
	closes with the profile asking for the other quest log, offer the reload that switches it. Comparing
	against this session's state covers a profile switch too, and stays quiet after a switch flipped back.

	The game's Options window may not exist yet when this file loads, so it is hooked the first time one
	of the add-on's panels shows inside it. Watching the window rather than the panels means the prompt
	still comes when the player has moved on to another category before closing.
]]
function ns.WatchOptionsForReload(panels)
	local hookedWindow
	local function PromptIfClosed()
		if ns.IsQuestLogReloadPending() then
			StaticPopup_Show("PRETTYWIDEQUESTLOG_RELOAD")
		end
	end
	for _, panel in ipairs(panels) do
		panel:HookScript("OnShow", function()
			local window = OptionsWindow(panel)
			if window ~= hookedWindow then
				hookedWindow = window
				window:HookScript("OnHide", function()
					C_Timer.After(0, PromptIfClosed)
				end)
			end
		end)
	end
end
