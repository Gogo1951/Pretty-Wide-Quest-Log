local _, ns = ...

--[[
	Every client: the quest giver window's own pages, styled like the quest details, and the quest log's
	level tags in a quest giver's list of quests. The gossip window's spacing is in Gossip.lua, and the
	greeting and progress pages, with the quest ID under the progress page, in Quest-Giver-Pages.lua
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

--------------------------------------------------------------------------------
-- Skins on the quest giver window
--------------------------------------------------------------------------------

--[[
	Skins (ElvUI) keep the parchment but draw the window around it see-through, so whatever sits behind
	the window, Questie's tracker or a nameplate, shows through above and below the page. With the cleanup
	on the skin's backdrop is opaque in its own color, and with it off it goes back to the skin's. ElvUI
	puts the backdrop on the window itself on WoW Forever and Mists, and on a frame of its own on Classic
	Era and TBC. A window no skin has touched has neither, and is left alone
]]
local skinAlpha -- The skin's own backdrop alpha, from before this add-on changed it

local function UpdateWindowBackdrop()
	local frame = QuestFrame and (QuestFrame.backdrop or (QuestFrame.template and QuestFrame))
	if not (frame and frame.GetBackdropColor and frame.SetBackdropColor) then
		return
	end
	local r, g, b, a = frame:GetBackdropColor()
	if not r then
		return
	end
	if skinAlpha == nil then
		skinAlpha = a or 1
	end
	if ns.IsQuestGiverCleanupOn() then
		frame.customBackdropAlpha = 1 -- ElvUI keeps it through its color updates
		frame:SetBackdropColor(r, g, b, 1)
	elseif frame.customBackdropAlpha == 1 then
		frame.customBackdropAlpha = nil
		frame:SetBackdropColor(r, g, b, skinAlpha)
	end
end

if QuestFrame then
	-- Skins style the window after this file loads, so it's checked each time the window opens
	QuestFrame:HookScript("OnShow", UpdateWindowBackdrop)
end

--[[
	Reward names, wherever QuestInfo shows rewards: the quest giver window, and on WoW Forever and Mists
	the quest details too. Blizzard draws them white on a dark name plate, and skins (ElvUI)
	that hide the plate leave them white, with a shadow, on the bare parchment. With the plate hidden they
	take the description's color, without the shadow, as the rest of the parchment's text does. The
	buttons are shared, so every display restyles every button it shows. Skins restyle them in hooks that
	may run after this one, so it runs again a frame later. On a quest giver page with the cleanup off
	they go back to the color and shadow they had
]]
local namesBefore = {} -- Each name's color and shadow from before this add-on changed them

local function StyleRewardNames(on)
	local rewards = QuestInfoRewardsFrame
	local r, g, b = QuestInfoDescriptionText:GetTextColor()
	for _, button in ipairs(rewards and rewards.RewardButtons or {}) do
		local name = button.Name
		local plateHidden = button.NameFrame and ((not button.NameFrame:IsShown()) or button.NameFrame:GetAlpha() == 0)
		if name and on and plateHidden then
			if not namesBefore[name] then
				namesBefore[name] = { color = { name:GetTextColor() }, shadow = { name:GetShadowColor() } }
			end
			name:SetTextColor(r, g, b)
			name:SetShadowColor(0, 0, 0, 0)
		elseif name and namesBefore[name] then
			name:SetTextColor(unpack(namesBefore[name].color))
			name:SetShadowColor(unpack(namesBefore[name].shadow))
			namesBefore[name] = nil
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
	local namesStyled -- Whether the last display's reward names are styled, for the pass a frame later
	local function StyleRewardNamesLater()
		StyleRewardNames(namesStyled)
	end
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame)
		local onQuestGiverPage = ns.IsQuestGiverPage(parentFrame)
		if onQuestGiverPage and ns.IsQuestGiverCleanupOn() then
			SpaceQuestGiverPage(template, parentFrame)
		end
		namesStyled = (not onQuestGiverPage) or ns.IsQuestGiverCleanupOn()
		StyleRewardNames(namesStyled)
		C_Timer.After(0, StyleRewardNamesLater)
	end)
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
	UpdateWindowBackdrop()
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
ns.TagQuestLine = TagQuestLine -- The greeting page's quest lines too (Quest-Giver-Pages.lua)

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
