local _, ns = ...

--[[
	Routes: the Quest Arrow, as TomTom's does it, pointing at the route's first stop. Under it, how
	far the stop is, then every quest at the stop, centered under the arrow as a block: its level and
	name, and indented under it what's to do there, its objectives with their counts or "Turn in quest"
	(routes.ForEachStopLine).

	The arrow is green while it points within ON_COURSE degrees of straight ahead, yellow out to
	OFF_COURSE either side, and red beyond, behind the player: which way to turn, at a glance. It points
	to the next stop, all the way to one that's one place (an NPC, an object, the corpse), and becomes a
	blue eye that breathes within 10 yards of it, "You're there". In the area of any objective on the
	route (within routes.AREA_REACH of its spawns), it's the eye, "Objective Area", listing every
	objective around, then the arrow, pointing on to the next destination and listing that, by turns over
	the cycleSeconds setting: work what's here, keep heading the right way. Drag it to move it; right-click it to
	reroute around the stop's objectives, middle-click to reset all routes. By default it hides in
	a raid group and in instances (dungeons, raids, battlegrounds), where it isn't questing that's under
	way. Its size, lock, text and hiding are the Quest Arrow panel's settings (Options/Options-Quest-Arrow.lua)
]]

local routes = ns.routes
local L = ns.L

-- The owner of this file's event handlers in Core.lua's EVENTS
local routesArrow = {}
ns.routesArrow = routesArrow

local ARROW_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Arrow"
local EYE_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Eye"
local ARROW_SIZE = 64 -- The texture's own size, drawn pixel for pixel; on the doubling scale like the spacing
local WIDTH = 512 -- Widest the quest list gets before its lines are cut short
local TURN_INTERVAL = 0.03 -- Seconds between turns of the arrow
local TEXT_INTERVAL = 0.25 -- Seconds between rewrites of the distance
local LIST_INTERVAL = 1 -- Seconds between rewrites of the quests, whose counts change only as the player works
--[[
	Degrees either side of straight ahead: green within ON_COURSE (a fifth of the circle, 72 degrees in
	all), yellow out to OFF_COURSE (a fifth more each side), red beyond, the two fifths behind. Each line
	blends from one color to the next over BLEND degrees centered on it
]]
local ON_COURSE = 36
local OFF_COURSE = 108
local BLEND = 20
local SPOT_REACH = 10 -- Yards from one place (a chest, an NPC) that count as there: the eye instead of the arrow
local BREATH_PERIOD = 2.5 -- Seconds for the eye to grow and shrink again
local BREATH_GROWTH = 0.3 -- How much bigger the eye gets at the top of a breath
local SPACE = ns.LAYOUT.SPACE

local HBD

local frame = CreateFrame("Button", "PrettyWideQuestLogRouteArrow", UIParent)
frame:SetWidth(WIDTH)
frame:SetFrameStrata("MEDIUM")
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:RegisterForClicks("RightButtonUp", "MiddleButtonUp")
frame:Hide()

local arrow = frame:CreateTexture(nil, "ARTWORK")
arrow:SetTexture(ARROW_TEXTURE)
arrow:SetSize(ARROW_SIZE, ARROW_SIZE)
-- By its middle, so the eye breathes in place without moving the text under it
arrow:SetPoint("CENTER", frame, "TOP", 0, -ARROW_SIZE / 2)

local distance = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
distance:SetPoint("TOP", frame, "TOP", 0, -(ARROW_SIZE + SPACE.TIGHT))

--------------------------------------------------------------------------------
-- The quests at the stop
--------------------------------------------------------------------------------

-- Lines of the quest list, made as needed and kept: each a title or an objective
local lines = {}

local function Line(index, isTitle)
	local line = lines[index]
	if not line then
		line = frame:CreateFontString(nil, "OVERLAY")
		line:SetJustifyH("LEFT")
		line:SetWordWrap(false)
		lines[index] = line
	end
	line:SetFontObject(isTitle and "GameFontNormal" or "GameFontHighlight") -- Same size, titles gold and objectives white
	line.isTitle = isTitle
	line:Show()
	return line
end

-- A font string's line height, whether or not it holds text now
local function LineHeight(fontString)
	local _, size = fontString:GetFont()
	return size or 12
end

-- How far in a line starts from the list's left edge: objectives sit indented under their quest
local function Indent(line)
	return line.isTitle and 0 or SPACE.NEAR
end

