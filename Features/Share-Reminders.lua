local _, ns = ...

--[[
	Every client: when a quest share fails for a reason the party member can fix, a whisper telling them
	which quest it was and asking them to remind you. Failures they can't fix (not eligible, already on it,
	already done) get none.
]]

--------------------------------------------------------------------------------
-- Share Results
--------------------------------------------------------------------------------

-- The game's share results the other player can fix, by the whisper each gets; a client without one skips it
local FIXABLE_RESULTS = {
	{ "ERR_QUEST_PUSH_BUSY_S", "WHISPER_SHARE_BUSY" },
	{ "ERR_QUEST_PUSH_TOO_FAR_S", "WHISPER_SHARE_TOO_FAR" },
	{ "ERR_QUEST_PUSH_LOG_FULL_S", "WHISPER_SHARE_LOG_FULL" },
}

-- A chat line's format string as a pattern catching the player's name where the format has its %s
local function NamePattern(formatString)
	local pattern = formatString:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
	pattern = pattern:gsub("%%%%%d%%%$s", "(.+)"):gsub("%%%%s", "(.+)")
	return "^" .. pattern .. "$"
end

local resultPatterns = {}
for _, result in ipairs(FIXABLE_RESULTS) do
	local formatString = _G[result[1]]
	if type(formatString) == "string" then
		resultPatterns[#resultPatterns + 1] = { pattern = NamePattern(formatString), whisperKey = result[2] }
	end
end

--------------------------------------------------------------------------------
-- The Quest Shared
--------------------------------------------------------------------------------

--[[
	Results name the player but not the quest, so each share is noted as it goes out: the quest selected
	when QuestLogPushQuest runs, which every way of sharing calls. A result is matched to the last share
	only within ns.GetShareInterval() of it, the gap the zone menu leaves between shares
]]
local lastShare = {}
local whispered = {}

local function SelectedQuest()
	if ns.FLAVOR == "Camelot" then
		local questID = C_QuestLog.GetSelectedQuest()
		return questID, questID and C_QuestLog.GetTitleForQuestID(questID)
	end
	local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(GetQuestLogSelection())
	if title and not isHeader then
		return questID, title
	end
end

hooksecurefunc("QuestLogPushQuest", function()
	local questID, title = SelectedQuest()
	if questID and title then
		lastShare.questID, lastShare.title, lastShare.time = questID, title, GetTime()
		whispered = {}
	end
end)

--------------------------------------------------------------------------------
-- Whispers
--------------------------------------------------------------------------------

-- Cuts text to at most maxBytes without splitting a character, the chat limit being in bytes
local function TrimToBytes(text, maxBytes)
	if #text <= maxBytes then
		return text
	end
	local cut = text:sub(1, math.max(maxBytes, 0))
	return (cut:gsub("[\192-\255][\128-\191]*$", ""))
end

--[[
	The ways a whisper can name a quest, best first: Questie's quest link (the game's own, clickable for
	anyone), then Questie's bracketed text, which Questie turns into a link for players who run it
]]
local function QuestReferences(questID)
	local references = {}
	local questieLink = ns.ImportQuestieModule("QuestieLink")
	for _, name in ipairs({ "GetNativeQuestLinkStringById", "GetQuestLinkStringById" }) do
		if questieLink and type(questieLink[name]) == "function" then
			local found, reference = pcall(questieLink[name], questID)
			if found and type(reference) == "string" and reference ~= "" then
				references[#references + 1] = reference
			end
		end
	end
	return references
end

--[[
	How the whisper names a quest: the best way that fits the chat limit; without Questie, or when nothing
	else fits, its title in brackets, shortened if need be, so the whisper is never rejected
]]
function ns.ShareWhisperQuestReference(whisperKey, questID, title)
	for _, reference in ipairs(QuestReferences(questID)) do
		if #ns:BuildAnnounceMessage(whisperKey, reference) <= ns.CHAT_MESSAGE_MAX_LENGTH then
			return reference
		end
	end
	local reference = "[" .. title .. "]"
	local over = #ns:BuildAnnounceMessage(whisperKey, reference) - ns.CHAT_MESSAGE_MAX_LENGTH
	if over > 0 then
		reference = "[" .. TrimToBytes(title, #title - over - 3) .. "...]"
	end
	return reference
end

-- The whisper for a quest, as sent
function ns.BuildShareWhisper(whisperKey, questID, title)
	return ns:BuildAnnounceMessage(whisperKey, ns.ShareWhisperQuestReference(whisperKey, questID, title))
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
	if GetTime() - lastShare.time > ns.GetShareInterval() then
		return
	end
	for _, result in ipairs(resultPatterns) do
		local name = message:match(result.pattern)
		if name and not whispered[name] then
			whispered[name] = true
			local reference = ns.ShareWhisperQuestReference(result.whisperKey, lastShare.questID, lastShare.title)
			ns:Announce("WHISPER", name, result.whisperKey, reference)
			return
		end
	end
end
