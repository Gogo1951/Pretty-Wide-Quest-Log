local _, ns = ...

--[[
	Routes: the quest list under the Quest Arrow, laid out on the arrow's own frame (Routes-Arrow.lua): the
	quests at the waypoint, what's on the way under "While You're Here", and the Next Objective
]]

local routes = ns.routes
local L = ns.L

local SPACE = ns.LAYOUT.SPACE
local parts, layout = routes.arrowParts, routes.ARROW_LAYOUT
local frame, distance, note = parts.frame, parts.distance, parts.note
local nextArrow, nextDistance = parts.nextArrow, parts.nextDistance
local WIDTH, ARROW_SIZE = layout.WIDTH, layout.ARROW_SIZE
local NEXT_ARROW_SIZE, EYE_TEXTURE = layout.NEXT_ARROW_SIZE, layout.EYE_TEXTURE
local DIM_ALPHA = layout.DIM_ALPHA
local ICON_SIZE = 16 -- The small eye beside "While You're Here": a quarter of the big one, on the doubling scale

--------------------------------------------------------------------------------
-- The quests at the stop
--------------------------------------------------------------------------------

--[[
	Lines of the quest list, made as needed and kept: each a quest's title, an objective, the name of
	someone who still needs it, the count of quests not listed, or a heading ("While You're Here", "Next
	Objective"). Each has a left side, a count on the right where it has one, and a small icon where it has one
]]
local lines = {}
local nextGutter = 0 -- How far the Next Objective's lines sit right of the block's edge, past its arrow and distance

local function Line(index, kind)
	local line = lines[index]
	if not line then
		line = frame:CreateFontString(nil, "OVERLAY")
		line:SetJustifyH("LEFT")
		line:SetWordWrap(false)
		line.count = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		line.count:SetJustifyH("RIGHT")
		line.count:SetWordWrap(false)
		line.icon = frame:CreateTexture(nil, "OVERLAY")
		line.icon:SetSize(ICON_SIZE, ICON_SIZE)
		lines[index] = line
	end
	line:SetFontObject(kind == "title" and "GameFontNormal" or "GameFontHighlight") -- Same size, titles gold and objectives white
	line.kind = kind
	line:Show()
	return line
end

-- A font string's line height, whether or not it holds text now
local function LineHeight(fontString)
	local _, size = fontString:GetFont()
	return size or 12
end

--[[
	How far in a line starts from the list's left edge: objectives indented under their quest, names under
	those, and the Next Objective's lines right of its arrow column. The count of quests not listed stands
	for whole quests, so it's flush with their titles
]]
local function Indent(line)
	local column = line.next and nextGutter or 0
	if line.kind == "title" or line.kind == "section" or line.kind == "more" then
		return column
	elseif line.kind == "name" then
		return column + 2 * SPACE.NEAR
	end
	return column + SPACE.NEAR
end

--[[
	Lists the stop's quests under the arrow and sizes the frame to fit. The lines are left-aligned with
	each other and the block centered under the arrow, as wide as its widest line, each on one line, cut
	short past WIDTH; the counts line up on the block's right edge, at least SPACE.GROUP from what's left
	of them. The distance line keeps its room while blank, so the list doesn't jump on arrival. The frame
	takes the mouse only over the arrow and the block, not the empty width either side
]]
local listedKey
local pending = {}
local nextShown = false -- Whether the Next Objective is laid out, which ListQuests returns

--[[
	Where each quest's title sits, for the item buttons beside it (Routes-Arrow-Items.lua): rows, each
	{ questID, top, room, dim } in the frame's own units from its top, room being how far down the quest's
	lines reach (16 more is clear before what comes next); right, the block's right edge from the frame's left; and version,
	counted up on every layout. The Next Objective's quest has none, as it isn't where the player is yet
]]
local titleRows = { rows = {}, right = 0, version = 0 }
routes.arrowTitleRows = titleRows

--[[
	view is what the list is about; note goes under "Current Objective Area"; passing is a stop's worth of
	objectives on the way, listed dimmed under "While You're Here"; nextStop is where the route goes after
	the area: dimmed, its arrow and distance in a column on the left, and on the right "Next Objective",
	its first quest and what's to do there, as the list writes a quest. Returns whether the Next Objective
	is laid out, so Point turns its arrow
]]
local function ListQuests(view, noteText, passing, nextStop)
	local settings = routes.Settings()
	-- The lines first, so a second with nothing changed lays nothing out again
	local count, texts = 0, {}
	local function Add(kind, text, red, green, blue, right, dim, icon, isNext, questID)
		count = count + 1
		local entry = pending[count] or {}
		pending[count] = entry
		entry.kind, entry.text, entry.right, entry.dim, entry.icon = kind, text, right, dim, icon
		entry.next, entry.questID = isNext, questID
		entry.red, entry.green, entry.blue = red, green, blue
		texts[count] = string.format(
			"%s%.2f%.2f%.2f%s|%s|%s%s%s%s",
			kind,
			red,
			green,
			blue,
			text,
			right or "",
			dim and "dim" or "",
			icon or "",
			isNext and "next" or "",
			questID or ""
		)
	end
	local function AddStop(stop, dim)
		routes.ForEachStopLine(stop, settings.questsListed, function(kind, text, red, green, blue, right, questID)
			Add(kind, text, red, green, blue, right, dim, nil, nil, questID)
		end)
	end
	if settings.showQuests then
		AddStop(view, false)
		if passing then
			local red, green, blue = ns.GetColorRGB("HELP")
			Add("section", L["ROUTES_WHILE_HERE"], red, green, blue, nil, true, "eye")
			AddStop(passing, true)
		end
	end
	if nextStop then
		local red, green, blue = ns.GetColorRGB("HELP")
		Add("section", L["ROUTES_NEXT_OBJECTIVE"], red, green, blue, nil, true, nil, true)
		-- Its first quest only, with its objectives and, in a party, who needs each: the rest once there
		routes.ForEachStopLine(nextStop, 1, function(kind, text, lineRed, lineGreen, lineBlue, right)
			if kind ~= "more" then
				Add(kind, text, lineRed, lineGreen, lineBlue, right, true, nil, true)
			end
		end)
	end
	local key = (noteText or "") .. "\n" .. table.concat(texts, "\n")
	if key == listedKey then
		return nextShown
	end
	listedKey = key

	note:SetText(noteText or "")
	note:SetTextColor(ns.GetColorRGB("HELP"))
	note:SetShown(noteText ~= nil)
	local y = ARROW_SIZE + SPACE.LINE + LineHeight(distance)
	if noteText then
		y = y + SPACE.LINE + LineHeight(note)
	end

	-- The Next Objective's column: as wide as the longest distance, so it holds still as it counts down
	local nextColumn, nextTop = 0, nil
	nextGutter = 0
	if nextStop then
		nextDistance:SetText(routes.YardsText(9999))
		nextColumn = math.ceil(math.max(NEXT_ARROW_SIZE, nextDistance:GetStringWidth() or 0))
		nextGutter = nextColumn + SPACE.GROUP
		nextDistance:SetText("")
	end

	local used, blockWidth, previous = 0, 0, nil
	for index = 1, count do
		local entry = pending[index]
		local kind = entry.kind
		used = used + 1
		local line = Line(used, kind)
		line.next = entry.next
		--[[
			16 above each quest, heading and the count of quests not listed, 8 under a heading as the quest
			page leaves under its headings, and 4 between a quest's lines
		]]
		if used == 1 or kind == "section" or kind == "more" then
			y = y + SPACE.GROUP
		elseif previous == "section" then
			y = y + SPACE.NEAR
		elseif kind == "title" then
			y = y + SPACE.GROUP
		else
			y = y + SPACE.LINE
		end
		previous = kind
		line.top = y
		if entry.next and not nextTop then
			nextTop = y
		end
		line:SetWidth(0) -- Unbounded while it's measured, then held to the frame below
		line:SetText(entry.text)
		line:SetTextColor(entry.red, entry.green, entry.blue)
		local alpha = entry.dim and DIM_ALPHA or 1
		line:SetAlpha(alpha)
		line.count:SetAlpha(alpha)
		line.icon:SetAlpha(alpha)
		line.iconWidth = entry.icon and (ICON_SIZE + SPACE.LINE) or 0
		if entry.icon == "eye" then
			line.icon:SetTexture(EYE_TEXTURE)
			line.icon:SetRotation(0)
			line.icon:SetVertexColor(ns.GetColorRGB("INFO"))
			line.icon:Show()
		else
			line.icon:Hide()
		end
		local width = Indent(line) + line.iconWidth + (line:GetStringWidth() or 0)
		line.countWidth = 0
		if entry.right then
			line.count:SetText(entry.right)
			line.count:SetTextColor(ns.GetColorRGB("HELP"))
			line.count:Show()
			line.countWidth = (line.count:GetStringWidth() or 0) + SPACE.GROUP
		else
			line.count:Hide()
		end
		blockWidth = math.max(blockWidth, width + line.countWidth)
		y = y + LineHeight(line)
	end
	blockWidth = math.min(math.ceil(blockWidth), WIDTH) -- Whole pixels, so the widest line isn't cut short by a fraction
	local left = math.max(0, (WIDTH - blockWidth) / 2)
	for i = 1, used do
		local line = lines[i]
		local x = left + Indent(line)
		line:ClearAllPoints()
		line.count:ClearAllPoints()
		line.icon:ClearAllPoints()
		if line.iconWidth > 0 then
			line.icon:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -(line.top + (LineHeight(line) - ICON_SIZE) / 2))
			x = x + line.iconWidth
		end
		line:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -line.top)
		line:SetWidth(math.max(1, blockWidth - (x - left) - line.countWidth))
		line.count:SetPoint("TOPRIGHT", frame, "TOPLEFT", left + blockWidth, -line.top)
	end
	for i = used + 1, #lines do
		lines[i]:Hide()
		lines[i].count:Hide()
		lines[i].icon:Hide()
	end

	-- The arrow level with "Next Objective", the distance under it as under the big one, both centered in the column
	nextShown = nextTop ~= nil
	nextArrow:ClearAllPoints()
	nextDistance:ClearAllPoints()
	if nextShown then
		local middle = left + nextColumn / 2
		nextArrow:SetPoint("TOP", frame, "TOPLEFT", middle, -nextTop)
		nextDistance:SetPoint("TOP", frame, "TOPLEFT", middle, -(nextTop + NEXT_ARROW_SIZE + SPACE.LINE))
		nextDistance:SetAlpha(DIM_ALPHA)
		y = math.max(y, nextTop + NEXT_ARROW_SIZE + SPACE.LINE + LineHeight(nextDistance))
	end
	nextArrow:SetShown(nextShown)
	nextDistance:SetShown(nextShown)

	-- Each quest's title, and how far down its lines reach before the next quest, heading or count
	wipe(titleRows.rows)
	local lastRow
	for i = 1, used do
		local line, entry = lines[i], pending[i]
		if entry.kind == "title" or entry.kind == "section" or entry.kind == "more" then
			lastRow = nil
		end
		if entry.kind == "title" and entry.questID and not entry.next then
			lastRow = { questID = entry.questID, top = line.top, room = 0, dim = entry.dim }
			titleRows.rows[#titleRows.rows + 1] = lastRow
		end
		if lastRow then
			lastRow.room = line.top + LineHeight(line) - lastRow.top
		end
	end
	titleRows.right = left + blockWidth
	titleRows.version = titleRows.version + 1

	frame:SetHeight(y)
	local inset = math.max(0, (WIDTH - math.max(blockWidth, ARROW_SIZE)) / 2)
	frame:SetHitRectInsets(inset, inset, 0, 0)
	frame.hitInset = inset
	return nextShown
end

-- Point lists the quests as they change (Routes-Arrow.lua)
routes.ListArrowQuests = ListQuests
