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
	"WHISPER_SHARE_BUSY",
	"WHISPER_SHARE_TOO_FAR",
	"WHISPER_SHARE_LOG_FULL",
}

-- The quest with the longest title in the log, in bytes: its ID and title
local function LongestQuestTitle()
	local longest, longestID = "", nil
	local function Consider(title, questID)
		if title and questID and #title > #longest then
			longest, longestID = title, questID
		end
	end
	if ns.FLAVOR == "Camelot" then
		for index = 1, C_QuestLog.GetNumQuestLogEntries() do
			local entry = C_QuestLog.GetInfo(index)
			if entry and not entry.isHeader then
				Consider(entry.title, entry.questID)
			end
		end
	else
		for index = 1, GetNumQuestLogEntries() do
			local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(index)
			if not isHeader then
				Consider(title, questID)
			end
		end
	end
	return longestID, longest
end

--[[
	Each whisper built for that quest, as sent (with Questie's link where it fits), and its byte length
	against the chat limit; SHORTENED where even the bracketed title had to be cut. Builds strings only
]]
function ns:BuildMessageLengthReport()
	local lines = { GetClientHeader(), "" }
	local questID, title = LongestQuestTitle()
	if not questID then
		lines[#lines + 1] = "No quests in the log: pick up a quest to measure with."
		return table.concat(lines, "\n")
	end
	lines[#lines + 1] = string.format("Longest quest title: %s (%d bytes)", title, #title)
	lines[#lines + 1] = string.format("Chat limit: %d bytes", ns.CHAT_MESSAGE_MAX_LENGTH)
	lines[#lines + 1] = ""
	for _, key in ipairs(SHARE_WHISPER_KEYS) do
		local sent = ns.BuildShareWhisper(key, questID, title)
		local bracketed = ns:BuildAnnounceMessage(key, "[" .. title .. "]")
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
	return table.concat(lines, "\n")
end
