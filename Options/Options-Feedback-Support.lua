local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

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
			args["spaceParagraph" .. index] = ns.OptionsKit.Spacer(order)
			order = order + 1
		end
		args["paragraph" .. index] = ns.OptionsKit.Desc(L[key], order)
		order = order + 1
	end

	args.spaceLinks0 = ns.OptionsKit.Spacer(order)
	args.headerLinks = ns.OptionsKit.Header(L["OPTIONS_FEEDBACK_LINKS_HEADER"], order + 1)
	args.spaceLinks1 = ns.OptionsKit.Spacer(order + 2)
	order = order + 3

	for index, row in ipairs(LINKS) do
		local captionKey, linkKey = row[1], row[2]
		if index > 1 then
			args["linkSpace" .. index] = ns.OptionsKit.Spacer(order)
			order = order + 1
		end
		args["link" .. index] = ns.OptionsKit.LinkRow(order, L[captionKey], ns.LINKS[linkKey])
		order = order + 1
	end

	args.spaceCopyLink = ns.OptionsKit.Spacer(order)
	args.copyLink = ns.OptionsKit.Desc(GetColor("HELP") .. L["OPTIONS_COPY_LINK"] .. "|r", order + 1)

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
