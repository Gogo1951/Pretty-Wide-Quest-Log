local ADDON_NAME, ns = ...

--[[
	Routes: the Quest Arrow's shade on hover. The arrow is Routes-Arrow.lua's frame, its list laid out by
	Routes-Arrow-List.lua and its item buttons by Routes-Arrow-Items.lua
]]

local routes = ns.routes

local SPACE = ns.LAYOUT.SPACE

local frame = routes.arrowFrame
local WIDTH = routes.ARROW_LAYOUT.WIDTH

--[[
	A soft dark wash behind the arrow, its list and its item buttons while the mouse is on them or their
	menu, so the text reads over bright ground, gone again when the mouse leaves. No box or edge: easing
	out from the edges of what it covers to nothing SHADE_FADE past them, the same on every side, with
	round corners. Nine pieces of one soft round texture: its quarters at the corners, a strip through its
	middle along each side, and its solid middle stretched over the rest
]]
local SHADE_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Shade"
local SHADE_ALPHA = 0.4 -- How dark the middle gets
local SHADE_FADE_SECONDS = 0.15 -- To come in or go
local SHADE_FADE = 2 * SPACE.SECTION -- From the edges of what it covers out to nothing: 64, on the doubling scale
-- The arrow's art sits inside its square: the eye 10 below its top, the arrow pointing ahead 6
local ART_TOP = SPACE.NEAR

-- Each piece: which column and row of the 3 x 3, and the part of the texture it shows
local SHADE_PIECES = {
	{ 1, 1, 0, 0.5, 0, 0.5 },
	{ 2, 1, 0.5, 0.5, 0, 0.5 },
	{ 3, 1, 0.5, 1, 0, 0.5 },
	{ 1, 2, 0, 0.5, 0.5, 0.5 },
	{ 2, 2, 0.5, 0.5, 0.5, 0.5 },
	{ 3, 2, 0.5, 1, 0.5, 0.5 },
	{ 1, 3, 0, 0.5, 0.5, 1 },
	{ 2, 3, 0.5, 0.5, 0.5, 1 },
	{ 3, 3, 0.5, 1, 0.5, 1 },
}

local shade = {}
for i, piece in ipairs(SHADE_PIECES) do
	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetTexture(SHADE_TEXTURE)
	texture:SetTexCoord(piece[3], piece[4], piece[5], piece[6])
	texture:SetVertexColor(0, 0, 0)
	texture:SetAlpha(0)
	texture.column, texture.row = piece[1], piece[2]
	shade[i] = texture
end

local shadeAlpha, shadeLeft, shadeRight, shadeBottom = 0, nil, nil, nil

--[[
	Round what shows, in the arrow's units from its top left: the list (centered, frame.hitInset in from
	each side), the arrow's art above it, and the item buttons to its left
]]
local function PlaceShade()
	local inset = frame.hitInset or 0
	local left, right = inset, WIDTH - inset
	local top, bottom = ART_TOP, frame:GetHeight()
	-- Called in full: "routes.ArrowItemBounds and routes.ArrowItemBounds()" would keep only its first value
	local itemLeft, itemBottom = routes.ArrowItemBounds()
	if itemLeft then
		left = math.min(left, itemLeft)
		bottom = math.max(bottom, itemBottom)
	end
	if left == shadeLeft and right == shadeRight and bottom == shadeBottom then
		return
	end
	shadeLeft, shadeRight, shadeBottom = left, right, bottom
	-- Where each column and row starts and ends: the fade, the solid middle, the fade
	local xs = { left - SHADE_FADE, left, right, right + SHADE_FADE }
	local ys = { top - SHADE_FADE, top, bottom, bottom + SHADE_FADE }
	for _, texture in ipairs(shade) do
		local column, row = texture.column, texture.row
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", frame, "TOPLEFT", xs[column], -ys[row])
		texture:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT", xs[column + 1], -ys[row + 1])
	end
end

local function SetShadeAlpha(alpha)
	shadeAlpha = alpha
	for _, texture in ipairs(shade) do
		texture:SetAlpha(alpha * SHADE_ALPHA)
	end
end

frame:HookScript("OnUpdate", function(_, elapsed)
	local over = routes.IsMouseOverArrow() or (routes.IsArrowMenuShown and routes.IsArrowMenuShown())
	local target = over and 1 or 0
	if shadeAlpha == 0 and target == 0 then
		return
	end
	-- The list and buttons change as the player works, so the shade follows them while showing
	PlaceShade()
	if shadeAlpha ~= target then
		local step = elapsed / SHADE_FADE_SECONDS
		SetShadeAlpha(
			target > shadeAlpha and math.min(target, shadeAlpha + step) or math.max(target, shadeAlpha - step)
		)
	end
end)
frame:HookScript("OnHide", function()
	SetShadeAlpha(0)
end)
