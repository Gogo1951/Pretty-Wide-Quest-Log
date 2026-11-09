local _, ns = ...

--[[
	WoW Forever and Mists: the quest details' reward buttons (Forever-Quest-Details.lua), of the window's
	own: icon, name in the item's quality color, and count. Blizzard's plain LargeItemButtonTemplate gives
	the look; it has no scripts of its own. Hovering shows the reward through the tooltip's own quest log
	calls, and a modified click links an item in chat
]]

local state = ns.questLog

local function ShowRewardTooltip(button)
	local reward = button.reward
	if not reward then
		return
	end
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	if reward.kind == "spell" then
		GameTooltip:SetSpellByID(reward.spellID)
	else
		-- These read the quest log's selection, which something else may have moved since
		ns.SelectQuest(state.selectedQuestID)
		if reward.kind == "currency" then
			GameTooltip:SetQuestLogCurrency(reward.tooltipType, reward.tooltipIndex)
		else
			GameTooltip:SetQuestLogItem(reward.tooltipType, reward.tooltipIndex)
		end
	end
	GameTooltip:Show()
end

local function LinkReward(button)
	local reward = button.reward
	if not (reward and reward.kind == "item" and IsModifiedClick()) then
		return
	end
	ns.SelectQuest(state.selectedQuestID)
	local link = GetQuestLogItemLink(reward.tooltipType, reward.tooltipIndex)
	if link then
		HandleModifiedItemClick(link)
	end
end

local UNUSABLE_RED, UNUSABLE_GREEN, UNUSABLE_BLUE = 0.9, 0, 0 -- Blizzard's tint for a reward the player can't use

local function FillRewardButton(button, reward)
	button.reward = reward
	button.Icon:SetTexture(reward.texture)
	button.Name:SetText(reward.name or "")
	local quality = reward.quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[reward.quality]
	if quality and reward.quality > 1 then
		button.Name:SetTextColor(quality.r, quality.g, quality.b)
	else
		button.Name:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
	end
	local count = reward.count or 0
	local showCount = (reward.kind == "currency" and count > 0) or count > 1
	button.Count:SetText(showCount and ns.FormatNumber(count) or "")
	if reward.isUsable == false then
		button.Icon:SetVertexColor(UNUSABLE_RED, UNUSABLE_GREEN, UNUSABLE_BLUE)
		button.NameFrame:SetVertexColor(UNUSABLE_RED, UNUSABLE_GREEN, UNUSABLE_BLUE)
	else
		button.Icon:SetVertexColor(1, 1, 1)
		button.NameFrame:SetVertexColor(1, 1, 1)
	end
end

--[[
	An item reward the client hasn't loaded comes back without its name. Each such item asks for its data
	once, and the details are drawn again when it arrives
]]
local itemsAskedFor = {}
local function AskForItem(itemID)
	if itemsAskedFor[itemID] or not (Item and Item.CreateFromItemID) then
		return
	end
	itemsAskedFor[itemID] = true
	Item:CreateFromItemID(itemID):ContinueOnItemLoad(function()
		itemsAskedFor[itemID] = nil
		ns.RequestUpdate()
	end)
end

--[[
	The reward buttons on parent, each made as it's first needed. Fill(index, reward) gives the button at
	index the reward, asking for its item where the client hasn't loaded it, and returns the button.
	HideFrom(index) hides the button at index and every one after it
]]
function ns.CreateRewardButtons(parent)
	local rewardButtons = {}

	local function RewardButton(index)
		local button = rewardButtons[index]
		if not button then
			button = CreateFrame("Button", nil, parent, "LargeItemButtonTemplate")
			button:SetScript("OnEnter", ShowRewardTooltip)
			button:SetScript("OnLeave", GameTooltip_Hide)
			button:SetScript("OnClick", LinkReward)
			rewardButtons[index] = button
		end
		return button
	end

	local set = {}
	function set.Fill(index, reward)
		local button = RewardButton(index)
		FillRewardButton(button, reward)
		if reward.kind == "item" and not reward.name and reward.itemID then
			AskForItem(reward.itemID)
		end
		return button
	end
	function set.HideFrom(index)
		for later = index, #rewardButtons do
			rewardButtons[later]:Hide()
			rewardButtons[later].reward = nil
		end
	end
	return set
end
