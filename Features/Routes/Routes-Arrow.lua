local ADDON_NAME, ns = ...

--[[
	Routes: the Quest Arrow, as TomTom's does it, pointing at the first stop on the route with a task left
	outside the area the player is in. Under it, how far the stop is, then every quest at the stop,
	centered under the arrow as a block: its level and name, and indented under it what's to do there, its
	objectives with their counts or "Turn In Quest" (routes.ForEachStopLine).

	The arrow is green while it points within ON_COURSE degrees of straight ahead, yellow out to
	OFF_COURSE either side, and red beyond, behind the player: which way to turn, at a glance. It turns
	with the player's facing, and its color follows where they're going: their facing, or while they back
	up or strafe, the way they're moving (ColorHeading), so closing in backwards isn't red. It points
	to the next stop, all the way to one that's one place (an NPC, an object, the corpse), and becomes a
	blue eye that breathes within 10 yards of it, "You're There".

	Heading for an area, it points at the camp's nearest spawn and counts down to its edge, routes.AREA_REACH
	short of it, where the eye takes over. In an area (within routes.AREA_REACH of an objective's spawns) it
	tells working from passing through.
	The objectives of the waypoint the route sent the player to, or one pinned there for being worked,
	are "work here": the eye, "Current Objective Area", over a note, "Finish Here Before Moving On" where
	one of them can be done nowhere else or "More Along the Route" where the route passes more of each,
	and the list. Any other objective the player is among is on the way: the arrow keeps pointing, and it's
	listed dimmed under "While You're Here", to tag without stopping; with many, only the nearest
	(Routes-Arrow-Survey.lua).

	Under the list, dimmed, with showNextObjective, the Next Objective: the waypoint after the area, or
	heading to a waypoint, the one after that. On the left a 32px arrow turning toward it, colored as the
	big one is, with how far it is under it; on the right "Next Objective", its first quest and what's to
	do there, with counts (and in a party, who needs each).

	Drag it to move it, held by its top so the list grows and shrinks below it; the mouse over it opens its
	menu (Routes-Arrow-Menu.lua), to ignore one objective
	at a time, here or at the Next Objective; middle-click resets the zone, putting back what was ignored in it. By default it
	hides in a raid group and in instances (dungeons, raids, battlegrounds), where it isn't questing that's
	under way. Its size, lock, text and hiding are the Quest Arrow panel's settings
	(Options/Options-Quest-Arrow.lua)
]]

local routes = ns.routes
local L = ns.L

-- The owner of this file's event handlers in Core.lua's EVENTS
local routesArrow = {}
ns.routesArrow = routesArrow

local ARROW_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Arrow"
local EYE_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Eye"
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
local SAMPLE_INTERVAL = 0.1 -- Seconds between notes of where the player is, for the way they're moving
local HEADING_WINDOW = 0.5 -- Seconds of movement the way they're moving is measured over
local SAMPLES = HEADING_WINDOW / SAMPLE_INTERVAL + 1 -- Notes kept, to span the window
local MIN_TRAVEL = 1.5 -- Yards moved over the window that count as moving: under a walk's pace is standing
local MAX_TRAVEL = 50 -- Yards over the window past which it was a teleport or a load, not moving
local FACING_TRUST = math.rad(60) -- Moving within this of their facing, the facing colors it, as it answers at once
local SPOT_REACH = 10 -- Yards from one place (a chest, an NPC) that count as there: the eye instead of the arrow
local BREATH_PERIOD = 2.5 -- Seconds for the eye to grow and shrink again
local BREATH_GROWTH = 0.3 -- How much bigger the eye gets at the top of a breath
local NEXT_ARROW_SIZE = 16 -- The Next Objective's arrow, left of its lines: a quarter of the big one
local DIM_ALPHA = 0.72 -- What's on the way and what's next, behind what to do here
local SPACE = ns.LAYOUT.SPACE

local Survey = routes.ArrowSurvey
local NearestPlace = routes.ArrowNearestPlace
local NearestSpawn = routes.ArrowNearestSpawn

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

--[[
	Under the arrow as a label under its icon: how far, in silver like the list's counts, or what the eye
	says, in the eye's blue. The arrow's art leaves 10px clear under it pointing ahead, but turned, a corner
	of it reaches within 2px of the bottom of its square, so the line keeps SPACE.LINE below the square
]]
local distance = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
distance:SetPoint("TOP", frame, "TOP", 0, -(ARROW_SIZE + SPACE.LINE))

--[[
	Under "Current Objective Area": whether to finish here or move on, in silver, the list's size, as the
	second line of what the eye says
]]
local note = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
note:SetPoint("TOP", distance, "BOTTOM", 0, -SPACE.LINE)

-- Where the arrow would be while the waypoint is on another continent, so it isn't an empty square
local away = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
away:SetPoint("CENTER", frame, "TOP", 0, -ARROW_SIZE / 2)
away:SetText(L["ROUTES_OTHER_MAP"])
away:SetTextColor(ns.GetColorRGB("HELP"))
away:Hide()

-- The Next Objective's own arrow and distance, a column left of its lines, turned and counted by Point
local nextArrow = frame:CreateTexture(nil, "ARTWORK")
nextArrow:SetTexture(ARROW_TEXTURE)
nextArrow:SetSize(NEXT_ARROW_SIZE, NEXT_ARROW_SIZE)
nextArrow:Hide()
local nextDistance = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
nextDistance:SetTextColor(ns.GetColorRGB("HELP"))
nextDistance:Hide()

-- "279 Yards", or "1 Yard"
function routes.YardsText(yards)
	local whole = math.floor(yards)
	return string.format(whole == 1 and L["ROUTES_YARD"] or L["ROUTES_YARDS"], whole)
end

-- The pieces and sizes the quest list lays out under the arrow (Routes-Arrow-List.lua)
routes.arrowParts = {
	frame = frame,
	distance = distance,
	note = note,
	nextArrow = nextArrow,
	nextDistance = nextDistance,
}
routes.ARROW_LAYOUT = {
	WIDTH = WIDTH,
	ARROW_SIZE = ARROW_SIZE,
	NEXT_ARROW_SIZE = NEXT_ARROW_SIZE,
	EYE_TEXTURE = EYE_TEXTURE,
	ARROW_TEXTURE = ARROW_TEXTURE,
	DIM_ALPHA = DIM_ALPHA,
}

--------------------------------------------------------------------------------
-- Where it sits
--------------------------------------------------------------------------------

--[[
	Holds the frame by its top middle where it is now, and saves that spot, so the arrow stays put and the
	list grows and shrinks below it. StopMovingOrSizing anchors by whichever corner or edge is nearest
	instead, which would move the arrow each time the list changed height
]]
local function HoldByTop()
	local left, top, width = frame:GetLeft(), frame:GetTop(), frame:GetWidth()
	if not (left and top) then
		return
	end
	local x = left + width / 2
	frame:ClearAllPoints()
	frame:SetPoint("TOP", UIParent, "BOTTOMLEFT", x, top)
	local scale = frame:GetScale()
	routes.SetArrowPoint({ "TOP", "BOTTOMLEFT", x * scale, top * scale })
end

--[[
	The spot is saved in the screen's units, and a frame's offsets are in its own scale, so they're divided
	by it. A spot saved by another anchor point is saved again by its top
]]
local function PlaceFrame()
	frame:ClearAllPoints()
	local scale = frame:GetScale()
	local point = routes.ArrowPoint()
	if type(point) == "table" and point[1] then
		frame:SetPoint(point[1], UIParent, point[2], point[3] / scale, point[4] / scale)
		if point[1] ~= "TOP" then -- MIGRATION (remove after 2026-12-07): spots released builds saved by other points
			HoldByTop()
		end
	else
		frame:SetPoint("TOP", UIParent, "CENTER", 0, UIParent:GetHeight() / 4 / scale)
	end
end
routes.ResetArrow = PlaceFrame

-- The arrow's menu (Routes-Arrow-Menu.lua) opens with the mouse over it and stays open while the mouse is on the arrow or the menu
routes.arrowFrame = frame

-- Whether the mouse is over the arrow and its list, not the empty width either side (frame.hitInset)
function routes.IsMouseOverArrow()
	local inset = frame.hitInset or 0
	return frame:IsVisible() and frame:IsMouseOver(0, 0, inset, -inset)
end

frame:SetScript("OnClick", function(_, button)
	if button == "RightButton" then
		routes.IgnoreArrowObjective()
	elseif button == "MiddleButton" then
		routes.ResetZone()
	end
end)

frame:SetScript("OnEnter", function(self)
	if not self.moving then
		routes.ShowArrowMenu()
	end
end)
frame:SetScript("OnHide", function()
	routes.HideArrowMenu()
end)

local function StartDrag()
	if routes.Settings().lockArrow then
		return
	end
	routes.HideArrowMenu()
	frame.moving = true
	frame:StartMoving()
end

local function StopDrag()
	if not frame.moving then
		return
	end
	frame.moving = nil
	frame:StopMovingOrSizing()
	HoldByTop()
end

frame:SetScript("OnDragStart", StartDrag)
frame:SetScript("OnDragStop", StopDrag)

--[[
	A drag begun on the menu's Drag row: the arrow moves with the mouse as if it had been dragged itself. The
	menu hides as the drag starts, taking the row and its OnDragStop with it, so the button coming up ends it
]]
local dragWatcher = CreateFrame("Frame")
dragWatcher:Hide()
dragWatcher:SetScript("OnUpdate", function(self)
	if not frame.moving or not IsMouseButtonDown("LeftButton") then
		self:Hide()
		StopDrag()
	end
end)

function routes.DragArrowFromMenu()
	StartDrag()
	if frame.moving then
		dragWatcher:Show()
	end
end

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
	By how far the target is from where the player is going (radians, either way): solid colors through
	the middle of each band, easy to read at a glance, and a short blend at the lines so it doesn't snap
]]
local function Shade(turn)
	local degrees = math.abs(math.deg((turn + math.pi) % (2 * math.pi) - math.pi))
	if degrees < (ON_COURSE + OFF_COURSE) / 2 then
		return Mix("ARROW_ON_COURSE", "ARROW_TURN", Across(degrees, ON_COURSE))
	end
	return Mix("ARROW_TURN", "ARROW_WRONG_WAY", Across(degrees, OFF_COURSE))
