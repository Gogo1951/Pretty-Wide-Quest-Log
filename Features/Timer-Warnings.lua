local _, ns = ...

--[[
	A timed quest's clock lives under the Quest Arrow and in the quest log, where nobody looks mid-fight or
	while the arrow hides in an instance. So a line in the player's own chat, "PWQL // [Need for a Cure] has 5
	minutes left.", as its time left drops to 5 minutes and again to 1 minute.

	The clocks are the ones the Quest Arrow lists under Timer Active! (routes.TimedQuests): quest timers, and
	quest items that run out. A quest that only borrows another quest's clock gets no line of its own, so each
	clock is named once. Each line prints once per run of a clock; a clock first seen already past a mark,
	as after a reload, prints nothing for that mark. Checked every second only while a clock runs
]]

local L = ns.L
local routes = ns.routes

local timerWarnings = {}
ns.timerWarnings = timerWarnings

local CHECK_INTERVAL = 1 -- Seconds between checks while a clock runs
local MARKS = { -- Seconds left at each warning, and its line
	{ seconds = 300, key = "TIMER_WARNING_FIVE" },
	{ seconds = 60, key = "TIMER_WARNING_ONE" },
}

local lastSeconds = {} -- Each running clock's time left at the last check, by quest ID
local ticker

-- The quest as the line names it: Questie's link where it can make one, else its title in brackets
local function QuestReference(questID)
	local title = ns.GetQuestTitleByID(questID)
	local link = routes.QuestLink(questID, nil)
	if link ~= "" and link ~= tostring(questID) then
		return link
	end
	return "[" .. (title or tostring(questID)) .. "]"
end

local function Check()
	local timed, borrowed = routes.TimedQuests()
	borrowed = borrowed or {}
	local running = false
	for questID, seconds in pairs(timed) do
		if not borrowed[questID] and seconds > 0 then
			running = true
			local before = lastSeconds[questID]
			if before then
				for _, mark in ipairs(MARKS) do
					if before > mark.seconds and seconds <= mark.seconds then
						ns:PrintMessage(L[mark.key]:format(QuestReference(questID)))
					end
				end
			end
			lastSeconds[questID] = seconds
		end
	end
	-- A clock that stopped forgets its time, so a new run of it warns again
	for questID in pairs(lastSeconds) do
		local seconds = timed[questID]
		if not seconds or seconds <= 0 or borrowed[questID] then
			lastSeconds[questID] = nil
		end
	end
	if not running and ticker then
		ticker:Cancel()
		ticker = nil
	end
	return running
end

-- Starts the checks when a clock is running and they aren't already
local function Watch()
	if not ticker and Check() then
		ticker = C_Timer.NewTicker(CHECK_INTERVAL, Check)
	end
end

function timerWarnings:OnPlayerEnteringWorld()
	Watch()
end

function timerWarnings:OnQuestLogUpdate()
	Watch()
end

-- A quest item that runs out can start a clock with no quest log change
function timerWarnings:OnBagUpdateDelayed()
	Watch()
end
