local _, ns = ...

--[[
	WoW Forever and Mists: the window's quest details (right pane), drawn on frames of its own from the quest
	log's data (ns.GetSelectedQuestDetails). Nothing here calls or borrows Blizzard's QuestInfo, which the
	quest giver window and Blizzard's own quest details use
]]

local LAYOUT = ns.LAYOUT
local SPACE = LAYOUT.SPACE
local PANE_TOP = LAYOUT.PANE_TOP
local WIDTH = LAYOUT.CONTENT_WIDTH
local frame = ns.questLogFrame
local state = ns.questLog

--------------------------------------------------------------------------------
-- The Pane
--------------------------------------------------------------------------------

-- Covers the parchment
local detail = CreateFrame("Frame", nil, frame)
detail:SetPoint("TOPLEFT", LAYOUT.PARCHMENT_LEFT, -(PANE_TOP - 2))
detail:SetWidth(LAYOUT.PARCHMENT_RIGHT - LAYOUT.PARCHMENT_LEFT)

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

--------------------------------------------------------------------------------
-- Text
--------------------------------------------------------------------------------

--[[
	The details' text, in the fonts Blizzard's quest details use: the title in QuestTitleFont, the section
	headings in the smaller section heading font (ns.StyleQuestText), the rest in QuestFont, all a text
	column wide with the quest text's line spacing
]]
local function Text(fontObject, sectionHeading)
	local text = detailChild:CreateFontString(nil, "ARTWORK", fontObject)
	text:SetJustifyH("LEFT")
	text:SetWidth(WIDTH)
	ns.StyleQuestText(text, sectionHeading)
	text:Hide()
	return text
end

local titleText = Text("QuestTitleFont")
local objectivesText = Text("QuestFont")
local timerText = Text("QuestFont")
local groupSizeText = Text("QuestFont")
local requiredMoneyText = Text("QuestFont")
local waypointText = Text("QuestFont")
local descriptionHeading = Text("QuestTitleFont", true)
descriptionHeading:SetText(QUEST_DESCRIPTION)
local descriptionText = Text("QuestFont")
local rewardsHeading = Text("QuestTitleFont", true)
rewardsHeading:SetText(QUEST_REWARDS)
local choiceText = Text("QuestFont")
local spellText = Text("QuestFont")
spellText:SetText(REWARD_SPELL)
local receiveText = Text("QuestFont")
local experienceText = Text("QuestFont")
experienceText:SetText(EXPERIENCE_COLON)

-- Gold and experience, right-aligned two spaces in from the right edge of the text column like the objective counts
local function Number()
	local number = detailChild:CreateFontString(nil, "ARTWORK", "QuestFont")
	number:SetJustifyH("RIGHT")
	number:Hide()
	return number
end
local moneyNumber = Number()
local experienceNumber = Number()

-- Objective lines, one per objective, styled by ns.StyleObjective
local objectiveLines = {}
local function ObjectiveLine(index)
	local line = objectiveLines[index]
	if not line then
		line = Text("QuestFont")
		objectiveLines[index] = line
	end
	return line
end

-- The parchment's ink: Blizzard's colors for quest text, light ones while Quest Text Contrast asks for them
local FALLBACK_TEXT_COLOR, FALLBACK_TITLE_COLOR = { 0.18, 0.12, 0.06 }, { 0, 0, 0 }
local FINISHED_COLOR = { 0.2, 0.2, 0.2 } -- A finished objective, as Blizzard grays it on Mists

local function TextColors()
	local lightText = QuestTextContrast and QuestTextContrast.UseLightText and QuestTextContrast.UseLightText()
	local textColor, titleColor
	if GetMaterialTextColors then
		textColor, titleColor = GetMaterialTextColors(lightText and "Stone" or "Default")
	end
	return textColor or FALLBACK_TEXT_COLOR, titleColor or FALLBACK_TITLE_COLOR
end

local function SetColor(region, color)
	region:SetTextColor(color[1], color[2], color[3])
end

--------------------------------------------------------------------------------
-- Reward Buttons
--------------------------------------------------------------------------------

