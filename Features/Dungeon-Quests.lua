local _, ns = ...
local L = ns.L

--[[
	Every client: on entering a dungeon or raid with a group, tells the group which of your quests still
	need doing there and shares the ones the game lets you share. Each dungeon gets this once per group,
	however many times it's entered or reset; leaving the group starts over. Which dungeon, and which
	quests are its, is Dungeon-Quest-Lookup.lua's
]]

--------------------------------------------------------------------------------
-- Announcement
--------------------------------------------------------------------------------

-- The quests not yet ready to turn in, nor failed
local function QuestsToDo(quests)
	local toDo = {}
	for _, quest in ipairs(quests) do
		if not (quest.isComplete or quest.isFailed) then
			toDo[#toDo + 1] = quest
		end
	end
	return toDo
end

--[[
	The announcement for the dungeon's quests still to do, none when there are none: the first message
	saying how many, then as many more as the quest names need, each a complete message under the chat
	limit and split only between quests, so no link is ever broken. Quests are named as a share whisper
	names them. Each message is ns:Announce's format key and arguments
]]
local function DungeonAnnouncementArguments(dungeonQuests)
	local quests = QuestsToDo(dungeonQuests)
	local count = #quests
	local function Arguments(isFirst, parts)
		local list = table.concat(parts, L["DUNGEON_QUESTS_SEPARATOR"])
		if not isFirst then
			return { "DUNGEON_QUESTS_ANNOUNCE_CONTINUED", list }
		elseif count == 1 then
			return { "DUNGEON_QUESTS_ANNOUNCE_ONE", list }
		end
		return { "DUNGEON_QUESTS_ANNOUNCE", count, list }
	end
	local function Build(isFirst, parts)
		return ns:BuildAnnounceMessage(unpack(Arguments(isFirst, parts)))
	end

	local messages, parts = {}, {}
	for _, quest in ipairs(quests) do
		local reference = ns.FittingQuestReference(function(candidate)
			return Build(#messages == 0 and #parts == 0, { candidate })
		end, quest.questID, quest.title)
		parts[#parts + 1] = reference
		if #parts > 1 and #Build(#messages == 0, parts) > ns.CHAT_MESSAGE_MAX_LENGTH then
			parts[#parts] = nil
			messages[#messages + 1] = Arguments(#messages == 0, parts)
			parts = { reference }
		end
	end
	if #parts > 0 then
		messages[#messages + 1] = Arguments(#messages == 0, parts)
	end
	return messages
end

-- The announcement as the messages it sends, for the Sharing Context report
function ns.BuildDungeonAnnouncement(dungeonQuests)
	local messages = {}
	for _, arguments in ipairs(DungeonAnnouncementArguments(dungeonQuests)) do
		messages[#messages + 1] = ns:BuildAnnounceMessage(unpack(arguments))
	end
	return messages
end

local function Announce(quests)
	-- During chat lockdown on WoW Forever nothing can be sent
	if C_ChatInfo.InChatMessagingLockdown() then
		return
	end
	local channel = ns:GetGroupChatChannel()
	if not channel then
		return
	end
	for _, arguments in ipairs(DungeonAnnouncementArguments(quests)) do
		ns:Announce(channel, nil, unpack(arguments))
	end
end

--------------------------------------------------------------------------------
-- Sharing
--------------------------------------------------------------------------------

--[[
	Shares every quest for the dungeon the game lets you share, ready to turn in or not, at the zone
	menu's pace. A failed share gets the usual whisper (Share-Reminders.lua). Skipped while the zone menu
	is still sharing
]]
local function Share(quests, dungeon)
	if ns.sharingQuests then
		return
	end
	local questIDs = {}
	for _, quest in ipairs(quests) do
		if quest.pushable then
			questIDs[#questIDs + 1] = quest.questID
		end
	end
	if #questIDs == 0 then
		return
	elseif #questIDs == 1 then
		ns:PrintMessage(L["CHAT_SHARING_ZONE_ONE"]:format(dungeon.name))
	else
		ns:PrintMessage(L["CHAT_SHARING_ZONE"]:format(#questIDs, dungeon.name, ns.GetShareInterval()))
	end
	ns.ShareQuests(questIDs)
end

--------------------------------------------------------------------------------
-- Entering a Dungeon
--------------------------------------------------------------------------------

-- Whether either dungeon feature is on
local function IsEnabled()
	local profile = ns.db.profile
	return profile.enableQualityOfLife and (profile.dungeonAnnounce or profile.dungeonShare)
end

-- Dungeons this group has already had, by zone key
local doneZones = {}

-- Whether this group has already had the dungeon the player is in
function ns.IsDungeonDone(dungeon)
	return doneZones[dungeon.key] == true
end

--[[
	Runs ns.DUNGEON_QUESTS_DELAY after arriving, so the group has had a moment to load in too, and only
	if the player is still in the same dungeon, still grouped, and this group hasn't had it yet
]]
local function Run(key)
	local dungeon = ns.CurrentDungeon()
	if not (dungeon and dungeon.key == key and IsInGroup() and IsEnabled()) or ns.IsDungeonDone(dungeon) then
		return
	end
	doneZones[dungeon.key] = true
	local quests = ns.DungeonQuests(dungeon)
	local profile = ns.db.profile
	if profile.dungeonAnnounce then
		Announce(quests)
	end
	if profile.dungeonShare then
		Share(quests, dungeon)
	end
end

local function Schedule()
	local dungeon = ns.CurrentDungeon()
	if dungeon and IsInGroup() and IsEnabled() and not ns.IsDungeonDone(dungeon) then
		C_Timer.After(ns.DUNGEON_QUESTS_DELAY, function()
			Run(dungeon.key)
		end)
	end
end

-- A login or reload inside a dungeon isn't arriving there; the group has most likely had it already
function ns:OnPlayerEnteringWorld(isInitialLogin, isReloadingUi)
	if not (isInitialLogin or isReloadingUi) then
		Schedule()
	end
end

-- A group formed inside the dungeon
function ns:OnGroupJoined()
	Schedule()
end

--------------------------------------------------------------------------------
-- Group Changes
--------------------------------------------------------------------------------

-- The group's other members, by GUID, as last seen
local members = {}

local function CurrentMembers()
	local current = {}
	local prefix, count = "party", GetNumSubgroupMembers()
	if IsInRaid() then
		prefix, count = "raid", GetNumGroupMembers()
	end
	for index = 1, count do
		local unit = prefix .. index
		local guid = UnitGUID(unit)
		if guid and not UnitIsUnit(unit, "player") then
			current[guid] = true
		end
	end
	return current
end

-- Whether anyone joined or left since the roster was last seen
local function RosterChanged()
	local current = CurrentMembers()
	local changed = false
	for guid in pairs(current) do
		changed = changed or not members[guid]
	end
	for guid in pairs(members) do
		changed = changed or not current[guid]
	end
	members = current
	return changed
end

--[[
	A share run for the dungeon again, once the roster has settled: only for a dungeon this group has
	already had, so the first run on arrival is never doubled, and after any run still going
]]
local reshareGeneration = 0

local function Reshare(generation, key)
	if generation ~= reshareGeneration then
		return
	end
	local dungeon = ns.CurrentDungeon()
	local profile = ns.db.profile
	if
		not (dungeon and dungeon.key == key and IsInGroup() and ns.IsDungeonDone(dungeon))
		or not (profile.enableQualityOfLife and profile.dungeonShare)
	then
		return
	end
	if ns.sharingQuests then
		C_Timer.After(ns.DUNGEON_QUESTS_DELAY, function()
			Reshare(generation, key)
		end)
		return
	end
	Share(ns.DungeonQuests(dungeon), dungeon)
end

-- The owner of this file's second handler for an event another file handles too (Core.lua)
ns.dungeonQuests = {}

-- Someone joined or left: the dungeon's quests are shared again ns.DUNGEON_QUESTS_DELAY after the last change
function ns.dungeonQuests:OnGroupRosterUpdate()
	if not RosterChanged() then
		return
	end
	local dungeon = ns.CurrentDungeon()
	if dungeon and IsInGroup() and ns.IsDungeonDone(dungeon) then
		reshareGeneration = reshareGeneration + 1
		local generation = reshareGeneration
		C_Timer.After(ns.DUNGEON_QUESTS_DELAY, function()
			Reshare(generation, dungeon.key)
		end)
	end
end

function ns:OnGroupLeft()
	doneZones = {}
	members = {}
end
