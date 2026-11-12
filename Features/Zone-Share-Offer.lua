local _, ns = ...

--[[
	Every client: when the player joins a party, or someone joins theirs, each party member in the player's
	zone is whispered how many of the player's quests for that zone they don't have, and asked whether
	they'd like them shared. It waits ns.ZONE_OFFER_DELAY seconds first, so Questie can swap quest logs.
	A quest counts when the game lets the player share it and it has objectives in the zone, as the
	dungeon share decides (Dungeon-Quest-Lookup.lua). Whether the member has it is read as the quest
	list's party icons read it: the game, while they're close enough to see, or their Questie. One whose
	quests can't be seen either way, or who has every one, isn't whispered. Each member is offered once
	per group, kept through a reload; logging in while in a group counts as joining it. Nothing runs in a
	dungeon, where the dungeon share does this, nor in a raid group, and leaving the group starts over
]]

--------------------------------------------------------------------------------
-- The Offer
--------------------------------------------------------------------------------

--[[
	A party member's name as a whisper takes it, exactly as Good to Go's Rank Watch whispers do: GetUnitName
	with the realm, which on WoW Forever is the whole name, first name and surname ("Snaptrap Mchunter"),
	as the first name alone reaches no one, and elsewhere the name, with the realm when it's another. The
	GUID's record stands in when the unit's name can't be read
]]
local function WhisperTarget(unit)
	local name = GetUnitName(unit, true)
	if ns.IsReadable(name) and type(name) == "string" and name ~= "" and name ~= UNKNOWNOBJECT then
		return name
	end
	local guid = UnitGUID(unit)
	if not (guid and ns.IsReadable(guid)) then
		return nil
	end
	local _, _, _, _, _, guidName, realm = GetPlayerInfoByGUID(guid)
	if not (ns.IsReadable(guidName, realm) and type(guidName) == "string" and guidName ~= "") then
		return nil
	end
	if type(realm) == "string" and realm ~= "" then
		return guidName .. "-" .. realm
	end
	return guidName
end

--[[
	How many of the zone's quests the member doesn't have, or nil when their quests can't be seen: the
	game answers only while they're close enough to see (as the quest list's party icons take it), and
	their Questie only once it has shared something. Quests they've already done count too, as nothing
	says which those are; the share itself tells
]]
local function MissingCount(unit, zoneQuests)
	local routes = ns.routes
	local name = routes and routes.UnitFullName(unit)
	local hasQuestie = name ~= nil and routes.MemberHasQuestie(name)
	local visible = UnitIsVisible(unit)
	local gameSees = ns.IsReadable(visible) and visible == true
	if not (hasQuestie or gameSees) then
		return nil
	end
	local count = 0
	for _, quest in ipairs(zoneQuests) do
		if quest.pushable then
			local answer = ns.IsUnitOnQuest(unit, quest.questID)
			local readable = ns.IsReadable(answer)
			local onQuest = readable and answer and true or false
			if not onQuest and hasQuestie then
				onQuest = routes.QuestieHasUnitOnQuest(unit, quest.questID)
			end
			-- A secret answer, without Questie to say, is never counted as missing
			if not onQuest and (hasQuestie or readable) then
				count = count + 1
			end
		end
	end
	return count
end

--[[
	Tries the offer to one member: "done" once it's whispered or isn't wanted (another zone, nothing they
	lack), "wait" while it can't yet be told; then what was found, for the Sharing Context report. The zone's
	quests are looked up once a check, into the check's table
]]
local function Offer(unit, check)
	if C_ChatInfo.InChatMessagingLockdown() then
		return "wait", "chat lockdown"
	end
	local zone = ns.CurrentZone()
	if not zone then
		-- In a dungeon the dungeon share has it; elsewhere the client won't say where the player is yet
		local _, instanceType = GetInstanceInfo()
		if instanceType == "party" or instanceType == "raid" then
			return "done", "you're in a dungeon"
		end
		return "wait", "your zone unknown"
	end
	local theirs = ns.routes.UnitZone(unit)
	if theirs == nil then
		return "wait", "their zone unknown"
	elseif theirs ~= zone.zoneMapID then
		return "done", string.format("in another zone (%s, you're in %s)", tostring(theirs), tostring(zone.zoneMapID))
	end
	check.zoneQuests = check.zoneQuests or ns.ZoneQuests(zone)
	local count = MissingCount(unit, check.zoneQuests)
	if count == nil then
		return "wait", "their quests can't be seen (not in sight, no Questie log)"
	elseif count == 0 then
		return "done", "has every quest you could share in " .. zone.name
	end
	local target = WhisperTarget(unit)
	if not target then
		return "wait", "their name can't be read"
	end
	ns:Announce("WHISPER", target, ns.ZoneShareOfferFormat(count, zone.name)) -- Announcements.lua
	return "done", string.format("whispered %s: %d quests in %s", target, count, zone.name)
end

--------------------------------------------------------------------------------
-- The Party
--------------------------------------------------------------------------------

local function IsEnabled()
	local profile = ns.db.profile
	return profile.enableQualityOfLife and profile.zoneShareOffer
end

-- The other party members the game has filled in, by GUID, each with its unit; never a raid group's
local function PartyUnits()
	local units = {}
	if IsInRaid() then
		return units
	end
	for index = 1, GetNumSubgroupMembers() do
		local unit = "party" .. index
		local guid = UnitGUID(unit)
		if guid and ns.IsReadable(guid) then
			units[guid] = unit
		end
	end
	return units
end

--[[
	By GUID, every party member seen in this group: when their offer is due (GetTime()), or true once it's
	been made or passed over. Those are kept for the character (ns.db.char.zoneShareOffered), so a reload
	offers no one twice; a login or leaving the group clears them
]]
local members = {}
-- By GUID, what the last try found, for the Sharing Context report
local outcomes = {}
local ticker
-- Nothing is noted until the first loading screen, nor after a login or reload in a group until Questie has been asked for the party's logs
local ready = false