--[[
	Reward buttons of the window's own, two to a row: icon, name in the item's quality color, and count.
	Blizzard's plain LargeItemButtonTemplate gives the look; it has no scripts of its own. Hovering shows
	the reward through the tooltip's own quest log calls, and a modified click links an item in chat
]]
local rewardButtons = {}

local function ShowRewardTooltip(button)
	local reward = button.reward
	if not reward then
		return
	end
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	if reward.kind == "spell" then
		GameTooltip:SetSpellByID(reward.spellID)
	else
		-- These read the quest log's selection, which something else may have moved since
		ns.SelectQuest(state.selectedQuestID)
		if reward.kind == "currency" then
			GameTooltip:SetQuestLogCurrency(reward.tooltipType, reward.tooltipIndex)
		else
			GameTooltip:SetQuestLogItem(reward.tooltipType, reward.tooltipIndex)
		end
	end
	GameTooltip:Show()
end

local function LinkReward(button)
	local reward = button.reward
	if not (reward and reward.kind == "item" and IsModifiedClick()) then
		return
	end
	ns.SelectQuest(state.selectedQuestID)
	local link = GetQuestLogItemLink(reward.tooltipType, reward.tooltipIndex)
	if link then
		HandleModifiedItemClick(link)
	end
end

local function RewardButton(index)
	local button = rewardButtons[index]
	if not button then
		button = CreateFrame("Button", nil, detailChild, "LargeItemButtonTemplate")
		button:SetScript("OnEnter", ShowRewardTooltip)
		button:SetScript("OnLeave", GameTooltip_Hide)
		button:SetScript("OnClick", LinkReward)
		rewardButtons[index] = button
	end
	return button
end

local UNUSABLE_RED, UNUSABLE_GREEN, UNUSABLE_BLUE = 0.9, 0, 0 -- Blizzard's tint for a reward the player can't use

local function FillRewardButton(button, reward)
	button.reward = reward
	button.Icon:SetTexture(reward.texture)
	button.Name:SetText(reward.name or "")
	local quality = reward.quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[reward.quality]
	if quality and reward.quality > 1 then
		button.Name:SetTextColor(quality.r, quality.g, quality.b)
	else
		button.Name:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
	end
	local count = reward.count or 0
	local showCount = (reward.kind == "currency" and count > 0) or count > 1
	button.Count:SetText(showCount and ns.FormatNumber(count) or "")
	if reward.isUsable == false then
		button.Icon:SetVertexColor(UNUSABLE_RED, UNUSABLE_GREEN, UNUSABLE_BLUE)
		button.NameFrame:SetVertexColor(UNUSABLE_RED, UNUSABLE_GREEN, UNUSABLE_BLUE)
	else
		button.Icon:SetVertexColor(1, 1, 1)
		button.NameFrame:SetVertexColor(1, 1, 1)
	end
end

--[[
	An item reward the client hasn't loaded comes back without its name. Each such item asks for its data
	once, and the details are drawn again when it arrives
]]
local itemsAskedFor = {}
local function AskForItem(itemID)
	if itemsAskedFor[itemID] or not (Item and Item.CreateFromItemID) then
		return
	end
	itemsAskedFor[itemID] = true
	Item:CreateFromItemID(itemID):ContinueOnItemLoad(function()
		itemsAskedFor[itemID] = nil
		ns.RequestUpdate()
	end)
end

--------------------------------------------------------------------------------
-- Quest Chain and Quest ID
--------------------------------------------------------------------------------

-- The quest chain (Quest-Chain.lua), shown between the rewards and the quest ID when there is one
local chainSection = ns.CreateQuestChainSection(detailChild)

-- The quest ID, right-aligned under whatever comes last, in the description's color
local questIDRow = CreateFrame("Frame", nil, detailChild)
questIDRow:SetSize(WIDTH, 14)
questIDRow.Text = questIDRow:CreateFontString(nil, "ARTWORK", "QuestFontNormalSmall")
questIDRow.Text:SetPoint("RIGHT")
questIDRow.Text:SetJustifyH("RIGHT")
ns.LinkQuestIDToWowhead(questIDRow, questIDRow.Text, function()
	return state.selectedQuestID
end)

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

--[[
	The pieces go down the column one under another, each so far under the last. height adds up as they
	go, so the scroll child ends a margin under the last piece
]]
local placed, last, height = {}, nil, 0

