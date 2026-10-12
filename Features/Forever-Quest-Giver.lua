local _, ns = ...

-- WoW Forever: the quest giver window's gold, experience and quest ID, laid out like the quest details.

local LAYOUT = ns.LAYOUT

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

local function IsOn(region, page)
	local parent = region:GetParent()
	while parent and parent ~= page do
		parent = parent:GetParent()
	end
	return parent == page
end

--[[
	The last of the page's pieces Blizzard showed, which the quest ID goes under. A piece left showing
	from the quest details (the spacer, say) is on the quest log, not this page, so it doesn't count
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
	After anything else calls QuestInfo_Display: on a quest giver page, the quest details' gold,
	experience and quest ID. Returns whether it was one
]]
function ns.LayOutQuestGiverPage(template, parentFrame)
	local width = template and template.contentWidth
	if ns.IsQuestGiverPage(parentFrame) and width and ns.IsQuestGiverCleanupOn() then
		ns.AlignRewardNumbers(width)
		ShowQuestGiverID(parentFrame, width)
		return true
	end
	questGiverID:Hide()
	return false
end
