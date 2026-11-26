local _, ns = ...

--[[
	A gold coin on the quest reward choice worth the most at a vendor (rewardPick.MostValuable), so a player
	who can use none of them needn't hover each one to find it. It shows on the quest giver's Complete Quest
	page, and on the quest log's rewards: WoW Forever's and Mists' own buttons (Forever-Quest-Details.lua), and
	Blizzard's on Classic Era and TBC. Its tooltip says what it means. No coin with fewer than two choices,
	none worth anything, or before every choice's item has loaded.

	Pawn and ElvUI can put their own coin on Blizzard's reward buttons. While Pawn marks quest rewards, or
	ElvUI's coin shows on the Complete Quest page, this one stays off those buttons, so only one coin shows
]]

local L = ns.L
local SPACE = ns.LAYOUT.SPACE
local rewardPick = ns.rewardPick

local rewardCoin = {}
ns.rewardCoin = rewardCoin

local COIN_TEXTURE = "Interface\\MoneyFrame\\UI-GoldIcon"
local COIN_SIZE = SPACE.GROUP

local marked = { giver = {}, log = {} } -- The buttons each page has its coin on now
local waiting = {} -- The pages whose items hadn't loaded when last marked
local onGiverPage -- Whether the last page QuestInfo drew was the Complete Quest page

--------------------------------------------------------------------------------
-- The coin
--------------------------------------------------------------------------------

-- A reward button's icon: Blizzard's newer buttons and WoW Forever's name it, the Classic quest log's are globals
local function ButtonIcon(button)
	local name = button.GetName and button:GetName()
	return button.Icon or (name and _G[name .. "IconTexture"])
end

-- After the game's own tooltip lines: what the coin means
local function AddCoinLine(button)
	if button.prettyWideQuestLogCoin:IsShown() and GameTooltip:GetOwner() == button then
		GameTooltip:AddLine(L["REWARD_SELLS_MOST"], ns.GetColorRGB("HELP"))
		GameTooltip:Show()
	end
end

-- Shows or hides the coin over the lower right of a reward button's icon, making it the first time
function rewardCoin.SetCoin(button, shown)
	local coin = button.prettyWideQuestLogCoin
	if not shown then
		if coin then
			coin:Hide()
		end
		return
	end
	if not coin then
		coin = button:CreateTexture(nil, "OVERLAY", nil, 7)
		coin:SetTexture(COIN_TEXTURE)
		coin:SetSize(COIN_SIZE, COIN_SIZE)
		coin:SetPoint("BOTTOMRIGHT", ButtonIcon(button) or button, "BOTTOMRIGHT", SPACE.TIGHT, -SPACE.TIGHT)
		button.prettyWideQuestLogCoin = coin
		button:HookScript("OnEnter", AddCoinLine)
	end
	coin:Show()
end

local function Clear(page)
	for button in pairs(marked[page]) do
		rewardCoin.SetCoin(button, false)
	end
	wipe(marked[page])
	waiting[page] = nil
end

local function Mark(page, button)
	rewardCoin.SetCoin(button, true)
	marked[page][button] = true
end

-- The choice to mark among choices, { item, amount } each, and notes the page waiting while an item hasn't loaded
local function Best(page, choices)
	local best, missing = rewardPick.MostValuable(choices)
	if missing then
		waiting[page] = true
		return nil
	end
	return best
end

--------------------------------------------------------------------------------
-- The quest giver's Complete Quest page
--------------------------------------------------------------------------------

local function ElvUICoinShown()
	local coin = _G.ElvUI_QuestRewardGoldIconFrame
	return coin and coin:IsShown() or false
end

local function MarkGiverPage()
	Clear("giver")
	if not (onGiverPage and QuestInfoRewardsFrame:IsVisible()) then
		return
	end
	local choices = {}
	for index = 1, GetNumQuestChoices() do
		local _, _, amount = GetQuestItemInfo("choice", index)
		choices[index] = { item = GetQuestItemLink("choice", index), amount = amount }
	end
	local best = Best("giver", choices)
	if not best or rewardPick.PawnMarksRewards() or ElvUICoinShown() then
		return
	end
	local button = QuestInfo_GetRewardButton(QuestInfoRewardsFrame, best)
	if button and button.type == "choice" and button:IsShown() then
		Mark("giver", button)
	end
end

-- ElvUI may draw its coin after this one: this one then goes, so only one shows
local elvuiCoinHooked
local function WatchElvUICoin()
	local coin = _G.ElvUI_QuestRewardGoldIconFrame
	if coin and not elvuiCoinHooked then
		elvuiCoinHooked = true
		hooksecurefunc(coin, "Show", function()
			Clear("giver")
		end)
	end
end

if QuestInfo_Display and QuestInfo_GetRewardButton and QuestInfoRewardsFrame then
	hooksecurefunc("QuestInfo_Display", function(template)
		onGiverPage = template ~= nil and template == QUEST_TEMPLATE_REWARD
		Clear("giver")
		if onGiverPage then
			-- A frame later, once Pawn and ElvUI have marked theirs (and the reward pick has hidden ElvUI's)
			C_Timer.After(0, function()
				WatchElvUICoin()
				MarkGiverPage()
			end)
		end
	end)
end

--------------------------------------------------------------------------------
-- The quest log on Classic Era and TBC: Blizzard's QuestLogItem buttons
--------------------------------------------------------------------------------

local function MarkClassicLog()
	Clear("log")
	local choices = {}
	for index = 1, GetNumQuestLogChoices() do
		local _, _, amount = GetQuestLogChoiceInfo(index)
		choices[index] = { item = GetQuestLogItemLink("choice", index), amount = amount }
	end
	local best = Best("log", choices)
	if not best or rewardPick.PawnMarksRewards() then
		return
	end
	local index = 1
	local button = _G.QuestLogItem1
	while button do
		if button.type == "choice" and button:GetID() == best and button:IsShown() then
			Mark("log", button)
			return
		end
		index = index + 1
		button = _G["QuestLogItem" .. index]
	end
end

if _G.QuestLog_UpdateQuestDetails and GetNumQuestLogChoices and GetQuestLogChoiceInfo then
	hooksecurefunc("QuestLog_UpdateQuestDetails", MarkClassicLog)
end

--------------------------------------------------------------------------------
-- Items loading
--------------------------------------------------------------------------------

-- An item a page was waiting on has loaded: mark it again. WoW Forever's quest log redraws itself
function rewardCoin:OnGetItemInfoReceived()
	if waiting.giver then
		MarkGiverPage()
	end
	if waiting.log then
		MarkClassicLog()
	end
end
