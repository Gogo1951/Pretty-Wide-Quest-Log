local _, ns = ...

--[[
	Routes: joining up with the group, for the groupUp setting. In a party, once anyone in the player's zone is
	off the player's minimap, farther than it shows at its widest (APART), the Quest Arrow says "Join Up with
	Group" and points to the middle of everyone and the group's first waypoint (Routes-Arrow.lua), so the group
	meets on the way to what it does together first; the world map marks the spot (Routes-Map.lua). Every
	client works the same out alone, so the members head toward each other and gather near it. It needs Party
	Objectives (partyQuests) on too: with the party's quests off the route, the player is questing alone.

	It lasts until everyone here is within TOGETHER yards, so drifting a little apart doesn't start it again,
	or until the player changes zone. There's no skipping it, which nothing could undo: the setting turns it
	off. Only in a party: in a raid group the arrow hides by default and there's no one place to meet
]]

local routes = ns.routes

-- The owner of this file's event handlers in Core.lua's EVENTS
local routesGroupUp = {}
ns.routesGroupUp = routesGroupUp

local CHECK_INTERVAL = 1 -- Seconds between checks of where everyone is
--[[
	Yards from a member past which the group is joined up again: off the minimap at its widest outdoor zoom,
	about 466 yards across
]]
local APART = 233
local TOGETHER = 40 -- Yards from every member within which the group counts as together again

local joining = false -- Anyone went off the minimap, and not everyone is together since
local myZone -- The zone of the last check, so a new one starts afresh
local lastSeen = {} -- Each member's last known place, by unit name, kept while the client won't say

--[[
	Where the arrow and the map's marker lead while joining up: { x, y, instance } in world yards, one table
	moved in place each check
]]
local place = {}
routes.groupUpTarget = nil

-- Whether joining up is wanted now: the setting and Party Objectives on, in a party, out of instances
local function IsWanted()
	local settings = routes.Settings()
	return settings.groupUp and settings.partyQuests and routes.IsInParty() and (IsInInstance()) ~= true
end

--[[
	The places of the online members in the player's zone, on the player's continent: each one's last known
	place where WoW Forever keeps their map, position or connection secret. Also whether any was secret
]]
local function Others(zone, instance)
	local others, seen, anySecret = {}, {}, false
	for _, member in ipairs(routes.PartyMembers(true)) do
		seen[member.name] = true
		local secret = member.unknown or not ns.IsReadable(C_Map.GetBestMapForUnit(member.unit))
		anySecret = anySecret or secret
		local here = not member.offline and routes.UnitZone(member.unit) == zone
		if here then
			local x, y, memberInstance = routes.UnitWorldPosition(member.unit)
			if x then
				lastSeen[member.name] = { x = x, y = y, instance = memberInstance, zone = zone }
			end
		end
		if here or secret then
			local last = lastSeen[member.name]
			if last and last.zone == zone and last.instance == instance then
				others[#others + 1] = last
			end
		end
	end
	for name in pairs(lastSeen) do
		if not seen[name] then
			lastSeen[name] = nil -- Gone from the party
		end
	end
	return others, anySecret
end

--[[
	The route's first waypoint the group works on together: a party member's quest, or one of the player's a
	member has too. The first waypoint of all where there's none. Only on the player's continent
]]
local function GroupWaypoint(instance)
	local first
	for _, stop in ipairs(routes.stops) do
		if stop.instance == instance then
			first = first or stop
			for _, task in ipairs(stop.tasks or {}) do
				if task.party or (task.questID and routes.PartyHasQuest(task.questID)) then
					return stop
				end
			end
		end
	end
	return first
end

--[[
	The place to head for: the middle of everyone, the player too, and the group's first waypoint, so the
	meeting is on the way to it. Nothing while the group is together
]]
local function Target()
	if not IsWanted() then
		joining = false
		return nil
	end
	local zone = routes.PlayerZone()
	if zone ~= myZone then
		myZone, joining = zone, false
	end
	local x, y, instance = routes.PlayerPosition()
	local hereBeDragons = routes.HereBeDragons()
	if not (x and zone and hereBeDragons) then
		return nil
	end
	local others, anySecret = Others(zone, instance)
	if #others == 0 and anySecret then
		-- Nobody can be placed while it's secret, so joining up and its spot stay as they were
		return joining and routes.groupUpTarget or nil
	end
	local farthest = 0
	for _, other in ipairs(others) do
		farthest = math.max(farthest, hereBeDragons:GetWorldDistance(instance, x, y, other.x, other.y) or 0)
	end
	if farthest <= TOGETHER then
		joining = false
	elseif farthest > APART then
		joining = true
	end
	if not joining then
		return nil
	end
	local sumX, sumY, count = x, y, #others + 1
	for _, other in ipairs(others) do
		sumX, sumY = sumX + other.x, sumY + other.y
	end
	local waypoint = GroupWaypoint(instance)
	if waypoint then
		sumX, sumY, count = sumX + waypoint.x, sumY + waypoint.y, count + 1
	end
	place.x, place.y = sumX / count, sumY / count
	place.instance = instance
	return place
end

-- Sets what the arrow and map show; both are refreshed when whether there's somewhere to head changes
local function Publish(target)
	local changed = (target ~= nil) ~= (routes.groupUpTarget ~= nil)
	routes.groupUpTarget = target
	if changed and routes.RefreshArrow then
		routes.RefreshArrow()
	end
	if changed and routes.RefreshGroupUpMarker then
		routes.RefreshGroupUpMarker() -- Its marker on the world map (Routes-Map.lua)
	end
end

-- For the Routes Context report: the state alone, no names or places
function routes.GroupUpState()
	return joining and "joining up" or "together"
end

local checker = CreateFrame("Frame")
local sinceCheck = 0
checker:SetScript("OnUpdate", function(_, elapsed)
	sinceCheck = sinceCheck + elapsed
	if sinceCheck >= CHECK_INTERVAL then
		sinceCheck = 0
		Publish(Target())
	end
end)

-- A login, reload or new area: checked on the next frame
function routesGroupUp:OnPlayerEnteringWorld()
	sinceCheck = CHECK_INTERVAL
end
