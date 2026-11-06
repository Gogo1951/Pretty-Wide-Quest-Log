local _, ns = ...

--[[
	How a quest's rewards are drawn wherever QuestInfo shows them (the quest details, the quest giver
	window and the map's details): the experience and gold in the description's font and color, and the
	space around the reward buttons and between the rewards' sections
]]

--------------------------------------------------------------------------------
-- Rewards
--------------------------------------------------------------------------------

--[[
	Sets a number Blizzard draws in its own white outlined font (the experience reward) in source's font
	and color (the description's), like the other numbers on the parchment
]]
local function StyleQuestNumber(region, source)
	local fontObject = source:GetFontObject()
	if fontObject then
		region:SetFontObject(fontObject)
	else
		region:SetFont(source:GetFont())
	end
	region:SetTextColor(source:GetTextColor())
end

--[[
	The experience reward, each time QuestInfo shows one (the quest details, the quest giver window and the
	map's details), in the description's font and color, its thousands grouped like the turn-in line's.
	On a quest giver page with the quest giver window cleanup off it stays Blizzard's.

	Skins (ElvUI) add the share of a level it's worth after the number, "2,950 (+20.49%)", in a bright green
	made for their dark backdrop. On the parchment, where the description is dark, the share takes
	PARCHMENT_GAIN_COLOR instead. The skin adds it in a hook that may run before or after this one, so
	only the number at the front is grouped, and the color follows each change to the text
]]
local PARCHMENT_GAIN_COLOR = "1d6b1d" -- A deep green that reads on the parchment

-- Whether a FontString's color is dark, as text on the parchment is
local function IsDarkText(region)
	local r, g, b = region:GetTextColor()
	return (0.299 * r + 0.587 * g + 0.114 * b) < 0.5
end

--[[
	The gold reward, wherever the experience is styled, in the description's font and color like the
	other numbers on the parchment, rather than Blizzard's white outlined number font. Each coin's amount
	is its button's text, sized by Blizzard when it lays the coins out, so after a change of font the
	coins are laid out again for the same amount. With styled false they go back to Blizzard's font
]]
local moneyFont = CreateFont("PrettyWideQuestLogMoneyFont")
local rewardMoney = QuestInfoRewardsFrame and QuestInfoRewardsFrame.MoneyFrame
local blizzardCoinFonts = {} -- Each coin button's font object as Blizzard set it

local function CoinButtons(moneyFrame)
	local name, buttons = moneyFrame:GetName(), {}
	for _, coin in ipairs({ "Gold", "Silver", "Copper" }) do
		local button = moneyFrame[coin .. "Button"] or (name and _G[name .. coin .. "Button"])
		if button and button.GetNormalFontObject then
			buttons[#buttons + 1] = button
		end
	end
	return buttons
end

function ns.StyleRewardMoney(styled)
	if not rewardMoney then
		return
	end
	if styled then
		local source = QuestInfoDescriptionText
		local fontObject = source:GetFontObject()
		if fontObject then
			moneyFont:CopyFontObject(fontObject)
		else
			moneyFont:SetFont(source:GetFont())
		end
		moneyFont:SetTextColor(source:GetTextColor())
		moneyFont:SetShadowColor(0, 0, 0, 0)
	end
	local changed = false
	for _, button in ipairs(CoinButtons(rewardMoney)) do
		if blizzardCoinFonts[button] == nil then
			blizzardCoinFonts[button] = button:GetNormalFontObject() or false
		end
		local wanted = styled and moneyFont or blizzardCoinFonts[button]
		if wanted and button:GetNormalFontObject() ~= wanted then
			button:SetNormalFontObject(wanted)
			changed = true
		end
	end
	if changed and rewardMoney:IsShown() and rewardMoney.staticMoney and MoneyFrame_Update then
		MoneyFrame_Update(rewardMoney, rewardMoney.staticMoney)
	end
end

local experienceFrame = QuestInfoRewardsFrame and QuestInfoRewardsFrame.XPFrame
local experienceValue = experienceFrame and experienceFrame.ValueText
if experienceValue and QuestInfo_Display then
	ns.RememberBlizzardStyle(experienceValue)
	local blizzardRed, blizzardGreen, blizzardBlue, blizzardAlpha = experienceValue:GetTextColor()

	local onParchment -- Whether the experience is styled, on dark text
	local recoloring
	local function RecolorGain()
		if recoloring or not onParchment then
			return
		end
		local text = experienceValue:GetText()
		local recolored = text and (text:gsub("|c%x%x%x%x%x%x%x%x", "|cff" .. PARCHMENT_GAIN_COLOR))
		if recolored and recolored ~= text then
			recoloring = true
			experienceValue:SetText(recolored)
			recoloring = false
		end
	end
	hooksecurefunc(experienceValue, "SetText", RecolorGain)
	hooksecurefunc(experienceValue, "SetFormattedText", RecolorGain)

	hooksecurefunc("QuestInfo_Display", function(_, parentFrame)
		if ns.IsQuestGiverPage(parentFrame) and not ns.IsQuestGiverCleanupOn() then
			onParchment = false
			ns.RestoreBlizzardStyle(experienceValue)
			experienceValue:SetTextColor(blizzardRed, blizzardGreen, blizzardBlue, blizzardAlpha)
			ns.StyleRewardMoney(false)
			return
		end
		ns.StyleRewardMoney(true)
		StyleQuestNumber(experienceValue, QuestInfoDescriptionText)
		onParchment = IsDarkText(QuestInfoDescriptionText)
		-- The number at the front, grouped or not, with anything after it (the skin's share) kept as it is
		local text = experienceValue:GetText() or ""
		local number, rest = text:match("^(%d[%d,%. \194\160']*%d)(.*)$")
		if not number then
			number, rest = text:match("^(%d)(.*)$")
		end
		if number then
			experienceValue:SetText(ns.FormatNumber(tonumber((number:gsub("%D", "")), 10)) .. rest)
		end
		RecolorGain()
	end)
end

--[[
	Spaces the reward buttons LAYOUT.REWARD_BUTTONS_SPACE from the text around them: a button that hangs
	under a line of text (the first of its section) that far below it, and anything that hangs under a
	button (the next section's line) that far below that. Returns how much further down region went,
	for a block that has to grow to match
]]
function ns.SpaceAroundRewardButtons(region)
	if (not region) or (not region:IsShown()) or (region:GetNumPoints() < 1) then
		return 0
	end
	local point, relativeTo, relativePoint, x, y = region:GetPoint(1)
	local relativeType = relativeTo and relativeTo.GetObjectType and relativeTo:GetObjectType()
	local isButton = region:GetObjectType() == "Button"
	if isButton and relativeType ~= "FontString" then
		return 0 -- Buttons further down a section only sit beside or below the one before
	end
	if (not isButton) and relativeType ~= "Button" then
		return 0
	end
	local spacedY = -ns.LAYOUT.REWARD_BUTTONS_SPACE
	region:SetPoint(point, relativeTo, relativePoint, x, spacedY)
	return y - spacedY
end

local BLIZZARD_REWARD_LINE_GAP = 5 -- Blizzard's space between one section of the rewards and the next

-- Sets how far a piece hangs under the one above it, returning how much further down that put it
local function SetSpaceAbove(region, space)
	local point, relativeTo, relativePoint, x, y = region:GetPoint(1)
	region:SetPoint(point, relativeTo, relativePoint, x, -space)
	return y + space
end

--[[
	Spaces a QuestInfo rewards block to the scale, for WoW Forever and Mists' quest details and the quest
	giver window on every client: the heading's space under the Rewards heading, reward buttons clear of
	the text around them, each later section of the rewards a step under the one before, and with gold
	and experience both shown, a blank line's worth between them (without gold, "You will also receive:"
	is the experience line's own label, so it stays right under it). Blizzard sizes the block to fit what
	it laid out, so the block grows by however much further down its pieces went. Running it again on
	the same layout changes nothing
]]
function ns.SpaceRewardsBlock(rewards)
	if not (rewards and rewards:IsShown()) then
		return
	end
	local LAYOUT = ns.LAYOUT
	local heading = rewards.Header or QuestInfoRewardsHeader
	local hasMoney = rewards.MoneyFrame and rewards.MoneyFrame:IsShown()
	local pieces = { rewards:GetRegions() }
	for _, child in ipairs({ rewards:GetChildren() }) do
		pieces[#pieces + 1] = child
	end

	local moved = 0
	for _, piece in ipairs(pieces) do
		if piece:IsShown() and piece:GetNumPoints() > 0 then
			local point, relativeTo, relativePoint, _, y = piece:GetPoint(1)
			local relativeType = relativeTo and relativeTo.GetObjectType and relativeTo:GetObjectType()
			local hangsUnder = point == "TOPLEFT" and relativePoint == "BOTTOMLEFT"
			if piece:GetObjectType() == "Button" or relativeType == "Button" then
				moved = moved + ns.SpaceAroundRewardButtons(piece)
			elseif hangsUnder and heading and relativeTo == heading then
				moved = moved + SetSpaceAbove(piece, LAYOUT.HEADING_SPACE_BELOW)
			elseif hangsUnder and piece == rewards.XPFrame and relativeTo == rewards.ItemReceiveText then
				moved = moved + SetSpaceAbove(piece, hasMoney and LAYOUT.MONEY_EXPERIENCE_SPACE or LAYOUT.SPACE.LINE)
			elseif hangsUnder and y and math.abs(y + BLIZZARD_REWARD_LINE_GAP) < 0.5 then
				moved = moved + SetSpaceAbove(piece, LAYOUT.REWARD_LINE_SPACE)
			end
		end
	end
	if moved ~= 0 then
		rewards:SetHeight(rewards:GetHeight() + moved)
	end
end
