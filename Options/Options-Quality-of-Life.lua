local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

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
	local toggle = Toggle("giverLevels", "SHOW_QUEST_LEVELS", 2)
	toggle.name = ns.OptionsSubLabel(toggle.name)
	toggle.desc = L["GIVER_LEVELS_DESCRIPTION"]:format(ns.LevelTag(40, L["QUEST_SUFFIX_DUNGEON"]))
		.. " "
		.. ns.QuestLevelLegend()
	toggle.width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH
	toggle.hidden = nil
	return toggle
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
	PARTY = { chatType = "PARTY", hex = "AAAAFF", prefix = CHAT_PARTY_GET or "[Party] %s: " },
	WHISPER = { chatType = "WHISPER", hex = "FF80FF", prefix = CHAT_WHISPER_GET or "%s whispers: " },
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
local function RenderSample(formKey, message)
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
local function SampleQuests()
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
local function NoSamples()
	return #ns.SAMPLE_QUEST_IDS == 0
end

-- The first share-failed whisper, as the party member receives it
local function ShareWhisperExample()
	local quest = SampleQuests()[1]
	return RenderSample("WHISPER", ns.BuildShareWhisper("WHISPER_SHARE_FAILED", quest.questID, quest.title))
end

-- The first message of the dungeon announcement, as the group reads it
local function DungeonAnnounceExample()
	return RenderSample("PARTY", ns.BuildDungeonAnnouncement(SampleQuests())[1] or "")
end

-- What sharing an area's quests prints, at the pace the slider sets
local function AreaSharePrintExample(areaID)
	local area = C_Map.GetAreaInfo(areaID) or tostring(areaID)
	return RenderSample("PRINT", L["CHAT_SHARING_ZONE"]:format(#ns.SAMPLE_QUEST_IDS, area, ns.GetShareInterval()))
end

-- Sharing the dungeon's quests, under Automatic Dungeon Quest Sharing
local function SharePrintExample()
	return AreaSharePrintExample(ns.SAMPLE_DUNGEON_AREA_ID)
end

-- Sharing a zone's quests from the zone menu, under the slider, so it reads as pacing those shares too
local function ZoneSharePrintExample()
	return AreaSharePrintExample(ns.SAMPLE_ZONE_AREA_ID or ns.SAMPLE_DUNGEON_AREA_ID)
end

-- An Example under a control, indented as a sub-option and shown only while hidden() is false
local function ExampleRow(order, example, hidden)
	return ns.OptionsSubRow(order, function()
		return hidden() or NoSamples()
	end, {
		example = {
			type = "description",
			name = function()
				return NoSamples() and "" or example()
			end,
			fontSize = "medium",
			width = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH,
			order = 2,
		},
	})
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
				"FEATURE_QUALITY_OF_LIFE_SUMMARY",
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
			giverLevelsRow = ns.OptionsSubRow(16, function()
				return Hidden() or not ns.db.profile.giverCleanup
			end, { giverLevels = GiverLevelsToggle() }),

			spaceQuestSharing0 = ns.OptionsSpacer(20, Hidden),
			headerQuestSharing = ns.OptionsHeader(L["QUEST_SHARING_HEADER"], 21, Hidden),
			spaceQuestSharing1 = ns.OptionsSpacer(22, Hidden),
			descQuestSharing = ns.OptionsDesc(L["QUEST_SHARING_INTRO"], 23, Hidden),
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
			shareIntervalExampleRow = ExampleRow(26.5, ZoneSharePrintExample, Hidden),
			spaceShareWhispers = ns.OptionsSpacer(27, Hidden),
			shareWhispers = Toggle("shareWhispers", "SHARE_WHISPERS", 28),
			shareWhisperExampleRow = ExampleRow(29, ShareWhisperExample, function()
				return Hidden() or not ns.db.profile.shareWhispers
			end),

			spaceDungeonQuests0 = ns.OptionsSpacer(30, Hidden),
			headerDungeonQuests = ns.OptionsHeader(L["DUNGEON_QUESTS_HEADER"], 31, Hidden),
			spaceDungeonQuests1 = ns.OptionsSpacer(32, Hidden),
			descDungeonQuests = ns.OptionsDesc(L["DUNGEON_QUESTS_INTRO"], 33, Hidden),
			spaceDungeonQuests2 = ns.OptionsSpacer(34, Hidden),
			dungeonAnnounce = Toggle("dungeonAnnounce", "DUNGEON_ANNOUNCE", 35),
			dungeonAnnounceExampleRow = ExampleRow(36, DungeonAnnounceExample, function()
				return Hidden() or not ns.db.profile.dungeonAnnounce
			end),
			spaceDungeonShare = ns.OptionsSpacer(37, Hidden),
			dungeonShare = Toggle("dungeonShare", "DUNGEON_SHARE", 38),
			dungeonShareExampleRow = ExampleRow(39, SharePrintExample, function()
				return Hidden() or not ns.db.profile.dungeonShare
			end),
		},
	}
end
