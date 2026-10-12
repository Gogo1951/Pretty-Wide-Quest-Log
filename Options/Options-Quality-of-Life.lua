local _, ns = ...
local L = ns.L

-- While the Quality of Life switch at the top of the panel is off, every setting under it is hidden
local function Hidden()
	return not ns.db.profile.enableQualityOfLife
end

local function Toggle(key, nameKey, order)
	return {
		type = "toggle",
		name = L[nameKey],
		desc = L[nameKey .. "_DESCRIPTION"],
		width = "full",
		order = order,
		hidden = Hidden,
		get = function()
			return ns.db.profile[key]
		end,
		set = function(_, value)
			ns.db.profile[key] = value
			ns.ApplyQuestGiverCleanup()
		end,
	}
end

-- A sub-option of the quest giver window cleanup, indented with a silver caption; its row hides it, not itself
local function GiverLevelsToggle()
	local toggle = Toggle("giverLevels", "GIVER_LEVELS", 2)
	toggle.name = ns.OptionsSubLabel(toggle.name)
	toggle.width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH
	toggle.hidden = nil
	return toggle
end

-- Chat shows the {rt3} that leads a whisper as the purple diamond
local TARGET_MARKER_ICON = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t"

local EXAMPLE_QUEST = "[" .. L["OPTIONS_EXAMPLE_QUEST_NAME"] .. "]"

-- A message as chat shows it, the marker drawn as its icon
local function ShownInChat(message)
	return (message:gsub(ns.TARGET_MARKER, TARGET_MARKER_ICON))
end

--[[
	One of the whispers as the party member would read it, all in silver after "Example:", without chat's
	whisper color
]]
local function ShareWhisperExample()
	local message = ShownInChat(ns:BuildAnnounceMessage("WHISPER_SHARE_BUSY", EXAMPLE_QUEST))
	return ns.GetColor("HELP") .. L["OPTIONS_EXAMPLE"] .. " " .. message .. "|r"
end

-- The dungeon announcement for three quests as the group would read it, all in silver after "Example:"
local EXAMPLE_DUNGEON_QUEST_COUNT = 3

local function DungeonAnnounceExample()
	local quests = {}
	for index = 1, EXAMPLE_DUNGEON_QUEST_COUNT do
		quests[index] = EXAMPLE_QUEST
	end
	local list = table.concat(quests, L["DUNGEON_QUESTS_SEPARATOR"])
	local message = ShownInChat(ns:BuildAnnounceMessage("DUNGEON_QUESTS_ANNOUNCE", EXAMPLE_DUNGEON_QUEST_COUNT, list))
	return ns.GetColor("HELP") .. L["OPTIONS_EXAMPLE"] .. " " .. message .. "|r"
end

-- A silver example under a toggle, indented as a sub-option and shown only while hidden() is false
local function ExampleRow(order, example, hidden)
	return ns.OptionsSubRow(order, {
		example = {
			type = "description",
			name = example,
			fontSize = "medium",
			width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH,
			order = 2,
		},
	}, hidden)
end

--------------------------------------------------------------------------------
-- Quality of Life Panel
--------------------------------------------------------------------------------

function ns.BuildQualityOfLifeOptions()
	return {
		type = "group",
		name = L["TAB_QUALITY_OF_LIFE"],
		args = {
			descIntro = ns.OptionsDesc(L["TAB_QUALITY_OF_LIFE_DESCRIPTION"], 1),
			spaceIntro = ns.OptionsSpacer(2),
			enableQualityOfLife = ns.OptionsFeatureToggle(
				"enableQualityOfLife",
				"ENABLE_QUALITY_OF_LIFE",
				"FEATURE_QUALITY_OF_LIFE_DESCRIPTION",
				3,
				nil,
				ns.ApplyQuestGiverCleanup
			),

			spaceQuestGivers0 = ns.OptionsSpacer(10, Hidden),
			headerQuestGivers = ns.OptionsHeader(L["QUEST_GIVERS_HEADER"], 11, Hidden),
			spaceQuestGivers1 = ns.OptionsSpacer(12, Hidden),
			descQuestGivers = ns.OptionsDesc(L["QUEST_GIVERS_DESCRIPTION"], 13, Hidden),
			spaceQuestGivers2 = ns.OptionsSpacer(14, Hidden),
			giverCleanup = Toggle("giverCleanup", "GIVER_CLEANUP", 15),
			giverLevelsRow = ns.OptionsSubRow(16, { giverLevels = GiverLevelsToggle() }, function()
				return Hidden() or not ns.db.profile.giverCleanup
			end),

			spaceQuestSharing0 = ns.OptionsSpacer(20, Hidden),
			headerQuestSharing = ns.OptionsHeader(L["QUEST_SHARING_HEADER"], 21, Hidden),
			spaceQuestSharing1 = ns.OptionsSpacer(22, Hidden),
			descQuestSharing = ns.OptionsDesc(L["QUEST_SHARING_DESCRIPTION"], 23, Hidden),
			spaceQuestSharing2 = ns.OptionsSpacer(24, Hidden),
			shareIntervalLabel = ns.OptionsRowLabel(L["SHARE_INTERVAL"], 25, nil, Hidden),
			shareInterval = {
				type = "range",
				name = "",
				desc = L["SHARE_INTERVAL_DESCRIPTION"],
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 26,
				hidden = Hidden,
				min = ns.SHARE_INTERVAL_MIN,
				max = ns.SHARE_INTERVAL_MAX,
				step = 1,
				get = function()
					return ns.db.profile.shareInterval
				end,
				set = function(_, value)
					ns.db.profile.shareInterval = value
				end,
			},
			spaceShareWhispers = ns.OptionsSpacer(27, Hidden),
			shareWhispers = Toggle("shareWhispers", "SHARE_WHISPERS", 28),
			shareWhisperExampleRow = ExampleRow(29, ShareWhisperExample, function()
				return Hidden() or not ns.db.profile.shareWhispers
			end),

			spaceDungeonQuests0 = ns.OptionsSpacer(30, Hidden),
			headerDungeonQuests = ns.OptionsHeader(L["DUNGEON_QUESTS_HEADER"], 31, Hidden),
			spaceDungeonQuests1 = ns.OptionsSpacer(32, Hidden),
			descDungeonQuests = ns.OptionsDesc(L["DUNGEON_QUESTS_DESCRIPTION"], 33, Hidden),
			spaceDungeonQuests2 = ns.OptionsSpacer(34, Hidden),
			dungeonAnnounce = Toggle("dungeonAnnounce", "DUNGEON_ANNOUNCE", 35),
			dungeonAnnounceExampleRow = ExampleRow(36, DungeonAnnounceExample, function()
				return Hidden() or not ns.db.profile.dungeonAnnounce
			end),
			spaceDungeonShare = ns.OptionsSpacer(37, Hidden),
			dungeonShare = Toggle("dungeonShare", "DUNGEON_SHARE", 38),
		},
	}
end