--[[
	Lists the stop's quests under the arrow and sizes the frame to fit. The lines are left-aligned with
	each other and the block centered under the arrow, as wide as its widest line, each on one line, cut
	short past WIDTH. The distance line keeps its room while blank, so the list doesn't jump on arrival.
	The frame takes the mouse only over the arrow and the block, not the empty width either side
]]
local listedKey
local pending = {}
local function ListQuests(stop)
	local settings = routes.Settings()
	-- The lines first, so a second with nothing changed lays nothing out again
	local count, texts = 0, {}
	if settings.showQuests then
		routes.ForEachStopLine(stop, settings.questsListed, function(isTitle, text, red, green, blue)
			count = count + 1
			local entry = pending[count] or {}
			pending[count] = entry
			entry.isTitle, entry.text, entry.red, entry.green, entry.blue = isTitle, text, red, green, blue
			texts[count] = string.format("%s%.2f%.2f%.2f%s", isTitle and "T" or "L", red, green, blue, text)
		end)
	end
	local key = table.concat(texts, "\n")
	if key == listedKey then
		return
	end
	listedKey = key

	local used, blockWidth = 0, 0
	local y = ARROW_SIZE + SPACE.TIGHT + LineHeight(distance)
	for index = 1, count do
		local entry = pending[index]
		used = used + 1
		local line = Line(used, entry.isTitle)
		y = y + ((used == 1 or entry.isTitle) and SPACE.GROUP or SPACE.LINE) -- 16 above each quest, 4 between its lines
		line.top = y
		line:SetWidth(0) -- Unbounded while it's measured, then held to the frame below
		line:SetText(entry.text)
		line:SetTextColor(entry.red, entry.green, entry.blue)
		blockWidth = math.max(blockWidth, Indent(line) + (line:GetStringWidth() or 0))
		y = y + LineHeight(line)
	end
	local left = math.max(0, (WIDTH - blockWidth) / 2)
	for i = 1, used do
		local line = lines[i]
		line:ClearAllPoints()
		line:SetPoint("TOPLEFT", frame, "TOPLEFT", left + Indent(line), -line.top)
		line:SetWidth(WIDTH - left - Indent(line))
	end
	for i = used + 1, #lines do
		lines[i]:Hide()
	end
	frame:SetHeight(y)
	local inset = math.max(0, (WIDTH - math.max(blockWidth, ARROW_SIZE)) / 2)
	frame:SetHitRectInsets(inset, inset, 0, 0)
end

--------------------------------------------------------------------------------
-- Where it sits
--------------------------------------------------------------------------------

-- The spot is saved in the screen's units, and a frame's offsets are in its own scale, so they're divided by it
local function PlaceFrame()
	frame:ClearAllPoints()
	local scale = frame:GetScale()
	local point = routes.ArrowPoint()
	if type(point) == "table" and point[1] then
		frame:SetPoint(point[1], UIParent, point[2], point[3] / scale, point[4] / scale)
	else
		frame:SetPoint("TOP", UIParent, "CENTER", 0, UIParent:GetHeight() / 4 / scale)
	end
end
routes.ResetArrow = PlaceFrame

frame:SetScript("OnClick", function(_, button)
	if button == "RightButton" then
		routes.SkipStop(routes.arrowTarget or routes.stops[1])
	elseif button == "MiddleButton" then
		routes.ResetObjectives()
	end
end)

