local _, ns = ...

local GetClientHeader = ns.GetDiagnosticClientHeader
local CountKeys = ns.CountDiagnosticKeys
local D = ns.DiagnosticsStrings

--------------------------------------------------------------------------------
-- Locale Context
--------------------------------------------------------------------------------

function ns:BuildLocaleContextReport()
	local lines = { GetClientHeader(), "" }
	lines[#lines + 1] = string.format("GetLocale: %s", tostring(GetLocale()))
	lines[#lines + 1] = string.format("textLocale CVar: %s", tostring(GetCVar("textLocale")))
	lines[#lines + 1] = string.format("audioLocale CVar: %s", tostring(GetCVar("audioLocale")))
	lines[#lines + 1] = string.format("Locale keys (ns.L): %d", CountKeys(ns.L))
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Game Names
--------------------------------------------------------------------------------

--[[
    One line per ns.DIAGNOSTIC_NAME_LOOKUPS row: the name this client returns
    through the row's own lookup, or NIL. A row with a request function names
    something that loads late, so the report asks for it and polls with
    Validate Data's cadence before settling it as NIL. Every timer carries the
    run's generation, so Stop retires the chain.
]]
local NAME_POLL_SECONDS = 0.5
local NAME_REASK_POLLS = 3
local NAME_MAX_IDLE_POLLS = 12

local nameRun = { generation = 0 }

-- The row's name, or nil and the message when its lookup throws.
local function ReadName(row)
	local ok, name = pcall(row.lookup)
	if not ok then
		return nil, tostring(name)
	end
	if name == nil or tostring(name) == "" then
		return nil, nil
	end
	return tostring(name), nil
end

-- Line breaks shown as a literal \n, and pipes escaped so links paste as text.
local function ShownText(text)
	local shown = text:gsub("\r?\n", "\\n")
	shown = shown:gsub("|", "||")
	return shown
end

local function PendingRows()
	local pending = {}
	for _, row in ipairs(ns.DIAGNOSTIC_NAME_LOOKUPS) do
		if row.request and not ReadName(row) then
			pending[#pending + 1] = row
		end
	end
	return pending
end

local function RequestRows(rows)
	for _, row in ipairs(rows) do
		pcall(row.request)
	end
end

local function FinishNames(run)
	local lines = { GetClientHeader(), "" }
	local missing = 0
	for _, row in ipairs(ns.DIAGNOSTIC_NAME_LOOKUPS) do
		local name, problem = ReadName(row)
		if not name then
			missing = missing + 1
		end
		lines[#lines + 1] = string.format(
			"[%s] %s (%s %s): %s",
			name and "OK" or "NIL",
			row.constant,
			row.kind,
			tostring(row.id),
			ShownText(name or problem or "")
		)
	end
	local onFinish = run.onFinish
	run.onFinish = nil
	if onFinish then
		onFinish(
			table.concat(lines, "\n"),
			missing == 0 and D.NAMES_ALL_FOUND or string.format(D.NAMES_SOME_NIL, missing)
		)
	end
end

local function ScheduleNames(run, delay, step)
	local generation = run.generation
	C_Timer.After(delay, function()
		if run.generation ~= generation then
			return
		end
		local ok, problem = pcall(step, run)
		if not ok then
			local onFinish = run.onFinish
			run.onFinish = nil
			run.generation = run.generation + 1
			if onFinish then
				onFinish(nil, nil, tostring(problem))
			end
		end
	end)
end

local function PollNames(run)
	local pending = PendingRows()
	if #pending == 0 then
		FinishNames(run)
		return
	end
	if #pending < run.pendingCount then
		run.pendingCount = #pending
		run.idlePolls = 0
	else
		run.idlePolls = run.idlePolls + 1
	end
	if run.idlePolls >= NAME_MAX_IDLE_POLLS then
		FinishNames(run)
		return
	end
	if run.idlePolls > 0 and run.idlePolls % NAME_REASK_POLLS == 0 then
		RequestRows(pending)
	end
	ScheduleNames(run, NAME_POLL_SECONDS, PollNames)
end

--[[
    onFinish(text, note) receives the finished report and its status note, or
    onFinish(nil, nil, problem) when a step threw. A stopped run never calls it.
]]
function ns:StartNameLookupReport(onFinish)
	nameRun.generation = nameRun.generation + 1
	nameRun.onFinish = onFinish
	nameRun.idlePolls = 0
	local pending = PendingRows()
	nameRun.pendingCount = #pending
	if #pending == 0 then
		ScheduleNames(nameRun, 0, FinishNames)
		return
	end
	RequestRows(pending)
	ScheduleNames(nameRun, NAME_POLL_SECONDS, PollNames)
end

function ns:StopNameLookupReport()
	nameRun.generation = nameRun.generation + 1
	nameRun.onFinish = nil
end

--------------------------------------------------------------------------------
-- Message Length
--------------------------------------------------------------------------------

-- The whispers a failed quest share sends (Share-Reminders.lua), by locale key
local SHARE_WHISPER_KEYS = {
	"WHISPER_SHARE_FAILED",
	"WHISPER_SHARE_FAILED_AGAIN",
}

-- The longest channel prefix Zone Info writes before its Ask for Shares line (Zone-Info.lua's LFG_CHANNEL)
local ASK_CHANNEL_PREFIX = "/4 "

--[[
	The quest with the longest title in the log, in bytes: its ID and title, and how many zones went
	uncounted. Read through ns.DiagnosticLogQuests, which never opens a zone or selects a quest, so a
	zone collapsed in Blizzard's log (Classic Era, TBC and Mists) lists none of its quests
]]
local function LongestQuestTitle()
	local longest, longestID = "", nil
	local quests, collapsed = ns.DiagnosticLogQuests()
	for _, quest in ipairs(quests) do
		if quest.title and quest.questID and #quest.title > #longest then
			longest, longestID = quest.title, quest.questID
		end
	end
	return longestID, longest, collapsed
end

--[[
	Each whisper built for that quest, as sent (with Questie's link where it fits), and its byte length
	against the chat limit; SHORTENED where even the bracketed title had to be cut. Then each message of
	the dungeon announcement, OVER past the limit. Builds strings only
]]
function ns:BuildMessageLengthReport()
	local lines = { GetClientHeader(), "" }
	local questID, title, collapsed = LongestQuestTitle()
	local uncounted = collapsed > 0 and string.format(" (not counting %d collapsed zones)", collapsed) or ""
	if not questID then
		lines[#lines + 1] = "No quests in the log"
			.. uncounted
			.. ": pick up a quest, or open its zone in the quest log, to measure with."
		return table.concat(lines, "\n")
	end
	lines[#lines + 1] = string.format("Longest quest title: %s (%d bytes)%s", title, #title, uncounted)
	lines[#lines + 1] = string.format("Chat limit: %d bytes", ns.CHAT_MESSAGE_MAX_LENGTH)
	lines[#lines + 1] = ""
	for _, key in ipairs(SHARE_WHISPER_KEYS) do
		local sent = ns.BuildShareWhisper(key, questID, title)
		local bracketed = ns:BuildWhisperMessage(key, "[" .. title .. "]")
		local linked = sent:find("|H", 1, true) ~= nil
		local status = (not linked and #bracketed > ns.CHAT_MESSAGE_MAX_LENGTH) and "SHORTENED" or "OK"
		lines[#lines + 1] = string.format(
			"[%s] %s: %d bytes, %s",
			status,
			key,
			#sent,
			linked and "with Questie's quest link" or "with the title in brackets"
		)
		lines[#lines + 1] = "    " .. ShownText(sent)
	end

	-- Every quest still to do in the log, announced as one dungeon's: the most the announcement can carry
	local messages = ns.BuildDungeonAnnouncement((ns.DiagnosticLogQuests()))
	lines[#lines + 1] = ""
	lines[#lines + 1] =
		string.format("Dungeon announcement naming every quest to do in the log: %d messages", #messages)
	for _, message in ipairs(messages) do
		lines[#lines + 1] = string.format(
			"[%s] DUNGEON_QUESTS_ANNOUNCE: %d bytes",
			#message > ns.CHAT_MESSAGE_MAX_LENGTH and "OVER" or "OK",
			#message
		)
		lines[#lines + 1] = "    " .. ShownText(message)
	end

	--[[
		Zone Info's Ask for Shares line naming every quest in the log as shareable and nobody in the party on it,
		with room for the longest channel prefix Zone-Info.lua writes before it ("/4 "). The builder names only
		the quests that fit, so the count shows how many a full line holds
	]]
	local askQuests = {}
	for _, quest in ipairs((ns.DiagnosticLogQuests())) do
		if quest.questID and quest.title then
			askQuests[#askQuests + 1] = { questID = quest.questID, name = quest.title, shareable = true }
		end
	end
	local room = ns.CHAT_MESSAGE_MAX_LENGTH - #ASK_CHANNEL_PREFIX
	local ask = ns.BuildAskForSharesMessage(askQuests, room, function()
		return 0
	end)
	lines[#lines + 1] = ""
	if not ask then
		lines[#lines + 1] = "Ask for Shares: no line, as no quest fits"
	else
		-- Every way the builder names a quest carries its title
		local named = 0
		for _, quest in ipairs(askQuests) do
			if ask:find(quest.name, 1, true) then
				named = named + 1
			end
		end
		lines[#lines + 1] = string.format(
			"[%s] ZONE_INFO_ASK_MESSAGE: %d bytes of %d after the channel prefix, %d of %d quests named",
			#ask > room and "OVER" or "OK",
			#ask,
			room,
			named,
			#askQuests
		)
		lines[#lines + 1] = "    " .. ShownText(ask)
	end
	return table.concat(lines, "\n")
end
