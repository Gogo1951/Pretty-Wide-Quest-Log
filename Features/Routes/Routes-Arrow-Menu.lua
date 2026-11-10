local _, ns = ...

--[[
	Routes: the Quest Arrow's menu, laid out as WIM's whisper list is: a dark plate with angled corners and a
	row for each thing to do. The mouse over the arrow opens it under the arrow's list, or above the arrow in
	the lower half of the screen. It stays open while the mouse is on the arrow or the menu and closes
	CLOSE_DELAY after the mouse leaves both; Escape closes it.

	Three groups, each under a small gold label, its rows indented a space as the tooltips are:
	Ignore, each objective or turn-in at the waypoint the arrow shows, then at its Next Objective (Next on
	the right), clicked to leave it off the route until the zone is reset (routes.IgnoreTask).
	What is Shown: Next Objective, the showNextObjective setting; Future Turn-Ins, showUpcomingTurnIns;
	Local Available Quests, showLocalQuests; in a party, Party Objectives, partyQuests, and with it on an
	Objectives From switch for each member, a space further in. A switch that's off is gray, On green. Ignored, with
	how many on the right: the ignore list in gray, a row brightening with Put Back on the right under the
	mouse, clicked to put it back on the route (routes.UnignoreTask). Then the arrow's click hints:
	right-click ignores the objective the arrow shows first (routes.IgnoreArrowObjective), middle-click
	resets the zone (routes.ResetZone)
]]

local routes = ns.routes
local L = ns.L

local SPACE = ns.LAYOUT.SPACE

--[[
	The plate's art, drawn at half its size so the edges stay sharp: PLATE_SIZE pixels square, the plate
	itself PLATE_MARGIN in from each edge and the rest its shadow, each corner piece PLATE_CORNER across
]]
local PLATE_TEXTURE = "Interface\\AddOns\\Pretty-Wide-Quest-Log\\Includes\\Images\\Route-Menu"
local PLATE_SIZE = 128
local PLATE_MARGIN = { left = 12, right = 12, top = 10, bottom = 14 }
local PLATE_CORNER = 32
local PLATE_SCALE = 0.5

local CLOSE_DELAY = 0.25 -- Seconds the menu stays once the mouse leaves it and the arrow
local REFRESH_INTERVAL = 0.5 -- Seconds between checks for its rows changing
local MIN_WIDTH = 128
local ROW_INSET = SPACE.LINE -- From the plate's edge to a row's highlight
local TEXT_INSET = SPACE.NEAR -- From a row's edge to its text
local HIGHLIGHT_ALPHA = 0.16
local PLATE_ALPHA = 0.8 -- The plate's art is black: a little of the world shows through, so it reads lighter
local INDENT = " " -- Per level, as the tooltips indent their rows

local menu = CreateFrame("Frame", "PrettyWideQuestLogRouteMenu", UIParent)
menu:SetFrameStrata("DIALOG")
menu:SetClampedToScreen(true)
menu:EnableMouse(true)
menu:Hide()
tinsert(UISpecialFrames, menu:GetName()) -- Escape closes it

--------------------------------------------------------------------------------
-- The plate
--------------------------------------------------------------------------------

