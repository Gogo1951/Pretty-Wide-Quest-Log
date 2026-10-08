local ADDON_NAME, ns = ...
local L = ns.L
local LAYOUT = ns.LAYOUT

local ART_PATH_PREFIX = "Interface/AddOns/" .. ADDON_NAME .. "/Includes/Images/PWQL_"
local TOP_SPLIT = 0.5
local STRIP_SOURCE = 8 -- Pixels of the middle piece the widening strip is cut from

--[[
	Draws the window art on a frame and returns a function that lays it out for a given window height.
	Three columns of pieces, plus a strip widening the parchment where the middle and right pieces meet.
	The strip is cut from the last few pixels of the middle piece and stretched, so both of its seams
	continue the art on either side. The top half of each upper piece carries the window's top border
	and keeps its proportions; only the plain lower half is stretched when the window is dragged taller
]]
function ns.CreateWindowArt(frame, sublevel)
	local pieces = {}
	for _, column in ipairs({
		{ "Left", 3, 0, 256 },
		{ "Mid", 259, 0, 256 },
		{ "Mid", 515, 1 - STRIP_SOURCE / 256, LAYOUT.EXTRA_WIDTH },
		{ "Right", 515 + LAYOUT.EXTRA_WIDTH, 0, 256 },
	}) do
		local name, x, left, width = unpack(column)
		for _, row in ipairs({ "Top", "Bot" }) do
			local count = (row == "Top") and 2 or 1
			for piece = 1, count do
				local region = frame:CreateTexture(nil, "ARTWORK", nil, sublevel)
				region:SetTexture(ART_PATH_PREFIX .. row .. name)
				region:SetWidth(width)
				if count == 1 then
					region:SetTexCoord(left, 1, 0, 1)
				elseif piece == 1 then
					region:SetTexCoord(left, 1, 0, TOP_SPLIT)
				else
					region:SetTexCoord(left, 1, TOP_SPLIT, 1)
				end
				pieces[#pieces + 1] = { region = region, x = x, row = row, piece = piece }
			end
		end
	end

	return function(height)
		local extra = height - LAYOUT.BASE_HEIGHT
		for _, art in ipairs(pieces) do
			art.region:ClearAllPoints()
			if art.row == "Top" then
				if art.piece == 1 then
					art.region:SetHeight(256 * TOP_SPLIT)
					art.region:SetPoint("TOPLEFT", frame, "TOPLEFT", art.x, 0)
				else
					art.region:SetHeight(256 * (1 - TOP_SPLIT) + extra)
					art.region:SetPoint("TOPLEFT", frame, "TOPLEFT", art.x, -256 * TOP_SPLIT)
				end
			else
				art.region:SetHeight(256)
				art.region:SetPoint("TOPLEFT", frame, "TOPLEFT", art.x, -(height - 257))
			end
		end
	end
end

--[[
	Snaps a window height to whole list rows, between the default height and the bottom of the screen
	(the window grows downward from its top edge)
]]
function ns.ClampHeight(frame, height, rowHeight)
	local base = LAYOUT.BASE_HEIGHT
	height = base + math.floor((height - base) / rowHeight + 0.5) * rowHeight

	local top = frame:GetTop() or UIParent:GetHeight()
	local maximumHeight = math.max(base, top - LAYOUT.MINIMUM_BOTTOM_CLAMP)
	if height > maximumHeight then
		height = base + math.floor((maximumHeight - base) / rowHeight) * rowHeight
	end
	return math.max(height, base)
end

--[[
	A grip in the window's bottom-right corner for dragging it taller. applyHeight(height) resizes the
	window and getHeight() returns its height now; the height it's dragged to is saved when the drag ends
]]
function ns.CreateResizeGrip(frame, applyHeight, getHeight)
	local grip = CreateFrame("Button", nil, frame)
	grip:SetSize(16, 16)
	grip:SetFrameLevel(frame:GetFrameLevel() + 10)
	grip:SetPoint(
		"BOTTOMRIGHT",
		-(LAYOUT.ART_INSET_RIGHT + LAYOUT.GRIP_INSET),
		LAYOUT.ART_INSET_BOTTOM + LAYOUT.GRIP_INSET
	)
	grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

	grip:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(L["RESIZE_TOOLTIP"])
		GameTooltip:Show()
	end)
	grip:SetScript("OnLeave", GameTooltip_Hide)

	local startY, startHeight
	local function StopSizing(self)
		if not startY then
			return
		end
		startY = nil
		self:SetScript("OnUpdate", nil)
		ns.db.global.height = getHeight()
	end

	grip:SetScript("OnMouseDown", function(self)
		local _, y = GetCursorPosition()
		startY, startHeight = y / frame:GetEffectiveScale(), getHeight()
		self:SetScript("OnUpdate", function(this)
			if not IsMouseButtonDown("LeftButton") then
				StopSizing(this) -- The mouse-up went somewhere else
				return
			end
			local _, cursorY = GetCursorPosition()
			applyHeight(startHeight + (startY - cursorY / frame:GetEffectiveScale()))
		end)
	end)
	grip:SetScript("OnMouseUp", StopSizing)
	grip:SetScript("OnHide", StopSizing)

	return grip
end

--------------------------------------------------------------------------------
-- List Buttons
--------------------------------------------------------------------------------

local function CreateListButton(parent, labels)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(LAYOUT.BUTTON_WIDTH, LAYOUT.BUTTON_HEIGHT)
	button:SetText(labels[1])
	button.labels = labels
	return button
end

--[[
	Expand All / Collapse All and Track All / Untrack All, side by side above the quest list. The caller
	anchors the first and sets their clicks and labels. Both take one width, fitting the longest label
	in this locale, so neither changes size as its label switches. That's measured the first time they
	show, once the font is sure to be loaded
]]
function ns.CreateListButtons(parent)
	local expandButton = CreateListButton(parent, { L["EXPAND_ALL"], L["COLLAPSE_ALL"] })
	local trackButton = CreateListButton(parent, { L["TRACK_ALL"], L["UNTRACK_ALL"] })
	trackButton:SetPoint("LEFT", expandButton, "RIGHT")

	local buttons = { expandButton, trackButton }
	local fitted
	local function FitWidth()
		if fitted then
			return
		end
		fitted = true
		local width = LAYOUT.BUTTON_WIDTH
		for _, button in ipairs(buttons) do
			local current = button:GetText()
			for _, label in ipairs(button.labels) do
				button:SetText(label)
				width = math.max(width, button:GetTextWidth() + LAYOUT.LABEL_PADDING)
			end
			button:SetText(current)
		end
		for _, button in ipairs(buttons) do
			button:SetWidth(width)
		end
	end
	expandButton:HookScript("OnShow", FitWidth)
	trackButton:HookScript("OnShow", FitWidth)

	return expandButton, trackButton
end
