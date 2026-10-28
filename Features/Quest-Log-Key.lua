local _, ns = ...

-- WoW Forever and Mists: the quest log key, bound over to the window (Forever-Quest-Log.lua).

--[[
	Routed to the window only when enableWideQuestLog is on at load, by each client's ns.TakeOverQuestLog
	(Forever-Quest-Log-Key.lua, Mists-Quest-Log-Key.lua); with it off, the key opens Blizzard's own quest
	log. A change to it applies at the next /reload, which the Options window offers on close. The key is
	bound over, on the window, to a button of the add-on's own, so it never opens Blizzard's, in combat or
	out. Bindings can't change in combat, so a change then waits for it to end
]]
local QUEST_LOG_BINDING = "TOGGLEQUESTLOG"

local frame = ns.questLogFrame

local toggleButton = CreateFrame("Button", "PrettyWideQuestLogToggleButton", UIParent)
toggleButton:Hide()
toggleButton:SetScript("OnClick", function()
	ns.ToggleQuestLogWindow()
end)

local routePending
function ns.RouteQuestLogKey()
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

function ns:OnUpdateBindings()
	if ns.questLogTakenOver then
		ns.RouteQuestLogKey()
	end
end

function ns:OnPlayerRegenEnabled()
	if ns.questLogTakenOver and routePending then
		ns.RouteQuestLogKey()
	end
end
