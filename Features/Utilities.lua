local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

local COLORS = {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = "|cff" .. hex
end

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end

--------------------------------------------------------------------------------
-- Numbers
--------------------------------------------------------------------------------

--[[
	A whole number with its thousands grouped the way this locale writes them, "3,950" in English.
	BreakUpLargeNumbers can leave them ungrouped, so the add-on groups them itself
]]
local THOUSANDS_SEPARATOR = LARGE_NUMBER_SEPERATOR or ","

function ns.FormatNumber(number)
	local digits = tostring(math.floor(number))
	local head = #digits % 3
	if head == 0 then
		head = 3
	end
	local groups = { digits:sub(1, head) }
	for start = head + 1, #digits, 3 do
		groups[#groups + 1] = digits:sub(start, start + 2)
	end
	return table.concat(groups, THOUSANDS_SEPARATOR)
end

--------------------------------------------------------------------------------
-- Questie
--------------------------------------------------------------------------------

function ns.ImportQuestieModule(name)
	if not QuestieLoader then
		return
	end
	local loaded, module = pcall(QuestieLoader.ImportModule, QuestieLoader, name)
	return loaded and type(module) == "table" and module or nil
end

--------------------------------------------------------------------------------
-- Quest Tags
--------------------------------------------------------------------------------

-- A quest's tag (Enum.QuestTag) and whether it's elite, by quest ID, whether or not it's in the quest log
if C_QuestLog.GetQuestTagInfo then
	function ns.GetQuestTagByID(questID)
		local tagDetails = C_QuestLog.GetQuestTagInfo(questID)
		return tagDetails and tagDetails.tagID, tagDetails and tagDetails.isElite
	end
else
	function ns.GetQuestTagByID(questID)
		if not GetQuestTagInfo then
			return nil, false
		end
		local tagID, tagName = GetQuestTagInfo(questID)
		return tagID, ELITE ~= nil and tagName == ELITE
	end
end

-- A quest's title by quest ID, whether or not it's in the quest log; nil until the client has loaded it
if C_QuestLog.GetTitleForQuestID then
	function ns.GetQuestTitleByID(questID)
		return C_QuestLog.GetTitleForQuestID(questID)
	end
else
	function ns.GetQuestTitleByID(questID)
		return C_QuestLog.GetQuestInfo and C_QuestLog.GetQuestInfo(questID)
	end
end

-- Whether a quest log frequency is a daily quest's. TBC tags daily quests; Classic Era has none, nor the constant
local DAILY_FREQUENCY = LE_QUEST_FREQUENCY_DAILY
function ns.IsDailyFrequency(frequency)
	return DAILY_FREQUENCY ~= nil and frequency == DAILY_FREQUENCY
end

--------------------------------------------------------------------------------
-- VoiceOver
--------------------------------------------------------------------------------

--[[
	VoiceOver puts a play button in front of quest titles in the quest log, and so does Spoken Quests, its
	fork, which keeps the VoiceOver global. Returns that global while either is loaded with its quest log
	part switched on, else nil. rawget, as the global falls back to _G for anything it doesn't hold itself
]]
function ns.GetVoiceOver()
	if not (C_AddOns.IsAddOnLoaded("AI_VoiceOver") or C_AddOns.IsAddOnLoaded("Spoken_Quests")) then
		return nil
	end
	local voiceOver = type(VoiceOver) == "table" and VoiceOver
	if
		not (
			voiceOver
			and rawget(voiceOver, "QuestOverlayUI")
			and rawget(voiceOver, "DataModules")
			and rawget(voiceOver, "Enums")
		)
	then
		return nil
	end
	local addon = rawget(voiceOver, "Addon")
	if addon and addon.IsPartOn and not addon:IsPartOn() then
		return nil
	end
	return voiceOver
end

--------------------------------------------------------------------------------
-- Quest Sharing
--------------------------------------------------------------------------------

-- Seconds between the zone menu's shares: the Quality of Life panel's setting, or the default while that switch is off
function ns.GetShareInterval()
	local profile = ns.db.profile
	return profile.enableQualityOfLife and profile.shareInterval or ns.DATABASE_DEFAULTS.profile.shareInterval
end

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
	this matches names (GAME NAMES); a dungeon or class header never matches
]]
function ns.IsCurrentZone(title)
	return title ~= nil and title == GetRealZoneText()
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
