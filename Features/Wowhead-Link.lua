local _, ns = ...
local L = ns.L

-- Every client: a quest ID line that opens the quest's Wowhead address, ready to copy.

--------------------------------------------------------------------------------
-- Wowhead Link
--------------------------------------------------------------------------------

-- The quest's Wowhead address, selected and kept as it is, ready to copy
StaticPopupDialogs.PRETTYWIDEQUESTLOG_WOWHEAD = {
	text = L["WOWHEAD_LINK_COPY"],
	button1 = CLOSE,
	hasEditBox = true,
	editBoxWidth = 280,
	OnShow = function(self, url)
		local editBox = self.GetEditBox and self:GetEditBox() or self.editBox
		editBox:SetText(url)
		editBox:HighlightText()
		editBox:SetFocus()
	end,
	EditBoxOnTextChanged = function(editBox, url)
		if editBox:GetText() ~= url then
			editBox:SetText(url)
			editBox:HighlightText()
		end
	end,
	EditBoxOnEnterPressed = function()
		StaticPopup_Hide("PRETTYWIDEQUESTLOG_WOWHEAD")
	end,
	EditBoxOnEscapePressed = function()
		StaticPopup_Hide("PRETTYWIDEQUESTLOG_WOWHEAD")
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

--[[
	Makes a quest ID line in the quest details or the quest giver window clickable: hovering it says so,
	and clicking it shows the quest's Wowhead address. getQuestID returns the quest it shows, read only
	while the line is showing. Returns the button, for a line that moves to another parent
]]
function ns.LinkQuestIDToWowhead(parent, text, getQuestID)
	if not ns.WOWHEAD_QUEST_URL then
		return
	end
	text.linksToWowhead = true -- StyleQuestID adds the chain link
	local button = CreateFrame("Button", nil, parent)
	button:SetAllPoints(text)
	button:SetScript("OnEnter", function(self)
		if text:IsShown() then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:AddLine(L["WOWHEAD_LINK_TOOLTIP"], ns.GetColorRGB("TEXT"))
			GameTooltip:Show()
		end
	end)
	button:SetScript("OnLeave", GameTooltip_Hide)
	button:SetScript("OnClick", function()
		local questID = text:IsShown() and getQuestID()
		if questID then
			StaticPopup_Show("PRETTYWIDEQUESTLOG_WOWHEAD", nil, nil, ns.WOWHEAD_QUEST_URL .. questID)
		end
	end)
	return button
end
