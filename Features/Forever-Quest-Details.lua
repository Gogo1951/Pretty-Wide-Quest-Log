local _, ns = ...

local LAYOUT = ns.LAYOUT
local PANE_TOP = LAYOUT.PANE_TOP
local frame = ns.questLogFrame
local state = ns.questLog

--------------------------------------------------------------------------------
-- Quest details (right pane)
--------------------------------------------------------------------------------

--[[
	QuestInfo_Display() expects the scroll child's grandparent to carry the quest ID and the seal
	texture, the same arrangement as Blizzard's QuestLogPopupDetailFrame. It covers the parchment
]]
local detail = CreateFrame("Frame", nil, frame)
detail:SetPoint("TOPLEFT", LAYOUT.PARCHMENT_LEFT, -(PANE_TOP - 2))
detail:SetWidth(LAYOUT.PARCHMENT_RIGHT - LAYOUT.PARCHMENT_LEFT)

detail.SealMaterialBG = detail:CreateTexture(nil, "BACKGROUND")
detail.SealMaterialBG:SetAllPoints()
detail.SealMaterialBG:Hide()

-- Shown over the parchment when the accessibility "Quest Text Contrast" option is on
detail.ContrastBG = detail:CreateTexture(nil, "BACKGROUND", nil, -1)
detail.ContrastBG:SetAllPoints()
detail.ContrastBG:Hide()

--[[
	The scroll bar sits in the slot to the right of the parchment. It's the quest list's slim bar, set up
	here rather than taken from ScrollFrameTemplate, whose bar is a different style on each client (wider,
	with round buttons, on Mists)
]]
local detailScroll = CreateFrame("ScrollFrame", nil, detail)
detailScroll:SetPoint("TOPLEFT", 0, -2)
detailScroll:SetPoint("BOTTOMRIGHT", 0, 2)
local detailBar = CreateFrame("EventFrame", nil, detailScroll, "MinimalScrollBar")
local scrollBarX = (LAYOUT.DETAIL_SCROLL_SLOT_X - 4) - LAYOUT.PARCHMENT_RIGHT
detailBar:SetPoint("TOPLEFT", detailScroll, "TOPRIGHT", scrollBarX, -4)
detailBar:SetPoint("BOTTOMLEFT", detailScroll, "BOTTOMRIGHT", scrollBarX, 4)
ScrollUtil.InitScrollFrameWithScrollBar(detailScroll, detailBar)

local detailChild = CreateFrame("Frame", nil, detailScroll)
detailChild:SetSize(LAYOUT.PARCHMENT_RIGHT - LAYOUT.PARCHMENT_LEFT, 300)
detailScroll:SetScrollChild(detailChild)

--[[
	The quest giver window and Blizzard's own quest detail panes use the same QuestInfo elements as this
	one. Taking them while one of those is open would blank it (mid turn-in, say), so wait until it closes
]]
--[[
	Blizzard's own quest log on Mists (QuestLogFrame, and QuestLogDetailFrame when its details pop out on
	their own) and WoW Forever's quest detail popup are the others
]]
local QUEST_INFO_BORROWERS = { QuestFrame, QuestLogPopupDetailFrame, QuestLogFrame, QuestLogDetailFrame }

local function QuestInfoInUseElsewhere()
	for _, borrower in pairs(QUEST_INFO_BORROWERS) do
		if borrower:IsShown() then
			return true
		end
	end
	local mapDetails = QuestMapFrame and QuestMapFrame.DetailsFrame
	return (mapDetails and mapDetails:IsVisible()) and true or false
end

-- The quest ID, right-aligned under the rewards (or whatever comes last), in the description's color
local questIDRow = CreateFrame("Frame", nil, detailChild)
questIDRow:SetSize(LAYOUT.CONTENT_WIDTH, 14)
questIDRow.Text = questIDRow:CreateFontString(nil, "ARTWORK", "QuestFontNormalSmall")
questIDRow.Text:SetPoint("RIGHT")
questIDRow.Text:SetJustifyH("RIGHT")
ns.LinkQuestIDToWowhead(questIDRow, questIDRow.Text, ns.GetSelectedQuestID)

local function QuestInfo_ShowQuestID()
	ns.StyleQuestID(questIDRow.Text, ns.GetSelectedQuestID(), QuestInfoDescriptionText)
	questIDRow.Text:ClearAllPoints()
	questIDRow.Text:SetPoint("RIGHT", -ns.TwoSpacesWide(QuestInfoDescriptionText), 0)
	questIDRow:Show()
	return questIDRow
end

-- The quest chain (Quest-Chain.lua), shown between the rewards and the quest ID when there is one
local chainSection = ns.CreateQuestChainSection(detailChild)
local function QuestInfo_ShowQuestChain()
	local questID = ns.GetSelectedQuestID()
	if ns.UpdateQuestChainSection(chainSection, questID, QuestInfoDescriptionHeader, QuestInfoDescriptionText) then
		return chainSection
	end
