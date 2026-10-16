local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--[[
	The link labels are one short word each, so they take only what a word needs and give the rest of
	the row to the URL.
]]
local LINK_LABEL_WIDTH = 0.6

local PARAGRAPHS = {
	"OPTIONS_LEVEL_UP_INTRO",
	"OPTIONS_LEVEL_UP_WAYS",
	"OPTIONS_LEVEL_UP_FEEDBACK",
	"OPTIONS_LEVEL_UP_FRIEND",
	"OPTIONS_LEVEL_UP_CURSEFORGE",
	"OPTIONS_LEVEL_UP_GITHUB",
	"OPTIONS_LEVEL_UP_THANKS",
}

-- { captionKey, linkKey }, in display order
local LINKS = {
	{ "OPTIONS_DISCORD", "DISCORD" },
	{ "OPTIONS_CURSEFORGE", "CURSEFORGE" },
	{ "OPTIONS_WAGO", "WAGO" },
	{ "OPTIONS_GITHUB", "GITHUB" },
}

--------------------------------------------------------------------------------
-- Feedback & Support Panel
--------------------------------------------------------------------------------

function ns.BuildFeedbackSupportOptions()
	local args = {}
	local order = 1

	for index, key in ipairs(PARAGRAPHS) do
		if index > 1 then
			args["spaceParagraph" .. index] = ns.OptionsSpacer(order)
			order = order + 1
		end
		args["paragraph" .. index] = ns.OptionsDesc(L[key], order)
		order = order + 1
	end

	args.spaceLinks0 = ns.OptionsSpacer(order)
	args.headerLinks = ns.OptionsHeader(L["OPTIONS_FEEDBACK_LINKS_HEADER"], order + 1)
	args.spaceLinks1 = ns.OptionsSpacer(order + 2)
	order = order + 3

	for index, row in ipairs(LINKS) do
		local captionKey, linkKey = row[1], row[2]
		if index > 1 then
			args["linkSpace" .. index] = ns.OptionsSpacer(order)
			order = order + 1
		end
		args["linkLabel" .. index] =
			ns.OptionsRowLabel(GetColor("TITLE") .. L[captionKey] .. "|r", order, LINK_LABEL_WIDTH)
		args["linkValue" .. index] = {
			type = "input",
			name = "",
			width = ns.OPTIONS_ROW_WIDTH - LINK_LABEL_WIDTH,
			order = order + 1,
			get = function()
				return ns.LINKS[linkKey]
			end,
			set = function() end,
		}
		order = order + 2
	end

	args.spaceCopyLink = ns.OptionsSpacer(order)
	args.copyLink = ns.OptionsDesc(GetColor("HELP") .. L["OPTIONS_COPY_LINK"] .. "|r", order + 1)

	args.spaceVersion = {
		type = "description",
		name = " ",
		width = "full",
		order = 998,
	}
	args.version = {
		type = "description",
		name = GetColor("INFO") .. L["OPTIONS_VERSION"]:format(ns.Version) .. "|r",
		fontSize = "medium",
		order = 999,
	}

	return {
		type = "group",
		name = L["OPTIONS_LEVEL_UP_TITLE"],
		args = args,
	}
end
