local _, ns = ...

--[[
	Every client: when a quest share fails for a reason the party member can fix, a whisper telling them
	which quest it was and asking them to remind you. Each later failure for the same player gets a short
	line naming just the quest, until you next join or leave a group. Failures they can't fix (not
	eligible, already on it, already done) get none. Party only: nothing is whispered in a raid, a
	battleground or an arena.
]]

--------------------------------------------------------------------------------
-- Share Results
--------------------------------------------------------------------------------

-- The game's share results the other player can fix; a client without one skips it
local FIXABLE_RESULTS = {
	"ERR_QUEST_PUSH_BUSY_S",
	"ERR_QUEST_PUSH_TOO_FAR_S",
	"ERR_QUEST_PUSH_LOG_FULL_S",
}

-- A chat line's format string as a pattern catching the player's name where the format has its %s
local function NamePattern(formatString)
	local pattern = formatString:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
	pattern = pattern:gsub("%%%%%d%%%$s", "(.+)"):gsub("%%%%s", "(.+)")
	return "^" .. pattern .. "$"
end

-- The pattern each result this client has matches its chat line with
local resultPatterns = {}
for _, result in ipairs(FIXABLE_RESULTS) do
	local formatString = _G[result]
	if type(formatString) == "string" then
		resultPatterns[#resultPatterns + 1] = NamePattern(formatString)
	end
end

--------------------------------------------------------------------------------
-- The Quest Shared
--------------------------------------------------------------------------------

--[[
	Results name the player but not the quest, so each share is noted as it goes out through
	QuestLogPushQuest, which every way of sharing calls: the log entry it's given (WoW Forever's share
	menus pass one without selecting the quest), or the selected quest when it's given none. A result is
	matched to the last share only within ns.GetShareInterval() of it, the gap Share Quests leaves
	between shares
]]
local lastShare = {}
local whispered = {}

-- The players sent the full whisper since you last joined or left a group; the rest get the short one
local told = {}

local function ForgetTold()
	told = {}
end

-- The owner of this file's handlers for events the dungeon quests handle too (Core.lua)
ns.shareReminders = {}

function ns.shareReminders:OnGroupJoined()
	ForgetTold()
end

function ns.shareReminders:OnGroupLeft()
	ForgetTold()
end

hooksecurefunc("QuestLogPushQuest", function(questLogIndex)
	local questID, title = ns.SharedQuest(questLogIndex)
	if questID and title then
		lastShare.questID, lastShare.title, lastShare.time = questID, title, GetTime()
		whispered = {}
	end
end)

--------------------------------------------------------------------------------
-- Whispers
--------------------------------------------------------------------------------

-- Whispers go out in a party only: never in a raid, a battleground or an arena
local function InPartyOnly()
	if not IsInGroup() or IsInRaid() then
		return false
	end
	local _, instanceType = IsInInstance()
	return instanceType ~= "pvp" and instanceType ~= "arena"
end

--[[
	The party unit a share result names: the result may give the first name alone, which on WoW Forever
	reaches no one, so the whisper goes to the name ns.WhisperTarget gives that member
]]
local function PartyUnitNamed(name)
	local short = Ambiguate(name, "short")
	for index = 1, GetNumSubgroupMembers() do
		local unit = "party" .. index
		local full, first = GetUnitName(unit, true), UnitName(unit)
		if
			ns.IsReadable(full, first)
			and (full == name or first == name or (full and Ambiguate(full, "short") == short))
		then
			return unit
		end
	end
end

function ns:OnChatMsgSystem(message)
	-- During chat lockdown on WoW Forever the system message is secret and can't be read
	if C_ChatInfo.InChatMessagingLockdown() then
		return
	end
	local profile = ns.db.profile
	if not (profile.enableQualityOfLife and profile.shareWhispers and lastShare.time and message) then
		return
	end
	if GetTime() - lastShare.time > ns.GetShareInterval() or not InPartyOnly() then
		return
	end
	for _, pattern in ipairs(resultPatterns) do
		local name = message:match(pattern)
		if name and not whispered[name] then
			local unit = PartyUnitNamed(name)
			local target = unit and ns.WhisperTarget(unit)
			if not target then
				return
			end
			whispered[name] = true
			local whisperKey = told[name] and "WHISPER_SHARE_FAILED_AGAIN" or "WHISPER_SHARE_FAILED"
			told[name] = true
			local reference = ns.ShareWhisperQuestReference(whisperKey, lastShare.questID, lastShare.title)
			ns:Announce("WHISPER", target, whisperKey, reference)
			return
		end
	end
end