end

--[[
	Blizzard's QUEST_TEMPLATE_LOG lays out the description, objectives and rewards in one column, as
	Classic did. A copy of it is placed and spaced to the shared layout, with the quest ID added at the end
]]
local LOG_TEMPLATE = CopyTable(QUEST_TEMPLATE_LOG)
LOG_TEMPLATE.contentWidth = LAYOUT.CONTENT_WIDTH
ns.SetTextSpacing(QuestInfoDescriptionText)
do
	local elements = LOG_TEMPLATE.elements
	for index = 1, #elements, 3 do
		local show = elements[index]
		if show == QuestInfo_ShowTitle then
			elements[index + 1] = LAYOUT.CONTENT_LEFT - LAYOUT.PARCHMENT_LEFT
			elements[index + 2] = -(LAYOUT.CONTENT_TOP - PANE_TOP)
		elseif show == QuestInfo_ShowObjectivesText then
			elements[index + 2] = -LAYOUT.TITLE_SPACE_BELOW
		elseif show == QuestInfo_ShowDescriptionText then
			elements[index + 2] = -LAYOUT.HEADING_SPACE_BELOW
		elseif show == QuestInfo_ShowDescriptionHeader then
			elements[index + 2] = -LAYOUT.HEADING_SPACE_ABOVE
		elseif show == QuestInfo_ShowRewards then
			elements[index + 2] = -(LAYOUT.HEADING_SPACE_ABOVE + LAYOUT.REWARDS_HEADING_RISE)
		end
	end
	for index = 1, #elements, 3 do
		if elements[index] == QuestInfo_ShowSpacer then
			tinsert(elements, index, -LAYOUT.QUEST_ID_GAP)
			tinsert(elements, index, 0)
			tinsert(elements, index, QuestInfo_ShowQuestID)
			break
		end
	end
	for index = 1, #elements, 3 do
		if elements[index] == QuestInfo_ShowQuestID then
			tinsert(elements, index, -LAYOUT.HEADING_SPACE_ABOVE)
			tinsert(elements, index, 0)
			tinsert(elements, index, QuestInfo_ShowQuestChain)
			break
		end
	end
end

-- Gold and experience right-aligned two spaces in from the right edge of a text column width wide, like the objective counts
function ns.AlignRewardNumbers(width)
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

--[[
	The quest giver window and the map's quest details use the same objective lines and reward frames,
	laid out Blizzard's way, so the objective lines go back to Blizzard's font, without this add-on's
	count column, whenever anything else calls QuestInfo_Display. The rest of the text follows the quest
	giver window cleanup (ns.ApplyQuestGiverCleanup). The quest giver window gets the quest details' gold,
	experience and quest ID (Forever-Quest-Giver.lua); the map keeps Blizzard's
]]
local function LayOutSharedPieces(template, parentFrame)
	if parentFrame == detailChild then
		return
	end
	ns.ClearObjectiveCounts()
	for _, line in ipairs(QuestInfoObjectivesFrame.Objectives or {}) do
		local red, green, blue, alpha = line:GetTextColor()
		line:SetFontObject(QuestFontNormalSmall)
		line:SetTextColor(red, green, blue, alpha)
	end
	if ns.LayOutQuestGiverPage(template, parentFrame) then
		return
	end
	local rewardsFrame = QuestInfoRewardsFrame
	rewardsFrame.MoneyFrame:ClearAllPoints()
	rewardsFrame.MoneyFrame:SetPoint("LEFT", rewardsFrame.ItemReceiveText, "RIGHT", 15, 0)
	rewardsFrame.XPFrame.ValueText:ClearAllPoints()
	rewardsFrame.XPFrame.ValueText:SetPoint("LEFT", rewardsFrame.XPFrame.ReceiveText, "RIGHT", 15, 0)
end
hooksecurefunc("QuestInfo_Display", LayOutSharedPieces)

