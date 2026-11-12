local ADDON_NAME, ns = ...

--[[
	Routes: the plates the Quest Arrow's menu is drawn on (Routes-Arrow-Menu.lua), laid out as WIM's whisper
	list is: a dark plate with angled corners and a row for each line, and the flyout a label opens beside the
	menu, on a plate of its own. Each row is a kind the menu's rows name ("header", "section", "action" and
	the rest), laid out to its text; what the rows say, and opening and closing the menu, are the menu's
]]

local routes = ns.routes

local SPACE = ns.LAYOUT.SPACE

--[[
	The plate's art, drawn at half its size so the edges stay sharp: PLATE_SIZE pixels square, the plate
	itself PLATE_MARGIN in from each edge and the rest its shadow, each corner piece PLATE_CORNER across
]]
local PLATE_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Route-Menu"
local PLATE_SIZE = 128
local PLATE_MARGIN = { left = 12, right = 12, top = 10, bottom = 14 }
local PLATE_CORNER = 32
local PLATE_SCALE = 0.5

local MIN_WIDTH = 128
local ROW_INSET = SPACE.LINE -- From the plate's edge to a row's highlight
local TEXT_INSET = SPACE.NEAR -- From a row's edge to its text
local HIGHLIGHT_ALPHA = 0.16
local PLATE_ALPHA = 0.8 -- The plate's art is black: a little of the world shows through, so it reads lighter

--------------------------------------------------------------------------------
-- The plate
--------------------------------------------------------------------------------

-- Nine pieces: the corners at their own size, keeping the angle and shadow, the edges and middle stretched
local function AddPlate(panel)
	local plate = CreateFrame("Frame", nil, panel)
	plate:SetPoint("TOPLEFT", -PLATE_MARGIN.left * PLATE_SCALE, PLATE_MARGIN.top * PLATE_SCALE)
	plate:SetPoint("BOTTOMRIGHT", PLATE_MARGIN.right * PLATE_SCALE, -PLATE_MARGIN.bottom * PLATE_SCALE)
	plate:SetFrameLevel(panel:GetFrameLevel()) -- Under the rows
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

--[[
	A plate with rows on it: the menu, and the flyout its Route, Show or Ignored label opens beside it
	(submenu), drawn over the menu. Escape closes both
]]
local function NewPanel(name, level)
	local panel = CreateFrame("Frame", name, UIParent)
	panel:SetFrameStrata("DIALOG")
	if level then
		panel:SetFrameLevel(level)
	end
	panel:SetClampedToScreen(true)
	panel:EnableMouse(true)
	panel:Hide()
	panel.rows = {}
	AddPlate(panel)
	tinsert(UISpecialFrames, name)
	return panel
end

local menu = NewPanel("PrettyWideQuestLogRouteMenu")
local submenu = NewPanel("PrettyWideQuestLogRouteSubmenu", menu:GetFrameLevel() + 20)
menu:HookScript("OnHide", function()
	submenu:Hide()
end)

-- What the menu reads back: the two plates, filling one with rows, and the flyout's opening and closing
local panels = { menu = menu, submenu = submenu, submenus = {} }
routes.arrowMenuPanels = panels

--------------------------------------------------------------------------------
-- Laying it out
--------------------------------------------------------------------------------

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

local OpenSubmenu, CloseSubmenu -- Below, once the rows are laid out

local function Row(panel, index)
	local row = panel.rows[index]
	if not row then
		row = CreateFrame("Button", nil, panel)
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
			if self.submenu then
				OpenSubmenu(self)
			elseif self.action then
				self.action()
				routes.RefreshArrowMenu()
			end
		end)
		--[[
			On the menu, a flyout's label opens it and any other row closes it, as a dropdown's submenu does;
			the flyout's own rows leave it open
		]]
		row:SetScript("OnEnter", function(self)
			if self.hover then
				Dress(self, true)
			end
			if self.submenu then
				OpenSubmenu(self)
			elseif panel == menu then
				CloseSubmenu()
			end
		end)
		row:SetScript("OnLeave", function(self)
			if self.hover then
				Dress(self, false)
			end
		end)
		row:SetScript("OnDragStart", function(self)
			if self.drag then
				routes.DragArrowFromMenu()
			end
		end)
		panel.rows[index] = row
	end
	row:Show()
	return row
