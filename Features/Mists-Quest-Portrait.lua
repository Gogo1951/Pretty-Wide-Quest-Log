local _, ns = ...

-- Mists: the quest giver's model beside the window, as Blizzard's own quest log shows it beside its own.

local LAYOUT = ns.LAYOUT
local frame = ns.questLogFrame
local state = ns.questLog
local holder = ns.questMap.holder -- The map docked to the window's right (Quest-Map.lua)

local MODEL_WIDTH, MODEL_HEIGHT = 198, 230 -- Blizzard's own quest giver model
local NAME_HEIGHT = 20 -- The strip under the model the giver's name sits in
local GAP = 4 -- Between the map and the box under it
local MIN_MODEL_HEIGHT = 60 -- Any less room under the map and the box hides
-- Where the box goes beside the window while the map is closed, as Blizzard's quest log puts its own
local BESIDE_X, BESIDE_Y = -5, -42

--------------------------------------------------------------------------------
-- The Box
--------------------------------------------------------------------------------

-- In the map's own border, holding the model and the giver's name. Blizzard's own model is left alone
local box = CreateFrame("Frame", nil, frame, "BackdropTemplate")
box:SetBackdrop(holder.backdropInfo)
box:Hide()
local inset = holder.backdropInfo.insets.left

local scene = CreateFrame("ModelScene", nil, box, "PanningModelSceneMixinTemplate")
scene:SetPoint("TOPLEFT", inset, -inset)
scene:SetPoint("BOTTOMRIGHT", -inset, inset + NAME_HEIGHT)

local nameText = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
nameText:SetPoint("BOTTOMLEFT", inset, inset)
nameText:SetPoint("BOTTOMRIGHT", -inset, inset)
nameText:SetHeight(NAME_HEIGHT)
nameText:SetWordWrap(false)

-- The box's size around a model of this size
local function SetModelSize(width, height)
	box:SetSize(width + 2 * inset, height + 2 * inset + NAME_HEIGHT)
end

--[[
	Under the map, in the space beside the window, sized to Blizzard's proportions so that it ends level with
	the bottom of the window's art, and no wider than the map. Returns false when there's too little room for
	it, or while the map or the window hasn't been laid out yet
]]
local function FitUnderMap()
	box:ClearAllPoints()
	box:SetPoint("TOPLEFT", holder, "BOTTOMLEFT", 0, -GAP)
	if not (holder:GetBottom() and frame:GetBottom()) then
		return false
	end
	local scale = box:GetEffectiveScale()
	local top = holder:GetBottom() * holder:GetEffectiveScale() / scale - GAP
	-- The window's art ends above the frame's own bottom edge, as the map measures it (Quest-Map.lua)
	local artBottom = frame:GetBottom() + LAYOUT.ART_INSET_BOTTOM
	local room = top - artBottom * frame:GetEffectiveScale() / scale
	local modelHeight = room - 2 * inset - NAME_HEIGHT
	local maxWidth = holder:GetWidth() * holder:GetEffectiveScale() / scale - 2 * inset
	local modelWidth = math.min(modelHeight * MODEL_WIDTH / MODEL_HEIGHT, maxWidth)
	modelHeight = modelWidth * MODEL_HEIGHT / MODEL_WIDTH
	if modelHeight < MIN_MODEL_HEIGHT then
		return false
	end
	SetModelSize(modelWidth, modelHeight)
	return true
end

local function PlaceBesideWindow()
	box:ClearAllPoints()
	box:SetPoint("TOPLEFT", frame, "TOPRIGHT", BESIDE_X, BESIDE_Y)
	SetModelSize(MODEL_WIDTH, MODEL_HEIGHT)
	return true
end

--------------------------------------------------------------------------------
-- The Quest Giver
--------------------------------------------------------------------------------

--[[
	Posed as Blizzard poses its own (QuestFrame_ShowQuestPortrait): the player for -1, otherwise the giver,
	on its mount when it has one
]]
local function Pose(portrait, mount, modelSceneID)
	scene:ClearScene()
	scene:TransitionToModelSceneID(
		modelSceneID or QUEST_FRAME_MODEL_SCENE_ID,
		CAMERA_TRANSITION_TYPE_IMMEDIATE,
		CAMERA_MODIFICATION_TYPE_DISCARD,
		true
	)
	if portrait == -1 then
		scene:GetPlayerActor("player"):SetModelByUnit("player", false)
		return
	end
	local mountActor, riderActor
	local riderTag = "rider"
	if mount and mount > 0 then
		mountActor = scene:GetActorByTag("mount")
		mountActor:SetModelByCreatureDisplayID(mount)
		mountActor:SetAnimation(618)
	else
		riderTag = "mount" -- With no mount, the mount's actor holds the giver
	end
	if portrait > 0 then
		riderActor = scene:GetActorByTag(riderTag)
		riderActor:SetModelByCreatureDisplayID(portrait)
		riderActor:SetAnimation(0)
	end
	if mountActor and riderActor then
		mountActor:AttachToMount(riderActor, 91, 0)
	end
end

local posedAs -- The giver last posed, so a refresh doesn't start the model over

--[[
	For the quest the details show, which they select first, so GetQuestLogPortraitGiver reads it. Under the
	map while the map is open, otherwise beside the window. Nothing changes for a quest the details didn't
	take (the quest giver window had the quest text), and quests with no giver to show, or an empty window, hide it
]]
local function Update()
	if not frame:IsShown() then
		return
	end
	if not state.selectedQuestID then
		box:Hide()
		posedAs = nil
		return
	end
	if ns.GetSelectedQuestID() ~= state.selectedQuestID then
		return
	end
	local portrait, _, name, mount, modelSceneID = GetQuestLogPortraitGiver()
	local hasGiver = portrait and portrait ~= 0 and (not QuestLogShouldShowPortrait or QuestLogShouldShowPortrait())
	local placed = hasGiver and (holder:IsShown() and FitUnderMap() or (not holder:IsShown() and PlaceBesideWindow()))
	if not placed then
		box:Hide()
		return
	end
	box:Show()
	nameText:SetText(name or "")
	local giver = strjoin(":", tostring(portrait), tostring(mount), tostring(modelSceneID))
	if giver ~= posedAs then
		posedAs = giver
		Pose(portrait, mount, modelSceneID)
	end
end

hooksecurefunc(ns, "DisplayQuestDetails", Update)

-- Posed afresh next time the window opens
frame:HookScript("OnHide", function()
	posedAs = nil
end)

--[[
	Opening or closing the map, resizing the window, or a new Map Scale moves or refits it, a frame later,
	once the map has been laid out to match (Quest-Map.lua). While the window is being dragged taller or
	shorter it's hidden, and drawn again once, as the drag ends (Window.lua)
]]
local refitPending
local function RequestRefit()
	if refitPending then
		return
	end
	refitPending = true
	C_Timer.After(0, function()
		refitPending = nil
		Update()
	end)
end
holder:HookScript("OnShow", RequestRefit)
holder:HookScript("OnHide", RequestRefit)
hooksecurefunc(ns, "ApplyMapScale", RequestRefit)
hooksecurefunc(ns, "OnWindowResizeStopped", RequestRefit)
frame:HookScript("OnSizeChanged", function()
	if frame.isResizing then
		box:Hide()
	else
		RequestRefit()
	end
end)