function ns.DisplayQuestDetails(resetScroll)
	detailScroll:SetShown(state.selectedQuestID ~= nil)
	if (not state.selectedQuestID) or QuestInfoInUseElsewhere() then
		return
	end

	ns.SelectQuest(state.selectedQuestID)
	detail.questID = state.selectedQuestID

	if QuestTextContrast and QuestTextContrast.IsEnabled() then
		detail.ContrastBG:SetAtlas(QuestTextContrast.GetDefaultBackgroundAtlas())
		detail.ContrastBG:Show()
	else
		detail.ContrastBG:Hide()
	end

	ns.StyleQuestInfo() -- Again, in case anything restyled the shared text since
	QuestInfo_Display(LOG_TEMPLATE, detailChild)

	-- Mists' quest text sets these two 270 wide whatever the template's width
	QuestInfoDescriptionText:SetWidth(LAYOUT.CONTENT_WIDTH)
	QuestInfoObjectivesText:SetWidth(LAYOUT.CONTENT_WIDTH)

	--[[
		Just the quest's name: Blizzard decorates it with the quest type's icon, and that and the level
		are already in the list
	]]
	local title = ns.GetQuestTitleByID(state.selectedQuestID)
	if title then
		if IsCurrentQuestFailed() and QUEST_TITLE_FORMAT_FAILED then
			title = QUEST_TITLE_FORMAT_FAILED:format(title)
		end
		QuestInfoTitleHeader:SetText(title)
	end

	--[[
		Objective lines: check, name and a right-aligned count. Blizzard's lines follow the leaderboard,
		skipping spell and log objectives, after an optional waypoint line (WoW Forever only)
	]]
	ns.ClearObjectiveCounts()
	local lines = QuestInfoObjectivesFrame.Objectives
	local waypoint = C_QuestLog.GetNextWaypointText and C_QuestLog.GetNextWaypointText(state.selectedQuestID)
	local lineIndex = waypoint and 1 or 0
	for index = 1, GetNumQuestLeaderBoards() do
		local text, objectiveType, finished = GetQuestLogLeaderBoard(index)
		if objectiveType ~= "spell" and objectiveType ~= "log" then
			lineIndex = lineIndex + 1
			local line = lines and lines[lineIndex]
			if line and line:IsShown() then
				ns.StyleObjective(
					line,
					(text and text ~= "") and text or objectiveType,
					finished,
					LAYOUT.CONTENT_WIDTH,
					QuestInfoDescriptionText
				)
			end
		end
	end

	ns.AlignRewardNumbers(LAYOUT.CONTENT_WIDTH) -- See LayOutSharedPieces

	--[[
		The same space under the Rewards heading as under Description. Blizzard hangs the first reward line
		just under the heading and sizes the rewards block to fit, so move that line and grow the block to match
	]]
	local rewards = QuestInfoFrame.rewardsFrame
	local first = rewards and rewards:IsShown() and rewards.activeRewardElements and rewards.activeRewardElements[1]
	if first and first:GetNumPoints() > 0 then
		local point, relativeTo, relativePoint, x = first:GetPoint(1)
		if relativeTo == rewards.Header then
			first:SetPoint(point, relativeTo, relativePoint, x, -LAYOUT.HEADING_SPACE_BELOW)
			rewards:SetHeight(rewards:GetHeight() + LAYOUT.EXTRA_HEADING_GAP)
		end
	end

	-- Reward buttons clear of the text above and below them, again growing the rewards block to match
	if rewards and rewards:IsShown() then
		local moved = 0
		for _, button in ipairs(rewards.RewardButtons or {}) do
			moved = moved + ns.SpaceAroundRewardButtons(button)
		end
		for _, element in ipairs(rewards.activeRewardElements or {}) do
			moved = moved + ns.SpaceAroundRewardButtons(element)
		end
		moved = moved + ns.SpaceAroundRewardButtons(rewards.ItemReceiveText)
		rewards:SetHeight(rewards:GetHeight() + moved)
	end

	--[[
		A blank line between the money and experience lines, again growing the rewards block to match.
		Without money, "You will also receive:" is the experience line's own label, so it stays right under it
	]]
	local experienceFrame = rewards and rewards:IsShown() and rewards.XPFrame
	local hasMoney = rewards and rewards.MoneyFrame and rewards.MoneyFrame:IsShown()
	if hasMoney and experienceFrame and experienceFrame:IsShown() and experienceFrame:GetNumPoints() > 0 then
		local point, relativeTo, relativePoint, x, y = experienceFrame:GetPoint(1)
		if relativeTo == rewards.ItemReceiveText then
			experienceFrame:SetPoint(point, relativeTo, relativePoint, x, y - LAYOUT.QUEST_LINE)
			rewards:SetHeight(rewards:GetHeight() + LAYOUT.QUEST_LINE)
		end
	end

	detailScroll:UpdateScrollChildRect()
	if resetScroll then
		detailScroll:SetVerticalScroll(0)
	end
end

-- Take the QuestInfo elements back once whatever borrowed them closes
local function RequestUpdate()
	ns.RequestUpdate()
end
for _, borrower in pairs(QUEST_INFO_BORROWERS) do
	borrower:HookScript("OnHide", RequestUpdate)
end
if QuestMapFrame and QuestMapFrame.DetailsFrame then
	QuestMapFrame.DetailsFrame:HookScript("OnHide", RequestUpdate)
end

function ns.SetQuestDetailsHeight(height)
	detail:SetHeight(height)
end
