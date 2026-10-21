local _, ns = ...

-- Every client: the tracking mark in front of each quest in the list, and whether Questie's tracker has taken over.

--------------------------------------------------------------------------------
-- Tracking Mark
--------------------------------------------------------------------------------

--[[
	Questie's tracker takes over tracking a few seconds after login, once Questie's startup reaches it.
	Until then every quest reads as untracked, which would flash an eye on every row with markUntracked
	on. So while it's pending no marks are drawn, and the quest log redraws the moment it starts
]]
local questieTracker, redrawOnTrackerStart
local function IsQuestieTrackerPending()
	if not (Questie and Questie.db and Questie.db.profile and Questie.db.profile.trackerEnabled) then
		return false
	end
	questieTracker = questieTracker or ns.ImportQuestieModule("QuestieTracker")
	if not questieTracker or questieTracker.started then
		return false
	end
	if not redrawOnTrackerStart and type(questieTracker.HookBaseTracker) == "function" then
		redrawOnTrackerStart = true
		hooksecurefunc(questieTracker, "HookBaseTracker", function()
			if ns.wideQuestLogActive then
				ns.RefreshQuestLog()
			end
		end)
	end
	return true
end

-- Whether Questie's tracker has taken over tracking (it replaces IsQuestWatched and AutoQuestWatch_Insert's effect)
function ns.IsQuestieTracking()
	if not (Questie and Questie.db and Questie.db.profile and Questie.db.profile.trackerEnabled) then
		return false
	end
	questieTracker = questieTracker or ns.ImportQuestieModule("QuestieTracker")
	return questieTracker and questieTracker.started and true or false
end

--[[
	Draws the tracking mark for a quest in its slot texture: the check when it's tracked, or with
	markUntracked on, the crossed-out eye when it isn't. Hidden otherwise, and while Questie's tracker
	is still starting up
]]
function ns.ShowTrackingMark(texture, isTracked)
	local markUntracked = ns.db and ns.db.profile.markUntracked
	local mark = markUntracked and ns.TRACKING_MARKS.untracked or ns.TRACKING_MARKS.tracked
	texture:SetTexture(mark.texture)
	texture:SetVertexColor(ns.HexToRGB(mark.color))
	texture:SetShown(
		(isTracked and true or false) ~= (markUntracked and true or false) and not IsQuestieTrackerPending()
	)
end
