local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

-- A 6-character hex color as r, g, b from 0 to 1, for the APIs that take numbers
local function HexToRGB(hex)
	return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end
ns.HexToRGB = HexToRGB

local COLORS, COLORS_RGB = {}, {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = "|cff" .. hex
	COLORS_RGB[key] = { HexToRGB(hex) }
end

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end

function ns.GetColorRGB(key)
	return unpack(COLORS_RGB[key] or COLORS_RGB.TEXT)
end

--------------------------------------------------------------------------------
-- Numbers
--------------------------------------------------------------------------------

--[[
	A whole number with its thousands grouped the way this locale writes them, "3,950" in English.
	BreakUpLargeNumbers can leave them ungrouped, so the add-on groups them itself
]]
local THOUSANDS_SEPARATOR = LARGE_NUMBER_SEPERATOR or ","

function ns.FormatNumber(number)
	local digits = tostring(math.floor(number))
	local head = #digits % 3
	if head == 0 then
		head = 3
	end
	local groups = { digits:sub(1, head) }
	for start = head + 1, #digits, 3 do
		groups[#groups + 1] = digits:sub(start, start + 2)
	end
	return table.concat(groups, THOUSANDS_SEPARATOR)
end

--------------------------------------------------------------------------------
-- Secret Values
--------------------------------------------------------------------------------

-- Whether none of the values given is a secret value, which WoW Forever can hand back in combat and nothing may test
function ns.IsReadable(...)
	if not issecretvalue then
		return true
	end
	for index = 1, select("#", ...) do
		if issecretvalue((select(index, ...))) then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------
-- Questie
--------------------------------------------------------------------------------

function ns.ImportQuestieModule(name)
	if not QuestieLoader then
		return
	end
	local loaded, module = pcall(QuestieLoader.ImportModule, QuestieLoader, name)
	return loaded and type(module) == "table" and module or nil
end

--[[
	Questie's quest log, keyed by quest ID, or nil when there's none to read. Questie 12.6.3 moved it from
	QuestiePlayer.currentQuestlog (each value the quest) to the ActiveQuests module (each value an
	acceptance, the quest under .quest, nil for a quest Questie's database lacks). The second return says
	which. ImportModule hands back an empty table for a module it doesn't have, so GetAll is the test
]]
function ns.QuestieLogEntries()
	local activeQuests = ns.ImportQuestieModule("ActiveQuests")
	if activeQuests and type(activeQuests.GetAll) == "function" then
		local loaded, log = pcall(activeQuests.GetAll)
		if loaded and type(log) == "table" then
			return log, true
		end
	end
	local player = ns.ImportQuestieModule("QuestiePlayer")
	local log = player and player.currentQuestlog
	return type(log) == "table" and log or nil, false
end

--------------------------------------------------------------------------------
-- VoiceOver
--------------------------------------------------------------------------------

--[[
	VoiceOver puts a play button in front of quest titles in the quest log, and so does Spoken Quests, its
	fork, which keeps the VoiceOver global. Returns that global while either is loaded with its quest log
	part switched on, else nil. rawget, as the global falls back to _G for anything it doesn't hold itself
]]
local function IsVoiceOverLoaded()
	for _, name in ipairs(ns.VOICEOVER_ADDON_NAMES) do
		if C_AddOns.IsAddOnLoaded(name) then
			return true
		end
	end
	return false
end

function ns.GetVoiceOver()
	if not IsVoiceOverLoaded() then
		return nil
	end
	local voiceOver = type(VoiceOver) == "table" and VoiceOver
	if
		not (
			voiceOver
			and rawget(voiceOver, "QuestOverlayUI")
			and rawget(voiceOver, "DataModules")
			and rawget(voiceOver, "Enums")
		)
	then
		return nil
	end
	local addon = rawget(voiceOver, "Addon")
	if addon and addon.IsPartOn and not addon:IsPartOn() then
		return nil
	end
	return voiceOver
end

--------------------------------------------------------------------------------
-- Quest Sharing
--------------------------------------------------------------------------------

-- Seconds between Share Quests' shares: the Quality of Life panel's setting, or the default while that switch is off
function ns.GetShareInterval()
	local profile = ns.db.profile
	return profile.enableQualityOfLife and profile.shareInterval or ns.DATABASE_DEFAULTS.profile.shareInterval
end

-- Says on hover why a Share Quest button is grayed out when the player isn't in a party; hooked, as Classic's is Blizzard's
function ns.ExplainShareButton(button)
	button:SetMotionScriptsWhileDisabled(true)
	button:HookScript("OnEnter", function(self)
		if not self:IsEnabled() and not IsInGroup() then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip_SetTitle(GameTooltip, ERR_NOT_IN_GROUP)
			GameTooltip:Show()
		end
	end)
	button:HookScript("OnLeave", GameTooltip_Hide)
end
