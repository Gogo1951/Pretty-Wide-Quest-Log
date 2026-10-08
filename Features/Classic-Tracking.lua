local _, ns = ...

-- Classic Era and TBC: tracking or untracking every quest at once, as a shift-click on each would.

--------------------------------------------------------------------------------
-- Track All and Untrack All
--------------------------------------------------------------------------------

-- A quest a shift-click could track: one with objectives that isn't tracked yet
local function IsTrackable(index)
	local isHeader = select(4, GetQuestLogTitle(index))
	return not isHeader and not IsQuestWatched(index) and GetNumQuestLeaderBoards(index) > 0
end

local function HasRoomToTrack()
	return GetNumQuestWatches() < MAX_WATCHABLE_QUESTS
end

-- Whether Track All would track anything: one of the quests (log indexes) is trackable and there's room
function ns.CanTrackMore(indexes)
	if not HasRoomToTrack() then
		return false
	end
	for _, index in ipairs(indexes) do
		if IsTrackable(index) then
			return true
		end
	end
	return false
end

-- Tracks the quests in the order given, the list's, until the watch list is full
function ns.TrackAllQuests(indexes)
	for _, index in ipairs(indexes) do
		if IsTrackable(index) then
			if not HasRoomToTrack() then
				UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0)
				break
			end
			AutoQuestWatch_Insert(index, QUEST_WATCH_NO_EXPIRE)
		end
	end
	QuestWatch_Update()
	QuestLog_Update()
end

-- A quest that reads as tracked, by Blizzard's tracker or by Questie's, which replaces IsQuestWatched
local function IsUntrackable(index)
	local isHeader = select(4, GetQuestLogTitle(index))
	return not isHeader and IsQuestWatched(index) and true or false
end

-- Whether Untrack All would untrack anything: one of the quests (log indexes) reads as tracked
function ns.CanUntrackAny(indexes)
	for _, index in ipairs(indexes) do
		if IsUntrackable(index) then
			return true
		end
	end
	return false
end

--[[
	Untracks every tracked quest in the list (log indexes), whichever tracker has it: Questie hooks
	RemoveQuestWatch to untrack in its own. Blizzard's watch timers forget each one too, as on a shift-click
]]
function ns.UntrackAllQuests(indexes)
	for _, index in ipairs(indexes) do
		if IsUntrackable(index) then
			local questID = GetQuestIDFromLogIndex(index)
			for position = #QUEST_WATCH_LIST, 1, -1 do
				if QUEST_WATCH_LIST[position].id == questID then
					tremove(QUEST_WATCH_LIST, position)
				end
			end
			RemoveQuestWatch(index)
		end
	end
	QuestWatch_Update()
	QuestLog_Update()
end
