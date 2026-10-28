local _, ns = ...

-- WoW Forever and Mists: VoiceOver's play buttons on the quest list's rows.

local LAYOUT = ns.LAYOUT

-- The button sits where the title would start, and the title moves over to clear it
local TITLE_INSET = 22

--[[
	VoiceOver, or its fork Spoken Quests, puts its play buttons on Blizzard's quest list (the map's on WoW
	Forever, the quest log's on Mists), which this window stands in for, so the list puts them on its own
	rows through VoiceOver's own button functions. Buttons of its own, one per quest in the log and reused
	once a quest leaves it, rather than VoiceOver's: Blizzard's list takes those back to its rows whenever
	it redraws
]]
local buttons = {}

-- A button whose quest has left the log, taken off its old quest; nil when every button's quest is still there
local function TakeLeftoverButton()
	for questID, button in pairs(buttons) do
		if not ns.GetLogIndexForQuestID(questID) then
			buttons[questID] = nil
			button:Hide()
			button.row = nil
			return button
		end
	end
end

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
		button = TakeLeftoverButton() or overlay:MakePlayButton(row)
		buttons[questID] = button
	end
	button:SetParent(row)
	button:SetFrameLevel(row:GetFrameLevel() + 2)
	button:ClearAllPoints()
	button:SetPoint("LEFT", row, "LEFT", LAYOUT.QUEST_TEXT_X, 0)

	-- Grayed out for a quest no sound pack has a reading of
	overlay:BindPlayButton(button, questID, ns.GetQuestTitleByID(questID) or "")
	local sound = { event = voiceOver.Enums.SoundEvent.QuestAccept, questID = questID }
	button:SetEnabled(voiceOver.DataModules:PrepareSound(sound) and true or false)
	overlay:SetPlayButtonState(button)

	button.row = row
	row.voiceOverButton = button
	button:Show()
	return TITLE_INSET
end
