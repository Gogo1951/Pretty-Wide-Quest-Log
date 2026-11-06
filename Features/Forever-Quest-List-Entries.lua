local _, ns = ...

--[[
	WoW Forever and Mists: the window's quest list as entries, the zones and quests that show in the
	order the Quest Log settings ask for. Forever-Quest-List.lua draws them
]]

--------------------------------------------------------------------------------
-- Sorting
--------------------------------------------------------------------------------

-- Zone ranks frozen while the window stays open (ns.SortZones)
local zoneOrder

--[[
	Whether a quest entry is complete or failed: the entry's own field where it carries one, as Mists'
	does, else asked by quest ID, which on Mists would walk the whole log for every quest
]]
local function EntryIsComplete(entry)
	if entry.isComplete ~= nil then
		return entry.isComplete
	end
	return ns.IsQuestComplete(entry.questID)
end

local function EntryIsFailed(entry)
	if entry.isFailed ~= nil then
		return entry.isFailed
	end
	return ns.IsQuestFailed(entry.questID)
end

--[[
	Same visibility rules as the map's quest list: no hidden quests, world quests or bonus objectives,
	and zones only when something under them would show. Quests outside any zone come first, then the
	zones in the zoneSort order, each after a blank spacer (zoneGap) but the first. Within each, quests
	go in the questSort order. Returns the list entries, every quest that would show with its zone
	open (in list order), and whether every zone is collapsed
]]
function ns.BuildQuestListEntries()
	local entries, zones = {}, {}
	local header

	ns.ShowEveryQuestLogEntry()
	for index = 1, ns.GetNumQuestLogEntries() do
		local entry = ns.GetQuestLogEntry(index)
		if entry and entry.isHeader then
			header = entry
			header.quests = {}
			header.sortKey = ns.NameSortKey(header.title)
			header.sortIndex = header.questLogIndex
			zones[#zones + 1] = header
		elseif entry and not entry.isHidden and not entry.isTask and (not entry.isBounty or EntryIsComplete(entry)) then
			entry.sortLevel = entry.difficultyLevel or entry.level or 0
			entry.sortIndex = entry.questLogIndex
			entry.sortKey = ns.NameSortKey(entry.title)
			entry.isComplete = EntryIsComplete(entry)
			entry.isFailed = EntryIsFailed(entry)
			entry.zone = header and header.title
			if header then
				header.quests[#header.quests + 1] = entry
			else
				entries[#entries + 1] = entry
			end
		end
	end

	local questSort, completedFirst = ns.db.profile.questSort, ns.db.profile.completedFirst
	ns.SortQuests(entries, questSort, completedFirst) -- Quests outside any zone
	for _, zone in ipairs(zones) do
		zone.averageLevel = ns.AverageLevel(zone.quests)
		ns.SortQuests(zone.quests, questSort, completedFirst)
	end
	zoneOrder = ns.SortZones(zones, ns.db.profile.zoneSort, ns.db.profile.currentZoneFirst, zoneOrder)

	local quests = {}
	for _, quest in ipairs(entries) do
		quests[#quests + 1] = quest
	end
	local anyHeader, anyExpanded = false, false
	for _, zone in ipairs(zones) do
		for _, quest in ipairs(zone.quests) do
			quests[#quests + 1] = quest
		end
		if #zone.quests > 0 then
			if #entries > 0 and ns.db.profile.zoneGap then
				entries[#entries + 1] = { isSpacer = true }
			end
			entries[#entries + 1] = zone
			anyHeader = true
			if not zone.isCollapsed then
				anyExpanded = true
				for _, quest in ipairs(zone.quests) do
					entries[#entries + 1] = quest
				end
			end
		end
	end

	return entries, quests, anyHeader and not anyExpanded
end

-- The next list sorts its zones afresh: after a settings change, and once the window closes
function ns.ResetZoneOrder()
	zoneOrder = nil
end