end

-- Where the player was, the last SAMPLES notes, a ring with sampleHead the newest
local sampleTimes, sampleX, sampleY = {}, {}, {}
local sampleHead, sampleInstance, lastSample = 0, nil, 0

local function NoteMovement(now, x, y, instance)
	if instance ~= sampleInstance then
		sampleInstance = instance
		wipe(sampleTimes)
	end
	if now - lastSample < SAMPLE_INTERVAL then
		return
	end
	lastSample = now
	sampleHead = sampleHead % SAMPLES + 1
	sampleTimes[sampleHead], sampleX[sampleHead], sampleY[sampleHead] = now, x, y
end

-- The way the player has moved over the last HEADING_WINDOW, as an angle like the arrow's, or nil standing still
local function TravelHeading(hereBeDragons, now, x, y, instance)
	local oldest
	for i = 1, SAMPLES do
		local t = sampleTimes[i]
		if t and now - t <= HEADING_WINDOW + SAMPLE_INTERVAL / 2 and (not oldest or t < sampleTimes[oldest]) then
			oldest = i
		end
	end
	if not oldest then
		return nil
	end
	local angle, yards = hereBeDragons:GetWorldVector(instance, sampleX[oldest], sampleY[oldest], x, y)
	if angle and yards >= MIN_TRAVEL and yards <= MAX_TRAVEL then
		return angle
	end
