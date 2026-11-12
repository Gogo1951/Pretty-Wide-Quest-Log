local ADDON_NAME, ns = ...
local L = ns.L

local LAYOUT = ns.LAYOUT
local PANE_TOP = LAYOUT.PANE_TOP
local frame = ns.questLogFrame
local state = ns.questLog

--------------------------------------------------------------------------------
-- Quest list (left pane)
--------------------------------------------------------------------------------

local listBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
listBox:SetPoint("TOPLEFT", LAYOUT.LIST_LEFT, -PANE_TOP)
listBox:SetWidth(LAYOUT.LIST_WIDTH)

local listBar = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")
listBar:SetPoint("TOPLEFT", listBox, "TOPRIGHT", 8, -4)
listBar:SetPoint("BOTTOMLEFT", listBox, "BOTTOMRIGHT", 8, 4)

local noQuestsText = frame:CreateFontString(nil, "OVERLAY")
noQuestsText:SetFontObject(ns.AreaFont("list", "GameFontHighlight"))
noQuestsText:SetPoint("TOP", listBox, "TOP", 0, -90)
noQuestsText:SetText(QUESTLOG_NO_QUESTS_TEXT)
noQuestsText:Hide()

local PLUS_TEXTURE = "Interface\\Buttons\\UI-PlusButton-Up"
local MINUS_TEXTURE = "Interface\\Buttons\\UI-MinusButton-Up"
local TITLE_HIGHLIGHT = "Interface\\QuestFrame\\UI-QuestLogTitleHighlight"
local PARTY_TEXTURE = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Includes\\Images\\Party-On-Quest"
local SPACE = LAYOUT.SPACE
local CountPartyOnQuest, ShowPartyOnQuest = ns.CountPartyOnQuest, ns.ShowPartyOnQuest -- Forever-Quest-List-Party.lua

local function ToggleHeader(questLogIndex)
	local entry = ns.GetQuestLogEntry(questLogIndex)
	if not entry then
		return
	end
	ns.SetQuestZoneCollapsed(questLogIndex, not entry.isCollapsed)
	ns.RequestUpdate()
end

-- Every zone starts the session open; collapsing one only lasts until the next login or reload
function ns.ExpandAllZones()
	ns.ShowEveryQuestLogEntry()
	for index = ns.GetNumQuestLogEntries(), 1, -1 do
		local entry = ns.GetQuestLogEntry(index)
		if entry and entry.isHeader and entry.isCollapsed then
			ns.SetQuestZoneCollapsed(index, false)
		end
	end
end

-- The tag at the right of a quest's row: (Failed), (Complete), or its type
local function GetQuestTag(data)
	if data.isFailed then
		return FAILED
	elseif data.isComplete then
		return COMPLETE
	end
	local _, isElite, tagName = ns.GetQuestTagByID(data.questID)
	if tagName then
		return tagName
	elseif isElite then
		return ELITE
	end
end

--[[
	The color the game's own quest log gives a quest: how hard the server rates it for the player, which
	can differ from what the quest's level alone suggests. Falls back to the level, which also grays out a
	quest disabled for the session, when the server gives no rating
]]
local function GetQuestColor(data)
	local difficulty = not ns.IsQuestDisabledForSession(data.questID)
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer
		and C_PlayerInfo.GetContentDifficultyQuestForPlayer(data.questID)
	if difficulty and GetDifficultyColor then
		return GetDifficultyColor(difficulty)
	end
	return GetQuestDifficultyColor(data.difficultyLevel or data.level, data.isScaling, data.questID)
end

local function ColorRow(row, highlighted)
	local data = row.data
	if (not data) or data.isSpacer then
		return
	end
	local color, highlight
	if data.isHeader then
		color, highlight = QuestDifficultyColors.header, QuestDifficultyHighlightColors.header
	else
		color, highlight = GetQuestColor(data)
	end
	local text = (highlighted or (data.questID and data.questID == state.selectedQuestID)) and highlight or color
	row.Text:SetTextColor(text.r, text.g, text.b)
	row.Tag:SetTextColor(text.r, text.g, text.b)
	row.Highlight:SetVertexColor(color.r, color.g, color.b)
	row.Selected:SetVertexColor(color.r, color.g, color.b)
