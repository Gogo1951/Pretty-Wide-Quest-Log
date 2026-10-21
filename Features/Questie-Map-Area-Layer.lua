local _, ns = ...

--[[
	Every client: the layer the objective areas Questie-Map-Areas.lua works out are drawn on, under
	Questie's icons on the map
]]

ns.AddWideQuestLogPart(function()
	local questMap = ns.questMap

	local AREA_PIN_TEMPLATE = "PrettyWideQuestLogAreaPinTemplate"
	local FILL_ALPHA = 0.3
	local OUTLINE_ALPHA = 0.75
	local OUTLINE_WIDTH = 1.5 -- On screen, whatever the zoom
	local FALLBACK_COLOR = { ns.GetColorRGB("TITLE") }
	local WHITE_TEXTURE = "Interface\\Buttons\\WHITE8X8"

	-- A texture's corners, as SetVertexOffset numbers them
	local UPPER_LEFT, LOWER_LEFT, UPPER_RIGHT, LOWER_RIGHT = 1, 2, 3, 4

	--------------------------------------------------------------------------------
	-- Map layer
	--------------------------------------------------------------------------------

	--[[
		One pin as large as the map, under Questie's icons, that the areas are drawn on. It zooms with the
		map, so only the outlines' width needs keeping up with the zoom
	]]
	local areaPinMixin = {}

	function areaPinMixin:OutlineWidth()
		return OUTLINE_WIDTH / self:GetMap():GetCanvasScale()
	end

	function areaPinMixin:OnCanvasScaleChanged()
		local width = self:OutlineWidth()
		for i = 1, self.linesUsed do
			self.lines[i]:SetThickness(width)
		end
	end

	-- One triangle of an area's fill: a texture with its four corners moved onto the triangle's three
	function areaPinMixin:AddTriangle(color, ax, ay, bx, by, cx, cy)
		self.fillsUsed = self.fillsUsed + 1
		local texture = self.fills[self.fillsUsed]
		if not texture then
			texture = self:CreateTexture(nil, "ARTWORK")
			texture:SetTexture(WHITE_TEXTURE)
			self.fills[self.fillsUsed] = texture
		end

		-- Counterclockwise, as the texture's own upper-left, lower-left and upper-right corners run
		if (bx - ax) * (cy - ay) - (by - ay) * (cx - ax) < 0 then
			bx, by, cx, cy = cx, cy, bx, by
		end
		local left, right = math.min(ax, bx, cx), math.max(ax, bx, cx)
		local bottom, top = math.min(ay, by, cy), math.max(ay, by, cy)
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", self, "TOPLEFT", left, top)
		texture:SetSize(right - left, top - bottom)
		texture:SetVertexOffset(UPPER_LEFT, ax - left, ay - top)
		texture:SetVertexOffset(LOWER_LEFT, bx - left, by - bottom)
		texture:SetVertexOffset(UPPER_RIGHT, cx - right, cy - top)
		texture:SetVertexOffset(LOWER_RIGHT, cx - right, cy - bottom)
		texture:SetVertexColor(color[1], color[2], color[3], FILL_ALPHA)
		texture:Show()
	end

	function areaPinMixin:AddLine(color, width, ax, ay, bx, by)
		self.linesUsed = self.linesUsed + 1
		local line = self.lines[self.linesUsed]
		if not line then
			line = self:CreateLine(nil, "OVERLAY")
			line:SetTexture(WHITE_TEXTURE)
			self.lines[self.linesUsed] = line
		end
		line:SetStartPoint("TOPLEFT", self, ax, ay)
		line:SetEndPoint("TOPLEFT", self, bx, by)
		line:SetThickness(width)
		line:SetVertexColor(color[1], color[2], color[3], OUTLINE_ALPHA)
		line:Show()
	end

	-- Each area's fill as a fan of triangles from its middle, then its outline over it
	function areaPinMixin:Draw(shapes)
		local mapWidth, mapHeight = self:GetSize()
		local outlineWidth = self:OutlineWidth()
		self.fillsUsed, self.linesUsed = 0, 0
		for _, shape in ipairs(shapes) do
			local color, outline = shape.color or FALLBACK_COLOR, shape.outline
			local middleX, middleY = shape.x * mapWidth, -shape.y * mapHeight
			for i = 1, #outline do
				local a, b = outline[i], outline[i % #outline + 1]
				local ax, ay, bx, by = a.x * mapWidth, -a.y * mapHeight, b.x * mapWidth, -b.y * mapHeight
				self:AddTriangle(color, middleX, middleY, ax, ay, bx, by)
				self:AddLine(color, outlineWidth, ax, ay, bx, by)
			end
		end
		for i = self.fillsUsed + 1, #self.fills do
			self.fills[i]:Hide()
		end
		for i = self.linesUsed + 1, #self.lines do
			self.lines[i]:Hide()
		end
	end

	--[[
		Draws the areas on the map, each { color, x, y, outline }: color the objective's, if Questie gave it
		one, x and y its middle and outline its corners (0-1)
	]]
	function questMap.DrawObjectiveAreas(map, shapes)
		if #shapes == 0 then
			return
		end
		local pin = map:AcquirePin(AREA_PIN_TEMPLATE)
		if not pin.fills then
			Mixin(pin, areaPinMixin)
			pin.fills, pin.lines = {}, {}
		end
		pin:UseFrameLevelType("PIN_FRAME_LEVEL_QUEST_BLOB")
		pin:ApplyFrameLevel()
		pin:SetSize(map:GetCanvas():GetSize())
		pin:SetPosition(0.5, 0.5)
		pin:Draw(shapes)
	end

	function questMap.RemoveObjectiveAreas(map)
		map:RemoveAllPinsByTemplate(AREA_PIN_TEMPLATE)
	end
end)
