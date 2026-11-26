local _, ns = ...

--[[
	On the Complete Quest page, a reward chosen before the player clicks: the first choice Pawn calls an
	upgrade, left to right and top to bottom, else the choice worth the most at a vendor (its sell price
	times how many come). Without Pawn, the one worth the most. A reward the player clicks stays theirs.
	While Pawn marks quest rewards, ElvUI's Mark Quest Reward coin is hidden, so only Pawn's mark shows
]]

local rewardPick = {}
ns.rewardPick = rewardPick

local onRewardPage -- Whether the last page QuestInfo drew was the Complete Quest page
local playerChose -- Whether the player clicked a reward since that page opened
local picking -- Whether the click under way is this file's, not the player's
local waitingForItems -- Whether a choice's item hadn't loaded on the last try

--------------------------------------------------------------------------------
-- Pawn and ElvUI
--------------------------------------------------------------------------------

-- Whether Pawn is loaded and set up for this character, as its own quest hook checks
local function PawnReady()
	if not (PawnCommon and PawnPlayerFullName and PawnGetItemData and PawnIsItemAnUpgrade) then
		return false
	end
	return not (PawnIsIncompatible and PawnIsIncompatible())
end

-- Whether Pawn draws its upgrade arrows and coins on quest rewards
local function PawnMarksRewards()
	return PawnReady() and PawnCommon.ShowQuestUpgradeAdvisor and true or false
end
rewardPick.PawnMarksRewards = PawnMarksRewards -- For the coin on the reward worth the most (Quest-Reward-Coin.lua)

-- ElvUI's coin, hidden now and each time ElvUI shows it while Pawn marks the rewards
local elvuiCoinHooked
local function HideElvUICoin()
	local coin = _G.ElvUI_QuestRewardGoldIconFrame
	if not coin then
		return
	end
	if not elvuiCoinHooked then
		elvuiCoinHooked = true
		hooksecurefunc(coin, "Show", function(self)
			if PawnMarksRewards() then
				self:Hide()
			end
		end)
	end
	if coin:IsShown() and PawnMarksRewards() then
		coin:Hide()
	end
end

--[[
	Whether Pawn calls a choice an upgrade, as it decides for its green arrow: usable, and better by its
	scales, or by item level when Pawn shows item level upgrades. Nothing while Pawn can't read the item yet
]]
local function IsPawnUpgrade(link, usable)
	if not (usable and PawnReady()) then
		return false
	end
	local item = PawnGetItemData(link)
	if not item then
		return nil
	end
	local upgradeInfo, itemLevelIncrease = PawnIsItemAnUpgrade(item)
	return (upgradeInfo or (PawnCommon.ShowItemLevelUpgrades and itemLevelIncrease)) and true or false
end

--------------------------------------------------------------------------------
-- Choosing
--------------------------------------------------------------------------------

--[[
	Of a quest's choices, the one worth the most at a vendor: its sell price times how many come. choices is a
	list of { item, amount }: item a link or item ID, false for a choice that isn't an item and sells for
	nothing, nil where it isn't known yet. Nothing with fewer than two, or none worth anything. Also returns
	whether an item hadn't loaded yet. Shared with the coin on that choice (Quest-Reward-Coin.lua)
]]
function rewardPick.MostValuable(choices)
	if #choices < 2 then
		return nil, false
	end
	local missing = false
	local best, bestValue = nil, 0
	for index, choice in ipairs(choices) do
		if choice.item ~= false then
			local sellPrice = choice.item and select(11, C_Item.GetItemInfo(choice.item))
			if sellPrice == nil then
				missing = true
			else
				local value = sellPrice * math.max(choice.amount or 1, 1)
				if value > bestValue then
					best, bestValue = index, value
				end
			end
		end
	end
	return best, missing
end

-- The choice to pick, and whether an item it weighed hadn't loaded yet
local function ChooseReward()
	local count = GetNumQuestChoices()
	if count < 2 then
		return nil, false
	end
	local missing = false
	local firstUpgrade
	local choices = {}
	for index = 1, count do
		local link = GetQuestItemLink("choice", index)
		local _, _, amount, _, usable = GetQuestItemInfo("choice", index)
		choices[index] = { item = link, amount = amount }
		if link then
			local upgrade = IsPawnUpgrade(link, usable)
			if upgrade == nil then
				missing = true
			elseif upgrade and not firstUpgrade then
				firstUpgrade = index
			end
		end
	end
	local best, priceMissing = rewardPick.MostValuable(choices)
	return firstUpgrade or best, missing or priceMissing
end

-- The choice's button, as Blizzard's click on it would find it
local function ChoiceButton(index)
	local button = QuestInfo_GetRewardButton(QuestInfoRewardsFrame, index)
	if button and button.type == "choice" and button:IsShown() then
		return button
	end
end

-- Lights the chosen reward through Blizzard's own click, so Complete Quest takes it and skins follow
local function Pick()
	waitingForItems = false
	if playerChose or not onRewardPage or not QuestInfoRewardsFrame:IsVisible() then
		return
	end
	local index, missing = ChooseReward()
	waitingForItems = missing
	local button = index and ChoiceButton(index)
	if button and QuestInfoFrame.itemChoice ~= index then
		picking = true
		QuestInfoItem_OnClick(button)
		picking = false
	end
end

if QuestInfo_Display and QuestInfoItem_OnClick and QuestInfo_GetRewardButton and QuestInfoRewardsFrame then
	hooksecurefunc("QuestInfoItem_OnClick", function()
		if not picking then
			playerChose = true
		end
	end)

	hooksecurefunc("QuestInfo_Display", function(template)
		onRewardPage = template ~= nil and template == QUEST_TEMPLATE_REWARD
		playerChose = false
		waitingForItems = false
		if not onRewardPage then
			return
		end
		-- A frame later: once Blizzard has cleared the last choice, and Pawn and ElvUI have marked theirs
		C_Timer.After(0, function()
			HideElvUICoin()
			Pick()
		end)
	end)
end

-- An item a choice was waiting on has loaded: weigh the choices again, unless the player has chosen
function rewardPick:OnGetItemInfoReceived()
	if waitingForItems then
		Pick()
	end
end
