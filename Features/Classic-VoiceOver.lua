local _, ns = ...

-- Classic Era and TBC: keeps VoiceOver's play buttons in the quest list on the quests the sorted rows show.

ns.AddWideQuestLogPart(function()
	--------------------------------------------------------------------------------
	-- Title Padding
	--------------------------------------------------------------------------------

	--[[
		VoiceOver puts its play button over the start of the title, so with it loaded each title starts with
		enough spaces to clear the button (as VoiceOver pads it). Spaces only: a tab draws as a missing glyph
		in some fonts, ElvUI's among them. Measured once per font and size, so a font the player picks later
		gets its own
	]]
	local voiceOverPadding = {}
	local function VoiceOverPadding(text)
		local file, size = text:GetFont()
		local font = tostring(file) .. ":" .. tostring(size)
		if not voiceOverPadding[font] then
			local padding = "  "
			for count = 1, 20 do
				text:SetText(string.rep(" ", count))
				if text:GetStringWidth() >= 24 then
					padding = text:GetText()
					break
				end
			end
			voiceOverPadding[font] = padding
		end
		return voiceOverPadding[font]
	end

	-- What goes in front of a quest title in the list: the padding while VoiceOver's buttons are on (isOn), nothing otherwise
	function ns.VoiceOverTitlePrefix(text, isOn)
		if not isOn then
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
	-- Whether every part of VoiceOver dealing the buttons calls is there, so an update of it that renames one only leaves the buttons alone
	local OVERLAY_FUNCTIONS = { "CreatePlayButton", "UpdatePlayButton", "UpdateQuestTitle", "UpdatePlayButtonTexture" }
	local function CanDealButtons(voiceOver, overlay)
		if
			not (
				type(overlay) == "table"
				and type(overlay.displayedButtons) == "table"
				and type(overlay.questPlayButtons) == "table"
				and type(voiceOver.GetQuestLogTitle) == "function"
				and type(voiceOver.Enums) == "table"
				and type(voiceOver.Enums.SoundEvent) == "table"
				and voiceOver.Enums.SoundEvent.QuestAccept ~= nil
				and type(voiceOver.DataModules) == "table"
				and type(voiceOver.DataModules.PrepareSound) == "function"
			)
		then
			return false
		end
		for _, name in ipairs(OVERLAY_FUNCTIONS) do
			if type(overlay[name]) ~= "function" then
				return false
			end
		end
		return true
	end

	function ns.MatchVoiceOverButtons(order)
		local voiceOver = order and ns.GetVoiceOver()
		local overlay = voiceOver and voiceOver.QuestOverlayUI
		if not CanDealButtons(voiceOver, overlay) then
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
				local _
				title, _, _, isHeader, _, _, _, questID = getTitle(index)
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
		VoiceOver restyles the rows from its own QuestLog_Update hook, which can run after the list's, so its play
		buttons and the row styling are redone after it, with the order the list's update built. Hooked whether or
		not its quest log part is on yet, as that's read from saved settings
	]]
	local voiceOverOverlay = type(VoiceOver) == "table" and rawget(VoiceOver, "QuestOverlayUI")
	if voiceOverOverlay and voiceOverOverlay.Update then
		hooksecurefunc(voiceOverOverlay, "Update", function()
			ns.RestyleClassicQuestRows()
		end)
	end
end)
