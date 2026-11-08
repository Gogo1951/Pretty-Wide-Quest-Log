local _, ns = ...

--[[
	Routes: party members' quests, for the partyQuests setting. Questie shares each
	member's quest log over the addon channel (QuestieComms.remoteQuestLogs: by quest, by member, each
	objective's progress); a quest a member has and the player doesn't becomes one the route plans like
	the player's own, with an objective for every one some online member still needs. Its spawns are
	worked out by Questie's own spawn list builder, the one Questie draws a party member's objectives
	with. Only in a party: a raid's every quest would swamp the route
]]

local routes = ns.routes

--[[
	The quests worked out, by quest ID, kept while some member has them: their objectives last from one
	plan to the next, so the blobs worked out from their spawns (cached by objective) are reused
]]
local partyQuests = {}

local function IsInParty()
	return IsInGroup() and not IsInRaid()
end

-- A name Questie keys a shared log by, without a realm after a hyphen
local function ShortName(name)
	return Ambiguate(name, "short")
end

--[[
	A unit's name as Questie keys its shared logs, the Quest Arrow lists it and its menu switches it. On
	WoW Forever every character has a surname, which UnitName returns where other clients put the realm,
	and Questie's key is both ("Cyralene Black"); elsewhere it's the first name alone, the realm left off
]]
function routes.UnitFullName(unit)
	local first, second = UnitName(unit)
	if not (ns.IsReadable(first) and type(first) == "string") then
		return nil
	end
	if ns.FLAVOR == "Camelot" and ns.IsReadable(second) and type(second) == "string" and second ~= "" then
		return first .. " " .. second
	end
	return first
end

-- The party unit for a name Questie keys a shared log by, or nothing for one not in the party
local function UnitFor(name)
	local short = ShortName(name)
	for i = 1, 4 do
		local unit = "party" .. i
		local full = UnitExists(unit) and routes.UnitFullName(unit)
		if full and (full == name or ShortName(full) == short) then
			return unit
		end
	end
end

-- Whether a member Questie has a shared log for is in another zone than the player
function routes.IsMemberOutOfZone(name)
	local unit = UnitFor(name)
	return unit ~= nil and routes.IsUnitOutOfZone(unit)
end

--[[
	A member counts while online, in the player's zone, showing the quest, and not ignored from the Quest
	Arrow's menu (routes.ignoredMembers): Questie lets a member hide one from the party
]]
local function IsSharing(name, questID, visibility)
	if routes.ignoredMembers[ShortName(name)] then
		return false
	end
	if not UnitIsConnected(name) then
		return false
	end
	if routes.IsMemberOutOfZone(name) then
		return false
	end
	if visibility and type(visibility.ShouldShowPartyObjective) == "function" then
		local ok, shown = pcall(visibility.ShouldShowPartyObjective, visibility, name, questID)
		if ok and shown == false then
			return false
		end
	end
	return true
end

-- What an objective is after, by name, for one whose quest data gives no text
local function TargetName(QuestieDB, objectiveType, id)
	local query
	if objectiveType == "monster" or objectiveType == "killcredit" then
		query = QuestieDB.QueryNPCSingle
	elseif objectiveType == "object" then
		query = QuestieDB.QueryObjectSingle
	elseif objectiveType == "item" then
		query = QuestieDB.QueryItemSingle
	end
	if type(query) == "function" and id then
		local ok, name = pcall(query, id, "name")
		if ok and type(name) == "string" then
			return name
		end
	end
end

-- Every spawn of what an objective is after, as Questie lists them for the player's own objectives
local function SpawnList(objective, objectiveData)
	local QuestieQuest = ns.ImportQuestieModule("QuestieQuest")
	local builders = QuestieQuest
		and type(QuestieQuest.private) == "table"
		and QuestieQuest.private.objectiveSpawnListCallTable
	local build = type(builders) == "table" and builders[objectiveData.Type]
	if type(build) ~= "function" then
		return {}
	end
	local ok, list = pcall(build, objectiveData.Id, objective, objectiveData)
	return ok and type(list) == "table" and list or {}
end

