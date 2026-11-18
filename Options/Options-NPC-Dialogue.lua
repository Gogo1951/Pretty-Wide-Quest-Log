local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

--[[
	The NPC Dialogue panel, under Wide Quest Log: the quest giver window cleanup (Quest-Giver.lua) and the
	font of the quest giver and gossip windows' text. Neither follows the Quest Log switch, so they work
	alongside Blizzard's quest log too
]]

local function CleanupOff()
	return not ns.db.profile.giverCleanup
end

local function Toggle(key, nameKey, order)
	return {
		type = "toggle",
		name = L[nameKey],
		desc = L[nameKey .. "_DESCRIPTION"],
		width = "full",
		order = order,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			ns.ApplyQuestGiverCleanup()
			ns.RefreshSettings()
		end,
	}
end

-- The quest giver window cleanup's switch, at a caption's width with its one setting beside it
local function GiverCleanupToggle(order)
	local toggle = Toggle("giverCleanup", "GIVER_CLEANUP", order)
	toggle.width = ns.OPTIONS_LABEL_WIDTH
	return toggle
end

-- The quest giver window cleanup's one setting, beside its switch and hidden while it's off
local function GiverLevelsToggle(order)
	local toggle = Toggle("giverLevels", "SHOW_QUEST_LEVELS", order)
	toggle.desc = L["GIVER_LEVELS_DESCRIPTION"]:format(ns.LevelTag(40, L["QUEST_SUFFIX_DUNGEON"]))
		.. " "
		.. ns.QuestLevelLegend()
	toggle.width = ns.OPTIONS_CONTROL_WIDTH
	toggle.hidden = CleanupOff
	return toggle
end

-- The dialogue's font is part of the cleanup's styling, so it waits for the cleanup's switch, and says so
local function FontNeedsCleanupText()
	if CleanupOff() then
		return L["FONT_DIALOGUE_NEEDS_CLEANUP"]
	end
end

function ns.BuildNPCDialogueOptions()
	local args = {
		descIntro = Kit.Desc(L["TAB_NPC_DIALOGUE_DESCRIPTION"], 1),
		giverCleanupRow = Kit.Row(15, nil, { GiverCleanupToggle(), GiverLevelsToggle() }),
	}
	Kit.Section(args, "QuestGivers", 10, L["QUEST_GIVERS_HEADER"], L["QUEST_GIVERS_DESCRIPTION"])
	--[[
		The font's controls hide while the cleanup is off; its heading and the line saying why stay, so the
		section still says where it went
	]]
	ns.AddFontOptions(args, "dialogue", 20, CleanupOff)
	args.spaceFont0.hidden, args.headerFont.hidden, args.spaceFont1.hidden = nil, nil, nil
	args.noteFont = Kit.StatusLine(FontNeedsCleanupText, 23.5)
	return { type = "group", name = L["TAB_NPC_DIALOGUE"], args = args }
end
