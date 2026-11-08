local _, ns = ...

--[[
	Routes: two objectives at once. Where one objective's spawns lie close to another's, or share their
	mobs or objects, the second rides along with the first, so the route does both there (routes.LinkOverlaps)
]]

local routes = ns.routes

local Unworked = routes.Unworked

-- Yards from a one-place objective's spot another objective's spawns can be and still ride along: area reach plus a waypoint's merge
local RIDE_REACH = routes.AREA_REACH + 100
local RIDE_RADIUS = 2 * routes.MIN_STOP_RADIUS -- Yards a rider's area reaches at least, so the arrow treats it as an area
local SHARED_CREDIT = 300 -- Yards nearer a blob counts for each other objective done there too, the sparse penalty's scale

--------------------------------------------------------------------------------
-- Two objectives at once
--------------------------------------------------------------------------------

-- How many of a node's spawns lie within reach of a point
local function SpawnsNear(spawns, x, y, reach)
	local count, reachSquared = 0, reach * reach
	local xs, ys = spawns.x, spawns.y
	for i = 1, spawns.count do
		local dx, dy = xs[i] - x, ys[i] - y
		if dx * dx + dy * dy <= reachSquared then
			count = count + 1
		end
	end
	return count
end

-- Whether a node's blobs name any of the mobs or objects named, so each kill there serves both
local function SharesName(names, blobs)
	for _, blob in ipairs(blobs) do
		for _, name in ipairs(blob.names or {}) do
			if tContains(names, name) then
				return true
			end
		end
	end
	return false
end

-- A node's blob nearest a point
local function NearestBlob(node, x, y)
	local best, bestDistance
	for _, blob in ipairs(node.blobs) do
		local dx, dy = blob.x - x, blob.y - y
		local distance = dx * dx + dy * dy
		if not bestDistance or distance < bestDistance then
			best, bestDistance = blob, distance
		end
	end
	return best
end

--[[
	Sends the route where one trip does two objectives, before PinEngaged (which can still pin any of them
	to the camp the player is working).

	Anchors and riders: an objective whose spawns in the zone are one blob can be done in one place only.
	Another objective with spawns within RIDE_REACH of that place, or naming the same mob, rides along: while
	the anchor is left to do, the rider's only candidate is the anchor's place, so the solver puts both at
	one waypoint (Routes-Stops.lua joins them). The rider gets node.rider, the anchor. Stolen Silver drops
	in one camp of Sunscale Scytheclaws, so Raptor Horns, from raptors all over the Barrens, is done there.

	Shared camps: between spread-out objectives, each blob counts SHARED_CREDIT yards nearer for each other
	objective with a blob within RIDE_REACH of it, so a camp that serves two beats a slightly denser one
	that serves one. The most shared blob joins the candidates if the densest didn't include it
]]
function routes.LinkOverlaps(nodes, yield)
	local objectives = {}
	for _, node in ipairs(nodes) do
		if node.kind == "objective" and node.spawns and node.blobs and #node.blobs > 0 then
			objectives[#objectives + 1] = node
		end
	end

	for _, anchor in ipairs(objectives) do
		if #anchor.blobs == 1 then
			local spot = anchor.blobs[1]
			for _, other in ipairs(objectives) do
				if other ~= anchor and not other.rider and not other.urgent and #other.blobs > 1 then
					local near = SpawnsNear(other.spawns, spot.x, spot.y, RIDE_REACH)
					if near > 0 or SharesName(spot.names or {}, other.blobs) then
						local own = NearestBlob(other, spot.x, spot.y)
						other.rider = anchor
						other.candidates = {
							{
								x = spot.x,
								y = spot.y,
								count = math.max(near, 2),
								radius = math.max(spot.radius, RIDE_RADIUS),
								names = own and own.names or {},
								penalty = 0,
							},
						}
					end
				end
			end
			yield()
		end
	end

	for _, node in ipairs(objectives) do
		if not node.rider and #node.blobs > 1 then
			local usable = Unworked(node.key, node.blobs)
			local shared, best, bestShared = {}, nil, 0
			for _, blob in ipairs(usable) do
				local count = 0
				for _, other in ipairs(objectives) do
					if other ~= node then
						for _, otherBlob in ipairs(other.blobs) do
							local dx, dy = otherBlob.x - blob.x, otherBlob.y - blob.y
							if dx * dx + dy * dy <= RIDE_REACH * RIDE_REACH then
								count = count + 1
								break
							end
						end
					end
				end
				shared[blob] = count
				if count > bestShared then
					best, bestShared = blob, count
				end
			end
			if best then
				if not tContains(node.candidates, best) then
					local densest = usable[1].count or 1
					best.penalty = routes.SPARSE_PENALTY * (1 - (best.count or 1) / densest)
					node.candidates[#node.candidates + 1] = best
				end
				for _, candidate in ipairs(node.candidates) do
					candidate.penalty = (candidate.penalty or 0)
						+ SHARED_CREDIT * (bestShared - (shared[candidate] or 0))
				end
			end
			yield()
		end
	end
end