-- A color for an objective, as Questie gives each of the player's own
local function NewColor()
	local QuestieLib = ns.ImportQuestieModule("QuestieLib")
	if QuestieLib and type(QuestieLib.ColorWheel) == "function" then
		local ok, color = pcall(QuestieLib.ColorWheel, QuestieLib)
		if ok and type(color) == "table" then
			return color
		end
	end
end

--[[
	What the sharing members have of a quest, by objective: how many each needs, the fewest any of them
	has of it, and who still needs it
]]
local function GatherProgress(questID, players, visibility)
	local progress, sharing = {}, false
	for name, objectives in pairs(players) do
		if type(name) == "string" and type(objectives) == "table" and IsSharing(name, questID, visibility) then
			sharing = true
			for index, remote in pairs(objectives) do
				if type(index) == "number" and type(remote) == "table" then
					local entry = progress[index] or { needed = {} }
					progress[index] = entry
					entry.required = tonumber(remote.required) or entry.required
					if not remote.finished then
						entry.needed[#entry.needed + 1] = ShortName(name)
						local has = tonumber(remote.fulfilled) or 0
						entry.collected = entry.collected and math.min(entry.collected, has) or has
					end
				end
			end
		end
	end
	return sharing and progress or nil
end

--[[
	A party quest as the route plans it, shaped as Questie's quest log has the player's own: name,
	level, and Objectives each with Description, Collected, Needed, Completed and spawnList. Questie's spawn
	list builder is the slow part, so yield follows each new objective's
]]
local function PartyQuest(questID, players, QuestieDB, visibility, yield)
	local progress = GatherProgress(questID, players, visibility)
	if not progress then
		return nil
	end
	local quest = partyQuests[questID]
	if not quest then
		local ok, data = pcall(QuestieDB.GetQuest, questID)
		if not (ok and type(data) == "table") then
			return nil
		end
		quest = {
			Id = questID,
			name = data.name,
			level = data.level,
			Objectives = {},
			objectiveData = type(data.ObjectiveData) == "table" and data.ObjectiveData or {},
			party = true,
		}
		partyQuests[questID] = quest
	end
	for index, entry in pairs(progress) do
		local data = quest.objectiveData[index]
		if type(data) == "table" and data.Type then
			local objective = quest.Objectives[index]
			if not objective then
				local text = type(data.Text) == "string" and data.Text ~= "" and data.Text or nil
				objective = {
					Index = index,
					questId = questID,
					Type = data.Type,
					Id = data.Id,
					Icon = data.Icon,
					Description = text or TargetName(QuestieDB, data.Type, data.Id) or "",
					Color = NewColor(),
					party = true,
				}
				objective.spawnList = SpawnList(objective, data)
				quest.Objectives[index] = objective
				if yield then
					yield()
				end
			end
			objective.Needed = entry.required
			objective.Collected = entry.collected or entry.required
			objective.Completed = #entry.needed == 0
			table.sort(entry.needed)
			objective.members = entry.needed
		end
	end
	return quest
end

-- Questie's party quest logs, by quest ID, while the setting is on and the player is in a party
local function RemoteLogs()
	local QuestieComms = ns.ImportQuestieModule("QuestieComms")
	local logs = QuestieComms and QuestieComms.remoteQuestLogs
	if routes.Settings().partyQuests and IsInParty() and type(logs) == "table" then
		return logs
	end
end

--[[
	The party's quests the player doesn't have (ownLog, Questie's quest log, by quest ID), by quest ID;
	none while the setting is off or the player isn't in a party. With yield, it's called after each new
	objective's spawns are worked out, so a party just joined is spread over frames
]]
function routes.PartyQuests(ownLog, yield)
	local found = {}
	local logs = RemoteLogs()
	local QuestieDB = ns.ImportQuestieModule("QuestieDB")
	if logs and QuestieDB and type(QuestieDB.GetQuest) == "function" then
		local visibility = ns.ImportQuestieModule("CommsVisibility")
		-- Listed first: Questie can add to its logs while a yield waits, which a pairs walk can't take
		local questIDs = {}
		for questID, players in pairs(logs) do
			if type(questID) == "number" and not ownLog[questID] and type(players) == "table" then
				questIDs[#questIDs + 1] = questID
			end
		end
		for _, questID in ipairs(questIDs) do
			local players = logs[questID]
			if type(players) == "table" then
				found[questID] = PartyQuest(questID, players, QuestieDB, visibility, yield)
			end
		end
	end
	for questID in pairs(partyQuests) do
		if not found[questID] then
			partyQuests[questID] = nil
		end
	end
	return found
end

--[[
	What routes.PartyQuests would find, cheaply, for the check for changes: by quest ID, each objective's
	progress (GatherProgress) by index. Nothing is asked of Questie's database, so it's quick enough to run
	every check however many quests the party has
]]
function routes.PartyProgress(ownLog)
	local found = {}
	local logs = RemoteLogs()
	if logs then
		local visibility = ns.ImportQuestieModule("CommsVisibility")
		for questID, players in pairs(logs) do
			if type(questID) == "number" and not ownLog[questID] and type(players) == "table" then
				found[questID] = GatherProgress(questID, players, visibility)
			end
		end
	end
	return found
end

-- The key Questie's party map icons are told apart by: the quest, and the objective's place in it
function routes.PartyObjectiveKey(questID, index)
	return "party:" .. tostring(questID) .. ":" .. tostring(index)
end

function routes.IsInParty()
	return IsInParty()
end

--[[
	Whether the route's lists show the party: in a party with Show Party Objectives (partyQuests) on. With it
	off, the arrow and the map's tooltip list the player's objectives as they do alone, with no names
]]
function routes.ShowsParty()
	return routes.Settings().partyQuests and IsInParty() or false
end

--[[
	The online party members, each { unit, name }: name as routes.UnitFullName gives it. With includeOffline,
	the offline ones too, each with offline set. Sorted by name
]]
function routes.PartyMembers(includeOffline)
	local members = {}
	if not IsInParty() then
		return members
	end
	for i = 1, 4 do
		local unit = "party" .. i
		local name = UnitExists(unit) and routes.UnitFullName(unit)
		if name and name ~= UNKNOWNOBJECT then
			local online = UnitIsConnected(unit)
			if online or includeOffline then
				members[#members + 1] = { unit = unit, name = name, offline = not online or nil }
			end
		end
	end
	table.sort(members, function(a, b)
		return a.name < b.name
	end)
	return members
end

--[[
	Whether a party member (name as routes.UnitFullName gives it) has shared anything over Questie: a quest
	in its party logs, or the class it sends with them. One without Questie shares nothing, and the game
	itself tells nothing of another player's quests the player doesn't have. One with Questie and no quests,
	or just joined, before their first share arrives, reads as without it too
]]
function routes.MemberHasQuestie(name)
	local QuestieComms = ns.ImportQuestieModule("QuestieComms")
	if not QuestieComms then
		return false
	end
	local short = ShortName(name)
	local function Holds(byName)
		if type(byName) ~= "table" then
			return false
		end
		if byName[name] ~= nil then
			return true
		end
		for key in pairs(byName) do
			if type(key) == "string" and ShortName(key) == short then
				return true
			end
		end
		return false
	end
	if Holds(QuestieComms.remotePlayerClasses) then
		return true
	end
	for _, players in pairs(type(QuestieComms.remoteQuestLogs) == "table" and QuestieComms.remoteQuestLogs or {}) do
		if Holds(players) then
			return true
		end
	end
	return false
end

--[[
	The online party members Questie has a quest log for who have a quest, each { name, shortName,
	objectives }: objectives by index, each with fulfilled, required and finished, as Questie shares them.
	Sorted by name; none outside a party
]]
function routes.MemberProgress(questID)
	local members = {}
	local QuestieComms = ns.ImportQuestieModule("QuestieComms")
	local logs = IsInParty() and QuestieComms and QuestieComms.remoteQuestLogs
	local players = type(logs) == "table" and logs[questID]
	if type(players) ~= "table" then
		return members
	end
	local visibility = ns.ImportQuestieModule("CommsVisibility")
	local self = routes.UnitFullName("player")
	for name, objectives in pairs(players) do
		if type(name) == "string" and type(objectives) == "table" and IsSharing(name, questID, visibility) then
			local shortName = ShortName(name)
			if shortName ~= self then
				members[#members + 1] = { name = name, shortName = shortName, objectives = objectives }
			end
		end
	end
	table.sort(members, function(a, b)
		return a.shortName < b.shortName
	end)
	return members
end
