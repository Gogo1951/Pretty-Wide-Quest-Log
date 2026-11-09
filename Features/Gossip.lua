local _, ns = ...

--[[
	Every client: the gossip window's greeting text and quest level tags, while the quest giver window
	cleanup is on (Quest-Giver.lua)
]]

--------------------------------------------------------------------------------
-- The gossip window's greeting
--------------------------------------------------------------------------------

--[[
	The greeting takes the quest text's font and line spacing with the cleanup on, and Blizzard's back with
	it off. The shown greeting row is styled as Blizzard sets it up
]]
local function StyleGossipGreeting(greetingText)
	if not greetingText then
		return
	end
	if ns.IsQuestGiverCleanupOn() then
		ns.RememberBlizzardStyle(greetingText)
		ns.StyleQuestText(greetingText)
	else
		ns.RestoreBlizzardStyle(greetingText)
	end
end
if GossipGreetingTextMixin and GossipGreetingTextMixin.Setup then
	hooksecurefunc(GossipGreetingTextMixin, "Setup", function(frame)
		StyleGossipGreeting(frame.GreetingText)
	end)
end

--[[
	The gossip list places its rows by a hidden copy of the greeting of its own (the greetingTextFrame in
	the greeting's list entry): Blizzard only sets that copy's text and reads its height, never runs its
	Setup, so the hook above misses it. Left in Blizzard's spacing, it measures a long greeting shorter
	than the styled row draws, and the first option lands inside the text. So the copy takes the same
	style after each list update, and when that changes its height the list is rebuilt. A FullUpdate isn't
	enough: it recalculates the row heights but leaves the rows already shown at their old size and place.
	Blizzard only creates the copy inside the first update, so that first update is the one that needs the
	rebuild. The copy lasts for the session, so from the next update on it's measured in the right style first time
]]
local function StyleGossipMeasuringGreeting()
	local scrollBox = GossipFrame.GreetingPanel and GossipFrame.GreetingPanel.ScrollBox
	local dataProvider = scrollBox and scrollBox.GetDataProvider and scrollBox:GetDataProvider()
	if not (dataProvider and dataProvider.FindElementDataByPredicate) then
		return
	end
	local entry = dataProvider:FindElementDataByPredicate(function(elementData)
		return elementData.greetingTextFrame ~= nil
	end)
	local measuringText = entry and entry.greetingTextFrame.GreetingText
	if not measuringText then
		return
	end
	local measuredHeight = measuringText:GetHeight()
	StyleGossipGreeting(measuringText)
	if measuringText:GetHeight() == measuredHeight then
		return
	end
	if scrollBox.Rebuild then
		scrollBox:Rebuild(ScrollBoxConstants.RetainScrollPosition)
	elseif scrollBox.FullUpdate then
		scrollBox:FullUpdate(ScrollBoxConstants.UpdateImmediately)
	end
end
if GossipFrame and GossipFrame.Update then
	hooksecurefunc(GossipFrame, "Update", StyleGossipMeasuringGreeting)
end

--------------------------------------------------------------------------------
-- The gossip window's quest lines
--------------------------------------------------------------------------------

-- Each quest line is set up from its gossip quest info, then takes the quest log's level tag (Quest-Giver.lua)
local function TagGossipQuest(button, questInfo)
	if ns.TagQuestLine(button, questInfo.questLevel, questInfo.questID) then
		button:Resize()
	end
end
for _, mixin in ipairs({ GossipSharedAvailableQuestButtonMixin, GossipSharedActiveQuestButtonMixin }) do
	if mixin and mixin.Setup then
		hooksecurefunc(mixin, "Setup", TagGossipQuest)
	end
end
