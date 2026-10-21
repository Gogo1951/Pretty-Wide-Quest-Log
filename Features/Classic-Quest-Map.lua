local _, ns = ...

--[[
	Classic Era and TBC: the map's layers and the quest it follows (Quest-Map.lua builds the map itself).
	These clients have no quest objective areas or quest markers of Blizzard's, so the selected quest
	comes from Questie's icons alone (Questie-Map.lua). Without them the map shows the zone the quest was
	given in, or the player's zone where Questie doesn't know it
]]

ns.AddWideQuestLogPart(function()
	local questMap = ns.questMap
	local canvas = questMap.canvas

	--------------------------------------------------------------------------------
	-- Map layers
	--------------------------------------------------------------------------------

	canvas:AddDataProvider(CreateFromMixins(MapExplorationDataProviderMixin))

	-- Bottom to top, in the world map's order
	local levels = canvas:GetPinFrameLevelsManager()
	levels:AddFrameLevel("PIN_FRAME_LEVEL_MAP_EXPLORATION")
	levels:AddFrameLevel("PIN_FRAME_LEVEL_QUEST_BLOB") -- Questie's objective areas (Questie-Map-Area-Layer.lua)
	levels:AddFrameLevel("PIN_FRAME_LEVEL_ACTIVE_QUEST")

	--------------------------------------------------------------------------------
	-- Following the selected quest
	--------------------------------------------------------------------------------

	function questMap.FollowQuest()
		local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(GetQuestLogSelection())
		questID = (title and not isHeader) and questID or nil
		questMap.FollowQuestieQuest(questID, questMap.QuestGiverMapID(questID) or MapUtil.GetDisplayableMapForPlayer())
	end

	hooksecurefunc("QuestLog_UpdateQuestDetails", questMap.RequestRefresh)
end)
