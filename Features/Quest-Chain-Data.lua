local _, ns = ...

-- Every client: the selected quest's chain, from Questie's quest database, for the quest details' chain section (Quest-Chain.lua).

--------------------------------------------------------------------------------
-- Questie
--------------------------------------------------------------------------------

local questieModules = {}
local function QuestieModule(name)
	questieModules[name] = questieModules[name] or ns.ImportQuestieModule(name)
	return questieModules[name]
end

-- One field of a quest's record in Questie's database, or nil while Questie isn't loaded or isn't ready
local function Query(questID, field)
	local questieDB = QuestieModule("QuestieDB")
	if not (questieDB and type(questieDB.QueryQuestSingle) == "function") then
		return nil
	end
	local found, value = pcall(questieDB.QueryQuestSingle, questID, field)
	return found and value or nil
end

--[[
	A quest's tag, from Questie's corrected list when it has one, else the client's, and whether it's elite,
	always the client's: a tag's name is never compared, since it reads differently in every language
]]
local function QuestTag(questID)
	local clientTagID, isElite = ns.GetQuestTagByID(questID)
	local questieDB = QuestieModule("QuestieDB")
	if questieDB and type(questieDB.GetQuestTagInfo) == "function" then
		local found, tagID = pcall(questieDB.GetQuestTagInfo, questID)
		if found and tagID then
			return tagID, isElite
		end
	end
	return clientTagID, isElite
end

--------------------------------------------------------------------------------
-- The Chain
--------------------------------------------------------------------------------

local MAX_PARTS = 25 -- A walk this long has met a loop in the data

-- The part before a quest in a straight chain: its only prerequisite, which names it as the next part
local function PreviousPart(questID)
	local group = Query(questID, "preQuestGroup")
	if type(group) == "table" and next(group) then
		return nil
	end
	local single = Query(questID, "preQuestSingle")
	if type(single) ~= "table" or #single ~= 1 then
		return nil
	end
	if Query(single[1], "nextQuestInChain") == questID then
		return single[1]
	end
end

local function NextPart(questID)
	local nextID = Query(questID, "nextQuestInChain")
	if type(nextID) == "number" and nextID ~= 0 then
		return nextID
	end
end

--[[
	The last chain found, as the quest details repaint in bursts and Questie's data doesn't change in a
	session. Only a chain found is kept: before Questie's database is ready a quest is in none
]]
local lastChain = {}

--[[
	The quest IDs of the chain through questID, first part first, and questID's place in it; nil when
	the quest is in no chain Questie knows. Where a chain branches, only its straight run is followed.
	Callers only read them: the section shows the parts and counts the position in its heading
]]
function ns.GetQuestChain(questID)
	if lastChain.questID == questID then
		return lastChain.parts, lastChain.position
	end
	local parts, seen = { questID }, { [questID] = true }
	local previous = PreviousPart(questID)
	while previous and not seen[previous] and #parts < MAX_PARTS do
		table.insert(parts, 1, previous)
		seen[previous] = true
		previous = PreviousPart(previous)
	end
	local position = #parts
	local nextID = NextPart(questID)
	while nextID and not seen[nextID] and #parts < MAX_PARTS do
		parts[#parts + 1] = nextID
		seen[nextID] = true
		nextID = NextPart(nextID)
	end
	if #parts < 2 then
		return nil
	end
	lastChain.questID, lastChain.parts, lastChain.position = questID, parts, position
	return parts, position
end

-- A part's level badge ("60D", the quest log's tag without its brackets) and its name ("Agent of Hydraxis"), with Questie's level for it
local function PartLabel(questID)
	local title = ns.GetQuestTitleByID(questID) or Query(questID, "name") or tostring(questID)
	local level = Query(questID, "questLevel")
	if type(level) ~= "number" or level <= 0 then
		return nil, title
	end
	return format("%d%s", level, ns.QuestSuffix(QuestTag(questID))), title, level
end

--[[
	The color the quest log gives a part: for a part in the log on WoW Forever, how hard the server rates
	it for the player, as Forever-Quest-List.lua colors it. The server rates only quests in the log, so any
	other part, and every part on Classic, goes by its level against the player's. Nil when neither is known
]]
local function PartColor(questID, level)
	local difficulty = C_PlayerInfo
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer
		and C_QuestLog.GetLogIndexForQuestID
		and C_QuestLog.GetLogIndexForQuestID(questID)
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer(questID)
	if difficulty and GetDifficultyColor then
		return GetDifficultyColor(difficulty)
	end
	if level then
		return GetQuestDifficultyColor(level)
	end
end

ns.QuestChainPartLabel = PartLabel -- For the chain section's rows (Quest-Chain.lua)
ns.QuestChainPartColor = PartColor
