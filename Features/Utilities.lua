local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

-- A 6-character hex color as r, g, b from 0 to 1, for the APIs that take numbers
local function HexToRGB(hex)
	return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end
ns.HexToRGB = HexToRGB

local COLORS, COLORS_RGB = {}, {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = "|cff" .. hex
	COLORS_RGB[key] = { HexToRGB(hex) }
end

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end

function ns.GetColorRGB(key)
	return unpack(COLORS_RGB[key] or COLORS_RGB.TEXT)
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
-- Quest Log
--------------------------------------------------------------------------------

--[[
	The quest log read and acted on by quest ID, as WoW Forever's quest log calls do (C_QuestLog.GetInfo
	and the rest), on every client. Classic Era, TBC and Mists have only the older calls by quest log
	index, and those that act on a quest act on the selected one, so here each selects the quest it acts
	on and puts the player's selection back. The window on WoW Forever and Mists reads the log through
	these (Forever-Quest-Log.lua, Forever-Quest-List.lua)
]]
if C_QuestLog.GetInfo then
	function ns.GetNumQuestLogEntries()
		return (C_QuestLog.GetNumQuestLogEntries())
	end

	-- One entry (a zone header or a quest), as C_QuestLog.GetInfo describes it
	function ns.GetQuestLogEntry(index)
		return C_QuestLog.GetInfo(index)
	end

	function ns.SetQuestZoneCollapsed(index, collapsed)
		if collapsed then
			CollapseQuestHeader(index)
		else
			ExpandQuestHeader(index)
		end
	end

	-- Every quest is listed whether its zone is collapsed or not
	function ns.ShowEveryQuestLogEntry() end

	function ns.GetLogIndexForQuestID(questID)
		return C_QuestLog.GetLogIndexForQuestID(questID)
	end

	function ns.GetHeaderIndexForQuest(questID)
		return C_QuestLog.GetHeaderIndexForQuest(questID)
	end

	ns.IsQuestComplete = C_QuestLog.IsComplete
	ns.IsQuestFailed = C_QuestLog.IsFailed
	ns.IsQuestDisabledForSession = C_QuestLog.IsQuestDisabledForSession
	ns.GetSelectedQuestID = C_QuestLog.GetSelectedQuest
	ns.SelectQuest = C_QuestLog.SetSelectedQuest
	ns.IsPushableQuest = C_QuestLog.IsPushableQuest
	ns.CanAbandonQuest = C_QuestLog.CanAbandonQuest

	function ns.ShareQuest(questID)
		QuestMapQuestOptions_ShareQuest(questID)
	end

	-- Asks whether to abandon the quest, as the game's own Abandon button does
	function ns.AskToAbandonQuest(questID)
		QuestMapQuestOptions_AbandonQuest(questID)
	end
