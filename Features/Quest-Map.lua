local _, ns = ...
local L = ns.L
local LAYOUT = ns.LAYOUT

--[[
	A map docked to the right of the quest log, showing the selected quest's zone. It's Blizzard's map
	canvas with a handful of the world map's data providers, as the Battlefield Map does it, so nothing of
	the world map itself is touched. Each client's own file adds the layers and defines
	ns.questMap.FollowQuest, which puts the map on the selected quest
]]

local window = ns.questLogFrame
local canvas = PrettyWideQuestLogMapFrame

local questMap = { canvas = canvas }
ns.questMap = questMap

local MAP_ASPECT = 1002 / 668 -- Width over height of Blizzard's map art
local HEIGHT_SHARE = 0.66 -- Of the visible window's height, from its top

--[[
	Where the map sits: its left edge against the window art's right edge and its top level with the art's
	top border, measured in game. A skin that draws the window its own way restyles it (questMap.SetStyle)
]]
local style = {
	edge = window, -- The region whose right edge, top and bottom the offsets below are measured from
	x = -34,
	top = -9,
	bottom = 45,
	inset = 11, -- Edge of the map's border to the map inside it
}

--------------------------------------------------------------------------------
-- Frame
--------------------------------------------------------------------------------

local holder = CreateFrame("Frame", nil, window, "BackdropTemplate")
holder:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 32,
	insets = { left = style.inset, right = style.inset, top = style.inset, bottom = style.inset },
})
holder:EnableMouse(true)
questMap.holder = holder

canvas:SetParent(holder)
canvas:SetFrameLevel(holder:GetFrameLevel() + 1)

-- Same proportions as Blizzard's map art, HEIGHT_SHARE as tall as the visible window
local function LayOut()
	holder:ClearAllPoints()
	holder:SetPoint("TOPLEFT", style.edge, "TOPRIGHT", style.x, style.top)
	local height = (style.edge:GetHeight() + style.top - style.bottom) * HEIGHT_SHARE
	local mapHeight = height - 2 * style.inset
	holder:SetSize(mapHeight * MAP_ASPECT + 2 * style.inset, height)

	canvas:ClearAllPoints()
	canvas:SetPoint("TOPLEFT", style.inset, -style.inset)
	canvas:SetPoint("BOTTOMRIGHT", -style.inset, style.inset)
end
window:HookScript("OnSizeChanged", LayOut)

function questMap.SetStyle(changes)
	for key, value in pairs(changes) do
		style[key] = value
	end
	LayOut()
end

-- The map art is fitted to the scroll frame's size once the new size has taken, not when it's asked for
canvas.ScrollContainer:HookScript("OnSizeChanged", function()
	canvas:OnFrameSizeChanged()
end)

function questMap.ShowMap(mapID)
	if not mapID then
		return
	end
	canvas:SetMapID(mapID)
end

-- A map is needed before the canvas first draws, as the Battlefield Map does it
canvas:SetScript("OnShow", function(self)
	questMap.FollowQuest()
	MapCanvasMixin.OnShow(self)
end)

--------------------------------------------------------------------------------
-- Showing and hiding
--------------------------------------------------------------------------------

-- Show Map / Hide Map, centred in the gap between Abandon Quest and Share Quest
local gap = CreateFrame("Frame", nil, window)
gap:SetPoint("TOPLEFT", ns.abandonButton, "TOPRIGHT")
gap:SetPoint("BOTTOMRIGHT", ns.shareButton, "BOTTOMLEFT")

local toggleButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
toggleButton:SetSize(LAYOUT.BUTTON_WIDTH, LAYOUT.BUTTON_HEIGHT)
toggleButton:SetPoint("CENTER", gap)
questMap.toggleButton = toggleButton

-- Wide enough for the longer of its two labels, once the font is ready
local fitted
toggleButton:HookScript("OnShow", function(self)
	if fitted then
		return
	end
	fitted = true
	local current, width = self:GetText(), LAYOUT.BUTTON_WIDTH
	for _, label in ipairs({ SHOW_MAP, L["HIDE_MAP"] }) do
		self:SetText(label)
		width = math.max(width, self:GetTextWidth() + LAYOUT.LABEL_PADDING)
	end
	self:SetText(current)
	self:SetWidth(width)
end)

-- On the map itself, in its top-right corner
local closeButton = CreateFrame("Button", nil, holder, "UIPanelCloseButtonNoScripts")
closeButton:SetPoint("TOPRIGHT", canvas, "TOPRIGHT")
closeButton:SetFrameLevel(canvas:GetFrameLevel() + 10)
questMap.closeButton = closeButton

-- Remembered across sessions; shown unless it was closed
local function ApplyShown()
	local shown = not ns.db.global.mapHidden
	holder:SetShown(shown)
	toggleButton:SetText(shown and L["HIDE_MAP"] or SHOW_MAP)
end

local function SetShown(shown)
	ns.db.global.mapHidden = (not shown) or nil
	PlaySound(shown and SOUNDKIT.IG_QUEST_LOG_OPEN or SOUNDKIT.IG_QUEST_LOG_CLOSE)
	ApplyShown()
end

toggleButton:SetScript("OnClick", function()
	SetShown(not holder:IsShown())
end)
closeButton:SetScript("OnClick", function()
	SetShown(false)
end)
window:HookScript("OnShow", ApplyShown)

canvas:Show() -- The template starts hidden; from here it shows and hides with the holder
LayOut()