-- Nine pieces: the corners at their own size, keeping the angle and shadow, the edges and middle stretched
do
	local plate = CreateFrame("Frame", nil, menu)
	plate:SetPoint("TOPLEFT", -PLATE_MARGIN.left * PLATE_SCALE, PLATE_MARGIN.top * PLATE_SCALE)
	plate:SetPoint("BOTTOMRIGHT", PLATE_MARGIN.right * PLATE_SCALE, -PLATE_MARGIN.bottom * PLATE_SCALE)
	plate:SetFrameLevel(menu:GetFrameLevel()) -- Under the rows
	plate:SetAlpha(PLATE_ALPHA)

	local near, far = PLATE_CORNER / PLATE_SIZE, 1 - PLATE_CORNER / PLATE_SIZE
	local corner = PLATE_CORNER * PLATE_SCALE

	local function Piece(left, right, top, bottom)
		local texture = plate:CreateTexture(nil, "BACKGROUND")
		texture:SetTexture(PLATE_TEXTURE)
		texture:SetTexCoord(left, right, top, bottom)
		return texture
	end

	local topLeft = Piece(0, near, 0, near)
	topLeft:SetSize(corner, corner)
	topLeft:SetPoint("TOPLEFT")
	local topRight = Piece(far, 1, 0, near)
	topRight:SetSize(corner, corner)
	topRight:SetPoint("TOPRIGHT")
	local bottomLeft = Piece(0, near, far, 1)
	bottomLeft:SetSize(corner, corner)
	bottomLeft:SetPoint("BOTTOMLEFT")
	local bottomRight = Piece(far, 1, far, 1)
	bottomRight:SetSize(corner, corner)
	bottomRight:SetPoint("BOTTOMRIGHT")

	local top = Piece(near, far, 0, near)
	top:SetPoint("TOPLEFT", topLeft, "TOPRIGHT")
	top:SetPoint("BOTTOMRIGHT", topRight, "BOTTOMLEFT")
	local bottom = Piece(near, far, far, 1)
	bottom:SetPoint("TOPLEFT", bottomLeft, "TOPRIGHT")
	bottom:SetPoint("BOTTOMRIGHT", bottomRight, "BOTTOMLEFT")
	local left = Piece(0, near, near, far)
	left:SetPoint("TOPLEFT", topLeft, "BOTTOMLEFT")
	left:SetPoint("BOTTOMRIGHT", bottomLeft, "TOPRIGHT")
	local right = Piece(far, 1, near, far)
	right:SetPoint("TOPLEFT", topRight, "BOTTOMLEFT")
	right:SetPoint("BOTTOMRIGHT", bottomRight, "TOPRIGHT")
	local middle = Piece(near, far, near, far)
	middle:SetPoint("TOPLEFT", topLeft, "BOTTOMRIGHT")
	middle:SetPoint("BOTTOMRIGHT", bottomRight, "TOPLEFT")
end

--------------------------------------------------------------------------------
-- What's on it
--------------------------------------------------------------------------------