else
	--[[
		A collapsed zone lists none of its quests here, which would leave it out of the window's list
		altogether. So the window keeps Blizzard's zones open (ns.ShowEveryQuestLogEntry) and remembers which
		it shows collapsed itself, by zone name, for the session
	]]
	local collapsedZones = {}

	function ns.GetNumQuestLogEntries()
		return (GetNumQuestLogEntries())
	end

	--[[
		One entry (a zone header or a quest) with the fields of C_QuestLog.GetInfo the window reads, plus
		isComplete and isFailed. isCollapsed is whether the window shows the zone collapsed
	]]
	function ns.GetQuestLogEntry(index)
		local title, level, _, isHeader, _, isComplete, frequency, questID, _, _, _, _, isTask, isBounty, _, isHidden, isScaling =
			GetQuestLogTitle(index)
		if not title then
			return nil
		end
		return {
			title = title,
			level = level,
			questID = questID,
			questLogIndex = index,
			isHeader = isHeader and true or false,
			isCollapsed = (isHeader and collapsedZones[title]) and true or false,
			frequency = frequency,
			isTask = isTask,
			isBounty = isBounty,
			isHidden = isHidden,
			isScaling = isScaling,
			isComplete = (isComplete or 0) > 0,
			isFailed = (isComplete or 0) < 0,
		}
	end

	function ns.SetQuestZoneCollapsed(index, collapsed)
		local title, _, _, isHeader = GetQuestLogTitle(index)
		if title and isHeader then
			collapsedZones[title] = collapsed or nil
		end
	end

	-- Opens any of Blizzard's zones that are collapsed, so every quest is listed
	function ns.ShowEveryQuestLogEntry()
		for index = 1, GetNumQuestLogEntries() do
			local _, _, _, isHeader, isCollapsed = GetQuestLogTitle(index)
			if isHeader and isCollapsed then
				ExpandQuestHeader(0)
				return
			end
		end
	end

	function ns.GetLogIndexForQuestID(questID)
		for index = 1, GetNumQuestLogEntries() do
			local _, _, _, isHeader, _, _, _, entryID = GetQuestLogTitle(index)
			if not isHeader and entryID == questID then
				return index
			end
		end
	end

	function ns.GetHeaderIndexForQuest(questID)
		for index = ns.GetLogIndexForQuestID(questID) or 0, 1, -1 do
			if select(4, GetQuestLogTitle(index)) then
				return index
			end
		end
	end

	local function QuestEntry(questID)
		local index = ns.GetLogIndexForQuestID(questID)
		return index and ns.GetQuestLogEntry(index)
	end

	function ns.IsQuestComplete(questID)
		local entry = QuestEntry(questID)
		return entry and entry.isComplete or false
	end

	function ns.IsQuestFailed(questID)
		local entry = QuestEntry(questID)
		return entry and entry.isFailed or false
	end

	-- Only WoW Forever turns off quests for a session
	function ns.IsQuestDisabledForSession()
		return false
	end

	function ns.GetSelectedQuestID()
		local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(GetQuestLogSelection())
		if title and not isHeader then
			return questID
		end
	end

	function ns.SelectQuest(questID)
		local index = ns.GetLogIndexForQuestID(questID)
		if index then
			SelectQuestLogEntry(index)
		end
	end

	-- Runs work with the quest selected, then selects what was selected before; returns what work returns
	local function WithQuestSelected(questID, work)
		local index = ns.GetLogIndexForQuestID(questID)
		if not index then
			return nil
		end
		local selected = GetQuestLogSelection()
		SelectQuestLogEntry(index)
		local result = work()
		SelectQuestLogEntry(selected)
		return result
	end

	function ns.IsPushableQuest(questID)
		return WithQuestSelected(questID, function()
			return GetQuestLogPushable() and true or false
		end) or false
	end

	function ns.CanAbandonQuest(questID)
		if CanAbandonQuest then
			return CanAbandonQuest(questID) and true or false
		end
		return ns.GetLogIndexForQuestID(questID) ~= nil
	end

	function ns.ShareQuest(questID)
		WithQuestSelected(questID, QuestLogPushQuest)
	end

	-- Asks whether to abandon the quest, as the game's own Abandon button does
	function ns.AskToAbandonQuest(questID)
		WithQuestSelected(questID, function()
			SetAbandonQuest()
			local items = GetAbandonQuestItems()
			if items then
				StaticPopup_Hide("ABANDON_QUEST")
				StaticPopup_Show("ABANDON_QUEST_WITH_ITEMS", GetAbandonQuestName(), items)
			else
				StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")
				StaticPopup_Show("ABANDON_QUEST", GetAbandonQuestName())
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- Quest Tags
--------------------------------------------------------------------------------

--[[
	A quest's tag (Enum.QuestTag), whether it's elite, and the tag's name ("Dungeon"), by quest ID, whether
	or not it's in the quest log
]]
if C_QuestLog.GetQuestTagInfo then
	function ns.GetQuestTagByID(questID)
		local tagDetails = C_QuestLog.GetQuestTagInfo(questID)
		local isElite = (tagDetails and tagDetails.isElite) or C_QuestLog.IsEliteQuest(questID)
		return tagDetails and tagDetails.tagID, isElite and true or false, tagDetails and tagDetails.tagName
	end
else
	function ns.GetQuestTagByID(questID)
		if not GetQuestTagInfo then
			return nil, false
		end
		local tagID, tagName = GetQuestTagInfo(questID)
		return tagID, ELITE ~= nil and tagName == ELITE, tagName
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
	this matches names (GAME NAMES). A class or profession header never matches, and a dungeon's header
	matches only while the player is inside it (Dungeon-Quest-Lookup.lua relies on that)
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
