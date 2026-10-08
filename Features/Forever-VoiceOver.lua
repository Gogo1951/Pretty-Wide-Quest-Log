local _, ns = ...

-- WoW Forever: VoiceOver's play buttons on the quest list's rows.

local LAYOUT = ns.LAYOUT

-- The button sits where the title would start, and the title moves over to clear it
local TITLE_INSET = 22

--[[
	Spoken Quests puts its play buttons on the map's quest list, which this window stands in for, so the
	list puts them on its own rows through Spoken's own button functions. Buttons of its own, one per
	quest, rather than Spoken's: the map's list takes those back to its rows whenever it redraws
]]
local buttons = {}

local function GetOverlay()
	local voiceOver = ns.GetVoiceOver()
	local overlay = voiceOver and voiceOver.QuestOverlayUI
	if overlay and overlay.MakePlayButton and overlay.BindPlayButton and overlay.SetPlayButtonState then
		return overlay, voiceOver
	end
end

--[[
	Rows are recycled, so a row lets go of its button before it's set up again. Only if the button is
	still on it: another row may have taken it for the same quest already
]]
function ns.HideVoiceOverButton(row)
	local button = row.voiceOverButton
	if button and button.row == row then
		button:Hide()
		button.row = nil
	end
	row.voiceOverButton = nil
end

-- Puts the quest's play button on its row; returns how far the title moves right to clear it, 0 without one
function ns.ShowVoiceOverButton(row, questID)
	local overlay, voiceOver = GetOverlay()
	if not overlay then
		return 0
	end

	local button = buttons[questID]
	if not button then
		button = overlay:MakePlayButton(row)
		buttons[questID] = button
	end
	button:SetParent(row)
	button:SetFrameLevel(row:GetFrameLevel() + 2)
	button:ClearAllPoints()
	button:SetPoint("LEFT", row, "LEFT", LAYOUT.QUEST_TEXT_X, 0)

	-- Greyed out for a quest no sound pack has a reading of
	overlay:BindPlayButton(button, questID, C_QuestLog.GetTitleForQuestID(questID) or "")
	local sound = { event = voiceOver.Enums.SoundEvent.QuestAccept, questID = questID }
	button:SetEnabled(voiceOver.DataModules:PrepareSound(sound) and true or false)
	overlay:SetPlayButtonState(button)

	button.row = row
	row.voiceOverButton = button
	button:Show()
	return TITLE_INSET
end
