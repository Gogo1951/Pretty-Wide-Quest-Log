local _, ns = ...

-- Every client: the quest giver window's own pages, styled like the quest details, with the quest ID under the progress page.

--------------------------------------------------------------------------------
-- Quest Giver
--------------------------------------------------------------------------------

--[[
	The quest giver window's own pages, where it doesn't use QuestInfo (all of them on Classic Era and
	TBC Anniversary, the progress page on WoW Forever). Their text is found by its font, without
	naming it: text in the title's font is a heading, the one hung from the top of its page being the
	quest's title and the rest section headings, and everything else is quest text
]]
local QUEST_GIVER_PAGES = {
	"QuestDetailScrollChildFrame",
	"QuestProgressScrollChildFrame",
	"QuestRewardScrollChildFrame",
}

local function StyleQuestGiverPages()
	local headingFile = QuestTitleFont:GetFont()
	for _, name in ipairs(QUEST_GIVER_PAGES) do
		local page = _G[name]
		for _, region in ipairs(page and { page:GetRegions() } or {}) do
			if region:GetObjectType() == "FontString" then
				local _, relativeTo = region:GetPoint(1)
				local isHeading = region:GetFont() == headingFile
				local isTitle = isHeading and ((not relativeTo) or (relativeTo == page))
				ns.StyleQuestText(region, isHeading and not isTitle)
			end
		end
	end
end

-- Styled once, before Blizzard first lays any of them out, so its measurements match
StyleQuestGiverPages()

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

	-- Moves region up or down from what it hangs from, returning that
	local function MoveTo(region, y)
		local point, relativeTo, relativePoint, x = region:GetPoint(1)
		region:SetPoint(point, relativeTo, relativePoint, x, y)
		return relativeTo
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
