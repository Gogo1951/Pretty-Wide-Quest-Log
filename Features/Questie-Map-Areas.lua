local _, ns = ...

--[[
	Every client: the shapes of the areas where the selected quest's objectives are found, which
	Questie-Map-Area-Layer.lua draws. Built from every spawn in Questie's database for the objective, not
	the icons Questie draws, which it thins out where they crowd. Questie-Map.lua asks for them and puts
	one marker in each area in place of an icon on every spawn
]]

ns.AddWideQuestLogPart(function()
	local questMap = ns.questMap

	-- Questie's own copy of HereBeDragons, for each zone's size in yards
	local HBD = LibStub("HereBeDragonsQuestie-2.0", true)

	local CLUSTER_RADIUS = 180 -- Yards from an area's center its spawns lie within, as Questie's own areas
	local EDGE_PADDING = 35 -- Yards an area reaches past its outermost spawns
	local SPOT_GAP = 3 -- On screen, between an icon's edge and the least area drawn around it
	local FALLBACK_MIN_RADIUS = 80 -- Yards, for the least area where the map's size on screen isn't known
	local PADDING_POINTS = 24 -- Around each spawn, which round off the area's corners
	local TOUCH_GAP = 15 -- Yards between two areas' edges within which they count as touching, and merge

	local PADDING_DIRECTIONS = {}
	for i = 1, PADDING_POINTS do
		local angle = 2 * math.pi * i / PADDING_POINTS
		PADDING_DIRECTIONS[i] = { math.cos(angle), math.sin(angle) }
	end

	--------------------------------------------------------------------------------
	-- Spawns
	--------------------------------------------------------------------------------

	local function ByPosition(a, b)
		if a.x ~= b.x then
			return a.x < b.x
		end
		return a.y < b.y
	end

	--[[
		The objective's spawns on the map, in yards from its top-left corner, grouped by the icon Questie
		gives them, so an area of objects never takes in the creatures around it. Each group is sorted, so
		the same spawns always make the same areas
	]]
	local function CollectSpawns(objective, mapID, width, height)
		local ZoneDB = ns.ImportQuestieModule("ZoneDB")
		local Phasing = ns.ImportQuestieModule("Phasing")
		local groups, order = {}, {}
		if not (ZoneDB and ZoneDB.GetUiMapIdByAreaId and type(objective.spawnList) == "table") then
			return groups, order
		end

		local seen = {}
		for _, spawnData in pairs(objective.spawnList) do
			for areaID, spawns in pairs(spawnData.Spawns or {}) do
				if ZoneDB:GetUiMapIdByAreaId(areaID) == mapID then
					local key = spawnData.Icon or false
					for _, spawn in ipairs(spawns) do
						local x, y = spawn[1], spawn[2]
						local visible = not (Phasing and Phasing.IsSpawnVisible) or Phasing.IsSpawnVisible(spawn[3])
						local id = tostring(key) .. ":" .. tostring(x) .. ":" .. tostring(y)
						if x and y and x >= 0 and y >= 0 and visible and not seen[id] then
							seen[id] = true
							if not groups[key] then
								groups[key] = {}
								order[#order + 1] = key
							end
							local group = groups[key]
							group[#group + 1] = { x = x / 100 * width, y = y / 100 * height, name = spawnData.Name }
						end
					end
				end
			end
		end
		for _, key in ipairs(order) do
			table.sort(groups[key], ByPosition)
		end
		return groups, order
	end

	--[[
		Groups spawns as Questie's own areas do: each spawn not yet taken starts a group and takes every
		other within CLUSTER_RADIUS of the group's center, which moves to their mean as it grows. A second
		pass takes those the moving center has come within reach of
	]]
	local function Cluster(spawns)
		local taken, clusters = {}, {}
		local radiusSquared = CLUSTER_RADIUS * CLUSTER_RADIUS
		for i, seed in ipairs(spawns) do
			if not taken[i] then
				taken[i] = true
				local members = { seed }
				local sumX, sumY = seed.x, seed.y
				for _ = 1, 2 do
					for j = i + 1, #spawns do
						local spawn = spawns[j]
						local dx, dy = spawn.x - sumX / #members, spawn.y - sumY / #members
						if not taken[j] and dx * dx + dy * dy <= radiusSquared then
							taken[j] = true
							members[#members + 1] = spawn
							sumX, sumY = sumX + spawn.x, sumY + spawn.y
						end
					end
				end
				clusters[#clusters + 1] = members
			end
		end
		return clusters
	end

	--------------------------------------------------------------------------------
	-- Shapes
	--------------------------------------------------------------------------------

	local function Cross(o, a, b)
		return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)
	end

	-- The convex hull of the points, by Andrew's monotone chain. Sorts the points in place
	local function ConvexHull(points)
		if #points < 3 then
			return points
		end
		table.sort(points, ByPosition)
		local hull = {}
		for i = 1, #points do
			while #hull >= 2 and Cross(hull[#hull - 1], hull[#hull], points[i]) <= 0 do
				hull[#hull] = nil
			end
			hull[#hull + 1] = points[i]
		end
		local lowerCount = #hull + 1
		for i = #points - 1, 1, -1 do
			while #hull >= lowerCount and Cross(hull[#hull - 1], hull[#hull], points[i]) <= 0 do
				hull[#hull] = nil
			end
			hull[#hull + 1] = points[i]
		end
		hull[#hull] = nil -- The first point again
		return hull
	end

	local function Mean(members)
		local sumX, sumY = 0, 0
		for _, member in ipairs(members) do
			sumX, sumY = sumX + member.x, sumY + member.y
		end
		return sumX / #members, sumY / #members
	end

	--[[
		The hull of the spawns grown all round: a ring of points around each corner, and the hull of those.
		It grows by EDGE_PADDING, or by more where the spawns sit close together, so each area reaches at
		least minRadius from its middle. A lone spawn comes out as a circle, a line of spawns as a rounded bar
	]]
	local function Outline(members, minRadius)
		local meanX, meanY = Mean(members)
		local spread = 0
		for _, member in ipairs(members) do
			spread = math.max(spread, math.sqrt((member.x - meanX) ^ 2 + (member.y - meanY) ^ 2))
		end
		local padding = math.max(EDGE_PADDING, minRadius - spread)

		local padded = {}
		for _, corner in ipairs(ConvexHull({ unpack(members) })) do
			for _, direction in ipairs(PADDING_DIRECTIONS) do
				padded[#padded + 1] = { x = corner.x + direction[1] * padding, y = corner.y + direction[2] * padding }
			end
		end
		return ConvexHull(padded)
	end

	-- A group of spawns with its outline and the box around it
	local function Shape(members, minRadius)
		local outline = Outline(members, minRadius)
		local shape = { members = members, outline = outline, left = math.huge, right = -math.huge }
		shape.top, shape.bottom = math.huge, -math.huge
		for _, corner in ipairs(outline) do
			shape.left, shape.right = math.min(shape.left, corner.x), math.max(shape.right, corner.x)
			shape.top, shape.bottom = math.min(shape.top, corner.y), math.max(shape.bottom, corner.y)
		end
		return shape
	end

	-- Whether some edge of polygon a has all of b more than TOUCH_GAP outside it, for two convex polygons
	local function HasSeparatingEdge(a, b)
		for i = 1, #a do
			local from, to = a[i], a[i % #a + 1]
			local length = math.sqrt((to.x - from.x) ^ 2 + (to.y - from.y) ^ 2)
			local normalX, normalY = (to.y - from.y) / length, (from.x - to.x) / length
			local minA, maxA, minB, maxB = math.huge, -math.huge, math.huge, -math.huge
			for _, corner in ipairs(a) do
				local projection = corner.x * normalX + corner.y * normalY
				minA, maxA = math.min(minA, projection), math.max(maxA, projection)
			end
			for _, corner in ipairs(b) do
				local projection = corner.x * normalX + corner.y * normalY
				minB, maxB = math.min(minB, projection), math.max(maxB, projection)
			end
			if maxB + TOUCH_GAP < minA or maxA + TOUCH_GAP < minB then
				return true
			end
		end
		return false
	end

	-- Whether two shapes overlap or touch: their boxes do, and no edge of either keeps them apart
	local function Touch(a, b)
		if
			a.right + TOUCH_GAP < b.left
			or b.right + TOUCH_GAP < a.left
			or a.bottom + TOUCH_GAP < b.top
			or b.bottom + TOUCH_GAP < a.top
		then
			return false
		end
		return not (HasSeparatingEdge(a.outline, b.outline) or HasSeparatingEdge(b.outline, a.outline))
	end

	--[[
		Any two groups whose shapes touch become one, outlined anew, until none touch, so each blob on the map
		has one marker. A lone spawn counts by the circle drawn around it
	]]
	local function MergeTouching(clusters, minRadius)
		local shapes = {}
		for i, members in ipairs(clusters) do
			shapes[i] = Shape(members, minRadius)
		end
		local merged = true
		while merged do
			merged = false
			for i = 1, #shapes - 1 do
				for j = i + 1, #shapes do
					if Touch(shapes[i], shapes[j]) then
						local members = shapes[i].members
						for _, member in ipairs(shapes[j].members) do
							members[#members + 1] = member
						end
						shapes[i] = Shape(members, minRadius)
						table.remove(shapes, j)
						merged = true
						break
					end
				end
				if merged then
					break
				end
			end
		end
		return shapes
	end

	-- Where an area's marker goes: the middle of its shape, measured from its first corner for precision
	local function Centroid(polygon)
		local originX, originY = polygon[1].x, polygon[1].y
		local area, sumX, sumY = 0, 0, 0
		for i = 1, #polygon do
			local a, b = polygon[i], polygon[i % #polygon + 1]
			local ax, ay, bx, by = a.x - originX, a.y - originY, b.x - originX, b.y - originY
			local cross = ax * by - bx * ay
			area = area + cross
			sumX = sumX + (ax + bx) * cross
			sumY = sumY + (ay + by) * cross
		end
		if area == 0 then
			return originX, originY
		end
		return originX + sumX / (3 * area), originY + sumY / (3 * area)
	end

	local function Names(members)
		local names, seen = {}, {}
		for _, member in ipairs(members) do
			local name = member.name or ""
			if not seen[name] then
				seen[name] = true
				names[#names + 1] = name
			end
		end
		table.sort(names)
		return names
	end

	--------------------------------------------------------------------------------
	-- Areas
	--------------------------------------------------------------------------------

	-- The map's size in yards, or nothing where it isn't known
	local function ZoneSize(mapID)
		local width, height
		if HBD then
			width, height = HBD:GetZoneSize(mapID)
		end
		if width and height and width > 0 and height > 0 then
			return width, height
		end
	end

	--[[
		The least an area reaches from its middle, in yards: SPOT_GAP past the edge of an icon iconSize
		across, measured with the map zoomed all the way out, so the gap is the same on every zone's map
	]]
	local function MinRadius(map, zoneWidth, iconSize)
		local container = map.ScrollContainer
		local scale = container.GetScaleForMinZoom and container:GetScaleForMinZoom() or map:GetCanvasScale()
		local canvasWidth = map:GetCanvas():GetWidth()
		if not (scale and scale > 0 and canvasWidth > 0) then
			return FALLBACK_MIN_RADIUS
		end
		local yardsPerUnit = zoneWidth / (canvasWidth * scale)
		return math.floor((iconSize / 2 + SPOT_GAP) * yardsPerUnit + 0.5)
	end

	-- Each objective's areas, for the map and size they were built for, until Questie gives it new spawns
	local built = setmetatable({}, { __mode = "k" })

	--[[
		An objective's areas on the map, each { icon, x, y, names, outline }: icon is the Questie icon its
		spawns have, x and y where its marker goes (0-1), names the NPCs or objects in it, and outline its
		corners (0-1). Each reaches far enough to clear a marker iconSize across. Empty when Questie has no
		spawns for the objective on this map
	]]
	function questMap.ObjectiveAreas(objective, map, iconSize)
		local mapID = map:GetMapID()
		local width, height = ZoneSize(mapID)
		local minRadius = width and MinRadius(map, width, iconSize)
		local cached = built[objective]
		if
			cached
			and cached.mapID == mapID
			and cached.minRadius == minRadius
			and cached.spawnList == objective.spawnList
		then
			return cached.areas
		end

		local areas = {}
		if width then
			local groups, order = CollectSpawns(objective, mapID, width, height)
			for _, key in ipairs(order) do
				for _, shape in ipairs(MergeTouching(Cluster(groups[key]), minRadius)) do
					local x, y = Centroid(shape.outline)
					local area = { icon = key or nil, names = Names(shape.members), x = x / width, y = y / height }
					area.outline = {}
					for i, corner in ipairs(shape.outline) do
						area.outline[i] = { x = corner.x / width, y = corner.y / height }
					end
					areas[#areas + 1] = area
				end
			end
		end

		built[objective] = { mapID = mapID, minRadius = minRadius, spawnList = objective.spawnList, areas = areas }
		return areas
	end

	-- The corners (0-1) of a circle around x, y (0-1) on the map, SPOT_GAP clear of an icon iconSize across
	function questMap.SpotOutline(map, x, y, iconSize)
		local width, height = ZoneSize(map:GetMapID())
		if not width then
			return nil
		end
		local radius = MinRadius(map, width, iconSize)
		local outline = {}
		for i, direction in ipairs(PADDING_DIRECTIONS) do
			outline[i] = { x = x + direction[1] * radius / width, y = y + direction[2] * radius / height }
		end
		return outline
	end
end)
