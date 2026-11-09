local _, ns = ...

--[[
	Routes: Use Item buttons on the Quest Arrow, as Questie's tracker has them. In front of each quest the
	arrow lists where the player is (the waypoint, or "While You're Here"), a button for each item that
	quest has to use, up to two, ready to click; which items, and where, is Routes-Arrow-Item-Choice.lua's to say. The
	first button is the Use Quest Item key binding (Bindings.xml).

	The buttons are secure (SecureActionButtonTemplate), so in combat nothing about them can change: not
	the item, not where they sit, not whether they show. So they're never the arrow's children and never
	anchored to it, which would make the arrow itself protected and stop it moving or hiding in combat.
	Each sits on UIParent, at the arrow's own scale, placed in front of its quest's title on the arrow,
	and follows the arrow out of combat as it's dragged or its list changes. In combat a button whose
	place or item no longer matches the list stays where it was, faded (STALE_ALPHA), still using its
	item, and everything catches up when combat ends. The count, cooldown and range shading are plain
	textures and text on the button, so they update in combat too
]]

local routes = ns.routes
local L = ns.L

local SPACE = ns.LAYOUT.SPACE
local frame = routes.arrowFrame
local titleRows = routes.arrowTitleRows
local DIM_ALPHA = routes.ARROW_LAYOUT.DIM_ALPHA

-- The owner of this file's event handlers in Core.lua's EVENTS
local routesItems = {}
ns.routesItems = routesItems

local BUTTON_PREFIX = "PrettyWideQuestLogQuestItem"
local STALE_ALPHA = 0.35 -- In combat, a button the list has moved away from
local CHECK_INTERVAL = 1 -- Seconds between looks at the bags and the quests, as the list's counts
local RANGE_INTERVAL = 0.25 -- Seconds between range checks on the target
local QUESTION_MARK = "Interface\\Icons\\INV_Misc_QuestionMark"

-- The Use Quest Item binding (Bindings.xml) clicks the first button
routes.USE_ITEM_COMMAND = "CLICK " .. BUTTON_PREFIX .. "1:LeftButton"
BINDING_HEADER_PRETTYWIDEQUESTLOG = L["ADDON_TITLE"]
_G["BINDING_NAME_" .. routes.USE_ITEM_COMMAND] = L["BINDING_USE_QUEST_ITEM"]

--------------------------------------------------------------------------------
-- The buttons
--------------------------------------------------------------------------------

local buttons = {}

local function ShowCount(button)
	local ok, count = pcall(C_Item.GetItemCount, button.spec.itemID, nil, true)
	count = ok and type(count) == "number" and count or 0
	button.count:SetText(count > 1 and tostring(count) or "")
	-- Used up in combat, where it can't hide: grayed until combat ends takes it away
	button.icon:SetDesaturated(count == 0)
end

local function ShowCooldown(button)
	local ok, start, duration, enabled = pcall(C_Container.GetItemCooldown, button.spec.itemID)
	-- WoW Forever can keep a cooldown secret in combat, and nothing may test it: the swipe stays as it was
	if ok and not ns.IsReadable(start, duration, enabled) then
		return
	end
	if ok and (enabled == 1 or enabled == true) and type(duration) == "number" and duration > 0 then
		button.cooldown:SetCooldown(start, duration)
		button.cooldown:Show()
	else
		button.cooldown:Hide()
	end
end

--[[
	Red while the target is out of the item's reach, as the action bars shade theirs. The client won't
	say for a friendly target in combat, and WoW Forever can keep the answers secret then, so the shading
	stays as it was
]]
local function ShowRange(button)
	if not UnitExists("target") then
		button.icon:SetVertexColor(1, 1, 1)
		return
	end
	if InCombatLockdown() then
		local friendly = UnitIsFriend("player", "target")
		if not ns.IsReadable(friendly) or friendly then
			return
		end
	end
	local ok, inRange = pcall(C_Item.IsItemInRange, button.spec.itemID, "target")
	if ok and not ns.IsReadable(inRange) then
		return
	end
	if ok and inRange == false then
		button.icon:SetVertexColor(ns.GetColorRGB("ARROW_WRONG_WAY"))
	else
		button.icon:SetVertexColor(1, 1, 1)
	end