local function Saved()
	return ns.db and ns.db.char.zoneShareOffered
end

-- Done for this group: kept with what was found, so the Sharing Context report can still say why after a reload
local function MarkDone(guid, reason)
	members[guid] = true
	local saved = Saved()
	if saved then
		saved[guid] = reason or true
	end
end

local function Stop()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end
end

--[[
	Every ns.DUNGEON_CHECK_INTERVAL seconds while an offer waits: each one due is tried, and one that still
	can't be told ns.ZONE_OFFER_MAX_WAIT seconds after it was due is let go. A member who left is forgotten
]]
local function Check()
	if not (IsEnabled() and IsInGroup() and not IsInRaid()) then
		Stop()
		return
	end
	local units, now, waiting, check = PartyUnits(), GetTime(), false, {}
	for guid, due in pairs(members) do
		if type(due) == "number" then
			local unit = units[guid]
			if not unit then
				members[guid] = nil
			elseif now >= due then
				local connected = UnitIsConnected(unit)
				local result, reason
				if ns.IsReadable(connected) and not connected then
					result, reason = "done", "offline"
				else
					result, reason = Offer(unit, check)
				end
				if result == "done" then
					MarkDone(guid, reason)
				elseif now - due >= ns.ZONE_OFFER_MAX_WAIT then
					reason = "gave up: " .. reason
					MarkDone(guid, reason)
				else
					waiting = true
				end
				outcomes[guid] = { unit = unit, reason = reason, time = now }
			else
				waiting = true
			end
		end
	end
	if not waiting then
		Stop()
	end
end

-- Notes anyone new in the party, their offer due ns.ZONE_OFFER_DELAY seconds from now, and starts the checks
local function Scan()
	if not ready or not IsInGroup() or IsInRaid() then
		return
	end
	local enabled, saved = IsEnabled(), Saved() or {}
	local due = GetTime() + ns.ZONE_OFFER_DELAY
	for guid in pairs(PartyUnits()) do
		if members[guid] == nil then
			-- With the setting off, those already here are never offered once it's turned on
			if saved[guid] then
				members[guid] = true
			elseif not enabled then
				MarkDone(guid, "the setting was off when they joined")
			else
				members[guid] = due
			end
		end
	end
	for _, value in pairs(members) do
		if type(value) == "number" then
			if not ticker then
				ticker = C_Timer.NewTicker(ns.DUNGEON_CHECK_INTERVAL, Check)
			end
			return
		end
	end
end

--[[
	Questie asks the party for their quest logs only on joining a group, so after a login or reload in one
	it has none of theirs. Once Questie has started (or after ns.ZONE_OFFER_QUESTIE_WAIT seconds), it's
	asked to, as it does on joining, and only then is the party noted, so their offers come
	ns.ZONE_OFFER_DELAY seconds after the request. Without Questie the party is noted at once
]]
local function RequestPartyLogsThenScan()
	if type(Questie) ~= "table" then
		ready = true
		Scan()
		return
	end
	local since, waiter = GetTime(), nil
	waiter = C_Timer.NewTicker(1, function()
		local started = type(Questie) == "table" and Questie.started
		if not started and GetTime() - since < ns.ZONE_OFFER_QUESTIE_WAIT then
			return
		end
		waiter:Cancel()
		if started and IsInGroup() and type(Questie.SendMessage) == "function" then
			pcall(Questie.SendMessage, Questie, "QC_ID_REQUEST_FULL_QUESTLIST")
		end
		ready = true
		Scan()
	end)
end

-- The owner of this file's handlers for events other files handle too (Core.lua)
ns.zoneShareOffer = {}

function ns.zoneShareOffer:OnPlayerEnteringWorld(isInitialLogin, isReloadingUi)
	if not (isInitialLogin or isReloadingUi) then
		Scan()
		return
	end
	-- A login is joining the group afresh; a reload keeps who's been offered
	if isInitialLogin or not IsInGroup() then
		wipe(ns.db.char.zoneShareOffered)
	end
	if IsEnabled() and IsInGroup() and not IsInRaid() then
		RequestPartyLogsThenScan()
		return
	end
	ready = true
	Scan()
end

-- Joining a group is arriving; Questie asks for the new party's logs itself
function ns.zoneShareOffer:OnGroupJoined()
	ready = true
	Scan()
end

function ns.zoneShareOffer:OnGroupRosterUpdate()
	Scan()
end

function ns.zoneShareOffer:OnGroupLeft()
	members, outcomes = {}, {}
	if Saved() then
		wipe(Saved())
	end
	Stop()
end

--------------------------------------------------------------------------------
-- Sharing Context
--------------------------------------------------------------------------------

-- For the Sharing Context report: each party member's unit, whether their offer is due, done or waiting, and what the last try found
function ns.ZoneShareOfferStatus()
	local lines, now = {}, GetTime()
	for guid, unit in pairs(PartyUnits()) do
		local state = members[guid]
		local status = state == true and "done"
			or type(state) == "number" and (state > now and string.format("due in %ds", math.ceil(state - now)) or "trying")
			or "not seen yet"
		local outcome, saved = outcomes[guid], Saved() and Saved()[guid]
		local detail = outcome
				and string.format(" (last try %ds ago: %s)", math.floor(now - outcome.time), outcome.reason)
			or type(saved) == "string" and string.format(" (before the reload: %s)", saved)
			or ""
		lines[#lines + 1] = string.format("%s: %s%s", unit, status, detail)
	end
	table.sort(lines)
	return lines, ready, ticker ~= nil
end
