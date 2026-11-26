local _, ns = ...

--[[
	Routes: quest items that run out (routes.TimedItemQuests). An item such as Rendered Spores or a Fresh
	Zhevra Carcass has "Duration: 45 min" on its tooltip and is gone when it ends, so holding one is a ticking
	clock as a quest timer is: its quest counts as timed (routes.TimedQuests, Routes-Questie.lua), goes first
	on the route and is listed on the Quest Arrow with its time left.

	The quest's items are the ones Questie says it hands out (sourceItemId, requiredSourceItems) or asks for
	(its item objectives). Each one in the bags has its tooltip read for the game's own duration line
	(ITEM_DURATION_DAYS, _HOURS, _MIN, _SEC), so the time left is what the tooltip says: whole minutes, then
	seconds in the last one. Read at most every SCAN_INTERVAL seconds, as the route and the arrow ask often
]]

local routes = ns.routes

local SCAN_INTERVAL = 2 -- Seconds between reads of the bags
local LAST_BAG = 4 -- The backpack is bag 0, then four bag slots

local DURATIONS = { -- The game's duration lines, and the seconds in each unit
	{ "ITEM_DURATION_DAYS", 86400 },
	{ "ITEM_DURATION_HOURS", 3600 },
	{ "ITEM_DURATION_MIN", 60 },
	{ "ITEM_DURATION_SEC", 1 },
}

-- A duration line as a pattern that captures its number: "Duration: %d min" matches "Duration: 44 min"
local function Pattern(format)
	local pattern = format:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
	pattern = pattern:gsub("%%%%d", "(%%d+)")
	return "^" .. pattern .. "$"
end

--[[
	A line with a plural form, "Dauer: %d |4Minute:Minuten;", as each line the tooltip can show, one for each
	word, so minutes never match the hours' line
]]
local function Forms(format, forms)
	local before, choices, after = format:match("^(.-)|4([^;]*);(.*)$")
	if not before then
		forms[#forms + 1] = format
		return forms
	end
	for choice in choices:gmatch("[^:]+") do
		Forms(before .. choice .. after, forms)
	end
	return forms
end

local patterns -- Each { pattern, seconds }, made the first time they're needed, from what the client has
local function Patterns()
	if not patterns then
		patterns = {}
		for _, duration in ipairs(DURATIONS) do
			local format = _G[duration[1]]
			if type(format) == "string" and format:find("%d", 1, true) then
				for _, form in ipairs(Forms(format, {})) do
					patterns[#patterns + 1] = { Pattern(form), duration[2] }
				end
			end
		end
	end
	return patterns
end

-- A tooltip of its own, never shown, to read the bags' items with
local scanner
local function Scanner()
	if not scanner then
		scanner = CreateFrame("GameTooltip", "PrettyWideQuestLogTimedItemTooltip", nil, "GameTooltipTemplate")
	end
	return scanner
end

-- The seconds left on the item in a bag slot, as its tooltip says, or nil for one that doesn't run out
local function SecondsLeft(bag, slot)
	local tooltip = Scanner()
	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:ClearLines()
	local ok = pcall(tooltip.SetBagItem, tooltip, bag, slot)
	local seconds
	if ok then
		for line = 2, tooltip:NumLines() do
			local fontString = _G["PrettyWideQuestLogTimedItemTooltipTextLeft" .. line]
			local text = fontString and fontString:GetText()
			if type(text) == "string" then
				for _, entry in ipairs(Patterns()) do
					local count = text:match(entry[1])
					if count then
						seconds = tonumber(count) * entry[2]
						break
					end
				end
			end
			if seconds then
				break
			end
		end
	end
	tooltip:Hide()
	return seconds
end

-- The items a quest hands out or asks for, by Questie, kept as they never change
local questItems = {}
local function QuestItems(questID)
	local items = questItems[questID]
	if items then
		return items
	end
	items = {}
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	local function Query(field)
		if not (QuestieDB and type(QuestieDB.QueryQuestSingle) == "function") then
			return nil
		end
		local ok, value = pcall(QuestieDB.QueryQuestSingle, questID, field)
		return ok and value or nil
	end
	local source = Query("sourceItemId")
	if type(source) == "number" and source > 0 then
		items[#items + 1] = source
	end
	local required = Query("requiredSourceItems")
	for _, itemID in pairs(type(required) == "table" and required or {}) do
		if type(itemID) == "number" then
			items[#items + 1] = itemID
		end
	end
	-- Questie's objective lists can have gaps, so pairs
	local objectives = Query("objectives")
	local itemObjectives = type(objectives) == "table" and objectives[3]
	for _, objective in pairs(type(itemObjectives) == "table" and itemObjectives or {}) do
		if type(objective) == "table" and type(objective[1]) == "number" then
			items[#items + 1] = objective[1]
		end
	end
	questItems[questID] = items
	return items
end

local function Scan()
	local quests = {}
	if not (C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerItemID) then
		return quests
	end
	local wanted = {} -- Item ID to the quests in the log it's for
	local any = false
	for questID, quest in pairs(routes.QuestLog()) do
		if type(quest) == "table" and routes.QuestState(quest) ~= -1 then
			for _, itemID in ipairs(QuestItems(questID)) do
				wanted[itemID] = wanted[itemID] or {}
				table.insert(wanted[itemID], questID)
				any = true
			end
		end
	end
	if not any then
		return quests
	end
	for bag = 0, LAST_BAG do
		for slot = 1, C_Container.GetContainerNumSlots(bag) or 0 do
			local forQuests = wanted[C_Container.GetContainerItemID(bag, slot)]
			local seconds = forQuests and SecondsLeft(bag, slot)
			if seconds then
				for _, questID in ipairs(forQuests) do
					quests[questID] = math.min(quests[questID] or seconds, seconds)
				end
			end
		end
	end
	return quests
end

local scanned, scannedAt = {}, -math.huge

-- The quests in the log whose item is running out, each quest ID to the fewest seconds left on one
function routes.TimedItemQuests()
	if not routes.IsQuestieReady() then
		return {}
	end
	local now = GetTime()
	if now - scannedAt >= SCAN_INTERVAL then
		scanned, scannedAt = Scan(), now
	end
	return scanned
end
