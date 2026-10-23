local _, ns = ...

--[[
	Every client: the quest giver window's own pages, styled like the quest details, with the quest ID under
	the progress page, and the quest log's level tags in a quest giver's list of quests
]]

--[[
	The quest giver window's styling, here and in Forever-Quest-Giver.lua, runs while the Quality of Life
	switch and giverCleanup are both on. It never follows the Quest Log switch, so it works alongside
	Blizzard's quest log too
]]
function ns.IsQuestGiverCleanupOn()
	local profile = ns.db and ns.db.profile
	return profile and profile.enableQualityOfLife and profile.giverCleanup or false
end

-- Whether a QuestInfo_Display parent is one of the quest giver window's pages
function ns.IsQuestGiverPage(parentFrame)
	return parentFrame ~= nil
		and (parentFrame == QuestDetailScrollChildFrame or parentFrame == QuestRewardScrollChildFrame)
end

--------------------------------------------------------------------------------
-- Quest Giver
--------------------------------------------------------------------------------

--[[
	Text the quest giver window's pages hold themselves rather than through QuestInfo, chiefly the
	progress page's, which no client draws with QuestInfo. It is found by its font, without naming it:
	text in the title's font is a heading, the one hung from the top of its page being the quest's
	title and the rest section headings, and everything else is quest text
]]
local QUEST_GIVER_PAGES = {
	"QuestDetailScrollChildFrame",
	"QuestProgressScrollChildFrame",
	"QuestRewardScrollChildFrame",
}

local function StyleQuestGiverPages(on)
	local headingFile = QuestTitleFont:GetFont()
	for _, name in ipairs(QUEST_GIVER_PAGES) do
		local page = _G[name]
		for _, region in ipairs(page and { page:GetRegions() } or {}) do
			if region:GetObjectType() == "FontString" then
				if on then
					ns.RememberBlizzardStyle(region)
					local _, relativeTo = region:GetPoint(1)
					local isHeading = region:GetFont() == headingFile
					local isTitle = isHeading and ((not relativeTo) or (relativeTo == page))
					ns.StyleQuestText(region, isHeading and not isTitle)
				else
					ns.RestoreBlizzardStyle(region)
				end
			end
		end
	end
end

--[[
	The window's own pages and the shared QuestInfo text, styled with the cleanup on and put
	back to Blizzard's with it off. Done as the saved settings load, before Blizzard first lays any of
	them out, so its measurements match, and again when the switch or the profile changes. A window
	already open is laid out to match the next time it opens; WoW Forever's quest log, which restyles
	the shared text before every repaint, repaints at once
]]
function ns.ApplyQuestGiverCleanup()
	local on = ns.IsQuestGiverCleanupOn()
	StyleQuestGiverPages(on)
	if on then
		ns.StyleQuestInfo()
	else
		ns.RestoreQuestInfoStyle()
	end
	if ns.RequestUpdate then
		ns.RequestUpdate()
	end
end

--------------------------------------------------------------------------------
-- Level tags in a quest giver's list of quests
--------------------------------------------------------------------------------

--[[
	Puts the quest log's tag ("[36]", "[40D]") in front of a quest's line, in the line's own color (dark
	on the parchment), while the quest giver window cleanup and its giverLevels sub-option are both on.
	Blizzard sets the line's text before this runs, but may run this more than once on the same text, so a
	line already tagged is left alone
]]
local function TagQuestLine(button, level, questID)
	if not (ns.IsQuestGiverCleanupOn() and ns.db.profile.giverLevels and level and level > 0) then
		return false
	end
	local text = button:GetText() or ""
	if button.levelTaggedText == text then
		return false
	end
	local tagID, isElite
	if questID then
		tagID, isElite = ns.GetQuestTagByID(questID)
	end
	button:SetText(ns.LevelTag(level, ns.QuestSuffix(tagID, isElite)) .. " " .. text)
	button.levelTaggedText = button:GetText()
	return true
end

-- The gossip window, on every client: each quest line is set up from its gossip quest info
local function TagGossipQuest(button, questInfo)
	if TagQuestLine(button, questInfo.questLevel, questInfo.questID) then
		button:Resize()
	end
end
for _, mixin in ipairs({ GossipSharedAvailableQuestButtonMixin, GossipSharedActiveQuestButtonMixin }) do
	if mixin and mixin.Setup then
		hooksecurefunc(mixin, "Setup", TagGossipQuest)
	end
end

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

if QuestFrameGreetingPanel then
	-- Blizzard runs the page's setup from its OnShow script, and calls it directly when the page is already open
	QuestFrameGreetingPanel:HookScript("OnShow", TagGreetingQuests)
	if QuestFrameGreetingPanel_OnShow then
		hooksecurefunc("QuestFrameGreetingPanel_OnShow", TagGreetingQuests)
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

	hooksecurefunc("QuestFrameProgressItems_Update", function()
		if not ns.IsQuestGiverCleanupOn() then
			for _, region in ipairs({ heading, money, QuestProgressItem1 }) do
				PutBack(region)
			end
			questID:Hide()
			return
		end
		-- The quest log files set this spacing, and on Classic Era and TBC they don't run with the Quest Log switch off
		if not LAYOUT.QUEST_ID_GAP then
			ns.SetTextSpacing(QuestProgressText)
		end
		if heading:IsShown() and heading:GetNumPoints() > 0 then
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
