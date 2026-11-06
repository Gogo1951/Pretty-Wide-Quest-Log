local _, ns = ...

-- Every client: the gossip window's spacing, while the quest giver window cleanup is on (Quest-Giver.lua)

--------------------------------------------------------------------------------
-- The gossip window's spacing
--------------------------------------------------------------------------------

--[[
	The gossip window on the spacing scale (LAYOUT.SPACE), on every client, which all share Blizzard's
	gossip code. Blizzard lists the greeting, two spacer rows, the available quests, a spacer, the active
	quests, a spacer and the gossip options in one scrolling list, each line only as tall as its text,
	and every spacer 16 tall whatever its template says. With the cleanup on:
	  - each quest and option line gets half of QUEST_LINE_SPACE above and below it, so lines sit
	    QUEST_LINE_SPACE apart, as in the quest giver window's own list
	  - the greeting sits PAGE_TOP down the page, with the quest text's line spacing
	  - the two spacers under the greeting make a section's space before the first line, and the others
	    a group's space between one list and the next
	The list measures each row through its extent calculator, which is wrapped to add the same. With the
	cleanup off everything measures and sits as Blizzard has it
]]
local blizzardButtonAnchors = {} -- Each line's text and icon anchors as Blizzard set them

local function LinePadding()
	return ns.IsQuestGiverCleanupOn() and ns.LAYOUT.QUEST_LINE_SPACE / 2 or 0
end

local function PadGossipLine(button)
	local text, icon = button:GetFontString(), button.Icon
	if not (text and icon and text:GetNumPoints() > 0 and icon:GetNumPoints() > 0) then
		return
	end
	local anchors = blizzardButtonAnchors[button]
	if not anchors then
		anchors = { text = { text:GetPoint(1) }, icon = { icon:GetPoint(1) } }
		blizzardButtonAnchors[button] = anchors
	end
	local padding = LinePadding()
	local point, relativeTo, relativePoint, x, y = unpack(anchors.icon, 1, 5)
	icon:SetPoint(point, relativeTo, relativePoint, x, y - padding)
	text:ClearAllPoints()
	if padding == 0 then
		text:SetPoint(unpack(anchors.text, 1, 5))
		return
	end
	-- Blizzard centers the text in a line 2 taller than it; hung from the top instead, at the same place
	local textX = anchors.text[4] or 0
	text:SetPoint("TOPLEFT", button, "TOPLEFT", textX, -(1 + padding))
	button:SetHeight(math.max(button:GetTextHeight() + 2, icon:GetHeight()) + 2 * padding)
end

-- Every line resizes itself whenever its text changes (a quest's title loading, say), so each follows its Resize
local function SetUpGossipLine(button)
	if not button.prettyWidePadded and button.Resize then
		button.prettyWidePadded = true
		hooksecurefunc(button, "Resize", PadGossipLine)
	end
	PadGossipLine(button)
end
for _, mixin in ipairs({
	GossipSharedAvailableQuestButtonMixin,
	GossipSharedActiveQuestButtonMixin,
	GossipOptionButtonMixin,
}) do
	if mixin and mixin.Setup then
		hooksecurefunc(mixin, "Setup", SetUpGossipLine)
	end
end

-- The greeting's place and line spacing, put back to Blizzard's with the cleanup off
local blizzardGreetingY = {}
local function StyleGossipGreeting(greetingText)
	if not (greetingText and greetingText:GetNumPoints() > 0) then
		return
	end
	local point, relativeTo, relativePoint, x, y = greetingText:GetPoint(1)
	if blizzardGreetingY[greetingText] == nil then
		blizzardGreetingY[greetingText] = y
	end
	if ns.IsQuestGiverCleanupOn() then
		ns.RememberBlizzardStyle(greetingText)
		ns.StyleQuestText(greetingText)
		greetingText:SetPoint(point, relativeTo, relativePoint, x, -ns.LAYOUT.PAGE_TOP)
	else
		ns.RestoreBlizzardStyle(greetingText)
		greetingText:SetPoint(point, relativeTo, relativePoint, x, blizzardGreetingY[greetingText])
	end
end
if GossipGreetingTextMixin and GossipGreetingTextMixin.Setup then
	hooksecurefunc(GossipGreetingTextMixin, "Setup", function(frame)
		StyleGossipGreeting(frame.GreetingText)
	end)
end

--[[
	Row heights. The greeting's row grows by how much further down the greeting now sits; the two spacers
	under it share a section's space, less the first line's padding above it; the others make a group's
	space, less the padding of the lines either side
]]
local GREETING_SPACERS = 2 -- Blizzard's first rows: the greeting, then its two spacers
local function WrapGossipRowHeights()
	local scrollBox = GossipFrame and GossipFrame.GreetingPanel and GossipFrame.GreetingPanel.ScrollBox
	local view = scrollBox and scrollBox.GetView and scrollBox:GetView()
	local blizzardExtent = view and view.elementExtentCalculator
	if not (blizzardExtent and view.SetElementExtentCalculator) or view.prettyWideExtent == blizzardExtent then
		return
	end
	local function Extent(dataIndex, elementData)
		if not ns.IsQuestGiverCleanupOn() then
			return blizzardExtent(dataIndex, elementData)
		end
		local LAYOUT = ns.LAYOUT
		local padding = LinePadding()
		if elementData.greetingTextFrame then
			local greetingText = elementData.greetingTextFrame.GreetingText
			StyleGossipGreeting(greetingText) -- The measuring frame is never set up, only given the text
			return blizzardExtent(dataIndex, elementData) + LAYOUT.PAGE_TOP
		elseif elementData.buttonType == GOSSIP_BUTTON_TYPE_DIVIDER then
			if dataIndex <= 1 + GREETING_SPACERS then
				return (LAYOUT.SPACE.SECTION - padding) / GREETING_SPACERS
			end
			return LAYOUT.SPACE.GROUP - 2 * padding
		end
		return blizzardExtent(dataIndex, elementData)
	end
	view:SetElementExtentCalculator(Extent)
	view.prettyWideExtent = Extent
end

if GossipFrame then
	WrapGossipRowHeights()
	-- In case the list is set up again after this loads; the wrap is only ever done once per list
	GossipFrame:HookScript("OnShow", WrapGossipRowHeights)
end
