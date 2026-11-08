local _, ns = ...

-- WoW Forever and Mists: the quest giver window's gold, experience and quest ID, laid out like the quest details.

local LAYOUT = ns.LAYOUT

-- Gold and experience right-aligned two spaces in from the right edge of a text column width wide, like the objective counts
local function AlignRewardNumbers(width)
	local rewardsFrame = QuestInfoRewardsFrame
	local right = width - ns.TwoSpacesWide(QuestInfoDescriptionText)
	rewardsFrame.MoneyFrame:ClearAllPoints()
	rewardsFrame.MoneyFrame:SetPoint(
		"RIGHT",
		rewardsFrame.ItemReceiveText,
		"LEFT",
		right + LAYOUT.MONEY_RIGHT_PADDING,
		0
	)
	rewardsFrame.XPFrame.ValueText:ClearAllPoints()
	rewardsFrame.XPFrame.ValueText:SetPoint("RIGHT", rewardsFrame.XPFrame, "LEFT", right, 0)
end

-- Gold and experience back where Blizzard puts them, beside their labels
local function RestoreRewardNumbers()
	local rewardsFrame = QuestInfoRewardsFrame
	rewardsFrame.MoneyFrame:ClearAllPoints()
	rewardsFrame.MoneyFrame:SetPoint("LEFT", rewardsFrame.ItemReceiveText, "RIGHT", 15, 0)
	rewardsFrame.XPFrame.ValueText:ClearAllPoints()
	rewardsFrame.XPFrame.ValueText:SetPoint("LEFT", rewardsFrame.XPFrame.ReceiveText, "RIGHT", 15, 0)
end

--------------------------------------------------------------------------------
-- Quest Giver
--------------------------------------------------------------------------------

--[[
	The quest giver window gets the quest ID too, right-aligned under its last section the way the quest
	details have it. It lives on whichever of the window's pages is showing
]]
local questGiverID = QuestDetailScrollChildFrame:CreateFontString(nil, "ARTWORK")
questGiverID:SetJustifyH("RIGHT")
-- Its Wowhead button follows it from page to page
local questGiverIDButton = ns.LinkQuestIDToWowhead(QuestDetailScrollChildFrame, questGiverID, GetQuestID)
-- Room under it, so scrolled to the bottom it sits clear of the page's edge
local questGiverIDRoom = ns.CreateRoomBelow(QuestDetailScrollChildFrame, questGiverID)

local function IsOn(region, page)
	local parent = region:GetParent()
	while parent and parent ~= page do
		parent = parent:GetParent()
	end
	return parent == page
end

--[[
	The last of the page's pieces Blizzard showed, which the quest ID goes under. A piece left showing
	from Blizzard's own quest details (the spacer, say) is on that window, not this page, so it doesn't count
]]
local LAST_PIECES = {
	"QuestInfoSpacerFrame",
	"QuestInfoRewardsFrame",
	"QuestInfoObjectivesText",
	"QuestInfoRewardText",
	"QuestInfoDescriptionText",
}
local function LastShown(page)
	for _, name in ipairs(LAST_PIECES) do
		local region = _G[name]
		if region and region:IsShown() and IsOn(region, page) then
			return region
		end
	end
end

local function ShowQuestGiverID(parentFrame, width)
	local questID = GetQuestID()
	local above = LastShown(parentFrame)
	if (not questID) or (questID == 0) or not above then
		questGiverID:Hide()
		return
	end
	questGiverID:SetParent(parentFrame)
	questGiverIDRoom:SetParent(parentFrame)
	if questGiverIDButton then
		questGiverIDButton:SetParent(parentFrame)
	end
	ns.StyleQuestID(questGiverID, questID, QuestInfoDescriptionText)
	questGiverID:ClearAllPoints()
	questGiverID:SetPoint(
		"TOPRIGHT",
		above,
		"BOTTOMLEFT",
		width - ns.TwoSpacesWide(QuestInfoDescriptionText),
		-LAYOUT.QUEST_ID_GAP
	)
	questGiverID:Show()
	local scrollFrame = parentFrame:GetParent()
	if scrollFrame and scrollFrame.UpdateScrollChildRect then
		scrollFrame:UpdateScrollChildRect() -- So the quest ID scrolls into view
	end
end

--[[
	After anything calls QuestInfo_Display: on a quest giver page with the cleanup on, the quest details'
	gold, experience and quest ID. Anywhere else (Blizzard's own quest details, or a quest giver page with
	the cleanup off) the gold and experience go back to Blizzard's places. Returns whether it was a styled
	quest giver page
]]
function ns.LayOutQuestGiverPage(template, parentFrame)
	local width = template and template.contentWidth
	if ns.IsQuestGiverPage(parentFrame) and width and ns.IsQuestGiverCleanupOn() then
		AlignRewardNumbers(width)
		ShowQuestGiverID(parentFrame, width)
		return true
	end
	questGiverID:Hide()
	RestoreRewardNumbers()
	return false
end
hooksecurefunc("QuestInfo_Display", function(template, parentFrame)
	ns.LayOutQuestGiverPage(template, parentFrame)
end)
