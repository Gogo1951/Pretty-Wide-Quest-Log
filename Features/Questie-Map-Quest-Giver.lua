local _, ns = ...

--[[
	Every client: the zone a quest was given in, from Questie's database, for each client's map file to open
	when it picks the map for a quest (questMap.QuestGiverMapID)
]]

ns.AddWideQuestLogPart(function()
	local questMap = ns.questMap

	-- A zone from an area in Questie's database, when the map can show it
	local function AreaMapID(ZoneDB, areaID)
		local parentID = areaID and ZoneDB.GetParentZoneId and ZoneDB:GetParentZoneId(areaID)
		local mapID = areaID and ZoneDB:GetUiMapIdByAreaId(parentID or areaID)
		return questMap.CanShowMap(mapID) and mapID or nil
	end

	-- The area holding most of an NPC's or object's spawns in Questie's database
	local function BusiestArea(spawns)
		local bestAreaID, bestCount
		for areaID, list in pairs(type(spawns) == "table" and spawns or {}) do
			local count = type(list) == "table" and #list or 0
			if count > 0 and (not bestCount or count > bestCount or (count == bestCount and areaID < bestAreaID)) then
				bestAreaID, bestCount = areaID, count
			end
		end
		return bestAreaID
	end

	--[[
		The zone a quest was given in, from Questie's database: where its quest giver stands, otherwise the
		zone the quest is filed under, for a quest started from an item. Nil without Questie, or for a quest
		filed under a class or profession that no NPC or object starts
	]]
	function questMap.QuestGiverMapID(questID)
		local QuestieDB = ns.ImportQuestieModule("QuestieDB")
		local ZoneDB = ns.ImportQuestieModule("ZoneDB")
		if not (questID and QuestieDB and QuestieDB.QueryQuestSingle and ZoneDB and ZoneDB.GetUiMapIdByAreaId) then
			return nil
		end

		local startedBy = QuestieDB.QueryQuestSingle(questID, "startedBy")
		if type(startedBy) == "table" then
			for kind, query in ipairs({ QuestieDB.QueryNPCSingle, QuestieDB.QueryObjectSingle }) do
				for _, id in ipairs(type(startedBy[kind]) == "table" and startedBy[kind] or {}) do
					local mapID = AreaMapID(ZoneDB, BusiestArea(query(id, "spawns")))
					if mapID then
						return mapID
					end
				end
			end
		end

		local zoneOrSort = QuestieDB.QueryQuestSingle(questID, "zoneOrSort")
		return type(zoneOrSort) == "number" and zoneOrSort > 0 and AreaMapID(ZoneDB, zoneOrSort) or nil
	end
end)
