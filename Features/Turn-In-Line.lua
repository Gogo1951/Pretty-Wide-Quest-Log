local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Ready to Turn In
--------------------------------------------------------------------------------

--[[
	A line centered in the bottom row, between Abandon Quest and Share Quest, totaling the XP and gold
	waiting in quests ready to turn in (just the gold at the level cap, where quest XP stops). Both come
	from Questie's quest data (its QuestXP module), so the line is hidden while Questie isn't loaded.
	Hovering it lists each quest under its zone
]]
local questXP
local function QuestieXP()
	questXP = questXP or ns.ImportQuestieModule("QuestXP")
	if
		questXP
		and type(questXP.GetQuestLogRewardXP) == "function"
		and type(questXP.GetQuestRewardMoney) == "function"
	then
		return questXP
	end
end

-- "12,345 XP / 5g 12s", leaving out either side that's zero
local function RewardText(xp, money)
	local parts = {}
	if xp > 0 then
		parts[#parts + 1] = L["TURN_IN_XP"]:format(ns.FormatNumber(xp))
	end
	if money > 0 then
		parts[#parts + 1] = GetMoneyString(money)
	end
	return table.concat(parts, L["TURN_IN_SEPARATOR"])
end

--[[
	The list is long and opens over the quest text, so it gets a tooltip of its own with a solid
	background, set after each Show since showing restores the see-through style
]]
local turnInTooltip = CreateFrame("GameTooltip", "PrettyWideQuestLogTurnInTooltip", UIParent, "GameTooltipTemplate")

local function MakeOpaque(tooltip)
	local nineSlice = tooltip.NineSlice
	if nineSlice and nineSlice.GetCenterColor then
		local r, g, b = nineSlice:GetCenterColor()
		nineSlice:SetCenterColor(r, g, b, 1)
	end
	local backdrop = tooltip.backdrop -- A skin's own backdrop, such as ElvUI's
	if backdrop and backdrop.GetBackdropColor then
		local r, g, b = backdrop:GetBackdropColor()
		backdrop:SetBackdropColor(r, g, b, 1)
	end
end

-- The title, then each zone after a gap: its name in gold, its quests and their rewards in white
local function ShowTurnInTooltip(self)
	turnInTooltip:SetOwner(self, "ANCHOR_BOTTOM")
	turnInTooltip:AddLine(L["TURN_IN_TOOLTIP"])
	turnInTooltip:AddLine(" ")
	for _, zone in ipairs(self.zones) do
		turnInTooltip:AddLine(" ")
		turnInTooltip:AddLine(zone.name, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		for _, quest in ipairs(zone.quests) do
			turnInTooltip:AddDoubleLine(quest.title, RewardText(quest.xp, quest.money), 1, 1, 1, 1, 1, 1)
		end
	end
	turnInTooltip:Show()
	MakeOpaque(turnInTooltip)
end

local function HideTurnInTooltip()
	turnInTooltip:Hide()
end

-- Returns the line; fill it with ns.UpdateTurnInLine
function ns.CreateTurnInLine(parent)
	local line = CreateFrame("Frame", nil, parent)
	line.Text = line:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	line.Text:SetPoint("RIGHT")
	line:SetScript("OnEnter", ShowTurnInTooltip)
	line:SetScript("OnLeave", HideTurnInTooltip)
	line:Hide()
	return line
end

--[[
	Centered in the bottom row, in the gap between Abandon Quest and Share Quest. Placed when it first
	shows, as on Classic Era and TBC Classic-Quest-Log.lua makes those buttons after Classic-Quest-List.lua
	makes the line (on WoW Forever, Forever-Quest-Log.lua makes them first)
]]
local function PlaceTurnInLine(line)
	if line.placed then
		return
	end
	line.placed = true
	local gap = CreateFrame("Frame", nil, line:GetParent())
	gap:SetPoint("TOPLEFT", ns.abandonButton, "TOPRIGHT")
	gap:SetPoint("BOTTOMRIGHT", ns.shareButton, "BOTTOMLEFT")
	line:SetPoint("CENTER", gap)
end

--[[
	readyQuests: { questID, title, zone } for each quest ready to turn in, in list order. Zones keep the
	order their first quest comes in; quests outside any zone go under "Other"
]]
function ns.UpdateTurnInLine(line, readyQuests)
	local source = QuestieXP()
	if not source or #readyQuests == 0 then
		line:Hide()
		return
	end
	local atCap = UnitLevel("player") >= GetMaxPlayerLevel()
	local totalXP, totalMoney = 0, 0
	local zones, zoneByName = {}, {}
	for _, ready in ipairs(readyQuests) do
		local xp = 0
		if not atCap then
			local found, value = pcall(source.GetQuestLogRewardXP, source, ready.questID)
			xp = found and type(value) == "number" and value or 0
		end
		local found, value = pcall(source.GetQuestRewardMoney, ready.questID)
		local money = found and type(value) == "number" and value or 0
		if xp > 0 or money > 0 then
			totalXP, totalMoney = totalXP + xp, totalMoney + money
			local name = ready.zone or OTHER
			local zone = zoneByName[name]
			if not zone then
				zone = { name = name, quests = {} }
				zoneByName[name] = zone
				zones[#zones + 1] = zone
			end
			zone.quests[#zone.quests + 1] = { title = ready.title, xp = xp, money = money }
		end
	end
	if #zones == 0 then
		line:Hide()
		return
	end
	line.zones = zones
	line.Text:SetText(L["TURN_IN_SUMMARY"]:format(RewardText(totalXP, totalMoney)))
	line:SetSize(line.Text:GetStringWidth(), line.Text:GetStringHeight())
	PlaceTurnInLine(line)
	line:Show()
end