end

local function OpenQuestMenu(row)
	local questID = row.data.questID
	MenuUtil.CreateContextMenu(row, function(_, root)
		-- The same rules as the Track, Share and Abandon buttons (ns.QuestActions)
		local actions = ns.QuestActions(questID)
		root:CreateButton(actions.tracked and UNTRACK_QUEST or TRACK_QUEST, function()
			ns.ToggleTracking(questID)
		end):SetEnabled(actions.canTrack)
		root:CreateButton(SHARE_QUEST, function()
			ns.ShareQuest(questID)
		end):SetEnabled(actions.canShare)
		if ns.CanAbandonQuest(questID) then
			root:CreateButton(ABANDON_QUEST, function()
				ns.AskToAbandonQuest(questID)
			end):SetEnabled(actions.canAbandon)
		end
	end)
end

local function Row_OnClick(self, button)
	local data = self.data
	if (not data) or data.isSpacer then
		return
	end

	if data.isHeader then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		ToggleHeader(data.questLogIndex)
	elseif ChatFrameUtil.TryInsertQuestLinkForQuestID(data.questID) then
		return -- Shift-click with a chat box open links the quest
	elseif IsShiftKeyDown() then
		ns.ToggleTracking(data.questID) -- Otherwise it toggles tracking, as in Classic
	elseif button == "RightButton" then
		OpenQuestMenu(self)
	else
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
		ns.ShowQuest(data.questID)
	end
end

--[[
	A zone name shows its Share Quests button on hover (Zone-Share.lua); a quest lists the party
	members who have it
]]
local function Row_OnEnter(self)
	ColorRow(self, true)
	local data = self.data
	if data and data.isHeader then
		ns.ShowZoneShareButton(self, data.title)
	elseif data and data.questID then
		ShowPartyOnQuest(self, data.questID, data.questLogIndex)
	end
end

