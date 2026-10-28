local _, ns = ...

-- Mists: tracking from the window (Forever-Quest-Log.lua, Forever-Quest-List.lua), by quest ID.

--------------------------------------------------------------------------------
-- Tracking, and Questie
--------------------------------------------------------------------------------

--[[
	Mists' watch list goes by quest log index, as Classic Era's does. Questie's tracker, once it has taken
	over, hooks AddQuestWatch and RemoveQuestWatch and replaces IsQuestWatched, so these track and untrack in
	whichever tracker is in charge. Questie's takes every quest with no limit; Blizzard's takes
	MAX_WATCHABLE_QUESTS
]]

-- Every quest can be tracked: no quest is one Questie's tracker can't show
function ns.CanTrack()
	return true
end

--[[
	questLogIndex, where the caller already has it, saves walking the whole log for it; WoW Forever's
	tracking goes by quest ID and ignores it (Forever-Tracking.lua)
]]
function ns.IsTracked(questID, questLogIndex)
	local index = questLogIndex or ns.GetLogIndexForQuestID(questID)
	return index and IsQuestWatched(index) and true or false
end

-- Whether a quest that isn't tracked can be: false once Blizzard's watch list is full
function ns.HasRoomToTrack(questID, questLogIndex)
	return ns.IsTracked(questID, questLogIndex) or ns.IsQuestieTracking() or GetNumQuestWatches() < MAX_WATCHABLE_QUESTS
end

-- Untracking is never refused
function ns.CanRemoveQuestWatch()
	return true
end

local function Untrack(questID)
	local index = ns.GetLogIndexForQuestID(questID)
	if index then
		RemoveQuestWatch(index)
	end
end

-- Returns false, tracking nothing, when Blizzard's watch list is full
local function Track(questID)
	if not ns.HasRoomToTrack(questID) then
		UIErrorsFrame:AddMessage(
			format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS),
			RED_FONT_COLOR.r,
			RED_FONT_COLOR.g,
			RED_FONT_COLOR.b,
			1.0
		)
		return false
	end
	local index = ns.GetLogIndexForQuestID(questID)
	if index then
		AddQuestWatch(index)
	end
	return true
end

--[[
	WatchFrame listens for no event a watch change fires, so it's redrawn here, as Blizzard's own Track button
	does; none of its buttons is secure, so this is safe in combat
]]
local function Redraw()
	WatchFrame_Update()
	ns.RequestUpdate()
end

function ns.ToggleTracking(questID)
	if ns.IsTracked(questID) then
		Untrack(questID)
	else
		Track(questID)
	end
	Redraw()
end

-- Tracks or untracks every quest given, in order, so Track All fills a nearly full watch list from the top of the list down
function ns.SetAllTracked(questIDs, track)
	for _, questID in ipairs(questIDs) do
		if ns.IsTracked(questID) ~= track then
			if not track then
				Untrack(questID)
			elseif not Track(questID) then
				break
			end
		end
	end
	Redraw()
end
