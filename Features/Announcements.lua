local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

-- A line for the player's own chat window, as ns:PrintMessage prints it
function ns.BuildPrintLine(message)
	return GetColor("INFO")
		.. L["ADDON_TITLE"]
		.. "|r "
		.. GetColor("SEPARATOR")
		.. "//"
		.. "|r "
		.. GetColor("TEXT")
		.. message
		.. "|r"
end

function ns:PrintMessage(message)
	print(ns.BuildPrintLine(message))
end

--[[
	What sharing an area's quests prints: none can be shared, one, or how many at the pace
	ns.GetShareInterval() sets. Share Quests, the dungeon share and their Options Examples all print it
]]
function ns.BuildSharePrint(count, areaName)
	if count == 0 then
		return L["CHAT_SHARING_ZONE_NONE"]:format(areaName)
	elseif count == 1 then
		return L["CHAT_SHARING_ZONE_ONE"]:format(areaName)
	end
	return L["CHAT_SHARING_ZONE"]:format(count, areaName, ns.GetShareInterval())
end

--[[
	A message for other players, not yet sent: the add-on's marker, the body from L[formatKey], then its
	short name. WoW Forever blocks raid-marker tokens in chat, so the marker is left off there. Bodies can
	carry quest links, so pipes are kept: stripping them would break the links
]]
function ns:BuildAnnounceMessage(formatKey, ...)
	local body = L[formatKey]:format(...)
	local marker = ns.FLAVOR ~= "Camelot" and (ns.TARGET_MARKER .. " ") or ""
	return marker .. body .. " // " .. L["ADDON_SHORT_NAME"]
end

-- The group's chat: instance group, then raid, then party; nil while solo, so ns:Announce sends nothing
function ns:GetGroupChatChannel()
	if LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid() then
		return "RAID"
	elseif IsInGroup() then
		return "PARTY"
	end
end

-- Builds the message and sends it; nothing is sent without a channel or a message
function ns:Announce(channel, target, formatKey, ...)
	if not channel then
		return
	end
	local message = ns:BuildAnnounceMessage(formatKey, ...)
	if not message then
		return
	end
	C_ChatInfo.SendChatMessage(message, channel, nil, target)
end

--------------------------------------------------------------------------------
-- Naming Quests
--------------------------------------------------------------------------------

-- Cuts text to at most maxBytes without splitting a character, the chat limit being in bytes
local function TrimToBytes(text, maxBytes)
	if #text <= maxBytes then
		return text
	end
	local cut = text:sub(1, math.max(maxBytes, 0))
	return (cut:gsub("[\192-\255][\128-\191]*$", ""))
end

--[[
	The ways a message can name a quest, best first: Questie's quest link (the game's own, clickable for
	anyone), then Questie's bracketed text, which Questie turns into a link for players who run it
]]
local function QuestReferences(questID)
	local references = {}
	local questieLink = ns.ImportQuestieModule("QuestieLink")
	for _, name in ipairs({ "GetNativeQuestLinkStringById", "GetQuestLinkStringById" }) do
		if questieLink and type(questieLink[name]) == "function" then
			local found, reference = pcall(questieLink[name], questID)
			if found and type(reference) == "string" and reference ~= "" then
				references[#references + 1] = reference
			end
		end
	end
	return references
end

--[[
	How a message names a quest, build(reference) being the message with it: the best way that fits the
	chat limit; without Questie, or when nothing else fits, its title in brackets, shortened if need be,
	so the message is never rejected. The dungeon announcement names its quests this way too
]]
function ns.FittingQuestReference(build, questID, title)
	for _, reference in ipairs(QuestReferences(questID)) do
		if #build(reference) <= ns.CHAT_MESSAGE_MAX_LENGTH then
			return reference
		end
	end
	local reference = "[" .. title .. "]"
	local over = #build(reference) - ns.CHAT_MESSAGE_MAX_LENGTH
	if over > 0 then
		reference = "[" .. TrimToBytes(title, #title - over - 3) .. "...]"
	end
	return reference
end

-- How the whisper names a quest
function ns.ShareWhisperQuestReference(whisperKey, questID, title)
	return ns.FittingQuestReference(function(reference)
		return ns:BuildAnnounceMessage(whisperKey, reference)
	end, questID, title)
end

-- The whisper for a quest, as sent
function ns.BuildShareWhisper(whisperKey, questID, title)
	return ns:BuildAnnounceMessage(whisperKey, ns.ShareWhisperQuestReference(whisperKey, questID, title))
end
