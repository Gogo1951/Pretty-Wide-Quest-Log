local _, ns = ...
local L = ns.L

-- While the Quality of Life switch at the top of the panel is off, every setting under it is hidden
local function Hidden()
	return not ns.db.profile.enableQualityOfLife
end

-- A zone's Share Quests button is part of the wide quest log, so a line under the sharing intro says so while it's off
local function ZoneShareNeedsLog()
	if not Hidden() and not ns.db.profile.enableWideQuestLog then
		return L["ZONE_SHARE_NEEDS_WIDE_LOG"]
	end
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
			ns.ApplyQualityOfLifeSettings()
		end,
	}
end

--------------------------------------------------------------------------------
-- Example Lines
--------------------------------------------------------------------------------

-- The first share-failed whisper, as the party member receives it
local function ShareWhisperExample()
	local quest = ns.SampleQuests()[1]
	return ns.RenderSample("WHISPER", ns.BuildShareWhisper("WHISPER_SHARE_FAILED", quest.questID, quest.title))
end

-- The notice that new party members are missing your zone's quests, as your chat window shows it
local function ZoneShareOfferExample()
	local zone = C_Map.GetAreaInfo(ns.SAMPLE_ZONE_AREA_ID) or tostring(ns.SAMPLE_ZONE_AREA_ID)
	return ns.RenderSample("PRINT", ns.BuildZoneShareNotice(#ns.SAMPLE_QUEST_IDS, zone))
end

local function ZoneShareOfferOff()
	return Hidden() or not ns.db.profile.zoneShareOffer
end

--[[
	The notice's sound, on an indented row under its toggle (Build Reference → Sub-Option Rows), with the
	client's voice-chat speaker beside it to hear it before turning it on, as Good to Go's restock reminder
	does. An execute with an image renders as an icon, so its label rides in desc
]]
local function ZoneShareSoundRow(order)
	return ns.OptionsSubRow(order, ZoneShareOfferOff, {
		sound = {
			type = "toggle",
			name = ns.OptionsSubLabel(L["ZONE_SHARE_OFFERS_SOUND"]),
			desc = L["ZONE_SHARE_OFFERS_SOUND_DESCRIPTION"],
			order = 2,
			get = function()
				return ns.db.profile.zoneShareOfferSound
			end,
			set = function(_, value)
				ns.db.profile.zoneShareOfferSound = value
			end,
		},
		preview = {
			type = "execute",
			name = "",
			desc = L["ZONE_SHARE_SOUND_PREVIEW"],
			image = "Interface\\Common\\VoiceChat-Speaker",
			imageWidth = 16,
			imageHeight = 16,
			width = 0.15,
			order = 3,
			func = function()
				ns.PlayZoneShareAlert()
			end,
		},
	})
end

-- The first message of the dungeon announcement, as the group reads it
local function DungeonAnnounceExample()
	return ns.RenderSample("PARTY", ns.BuildDungeonAnnouncement(ns.SampleQuests())[1] or "")
end

-- What sharing an area's quests prints, at the pace the slider sets
local function AreaSharePrintExample(areaID)
	local area = C_Map.GetAreaInfo(areaID) or tostring(areaID)
	return ns.RenderSample("PRINT", ns.BuildSharePrint(#ns.SAMPLE_QUEST_IDS, area))
end

-- Sharing the dungeon's quests, under Automatic Dungeon Quest Sharing
local function SharePrintExample()
	return AreaSharePrintExample(ns.SAMPLE_DUNGEON_AREA_ID)
end

-- Sharing a zone's quests with Share Quests, under the slider, so it reads as pacing those shares too
local function ZoneSharePrintExample()
	return AreaSharePrintExample(ns.SAMPLE_ZONE_AREA_ID)
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
				ns.ApplyQualityOfLifeSettings
			),

			spaceQuestSharing0 = ns.OptionsSpacer(20, Hidden),
			headerQuestSharing = ns.OptionsHeader(L["QUEST_SHARING_HEADER"], 21, Hidden),
			spaceQuestSharing1 = ns.OptionsSpacer(22, Hidden),
			descQuestSharing = ns.OptionsDesc(L["QUEST_SHARING_INTRO"], 23, Hidden),
			zoneShareNeedsLog = ns.OptionsStatusLine(ZoneShareNeedsLog, 23.5),
			spaceQuestSharing2 = ns.OptionsSpacer(24, Hidden),
			shareIntervalLabel = ns.OptionsRowLabel(
				L["SHARE_INTERVAL"],
				25,
				nil,
				Hidden,
				L["SHARE_INTERVAL_DESCRIPTION"]
			),
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
			shareIntervalExampleRow = ns.OptionsExampleRow(26.5, ZoneSharePrintExample, Hidden),
			spaceShareWhispers = ns.OptionsSpacer(27, Hidden),
			shareWhispers = Toggle("shareWhispers", "SHARE_WHISPERS", 28),
			shareWhisperExampleRow = ns.OptionsExampleRow(29, ShareWhisperExample, function()
				return Hidden() or not ns.db.profile.shareWhispers
			end),
			spaceZoneShareOffer = ns.OptionsSpacer(29.2, Hidden),
			zoneShareOffer = Toggle("zoneShareOffer", "ZONE_SHARE_OFFERS", 29.4),
			zoneShareOfferSoundRow = ZoneShareSoundRow(29.5),
			zoneShareOfferExampleRow = ns.OptionsExampleRow(29.6, ZoneShareOfferExample, ZoneShareOfferOff),

			spaceDungeonQuests0 = ns.OptionsSpacer(30, Hidden),
			headerDungeonQuests = ns.OptionsHeader(L["DUNGEON_QUESTS_HEADER"], 31, Hidden),
			spaceDungeonQuests1 = ns.OptionsSpacer(32, Hidden),
			descDungeonQuests = ns.OptionsDesc(L["DUNGEON_QUESTS_INTRO"], 33, Hidden),
			spaceDungeonQuests2 = ns.OptionsSpacer(34, Hidden),
			dungeonAnnounce = Toggle("dungeonAnnounce", "DUNGEON_ANNOUNCE", 35),
			dungeonAnnounceExampleRow = ns.OptionsExampleRow(36, DungeonAnnounceExample, function()
				return Hidden() or not ns.db.profile.dungeonAnnounce
			end),
			spaceDungeonShare = ns.OptionsSpacer(37, Hidden),
			dungeonShare = Toggle("dungeonShare", "DUNGEON_SHARE", 38),
			dungeonShareExampleRow = ns.OptionsExampleRow(39, SharePrintExample, function()
				return Hidden() or not ns.db.profile.dungeonShare
			end),
		},
	}
end