end

--[[
	What the arrow's color is measured from: the facing, unless the player is moving well away from it,
	backing up or strafing, when it's the way they're moving. Facing answers a turn at once, where the way
	they're moving lags half a second behind, so it's kept whenever the two roughly agree
]]
local function ColorHeading(heading, facing)
	if heading and math.abs((heading - facing + math.pi) % (2 * math.pi) - math.pi) > FACING_TRUST then
		routes.arrowColoredBy = "travel"
		return heading
	end
	routes.arrowColoredBy = "facing"
	return facing
end

local sinceTurn, sinceText, sinceList = 0, 0, 0
local showingEye = false
local eyeLabel -- What the eye says: in an area, or at one place
--[[
	To work around the player, where to go next, the waypoint after that, and what's around on the way: each
	a stop's worth of tasks, or nothing
]]
local here, destination, afterDestination, passing
local areaNote -- Under "Current Objective Area": finish here, or more along the route
local listed, listedNext -- What the list under the arrow shows, and its Next Objective
local nextShown = false -- Whether the list laid out the Next Objective, so Point turns its arrow
local listedMeet -- The party member the list was written for, while grouping up

--[[
	Which of a stop's places is nearest, for the arrow and the Next Objective's arrow: worked out again as the
	distance is rewritten (TEXT_INTERVAL) or the stop changes, not each turn
]]
local aimedAt, aimedPlace, aimedTask, aimedSpawnX, aimedSpawnY
local nextAimedAt, nextAimedPlace

