local _, ns = ...

--[[
	Routes: the Quest Arrow's menu, laid out as WIM's whisper list is: a dark plate with angled corners and a
	row for each thing to do. The mouse over the arrow opens it under the arrow's list, or above the arrow in
	the lower half of the screen. It stays open while the mouse is on the arrow or the menu and closes
	CLOSE_DELAY after the mouse leaves both; Escape closes it.

	Under the title and a line's room, groups under small gold labels, rows indented a space as the
	tooltips are: Ignore, each objective or turn-in at the waypoint the arrow shows, then at its Next
	Objective (Next on the right), clicked to leave it off the route until the zone is reset
	(routes.IgnoreTask). Then three labels with Blizzard's submenu arrow, each opening a flyout beside the
	menu on the same plate. Route, what the route plans, most used first: Predictive Questing Routes,
	predictiveRoutes; Local Available Quests, showLocalQuests; Flight Paths, showFlightPaths; in a party,
	Party Objectives, partyQuests, and with it on an Objectives From switch for each member, a space in.
	Show, what only the arrow draws: Next Objective, showNextObjective. A switch that's off is gray, On
	green. Ignored, with how many, only while something is: the ignore list, each row gray, brightening with
	Put Back on the right under the mouse, clicked to put it back on the route (routes.UnignoreTask).
	Then a line and the arrow's click hints, each a row to use as well as a reminder: Drag, dragged, moves the
	arrow (routes.DragArrowFromMenu); right-click ignores the objective the arrow shows first
	(routes.IgnoreArrowObjective); middle-click resets the zone (routes.ResetZone)
]]

local routes = ns.routes
local L = ns.L

local SPACE = ns.LAYOUT.SPACE

-- The menu's plate and its flyout's, and laying out their rows (Routes-Arrow-Menu-Panel.lua)
local panels = routes.arrowMenuPanels
local menu, submenu = panels.menu, panels.submenu
local Fill, OpenSubmenu, CloseSubmenu = panels.Fill, panels.OpenSubmenu, panels.CloseSubmenu

