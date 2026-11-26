local _, ns = ...

--[[
	Routes: going along with where the player heads. When the player has been closing in on one objective
	for HEADING_SECONDS, straight at it rather than past it, that objective is their pick: the route plans
	it first (routes.PinEngaged), whatever it would have chosen, and the moving re-plans keep it there. Only
	the nearest objective closed in on counts, within HEADING_REACH; past that the route's own order stands.

	The pick holds until the player turns clearly away from it (HEADING_LEAVE past the nearest they came),
	closes in on another one the same way, gets there (being in its area or at its NPC pins it as working
	there does, Routes-Pinning.lua), finishes it, or changes zone or flies. It wins over a timed or escort
	quest's turn-in too: the player chose where to go.

	Closing in is measured by the distance to the objective falling, not by facing, so a road that bends or a
	step round a mob doesn't break it: each check it may grow HEADING_JITTER at most, and over the whole time
	it must fall by HEADING_SHARE of the yards walked, which a line within about 40 degrees of it gives
]]

local routes = ns.routes

local HEADING_SECONDS = 10 -- Seconds of closing in on an objective that make it the player's pick
local HEADING_MOVE = 40 -- Yards the player walks over them at least, so standing still or turning picks nothing
local HEADING_SHARE = 0.75 -- Of the yards walked, the share the distance to the objective must fall by
local HEADING_JITTER = 5 -- Yards the distance may grow between two checks and still count as closing in
local HEADING_REACH = 500 -- Yards off an objective can be and still be picked by heading for it
local HEADING_LEAVE = 80 -- Yards past the nearest the player came to the pick that let go of it

--[[
	Where the player was at each check, oldest first, each { at, x, y, yards, blobs }: yards is each
	objective's distance then, by node key, and blobs the blob nearest the spot that distance was measured to
]]
local samples = {}

-- The player's pick: { key, blobKey, nearest }, nearest the fewest yards they've come to it since picking it
routes.heading = nil

-- Forgets where the player has been; with forgetPick, the pick too (a new zone, a flight)
function routes.ResetHeading(forgetPick)
	samples = {}
	if forgetPick then
		routes.heading = nil
	end
end

--[[
	Whether a node can go first for being headed to: not a turn-in waiting on its objectives, not anything of
	a quest not taken yet (its pick-up comes first), and not a turn-in planned but hidden
]]
local function IsPickable(node)
	if node.kind == "turnIn" and not node.ready then
		return false
	end
	return not node.predicted and not node.hidden and node.blobs ~= nil and #node.blobs > 0
end

local function Yards(ax, ay, bx, by)
	local dx, dy = ax - bx, ay - by
	return math.sqrt(dx * dx + dy * dy)
end

--[[
	How far a node is from the player, and the blob that's toward: for an objective spread over an area, the
	nearest of its spawns, as the Quest Arrow counts down to it; for one place, the nearest blob's middle
]]
local function Distance(node, x, y)
	local spawns = node.spawns
	local toX, toY, best
	if spawns and spawns.count > 1 then
		local xs, ys = spawns.x, spawns.y
		for i = 1, spawns.count do
			local yards = Yards(xs[i], ys[i], x, y)
			if not best or yards < best then
				best, toX, toY = yards, xs[i], ys[i]
			end
		end
	else
		for _, blob in ipairs(node.blobs) do
			local yards = Yards(blob.x, blob.y, x, y)
			if not best or yards < best then
				best, toX, toY = yards, blob.x, blob.y
			end
		end
	end
	if not best then
		return nil
	end
	local nearestBlob, blobYards
	for _, blob in ipairs(node.blobs) do
		local yards = Yards(blob.x, blob.y, toX, toY)
		if not blobYards or yards < blobYards then
			nearestBlob, blobYards = blob, yards
		end
	end
	return best, nearestBlob
end

-- Whether every sample has the node, its distance never grew more than HEADING_JITTER, and fell enough overall
local function IsClosingIn(key, walked)
	local first, last = samples[1].yards[key], samples[#samples].yards[key]
	if not (first and last) or last > HEADING_REACH then
		return false
	end
	local previous = first
	for i = 2, #samples do
		local yards = samples[i].yards[key]
		if not yards or yards > previous + HEADING_JITTER then
			return false
		end
		previous = yards
	end
	return first - last >= walked * HEADING_SHARE
end

--[[
	Notes where the player is, and changes the pick where the samples say so. Called with each check for
	changes (Routes-Planner.lua). Returns true when the pick changed in a way the route should be planned
	again for: a new pick, or one let go of for turning away. One let go of for being reached or finished
	returns false, as walking in or the quest log changing plans it anyway
]]
function routes.NoteHeading()
	local nodes = routes.nodes
	local x, y, instance = routes.PlayerPosition()
	if not (nodes and x) or UnitIsDeadOrGhost("player") or (routes.start and instance ~= routes.start.instance) then
		samples = {}
		return false
	end

	local now = GetTime()
	local sample = { at = now, x = x, y = y, yards = {}, blobs = {} }
	local byKey = {}
	for _, node in ipairs(nodes) do
		if node.key and IsPickable(node) then
			local yards, blob = Distance(node, x, y)
			if yards then
				sample.yards[node.key], sample.blobs[node.key] = yards, blob
				byKey[node.key] = node
			end
		end
	end
	samples[#samples + 1] = sample
	while #samples > 2 and now - samples[2].at >= HEADING_SECONDS do
		table.remove(samples, 1)
	end

	-- The pick: let go of once reached, finished or turned away from
	local heading = routes.heading
	if heading then
		local node = byKey[heading.key]
		local yards = sample.yards[heading.key]
		if not node or routes.EngagedBlob(node, x, y) then
			routes.heading = nil
			heading = nil
		elseif yards > heading.nearest + HEADING_LEAVE then
			routes.heading = nil
			return true
		else
			heading.nearest = math.min(heading.nearest, yards)
		end
	end

	if #samples < 2 or now - samples[1].at < HEADING_SECONDS then
		return false
	end
	local walked = 0
	for i = 2, #samples do
		walked = walked + Yards(samples[i].x, samples[i].y, samples[i - 1].x, samples[i - 1].y)
	end
	if walked < HEADING_MOVE then
		return false
	end

	-- The nearest objective closed in on, one the player isn't already in
	local pickKey, pickYards
	for key, node in pairs(byKey) do
		local yards = sample.yards[key]
		if
			(not pickYards or yards < pickYards or (yards == pickYards and key < pickKey))
			and IsClosingIn(key, walked)
			and not routes.EngagedBlob(node, x, y)
		then
			pickKey, pickYards = key, yards
		end
	end
	if not pickKey or (heading and heading.key == pickKey) then
		return false
	end
	-- Already the route's first waypoint: the route and the player agree, so nothing need be pinned
	if not heading and routes.DestinationKeys()[pickKey] then
		return false
	end
	local blob = sample.blobs[pickKey]
	routes.heading = { key = pickKey, blobKey = blob and routes.BlobKey(blob), nearest = pickYards }
	return true
end
