local _, ns = ...

--[[
	Routes: an objective's spawns gathered into blobs, the places the route can send the player to do it,
	and the candidates among them that it offers the solver (Routes-Solver.lua)
]]

local routes = ns.routes

local IsInZone = routes.IsInZone

local CLUSTER_RADIUS = 180 -- Yards from a blob's middle its spawns lie within, as the quest map's areas
local MAX_CANDIDATES = 6 -- Blobs an objective offers the route at most: the densest, and the nearest
local SPARSE_PENALTY = 300 -- Yards a blob with few spawns counts as further away than the densest
local MIN_STOP_RADIUS = 30 -- Yards from a stop's middle that count as being there, for a blob of one spawn
local NAME_LIMIT = 4 -- NPCs or objects a blob names at most
local SPAWNS_PER_YIELD = 64

-- Routes-Stops.lua sizes and names stops by the same
routes.MIN_STOP_RADIUS, routes.NAME_LIMIT = MIN_STOP_RADIUS, NAME_LIMIT

local HBD

local function HereBeDragons()
	HBD = HBD or LibStub("HereBeDragonsQuestie-2.0", true)
	return HBD
end

--------------------------------------------------------------------------------
-- Spawns into blobs
--------------------------------------------------------------------------------

--[[
	Spawns as three flat lists (x, y, name by index) and a count, not a table each: an objective can have
	hundreds of spawns, and a table apiece would be most of the memory a plan uses
]]
local function NewPoints()
	return { x = {}, y = {}, name = {}, count = 0 }
end
routes.NewPoints = NewPoints

--[[
	Adds each spawn in a Questie spawn table ({ [areaID] = { { x, y, phase }, ... } }, x and y 0-100) to
	points, in world yards, where it's in the zone and Questie's phasing shows it
]]
local function AddSpawns(points, spawns, name, start, yield)
	local hbd = HereBeDragons()
	local ZoneDB = ns.ImportQuestieModule("ZoneDB")
	local Phasing = ns.ImportQuestieModule("Phasing")
	if not (hbd and ZoneDB and ZoneDB.GetUiMapIdByAreaId and type(spawns) == "table") then
		return
	end
	local checkPhase = Phasing and Phasing.IsSpawnVisible
	local xs, ys, names = points.x, points.y, points.name
	for areaID, list in pairs(spawns) do
		local mapID = ZoneDB:GetUiMapIdByAreaId(areaID)
		if mapID and type(list) == "table" and IsInZone(mapID, start.zone) then
			for i, spawn in ipairs(list) do
				local x, y = spawn[1], spawn[2]
				if x and y and x >= 0 and y >= 0 and (not checkPhase or Phasing.IsSpawnVisible(spawn[3])) then
					local worldX, worldY, worldInstance = hbd:GetWorldCoordinatesFromZone(x / 100, y / 100, mapID)
					if worldX and worldInstance == start.instance then
						local n = points.count + 1
						points.count = n
						xs[n], ys[n], names[n] = worldX, worldY, name or false
					end
				end
				if i % SPAWNS_PER_YIELD == 0 then
					yield()
				end
			end
		end
	end
end
routes.AddSpawns = AddSpawns

local function ByCountThenPosition(a, b)
	if a.count ~= b.count then
		return a.count > b.count
	end
	if a.x ~= b.x then
		return a.x < b.x
	end
	return a.y < b.y
end

