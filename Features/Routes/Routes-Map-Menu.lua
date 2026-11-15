local _, ns = ...

--[[
	Routes: the world map's menu, on the Quest Arrow menu's plate (Routes-Arrow-Menu-Panel.lua), in place of a
	marker's tooltip so its clicks are rows a controller's cursor reaches too. Hovering a waypoint's or camp's
	marker, or the "…" marker, opens it beside the marker (Routes-Map.lua): what the tooltip said, then a
	spacer, a line and the marker's click hints, what each does on the left in blue and the click that does
	the same on the marker on the right in gray, each a row to click. It stays while the mouse is on the marker
	or the menu, closes CLOSE_DELAY after it leaves both, once the marker is gone or a row is clicked, and on
	Escape
]]

local routes = ns.routes

local SPACE = ns.LAYOUT.SPACE
local panels = routes.arrowMenuPanels

local CLOSE_DELAY = 0.25 -- Seconds the menu stays once the mouse leaves it and its marker
local REFRESH_INTERVAL = 0.5 -- Seconds between checks for its rows changing, as progress counts up

-- Over the world map, whichever strata it's drawn in
local menu = panels.NewPanel("PrettyWideQuestLogRouteMapMenu", nil, "FULLSCREEN_DIALOG")
menu.OnAction = function()
	menu:Hide()
end

local owner, subject, Build, OnClose
local lastOver, sinceRefresh = 0, 0

--------------------------------------------------------------------------------
-- Rows, written as a tooltip's lines
--------------------------------------------------------------------------------

local function Color(red, green, blue)
	return red and { red, green, blue } or nil
end

--[[
	Takes a tooltip's AddLine and AddDoubleLine, so a stop's tooltip lines (routes.AddStopTooltip) become the
	menu's rows: a blank line a spacer, a line with no color gold, as a tooltip's is
]]
local rowsMixin = {}

function rowsMixin:NumLines()
	return #self.entries
end

function rowsMixin:Add(entry)
	self.entries[#self.entries + 1] = entry
end

function rowsMixin:AddLine(text, red, green, blue, wrap)
	if text == " " then
		self:Add({ kind = "spacer" })
		return
	end
	self:Add({ kind = "status", left = text, leftColor = Color(red, green, blue) or "TITLE", wrap = wrap or nil })
end

function rowsMixin:AddDoubleLine(left, right, red, green, blue, rightRed, rightGreen, rightBlue)
	self:Add({
		kind = "status",
		left = left,
		leftColor = Color(red, green, blue) or "TITLE",
		right = right,
		rightColor = Color(rightRed, rightGreen, rightBlue) or "TEXT",
	})
end

-- A group's small gold label, a spacer above it unless it opens the menu
function rowsMixin:AddSection(text)
	if #self.entries > 0 then
		self:Add({ kind = "spacer" })
	end
	self:Add({ kind = "section", left = text })
end

--[[
	The footer: a spacer and a line, then each hint, { click, what it does, action }, as a row: what it does
	on the left in blue, the click on the right in gray
]]
function rowsMixin:AddHints(hints)
	if #self.entries > 0 then
		self:Add({ kind = "spacer" })
	end
	self:Add({ kind = "separator" })
	for _, hint in ipairs(hints) do
		self:Add({ kind = "hint", left = hint[2], right = hint[1], rightColor = "MUTED", action = hint[3] })
	end
end

function routes.MapMenuRows()
	return Mixin({ entries = {} }, rowsMixin)
end

--------------------------------------------------------------------------------
-- Opening and closing
--------------------------------------------------------------------------------

-- Fills the menu from its builder; one that returns nothing, its marker handed to something else, closes it
local function Refresh()
	local entries = Build and Build()
	if not entries or #entries == 0 then
		menu:Hide()
		return false
	end
	panels.Fill(menu, entries, panels.EntriesKey(entries))
	return true
end

-- Beside the marker, as a tooltip anchored to its right is; to its left where the screen hasn't the room
local function Place()
	menu:ClearAllPoints()
	local right = owner:GetRight() or 0
	local scale = owner:GetEffectiveScale() / menu:GetEffectiveScale()
	if right * scale + SPACE.LINE + menu:GetWidth() > UIParent:GetWidth() then
		menu:SetPoint("TOPRIGHT", owner, "TOPLEFT", -SPACE.LINE, 0)
	else
		menu:SetPoint("TOPLEFT", owner, "TOPRIGHT", SPACE.LINE, 0)
	end
end

menu:SetScript("OnUpdate", function(self, elapsed)
	if not (owner and owner:IsVisible() and owner:IsMouseEnabled()) then
		self:Hide()
		return
	end
	local now = GetTime()
	if self:IsMouseOver() or owner:IsMouseOver() then
		lastOver = now
	elseif now - lastOver > CLOSE_DELAY then
		self:Hide()
		return
	end
	sinceRefresh = sinceRefresh + elapsed
	if sinceRefresh >= REFRESH_INTERVAL then
		sinceRefresh = 0
		Refresh()
	end
end)

menu:HookScript("OnHide", function()
	local close = OnClose
	owner, subject, Build, OnClose = nil, nil, nil, nil
	if close then
		close()
	end
end)

--[[
	Opens the menu beside a marker: build returns its rows, or nothing once the marker shows something else;
	onClose runs as it closes. The same marker for the same thing, hovered again, keeps the menu as it is.
	Returns whether it opened
]]
function routes.OpenMapMenu(pin, what, build, onClose)
	if menu:IsShown() and owner == pin and subject == what then
		lastOver = GetTime()
		return false
	end
	menu:Hide() -- Another marker's: it closes first, its onClose with it
	owner, subject, Build, OnClose = pin, what, build, onClose
	menu.shownKey = nil
	if not Refresh() then
		owner, subject, Build, OnClose = nil, nil, nil, nil -- Never shown, so no OnHide to forget them
		return false
	end
	Place()
	lastOver, sinceRefresh = GetTime(), 0
	menu:Show()
	return true
end

function routes.CloseMapMenu()
	menu:Hide()
end
