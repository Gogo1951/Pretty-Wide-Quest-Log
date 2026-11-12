local _, ns = ...
local L = ns.L

local LAYOUT = ns.LAYOUT

-- Every client: the Share Quests button on a zone name in the quest list, acting through each client's Zone-Actions file.

--------------------------------------------------------------------------------
-- Share Quests
--------------------------------------------------------------------------------

--[[
	One button, moved onto whichever zone name the mouse is over and hidden as the mouse leaves both. Its
	parent is that row, so it hides along with the row too
]]
local button = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
button:SetHeight(LAYOUT.ZONE_SHARE_BUTTON_HEIGHT)
-- In the quest list's copies of the fonts (Fonts.lua), as it sits on the list's zone names
button:SetNormalFontObject(ns.AreaFont("list", "GameFontNormalSmall"))
button:SetHighlightFontObject(ns.AreaFont("list", "GameFontHighlightSmall"))
button:SetDisabledFontObject(ns.AreaFont("list", "GameFontDisableSmall"))
button:SetText(L["SHARE_QUESTS"])
button:Hide()
ns.zoneShareButton = button -- Skinned by Classic-ElvUI.lua

local function Hovered(frame)
	return frame:IsVisible() and frame:IsMouseOver()
end

-- Grayed out while solo and while a share run is still going, kept current while it shows
local function CanShare()
	return IsInGroup() and not ns.sharingQuests
end

button:SetScript("OnUpdate", function(self)
	local enabled = CanShare()
	if self:IsEnabled() ~= enabled then
		self:SetEnabled(enabled)
	end
end)

--[[
	Shares only the zone's quests the game lets you share that someone in the group doesn't have yet
	(ns.PartyNeedsQuest), one every ns.GetShareInterval() seconds. When everyone has them all, it says so
]]
button:SetScript("OnClick", function(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	local zoneTitle = self.zoneTitle
	local shareable = ns.ShareableZoneQuests(zoneTitle)
	local questIDs = #shareable > 0 and ns.QuestsPartyNeeds(shareable) or shareable
	if #questIDs == 0 and #shareable > 0 then
		ns:PrintMessage(L["CHAT_SHARING_ZONE_PARTY_HAS"]:format(zoneTitle))
		return
	end
	ns:PrintMessage(ns.BuildSharePrint(#questIDs, zoneTitle))
	if #questIDs == 0 then
		return
	end
	ns.ShareQuests(questIDs)
	self:SetEnabled(false)
end)

button:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if IsInGroup() then
		GameTooltip_AddNormalLine(GameTooltip, L["SHARE_ZONE_QUESTS_TOOLTIP"]:format(ns.GetShareInterval()), true)
	else
		GameTooltip_SetTitle(GameTooltip, ERR_NOT_IN_GROUP)
	end
	GameTooltip:Show()
end)

button:SetScript("OnLeave", function(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
	if not (self.row and Hovered(self.row)) then
		self:Hide()
	end
end)

-- On a zone name's row as the mouse comes over it, at the row's right edge
function ns.ShowZoneShareButton(row, zoneTitle)
	button.row, button.zoneTitle = row, zoneTitle
	button:SetParent(row)
	button:SetFrameLevel(row:GetFrameLevel() + 3)
	button:ClearAllPoints()
	button:SetPoint("RIGHT", row, "RIGHT", -2, 0)
	button:SetWidth(button:GetTextWidth() + LAYOUT.ZONE_SHARE_BUTTON_PADDING)
	button:SetEnabled(CanShare())
	button:Show()
end

-- As the mouse leaves the row, unless it went onto the button
function ns.HideZoneShareButton(row)
	if button.row == row and not Hovered(button) then
		button:Hide()
	end
end

-- After a row is redrawn for another entry: the button stays only while the row under the mouse is a zone
function ns.UpdateZoneShareButton(row, zoneTitle)
	if zoneTitle and Hovered(row) then
		ns.ShowZoneShareButton(row, zoneTitle)
	elseif button.row == row then
		button:Hide()
	end
end