local function Row_OnLeave(self)
	ColorRow(self, false)
	ns.HideZoneShareButton(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

local function SetupRow(row)
	row:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	row.Icon = row:CreateTexture(nil, "ARTWORK")
	row.Icon:SetSize(16, 16)
	row.Icon:SetPoint("LEFT", LAYOUT.CHECK_X, 0) -- The +/- in the tracking mark's column

	-- In the quest list's copies of the fonts (Fonts.lua)
	row.Text = row:CreateFontString(nil, "ARTWORK")
	row.Text:SetFontObject(ns.AreaFont("list", "GameFontNormal"))
	row.Text:SetJustifyH("LEFT")
	row.Text:SetWordWrap(false)

	row.Tag = row:CreateFontString(nil, "ARTWORK")
	row.Tag:SetFontObject(ns.AreaFont("list", "GameFontNormal"))
	row.Tag:SetPoint("RIGHT", -2, 0)
	row.Tag:SetJustifyH("RIGHT")

	-- How many party members have the quest: a group icon and the count, just left of the tag
	row.PartyCount = row:CreateFontString(nil, "ARTWORK")
	row.PartyCount:SetFontObject(ns.AreaFont("list", "GameFontHighlight"))
	row.PartyCount:SetJustifyH("RIGHT")
	row.PartyCount:SetTextColor(ns.GetColorRGB("INFO"))
	row.PartyIcon = row:CreateTexture(nil, "ARTWORK")
	row.PartyIcon:SetTexture(PARTY_TEXTURE)
	row.PartyIcon:SetVertexColor(ns.GetColorRGB("INFO"))
	row.PartyIcon:SetSize(16, 16)
	row.PartyIcon:SetPoint("RIGHT", row.PartyCount, "LEFT", -SPACE.TIGHT, 0)

	row.Check = row:CreateTexture(nil, "ARTWORK")
	row.Check:SetSize(16, 16)
	row.Check:SetPoint("LEFT", LAYOUT.CHECK_X, 0)

	row.Selected = row:CreateTexture(nil, "BACKGROUND")
	row.Selected:SetTexture(TITLE_HIGHLIGHT)
	row.Selected:SetBlendMode("ADD")
	row.Selected:SetAllPoints()

	row.Highlight = row:CreateTexture(nil, "HIGHLIGHT")
	row.Highlight:SetTexture(TITLE_HIGHLIGHT)
	row.Highlight:SetBlendMode("ADD")
	row.Highlight:SetAllPoints()

	row:SetScript("OnClick", Row_OnClick)
	row:SetScript("OnEnter", Row_OnEnter)
	row:SetScript("OnLeave", Row_OnLeave)
end

--[[
	Rows are recycled between zone headers, quests and the blank spacers above headers, so each one is
	set up from scratch for whatever it's showing now
]]
local function InitRow(row, data)
	if not row.Text then
		SetupRow(row)
	end
	row.data = data
	ns.UpdateZoneShareButton(row, data.isHeader and data.title)

	row.Text:SetWidth(0)
	row.Tag:SetText(nil)
	row.PartyCount:SetText(nil)
	row.PartyIcon:Hide()
	row.Check:Hide()
	ns.HideVoiceOverButton(row)
	row:EnableMouse(not data.isSpacer)

	if data.isSpacer then
		row.Icon:Hide()
		row.Text:SetText(nil)
		row.Selected:Hide()
		return
	end

	if data.isHeader then
		row.Text:SetPoint("LEFT", LAYOUT.HEADER_TEXT_X, 0)
		row.Icon:SetTexture(data.isCollapsed and PLUS_TEXTURE or MINUS_TEXTURE)
		row.Icon:Show()
		row.Text:SetText(ns.ZoneHeaderText(data.title))
		row.Selected:Hide()
	else
		local questID = data.questID
		local tagID, elite = ns.GetQuestTagByID(questID)
		local textX = LAYOUT.QUEST_TEXT_X + ns.ShowVoiceOverButton(row, questID)
		row.Text:SetPoint("LEFT", textX, 0)
		row.Icon:Hide()
		row.Text:SetText(
			ns.QuestListTitle(data.difficultyLevel or data.level, data.title, ns.QuestSuffix(tagID, elite))
		)

		local tag = GetQuestTag(data)
		if tag then
			row.Tag:SetText(PARENS_TEMPLATE:format(tag))
		end

		local used = tag and (row.Tag:GetStringWidth() + 6) or 2
		local onQuest = CountPartyOnQuest(questID, data.questLogIndex)
		if onQuest > 0 then
			row.PartyCount:ClearAllPoints()
			if tag then
				row.PartyCount:SetPoint("RIGHT", row.Tag, "LEFT", -SPACE.LINE, 0)
			else
				row.PartyCount:SetPoint("RIGHT", -2, 0)
			end
			row.PartyCount:SetText(onQuest)
			row.PartyIcon:Show()
			used = used + row.PartyCount:GetStringWidth() + SPACE.TIGHT + 16 + SPACE.LINE
		end

		-- Shorten the title if it would run into the party count or the tag
		local room = LAYOUT.LIST_WIDTH - textX - used
		if row.Text:GetStringWidth() > room then
			row.Text:SetWidth(room)
		end
		ns.ShowTrackingMark(row.Check, ns.IsTracked(questID, data.questLogIndex))
		row.Selected:SetShown(questID == state.selectedQuestID)
	end

	ColorRow(row, row:IsMouseOver())
end

local listView = CreateScrollBoxListLinearView()
listView:SetElementExtentCalculator(function(_, data)
	if data.isSpacer then
		return LAYOUT.HEADER_GAP
	end
	return data.isHeader and LAYOUT.HEADER_ROW_HEIGHT or LAYOUT.QUEST_ROW_HEIGHT
end)
listView:SetElementInitializer("Button", InitRow)
ScrollUtil.InitScrollBoxListWithScrollBar(listBox, listBar, listView)

--------------------------------------------------------------------------------
-- Expand All and Track All
--------------------------------------------------------------------------------

local expandButton, trackButton = ns.CreateListButtons(frame)
expandButton:SetPoint("LEFT", frame, "TOPLEFT", LAYOUT.LIST_BUTTONS_X, LAYOUT.LIST_BUTTONS_Y)
ns.listButtons = { expandButton, trackButton } -- The map's Show Map button follows them (Quest-Map.lua)

expandButton:SetScript("OnClick", function(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	local collapse = not self.allCollapsed
	for index = 1, ns.GetNumQuestLogEntries() do
		local entry = ns.GetQuestLogEntry(index)
		if entry and entry.isHeader and entry.isCollapsed ~= collapse then
			ns.SetQuestZoneCollapsed(index, collapse)
		end
	end
	ns.RequestUpdate()
end)

trackButton:SetScript("OnClick", function(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	ns.SetAllTracked(self.questIDs, self.trackAll)
end)

--[[
	Collapse All while any zone is open, Expand All once every zone is collapsed. Track All while some
	quest Questie or the watch list can still take isn't tracked, Untrack All once none is left
]]
local function UpdateListButtons(quests, allCollapsed)
	expandButton.allCollapsed = allCollapsed
	expandButton:SetText(allCollapsed and L["EXPAND_ALL"] or L["COLLAPSE_ALL"])
	expandButton:SetEnabled(#quests > 0)

	local questIDs, anyTracked, trackAll = {}, false, false
	for _, quest in ipairs(quests) do
		local questID, questLogIndex = quest.questID, quest.questLogIndex
		questIDs[#questIDs + 1] = questID
		if ns.IsTracked(questID, questLogIndex) then
			anyTracked = true
		elseif ns.CanTrack(questID) and ns.HasRoomToTrack(questID, questLogIndex) then
			trackAll = true
		end
	end
	trackButton.questIDs, trackButton.trackAll = questIDs, trackAll
	trackButton:SetText(trackAll and L["TRACK_ALL"] or L["UNTRACK_ALL"])
	trackButton:SetEnabled(not InCombatLockdown() and (trackAll or (anyTracked and ns.CanRemoveQuestWatch())))
end

--------------------------------------------------------------------------------
-- Showing the entries
--------------------------------------------------------------------------------

--[[
	Picks a quest to show when nothing (or a quest no longer in the log) is selected: the first one
	showing, or failing that the first one under a collapsed zone
]]
local function ValidateSelection(entries, quests)
	if state.selectedQuestID and ns.GetLogIndexForQuestID(state.selectedQuestID) then
		return
	end
	state.selectedQuestID = nil
	for _, entry in ipairs(entries) do
		if entry.questID and not entry.isHeader then
			state.selectedQuestID = entry.questID
			return
		end
	end
	state.selectedQuestID = quests[1] and quests[1].questID
end

local function UpdateList(entries)
	listBox:SetDataProvider(CreateDataProvider(entries), ScrollBoxConstants.RetainScrollPosition)

	--[[
		Bring a quest opened from elsewhere into view once it's in the list (its zone may still have been
		opening)
	]]
	if state.scrollToQuestID then
		local index = listBox:FindElementDataIndexByPredicate(function(data)
			return data.questID == state.scrollToQuestID
		end)
		if index then
			state.scrollToQuestID = nil
			listBox:ScrollToElementDataIndex(
				index,
				ScrollBoxConstants.AlignNearest,
				0,
				ScrollBoxConstants.NoScrollInterpolation
			)
		end
	end
end

--------------------------------------------------------------------------------
-- Refreshing
--------------------------------------------------------------------------------

function ns.SetQuestListHeight(height)
	listBox:SetHeight(height)
end

local turnInLine = ns.CreateTurnInLine(frame)

-- Rebuilds the list and settles the selection; returns how many quests the log holds
function ns.UpdateQuestList()
	local entries, quests, allCollapsed = ns.BuildQuestListEntries() -- Forever-Quest-List-Entries.lua
	ValidateSelection(entries, quests)

	local ready = {}
	for _, quest in ipairs(quests) do
		if quest.isComplete then
			ready[#ready + 1] = quest
		end
	end
	ns.UpdateTurnInLine(turnInLine, ready)

	noQuestsText:SetShown(#quests == 0)
	-- A client whose TOC lists no map has none (Quest-Map.lua)
	if ns.questMap then
		ns.questMap.SetLogEmpty(#quests == 0)
	end
	UpdateListButtons(quests, allCollapsed)

	UpdateList(entries)
	return #quests
end
