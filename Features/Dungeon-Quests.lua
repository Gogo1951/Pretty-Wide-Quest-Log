local _, ns = ...
local L = ns.L

--[[
	Every client: on entering a dungeon with a party, tells the party which of your quests still need
	doing there and shares the ones the game lets you share. The announcement goes out once per dungeon
	per group, however many times it's entered or reset. The shares go to each party member once per
	dungeon: everyone on arrival, and anyone who joins later. Both wait until every online party member
	is in range, or ns.DUNGEON_SHARE_MAX_WAIT seconds; WoW Forever hides party range from add-ons, so
	there they go out on arrival. Nothing runs in a raid group, and leaving the group starts over. Which
	dungeon, and which quests are its, is Dungeon-Quest-Lookup.lua's
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

-- The announcement as the messages it sends, for the Options example and the diagnostics reports
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
	menu's pace. A failed share gets the usual whisper (Share-Reminders.lua). The caller waits out a run
	still going
]]
local function Share(quests, dungeon)
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
-- The Party
--------------------------------------------------------------------------------

-- Whether no answer here is a secret value, which WoW Forever can hand back in combat and nothing may test
local function Readable(...)
	if not issecretvalue then
		return true
	end
	for index = 1, select("#", ...) do
		if issecretvalue((select(index, ...))) then
			return false
		end
	end
	return true
end

-- Whether a party member is within range of a share; always on WoW Forever, which hides party range from add-ons
local function IsInRange(unit)
	if ns.FLAVOR == "Camelot" then
		return true
	end
	local inRange, checked = UnitInRange(unit)
	return inRange and checked ~= false and true or false
end

--[[
	The other party members who are online and known, by GUID, each with its unit and whether it's in
	range. A slot the game hasn't filled in yet, as happens around a loading screen, is left out, so it
	never reads as someone leaving and coming back
]]
local function PartyMembers()
	local members = {}
	for index = 1, GetNumSubgroupMembers() do
		local unit = "party" .. index
		local guid, connected = UnitGUID(unit), UnitIsConnected(unit)
		if guid and Readable(guid, connected) and connected then
			members[guid] = { unit = unit, inRange = IsInRange(unit) }
		end
	end
	return members
end

--------------------------------------------------------------------------------
-- What This Group Has Had
--------------------------------------------------------------------------------

-- By dungeon key: whether it was announced, and the party members (by GUID) its quests were shared with
local dungeons = {}

local function DungeonState(key)
	local state = dungeons[key]
	if not state then
		state = { sharedWith = {} }
		dungeons[key] = state
	end
	return state
end

--------------------------------------------------------------------------------
-- In a Dungeon
--------------------------------------------------------------------------------

-- Whether either dungeon feature is on
local function IsEnabled()
	local profile = ns.db.profile
	return profile.enableQualityOfLife and (profile.dungeonAnnounce or profile.dungeonShare)
end

-- The dungeon the player is in with a party, never a raid group, while either feature is on
local function PartyDungeon()
	if not (IsEnabled() and IsInGroup() and not IsInRaid()) then
		return nil
	end
	return ns.CurrentDungeon()
end

local ticker
-- The dungeon being waited in for the party to gather, and since when
local waitKey, waitStart
--[[
	After a login or reload, until the next loading screen: the party in the dungeon counts as already
	served, as it's seen over ns.DUNGEON_LOGIN_GRACE seconds from when the first member shows up, since
	the roster can fill in late after a login
]]
local adoptPending, adoptUntil

local function StopWatching()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
	waitKey, waitStart = nil, nil
end

--[[
	Every ns.DUNGEON_CHECK_INTERVAL seconds in a dungeon with a party. Once every online party member is
	in range (on WoW Forever, at once), or ns.DUNGEON_SHARE_MAX_WAIT seconds after the wait began, the
	dungeon is announced if this group hasn't had it, and its quests are shared if anyone in range hasn't
	had them. Anyone out of range then is shared with once they come in range. A run still going is
	waited out. The checks stop once nothing is left to do; Watch starts them again on a loading screen
	or a change to the group
]]
local function Check()
	local dungeon = PartyDungeon()
	if not dungeon then
		StopWatching()
		return
	end
	local state = DungeonState(dungeon.key)
	local members = PartyMembers()

	-- A login or reload inside a dungeon isn't arriving there: the group most likely had it already
	if adoptPending then
		if next(members) then
			adoptUntil = adoptUntil or GetTime() + ns.DUNGEON_LOGIN_GRACE
		end
		if not adoptUntil or GetTime() < adoptUntil then
			state.announced = true
			for guid in pairs(members) do
				state.sharedWith[guid] = true
			end
			return
		end
		adoptPending, adoptUntil = false, nil
	end

	local profile = ns.db.profile
	local announce = profile.dungeonAnnounce and not state.announced
	local everyoneInRange, waitingFor, newInRange = true, false, {}
	for guid, member in pairs(members) do
		everyoneInRange = everyoneInRange and member.inRange
		if profile.dungeonShare and not state.sharedWith[guid] then
			waitingFor = true
			if member.inRange then
				newInRange[#newInRange + 1] = guid
			end
		end
	end
	if not (announce or waitingFor) then
		StopWatching()
		return
	end
	if waitKey ~= dungeon.key or not waitStart then
		waitKey, waitStart = dungeon.key, GetTime()
	end
	if not everyoneInRange and GetTime() - waitStart < ns.DUNGEON_SHARE_MAX_WAIT then
		return
	end
	local share = #newInRange > 0
	if not (announce or share) then
		-- Only those out of range still need the shares: a fresh wait for them
		waitKey, waitStart = nil, nil
		return
	elseif share and not announce and ns.sharingQuests then
		return
	end

	local quests = ns.DungeonQuests(dungeon)
	if announce then
		state.announced = true
		Announce(quests)
	end
	if share then
		if ns.sharingQuests then
			return
		end
		for _, guid in ipairs(newInRange) do
			state.sharedWith[guid] = true
		end
		Share(quests, dungeon)
	end
	waitKey, waitStart = nil, nil
end

local function Watch()
	if not ticker and PartyDungeon() then
		ticker = C_Timer.NewTicker(ns.DUNGEON_CHECK_INTERVAL, Check)
	end
end

function ns:OnPlayerEnteringWorld(isInitialLogin, isReloadingUi)
	adoptPending, adoptUntil = isInitialLogin or isReloadingUi, nil
	Watch()
end

-- A group formed inside the dungeon
function ns:OnGroupJoined()
	Watch()
end

-- The owner of this file's second handler for an event another file handles too (Core.lua)
ns.dungeonQuests = {}

-- Someone joined, or a raid group became a party; whether anyone new needs the shares is Check's
function ns.dungeonQuests:OnGroupRosterUpdate()
	Watch()
end

function ns:OnGroupLeft()
	dungeons = {}
	StopWatching()
end

--------------------------------------------------------------------------------
-- Sharing Context
--------------------------------------------------------------------------------

--[[
	For the Sharing Context report: whether this group's dungeon was announced, each party member's
	unit, range and whether it has had the shares, and how long the party has been waited for
]]
function ns.DungeonShareStatus(dungeon)
	local state = dungeons[dungeon.key] or { sharedWith = {} }
	local members = {}
	for guid, member in pairs(PartyMembers()) do
		member.shared = state.sharedWith[guid] == true
		members[#members + 1] = member
	end
	table.sort(members, function(a, b)
		return a.unit < b.unit
	end)
	return {
		announced = state.announced == true,
		members = members,
		waited = waitKey == dungeon.key and waitStart and GetTime() - waitStart or nil,
		watching = ticker ~= nil,
	}
end
