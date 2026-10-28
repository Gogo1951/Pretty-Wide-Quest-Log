local _, ns = ...

local frame = ns.questLogFrame
local state = ns.questLog

--------------------------------------------------------------------------------
-- Taking over the quest log
--------------------------------------------------------------------------------

--[[
	Mists' quest log is Blizzard's own window. The quest log key goes to this window (Quest-Log-Key.lua).
	Everything else opens Blizzard's through the panel manager: the micro menu button (ToggleQuestLog),
	Questie's tracker, and the objective tracker, which opens just the quest's details in a window of their
	own (QuestLog_OpenToQuest). Out of combat this window takes over from it in the same frame, showing the
	quest it opened to. In combat Blizzard's stays, as hiding it then goes through the panel manager. No
	Blizzard function is replaced (README-Technical: Taint)
]]
local function IsBlizzardQuestLog(panel)
	return panel == QuestLogFrame or panel == QuestLogDetailFrame
end

-- Blizzard's quest log, opening while it's taken over, doesn't close this window as other windows do (Forever-Quest-Log.lua)
function ns.IsTakenOverPanel(panel)
	return ns.questLogTakenOver == true and not InCombatLockdown() and IsBlizzardQuestLog(panel)
end

-- Whether the window was open as ToggleQuestLog() opened Blizzard's, so the micro menu button closes it again
local openBeforeToggle

local function TakeOver(panel)
	local wasOpen = frame:IsShown()
	local shownQuestID = wasOpen and state.selectedQuestID
	HideUIPanel(panel)
	local questID = ns.GetSelectedQuestID()
	if panel == QuestLogDetailFrame and questID and questID == shownQuestID then
		frame:Hide() -- A second click on the same quest in the objective tracker closes it, as Blizzard's does
	elseif questID then
		ns.ShowQuest(questID)
	else
		frame:Show()
	end
	openBeforeToggle = wasOpen
	C_Timer.After(0, function()
		openBeforeToggle = nil
	end)
end

function ns.TakeOverQuestLog()
	ns.RouteQuestLogKey()

	hooksecurefunc("ShowUIPanel", function(panel)
		if panel and panel:IsShown() and ns.IsTakenOverPanel(panel) then
			TakeOver(panel)
		end
	end)

	hooksecurefunc("ToggleQuestLog", function()
		if openBeforeToggle then
			frame:Hide()
		end
		openBeforeToggle = nil
	end)

	--[[
		Questie opens a quest by showing Blizzard's quest log, then draws its details there, which takes the
		quest text back from this window; it's drawn here again a frame later
	]]
	hooksecurefunc("QuestInfo_Display", function(_, parentFrame)
		if parentFrame == QuestLogDetailScrollChildFrame and frame:IsShown() then
			ns.RequestUpdate()
		end
	end)

	ns.questLogTakenOver = true
end
