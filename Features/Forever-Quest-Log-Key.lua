local _, ns = ...

--------------------------------------------------------------------------------
-- Taking over the quest log
--------------------------------------------------------------------------------

--[[
	WoW Forever's quest log is in Blizzard's world map. The quest log key goes to this window
	(Quest-Log-Key.lua). The micro menu button, and anything else calling ToggleQuestLog(), and the
	objective tracker (and Questie, and a few others) calling QuestMapFrame_OpenToQuestDetails() open
	Blizzard's map first; out of combat this window takes over from it in the same frame. Opening the map
	closes this window (Forever-Quest-Log.lua), so ToggleQuestLog() with the window open closes it and the
	map both. In combat the map stays, as hiding it then goes through the panel manager. No Blizzard
	function is replaced (README-Technical: Taint)
]]

-- Whether Blizzard's map is showing and, out of combat, can be closed for this window
local function CanTakeOverFromMap()
	return WorldMapFrame and WorldMapFrame:IsShown() and not InCombatLockdown()
end

-- Only Blizzard's map is taken over from here, never one of its windows (Forever-Quest-Log.lua)
function ns.IsTakenOverPanel()
	return false
end

function ns.TakeOverQuestLog()
	ns.RouteQuestLogKey()

	hooksecurefunc("ToggleQuestLog", function()
		if CanTakeOverFromMap() then
			HideUIPanel(WorldMapFrame)
			if not ns.WasClosedForPanel(WorldMapFrame) then
				ns.ToggleQuestLogWindow()
			end
		end
	end)

	hooksecurefunc("QuestMapFrame_OpenToQuestDetails", function(questID)
		if questID and ns.GetLogIndexForQuestID(questID) and CanTakeOverFromMap() then
			HideUIPanel(WorldMapFrame)
			ns.ShowQuest(questID)
		end
	end)

	ns.questLogTakenOver = true
end
