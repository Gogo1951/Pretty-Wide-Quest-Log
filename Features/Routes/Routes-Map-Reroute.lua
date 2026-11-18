local _, ns = ...

--[[
	Routes: the world map's Rerouting bar. Clicks on the map's markers are planned only once they've stopped
	for a few seconds (routes.HoldPlanForMapClick, Routes-Planner.lua); while that plan runs, "Rerouting…" and
	a bar that sweeps back and forth sit at the bottom middle of the map, on the map menu's plate. Planning
	has no share done to show, so the bar only says it's working. It goes once the new route is drawn, or
	with the map. It takes no mouse, so it's never in the way of a marker
]]

local routes = ns.routes
local L = ns.L

local SPACE = ns.LAYOUT.SPACE
local panels = routes.arrowMenuPanels

local WHITE = "Interface\\Buttons\\WHITE8X8"
local BAR_WIDTH = 256
local BAR_HEIGHT = SPACE.NEAR
local SWEEP_WIDTH = 64 -- The part that moves along the bar
local SWEEP_SECONDS = 1 -- Seconds to cross the bar one way
local TRACK_ALPHA = 0.5 -- The bar under the sweep

local bar

local function Build()
	bar = CreateFrame("Frame", "PrettyWideQuestLogRouteRerouting", UIParent)
	bar:SetFrameStrata("FULLSCREEN_DIALOG") -- Over the world map, as its menu is
	bar:EnableMouse(false)
	bar:Hide()
	panels.AddPlate(bar)

	-- Over the plate, which takes the bar's own frame level
	local content = CreateFrame("Frame", nil, bar)
	content:SetAllPoints()
	content:SetFrameLevel(bar:GetFrameLevel() + 1)

	local label = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	label:SetPoint("TOP", 0, -SPACE.GROUP)
	label:SetTextColor(ns.GetColorRGB("TITLE"))
	bar.label = label

	local track = content:CreateTexture(nil, "ARTWORK")
	track:SetTexture(WHITE)
	track:SetVertexColor(ns.GetColorRGB("MUTED"))
	track:SetAlpha(TRACK_ALPHA)
	track:SetSize(BAR_WIDTH, BAR_HEIGHT)
	track:SetPoint("TOP", label, "BOTTOM", 0, -SPACE.GROUP)
	bar.track = track

	local sweep = content:CreateTexture(nil, "ARTWORK", nil, 1)
	sweep:SetTexture(WHITE)
	sweep:SetVertexColor(ns.GetColorRGB("INFO"))
	sweep:SetSize(SWEEP_WIDTH, BAR_HEIGHT)
	bar.sweep = sweep

	bar:SetScript("OnUpdate", function(self)
		local map = WorldMapFrame
		if not (map and map:IsVisible() and routes.IsRerouting()) then
			self:Hide()
			return
		end
		-- There and back, SWEEP_SECONDS each way
		local share = (GetTime() % (2 * SWEEP_SECONDS)) / SWEEP_SECONDS
		if share > 1 then
			share = 2 - share
		end
		self.sweep:ClearAllPoints()
		self.sweep:SetPoint("LEFT", self.track, "LEFT", share * (BAR_WIDTH - SWEEP_WIDTH), 0)
	end)
end

-- The plan a map click asked for has started (Routes-Planner.lua): the bar shows while it runs, on the open map
function routes.ShowRerouting()
	local map = WorldMapFrame
	if not (map and map:IsVisible()) then
		return
	end
	if not bar then
		Build()
	end
	bar.label:SetText(L["ROUTES_REROUTING"])
	local labelHeight = bar.label:GetStringHeight()
	bar:SetSize(
		math.max(BAR_WIDTH, bar.label:GetStringWidth()) + 2 * SPACE.GROUP,
		SPACE.GROUP + labelHeight + SPACE.GROUP + BAR_HEIGHT + SPACE.GROUP
	)
	bar:ClearAllPoints()
	bar:SetPoint("BOTTOM", map.ScrollContainer or map, "BOTTOM", 0, SPACE.SECTION)
	bar:Show()
end