local function Place(region, gap)
	region:ClearAllPoints()
	if last then
		region:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -gap)
		height = height + gap
	else
		region:SetPoint("TOPLEFT", LAYOUT.CONTENT_LEFT - LAYOUT.PARCHMENT_LEFT, -(LAYOUT.CONTENT_TOP - PANE_TOP))
		height = LAYOUT.CONTENT_TOP - PANE_TOP
	end
	region:Show()
	height = height + region:GetHeight()
	placed[#placed + 1] = region
	last = region
end

-- Text placed only when it has any; returns whether it did
local function PlaceText(region, text, gap)
	if not text or text == "" then
		return false
	end
	region:SetText(text)
	Place(region, gap)
	return true
end

local function HideEverything()
	for _, region in ipairs(placed) do
		region:Hide()
	end
	wipe(placed)
	moneyNumber:Hide()
	experienceNumber:Hide()
	ns.ClearObjectiveCounts()
	last, height = nil, 0
end

--[[
	Reward buttons two to a row, Blizzard's 1px apart side by side, and rows a step apart. The first row
	sits REWARD_BUTTONS_SPACE under the line that introduces it. Returns the next free button
]]
local function PlaceRewardButtons(rewards, nextButton)
	for index, reward in ipairs(rewards) do
		local button = RewardButton(nextButton)
		nextButton = nextButton + 1
		FillRewardButton(button, reward)
		if reward.kind == "item" and not reward.name and reward.itemID then
			AskForItem(reward.itemID)
		end
		if index % 2 == 1 then
			Place(button, index == 1 and LAYOUT.REWARD_BUTTONS_SPACE or SPACE.TIGHT)
		else
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", last, "TOPRIGHT", 1, 0)
			button:Show()
			placed[#placed + 1] = button
		end
	end
	return nextButton
end

--[[
	The Rewards section: what to choose from, spells taught, then what's given whatever is chosen (gold on
	the "You will receive:" line, experience under it, then the items and currencies). Each later part a
	step under the one before, and a blank line's worth between gold and experience when both show
]]
local function PlaceRewards(details)
	local choices, rewards, spells = details.choices, details.rewards, details.spells
	local money, experience = details.money or 0, details.experience or 0
	local hasGiven = #rewards > 0 or money > 0 or experience > 0
	if #choices == 0 and #spells == 0 and not hasGiven then
		return
	end

	Place(rewardsHeading, LAYOUT.HEADING_SPACE_ABOVE)
	local gap = LAYOUT.HEADING_SPACE_BELOW
	local nextButton = 1

	if #choices > 0 then
		PlaceText(choiceText, #choices == 1 and REWARD_ITEMS_ONLY or REWARD_CHOICES, gap)
		nextButton = PlaceRewardButtons(choices, nextButton)
		gap = LAYOUT.REWARD_BUTTONS_SPACE
	end

	if #spells > 0 then
		Place(spellText, gap)
		nextButton = PlaceRewardButtons(spells, nextButton)
		gap = LAYOUT.REWARD_BUTTONS_SPACE
	end

	if hasGiven then
		local also = #choices > 0 or #spells > 0
		PlaceText(receiveText, also and REWARD_ITEMS or REWARD_ITEMS_ONLY, gap)
		local inset = ns.TwoSpacesWide(descriptionText)
		if money > 0 then
			moneyNumber:SetText(GetCoinTextureString(money))
			moneyNumber:SetPoint("TOPRIGHT", receiveText, "TOPLEFT", WIDTH - inset, 0)
			moneyNumber:Show()
		end
		if experience > 0 then
			Place(experienceText, money > 0 and LAYOUT.MONEY_EXPERIENCE_SPACE or SPACE.LINE)
			experienceNumber:SetText(ns.FormatNumber(experience))
			experienceNumber:SetPoint("TOPRIGHT", experienceText, "TOPLEFT", WIDTH - inset, 0)
			experienceNumber:Show()
		end
		nextButton = PlaceRewardButtons(rewards, nextButton)
	end

	for index = nextButton, #rewardButtons do
		rewardButtons[index]:Hide()
		rewardButtons[index].reward = nil
	end
end

-- Objective lines: check, name and a right-aligned count, after WoW Forever's next waypoint when there is one
local function PlaceObjectives(details, textColor)
	local gap = SPACE.GROUP
	if details.waypoint then
		SetColor(waypointText, textColor)
		local waypointFormat = WAYPOINT_OBJECTIVE_FORMAT_OPTIONAL
		PlaceText(waypointText, waypointFormat and waypointFormat:format(details.waypoint) or details.waypoint, gap)
		gap = SPACE.LINE
	end
	for index, objective in ipairs(details.objectives) do
		local line = ObjectiveLine(index)
		SetColor(line, objective.finished and FINISHED_COLOR or textColor)
		ns.StyleObjective(line, objective.text, objective.finished, WIDTH, descriptionText)
		Place(line, gap)
		gap = SPACE.LINE
	end
end

function ns.DisplayQuestDetails(resetScroll)
	detailScroll:SetShown(state.selectedQuestID ~= nil)
	HideEverything()
	if not state.selectedQuestID then
		return
	end

	-- The quest log calls read Blizzard's selection, and the Mists portrait (Mists-Quest-Portrait.lua) reads it after this
	ns.SelectQuest(state.selectedQuestID)
	local details = ns.GetSelectedQuestDetails(state.selectedQuestID)

	if QuestTextContrast and QuestTextContrast.IsEnabled() then
		detail.ContrastBG:SetAtlas(QuestTextContrast.GetDefaultBackgroundAtlas())
		detail.ContrastBG:Show()
	else
		detail.ContrastBG:Hide()
	end
	local textColor, titleColor = TextColors()
	for _, region in ipairs({ titleText, descriptionHeading, rewardsHeading }) do
		SetColor(region, titleColor)
	end
	for _, region in ipairs({
		objectivesText,
		timerText,
		groupSizeText,
		requiredMoneyText,
		descriptionText,
		choiceText,
		spellText,
		receiveText,
		experienceText,
		moneyNumber,
		experienceNumber,
	}) do
		SetColor(region, textColor)
	end

	--[[
		Just the quest's name: Blizzard decorates it with the quest type's icon, and that and the level are
		already in the list
	]]
	local title = details.title or ""
	if details.failed then
		title = QUEST_TITLE_FORMAT_FAILED:format(title)
	end
	PlaceText(titleText, title, 0)
	PlaceText(objectivesText, details.objectivesText, LAYOUT.TITLE_SPACE_BELOW)
	if details.timeLeft then
		PlaceText(timerText, TIME_REMAINING .. " " .. SecondsToTime(details.timeLeft), SPACE.NEAR)
	end
	if details.groupSize > 0 then
		PlaceText(groupSizeText, QUEST_SUGGESTED_GROUP_NUM:format(details.groupSize), SPACE.NEAR)
	end
	if details.requiredMoney > 0 then
		PlaceText(requiredMoneyText, REQUIRED_MONEY .. " " .. GetCoinTextureString(details.requiredMoney), SPACE.NEAR)
	end
	PlaceObjectives(details, textColor)

	if details.description and details.description ~= "" then
		Place(descriptionHeading, LAYOUT.HEADING_SPACE_ABOVE)
		PlaceText(descriptionText, details.description, LAYOUT.HEADING_SPACE_BELOW)
	end

	PlaceRewards(details)

	if ns.UpdateQuestChainSection(chainSection, state.selectedQuestID, descriptionHeading, descriptionText) then
		Place(chainSection, LAYOUT.HEADING_SPACE_ABOVE)
	else
		chainSection:Hide()
	end

	ns.StyleQuestID(questIDRow.Text, state.selectedQuestID, descriptionText)
	questIDRow.Text:ClearAllPoints()
	questIDRow.Text:SetPoint("RIGHT", -ns.TwoSpacesWide(descriptionText), 0)
	Place(questIDRow, LAYOUT.QUEST_ID_GAP)

	detailChild:SetHeight(height + LAYOUT.PAGE_TOP)
	detailScroll:UpdateScrollChildRect()
	if resetScroll then
		detailScroll:SetVerticalScroll(0)
	end
end

function ns.SetQuestDetailsHeight(paneHeight)
	detail:SetHeight(paneHeight)
end