end

-- The item's own tooltip, then how to use it: a click, and for the first button its key, where one is bound
local function OnEnter(self)
	if not self.spec then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink("item:" .. self.spec.itemID)
	local hints = { { L["ROUTES_CLICK"], L["ROUTES_CLICK_USE_ITEM"] } }
	local key = self == buttons[1] and GetBindingKey(routes.USE_ITEM_COMMAND)
	if key then
		hints[2] = { GetBindingText(key), L["ROUTES_CLICK_USE_ITEM"] }
	end
	routes.AddClickHints(GameTooltip, hints)
	GameTooltip:Show()
end

local function OnLeave()
	GameTooltip:Hide()
end

--[[
	Made out of combat as needed and kept, named so the key binding can click the first. A key reaches
	the button twice, down and up, and a macro's /click only up, so it acts on the up half for all three
	whatever ActionButtonUseKeyDown says, as Good to Go's Buff Key does. Only the left button uses the item
]]
local function Button(index)
	if buttons[index] then
		return buttons[index]
	end
	local button = CreateFrame("Button", BUTTON_PREFIX .. index, UIParent, "SecureActionButtonTemplate")
	button:SetFrameStrata(frame:GetFrameStrata())
	button:SetFrameLevel(frame:GetFrameLevel() + 2)
	button:SetClampedToScreen(true)
	button:RegisterForClicks("AnyUp", "AnyDown")
	button:SetAttribute("useOnKeyDown", false)
	button:Hide()

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetAllPoints()
	button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- Inside the icon's own border
	button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
	button.cooldown:SetAllPoints()
	button.count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -SPACE.TIGHT, SPACE.TIGHT)

	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave", OnLeave)
	buttons[index] = button
	return button
end
-- The binding's button is there from the start, so a key pressed before any item shows finds it
Button(1)

local function SameSpec(a, b)
	return a and b and a.itemID == b.itemID and a.size == b.size and a.x == b.x and a.top == b.top
end

-- Out of combat only: the item, size and place, then shown
local function SetUp(button, spec, left, top, scale)
	local old = button.spec
	if SameSpec(old, spec) and button.left == left and button.top == top and button.scale == scale then
		button.spec = spec
		button:SetAlpha(spec.dim and DIM_ALPHA or 1)
		return
	end
	if not old or old.itemID ~= spec.itemID then
		button:SetAttribute("type1", "item")
		button:SetAttribute("item1", "item:" .. spec.itemID)
		button.icon:SetTexture(C_Item.GetItemIconByID(spec.itemID) or QUESTION_MARK)
	end
	button.spec, button.left, button.top, button.scale = spec, left, top, scale
	button:SetScale(scale)
	button:SetSize(spec.size, spec.size)
	button:ClearAllPoints()
	button:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left + spec.x, top - spec.top)
	button:SetAlpha(spec.dim and DIM_ALPHA or 1)
	button:Show()
	ShowCount(button)
	ShowCooldown(button)
	ShowRange(button)
end

-- Out of combat only: no item, hidden
local function Clear(button)
	if not button.spec then
		return
	end
	button.spec = nil
	button:SetAttribute("type1", nil)
	button:SetAttribute("item1", nil)
	button:Hide()
end

local wanted = {}
local pendingAfterCombat = false

--[[
	Puts the buttons where wanted says, against where the arrow is now. In combat it can only fade the
	ones that no longer match and leave the rest for PLAYER_REGEN_ENABLED
]]
local function Sync()
	local left, top, scale = frame:GetLeft(), frame:GetTop(), frame:GetScale()
	local placeable = left ~= nil and top ~= nil
	if InCombatLockdown() then
		pendingAfterCombat = false
		for index, button in ipairs(buttons) do
			local spec = wanted[index]
			if button.spec then
				local matches = placeable
					and SameSpec(button.spec, spec)
					and button.left == left
					and button.top == top
					and button.scale == scale
				button:SetAlpha(matches and (spec.dim and DIM_ALPHA or 1) or STALE_ALPHA)
				pendingAfterCombat = pendingAfterCombat or not matches
			elseif spec then
				pendingAfterCombat = true
			end
		end
		pendingAfterCombat = pendingAfterCombat or #wanted > #buttons
		return
	end
	pendingAfterCombat = false
	local count = placeable and #wanted or 0
	for index = 1, count do
		SetUp(Button(index), wanted[index], left, top, scale)
	end
	for index = count + 1, #buttons do
		Clear(buttons[index])
	end
