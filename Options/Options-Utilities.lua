local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Standard Helpers
--------------------------------------------------------------------------------

function ns.OptionsHeader(text, order, hidden)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = hidden }
end

function ns.OptionsDesc(text, order, hidden)
	return { type = "description", name = text, fontSize = "medium", order = order, hidden = hidden }
end

function ns.OptionsSpacer(order, hidden)
	return { type = "description", name = " ", order = order, hidden = hidden }
end

--[[
	A row's caption on the left of its control. Given desc, the caption shows the same tooltip as its
	control, titled with the caption: AceConfig wires every row to its tooltip, and InteractiveLabel is the
	label that takes the mouse
]]
function ns.OptionsRowLabel(text, order, width, hidden, desc)
	return {
		type = "description",
		name = text,
		desc = desc,
		dialogControl = desc and "InteractiveLabel" or nil,
		fontSize = "medium",
		width = width or ns.OPTIONS_LABEL_WIDTH,
		order = order,
		hidden = hidden,
	}
end

--[[
	A feature's on/off switch, the same widget on the root panel's Features section and at the top of the
	feature's own panel
]]
function ns.OptionsFeatureToggle(key, nameKey, descKey, order, width, onSet)
	return {
		type = "toggle",
		name = ns.L[nameKey],
		desc = ns.L[descKey],
		width = width or "full",
		order = order,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			if onSet then
				onSet(value)
			end
		end,
	}
end

--[[
	A Routes setting's switch. Routes is one line to leave out of the TOC (Features/Routes), so the switch
	hides without it. hidden, if given, hides it too; disabled, if given, grays it out
]]
function ns.OptionsRoutesToggle(key, nameKey, descKey, order, width, hidden, disabled)
	return {
		type = "toggle",
		name = ns.L[nameKey],
		desc = ns.L[descKey],
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
		end,
	}
end

--[[
	A control on the right of a row for a Routes setting (key; nil for a button), its caption on its own row
	label to the left, as the other panels lay out sliders and choices. hidden hides it
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
		end
	end
	return control
end

--[[
	The four sizes a Waypoint Marker or the Player Icon comes in, each times its size at Medium, for a select
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
	The Quest Route switch, on the root panel's Features section and the Quest Route panel: the route is
	drawn between the Waypoint Markers, so it's grayed out while they're off
]]
function ns.OptionsQuestRouteToggle(order, width)
	return ns.OptionsRoutesToggle(
		"showLine",
		"ENABLE_QUEST_ROUTE",
		"FEATURE_QUEST_ROUTE_DESCRIPTION",
		order,
		width,
		nil,
		function()
			return ns.routes ~= nil and not ns.routes.Settings().showMap
		end
	)
end

-- A Quality of Life setting takes effect at once: the quest giver window, and the dungeon quests' checks
function ns.ApplyQualityOfLifeSettings()
	ns.ApplyQuestGiverCleanup()
	if ns.dungeonQuests then
		ns.dungeonQuests.Watch()
	end
end

--[[
	Whether the Quest Log switch asks for the other quest log than this session runs: it applies only as the
	saved settings load (Core.lua), so it waits for a reload. A client with no wide quest log yet has none to wait for
]]
function ns.IsQuestLogReloadPending()
	return ns.hasWideQuestLog == true and (ns.db.profile.enableWideQuestLog and true or false) ~= ns.wideQuestLogActive
end

-- The silver line under the Quest Log switch, on the General and Quest Log panels, while it waits for its reload
function ns.QuestLogReloadPendingText()
	if ns.IsQuestLogReloadPending() then
		return L["FEATURE_QUEST_LOG_RELOAD_PENDING"]
	end
end

-- A silver line shown only while getText returns something
function ns.OptionsStatusLine(getText, order)
	return {
		type = "description",
		name = function()
			local text = getText()
			return text and (GetColor("HELP") .. text .. "|r") or ""
		end,
		fontSize = "medium",
		order = order,
		hidden = function()
			return getText() == nil
		end,
	}
end

-- A sub-option's caption, in silver (Build Reference → Sub-Option Rows)
function ns.OptionsSubLabel(text)
	return GetColor("HELP") .. text .. "|r"
end

--[[
	A sub-option: an indented control on a line of its own, in an unnamed inline group (Build Reference →
	Sub-Option Rows). hidden goes on the group, so the indent collapses with it
]]
function ns.OptionsSubRow(order, hidden, controls)
	local args = {
		indent = { type = "description", name = " ", width = ns.OPTIONS_SUB_INDENT_WIDTH, order = 1 },
	}
	for key, control in pairs(controls) do
		args[key] = control
	end
	return { type = "group", name = "", inline = true, order = order, hidden = hidden, args = args }
end

--------------------------------------------------------------------------------
-- Example Lines
--------------------------------------------------------------------------------

--[[
	How a line reaches whoever reads it, which decides how its Example is drawn: a whisper as the player
	receiving it sees it, and group chat as party chat, the one every group has. chatType is the client's
	ChatTypeInfo key, so a player who recolored a channel sees their own color; hex is for a client that
	hasn't filled that table in
]]
local SAMPLE_FORMS = {
	PARTY = { chatType = "PARTY", hex = "AAAAFF", prefix = CHAT_PARTY_GET },
	WHISPER = { chatType = "WHISPER", hex = "FF80FF", prefix = CHAT_WHISPER_GET },
}

local function ChatColor(form)
	local info = ChatTypeInfo and ChatTypeInfo[form.chatType]
	if not info then
		return "|cff" .. form.hex
	end
	return format(
		"|cff%02x%02x%02x",
		math.floor(info.r * 255 + 0.5),
		math.floor(info.g * 255 + 0.5),
		math.floor(info.b * 255 + 0.5)
	)
end

-- A panel falls back to white after a link's |r where chat falls back to the channel's color, so it's opened again
local function Tint(color, text)
	return color .. text:gsub("|r", "|r" .. color) .. "|r"
end

-- The receiving client draws a {rtN} token as its mark
local function RaidIconTexture(index)
	return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. index .. ":0|t"
end

-- The sender as chat names them: the character the panel is opened on, in its class color
local function SampleSender()
	local _, class = UnitClass("player")
	local color = ns.CLASS_COLORS[class or ""] or ns.PALETTE.TEXT
	return "[|cff" .. color .. (GetUnitName("player") or UnitName("player") or "") .. "|r]"
end

--[[
	An Example line: the silver label, then the line drawn as it will arrive. PRINT is the player's own
	window (ns.BuildPrintLine), PARTY and WHISPER chat from the player's character
]]
function ns.RenderSample(formKey, message)
	local line
	if formKey == "PRINT" then
		line = ns.BuildPrintLine(message)
	else
		local form = SAMPLE_FORMS[formKey]
		local shown = message:gsub("{rt(%d)}", RaidIconTexture)
		line = Tint(ChatColor(form), form.prefix:format(SampleSender()) .. shown)
	end
	return GetColor("HELP") .. L["SAMPLE_EXAMPLE"]:format(line .. GetColor("HELP")) .. "|r"
end

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

-- An Example under a control, indented as a sub-option and shown only while hidden() is false
function ns.OptionsExampleRow(order, example, hidden)
	return ns.OptionsSubRow(order, function()
		return hidden() or ns.NoSampleQuests()
	end, {
		example = {
			type = "description",
			name = function()
				return ns.NoSampleQuests() and "" or example()
			end,
			fontSize = "medium",
			width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH,
			order = 2,
		},
	})
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
