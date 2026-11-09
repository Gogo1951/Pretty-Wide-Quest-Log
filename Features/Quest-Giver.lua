local _, ns = ...

--[[
	Every client: the quest giver window's own pages, styled like the quest details, and the quest log's
	level tags in a quest giver's list of quests. What skins change is put right in Quest-Giver-Skins.lua.
	The gossip window's greeting and quest lines are in
	Gossip.lua, and the greeting and progress pages, with the quest ID under the progress page, in
	Quest-Giver-Pages.lua
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
	"QuestGreetingScrollChildFrame", -- The greeting, and its Current Quests and Available Quests headings
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
	The detail and reward pages on the spacing scale (LAYOUT.SPACE). Blizzard lays each page out from its
	template, every piece hung under the one before; this keeps those anchors and changes only the space
	above each piece, by what it is: the first PAGE_TOP down the page, a heading or the rewards a
	section under what's above them, text a step under the title or heading that introduces it, and the
	smaller pieces (group size, special objectives) a step under the text. Blizzard lays the page out
	afresh each time, so with the cleanup off it's simply left alone
]]
local PIECE_KINDS = {
	{ "QuestInfo_ShowTitle", "QuestInfoTitleHeader", "title" },
	{ "QuestInfo_ShowDescriptionText", "QuestInfoDescriptionText", "text" },
	{ "QuestInfo_ShowObjectivesText", "QuestInfoObjectivesText", "text" },
	{ "QuestInfo_ShowRewardText", "QuestInfoRewardText", "text" },
	{ "QuestInfo_ShowDescriptionHeader", "QuestInfoDescriptionHeader", "heading" },
	{ "QuestInfo_ShowObjectivesHeader", "QuestInfoObjectivesHeader", "heading" },
	{ "QuestInfo_ShowRewards", "QuestInfoRewardsFrame", "rewards" },
	{ "QuestInfo_ShowSpecialObjectives", "QuestInfoSpecialObjectivesFrame", "detail" },
	{ "QuestInfo_ShowGroupSize", "QuestInfoGroupSize", "detail" },
	{ "QuestInfo_ShowTimer", "QuestInfoTimerFrame", "detail" },
	{ "QuestInfo_ShowObjectives", "QuestInfoObjectivesFrame", "detail" },
	{ "QuestInfo_ShowSpacer", "QuestInfoSpacerFrame", "spacer" },
}

local function SpaceQuestGiverPage(template, parentFrame)
	local LAYOUT = ns.LAYOUT
	--[[
		WoW Forever and Mists (where Forever-Quest-Giver.lua loads) set the Rewards heading higher in its
		block than the other headings, so its space is that much more to match, as in their quest details
	]]
	local rewardsRise = ns.LayOutQuestGiverPage and LAYOUT.REWARDS_HEADING_RISE or 0
	local kinds, pieces = {}, {}
	for _, entry in ipairs(PIECE_KINDS) do
		local show, piece = _G[entry[1]], _G[entry[2]]
		if show and piece then
			kinds[show], pieces[show] = entry[3], piece
		end
	end
	local headings = { [QuestInfoDescriptionHeader or false] = true, [QuestInfoObjectivesHeader or false] = true }

	local elements = template and template.elements or {}
	for index = 1, #elements, 3 do
		local kind, piece = kinds[elements[index]], pieces[elements[index]]
		if piece and piece:IsShown() and piece:GetParent() == parentFrame and piece:GetNumPoints() > 0 then
			local point, relativeTo, relativePoint, x = piece:GetPoint(1)
			local space
			if relativeTo == parentFrame then
				space = LAYOUT.PAGE_TOP
			elseif kind == "heading" then
				space = LAYOUT.HEADING_SPACE_ABOVE
			elseif kind == "rewards" then
				space = LAYOUT.HEADING_SPACE_ABOVE + rewardsRise
			elseif relativeTo == QuestInfoTitleHeader then
				space = LAYOUT.TITLE_SPACE_BELOW
			elseif headings[relativeTo] then
				space = LAYOUT.HEADING_SPACE_BELOW
			elseif kind == "detail" then
				space = LAYOUT.SPACE.NEAR
			elseif kind == "spacer" then
				space = 0
			end
			if space and point == "TOPLEFT" then
				piece:SetPoint(point, relativeTo, relativePoint, x, -space)
			end
		end
	end
	if QuestInfoRewardsFrame and QuestInfoRewardsFrame:GetParent() == parentFrame then
		ns.SpaceRewardsBlock(QuestInfoRewardsFrame)
	end
end

if QuestInfo_Display then
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame)
		if ns.IsQuestGiverPage(parentFrame) and ns.IsQuestGiverCleanupOn() then
			SpaceQuestGiverPage(template, parentFrame)
		end
	end)
end

--[[
	The detail page writes its description in a few letters a frame, unless Instant Quest Text is on.
	Blizzard moves an alpha gradient along the text and calls the fade done once the font string says the
	gradient is past its last letter, then shows the objectives and rewards and enables Accept. With the
	window skinned (ElvUI) and laid out, the font string can say so after only the first few letters, and
	the rest of the description stays invisible: a few words, then a blank stretch as tall as the text.
	When the fade ends short of the description's length, the whole description is shown, over a few
	frames so it takes once the text has settled. A fade that ran to the end, or instant text, is left
	alone. This puts right Blizzard's own fade, so it runs whatever the cleanup switch says
]]
local detailPanel, descriptionText = QuestFrameDetailPanel, QuestInfoDescriptionText
if detailPanel and descriptionText and descriptionText.SetAlphaGradient then
	local REVEAL_FRAMES = 3
	local wasFading, revealFrames, revealTo = false, 0, 0
	detailPanel:HookScript("OnShow", function()
		wasFading, revealFrames = false, 0
	end)
	detailPanel:HookScript("OnUpdate", function(self)
		if self.fading then
			wasFading = true
			return
		end
		if wasFading then
			wasFading = false
			local length = strlenutf8(descriptionText:GetText() or "")
			if (self.fadingProgress or 0) < length then
				revealFrames = REVEAL_FRAMES
				revealTo = math.max(1024, length) + (QUEST_DESCRIPTION_GRADIENT_LENGTH or 30)
			end
		end
		if revealFrames > 0 then
			revealFrames = revealFrames - 1
			descriptionText:SetAlphaGradient(revealTo, QUEST_DESCRIPTION_GRADIENT_LENGTH or 30)
		end
	end)
end

--[[
	The window's own pages and the shared QuestInfo text, styled with the cleanup on and put
	back to Blizzard's with it off. Done as the saved settings load, before Blizzard first lays any of
	them out, so its measurements match, and again when the switch or the profile changes. A window
	already open is laid out to match the next time it opens
]]
function ns.ApplyQuestGiverCleanup()
	local on = ns.IsQuestGiverCleanupOn()
	StyleQuestGiverPages(on)
	ns.UpdateQuestGiverBackdrop()
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
-- The gossip window's and the greeting page's quest lines too (Gossip.lua, Quest-Giver-Pages.lua)
ns.TagQuestLine = TagQuestLine