local function ShowTooltip(self)
	-- A gap under the list, so the tooltip doesn't sit against its last line
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -SPACE.GROUP)
	local hints = {}
	if not routes.Settings().lockArrow then
		hints[1] = { L["ROUTES_CLICK_DRAG"], L["ROUTES_DRAG_MOVE"] }
	end
	if not (routes.stops[1] and routes.stops[1].corpse) then
		hints[#hints + 1] = { L["ROUTES_CLICK_RIGHT"], L["ROUTES_RIGHT_CLICK_REROUTE"] }
	end
	hints[#hints + 1] = { L["ROUTES_CLICK_MIDDLE"], L["ROUTES_MIDDLE_CLICK_RESET"] }
	routes.AddClickHints(GameTooltip, hints)
	GameTooltip:Show()
end

-- Only while the mouse is on the arrow: hidden while dragging, and if the arrow moves or hides from under it
local function HideTooltip()
	if GameTooltip:IsOwned(frame) then
		GameTooltip:Hide()
	end
end

frame:SetScript("OnEnter", ShowTooltip)
frame:SetScript("OnLeave", HideTooltip)
frame:SetScript("OnHide", HideTooltip)

frame:SetScript("OnDragStart", function(self)
	if routes.Settings().lockArrow then
		return
	end
	HideTooltip()
	self.moving = true
	self:StartMoving()
end)
frame:SetScript("OnDragStop", function(self)
	if not self.moving then
		return
	end
	self.moving = nil
	self:StopMovingOrSizing()
	local point, _, relativePoint, x, y = self:GetPoint()
	local scale = self:GetScale()
	routes.SetArrowPoint({ point, relativePoint, x * scale, y * scale })
end)

--------------------------------------------------------------------------------
-- Pointing
--------------------------------------------------------------------------------

-- From one color to the next across BLEND degrees centered on the line between them: a share of 0 to 1
local function Across(degrees, line)
	return math.min(1, math.max(0, (degrees - line) / BLEND + 0.5))
end

local function Mix(fromKey, toKey, share)
	local r1, g1, b1 = ns.GetColorRGB(fromKey)
	local r2, g2, b2 = ns.GetColorRGB(toKey)
	return r1 + (r2 - r1) * share, g1 + (g2 - g1) * share, b1 + (b2 - b1) * share
end

--[[
	By how far the arrow turns from straight ahead (radians, either way): solid colors through the middle
	of each band, easy to read at a glance, and a short blend at the lines so it doesn't snap
]]
local function Shade(turn)
	local degrees = math.abs(math.deg((turn + math.pi) % (2 * math.pi) - math.pi))
	if degrees < (ON_COURSE + OFF_COURSE) / 2 then
		return Mix("ARROW_ON_COURSE", "ARROW_TURN", Across(degrees, ON_COURSE))
	end
	return Mix("ARROW_TURN", "ARROW_WRONG_WAY", Across(degrees, OFF_COURSE))
end

local sinceTurn, sinceText, sinceList = 0, 0, 0
local showingEye = false
local eyeLabel -- What the eye says: in an area, or at one place
local hereKeys = {} -- The tasks whose areas the player is in, by key, held until routes.AREA_GRACE further
local here, destination -- Around the player, and where to go next: each a stop's worth of tasks, or nothing
local listed -- Which of them the list under the arrow shows

--[[
	Looks around: every task on the route whose area the player is in (routes.InArea), from any stop, as
	one list, and the next destination, the first stop with a task left that isn't among them. Dead,
	there's only the corpse
]]
local function Survey(x, y)
	local stops = routes.stops
	local wasHere, tasks = hereKeys, {}
	hereKeys = {}
	if not stops[1].corpse then
		for _, stop in ipairs(stops) do
			for _, task in ipairs(stop.tasks) do
				local key = task.key
				if
					key
					and not hereKeys[key]
					and routes.IsTaskLeft(task)
					and routes.InArea(task, x, y, wasHere[key])
				then
					hereKeys[key] = true
					tasks[#tasks + 1] = task
				end
			end
		end
	end
	here = #tasks > 0 and { tasks = tasks, instance = stops[1].instance } or nil
	destination = nil
	for _, stop in ipairs(stops) do
		local rest = {}
		for _, task in ipairs(stop.tasks) do
			if not hereKeys[task.key] and routes.IsTaskLeft(task) then
				rest[#rest + 1] = task
			end
		end
		if #rest > 0 then
			destination = {
				tasks = rest,
				x = stop.x,
				y = stop.y,
				instance = stop.instance,
				radius = stop.radius,
				corpse = stop.corpse,
			}
			break
		end
	end
end

-- Where in a stop the arrow points: its nearest place still to go to, or the nearest edge of an area
local function NearestPlace(stop, x, y)
	local nearest, nearestYards
	for _, task in ipairs(stop.tasks) do
		local point = routes.IsTaskLeft(task) and routes.TaskPoint(task)
		if point then
			local dx, dy = point.x - x, point.y - y
			local yards = math.sqrt(dx * dx + dy * dy)
			if routes.IsAreaPoint(point) then
				yards = math.max(0, yards - point.radius)
			end
			if not nearestYards or yards < nearestYards then
				nearest, nearestYards = point, yards
			end
		end
	end
	return nearest
end

local function Point(self, elapsed)
	sinceTurn, sinceText, sinceList = sinceTurn + elapsed, sinceText + elapsed, sinceList + elapsed
	if sinceTurn < TURN_INTERVAL then
		return
	end
	sinceTurn = 0
	if GameTooltip:IsOwned(self) and not self:IsMouseOver() then
		GameTooltip:Hide()
	end
	local rewrite = sinceText >= TEXT_INTERVAL
	if rewrite then
		sinceText = 0
	end

	local stop = routes.stops[1]
	if not stop then
		return
	end
	HBD = HBD or LibStub("HereBeDragonsQuestie-2.0", true)
	local x, y, instance = routes.PlayerPosition()
	local facing = GetPlayerFacing()
	local located = HBD and x and facing and instance == stop.instance
	-- Once a second: what's around, where next, and the counts, which change only as the player works
	local survey = sinceList >= LIST_INTERVAL
	if survey then
		sinceList = 0
		if located then
			Survey(x, y)
		else
			here, destination = nil, nil
		end
	end
	destination = destination or (not here and stop) or nil

	--[[
		Around the player: the eye, listing it, then the arrow to the next destination, by turns, half the
		cycleSeconds setting each
	]]
	local view, label = destination, nil
	local turn = routes.Settings().cycleSeconds / 2
	if here and (not destination or math.floor(GetTime() / turn) % 2 == 0) then
		view, label = here, L["ROUTES_OBJECTIVE_AREA"]
	end
	routes.arrowTarget = view -- What a right-click reroutes around
	if survey or view ~= listed then
		listed = view
		ListQuests(view)
	end
	if not located then
		arrow:Hide()
		distance:SetText("")
		return
	end
	arrow:Show()

	local target, angle, yards, isArea = view, nil, nil, false
	if not label then
		if not view.corpse then
			target = NearestPlace(view, x, y) or view
		end
		angle, yards = HBD:GetWorldVector(instance, x, y, target.x, target.y)
		isArea = target ~= view and routes.IsAreaPoint(target)
		-- At one place: the eye too, there's nowhere left to point
		if not (isArea or view.corpse) and yards <= SPOT_REACH then
			label = L["ROUTES_ARRIVED"]
		end
	end
	local eye = label ~= nil
	if eye ~= showingEye then
		showingEye = eye
		arrow:SetTexture(eye and EYE_TEXTURE or ARROW_TEXTURE)
		arrow:SetSize(ARROW_SIZE, ARROW_SIZE)
		rewrite = true
	end
	if eye then
		-- An eye in the add-on's blue, upright as there's nowhere left to point, breathing
		local breath = (1 - math.cos(2 * math.pi * GetTime() / BREATH_PERIOD)) / 2
		local size = ARROW_SIZE * (1 + BREATH_GROWTH * breath)
		arrow:SetSize(size, size)
		arrow:SetRotation(0)
		arrow:SetVertexColor(ns.GetColorRGB("INFO"))
		if rewrite or label ~= eyeLabel then
			eyeLabel = label
			distance:SetText(label)
		end
		return
	end
	if eyeLabel then
		eyeLabel, rewrite = nil, true -- Back to the arrow: its distance at once, not the eye's words
	end

	-- Pointing, at an area from outside it, or to a place; a corpse is reached from within its radius
	local arrived = view.corpse and yards <= view.radius
	arrow:SetRotation(angle - facing)
	arrow:SetVertexColor(Shade(angle - facing))
	if rewrite then
		local yardsText = routes.Settings().showDistance and string.format(L["ROUTES_YARDS"], yards) or ""
		distance:SetText(arrived and L["ROUTES_ARRIVED"] or yardsText)
	end
end

frame:SetScript("OnUpdate", Point)

--------------------------------------------------------------------------------
-- Showing it
--------------------------------------------------------------------------------

-- In a raid group or an instance, as the settings hide it there
local function IsAway(settings)
	return (settings.hideInRaids and IsInRaid()) or (settings.hideInInstances and (IsInInstance()) == true)
end

local loggedIn = false

local function Refresh()
	local settings = routes.Settings()
	local shown = settings.enabled and settings.showArrow and routes.stops[1] ~= nil and not IsAway(settings)
	if frame:GetScale() ~= settings.arrowScale then
		frame:SetScale(settings.arrowScale)
		if loggedIn then
			PlaceFrame()
		end
	end
	frame:SetShown(shown)
	if not shown then
		routes.arrowTarget = nil
	end
	if shown then
		sinceTurn, sinceText, sinceList = TURN_INTERVAL, TEXT_INTERVAL, LIST_INTERVAL -- Draws the new stop at once
	end
end

routes.OnLogin(function()
	loggedIn = true
	PlaceFrame()
	Refresh()
end)
routes.AddListener(Refresh)

-- Joining or leaving a raid, going into or out of an instance
local function RefreshAfterLogin()
	if loggedIn then
		Refresh()
	end
end
routesArrow.OnGroupRosterUpdate = RefreshAfterLogin
routesArrow.OnPlayerEnteringWorld = RefreshAfterLogin
routesArrow.OnZoneChangedNewArea = RefreshAfterLogin
