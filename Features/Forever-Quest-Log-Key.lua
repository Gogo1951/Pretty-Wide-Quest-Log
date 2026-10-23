local _, ns = ...

local frame = ns.questLogFrame

--------------------------------------------------------------------------------
-- Taking over the quest log
--------------------------------------------------------------------------------

--[[
	Routed to this window only when enableWideQuestLog is on at load; with it off, the world map keeps the
	quest log key. A change to it applies at the next /reload, which the Options window offers on close.
	No Blizzard function is replaced (README-Technical: Taint):

	- The quest log key is bound over, on this window, to a button of the add-on's own, so it never opens
	  the world map, in combat or out. Bindings can't change in combat, so a change then waits for it to end
	- The micro menu button, and anything else calling ToggleQuestLog(), and the objective tracker (and
	  Questie, and a few others) calling QuestMapFrame_OpenToQuestDetails() open Blizzard's map first; out
	  of combat this window takes over from it in the same frame. In combat the map stays, as hiding it then
	  goes through the panel manager
]]
local QUEST_LOG_BINDING = "TOGGLEQUESTLOG"

local toggleButton = CreateFrame("Button", "PrettyWideQuestLogToggleButton", UIParent)
toggleButton:Hide()
toggleButton:SetScript("OnClick", function()
	ns.ToggleQuestLogWindow()
end)

local routePending
local function RouteQuestLogKey()
	if InCombatLockdown() then
		routePending = true
		return
	end
	routePending = nil
	ClearOverrideBindings(frame)
	for _, key in ipairs({ GetBindingKey(QUEST_LOG_BINDING) }) do
		SetOverrideBindingClick(frame, false, key, toggleButton:GetName())
	end
end

-- Whether Blizzard's map is showing and, out of combat, can be closed for this window
local function CanTakeOverFromMap()
	return WorldMapFrame and WorldMapFrame:IsShown() and not InCombatLockdown()
end

function ns.TakeOverQuestLog()
	RouteQuestLogKey()

	hooksecurefunc("ToggleQuestLog", function()
		if CanTakeOverFromMap() then
			HideUIPanel(WorldMapFrame)
			ns.ToggleQuestLogWindow()
		end
	end)

	hooksecurefunc("QuestMapFrame_OpenToQuestDetails", function(questID)
		if questID and C_QuestLog.GetLogIndexForQuestID(questID) and CanTakeOverFromMap() then
			HideUIPanel(WorldMapFrame)
			ns.ShowQuest(questID)
		end
	end)

	ns.questLogTakenOver = true
end

function ns:OnUpdateBindings()
	if ns.questLogTakenOver then
		RouteQuestLogKey()
	end
end

function ns:OnPlayerRegenEnabled()
	if ns.questLogTakenOver and routePending then
		RouteQuestLogKey()
	end
end
