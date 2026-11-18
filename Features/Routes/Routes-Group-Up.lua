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

	Dead, the player has no joining up: the arrow runs them back to their corpse. While a member is dead,
	the rest join up at where their body lies instead, the middle of the bodies if more than one, by the same
	APART and TOGETHER yards; a member's ghost is at the graveyard, so it's never where to head. The game says
	where only the player's own corpse is, so a member's is where they were when they died, or last seen alive
	if they'd released before it could be seen, and nothing if they were a ghost all along
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
local corpses = {} -- Where each dead member's body lies, by unit name, kept until they're alive again
local meetingCorpse = false -- Whether the last spot to head for was a dead member's body

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
	Whether an online member is dead, and whether as a ghost: their body lies where they died, a ghost is at
	the graveyard. Nothing where WoW Forever keeps it secret
]]
local function DeathOf(unit)
	local dead, ghost = UnitIsDeadOrGhost(unit), UnitIsGhost(unit)
	if not ns.IsReadable(dead, ghost) then
		return nil
	end
	return dead and true or false, ghost and true or false
end

--[[
	Alive, a member has no body. Once a ghost, theirs is kept as it was; one not seen dead first, as one who
	released within a check, lies where they were last seen alive. Dead and not released, where they stand is
	their body, set with their place (Others)
]]
local function NoteCorpse(name, dead, ghost)
	if not dead then
		corpses[name] = nil
	elseif ghost and not corpses[name] then
		local last = lastSeen[name]
		corpses[name] = last and { x = last.x, y = last.y, instance = last.instance, zone = last.zone } or nil
	end
end

--[[
	The places of the online members in the player's zone, on the player's continent, alive: each one's last
	known place where WoW Forever keeps their map, position or connection secret. Then the bodies of the dead
	ones that lie here, and whether any was secret
]]
local function Others(zone, instance)
	local others, bodies, seen, anySecret = {}, {}, {}, false
	for _, member in ipairs(routes.PartyMembers(true)) do
		local name = member.name
		seen[name] = true
		local secret = member.unknown or not ns.IsReadable(C_Map.GetBestMapForUnit(member.unit))
		anySecret = anySecret or secret
		local dead, ghost
		if not member.offline then
			dead, ghost = DeathOf(member.unit)
			if dead == nil then
				-- Secret: as dead as last seen, and a body kept as it was, since they may have released
				dead = corpses[name] ~= nil
				ghost = dead
			else
				NoteCorpse(name, dead, ghost)
			end
		end
		local here = not member.offline and routes.UnitZone(member.unit) == zone
		if here and not ghost then
			local x, y, memberInstance = routes.UnitWorldPosition(member.unit)
			if x then
				lastSeen[name] = { x = x, y = y, instance = memberInstance, zone = zone }
				if dead then
					corpses[name] = lastSeen[name] -- Not released: where they stand is their body
				end
			end
		end
		if dead then
			local body = corpses[name]
			if body and body.zone == zone and body.instance == instance then
				bodies[#bodies + 1] = body
			end
		elseif here or secret then
			local last = lastSeen[name]
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
	for name in pairs(corpses) do
		if not seen[name] then
			corpses[name] = nil
		end
	end
	return others, bodies, anySecret
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
	if not IsWanted() or UnitIsDeadOrGhost("player") then
		joining, meetingCorpse = false, false -- Dead, the arrow runs the player back to their corpse
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
	local others, bodies, anySecret = Others(zone, instance)
	meetingCorpse = #bodies > 0
	if meetingCorpse then
		-- A member is dead: join up at where the body lies, the middle of the bodies if more than one
		local sumX, sumY = 0, 0
		for _, body in ipairs(bodies) do
			sumX, sumY = sumX + body.x, sumY + body.y
		end
		place.x, place.y, place.instance = sumX / #bodies, sumY / #bodies, instance
		local away = hereBeDragons:GetWorldDistance(instance, x, y, place.x, place.y) or 0
		if away <= TOGETHER then
			joining = false
		elseif away > APART then
			joining = true
		end
		return joining and place or nil
	end
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
	if UnitIsDeadOrGhost("player") then
		return "off while dead"
	end
	local state = joining and "joining up" or "together"
	return meetingCorpse and state .. " at a member's corpse" or state
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
