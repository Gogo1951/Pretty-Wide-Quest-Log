local _, ns = ...

-- Classic Era and TBC: keeps VoiceOver's play buttons in the quest list on the quests the sorted rows show.

--------------------------------------------------------------------------------
-- Title Padding
--------------------------------------------------------------------------------

--[[
	VoiceOver puts its play button over the start of the title, so with it loaded each title starts with
	enough spaces to clear the button (as VoiceOver pads it). Spaces only: a tab draws as a missing glyph
	in some fonts, ElvUI's among them
]]
local voiceOverPadding
local function VoiceOverPadding(text)
	if not voiceOverPadding then
		for count = 1, 20 do
			text:SetText(string.rep(" ", count))
			if text:GetStringWidth() >= 24 then
				voiceOverPadding = text:GetText()
				break
			end
		end
		voiceOverPadding = voiceOverPadding or "  "
	end
	return voiceOverPadding
end

-- What goes in front of a quest title in the list: the padding while VoiceOver's buttons are on, nothing otherwise
function ns.VoiceOverTitlePrefix(text)
	if not ns.GetVoiceOver() then
		return ""
	end
	return VoiceOverPadding(text)
end

--------------------------------------------------------------------------------
-- Play Buttons
--------------------------------------------------------------------------------

--[[
	VoiceOver gives row i the play button of quest log entry i + offset, Blizzard's order. With sorting on,
	the row shows a different entry, so the buttons are dealt out again by what each row shows, through
	VoiceOver's own button functions
]]
function ns.MatchVoiceOverButtons(order)
	local voiceOver = order and ns.GetVoiceOver()
	local overlay = voiceOver and voiceOver.QuestOverlayUI
	if not (overlay and overlay.displayedButtons) then
		return
	end
	local getTitle = voiceOver.GetQuestLogTitle -- VoiceOver's own wrapper where it has one, else Blizzard's
	for _, button in pairs(overlay.displayedButtons) do
		button:Hide()
	end
	wipe(overlay.displayedButtons)

	local offset = FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
	for i = 1, QUESTS_DISPLAYED do
		local row, index = _G["QuestLogTitle" .. i], order[offset + i]
		local title, isHeader, questID
		if index and row:IsShown() then
			local entry = { getTitle(index) }
			title, isHeader, questID = entry[1], entry[4], entry[8]
		end
		if questID and not isHeader then
			if not overlay.questPlayButtons[questID] then
				overlay:CreatePlayButton(questID)
			end
			local button = overlay.questPlayButtons[questID]
			local text, check = row.Text, _G["QuestLogTitle" .. i .. "Check"]
			local sound = { event = voiceOver.Enums.SoundEvent.QuestAccept, questID = questID }
			if voiceOver.DataModules:PrepareSound(sound) then
				overlay:UpdatePlayButton(title, questID, row, text, check)
				button:Enable()
			else
				overlay:UpdateQuestTitle(row, button, text, check)
				button:Disable()
			end
			button:Show()
			overlay:UpdatePlayButtonTexture(questID)
			tinsert(overlay.displayedButtons, button)
		end
	end
end

--------------------------------------------------------------------------------
-- Hooks
--------------------------------------------------------------------------------

--[[
	VoiceOver restyles the rows from its own QuestLog_Update hook, which can run after the list's, so restyle
	again after it. Hooked whether or not its quest log part is on yet, as that's read from saved settings
]]
local voiceOverOverlay = type(VoiceOver) == "table" and rawget(VoiceOver, "QuestOverlayUI")
if voiceOverOverlay and voiceOverOverlay.Update then
	hooksecurefunc(voiceOverOverlay, "Update", ns.UpdateClassicQuestList)
end