--[[
	Gathers points into blobs: first into a grid of CLUSTER_RADIUS squares, then, densest square first,
	each takes in the squares whose middles lie within CLUSTER_RADIUS of its own moving middle. The spawns
	are passed over twice, so thousands cost little; the squares are compared pairwise, which stays cheap
	because spawns crowd into far fewer squares than there are spawns, and a yield follows each blob.

	Squares are kept as flat lists by number too, and each spawn only notes its square; one last pass over
	the spawns finds each blob's reach and names. Each blob is { x, y, count, radius, names }
]]
local function Cluster(points, yield)
	local xs, ys, names = points.x, points.y, points.name
	local cellOf, cellIndex = {}, {}
	local sumX, sumY, counts = {}, {}, {}
	local cellCount = 0
	for i = 1, points.count do
		-- A number for the square, not a string: continents are well under 65536 squares across
		local key = math.floor(xs[i] / CLUSTER_RADIUS) * 65536 + math.floor(ys[i] / CLUSTER_RADIUS)
		local cell = cellIndex[key]
		if not cell then
			cellCount = cellCount + 1
			cell = cellCount
			cellIndex[key] = cell
			sumX[cell], sumY[cell], counts[cell] = 0, 0, 0
		end
		cellOf[i] = cell
		sumX[cell], sumY[cell], counts[cell] = sumX[cell] + xs[i], sumY[cell] + ys[i], counts[cell] + 1
	end

	-- Squares densest first, as the same spawns always give the same blobs
	local order, middleX, middleY = {}, {}, {}
	for cell = 1, cellCount do
		order[cell] = cell
		middleX[cell], middleY[cell] = sumX[cell] / counts[cell], sumY[cell] / counts[cell]
	end
	table.sort(order, function(a, b)
		if counts[a] ~= counts[b] then
			return counts[a] > counts[b]
		end
		if middleX[a] ~= middleX[b] then
			return middleX[a] < middleX[b]
		end
		return middleY[a] < middleY[b]
	end)

	local blobs, blobOf = {}, {}
	local reach = CLUSTER_RADIUS * CLUSTER_RADIUS
	for i, seed in ipairs(order) do
		if not blobOf[seed] then
			local blob = { x = 0, y = 0, count = 0, radius = 0, names = {} }
			blobs[#blobs + 1] = blob
			blobOf[seed] = blob
			local bx, by, bn = sumX[seed], sumY[seed], counts[seed]
			for j = i + 1, cellCount do
				local other = order[j]
				if not blobOf[other] then
					local dx, dy = middleX[other] - bx / bn, middleY[other] - by / bn
					if dx * dx + dy * dy <= reach then
						blobOf[other] = blob
						bx, by, bn = bx + sumX[other], by + sumY[other], bn + counts[other]
					end
				end
			end
			blob.x, blob.y, blob.count = bx / bn, by / bn, bn
			yield()
		end
	end

	-- How far each blob's spawns reach from its middle, and who they are
	for i = 1, points.count do
		local blob = blobOf[cellOf[i]]
		local dx, dy = xs[i] - blob.x, ys[i] - blob.y
		local distance = dx * dx + dy * dy
		if distance > blob.radius then
			blob.radius = distance
		end
		local name = names[i]
		if name and #blob.names < NAME_LIMIT and not tContains(blob.names, name) then
			blob.names[#blob.names + 1] = name
		end
	end
	for _, blob in ipairs(blobs) do
		blob.radius = math.max(MIN_STOP_RADIUS, math.sqrt(blob.radius))
		table.sort(blob.names)
	end
	table.sort(blobs, ByCountThenPosition)
	return blobs
end
routes.Cluster = Cluster

--[[
	The blobs a node offers the route: the MAX_CANDIDATES densest, with the nearest to the player in
	place of the last of them if it isn't one already. With penalize, a blob with fewer spawns than the
	densest counts as up to SPARSE_PENALTY yards further away, since its mobs take longer to find
]]
local function Candidates(blobs, start, penalize)
	local candidates = {}
	for i = 1, math.min(MAX_CANDIDATES, #blobs) do
		candidates[i] = blobs[i]
	end
	local nearest, nearestDistance
	for _, blob in ipairs(blobs) do
		local dx, dy = blob.x - start.x, blob.y - start.y
		local distance = dx * dx + dy * dy
		if not nearestDistance or distance < nearestDistance then
			nearest, nearestDistance = blob, distance
		end
	end
	if nearest and not tContains(candidates, nearest) then
		candidates[#candidates] = nearest
	end
	local densest = blobs[1] and blobs[1].count or 1
	for _, candidate in ipairs(candidates) do
		candidate.penalty = penalize and SPARSE_PENALTY * (1 - candidate.count / densest) or 0
	end
	return candidates
end
routes.Candidates = Candidates
