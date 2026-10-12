local _, ns = ...
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

function ns.OptionsRowLabel(text, order, width, hidden)
	return {
		type = "description",
		name = text,
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
	Whether the Quest Log switch asks for the other quest log than this session runs: it applies only as the
	saved settings load (Core.lua), so it waits for a reload
]]
function ns.IsQuestLogReloadPending()
	return (ns.db.profile.enableWideQuestLog and true or false) ~= ns.wideQuestLogActive
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
function ns.OptionsSubRow(order, controls, hidden)
	local args = {
		indent = { type = "description", name = " ", width = ns.OPTIONS_SUB_INDENT_WIDTH, order = 1 },
	}
	for key, control in pairs(controls) do
		args[key] = control
	end
	return { type = "group", name = "", inline = true, order = order, hidden = hidden, args = args }
end