end

--[[
	Sizes the menu to its rows: each as tall as a line and SPACE.LINE above and below, a group's label
	SPACE.NEAR above instead to set its group apart, the separators SPACE.NEAR
]]
local function Layout(panel, entries)
	local width, y = MIN_WIDTH, SPACE.NEAR
	local rows = panel.rows
	panel.submenuRows = {}
	for index, entry in ipairs(entries) do
		local row = Row(panel, index)
		local kind = entry.kind
		local clickable = kind == "action" or kind == "toggle" or entry.submenu ~= nil or entry.action ~= nil
		row:EnableMouse(clickable or entry.drag)
		if entry.drag then
			row:RegisterForDrag("LeftButton")
		else
			row:RegisterForDrag()
		end
		row.drag = entry.drag
		row.line:SetShown(kind == "separator")
		row.hover = entry.hover
		row.submenu = entry.submenu
		if entry.submenu then
			panel.submenuRows[entry.submenu] = row
		end
		local height
		if kind == "separator" or kind == "spacer" then
			Paint(row.left, nil)
			Paint(row.right, nil)
			height = kind == "spacer" and SPACE.GROUP or SPACE.NEAR
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
		row:SetPoint("TOPLEFT", panel, "TOPLEFT", ROW_INSET, -y)
		row:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -ROW_INSET, -y)
		y = y + height
	end
	for index = #entries + 1, #rows do
		rows[index]:Hide()
	end
	panel:SetSize(math.ceil(width), y + SPACE.NEAR)
end

-- Lays a panel out again where what its rows say has changed; their actions always, as a new plan makes new tasks
local function Fill(panel, entries, key)
	if key ~= panel.shownKey then
		panel.shownKey = key
		Layout(panel, entries)
	end
	for index, entry in ipairs(entries) do
		panel.rows[index].action = entry.action
	end
end

--[[
	The flyout beside its label (Route, Show or Ignored), its first row level with the label: to the right of
	the menu, or to the left where the screen hasn't the room. The label keeps its highlight while it's open
]]
local function PlaceSubmenu(row)
	submenu:ClearAllPoints()
	local gap = ROW_INSET + SPACE.NEAR
	local right = menu:GetRight() or 0
	local scale = menu:GetEffectiveScale() / UIParent:GetEffectiveScale()
	if (right + gap + submenu:GetWidth()) * scale > UIParent:GetWidth() then
		submenu:SetPoint("TOPRIGHT", row, "TOPLEFT", -gap, SPACE.NEAR)
	else
		submenu:SetPoint("TOPLEFT", row, "TOPRIGHT", gap, SPACE.NEAR)
	end
end

function OpenSubmenu(row)
	local entries, key = panels.submenus[row.submenu]()
	if #entries == 0 then
		CloseSubmenu()
		return
	end
	if submenu.name ~= row.submenu then
		CloseSubmenu() -- Another label's: its highlight goes, and the rows are laid out afresh
	end
	if not submenu:IsShown() then
		submenu.shownKey = nil
	end
	submenu.name = row.submenu
	Fill(submenu, entries, key)
	PlaceSubmenu(row)
	submenu:Show()
	row:LockHighlight()
end

function CloseSubmenu()
	for _, row in pairs(menu.submenuRows or {}) do
		row:UnlockHighlight()
	end
	submenu.name = nil
	submenu:Hide()
end

panels.Fill, panels.OpenSubmenu, panels.CloseSubmenu = Fill, OpenSubmenu, CloseSubmenu