-- The Next Objective's arrow, turned and colored as the big one would be, and its distance
local function PointNext(hereBeDragons, x, y, instance, facing, heading, rewrite)
	if not (nextShown and listedNext and listedNext.instance == instance) then
		return
	end
	if rewrite or nextAimedAt ~= listedNext then
		nextAimedAt = listedNext
		nextAimedPlace = listedNext.corpse and listedNext or NearestPlace(listedNext, x, y) or listedNext
	end
	local place = nextAimedPlace
	local nextAngle, nextYards = hereBeDragons:GetWorldVector(instance, x, y, place.x, place.y)
	if nextAngle then
		nextArrow:SetRotation(nextAngle - facing)
		nextArrow:SetVertexColor(Shade(nextAngle - heading))
		if rewrite then
			local text = routes.Settings().showDistance and routes.YardsText(nextYards) or ""
			if text ~= nextDistance:GetText() then
				nextDistance:SetText(text)
			end
		end
	end
end

--[[
	The little arrow on each quest's title in the list, to the middle of its objective area or its giver,
	turned and colored as the big one would be (Routes-Arrow-List.lua lays them out, hidden until turned
	here, so none shows unturned)
]]
local function PointLines(hereBeDragons, x, y, instance, facing, heading)
	for _, line in ipairs(routes.arrowPointingLines or {}) do
		local point = line.point
		local angle = point and hereBeDragons:GetWorldVector(instance, x, y, point.x, point.y)
		if angle then
			line.icon:SetRotation(angle - facing)
			line.icon:SetVertexColor(Shade(angle - heading))
			line.icon:Show()
		else
			line.icon:Hide()
		end
	end
end

--[[
	Joining up: the arrow points to the party member, or the middle of everyone, as it moves, with "Join Up
	with Group" under it, and with showNextObjective the route's next waypoint dimmed below as the Next
	Objective, where the group goes once together. Nothing on the menu's Ignore rows is at the arrow, and
	right-click does nothing while joining up (routes.IgnoreArrowObjective)
]]
local function PointToMember(meet, survey, rewrite, hereBeDragons, x, y, instance, facing)
	local nextStop = routes.Settings().showNextObjective and (here or destination) or nil
	routes.arrowTarget, routes.arrowNext = nil, nextStop
	if survey or meet ~= listedMeet or nextStop ~= listedNext then
		listed, listedNext, listedMeet = nil, nextStop, meet
		nextShown = routes.ListArrowQuests(nil, nil, nil, nextStop, meet)
	end
	if eyeLabel or showingEye then
		eyeLabel, showingEye, rewrite = nil, false, true
		arrow:SetTexture(ARROW_TEXTURE)
		arrow:SetSize(ARROW_SIZE, ARROW_SIZE)
	end
	if not (hereBeDragons and x and facing and instance == meet.instance) then
		arrow:Hide()
		away:Hide()
		distance:SetText("")
		return
	end
	away:Hide()
	arrow:Show()
	local now = GetTime()
	NoteMovement(now, x, y, instance)
	local heading = ColorHeading(TravelHeading(hereBeDragons, now, x, y, instance), facing)
	PointNext(hereBeDragons, x, y, instance, facing, heading, rewrite)
	local angle, yards = hereBeDragons:GetWorldVector(instance, x, y, meet.x, meet.y)
	if not angle then
		return
	end
	arrow:SetRotation(angle - facing)
	arrow:SetVertexColor(Shade(angle - heading))
	if rewrite then
		distance:SetText(routes.Settings().showDistance and routes.YardsText(yards) or "")
		distance:SetTextColor(ns.GetColorRGB("HELP"))
	end
end

