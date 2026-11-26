local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

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
			ns.RefreshSettings()
		end,
	}
end

--------------------------------------------------------------------------------
-- Example Lines
--------------------------------------------------------------------------------

-- The first share-failed whisper, as the party member receives it
local function ShareWhisperExample()
	local quest = ns.SampleQuests()[1]
	return Kit.SentLine("WHISPER", ns.BuildShareWhisper("WHISPER_SHARE_FAILED", quest.questID, quest.title))
end

-- The notice that new party members are missing your zone's quests, as your chat window shows it
local function ZoneShareOfferExample()
	local zone = C_Map.GetAreaInfo(ns.SAMPLE_ZONE_AREA_ID) or tostring(ns.SAMPLE_ZONE_AREA_ID)
	return ns.PrintedExample(ns.BuildZoneShareNotice(#ns.SAMPLE_QUEST_IDS, zone))
end

local function ZoneShareOfferOff()
	return Hidden() or not ns.db.profile.zoneShareOffer
end

--[[
	The notice's sound, a sub-option of its switch on an indented row (Build Reference → Sub-Option Rows), with
	the speaker past the row's end to hear it before turning it on, lined up with every other speaker
]]
local function ZoneShareSoundRow(order)
	return Kit.SubToggleRow(
		order,
		ZoneShareOfferOff,
		{
			type = "toggle",
			name = L["ZONE_SHARE_OFFERS_SOUND"],
			desc = L["ZONE_SHARE_OFFERS_SOUND_DESCRIPTION"],
			get = Kit.Get("profile", "zoneShareOfferSound"),
			set = Kit.Set("profile", "zoneShareOfferSound"),
		},
		Kit.SoundPreview(function()
			ns.PlayZoneShareAlert()
		end)
	)
end

-- The first message of the dungeon announcement, as the group reads it
local function DungeonAnnounceExample()
	return Kit.SentLine("PARTY", ns.BuildDungeonAnnouncement(ns.SampleQuests())[1] or "")
end

-- What sharing an area's quests prints, at the pace the slider sets
local function AreaSharePrintExample(areaID)
	local area = C_Map.GetAreaInfo(areaID) or tostring(areaID)
	return ns.PrintedExample(ns.BuildSharePrint(#ns.SAMPLE_QUEST_IDS, area))
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
	local args = {
		descIntro = Kit.Desc(L["TAB_QUALITY_OF_LIFE_DESCRIPTION"], 1),
		spaceIntro = Kit.Spacer(2),
		enableQualityOfLife = Kit.FeatureSwitch("enableQualityOfLife", 3),

		zoneShareNeedsLog = Kit.StatusLine(ZoneShareNeedsLog, 23.5),
		spaceQuestSharing2 = Kit.Spacer(24, Hidden),
		shareInterval = Kit.LabelRow(25, Hidden, L["SHARE_INTERVAL"], {
			type = "range",
			desc = L["SHARE_INTERVAL_DESCRIPTION"],
			min = ns.SHARE_INTERVAL_MIN,
			max = ns.SHARE_INTERVAL_MAX,
			step = 1,
			get = Kit.Get("profile", "shareInterval"),
			set = Kit.Set("profile", "shareInterval"),
		}),
		shareIntervalExample = ns.OptionsExample(26.5, Hidden, ZoneSharePrintExample),
		spaceShareWhispers = Kit.Spacer(27, Hidden),
		shareWhispers = Toggle("shareWhispers", "SHARE_WHISPERS", 28),
		shareWhisperExample = ns.OptionsExample(29, function()
			return Hidden() or not ns.db.profile.shareWhispers
		end, ShareWhisperExample),
		spaceZoneShareOffer = Kit.Spacer(29.2, Hidden),
		zoneShareOffer = Toggle("zoneShareOffer", "ZONE_SHARE_OFFERS", 29.4),
		zoneShareOfferSoundRow = ZoneShareSoundRow(29.5),
		zoneShareOfferExample = ns.OptionsExample(29.6, ZoneShareOfferOff, ZoneShareOfferExample),

		dungeonAnnounce = Toggle("dungeonAnnounce", "DUNGEON_ANNOUNCE", 35),
		dungeonAnnounceExample = ns.OptionsExample(36, function()
			return Hidden() or not ns.db.profile.dungeonAnnounce
		end, DungeonAnnounceExample),
		spaceDungeonShare = Kit.Spacer(37, Hidden),
		dungeonShare = Toggle("dungeonShare", "DUNGEON_SHARE", 38),
		dungeonShareExample = ns.OptionsExample(39, function()
			return Hidden() or not ns.db.profile.dungeonShare
		end, SharePrintExample),
	}
	Kit.Section(args, "QuestSharing", 20, L["QUEST_SHARING_HEADER"], nil, Hidden)
	args.descQuestSharing = Kit.Desc(L["QUEST_SHARING_INTRO"], 23, Hidden)
	Kit.Section(args, "DungeonQuests", 30, L["DUNGEON_QUESTS_HEADER"], L["DUNGEON_QUESTS_INTRO"], Hidden)
	return { type = "group", name = L["TAB_QUALITY_OF_LIFE"], args = args }
end
