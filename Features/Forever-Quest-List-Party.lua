local _, ns = ...

--[[
	WoW Forever and Mists: which party members have a quest, for the quest list's rows (Forever-Quest-List.lua):
	the count beside a quest's title, and the names on hovering it
]]

--[[
	Whether a party unit has a quest. The game only answers for members in range, so where it says no (or keeps
	the answer secret) a share from the member's Questie counts too (Routes-Party.lua). The second return is
	whether a "no" is unknown rather than known: the answer stayed secret, or the member is out of range
]]
local function IsPartyMemberOnQuest(unit, questID, questLogIndex)
	local onQuest = ns.IsUnitOnQuest(unit, questID, questLogIndex)
	local readable = ns.IsReadable(onQuest)
	if readable and onQuest then
		return true, false
	end
	if ns.routes and ns.routes.QuestieHasUnitOnQuest(unit, questID) then
		return true, false
	end
	local visible = UnitIsVisible(unit)
	return false, not (readable and ns.IsReadable(visible) and visible)
end

--[[
	How many party members have a quest, their names (class-colored where the class is readable), and whether
	any member's answer is unknown (IsPartyMemberOnQuest). Only the player's party (their raid subgroup in a
	raid). A secret name or class only leaves the member's name off the tooltip
]]
local function GetPartyOnQuest(questID, questLogIndex)
	local count, names, anyUnknown = 0, {}, false
	if not IsInGroup() then
		return count, names, anyUnknown
	end
	for index = 1, GetNumSubgroupMembers() do
		local unit = "party" .. index
		local onQuest, unknown = IsPartyMemberOnQuest(unit, questID, questLogIndex)
		if onQuest then
			count = count + 1
			local name = GetUnitName(unit, true)
			local _, class = UnitClass(unit)
			if name and ns.IsReadable(name) then
				local color = class and ns.IsReadable(class) and RAID_CLASS_COLORS[class]
				names[#names + 1] = color and color:WrapTextInColorCode(name) or name
			end
		elseif unknown then
			anyUnknown = true
		end
	end
	return count, names, anyUnknown
end

-- How many party members have a quest, for the row's count: GetPartyOnQuest without the tooltip's names
function ns.CountPartyOnQuest(questID, questLogIndex)
	local count = 0
	if not IsInGroup() then
		return count
	end
	for index = 1, GetNumSubgroupMembers() do
		if IsPartyMemberOnQuest("party" .. index, questID, questLogIndex) then
			count = count + 1
		end
	end
	return count
end

--[[
	While in a group, hovering a quest's row lists the party members who have it, as Blizzard's own quest
	log rows do on Classic Era and TBC, under the client's own labels. With any answer unknown (secret, or a
	member out of range), "none" would be a guess, so it isn't shown
]]
function ns.ShowPartyOnQuest(row, questID, questLogIndex)
	if not IsInGroup() then
		return
	end
	local count, names, anyUnknown = GetPartyOnQuest(questID, questLogIndex)
	if count == 0 and (anyUnknown or not PARTY_QUEST_STATUS_NONE) then
		return
	end
	if count > 0 and not PARTY_QUEST_STATUS_ON then
		return
	end
	GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
	if count > 0 then
		GameTooltip:AddLine(PARTY_QUEST_STATUS_ON)
		for _, name in ipairs(names) do
			GameTooltip:AddLine(name)
		end
	else
		GameTooltip:AddLine(PARTY_QUEST_STATUS_NONE, 1, 1, 1)
	end
	GameTooltip:Show()
end
