local _, ns = ...

ns.AddWideQuestLogPart(function()
	local L = ns.L

	-- Classic Era and TBC: the quest details (right pane) of Blizzard's widened quest log.

	local LAYOUT = ns.LAYOUT

	--------------------------------------------------------------------------------
	-- Quest details (right pane)
	--------------------------------------------------------------------------------

	-- Beside the list, reaching to the right edge of the parchment
	QuestLogDetailScrollFrame:ClearAllPoints()
	QuestLogDetailScrollFrame:SetPoint(
		"TOPLEFT",
		QuestLogListScrollFrame,
		"TOPRIGHT",
		LAYOUT.DETAIL_LEFT - (LAYOUT.LIST_LEFT + LAYOUT.LIST_WIDTH),
		0
	)
	QuestLogDetailScrollFrame:SetWidth(LAYOUT.PARCHMENT_RIGHT - LAYOUT.DETAIL_LEFT)
	QuestLogDetailScrollChildFrame:SetWidth(LAYOUT.PARCHMENT_RIGHT - LAYOUT.DETAIL_LEFT)

	--[[
		Quest text as wide as two columns of reward buttons, with the same margin of parchment on the left,
		right and top, and the title level with the first quest row of the list. Only the title is anchored
		to the pane; everything else hangs off it
	]]
	QuestLogQuestTitle:SetPoint(
		"TOPLEFT",
		QuestLogDetailScrollChildFrame,
		"TOPLEFT",
		LAYOUT.CONTENT_LEFT - LAYOUT.DETAIL_LEFT,
		-(LAYOUT.CONTENT_TOP - LAYOUT.PANE_TOP)
	)
	ns.SetTextSpacing(QuestLogQuestDescription)
	QuestLogObjectivesText:SetPoint("TOPLEFT", QuestLogQuestTitle, "BOTTOMLEFT", 0, -LAYOUT.TITLE_SPACE_BELOW)
	QuestLogQuestDescription:SetPoint("TOPLEFT", QuestLogDescriptionTitle, "BOTTOMLEFT", 0, -LAYOUT.HEADING_SPACE_BELOW)
	QuestLogRewardTitleText:SetPoint("TOPLEFT", QuestLogQuestDescription, "BOTTOMLEFT", 0, -LAYOUT.HEADING_SPACE_ABOVE)

	--[[
		Quest text at LAYOUT.LINE_HEIGHT, and section headings smaller than the title; the quest log has
		these to itself, so once is enough (objective lines follow the description, in ns.StyleObjective)
	]]
	for _, name in ipairs({
		"QuestLogQuestTitle",
		"QuestLogObjectivesText",
		"QuestLogTimerText",
		"QuestLogQuestDescription",
		"QuestLogItemChooseText",
		"QuestLogItemReceiveText",
		"QuestLogSpellLearnText",
	}) do
		if _G[name] then
			ns.StyleQuestText(_G[name])
		end
	end
	ns.StyleQuestText(QuestLogDescriptionTitle, true)
	ns.StyleQuestText(QuestLogRewardTitleText, true)

	-- Blizzard hangs the Description heading under whatever comes last above it each time; keep its anchor, change the gap
	local function SpaceAboveDescription()
		if QuestLogDescriptionTitle:GetNumPoints() > 0 then
			local point, relativeTo, relativePoint, x = QuestLogDescriptionTitle:GetPoint(1)
			QuestLogDescriptionTitle:SetPoint(point, relativeTo, relativePoint, x, -LAYOUT.HEADING_SPACE_ABOVE)
		end
	end
	for _, name in ipairs({
		"QuestLogQuestTitle",
		"QuestLogObjectivesText",
		"QuestLogTimerText",
		"QuestLogDescriptionTitle",
		"QuestLogQuestDescription",
		"QuestLogRewardTitleText",
		"QuestLogItemChooseText",
	}) do
		if _G[name] then
			_G[name]:SetWidth(LAYOUT.CONTENT_WIDTH)
		end
	end
	local objective = 1
	while _G["QuestLogObjective" .. objective] do
		_G["QuestLogObjective" .. objective]:SetWidth(LAYOUT.CONTENT_WIDTH)
		objective = objective + 1
	end

	-- Gold right-aligned two spaces in from the edge of the text column, like the objective counts
	local function AlignMoney()
		QuestLogMoneyFrame:ClearAllPoints()
		QuestLogMoneyFrame:SetPoint(
			"RIGHT",
			QuestLogItemReceiveText,
			"LEFT",
			LAYOUT.CONTENT_WIDTH + LAYOUT.MONEY_RIGHT_PADDING - ns.TwoSpacesWide(QuestLogQuestDescription),
			0
		)
	end

	--[[
		Objective lines: check, name and a right-aligned count (ns.StyleObjective). The quest log has one line per
		leaderboard entry
	]]
	local function StyleObjectives()
		ns.ClearObjectiveCounts()
		for index = 1, GetNumQuestLeaderBoards() do
			local line = _G["QuestLogObjective" .. index]
			if not line then
				break
			end
			local text, objectiveType, finished = GetQuestLogLeaderBoard(index)
			if line:IsShown() then
				ns.StyleObjective(
					line,
					(text and text ~= "") and text or objectiveType,
					finished,
					LAYOUT.CONTENT_WIDTH,
					QuestLogQuestDescription
				)
			end
		end
	end

	-- The quest chain (Quest-Chain.lua), below the rewards; PlaceQuestID positions it
	local chainSection = ns.CreateQuestChainSection(QuestLogDetailScrollChildFrame)

	--[[
		The quest chain and then the quest ID, right-aligned, under the rewards (or whatever comes last).
		Blizzard hangs a spacer below the last thing in the pane, so they go inside that, made tall enough to
		hold them
	]]
	local questIDText = QuestLogDetailScrollChildFrame:CreateFontString(nil, "ARTWORK", "QuestFontNormalSmall")
	questIDText:SetJustifyH("RIGHT")
	ns.LinkQuestIDToWowhead(QuestLogDetailScrollChildFrame, questIDText, function()
		return select(8, GetQuestLogTitle(GetQuestLogSelection()))
	end)
	QuestLogSpacerFrame:SetHeight(LAYOUT.QUEST_ID_GAP + 20) -- Room for the ID, so it scrolls into view

	local function PlaceQuestID()
		local spacerTop, childTop = QuestLogSpacerFrame:GetTop(), QuestLogDetailScrollChildFrame:GetTop()
		if spacerTop and childTop then
			local top = spacerTop - childTop
			if chainSection:IsShown() then
				chainSection:ClearAllPoints()
				chainSection:SetPoint(
					"TOPLEFT",
					QuestLogDetailScrollChildFrame,
					"TOPLEFT",
					LAYOUT.CONTENT_LEFT - LAYOUT.DETAIL_LEFT,
					top - LAYOUT.HEADING_SPACE_ABOVE
				)
				top = top - LAYOUT.HEADING_SPACE_ABOVE - chainSection:GetHeight()
			end
			questIDText:ClearAllPoints()
			questIDText:SetPoint(
				"TOPRIGHT",
				QuestLogDetailScrollChildFrame,
				"TOPLEFT",
				LAYOUT.CONTENT_LEFT
					+ LAYOUT.CONTENT_WIDTH
					- LAYOUT.DETAIL_LEFT
					- ns.TwoSpacesWide(QuestLogQuestDescription),
				top - LAYOUT.QUEST_ID_GAP
			)
			-- Tall enough for the chain and the ID, so both scroll into view
			QuestLogSpacerFrame:SetHeight(spacerTop - childTop - top + LAYOUT.QUEST_ID_GAP + 20)
			QuestLogDetailScrollFrame:UpdateScrollChildRect()
		end
	end

	--[[
		The pane is written by QuestLog_UpdateQuestDetails() and again while QuestFrameItems_Update()
		rebuilds it, so this follows both
	]]
	local function ShowQuestID()
		local title, _, _, _, _, _, _, questID = GetQuestLogTitle(GetQuestLogSelection())
		if (not title) or not questID then
			questIDText:Hide()
			return
		end
		-- Description's colour: dark on the parchment, white under ElvUI's parchment remover
		ns.StyleQuestID(questIDText, questID, QuestLogQuestDescription)
		questIDText:Show()
		PlaceQuestID()
		C_Timer.After(0, PlaceQuestID) -- Again once the pane's layout has settled
	end

	--[[
		On TBC, a daily quest says when dailies reset, under its title, in the description's font and colour.
		The objectives hang below it while it shows, and below the title otherwise. Classic Era has no daily
		quests, so it never shows there
	]]
	local dailyResetText = QuestLogDetailScrollChildFrame:CreateFontString(nil, "ARTWORK", "QuestFontNormalSmall")
	dailyResetText:SetWidth(LAYOUT.CONTENT_WIDTH)
	dailyResetText:SetJustifyH("LEFT")
	dailyResetText:SetPoint("TOPLEFT", QuestLogQuestTitle, "BOTTOMLEFT", 0, -LAYOUT.TITLE_SPACE_BELOW)
	dailyResetText:Hide()

	local function ShowDailyReset()
		local _, _, _, _, _, _, frequency = GetQuestLogTitle(GetQuestLogSelection())
		local daily = ns.IsDailyFrequency(frequency) and GetQuestResetTime and GetQuestResetTime()
		if daily and daily > 0 then
			local file, size, flags = QuestLogQuestDescription:GetFont()
			if file and size then
				dailyResetText:SetFont(file, size, flags)
			end
			dailyResetText:SetTextColor(QuestLogQuestDescription:GetTextColor())
			dailyResetText:SetText(L["DAILY_RESET"]:format(SecondsToTime(daily)))
			dailyResetText:Show()
			QuestLogObjectivesText:SetPoint("TOPLEFT", dailyResetText, "BOTTOMLEFT", 0, -LAYOUT.DAILY_RESET_SPACE_BELOW)
		else
			dailyResetText:Hide()
			QuestLogObjectivesText:SetPoint("TOPLEFT", QuestLogQuestTitle, "BOTTOMLEFT", 0, -LAYOUT.TITLE_SPACE_BELOW)
		end
	end

	-- Fills the quest chain for the selected quest, before PlaceQuestID positions it
	local function UpdateQuestChain()
		local questID = select(8, GetQuestLogTitle(GetQuestLogSelection()))
		ns.UpdateQuestChainSection(chainSection, questID, QuestLogDescriptionTitle, QuestLogQuestDescription)
	end

	--[[
		Blizzard hangs the first reward button of each section 3px left of the text above it, and the
		reward captions 3px in. Line them all up with the rest of the text, as on WoW Forever, so two
		columns of buttons fill the text column exactly
	]]
	local function IsRewardButton(region)
		local name = region and region.GetName and region:GetName()
		return name and name:find("^QuestLogItem%d+$") ~= nil
	end

	local function Realign(region, offset, unlessAnchoredToButton)
		if (not region) or (not region:IsShown()) or (region:GetNumPoints() < 1) then
			return
		end
		local point, relativeTo, relativePoint, x, y = region:GetPoint(1)
		if unlessAnchoredToButton and IsRewardButton(relativeTo) then
			return -- Buttons further down a section only sit beside or below the one before
		end
		if x and math.abs(x - offset) < 0.01 then
			region:SetPoint(point, relativeTo, relativePoint, 0, y)
		end
	end

	-- The same space under the Rewards heading as under the title and Description, for whichever line comes first
	local function SpaceUnderRewardsHeading(region)
		if region and region:IsShown() and region:GetNumPoints() > 0 then
			local point, relativeTo, relativePoint, x = region:GetPoint(1)
			if relativeTo == QuestLogRewardTitleText then
				region:SetPoint(point, relativeTo, relativePoint, x, -LAYOUT.HEADING_SPACE_BELOW)
			end
		end
	end

	local function AlignRewards()
		AlignMoney()
		Realign(QuestLogItemReceiveText, 3)
		Realign(QuestLogSpellLearnText, 3)
		SpaceUnderRewardsHeading(QuestLogItemChooseText)
		SpaceUnderRewardsHeading(QuestLogItemReceiveText)
		SpaceUnderRewardsHeading(QuestLogSpellLearnText)
		local index = 1
		while _G["QuestLogItem" .. index] do
			Realign(_G["QuestLogItem" .. index], -3, true)
			ns.SpaceAroundRewardButtons(_G["QuestLogItem" .. index])
			index = index + 1
		end
		ns.SpaceAroundRewardButtons(QuestLogItemReceiveText)
		ns.SpaceAroundRewardButtons(QuestLogSpellLearnText)
	end

	--------------------------------------------------------------------------------
	-- Hooks
	--------------------------------------------------------------------------------

	hooksecurefunc("QuestLog_UpdateQuestDetails", function()
		ShowDailyReset()
		SpaceAboveDescription()
		StyleObjectives()
		UpdateQuestChain()
		ShowQuestID()
	end)
	hooksecurefunc("QuestFrameItems_Update", function(questState)
		if questState == "QuestLog" then -- The quest giver window's rewards use it too
			AlignRewards()
			UpdateQuestChain()
			ShowQuestID()
		end
	end)
end)
