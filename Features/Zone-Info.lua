local ADDON_NAME, ns = ...

--[[
	Zone Info: a box under the docked map (Quest-Map.lua), the map at half the window's height above it,
	for the zone the map shows. Two columns, from Zone-Info-Data.lua, drawn as the quest list draws its own
	rows (Forever-Quest-List.lua): Quests to Pick Up, the quests the character could take now that work in
	the zone but start in another, under the zone each giver stands in; and Things to Bring, the tradeable
	items the zone's quests ask for, A to Z, with how many are in the bags against how many are needed.

	The map's zone dropdown (Questie-Map.lua) is the box's zone menu too: the quest's own zones, then where
	the player is, the zones of the quests in the log, the zones with the most quests to pick up, and every
	zone by continent. Picking one of those puts the map and the box there (questMap.browseMapID) until
	Back to Quest, or until another quest is picked in the log. With the box on, an empty quest log keeps
	the map, on the player's zone. Show Zone Info (showZoneInfo) in Window & Map turns it off, and the map
	goes back to two thirds of the window
]]

-- Here at load, so the events in Core.lua find their handlers; each does nothing until the box is built
local zoneInfo = {}
ns.zoneInfo = zoneInfo

ns.AddWideQuestLogPart(function()
	local L = ns.L
	local LAYOUT = ns.LAYOUT
	local SPACE = LAYOUT.SPACE
	local questMap = ns.questMap
	local holder = questMap.holder
	local data = ns.zoneInfoData

	-- The quest list's own sizes (Data.lua): a row, a zone name with room for its small button, the gap over a zone
	local ROW_HEIGHT = LAYOUT.QUEST_ROW_HEIGHT
	local TITLE_HEIGHT = LAYOUT.HEADER_ROW_HEIGHT
	local ICON_SIZE = 16 -- An item's icon and the tracking mark, in the list's check column
	--[[
		From the border or the divider to what each column shows, the same on every side: the icons and the
		titles at the left, the tags and counts at the right, the titles at the top. Rows already keep the
		check column's CHECK_X at their left and ROW_PADDING at their right, so the columns sit in by the rest
	]]
	local MARGIN = SPACE.GROUP
	local QUEST_SHARE = 2 / 3 -- Of the box's width, for Quests to Pick Up; Things to Bring takes the rest
	local ITEM_EXTRA = SPACE.GROUP -- And this much more to Things to Bring, so an item's name and count fit
	local LEFT_IN = MARGIN - LAYOUT.CHECK_X
	local RIGHT_IN = MARGIN - LAYOUT.ROW_PADDING
	local TOP_IN = MARGIN - SPACE.LINE -- A title's text sits about this far down its row
	local MENU_SCROLL_HEIGHT = 512 -- A continent's list of zones scrolls past this
	local AVAILABLE_ZONES_LISTED = 8
	local REFRESH_DELAY = 1 -- Seconds after the quest log or the bags change, so a burst of events works it out once
	local AVAILABLE_DELAY = 3 -- After a level or a new profession, once Questie has worked out its available quests again
	local STARTING_DELAY = 2 -- Between asks while Questie is still starting up after login
	local LFG_CHANNEL = 4 -- Ask for Shares writes here, where players look for groups, when the character is in it

	local ROW_HIGHLIGHT = "Interface\\QuestFrame\\UI-QuestLogTitleHighlight"
	local PLUS_TEXTURE = "Interface\\Buttons\\UI-PlusButton-Up" -- A zone heading's collapse button, as the list's
	local MINUS_TEXTURE = "Interface\\Buttons\\UI-MinusButton-Up"
	local PARTY_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Party-On-Quest"
	local SOLID_TEXTURE = "Interface\\Buttons\\WHITE8X8"

	local current = { mapID = nil, result = nil } -- The zone the box shows and its lists, once worked out
	local collapsed = {} -- Giver zones whose quests are folded away under their heading, by name, for the session

	--------------------------------------------------------------------------------
	-- The Box
	--------------------------------------------------------------------------------

	--[[
		In the map's own border, under it and as wide; the map's child, so Map Scale and Hide Map take it too.
		Solid where the map's backing is see-through, as the map's art always covers it and nothing covers this
	]]
	local box = CreateFrame("Frame", nil, holder, "BackdropTemplate")
	local backdrop = CopyTable(holder.backdropInfo)
	backdrop.bgFile = SOLID_TEXTURE
	box:SetBackdrop(backdrop)
	box:SetBackdropColor(0, 0, 0, 1)
	box:EnableMouse(true)
	box:SetPoint("TOPLEFT", holder, "BOTTOMLEFT")
	box:SetPoint("TOPRIGHT", holder, "BOTTOMRIGHT")
	box:Hide()
	questMap.zoneInfoBox = box -- For a skin that draws the map its own way (Classic-ElvUI.lua)
	local inset = backdrop.insets.left

	-- The window's height under the map's top, less the map's
	local function FitHeight()
		box:SetHeight(math.max(1, questMap.SharedHeight() - holder:GetHeight()))
	end
	holder:HookScript("OnSizeChanged", FitHeight)

	local content = CreateFrame("Frame", nil, box)
	content:SetPoint("TOPLEFT", inset, -inset)
	content:SetPoint("BOTTOMRIGHT", -inset, inset)

	--------------------------------------------------------------------------------
	-- Columns
	--------------------------------------------------------------------------------

	local divider = content:CreateTexture(nil, "ARTWORK")
	divider:SetColorTexture(ns.GetColorRGB("SEPARATOR"))
	divider:SetAlpha(0.25)
	divider:SetWidth(1)
	-- Two thirds across, as tall as the columns: quests with their tags want the room, items and counts less
	local function PlaceDivider(width)
		local x = math.floor(width * QUEST_SHARE + 0.5) - ITEM_EXTRA
		divider:ClearAllPoints()
		divider:SetPoint("TOP", content, "TOPLEFT", x, -TOP_IN)
		divider:SetPoint("BOTTOM", content, "BOTTOMLEFT", x, MARGIN)
	end
	PlaceDivider(content:GetWidth())
	content:SetScript("OnSizeChanged", function(_, width)
		PlaceDivider(width)
	end)

	--[[
		A column: its title on a row as tall as the list's zone names, then a heading's gap, then a scroll frame
		with a slim bar in its right margin, and a message for when it's empty
	]]
	local function Column(side)
		local column = CreateFrame("Frame", nil, content)
		column:SetPoint("TOP", 0, -TOP_IN)
		column:SetPoint("BOTTOM", 0, MARGIN)
		if side == "LEFT" then
			column:SetPoint("LEFT", LEFT_IN, 0)
			column:SetPoint("RIGHT", divider, "LEFT", -RIGHT_IN, 0)
		else
			column:SetPoint("LEFT", divider, "RIGHT", LEFT_IN, 0)
			column:SetPoint("RIGHT", -RIGHT_IN, 0)
		end

		column.title = column:CreateFontString(nil, "OVERLAY")
		column.title:SetFontObject(ns.AreaFont("list", "GameFontNormal"))
		column.title:SetPoint("TOPLEFT", LAYOUT.CHECK_X, 0)
		column.title:SetPoint("RIGHT", -LAYOUT.ROW_PADDING, 0)
		column.title:SetHeight(TITLE_HEIGHT)
		column.title:SetJustifyH("LEFT")
		column.title:SetWordWrap(false)

		local scroll = CreateFrame("ScrollFrame", nil, column)
		scroll:SetPoint("TOPLEFT", 0, -(TITLE_HEIGHT + SPACE.NEAR))
		scroll:SetPoint("BOTTOMRIGHT")
		-- Centered in the margin past the rows, so a long list scrolls without its rows moving over for the bar
		local bar = CreateFrame("EventFrame", nil, column, "MinimalScrollBar")
		bar:SetPoint("TOP", scroll, "TOPRIGHT", RIGHT_IN / 2, 0)
		bar:SetPoint("BOTTOM", scroll, "BOTTOMRIGHT", RIGHT_IN / 2, 0)
		if bar.SetHideIfUnscrollable then
			bar:SetHideIfUnscrollable(true)
		end
		ScrollUtil.InitScrollFrameWithScrollBar(scroll, bar)

		local child = CreateFrame("Frame", nil, scroll)
		child:SetSize(1, 1)
		scroll:SetScrollChild(child)
		scroll:HookScript("OnSizeChanged", function(self, width)
			child:SetWidth(width)
		end)
		column.scroll, column.child, column.rows = scroll, child, {}

		-- As the quest list says it has no quests
		column.empty = column:CreateFontString(nil, "OVERLAY")
		column.empty:SetFontObject(ns.AreaFont("list", "GameFontHighlight"))
		column.empty:SetPoint("TOPLEFT", scroll, "TOPLEFT", LAYOUT.QUEST_TEXT_X, -LAYOUT.ROW_PADDING)
		column.empty:SetPoint("RIGHT", scroll, "RIGHT", -LAYOUT.ROW_PADDING, 0)
		column.empty:SetJustifyH("LEFT")
		return column
	end

	local questColumn = Column("LEFT")
	local itemColumn = Column("RIGHT")

	-- Ask for Shares: the quest list's Share Quests button (Zone-Share.lua), on the Quests to Pick Up title
	local askButton = CreateFrame("Button", nil, questColumn, "UIPanelButtonTemplate")
	askButton:SetHeight(LAYOUT.ZONE_SHARE_BUTTON_HEIGHT)
	askButton:SetNormalFontObject(ns.AreaFont("list", "GameFontNormalSmall"))
	askButton:SetHighlightFontObject(ns.AreaFont("list", "GameFontHighlightSmall"))
	askButton:SetDisabledFontObject(ns.AreaFont("list", "GameFontDisableSmall"))
	askButton:SetMotionScriptsWhileDisabled(true)
	askButton:SetText(L["ZONE_INFO_ASK"])
	askButton:SetPoint("RIGHT", questColumn, "TOPRIGHT", -LAYOUT.ROW_PADDING, -TITLE_HEIGHT / 2)
	questColumn.title:SetPoint("RIGHT", askButton, "LEFT", -SPACE.LINE, 0)
	questMap.zoneInfoAskButton = askButton -- Skinned by Classic-ElvUI.lua

	content:HookScript("OnShow", function()
		askButton:SetWidth(askButton:GetTextWidth() + LAYOUT.ZONE_SHARE_BUTTON_PADDING)
	end)

	--------------------------------------------------------------------------------
	-- Rows, as the quest list's
	--------------------------------------------------------------------------------

	-- A quest's colors at its level, plain and under the mouse, as the quest list colors its rows
	local function QuestColors(level)
		local color, highlight = GetQuestDifficultyColor(level)
		if not highlight and QuestDifficultyHighlightColors then
			for key, value in pairs(QuestDifficultyColors) do
				if value == color then
					highlight = QuestDifficultyHighlightColors[key]
					break
				end
			end
		end
		return color, highlight or color
	end

	local function ItemColor(itemID)
		local _, _, quality = data.GetItemInfo(itemID)
		if quality and C_Item and C_Item.GetItemQualityColor then
			return C_Item.GetItemQualityColor(quality)
		elseif quality and GetItemQualityColor then
			return GetItemQualityColor(quality)
		end
		return ns.GetColorRGB("TEXT")
	end

	local function ColorRow(row, hovered)
		local r, g, b, hr, hg, hb
		if row.kind == "header" then
			local color = QuestDifficultyColors.header
			local highlight = QuestDifficultyHighlightColors and QuestDifficultyHighlightColors.header or color
			r, g, b, hr, hg, hb = color.r, color.g, color.b, highlight.r, highlight.g, highlight.b
		elseif row.kind == "quest" then
			local color, highlight = QuestColors(row.quest.level)
			r, g, b, hr, hg, hb = color.r, color.g, color.b, highlight.r, highlight.g, highlight.b
		else
			r, g, b = ItemColor(row.item.itemID)
			hr, hg, hb = r, g, b
		end
		if hovered then
			row.Text:SetTextColor(hr, hg, hb)
		else
			row.Text:SetTextColor(r, g, b)
		end
		-- Whether it can be shared, by color rather than the quest's: white if it can, gray if not
		if row.kind == "quest" then
			row.Tag:SetTextColor(ns.GetColorRGB(row.quest.shareable and "TEXT" or "MUTED"))
		end
		row.Highlight:SetVertexColor(r, g, b)
	end

	local Row_OnEnter, Row_OnLeave, Row_OnClick -- Below, with the tooltips
	local DrawQuests -- Below, with the lists

	local function NewRow(column)
		local row = CreateFrame("Button", nil, column.child)
		row:SetHeight(ROW_HEIGHT)

		row.Icon = row:CreateTexture(nil, "ARTWORK")
		row.Icon:SetSize(ICON_SIZE, ICON_SIZE)
		row.Icon:SetPoint("LEFT", LAYOUT.CHECK_X, 0) -- The quest list's check column

		row.Text = row:CreateFontString(nil, "ARTWORK")
		row.Text:SetFontObject(ns.AreaFont("list", "GameFontNormal"))
		row.Text:SetJustifyH("LEFT")
		row.Text:SetWordWrap(false)

		row.Tag = row:CreateFontString(nil, "ARTWORK")
		row.Tag:SetFontObject(ns.AreaFont("list", "GameFontNormal"))
		row.Tag:SetPoint("RIGHT", -LAYOUT.ROW_PADDING, 0)
		row.Tag:SetJustifyH("RIGHT")

		-- How many party members have the quest: the list's group icon and the count, just left of the tag
		row.PartyCount = row:CreateFontString(nil, "ARTWORK")
		row.PartyCount:SetFontObject(ns.AreaFont("list", "GameFontHighlight"))
		row.PartyCount:SetJustifyH("RIGHT")
		row.PartyCount:SetTextColor(ns.GetColorRGB("INFO"))
		row.PartyIcon = row:CreateTexture(nil, "ARTWORK")
		row.PartyIcon:SetTexture(PARTY_TEXTURE)
		row.PartyIcon:SetVertexColor(ns.GetColorRGB("INFO"))
		row.PartyIcon:SetSize(ICON_SIZE, ICON_SIZE)
		row.PartyIcon:SetPoint("RIGHT", row.PartyCount, "LEFT", -SPACE.TIGHT, 0)

		row.Highlight = row:CreateTexture(nil, "HIGHLIGHT")
		row.Highlight:SetTexture(ROW_HIGHLIGHT)
		row.Highlight:SetBlendMode("ADD")
		row.Highlight:SetAllPoints()

		row:SetScript("OnEnter", Row_OnEnter)
		row:SetScript("OnLeave", Row_OnLeave)
		row:SetScript("OnClick", Row_OnClick)
		return row
	end

	-- The column's row at index, set at y and cleared of what it showed last
	local function PlaceRow(column, index, y, height)
		local row = column.rows[index]
		if not row then
			row = NewRow(column)
			column.rows[index] = row
		end
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", 0, -y)
		row:SetPoint("TOPRIGHT", 0, -y)
		row:SetHeight(height)
		row.kind, row.quest, row.item, row.zone = nil, nil, nil, nil
		row.Icon:Hide()
		row.Tag:SetText(nil)
		row.PartyCount:SetText(nil)
		row.PartyIcon:Hide()
		row:Show()
		return row
	end

	local function FinishColumn(column, count, height)
		for index = count + 1, #column.rows do
			column.rows[index]:Hide()
		end
		column.child:SetHeight(math.max(1, height))
	end

	-- The name runs up to whatever sits at the row's right: the party count, the tag, or the edge
	local function FitText(row, textX)
		row.Text:ClearAllPoints()
		row.Text:SetPoint("LEFT", textX, 0)
		if row.PartyIcon:IsShown() then
			row.Text:SetPoint("RIGHT", row.PartyIcon, "LEFT", -SPACE.LINE, 0)
		elseif row.Tag:GetText() then
			row.Text:SetPoint("RIGHT", row.Tag, "LEFT", -SPACE.LINE, 0)
		else
			row.Text:SetPoint("RIGHT", -LAYOUT.ROW_PADDING, 0)
		end
	end

	local function PartyCount(questID)
		return ns.routes and ns.routes.PartyCountOnQuest and ns.routes.PartyCountOnQuest(questID) or 0
	end

	local function CanRoute()
		return ns.routes and ns.routes.IsWanted() or false
	end

	-- The route's mark in the check column: the quest list's tracking check
	local function ShowRouteMark(row)
		local mark = ns.TRACKING_MARKS.tracked
		row.Icon:SetTexture(mark.texture)
		row.Icon:SetVertexColor(ns.HexToRGB(mark.color))
		row.Icon:SetShown(data.IsWanted(row.quest.questID))
	end

	-- A giver's zone, its +/- in the check column as the list's zone names have, folding its quests away
	local function SetHeaderRow(row, zoneName)
		row.kind, row.zone = "header", zoneName
		row:EnableMouse(true)
		row.Icon:SetTexture(collapsed[zoneName] and PLUS_TEXTURE or MINUS_TEXTURE)
		row.Icon:SetVertexColor(1, 1, 1)
		row.Icon:Show()
		row.Text:SetText(zoneName)
		FitText(row, LAYOUT.HEADER_TEXT_X)
		ColorRow(row, row:IsMouseOver())
	end

	local function SetQuestRow(row, quest)
		row.kind, row.quest = "quest", quest
		row:EnableMouse(true)
		local tagID, isElite = ns.GetQuestTagByID(quest.questID)
		row.Text:SetText(ns.QuestListTitle(quest.level, quest.name, ns.QuestSuffix(tagID, isElite)))
		row.Tag:SetText(L[quest.shareable and "ZONE_INFO_SHAREABLE" or "ZONE_INFO_NOT_SHAREABLE"])
		local onQuest = PartyCount(quest.questID)
		if onQuest > 0 then
			row.PartyCount:ClearAllPoints()
			if row.Tag:GetText() then
				row.PartyCount:SetPoint("RIGHT", row.Tag, "LEFT", -SPACE.LINE, 0)
			else
				row.PartyCount:SetPoint("RIGHT", -LAYOUT.ROW_PADDING, 0)
			end
			row.PartyCount:SetText(onQuest)
			row.PartyIcon:Show()
		end
		ShowRouteMark(row)
		FitText(row, LAYOUT.QUEST_TEXT_X)
		ColorRow(row, row:IsMouseOver())
	end

	-- The count at the right, as an objective's: green once there are enough in the bags
	local function SetItemCount(row)
		local item = row.item
		local have = data.ItemCount(item.itemID)
		row.Tag:SetText(("%d / %d"):format(have, item.need))
		if have >= item.need then
			row.Tag:SetTextColor(ns.GetColorRGB("ON"))
		else
			row.Tag:SetTextColor(ns.GetColorRGB("TEXT"))
		end
	end

	local function SetItemRow(row, item)
		row.kind, row.item = "item", item
		row:EnableMouse(true)
		row.Icon:SetTexture(data.ItemIcon(item.itemID) or 134400) -- The question mark, until the icon loads
		row.Icon:SetVertexColor(1, 1, 1)
		row.Icon:Show()
		local name = data.GetItemInfo(item.itemID)
		row.Text:SetText(name or item.name)
		SetItemCount(row)
		FitText(row, LAYOUT.QUEST_TEXT_X)
		ColorRow(row, row:IsMouseOver())
	end

	--------------------------------------------------------------------------------
	-- Tooltips
	--------------------------------------------------------------------------------

	local function AddClickHints(tooltip, hints)
		if ns.routes and ns.routes.AddClickHints then
			ns.routes.AddClickHints(tooltip, hints)
		end
	end

	-- A line that wraps at the tooltip's width; GetColorRGB's three values only all pass as the last argument
	local function AddWrappedLine(text, colorKey)
		local r, g, b = ns.GetColorRGB(colorKey)
		GameTooltip:AddLine(text, r, g, b, true)
	end

	-- Where the giver stands: "47,58 in Mulgore", or the zone alone when Questie has no spot on the zone's map
	local function PlaceLine(quest)
		if quest.giverZone and quest.giverX and quest.giverY then
			local spot = ("%d,%d"):format(math.floor(quest.giverX + 0.5), math.floor(quest.giverY + 0.5))
			return L["ZONE_INFO_GIVER_PLACE"]:format(spot, quest.giverZone)
		end
		return quest.giverZone
	end

	--[[
		The quest as the list names it, who gives it, where they stand, then the click, a blank line between
		each; the row itself shows who can share it
	]]
	local function ShowQuestTooltip(row)
		local quest = row.quest
		GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
		local tagID, isElite = ns.GetQuestTagByID(quest.questID)
		GameTooltip:AddLine(
			ns.QuestListTitle(quest.level, quest.name, ns.QuestSuffix(tagID, isElite)),
			ns.GetColorRGB("TITLE")
		)
		if quest.giver then
			GameTooltip:AddLine(" ")
			AddWrappedLine(L["ZONE_INFO_GIVER"]:format(quest.giver), "TEXT")
		end
		local place = PlaceLine(quest)
		if place then
			GameTooltip:AddLine(" ")
			AddWrappedLine(place, "TEXT")
		end
		if CanRoute() then -- The click hints put their own blank line above
			local wanted = data.IsWanted(quest.questID)
			AddClickHints(GameTooltip, {
				{ L["ROUTES_CLICK"], wanted and L["ZONE_INFO_UNTRACK"] or L["ZONE_INFO_TRACK"] },
			})
		end
		GameTooltip:Show()
	end

	-- A heading of the add-on's own under the game's item lines, as other add-ons mark theirs: "PWQL // Needed for ..."
	local function AddOnHeading(text)
		GameTooltip:AddLine(
			ns.GetColor("INFO")
				.. L["ADDON_SHORT_NAME"]
				.. "|r "
				.. ns.GetColor("SEPARATOR")
				.. "//|r "
				.. ns.GetColor("TEXT")
				.. text
				.. "|r",
			nil,
			nil,
			nil,
			true
		)
	end

	-- The item, then the quests here that want it, listed under the heading as the list names them: "[6] Name"
	local function ShowItemTooltip(row)
		local item = row.item
		GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(item.itemID)
		GameTooltip:AddLine(" ")
		AddOnHeading(L["ZONE_INFO_NEEDED_FOR"])
		for _, quest in ipairs(item.quests) do
			local tagID, isElite = ns.GetQuestTagByID(quest.questID)
			local title = ns.QuestListTitle(quest.level, quest.name, ns.QuestSuffix(tagID, isElite))
			GameTooltip:AddLine(" " .. title, ns.GetColorRGB("TEXT"))
		end
		AddClickHints(GameTooltip, { { L["ZONE_INFO_SHIFT_CLICK"], L["ZONE_INFO_LINK_ITEM"] } })
		GameTooltip:Show()
	end

	function Row_OnEnter(row)
		ColorRow(row, true)
		if row.kind == "quest" then
			ShowQuestTooltip(row)
		elseif row.kind == "item" then
			ShowItemTooltip(row)
		end
	end

	function Row_OnLeave(row)
		if row.kind then
			ColorRow(row, false)
		end
		if GameTooltip:IsOwned(row) then
			GameTooltip:Hide()
		end
	end

	--[[
		A zone's row folds its quests away or opens them; a quest's puts its giver on the route or takes it off;
		an item's links it with Shift-Click
	]]
	function Row_OnClick(row)
		if row.kind == "header" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			collapsed[row.zone] = not collapsed[row.zone] or nil
			DrawQuests(current.result)
		elseif row.kind == "quest" then
			if not CanRoute() then
				return
			end
			local questID = row.quest.questID
			data.SetWanted(questID, not data.IsWanted(questID))
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			ShowRouteMark(row)
			ShowQuestTooltip(row)
		elseif row.kind == "item" and IsModifiedClick("CHATLINK") then
			local _, link = data.GetItemInfo(row.item.itemID)
			local insert = ChatFrameUtil and ChatFrameUtil.InsertLink or ChatEdit_InsertLink
			if link and insert then
				insert(link)
			end
		end
	end

	--------------------------------------------------------------------------------
	-- Drawing the lists
	--------------------------------------------------------------------------------

	local function SetTitle(column, label, count)
		column.title:SetText(label .. ns.GetColor("TEXT") .. " (" .. count .. ")|r")
	end

	-- The quests under the zone each giver stands in, as the quest list puts its quests under their zones
	function DrawQuests(result)
		local quests = result and result.quests or {}
		local index, y, lastZone, first = 0, 0, nil, true
		for _, quest in ipairs(quests) do
			local zone = quest.giverZone or UNKNOWN
			if first or zone ~= lastZone then
				if not first then
					y = y + LAYOUT.HEADER_GAP
				end
				index = index + 1
				SetHeaderRow(PlaceRow(questColumn, index, y, TITLE_HEIGHT), zone)
				y = y + TITLE_HEIGHT
				lastZone, first = zone, false
			end
			if not collapsed[zone] then
				index = index + 1
				SetQuestRow(PlaceRow(questColumn, index, y, ROW_HEIGHT), quest)
				y = y + ROW_HEIGHT
			end
		end
		FinishColumn(questColumn, index, y)
		SetTitle(questColumn, L["ZONE_INFO_QUESTS"], #quests)
	end

	-- The counts alone, as the bags change
	local function DrawCounts()
		for _, row in ipairs(itemColumn.rows) do
			if row:IsShown() and row.kind == "item" then
				SetItemCount(row)
			end
		end
	end

	local function DrawItems(result)
		local items = result and result.items or {}
		for index, item in ipairs(items) do
			SetItemRow(PlaceRow(itemColumn, index, (index - 1) * ROW_HEIGHT, ROW_HEIGHT), item)
		end
		FinishColumn(itemColumn, #items, #items * ROW_HEIGHT)
		SetTitle(itemColumn, L["ZONE_INFO_ITEMS"], #items)
	end

	local function SetMessage(column, message)
		column.empty:SetText(message or "")
		column.empty:SetShown(message ~= nil)
	end

	local function Draw()
		local result = current.result
		if not result or result.mapID ~= current.mapID then
			DrawQuests(nil)
			DrawItems(nil)
			local message = current.mapID and L["ZONE_INFO_WORKING"] or nil
			SetMessage(questColumn, message)
			SetMessage(itemColumn, message)
			askButton:Disable()
			return
		end
		if result.unavailable then
			-- Questie still starting up reads as working out the lists, which ask again until it's done
			local starting = Questie ~= nil
			DrawQuests(nil)
			DrawItems(nil)
			SetMessage(questColumn, starting and L["ZONE_INFO_WORKING"] or L["ZONE_INFO_NEEDS_QUESTIE"])
			SetMessage(itemColumn, starting and L["ZONE_INFO_WORKING"] or nil)
			askButton:Disable()
			return
		end
		DrawQuests(result)
		DrawItems(result)
		SetMessage(questColumn, #result.quests == 0 and L["ZONE_INFO_NO_QUESTS"] or nil)
		SetMessage(itemColumn, #result.items == 0 and L["ZONE_INFO_NO_ITEMS"] or nil)
		askButton:SetEnabled(result.shareable > 0)
	end

	--------------------------------------------------------------------------------
	-- Working the lists out
	--------------------------------------------------------------------------------

	local dirty = true -- The lists want working out again, next time the box shows
	local RequestRefresh -- Below

	local function Refresh()
		if not box:IsVisible() then
			dirty = true
			return
		end
		dirty = false
		local mapID = current.mapID
		if not mapID then
			Draw()
			return
		end
		data.PruneWanted()
		if not (current.result and current.result.mapID == mapID) then
			current.result = nil
			Draw() -- "Reading quests..." until they're done, only for a zone not shown yet
		end
		data.Request(mapID, function(result)
			if result.mapID == current.mapID then
				current.result = result
				Draw()
				-- Opened before Questie finished starting up: ask again, rather than wait for a quest to change
				if result.unavailable and Questie ~= nil then
					RequestRefresh(STARTING_DELAY)
				end
			end
		end)
	end

	local refreshPending
	function RequestRefresh(delay)
		if refreshPending then
			return
		end
		refreshPending = true
		C_Timer.After(delay or REFRESH_DELAY, function()
			refreshPending = nil
			Refresh()
		end)
	end

	local function SetZone(mapID)
		mapID = data.ZoneOf(mapID) or mapID
		if mapID == current.mapID then
			return
		end
		current.mapID = mapID
		Refresh()
	end

	-- Each zone the map is put on (Questie-Map.lua)
	questMap.onZoneShown = function(mapID)
		SetZone(mapID)
	end

	box:SetScript("OnShow", function()
		FitHeight()
		if not current.mapID then
			SetZone(questMap.ShownZone and questMap.ShownZone() or data.PlayerZone())
		end
		if dirty or (current.result and current.result.unavailable) then
			Refresh()
		end
	end)

	--------------------------------------------------------------------------------
	-- Looking at another zone
	--------------------------------------------------------------------------------

	-- One of the quest's own zones is no look elsewhere: the map's dropdown just moves to it (Questie-Map.lua)
	local function Browse(mapID)
		if questMap.PickQuestZone and questMap.PickQuestZone(mapID) then
			return
		end
		questMap.browseMapID = mapID
		questMap.FollowQuest() -- Puts the map on it (Questie-Map.lua), which tells SetZone
		SetZone(mapID)
	end

	-- Back to the selected quest's zone. Called from Questie-Map.lua as another quest is picked, so it only clears
	function questMap.EndBrowse()
		questMap.browseMapID = nil
	end

	-- Zone Info's groups in the map's zone dropdown, under the quest's own zones (Questie-Map.lua)
	function questMap.AddZoneInfoMenu(root)
		local function IsShown(mapID)
			return mapID == current.mapID
		end
		local function Radio(parent, mapID, label)
			parent:CreateRadio(label or data.ZoneName(mapID) or tostring(mapID), IsShown, Browse, mapID)
		end

		local playerZone = data.PlayerZone()
		if playerZone then
			root:CreateTitle(L["ZONE_INFO_MENU_HERE"])
			Radio(root, playerZone)
		end
		local logZones = data.LogZones()
		if #logZones > 0 then
			root:CreateTitle(L["ZONE_INFO_MENU_LOG"])
			for _, mapID in ipairs(logZones) do
				Radio(root, mapID)
			end
		end
		local availableZones, counts = data.AvailableZones(AVAILABLE_ZONES_LISTED)
		if #availableZones > 0 then
			root:CreateTitle(L["ZONE_INFO_MENU_AVAILABLE"])
			for _, mapID in ipairs(availableZones) do
				local name = data.ZoneName(mapID) or tostring(mapID)
				Radio(root, mapID, name .. ns.GetColor("MUTED") .. " (" .. counts[mapID] .. ")|r")
			end
		end
		root:CreateDivider()
		for _, continent in ipairs(data.Continents()) do
			local submenu = root:CreateButton(continent.name)
			if submenu.SetScrollMode then
				submenu:SetScrollMode(MENU_SCROLL_HEIGHT)
			end
			for _, zone in ipairs(continent.zones) do
				Radio(submenu, zone.mapID, zone.name)
			end
		end
	end

	--------------------------------------------------------------------------------
	-- Ask for Shares
	--------------------------------------------------------------------------------

	-- "/4 " while the character is in the LFG channel, which the chat box reads as a switch to it; else nothing
	local function ChannelPrefix()
		local channel = GetChannelName and GetChannelName(LFG_CHANNEL)
		if channel and channel > 0 then
			return "/" .. LFG_CHANNEL .. " "
		end
		return ""
	end

	--[[
		Each quest as the announcements name one (Announcements.lua): Questie's quest link, then Questie's
		bracketed text, then its title in brackets; the first that still fits the chat limit. Stops at the first
		quest none of them fits for, so the message is never cut short mid-name
	]]
	local function AskMessage(quests, room)
		local references = {}
		local function Message(list)
			return L["ZONE_INFO_ASK_MESSAGE"]:format(table.concat(list, ", "))
		end
		for _, quest in ipairs(quests) do
			if quest.shareable and PartyCount(quest.questID) == 0 then
				local choices = ns.QuestReferences and ns.QuestReferences(quest.questID) or {}
				choices[#choices + 1] = "[" .. quest.name .. "]"
				local fitted
				for _, reference in ipairs(choices) do
					references[#references + 1] = reference
					if #Message(references) <= room then
						fitted = true
						break
					end
					references[#references] = nil
				end
				if not fitted then
					break
				end
			end
		end
		return #references > 0 and Message(references) or nil
	end

	--[[
		Writes the shareable quests into the chat box on the LFG channel, never sending it: the player edits
		it, or picks another channel, and presses Enter themselves
	]]
	askButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		local result = current.result
		local openChat = ChatFrameUtil and ChatFrameUtil.OpenChat or ChatFrame_OpenChat
		if not (result and result.quests and openChat) then
			return
		end
		local prefix = ChannelPrefix()
		local message = AskMessage(result.quests, ns.CHAT_MESSAGE_MAX_LENGTH - #prefix)
		if message then
			openChat(prefix .. message)
		end
	end)

	-- As Share Quests says what it does
	askButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_AddNormalLine(GameTooltip, L["ZONE_INFO_ASK_DESCRIPTION"], true)
		GameTooltip:Show()
	end)
	askButton:SetScript("OnLeave", GameTooltip_Hide)

	--------------------------------------------------------------------------------
	-- Turning it on and off
	--------------------------------------------------------------------------------

	function zoneInfo.Apply()
		local shown = ns.db.profile.showZoneInfo ~= false
		questMap.SetZoneInfoShown(shown)
		box:SetShown(shown)
		if not shown and questMap.browseMapID then
			questMap.EndBrowse()
			questMap.FollowQuest()
		end
	end

	--------------------------------------------------------------------------------
	-- Events (Core.lua)
	--------------------------------------------------------------------------------

	zoneInfo.built = true
	zoneInfo.RequestRefresh = RequestRefresh
	zoneInfo.RequestAvailableRefresh = function()
		RequestRefresh(AVAILABLE_DELAY)
	end
	zoneInfo.DrawCounts = DrawCounts
	zoneInfo.Redraw = function()
		if box:IsVisible() and current.result then
			Draw()
		end
	end
	-- Turned on once the saved settings load (Core.lua): on WoW Forever and Mists this runs before they have
end)

-- The bags changed: the counts alone
function zoneInfo:OnBagUpdateDelayed()
	if self.built then
		self.DrawCounts()
	end
end

-- A quest taken, dropped or handed in changes what's available and what follows
function zoneInfo:OnQuestAccepted()
	if self.built then
		self.RequestRefresh()
	end
end
zoneInfo.OnQuestRemoved = zoneInfo.OnQuestAccepted
zoneInfo.OnQuestTurnedIn = zoneInfo.OnQuestAccepted

-- A new level or profession: once Questie has worked out its available quests again
function zoneInfo:OnPlayerLevelUp()
	if self.built then
		self.RequestAvailableRefresh()
	end
end
zoneInfo.OnSkillLinesChanged = zoneInfo.OnPlayerLevelUp

-- An item the lists asked the game for has loaded: whether it can be traded, its name and icon. Other
-- add-ons' items arrive here too, and set off nothing
function zoneInfo:OnGetItemInfoReceived(itemID, success)
	if ns.zoneInfoData.ItemArrived(itemID, success) and self.built then
		self.RequestRefresh()
	end
end

-- Who in the party has which quest, for the party count
function zoneInfo:OnGroupRosterUpdate()
	if self.built then
		self.Redraw()
	end
end
zoneInfo.OnUnitQuestLogChanged = zoneInfo.OnGroupRosterUpdate