end

--[[
	The left and bottom edges of the buttons showing, in the arrow's own units from its left and top, or
	nil with none: the arrow's hover shade (Routes-Arrow.lua) reaches round them
]]
function routes.ArrowItemBounds()
	local left, bottom
	for _, button in ipairs(buttons) do
		local spec = button.spec
		if spec and button:IsShown() then
			left = math.min(left or spec.x, spec.x)
			bottom = math.max(bottom or 0, spec.top + spec.size)
		end
	end
	return left, bottom
end

-- Looks at the bags and quests again, then places the buttons
local function Refresh()
	wanted = routes.WantedItemButtons()
	Sync()
end

--------------------------------------------------------------------------------
-- When it looks again
--------------------------------------------------------------------------------

--[[
	On the arrow's own frame updates, so only while it shows: every CHECK_INTERVAL, or at once when the
	list is laid out again; and on any frame the arrow has moved or been scaled, the buttons follow it.
	The range shading every RANGE_INTERVAL
]]
local sinceCheck, sinceRange = CHECK_INTERVAL, 0
local seenVersion, seenLeft, seenTop, seenScale

frame:HookScript("OnUpdate", function(_, elapsed)
	sinceCheck, sinceRange = sinceCheck + elapsed, sinceRange + elapsed
	local left, top, scale = frame:GetLeft(), frame:GetTop(), frame:GetScale()
	if sinceCheck >= CHECK_INTERVAL or titleRows.version ~= seenVersion then
		sinceCheck, seenVersion = 0, titleRows.version
		seenLeft, seenTop, seenScale = left, top, scale
		Refresh()
	elseif left ~= seenLeft or top ~= seenTop or scale ~= seenScale then
		seenLeft, seenTop, seenScale = left, top, scale
		Sync()
	end
	if sinceRange >= RANGE_INTERVAL then
		sinceRange = 0
		for _, button in ipairs(buttons) do
			if button.spec then
				ShowRange(button)
			end
		end
	end
end)

-- The arrow hiding takes its buttons with it, or in combat fades them until it ends; showing, they're back at once
frame:HookScript("OnHide", Refresh)
frame:HookScript("OnShow", function()
	sinceCheck = CHECK_INTERVAL
end)

-- A setting changed: Show Quest Item Buttons, Show Quests and Objectives, the arrow itself
routes.AddListener(function()
	sinceCheck = CHECK_INTERVAL
	if not frame:IsShown() then
		Refresh()
	end
end)

function routesItems:OnPlayerRegenEnabled()
	if pendingAfterCombat then
		Refresh()
	end
end

-- An item came into the bags or was used up: its count at once, in combat too, then the buttons
function routesItems:OnBagUpdateDelayed()
	for _, button in ipairs(buttons) do
		if button.spec then
			ShowCount(button)
		end
	end
	Refresh()
end

function routesItems:OnBagUpdateCooldown()
	for _, button in ipairs(buttons) do
		if button.spec then
			ShowCooldown(button)
		end
	end
end

function routesItems:OnPlayerTargetChanged()
	sinceRange = RANGE_INTERVAL
end

-- What Routes Context reports (Diagnostics/Manifests.lua): each button's item, and whether any wait on combat
function routes.ItemButtonsState()
	local shown = {}
	for index, button in ipairs(buttons) do
		if button.spec then
			shown[#shown + 1] = string.format("%d: item %d", index, button.spec.itemID)
		end
	end
	return shown, pendingAfterCombat
end
