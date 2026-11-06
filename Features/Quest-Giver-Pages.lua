local _, ns = ...

--[[
	Every client: the quest giver window's greeting page, its quest lines tagged with their levels and
	spaced on the scale, and its progress page, with the quest ID under it. Both follow the quest giver
	window cleanup (Quest-Giver.lua)
]]

local TagQuestLine = ns.TagQuestLine

--------------------------------------------------------------------------------
-- The quest giver's greeting page
--------------------------------------------------------------------------------

--[[
	The quest giver window's greeting page, for a quest giver with quests and nothing else to say. Its
	quest lines are named buttons on Classic Era and TBC, and pooled ones on WoW Forever. Each button's ID
	indexes the active or available quests, as isActive says
]]
local function GreetingQuestButtons()
	local pool = QuestFrameGreetingPanel.titleButtonPool
	if pool then
		local buttons = {}
		for button in pool:EnumerateActive() do
			buttons[#buttons + 1] = button
		end
		return buttons
	end
	local buttons, index = {}, 1
	while _G["QuestTitleButton" .. index] do
		buttons[#buttons + 1] = _G["QuestTitleButton" .. index]
		index = index + 1
	end
	return buttons
end

local function TagGreetingQuests()
	if not (GetActiveLevel and GetAvailableLevel) then
		return
	end
	for _, button in ipairs(GreetingQuestButtons()) do
		if button:IsShown() then
			local index = button:GetID()
			local level, questID
			if button.isActive == 1 then
				level, questID = GetActiveLevel(index), GetActiveQuestID and GetActiveQuestID(index)
			else
				level = GetAvailableLevel(index)
				questID = GetAvailableQuestInfo and select(5, GetAvailableQuestInfo(index))
			end
			if TagQuestLine(button, level, questID) then
				button:SetHeight(math.max(button:GetTextHeight() + 2, button.Icon and button.Icon:GetHeight() or 0))
			end
		end
	end
end

--[[
	The greeting page on the spacing scale (LAYOUT.SPACE): the greeting PAGE_TOP down the page, the
	Current Quests and Available Quests headings a section under it, each list's first quest line a
	heading's space under its heading, and the lines QUEST_LINE_SPACE apart. Between the two lists
	Blizzard puts a break 32px tall (hidden by skins such as ElvUI, but still holding its place), which
	becomes the whole section's space, its line in the middle. Blizzard anchors everything but the
	greeting afresh each time the page shows, so only the greeting needs putting back with the cleanup off
]]
local greetingBlizzardY

local function SetSpaceAbove(region, space)
	local point, relativeTo, relativePoint, x = region:GetPoint(1)
	region:SetPoint(point, relativeTo, relativePoint, x, -space)
end

local function SpaceGreetingPage()
	local greeting = GreetingText
	if not (greeting and greeting:GetNumPoints() > 0) then
		return
	end
	if greetingBlizzardY == nil then
		greetingBlizzardY = select(5, greeting:GetPoint(1))
	end
	if not ns.IsQuestGiverCleanupOn() then
		SetSpaceAbove(greeting, -greetingBlizzardY)
		return
	end
	local LAYOUT = ns.LAYOUT
	SetSpaceAbove(greeting, LAYOUT.PAGE_TOP)

	local divider = QuestGreetingFrameHorizontalBreak
	local hasGreeting = (greeting:GetText() or "") ~= ""
	local headings = {}
	for _, heading in ipairs({ CurrentQuestsText, AvailableQuestsText }) do
		if heading and heading:IsShown() and heading:GetNumPoints() > 0 then
			headings[heading] = true
			local relativeTo = select(2, heading:GetPoint(1))
			if relativeTo == greeting then
				SetSpaceAbove(heading, hasGreeting and LAYOUT.HEADING_SPACE_ABOVE or 0)
			elseif divider and relativeTo == divider and divider:GetNumPoints() > 0 then
				SetSpaceAbove(divider, 0)
				SetSpaceAbove(heading, 0)
			end
		end
	end
	for _, button in ipairs(GreetingQuestButtons()) do
		if button:IsShown() and button:GetNumPoints() > 0 then
			local relativeTo = select(2, button:GetPoint(1))
			SetSpaceAbove(button, headings[relativeTo] and LAYOUT.HEADING_SPACE_BELOW or LAYOUT.QUEST_LINE_SPACE)
		end
	end
end

local function SetUpGreetingPage()
	TagGreetingQuests()
	SpaceGreetingPage()
end

if QuestFrameGreetingPanel then
	-- Blizzard runs the page's setup from its OnShow script, and calls it directly when the page is already open
	QuestFrameGreetingPanel:HookScript("OnShow", SetUpGreetingPage)
	if QuestFrameGreetingPanel_OnShow then
		hooksecurefunc("QuestFrameGreetingPanel_OnShow", SetUpGreetingPage)
	end
end

--------------------------------------------------------------------------------
-- The quest giver's progress page
--------------------------------------------------------------------------------

--[[
	The page that asks for a quest's required items is drawn with its own pieces on every client, not
	QuestInfo. It gets the quest details' space around its "Required items:" heading, and the quest ID
	right-aligned under the last thing on it
]]
local progressPage = QuestProgressScrollChildFrame
if progressPage and QuestFrameProgressItems_Update then
	local LAYOUT = ns.LAYOUT
	local heading = QuestProgressRequiredItemsText
	local money = QuestProgressRequiredMoneyText

	local questID = progressPage:CreateFontString(nil, "ARTWORK")
	questID:SetJustifyH("RIGHT")
	ns.LinkQuestIDToWowhead(progressPage, questID, GetQuestID)
	ns.CreateRoomBelow(progressPage, questID) -- So scrolled to the bottom it sits clear of the page's edge

	local blizzardY = {} -- Each region's offset before it was first moved, to put back with the cleanup off

	-- Moves region up or down from what it hangs from, returning that
	local function MoveTo(region, y)
		local point, relativeTo, relativePoint, x, currentY = region:GetPoint(1)
		if blizzardY[region] == nil then
			blizzardY[region] = currentY
		end
		region:SetPoint(point, relativeTo, relativePoint, x, y)
		return relativeTo
	end

	local function PutBack(region)
		if region and blizzardY[region] ~= nil and region:GetNumPoints() > 0 then
			local point, relativeTo, relativePoint, x = region:GetPoint(1)
			region:SetPoint(point, relativeTo, relativePoint, x, blizzardY[region])
		end
	end

	--[[
		The last thing on the page: the left button of the last row of required items (the second of
		each row sits beside the first), else the gold, the heading or the text
	]]
	local function LastShown()
		local count = 0
		while _G["QuestProgressItem" .. (count + 1)] and _G["QuestProgressItem" .. (count + 1)]:IsShown() do
			count = count + 1
		end
		if count > 0 then
			return _G["QuestProgressItem" .. (count % 2 == 0 and count - 1 or count)]
		end
		for _, region in ipairs({ money, heading }) do
			if region and region:IsShown() then
				return region
			end
		end
		return QuestProgressText
	end

	local title, text = QuestProgressTitleText, QuestProgressText

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		if not ns.IsQuestGiverCleanupOn() then
			-- Blizzard anchors the first row of items afresh each time, so only the pieces anchored once go back
			for _, region in ipairs({ title, text, heading, money }) do
				PutBack(region)
			end
			questID:Hide()
			return
		end
		-- The quest's title PAGE_TOP down the page, and its text the title's space under it
		if title and title:GetNumPoints() > 0 then
			MoveTo(title, -LAYOUT.PAGE_TOP)
		end
		if text and text:GetNumPoints() > 0 and select(2, text:GetPoint(1)) == title then
			MoveTo(text, -LAYOUT.TITLE_SPACE_BELOW)
		end
		-- The first row of items a step under the gold, when it's asked for
		local first = QuestProgressItem1
		if money and money:IsShown() and first and first:IsShown() and first:GetNumPoints() > 0 then
			if select(2, first:GetPoint(1)) == money then
				MoveTo(first, -LAYOUT.SPACE.NEAR)
			end
		end
		if heading and heading:IsShown() and heading:GetNumPoints() > 0 then
			MoveTo(heading, -LAYOUT.HEADING_SPACE_ABOVE)
			for _, region in ipairs({ money, QuestProgressItem1 }) do
				if region and region:IsShown() and region:GetNumPoints() > 0 then
					local _, relativeTo = region:GetPoint(1)
					if relativeTo == heading then
						MoveTo(region, -LAYOUT.HEADING_SPACE_BELOW)
					end
				end
			end
		end

		local id = GetQuestID and GetQuestID()
		if (not id) or (id == 0) then
			questID:Hide()
			return
		end
		ns.StyleQuestID(questID, id, QuestProgressText)
		questID:ClearAllPoints()
		questID:SetPoint(
			"TOPRIGHT",
			LastShown(),
			"BOTTOMLEFT",
			QuestProgressText:GetWidth() - ns.TwoSpacesWide(QuestProgressText),
			-LAYOUT.QUEST_ID_GAP
		)
		questID:Show()
		if QuestProgressScrollFrame and QuestProgressScrollFrame.UpdateScrollChildRect then
			QuestProgressScrollFrame:UpdateScrollChildRect() -- So the quest ID scrolls into view
		end
	end)
end
