local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Tracking, and Questie
--------------------------------------------------------------------------------

-- While Questie's tracker is in charge, a quest counts as tracked only if it shows there (README-Technical).
local questieTracker

-- A repaint asks for every quest, so Questie's quest log is read once a frame
local questieLog, questieLogAcceptances, questieLogTime
local function QuestieLog()
	local now = GetTime()
	if questieLogTime ~= now then
		questieLog, questieLogAcceptances = ns.QuestieLogEntries()
		questieLogTime = now
	end
	return questieLog, questieLogAcceptances
end

--[[
	Whether Questie can show the quest: since Questie 12.6.3 an entry has the quest under .quest only when
	Questie's database knows it, as routes.QuestLog reads it; before, any entry is a quest
]]
local function QuestieKnows(log, acceptances, questID)
	local entry = log[questID]
	if acceptances then
		return type(entry) == "table" and type(entry.quest) == "table"
	end
	return entry ~= nil
end

--[[
	Returns Questie's tracker if it's in charge of this quest, false if it's in charge but can't show
	the quest, or nil if Blizzard's tracker is in charge
]]
local function TrackerFor(questID)
	if not (Questie and Questie.db and Questie.db.profile and Questie.db.profile.trackerEnabled) then
		return nil
	end
	questieTracker = questieTracker or ns.ImportQuestieModule("QuestieTracker")
	local log, acceptances = QuestieLog()
	if not (questieTracker and type(questieTracker.IsTrackedByQuestie) == "function" and log) then
		return nil
	end
	return QuestieKnows(log, acceptances, questID) and questieTracker or false
end

function ns.CanTrack(questID)
	return TrackerFor(questID) ~= false
end

function ns.IsTracked(questID)
	local tracker = TrackerFor(questID)
	if tracker then
		local found, tracked = pcall(tracker.IsTrackedByQuestie, questID)
		if found then
			return tracked and true or false
		end
		return QuestUtils_IsQuestWatched(questID)
	elseif tracker == false then
		return false
	end
	return QuestUtils_IsQuestWatched(questID)
end

function ns.QuestieCannotShowText(questID)
	return L["QUESTIE_CANNOT_SHOW"]:format(GetQuestLink(questID) or C_QuestLog.GetTitleForQuestID(questID) or questID)
end

-- Whether a quest that isn't tracked can be: false once Blizzard's watch list is full
function ns.HasRoomToTrack(questID)
	return QuestUtils_IsQuestWatched(questID)
		or C_QuestLog.GetNumQuestWatches() < Constants.QuestWatchConsts.MAX_QUEST_WATCHES
end

-- Whether a watch can be taken off the watch list now: the game refuses at times
function ns.CanRemoveQuestWatch()
	return QuestUtil.CanRemoveQuestWatch()
end

local function Untrack(questID, tracker)
	if
		tracker
		and not QuestUtils_IsQuestWatched(questID)
		and type(tracker.UntrackQuestId) == "function"
		and pcall(tracker.UntrackQuestId, tracker, questID)
	then
		return
	end
	if ns.CanRemoveQuestWatch() then
		ns.TrackerTaintStep("Untrack", C_QuestLog.RemoveQuestWatch, questID) -- Also untracks it in Questie
	end
end

-- Returns false, tracking nothing, when Blizzard's watch list is full
local function Track(questID)
	if not ns.HasRoomToTrack(questID) then
		UIErrorsFrame:AddMessage(OBJECTIVES_WATCH_TOO_MANY, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, 1.0)
		return false
	end
	-- Adding a watch that already exists is harmless, and is what tells Questie to track it
	ns.TrackerTaintStep("Track", C_QuestLog.AddQuestWatch, questID)
	return true
end

-- Changing the watch list from add-on code in combat taints the objective tracker, so it waits for combat to end
local function RefusedInCombat()
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, 1.0)
		return true
	end
	return false
end

local warnedUntrackable = {}
function ns.ToggleTracking(questID)
	if RefusedInCombat() then
		return
	end
	local tracker = TrackerFor(questID)
	if tracker == false then
		if not warnedUntrackable[questID] then
			warnedUntrackable[questID] = true
			ns:PrintMessage(ns.QuestieCannotShowText(questID))
		end
		UIErrorsFrame:AddMessage(L["QUESTIE_CANNOT_TRACK"], RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, 1.0)
		return
	end

	if ns.IsTracked(questID) then
		Untrack(questID, tracker)
	else
		Track(questID)
	end
	ns.RequestUpdate()
end

--[[
	Tracks or untracks every quest given, in order, so Track All fills a nearly full watch list from the
	top of the list down. Quests Questie can't track are skipped without a word
]]
function ns.SetAllTracked(questIDs, track)
	if RefusedInCombat() then
		return
	end
	for _, questID in ipairs(questIDs) do
		local tracker = TrackerFor(questID)
		if tracker ~= false and ns.IsTracked(questID) ~= track then
			if not track then
				Untrack(questID, tracker)
			elseif not Track(questID) then
				break
			end
		end
	end
	ns.RequestUpdate()
end
