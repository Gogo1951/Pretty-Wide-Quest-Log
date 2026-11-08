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
	it off. Only the text's look changes: the lines and rows keep Blizzard's places and sizes, as the
	gossip list measures its rows itself
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