local function Point(self, elapsed)
	sinceTurn, sinceText, sinceList = sinceTurn + elapsed, sinceText + elapsed, sinceList + elapsed
	if sinceTurn < TURN_INTERVAL then
		return
	end
	sinceTurn = 0
	local rewrite = sinceText >= TEXT_INTERVAL
	if rewrite then
		sinceText = 0
	end

	local stop = routes.stops[1]
	local meet = routes.groupUpTarget -- Where to join up with the group first (Routes-Group-Up.lua)
	if not (stop or meet) then
		return
	end
	local hereBeDragons = routes.HereBeDragons()
	local x, y, instance = routes.PlayerPosition()
	local facing = GetPlayerFacing()
	local located = hereBeDragons and x and facing and stop and instance == stop.instance
	-- Once a second: what's around, where next, and the counts, which change only as the player works
	local survey = sinceList >= LIST_INTERVAL
	if survey then
		sinceList = 0
		if located then
			here, passing, areaNote, destination, afterDestination = Survey(x, y)
		else
			here, destination, afterDestination, passing = nil, nil, nil, nil
		end
	end
	destination = destination or (not here and stop) or nil
	if meet then
		return PointToMember(meet, survey, rewrite, hereBeDragons, x, y, instance, facing)
	end

	--[[
		Working an area: the eye, listing it, and with showNextObjective the next destination under it.
		Otherwise the arrow to the destination, and with showNextObjective the waypoint after it under it
	]]
	local view, label, nextStop = destination, nil, afterDestination
	if here then
		view, label, nextStop = here, L["ROUTES_OBJECTIVE_AREA"], destination
	end
	if not routes.Settings().showNextObjective then
		nextStop = nil
	end
	routes.arrowTarget, routes.arrowNext = view, nextStop -- What the menu's rows ignore
	if survey or view ~= listed or nextStop ~= listedNext or listedMeet then
		listed, listedNext, listedMeet = view, nextStop, nil
		nextShown = routes.ListArrowQuests(view, here and areaNote or nil, passing, nextStop, nil, not here)
	end
	if not located then
		arrow:Hide()
		distance:SetText("")
		away:SetShown(x ~= nil and instance ~= stop.instance)
		return
	end
	away:Hide()
	arrow:Show()
	local now = GetTime()
	NoteMovement(now, x, y, instance)
	local heading = ColorHeading(TravelHeading(hereBeDragons, now, x, y, instance), facing)

	PointNext(hereBeDragons, x, y, instance, facing, heading, rewrite)
	PointLines(hereBeDragons, x, y, instance, facing, heading)

	local angle, yards
	if not label then
		if rewrite or aimedAt ~= view then
			aimedAt, aimedPlace, aimedTask = view, nil, nil
			if not view.corpse then
				aimedPlace, aimedTask = NearestPlace(view, x, y)
			end
			local place = aimedPlace or view
			--[[
				To an area: at its nearest spawn, counting down to where the eye takes over, routes.AREA_REACH
				short of it, rather than to the middle of the camp, which the eye shows well before reaching
			]]
			aimedSpawnX, aimedSpawnY = nil, nil
			if aimedTask and place ~= view and routes.IsAreaPoint(place) then
				aimedSpawnX, aimedSpawnY = NearestSpawn(aimedTask, place, x, y)
			end
		end
		local target = aimedPlace or view
		angle, yards = hereBeDragons:GetWorldVector(instance, x, y, target.x, target.y)
		local isArea = target ~= view and routes.IsAreaPoint(target)
		local spawnX, spawnY = aimedSpawnX, aimedSpawnY
		if spawnX then
			local spawnAngle, spawnYards = hereBeDragons:GetWorldVector(instance, x, y, spawnX, spawnY)
			if spawnAngle then
				angle, yards = spawnAngle, math.max(0, spawnYards - routes.AREA_REACH)
			end
		end
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
			distance:SetTextColor(ns.GetColorRGB("INFO"))
		end
		return
	end
	if eyeLabel then
		eyeLabel, rewrite = nil, true -- Back to the arrow: its distance at once, not the eye's words
	end

	-- Pointing, at an area from outside it, or to a place; a corpse is reached from within its radius
	local arrived = view.corpse and yards <= view.radius
	arrow:SetRotation(angle - facing)
	arrow:SetVertexColor(Shade(angle - heading))
	if rewrite then
		local yardsText = routes.Settings().showDistance and routes.YardsText(yards) or ""
		distance:SetText(arrived and L["ROUTES_ARRIVED"] or yardsText)
		distance:SetTextColor(ns.GetColorRGB(arrived and "INFO" or "HELP"))
	end
end

frame:SetScript("OnUpdate", Point)

--------------------------------------------------------------------------------
-- Showing it
--------------------------------------------------------------------------------

-- In a raid group or an instance, as the settings hide it there, or on a flight path, with nowhere to steer
local function IsAway(settings)
	return routes.IsOnTaxi()
		or (settings.hideInRaids and IsInRaid())
		or (settings.hideInInstances and (IsInInstance()) == true)
end

local loggedIn = false
-- The scale last applied: GetScale() hands back a rounded value that may never equal the setting's
local appliedScale

local function Refresh()
	local settings = routes.Settings()
	local shown = settings.showArrow
		and (routes.stops[1] ~= nil or routes.groupUpTarget ~= nil)
		and not IsAway(settings)
	if appliedScale ~= settings.arrowScale then
		appliedScale = settings.arrowScale
		frame:SetScale(settings.arrowScale)
		if loggedIn then
			PlaceFrame()
		end
	end
	frame:SetShown(shown)
	if not shown then
		routes.arrowTarget, routes.arrowNext = nil, nil
	end
	if shown then
		sinceTurn, sinceText, sinceList = TURN_INTERVAL, TEXT_INTERVAL, LIST_INTERVAL -- Draws the new stop at once
	end
end

-- Whether there's a party member to head to changed (Routes-Group-Up.lua)
function routes.RefreshArrow()
	if loggedIn then
		Refresh()
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