local CLOSE_DELAY = 0.25 -- Seconds the menu stays once the mouse leaves it and the arrow
local REFRESH_INTERVAL = 0.5 -- Seconds between checks for its rows changing
local INDENT = " " -- Per level, as the tooltips indent their rows
-- Blizzard's own arrow on a dropdown row with a submenu, on the Route, Show and Ignored labels
local SUBMENU_ARROW = "|TInterface\\ChatFrame\\ChatFrameExpandArrow:0|t"

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
	local byObjective, turnIns, pickUps, flightPaths = {}, {}, {}, {}
	for _, task in ipairs(view.tasks) do
		if task.key and routes.IsTaskLeft(task) and not routes.skipped[task.key] then
			if task.objective then
				byObjective[task.objective] = task
			elseif task.kind == "turnIn" then
				turnIns[task.questID] = task
			elseif task.kind == "pickUp" then
				pickUps[task.questID] = task
			elseif task.kind == "flightPath" or task.kind == "fly" then
				flightPaths[task.key] = task -- A flight path to discover or a flight to take, neither a quest's
			end
		end
	end
	for _, entry in ipairs(routes.QuestsAt(view, routes.PositionAt(view))) do
		if flightPaths[entry.task.key] then
			tasks[#tasks + 1] = flightPaths[entry.task.key]
		end
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

--[[
	Right-click on the arrow: leaves the objective it shows first off the route, as the menu's first Ignore
	does. Nothing while it says Join Up with Group, which the setting turns off, not a click
]]
function routes.IgnoreArrowObjective()
	if routes.groupUpTarget then
		return
	end
	local task = ArrowObjective()
	if task then
		routes.IgnoreTask(task)
	end
end

local function Colored(text, red, green, blue)
	return string.format("|cff%02x%02x%02x%s|r", red * 255, green * 255, blue * 255, text)
end

-- A key for a panel's rows that changes only when what they say does
local function EntriesKey(entries)
	local parts = {}
	for index, entry in ipairs(entries) do
		parts[index] = entry.kind .. "|" .. (entry.left or "") .. "|" .. (entry.right or "")
	end
	return table.concat(parts, "\n")
end

-- A switch: On in green, or Off with its name gray too, so what's off sits back
local function ToggleEntry(left, on, action)
	return {
		kind = "toggle",
		left = left,
		leftColor = not on and "MUTED" or nil,
		right = on and L["ROUTES_MENU_ON"] or L["ROUTES_MENU_OFF"],
		rightColor = on and "ON" or "MUTED",
		action = action,
	}
end

--[[
	The menu's rows, each { kind, left, right, leftColor, rightColor, hover, action, submenu }: kind "header",
	"spacer" (a line's room), "section" (a group's label), "separator", "action" (a row to click), "toggle" (a
	row to click, On or Off on the right), "status" (a toggle that can't be switched now, its reason on the
	right), or "hint" (a click hint). hover, { right, rightColor }, is the right side under the mouse, the name
	brightened. submenu, on a label, names the flyout it opens under the mouse or a click (panels.submenus).
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
	-- A label that opens a flyout, Blizzard's submenu arrow on the right after anything it says there
	local function Submenu(left, name, count)
		Add({
			kind = "section",
			left = left,
			right = (count and tostring(count) .. " " or "") .. SUBMENU_ARROW,
			rightColor = "MUTED",
			submenu = name,
		})
	end

	Add({ kind = "header", left = L["TAB_QUEST_ARROW"], right = L["ADDON_SHORT_NAME"], rightColor = "MUTED" })
	Add({ kind = "spacer" })

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

	-- Route and Show, each a flyout of its switches (RouteEntries, ShowEntries)
	Submenu(L["ROUTES_MENU_SECTION_ROUTE"], "route")
	Submenu(L["ROUTES_MENU_SECTION_SHOW"], "show")

	-- Ignored, with how many: the ignore list in a flyout (IgnoredEntries)
	local ignored = routes.IgnoredTasks()
	if #ignored > 0 then
		Submenu(L["ROUTES_MENU_IGNORED"], "ignored", #ignored)
	end

	--[[
		The click hints, each a row to use as well: Drag dragged moves the arrow, the others clicked do what that
		click on the arrow does
	]]
	Separator()
	if not routes.Settings().lockArrow then
		Add({ kind = "hint", left = L["ROUTES_CLICK_DRAG"], right = L["ROUTES_DRAG_MOVE"], drag = true })
	end
	if not routes.groupUpTarget and ArrowObjective() then
		Add({
			kind = "hint",
			left = L["ROUTES_CLICK_RIGHT"],
			right = L["ROUTES_RIGHT_CLICK_IGNORE"],
			action = routes.IgnoreArrowObjective,
		})
	end
	Add({
		kind = "hint",
		left = L["ROUTES_CLICK_MIDDLE"],
		right = L["ROUTES_MIDDLE_CLICK_RESET_ZONE"],
		action = routes.ResetZone,
	})

	return entries, EntriesKey(entries)
end

--[[
	Route's flyout: what the route plans, most used first, each as Options switches it and planned again at
	once. In a party, where the setting does anything, Party Objectives, and with it on, a switch for each
	member's objectives a space in
]]
local function RouteEntries()
	local settings = routes.Settings()
	local entries = {
		ToggleEntry(L["ROUTES_MENU_SHOWN_PREDICTIVE"], settings.predictiveRoutes, function()
			routes.SetSetting("predictiveRoutes", not routes.Settings().predictiveRoutes)
			routes.RequestPlan()
		end),
		ToggleEntry(L["ROUTES_MENU_SHOWN_LOCAL"], settings.showLocalQuests, function()
			routes.SetSetting("showLocalQuests", not routes.Settings().showLocalQuests)
			routes.RequestPlan()
		end),
		ToggleEntry(L["ROUTES_MENU_SHOWN_FLIGHTS"], settings.showFlightPaths, function()
			routes.SetSetting("showFlightPaths", not routes.Settings().showFlightPaths)
			routes.RequestPlan()
		end),
	}
	if routes.IsInParty() then
		local on = settings.partyQuests
		entries[#entries + 1] = ToggleEntry(L["ROUTES_MENU_SHOWN_PARTY"], on, function()
			routes.SetPartyQuests(not routes.Settings().partyQuests)
		end)
		--[[
			Why a member's objectives aren't on the route, in gray: Offline; No Questie, for one sharing none;
			Out of Zone, left off until they're back. None has anything to click, and the switch keeps its
			place for when that changes
		]]
		for _, member in ipairs(on and routes.PartyMembers(true) or {}) do
			local included = routes.ignoredMembers[member.name] == nil
			local name = Colored(member.name, routes.ClassColor(member.unit))
			local left = INDENT .. string.format(L["ROUTES_MENU_MEMBER_OBJECTIVES"], name)
			local reason = member.offline and L["ROUTES_MENU_OFFLINE"]
				or not routes.MemberHasQuestie(member.name) and L["ROUTES_MENU_NO_QUESTIE"]
				or routes.IsUnitOutOfZone(member.unit) and L["ROUTES_MENU_OUT_OF_ZONE"]
				or nil
			if reason then
				entries[#entries + 1] = { kind = "status", left = left, right = reason, rightColor = "MUTED" }
			else
				entries[#entries + 1] = ToggleEntry(left, included, function()
					routes.SetMemberIgnored(member.name, included)
				end)
			end
		end
	end
	return entries, EntriesKey(entries)
end

-- Show's flyout: what only the arrow draws. Next Objective, the showNextObjective setting, as Options switches it
local function ShowEntries()
	local entries = {
		ToggleEntry(L["ROUTES_NEXT_OBJECTIVE"], routes.Settings().showNextObjective, function()
			routes.SetSetting("showNextObjective", not routes.Settings().showNextObjective)
		end),
	}
	return entries, EntriesKey(entries)
end

-- Ignored's flyout: the ignore list in gray, each brightening with Put Back under the mouse
local function IgnoredEntries()
	local entries = {}
	for _, entry in ipairs(routes.IgnoredTasks()) do
		entries[#entries + 1] = {
			kind = "action",
			left = entry.label,
			leftColor = "MUTED",
			hover = { right = L["ROUTES_MENU_PUT_BACK"], rightColor = "ON" },
			action = function()
				routes.UnignoreTask(entry.key)
			end,
		}
	end
	return entries, EntriesKey(entries)
end

-- Each flyout's rows, by the name its label carries, for the flyout to fill itself from (Routes-Arrow-Menu-Panel.lua)
panels.submenus = { route = RouteEntries, show = ShowEntries, ignored = IgnoredEntries }

--[[
	Rebuilds the menu's rows, and the open flyout's; it closes once its label is gone, as Ignored's does once
	nothing is ignored
]]
function routes.RefreshArrowMenu()
	if not menu:IsShown() then
		return
	end
	local open = submenu:IsShown() and submenu.name
	for _, row in pairs(menu.submenuRows or {}) do
		row:UnlockHighlight()
	end
	Fill(menu, Entries())
	local row = open and menu.submenuRows[open]
	if row then
		OpenSubmenu(row)
	else
		CloseSubmenu()
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
	if self:IsMouseOver() or routes.IsMouseOverArrow() or (submenu:IsShown() and submenu:IsMouseOver()) then
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
		menu.shownKey = nil
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
