local _, ns = ...

--[[
	Every client: who in the group needs a quest shared, for Share Quests, the dungeon share and the Zone
	Share Offer to leave out those who have it, and on WoW Forever only, sharing one asked for in combat once
	combat ends
]]

--------------------------------------------------------------------------------
-- Who Needs a Share
--------------------------------------------------------------------------------

-- The group's other members, as units: the raid's, or the party's
local function GroupUnits()
	local units = {}
	if IsInRaid() then
		for index = 1, GetNumGroupMembers() do
			local unit = "raid" .. index
			if not UnitIsUnit(unit, "player") then
				units[#units + 1] = unit
			end
		end
	else
		for index = 1, GetNumSubgroupMembers() do
			units[#units + 1] = "party" .. index
		end
	end
	return units
end

--[[
	Whether a member is known to have a quest already: the game says so (only for members in range), or
	their Questie has shared that they do (Routes-Party.lua), from any distance
]]
local function IsKnownOnQuest(unit, questID, questLogIndex)
	local onQuest = ns.IsUnitOnQuest(unit, questID, questLogIndex)
	if ns.IsReadable(onQuest) and onQuest then
		return true
	end
	return ns.routes ~= nil and ns.routes.QuestieHasUnitOnQuest(unit, questID)
end

--[[
	Whether sharing a quest would reach anyone who doesn't have it yet: some online member among units
	(every other group member when none are given) isn't known to have it. A member the game can't answer
	for, out of range or kept secret, without Questie saying, counts as needing it, so a share is only left
	out when everyone it could reach already has the quest. A caller that knows the quest's log index
	passes it, for clients that look a unit's quests up by index (ns.IsUnitOnQuest)
]]
function ns.PartyNeedsQuest(questID, questLogIndex, units)
	for _, unit in ipairs(units or GroupUnits()) do
		local connected = UnitExists(unit) and UnitIsConnected(unit)
		local offline = ns.IsReadable(connected) and not connected
		if not offline and not IsKnownOnQuest(unit, questID, questLogIndex) then
			return true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Sharing After Combat
--------------------------------------------------------------------------------

if C_QuestLog.GetInfo then
	--[[
		WoW Forever blocks QuestLogPushQuest in combat for add-on code, a click on the add-on's own button
		included, and no secure button or slash command shares a quest. So a share asked for in combat says
		so in chat and goes out when combat ends (Core's EVENTS, owner "shareNeeds"), if the quest is still
		shareable and the party still there; a second one asked for meanwhile takes its place
	]]
	local pendingShare
	ns.shareNeeds = {}

	function ns.shareNeeds:OnPlayerRegenEnabled()
		local questID = pendingShare
		pendingShare = nil
		if
			questID
			and C_QuestLog.GetLogIndexForQuestID(questID)
			and C_QuestLog.IsPushableQuest(questID)
			and IsInGroup()
		then
			ns.TrackerTaintStep(
				"QuestMapQuestOptions_ShareQuest after combat",
				QuestMapQuestOptions_ShareQuest,
				questID
			)
		end
	end

	-- Mists shares in combat as it is asked, so only WoW Forever holds it
	function ns.ShareQuest(questID)
		if ns.FLAVOR == "Camelot" and InCombatLockdown() then
			pendingShare = questID
			ns:PrintMessage(ns.L["CHAT_SHARING_AFTER_COMBAT"]:format(C_QuestLog.GetTitleForQuestID(questID) or questID))
			return
		end
		ns.TrackerTaintStep("QuestMapQuestOptions_ShareQuest", QuestMapQuestOptions_ShareQuest, questID)
	end
end
