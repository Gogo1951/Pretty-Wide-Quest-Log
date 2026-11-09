local _, ns = ...

--[[
	Every client: what skins (ElvUI) change on the quest giver window, put right while the cleanup is on
	(ns.IsQuestGiverCleanupOn, Quest-Giver.lua): the window's see-through backdrop, and reward names left
	white on the bare parchment. Listed after Quest-Giver.lua, so its pass over a display runs after the
	page is spaced
]]

--[[
	Skins (ElvUI) keep the parchment but draw the window around it see-through, so whatever sits behind
	the window, Questie's tracker or a nameplate, shows through above and below the page. With the cleanup
	on the skin's backdrop is opaque in its own color, and with it off it goes back to the skin's. ElvUI
	puts the backdrop on the window itself on WoW Forever and Mists, and on a frame of its own on Classic
	Era and TBC. A window no skin has touched has neither, and is left alone
]]
local skinAlpha -- The skin's own backdrop alpha, from before this add-on changed it

local function UpdateWindowBackdrop()
	local frame = QuestFrame and (QuestFrame.backdrop or (QuestFrame.template and QuestFrame))
	if not (frame and frame.GetBackdropColor and frame.SetBackdropColor) then
		return
	end
	local r, g, b, a = frame:GetBackdropColor()
	if not r then
		return
	end
	if skinAlpha == nil then
		skinAlpha = a or 1
	end
	if ns.IsQuestGiverCleanupOn() then
		frame.customBackdropAlpha = 1 -- ElvUI keeps it through its color updates
		frame:SetBackdropColor(r, g, b, 1)
	elseif frame.customBackdropAlpha == 1 then
		frame.customBackdropAlpha = nil
		frame:SetBackdropColor(r, g, b, skinAlpha)
	end
end

if QuestFrame then
	-- Skins style the window after this file loads, so it's checked each time the window opens
	QuestFrame:HookScript("OnShow", UpdateWindowBackdrop)
end
ns.UpdateQuestGiverBackdrop = UpdateWindowBackdrop -- For the cleanup switch (Quest-Giver.lua)

--[[
	Reward names, wherever QuestInfo shows rewards while the cleanup is on: the quest giver window, and
	Blizzard's own quest details, which share its buttons. Blizzard draws them white on a dark name plate,
	and skins (ElvUI) that hide the plate leave them white, with a shadow, on the bare parchment. With the
	plate hidden they take the description's color, without the shadow, as the rest of the parchment's
	text does. The buttons are shared, so every display restyles every button it shows. Skins restyle them
	in hooks that may run after this one, so it runs again a frame later. With the cleanup off they go back
	to the color and shadow they had
]]
local namesBefore = {} -- Each name's color and shadow from before this add-on changed them

local function StyleRewardNames(on)
	local rewards = QuestInfoRewardsFrame
	local r, g, b = QuestInfoDescriptionText:GetTextColor()
	for _, button in ipairs(rewards and rewards.RewardButtons or {}) do
		local name = button.Name
		local plateHidden = button.NameFrame and ((not button.NameFrame:IsShown()) or button.NameFrame:GetAlpha() == 0)
		if name and on and plateHidden then
			if not namesBefore[name] then
				namesBefore[name] = { color = { name:GetTextColor() }, shadow = { name:GetShadowColor() } }
			end
			name:SetTextColor(r, g, b)
			name:SetShadowColor(0, 0, 0, 0)
		elseif name and namesBefore[name] then
			name:SetTextColor(unpack(namesBefore[name].color))
			name:SetShadowColor(unpack(namesBefore[name].shadow))
			namesBefore[name] = nil
		end
	end
end

if QuestInfo_Display then
	local namesStyled -- Whether the last display's reward names are styled, for the pass a frame later
	local function StyleRewardNamesLater()
		StyleRewardNames(namesStyled)
	end
	hooksecurefunc("QuestInfo_Display", function()
		namesStyled = ns.IsQuestGiverCleanupOn()
		StyleRewardNames(namesStyled)
		C_Timer.After(0, StyleRewardNamesLater)
	end)
end
