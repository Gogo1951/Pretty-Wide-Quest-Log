local _, ns = ...
local L = ns.L

--[[
	How both quest logs name a quest: its title in the list, tagged with its level and kind, the legend for
	those tags, and its quest ID. Its objective lines are drawn in Quest-Objectives.lua, its text's styling
	is in Quest-Info-Style.lua, and its rewards in Quest-Rewards.lua
]]

--------------------------------------------------------------------------------
-- Quest Text
--------------------------------------------------------------------------------

--[[
	Letters after the level in the quest list, by quest tag. Elite quests without a tag of their own get E.
	Tag 1 is Elite on Classic Era and WoW Forever but Group on TBC, so the tags live in each flavor's folder
	(ns.QUEST_TAG_SUFFIXES)
]]
local QUEST_TAG_SUFFIX = {}
for tagID, kind in pairs(ns.QUEST_TAG_SUFFIXES) do
	QUEST_TAG_SUFFIX[tagID] = L["QUEST_SUFFIX_" .. kind]
end
local ELITE_SUFFIX = L["QUEST_SUFFIX_ELITE"]

function ns.QuestSuffix(tagID, isElite)
	return (tagID and QUEST_TAG_SUFFIX[tagID]) or (isElite and ELITE_SUFFIX) or ""
end

--[[
	"Letters after the level: D dungeon, R raid, E elite, P PvP.": each letter this client can show, with
	what it stands for, for the Show Quest Levels tooltips. E is always in, as an elite quest without a tag
	of its own gets it on any client
]]
local LEGEND_ORDER = { "DUNGEON", "RAID", "GROUP", "ELITE", "PVP" }

local questLevelLegend
do
	local shown = { ELITE = true }
	for _, kind in pairs(ns.QUEST_TAG_SUFFIXES) do
		shown[kind] = true
	end
	local entries = {}
	for _, kind in ipairs(LEGEND_ORDER) do
		if shown[kind] then
			entries[#entries + 1] =
				L["QUEST_LEVEL_LEGEND_ENTRY"]:format(L["QUEST_SUFFIX_" .. kind], L["QUEST_TYPE_" .. kind])
		end
	end
	questLevelLegend = L["QUEST_LEVEL_LEGEND"]:format(table.concat(entries, L["LIST_SEPARATOR"]))
end

function ns.QuestLevelLegend()
	return questLevelLegend
end

-- "[13]", or "[13D]" for a dungeon quest, and so on
function ns.LevelTag(level, suffix)
	return format("[%d%s]", level or 0, suffix or "")
end

-- "[13] Quest Name", or "[13D] Quest Name" for a dungeon quest, and so on
function ns.LevelTitle(level, title, suffix)
	return ns.LevelTag(level, suffix) .. " " .. (title or "")
end

-- A quest's line in the quest list: tagged as above while showQuestLevels is on, else the title alone
function ns.QuestListTitle(level, title, suffix)
	if ns.db.profile.showQuestLevels then
		return ns.LevelTitle(level, title, suffix)
	end
	return title or ""
end

local function QuestIDText(questID)
	return format(L["QUEST_ID"], questID)
end

-- A quest ID and its chain link, if it has one, in source's color
local function ColorQuestID(text, source)
	local r, g, b = source:GetTextColor()
	text:SetTextColor(r, g, b)
	local label = QuestIDText(text.questID)
	if text.linksToWowhead then
		label =
			format("|T%s:0:0:0:0:32:32:0:32:0:32:%d:%d:%d|t %s", ns.WOWHEAD_LINK_ICON, r * 255, g * 255, b * 255, label)
	end
	text:SetText(label)
end

--[[
	Shows a quest ID in a FontString, in the same font and color as source (the description) but
	smaller. One that links to Wowhead starts with a chain link, in the same color. Skins (ElvUI) recolor
	the description in hooks that may run after this, so the first quest shown would keep Blizzard's
	parchment color. It follows each later recoloring of source instead
]]
function ns.StyleQuestID(text, questID, source)
	local file, size, flags = source:GetFont()
	if file and size then
		text:SetFont(file, size - ns.LAYOUT.QUEST_ID_FONT_SHRINK, flags)
	end
	text.questID = questID
	ColorQuestID(text, source)
	if not text.followsSourceColor then
		text.followsSourceColor = true
		hooksecurefunc(source, "SetTextColor", function()
			ColorQuestID(text, source)
		end)
	end
end
