local _, ns = ...

--[[
	Classic Era and TBC under ElvUI. ElvUI skins Blizzard's quest log, but not the buttons, map and
	dropdown this add-on adds to it, and its see-through backdrop lets whatever sits behind the window,
	Questie's tracker say, show through the quest text. ElvUI skins the window after this file loads, so the first time the
	window opens this makes the skin's backdrop opaque and styles the add-on's own pieces ElvUI's way.
	Nothing happens without ElvUI or with its quest skin turned off, as the window then has no backdrop
]]

local MAP_GAP = 3 -- Between the window's backdrop and the map's
local MAP_INSET = 2 -- Edge of the map's backdrop to the map inside it

local function GetSkins()
	local E = ElvUI and ElvUI[1]
	return E and E.GetModule and E:GetModule("Skins", true)
end

-- Opaque in the skin's own colour. ElvUI keeps customBackdropAlpha through its colour updates
local function MakeOpaque(frame)
	frame.customBackdropAlpha = 1
	local r, g, b = frame:GetBackdropColor()
	frame:SetBackdropColor(r, g, b, 1)
end

local skinned
QuestLogFrame:HookScript("OnShow", function()
	local backdrop = QuestLogFrame.backdrop
	local skins = (not skinned) and backdrop and GetSkins()
	if not skins then
		return
	end
	skinned = true

	MakeOpaque(backdrop)
	for _, button in ipairs(ns.listButtons) do
		skins:HandleButton(button, true)
	end

	local questMap = ns.questMap
	questMap.holder:SetBackdrop(nil)
	questMap.holder:SetTemplate("Transparent")
	MakeOpaque(questMap.holder)
	skins:HandleButton(questMap.toggleButton, true)
	skins:HandleCloseButton(questMap.closeButton)
	skins:HandleDropDownBox(questMap.zoneDropdown, questMap.zoneDropdown:GetWidth())
	questMap.SetStyle({ edge = backdrop, x = MAP_GAP, top = 0, bottom = 0, inset = MAP_INSET })
end)
