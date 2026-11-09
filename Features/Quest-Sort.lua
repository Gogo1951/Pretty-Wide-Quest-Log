local _, ns = ...

--------------------------------------------------------------------------------
-- Sorting
--------------------------------------------------------------------------------

--[[
	Both quest logs sort the same records: quests carry sortLevel, sortKey and sortIndex (their quest log
	index), zones carry title, sortIndex, sortKey and averageLevel.
]]

-- Alphabetical by full name, as Blizzard's quest log lists zones, so The Hinterlands goes under T
function ns.NameSortKey(title)
	return strlower(title or "")
end

-- The average level of a zone's quests, or nil when none are listed
function ns.AverageLevel(quests)
	if #quests == 0 then
		return nil
	end
	local total = 0
	for _, quest in ipairs(quests) do
		total = total + quest.sortLevel
	end
	return total / #quests
end

--[[
	questSort: LEVEL_HIGHEST_FIRST (the default) or LEVEL_LOWEST_FIRST by level, or ALPHABETICAL by name. With
	completedFirst, quests ready to turn in (isComplete) go before the rest, each group in the questSort order.
	Ties keep the quest log's order
]]
function ns.SortQuests(quests, questSort, completedFirst)
	table.sort(quests, function(a, b)
		if completedFirst and a.isComplete ~= b.isComplete then
			return a.isComplete == true
		end
		if questSort == "ALPHABETICAL" then
			if a.sortKey ~= b.sortKey then
				return a.sortKey < b.sortKey
			end
		elseif a.sortLevel ~= b.sortLevel then
			if questSort == "LEVEL_HIGHEST_FIRST" then
				return a.sortLevel > b.sortLevel
			end
			return a.sortLevel < b.sortLevel
		end
		return a.sortIndex < b.sortIndex
	end)
end

--[[
	Whether a zone header is the zone the player is in. Both quest logs name their zones only by text, so
	this matches names (GAME NAMES). A class or profession header never matches. A header is an area's
	name, and inside a dungeon the zone text is the instance's, which can be spelled differently, so there
	a header also matches any name the dungeon's quests can be filed under (ns.CurrentDungeonNames)
]]
function ns.IsCurrentZone(title)
	if title == nil then
		return false
	end
	if title == GetRealZoneText() then
		return true
	end
	local names = ns.CurrentDungeonNames and ns.CurrentDungeonNames()
	return names ~= nil and names[title] == true
end

-- A zone header's text, marked when it's the zone the player is in
function ns.ZoneHeaderText(title)
	if ns.IsCurrentZone(title) then
		return title .. " " .. ns.CURRENT_ZONE_MARK
	end
	return title
end

--[[
	zoneSort: LEVEL_HIGHEST_FIRST (the default) or LEVEL_LOWEST_FIRST by average quest level, or
	ALPHABETICAL; ties by name. With currentZoneFirst, the player's zone (isCurrent) goes before them all
]]
local function CompareZones(a, b, zoneSort, currentZoneFirst)
	if currentZoneFirst and a.isCurrent ~= b.isCurrent then
		return a.isCurrent
	end
	if zoneSort ~= "ALPHABETICAL" and a.averageLevel ~= b.averageLevel then
		-- A zone whose level isn't known goes after the rest
		if not (a.averageLevel and b.averageLevel) then
			return a.averageLevel ~= nil
		end
		if zoneSort == "LEVEL_LOWEST_FIRST" then
			return a.averageLevel < b.averageLevel
		end
		return a.averageLevel > b.averageLevel
	end
	if a.sortKey ~= b.sortKey then
		return a.sortKey < b.sortKey
	end
	return a.sortIndex < b.sortIndex
end

--[[
	Sorts zones by zoneSort and currentZoneFirst, except that frozen (zone title -> rank, from the first sort since the window
	opened) keeps zones where they were, so turning in or dropping a quest doesn't shuffle them under the
	cursor; zones it doesn't know go after. Returns the frozen ranks, made on the first call.
]]
function ns.SortZones(zones, zoneSort, currentZoneFirst, frozen)
	for _, zone in ipairs(zones) do
		zone.isCurrent = ns.IsCurrentZone(zone.title)
	end
	table.sort(zones, function(a, b)
		local rankA, rankB = frozen and frozen[a.title or ""], frozen and frozen[b.title or ""]
		if rankA and rankB then
			return rankA < rankB
		elseif rankA or rankB then
			return rankA ~= nil
		end
		return CompareZones(a, b, zoneSort, currentZoneFirst)
	end)
	if not frozen then
		frozen = {}
		for rank, zone in ipairs(zones) do
			frozen[zone.title or ""] = rank
		end
	end
	return frozen
end