--[[
	The objectives, turn-ins and pick-ups at the waypoint the arrow shows, still to do and not ignored (an ignored one
	stays at the waypoint until the next plan, which in combat waits for the fight to end): the quests as the arrow lists
	them, each one's objectives in the quest log's order, then its turn-in or pick-up. Nothing for the way back to the corpse
]]
local function MenuTasks(view)
	local tasks = {}
	if not view or view.corpse then
		return tasks
	end
	local byObjective, turnIns, pickUps = {}, {}, {}
	for _, task in ipairs(view.tasks) do
		if task.key and routes.IsTaskLeft(task) and not routes.skipped[task.key] then
			if task.objective then
				byObjective[task.objective] = task
			elseif task.kind == "turnIn" then
				turnIns[task.questID] = task
			elseif task.kind == "pickUp" then
				pickUps[task.questID] = task
			end
		end
	end
	for _, entry in ipairs(routes.QuestsAt(view, routes.PositionAt(view))) do
		for _, objective in ipairs(routes.QuestObjectives(entry)) do
			if byObjective[objective] then
				tasks[#tasks + 1] = byObjective[objective]
			end
		end
		if turnIns[entry.task.questID] then
			tasks[#tasks + 1] = turnIns[entry.task.questID]
		end
		if pickUps[entry.task.questID] then
			tasks[#tasks + 1] = pickUps[entry.task.questID]
		end
	end
	return tasks
end

-- The objective the arrow shows first, the top of what it lists, or nil with nothing there to ignore
local function ArrowObjective()
	return MenuTasks(routes.arrowTarget)[1]
end

-- Right-click on the arrow: leaves the objective it shows first off the route, as the menu's first Ignore does
function routes.IgnoreArrowObjective()
	local task = ArrowObjective()
	if task then
		routes.IgnoreTask(task)
	end
end

local function Colored(text, red, green, blue)
	return string.format("|cff%02x%02x%02x%s|r", red * 255, green * 255, blue * 255, text)
end

--[[
	The menu's rows, each { kind, left, right, leftColor, rightColor, hover, action }: kind "header",
	"section" (a group's label), "separator", "action" (a row to click), "toggle" (a row to click, On or Off
	on the right), "status" (a toggle that can't be switched now, its reason on the right), or "hint" (a
	click hint). hover, { right, rightColor }, is the right side under the mouse, the name brightened.
	Returns them and a key that changes only when what they say does
]]
local function Entries()
	local entries = {}
	local function Add(entry)
		entries[#entries + 1] = entry
	end
	local function Separator()
		Add({ kind = "separator" })
	end
	local function Section(left, right)
		Add({ kind = "section", left = left, right = right, rightColor = "MUTED" })
	end

	Add({ kind = "header", left = L["TAB_QUEST_ARROW"], right = L["ADDON_SHORT_NAME"], rightColor = "MUTED" })

	--[[
		Ignore: what the arrow lists, then its Next Objective, Next on the right, so the next waypoint can be
		left off before the player gets there. A task in both is offered once, as the arrow's
	]]
	local offered, ignoreRows = {}, {}
	for pass = 1, 2 do -- Not ipairs: with nothing at the arrow, its Next Objective still gets its rows
		local isNext = pass == 2
		local view = isNext and routes.arrowNext or routes.arrowTarget
		for _, task in ipairs(MenuTasks(view)) do
			if not offered[task.key] then
				offered[task.key] = true
				ignoreRows[#ignoreRows + 1] = {
					kind = "action",
					left = INDENT .. routes.TaskLabel(task),
					right = isNext and L["ROUTES_MENU_NEXT"] or nil,
					rightColor = "MUTED",
					action = function()
						routes.IgnoreTask(task)
					end,
				}
			end
		end
	end
	if #ignoreRows > 0 then
		Section(L["ROUTES_MENU_SECTION_IGNORE"])
		for _, row in ipairs(ignoreRows) do
			Add(row)
		end
	end

	-- A switch: On in green, or Off with its name gray too, so what's off sits back
	local function Toggle(left, on, action)
		Add({
			kind = "toggle",
			left = left,
			leftColor = not on and "MUTED" or nil,
			right = on and L["ROUTES_MENU_ON"] or L["ROUTES_MENU_OFF"],
			rightColor = on and "ON" or "MUTED",
			action = action,
		})
	end

	Section(L["ROUTES_MENU_SECTION_SHOWN"])

	-- Next Objective, the showNextObjective setting, as Options switches it
	Toggle(INDENT .. L["ROUTES_NEXT_OBJECTIVE"], routes.Settings().showNextObjective, function()
		routes.SetSetting("showNextObjective", not routes.Settings().showNextObjective)
	end)

	-- Future Turn-Ins, the showUpcomingTurnIns setting, as Options switches it: planned again at once
	Toggle(INDENT .. L["ROUTES_MENU_SHOWN_TURN_INS"], routes.Settings().showUpcomingTurnIns, function()
		routes.SetSetting("showUpcomingTurnIns", not routes.Settings().showUpcomingTurnIns)
		routes.RequestPlan()
	end)

	-- Local Available Quests, the showLocalQuests setting, as Options switches it
	Toggle(INDENT .. L["ROUTES_MENU_SHOWN_LOCAL"], routes.Settings().showLocalQuests, function()
		routes.SetSetting("showLocalQuests", not routes.Settings().showLocalQuests)
		routes.RequestPlan()
	end)

	--[[
		Under it, only in a party, where the setting does anything: Party Objectives, and with it on, a
		switch for each member's objectives a space further in
	]]
	if routes.IsInParty() then
		local on = routes.Settings().partyQuests
		Toggle(INDENT .. L["ROUTES_MENU_SHOWN_PARTY"], on, function()
			routes.SetPartyQuests(not routes.Settings().partyQuests)
		end)
		local members = on and routes.PartyMembers(true) or {}
		--[[
			Why a member's objectives aren't on the route, in gray: Offline; No Questie, for one sharing none;
			Out of Zone, left off until they're back. None has anything to click, and the switch keeps its
			place for when that changes
		]]
		for _, member in ipairs(members) do
			local included = routes.ignoredMembers[member.name] == nil
			local name = Colored(member.name, routes.ClassColor(member.unit))
			local left = INDENT .. INDENT .. string.format(L["ROUTES_MENU_MEMBER_OBJECTIVES"], name)
			if member.offline then
				Add({ kind = "status", left = left, right = L["ROUTES_MENU_OFFLINE"], rightColor = "MUTED" })
			elseif not routes.MemberHasQuestie(member.name) then
				Add({ kind = "status", left = left, right = L["ROUTES_MENU_NO_QUESTIE"], rightColor = "MUTED" })
			elseif routes.IsUnitOutOfZone(member.unit) then
				Add({ kind = "status", left = left, right = L["ROUTES_MENU_OUT_OF_ZONE"], rightColor = "MUTED" })
			else
				Toggle(left, included, function()
					routes.SetMemberIgnored(member.name, included)
				end)
			end
		end
	end

	-- Ignored, with how many: the ignore list in gray, each brightening with Put Back under the mouse
	local ignored = routes.IgnoredTasks()
	if #ignored > 0 then
		Section(L["ROUTES_MENU_IGNORED"], tostring(#ignored))
		for _, entry in ipairs(ignored) do
			Add({
				kind = "action",
				left = INDENT .. entry.label,
				leftColor = "MUTED",
				hover = { right = L["ROUTES_MENU_PUT_BACK"], rightColor = "ON" },
				action = function()
					routes.UnignoreTask(entry.key)
				end,
			})
		end
	end

	Separator()
	if not routes.Settings().lockArrow then
		Add({ kind = "hint", left = L["ROUTES_CLICK_DRAG"], right = L["ROUTES_DRAG_MOVE"] })
	end
	if ArrowObjective() then
		Add({ kind = "hint", left = L["ROUTES_CLICK_RIGHT"], right = L["ROUTES_RIGHT_CLICK_IGNORE"] })
	end
	Add({ kind = "hint", left = L["ROUTES_CLICK_MIDDLE"], right = L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] })

	local parts = {}
	for index, entry in ipairs(entries) do
		parts[index] = entry.kind .. "|" .. (entry.left or "") .. "|" .. (entry.right or "")
	end
	return entries, table.concat(parts, "\n")
end

--------------------------------------------------------------------------------
-- Laying it out
--------------------------------------------------------------------------------

local rows = {}

local function Paint(fontString, text, colorKey, fontObject)
	if fontObject then
		fontString:SetFontObject(fontObject)
	end
	fontString:SetText(text or "")
	if colorKey then
		fontString:SetTextColor(ns.GetColorRGB(colorKey))
	end
	fontString:SetShown(text ~= nil)
end

-- How a row reads, or under the mouse its hover: the name brightened and the hover's right side
local function Dress(row, over)
	local look, hover = row.look, over and row.hover
	Paint(row.left, look.left, hover and "TEXT" or look.leftColor)
	if hover then
		Paint(row.right, hover.right, hover.rightColor)
	else
		Paint(row.right, look.right, look.rightColor)
	end
end

local function Row(index)
	local row = rows[index]
	if not row then
		row = CreateFrame("Button", nil, menu)
		row:RegisterForClicks("LeftButtonUp")
		row.highlight = row:CreateTexture(nil, "HIGHLIGHT")
		row.highlight:SetAllPoints()
		local red, green, blue = ns.GetColorRGB("TITLE")
		row.highlight:SetColorTexture(red, green, blue, HIGHLIGHT_ALPHA)
		row.left = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		row.left:SetJustifyH("LEFT")
		row.left:SetWordWrap(false)
		row.right = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		row.right:SetJustifyH("RIGHT")
		row.right:SetWordWrap(false)
		row.line = row:CreateTexture(nil, "ARTWORK")
		row.line:SetHeight(1)
		row.line:SetPoint("LEFT", TEXT_INSET, 0)
		row.line:SetPoint("RIGHT", -TEXT_INSET, 0)
		red, green, blue = ns.GetColorRGB("SEPARATOR")
		row.line:SetColorTexture(red, green, blue, 0.35)
		row:SetScript("OnClick", function(self)
			if self.action then
				self.action()
				routes.RefreshArrowMenu()
			end
		end)
		row:SetScript("OnEnter", function(self)
			if self.hover then
				Dress(self, true)
			end
		end)
		row:SetScript("OnLeave", function(self)
			if self.hover then
				Dress(self, false)
			end
		end)
		rows[index] = row
	end
	row:Show()
	return row
end

--[[
	Sizes the menu to its rows: each as tall as a line and SPACE.LINE above and below, a group's label
	SPACE.NEAR above instead to set its group apart, the separators SPACE.NEAR
]]
local function Layout(entries)
	local width, y = MIN_WIDTH, SPACE.NEAR
	for index, entry in ipairs(entries) do
		local row = Row(index)
		local kind = entry.kind
		local clickable = kind == "action" or kind == "toggle"
		row:EnableMouse(clickable)
		row.line:SetShown(kind == "separator")
		row.hover = entry.hover
		local height
		if kind == "separator" then
			Paint(row.left, nil)
			Paint(row.right, nil)
			height = SPACE.NEAR
		else
			local font = kind == "header" and "GameFontNormal"
				or kind == "section" and "GameFontNormalSmall"
				or "GameFontHighlight"
			row.left:SetFontObject(font)
			row.right:SetFontObject(kind == "section" and font or "GameFontHighlight")
			local leftColor = entry.leftColor
				or (kind == "header" or kind == "section") and "TITLE"
				or kind == "hint" and "INFO"
				or "TEXT"
			local rightColor = entry.rightColor or (kind == "hint" and "INFO") or "TEXT"
			row.look = { left = entry.left, leftColor = leftColor, right = entry.right, rightColor = rightColor }
			local _, size = row.left:GetFont()
			local above = kind == "section" and SPACE.NEAR or SPACE.LINE
			height = (size or 12) + above + SPACE.LINE
			-- Centered on the line, not the row, so a label's extra room is all above it
			local drop = (above - SPACE.LINE) / 2
			row.left:ClearAllPoints()
			row.left:SetPoint("LEFT", TEXT_INSET, -drop)
			row.right:ClearAllPoints()
			row.right:SetPoint("RIGHT", -TEXT_INSET, -drop)
			-- As wide as its widest look: the hover's right side measured too, so Put Back never crowds the name
			local rightWidth = 0
			if row.hover then
				Dress(row, true)
				rightWidth = row.right:GetStringWidth() or 0
			end
			Dress(row, false)
			if entry.right then
				rightWidth = math.max(rightWidth, row.right:GetStringWidth() or 0)
			end
			local textWidth = row.left:GetStringWidth() or 0
			if rightWidth > 0 then
				textWidth = textWidth + SPACE.GROUP + rightWidth
			end
			width = math.max(width, textWidth + 2 * (TEXT_INSET + ROW_INSET))
			if row.hover and row:IsMouseOver() then
				Dress(row, true)
			end
		end
		row:SetHeight(height)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", menu, "TOPLEFT", ROW_INSET, -y)
		row:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -ROW_INSET, -y)
		y = y + height
	end
	for index = #entries + 1, #rows do
		rows[index]:Hide()
	end
	menu:SetSize(math.ceil(width), y + SPACE.NEAR)
end

local shownKey

-- Rebuilds the rows where what they say has changed; their actions always, as a new plan makes new tasks
function routes.RefreshArrowMenu()
	if not menu:IsShown() then
		return
	end
	local entries, key = Entries()
	if key ~= shownKey then
		shownKey = key
		Layout(entries)
	end
	for index, entry in ipairs(entries) do
		rows[index].action = entry.action
	end
end

--------------------------------------------------------------------------------
-- Opening and closing
--------------------------------------------------------------------------------

-- Under the arrow's list, or above the arrow in the lower half of the screen, so it opens toward the middle
local function Place()
	local arrow = routes.arrowFrame
	menu:ClearAllPoints()
	local _, centerY = arrow:GetCenter()
	local scale = arrow:GetEffectiveScale() / UIParent:GetEffectiveScale()
	if not centerY or centerY * scale > UIParent:GetHeight() / 2 then
		menu:SetPoint("TOP", arrow, "BOTTOM", 0, -SPACE.NEAR)
	else
		menu:SetPoint("BOTTOM", arrow, "TOP", 0, SPACE.NEAR)
	end
end

local lastOver, sinceRefresh = 0, 0

menu:SetScript("OnUpdate", function(self, elapsed)
	if not routes.arrowFrame:IsVisible() then
		self:Hide()
		return
	end
	local now = GetTime()
	if self:IsMouseOver() or routes.IsMouseOverArrow() then
		lastOver = now
	elseif now - lastOver > CLOSE_DELAY then
		self:Hide()
		return
	end
	sinceRefresh = sinceRefresh + elapsed
	if sinceRefresh >= REFRESH_INTERVAL then
		sinceRefresh = 0
		routes.RefreshArrowMenu()
	end
end)

function routes.ShowArrowMenu()
	lastOver, sinceRefresh = GetTime(), 0
	if not menu:IsShown() then
		shownKey = nil
		Place()
		menu:Show()
	end
	routes.RefreshArrowMenu()
end

function routes.HideArrowMenu()
	menu:Hide()
end

function routes.IsArrowMenuShown()
	return menu:IsShown()
end

-- A new plan, or a setting switched: the rows change with them
routes.AddListener(routes.RefreshArrowMenu)
