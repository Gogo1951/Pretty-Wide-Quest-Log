local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

-- A line for the player's own chat window, as ns:PrintMessage prints it: the short name, so lines stay short
function ns.BuildPrintLine(message)
	return GetColor("INFO")
		.. L["ADDON_SHORT_NAME"]
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
	short name. WoW Forever blocks raid-marker tokens in group and channel chat but allows them in whispers
	(as Good to Go found), so there the marker leads whispers only. Bodies can carry quest links, so pipes
	are kept: stripping them would break the links
]]
local function BuildSent(isWhisper, formatKey, ...)
	local body = L[formatKey]:format(...)
	local marker = (ns.FLAVOR ~= "Camelot" or isWhisper) and (ns.TARGET_MARKER .. " ") or ""
	return marker .. body .. " // " .. L["ADDON_SHORT_NAME"]
end

-- For group chat: no marker on WoW Forever
function ns:BuildAnnounceMessage(formatKey, ...)
	return BuildSent(false, formatKey, ...)
end

-- For a whisper: the marker on every client, WoW Forever included
function ns:BuildWhisperMessage(formatKey, ...)
	return BuildSent(true, formatKey, ...)
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

--[[
	A party member's name as a whisper takes it, exactly as Good to Go's Rank Watch whispers do: GetUnitName
	with the realm, which on WoW Forever is the whole name, first name and surname ("Snaptrap Mchunter"),
	as the first name alone reaches no one, and elsewhere the name, with the realm when it's another. The
	GUID's record stands in when the unit's name can't be read
]]
function ns.WhisperTarget(unit)
	local name = GetUnitName(unit, true)
	if ns.IsReadable(name) and type(name) == "string" and name ~= "" and name ~= UNKNOWNOBJECT then
		return name
	end
	local guid = UnitGUID(unit)
	if not (ns.IsReadable(guid) and guid) then
		return nil
	end
	local _, _, _, _, _, guidName, realm = GetPlayerInfoByGUID(guid)
	if not (ns.IsReadable(guidName, realm) and type(guidName) == "string" and guidName ~= "") then
		return nil
	end
	if type(realm) == "string" and realm ~= "" then
		return guidName .. "-" .. realm
	end
	return guidName
end

-- Builds the message and sends it; nothing is sent without a channel or a message
function ns:Announce(channel, target, formatKey, ...)
	if not channel then
		return
	end
	local message = BuildSent(channel == "WHISPER", formatKey, ...)
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
		return ns:BuildWhisperMessage(whisperKey, reference)
	end, questID, title)
end

-- The whisper for a quest, as sent
function ns.BuildShareWhisper(whisperKey, questID, title)
	return ns:BuildWhisperMessage(whisperKey, ns.ShareWhisperQuestReference(whisperKey, questID, title))
end

--------------------------------------------------------------------------------
-- Ask for Shares
--------------------------------------------------------------------------------

--[[
	Zone Info's Ask for Shares line (Zone-Info.lua), at most room bytes: each shareable quest nobody in the
	party has (partyCount), named as the announcements name one: Questie's quest link, then Questie's
	bracketed text, then its title in brackets; the first that still fits. Stops at the first quest none of
	them fits for, so the message is never cut short mid-name. nil with none
]]
function ns.BuildAskForSharesMessage(quests, room, partyCount)
	local references = {}
	local function Message(list)
		return L["ZONE_INFO_ASK_MESSAGE"]:format(table.concat(list, ", "))
	end
	for _, quest in ipairs(quests) do
		if quest.shareable and partyCount(quest.questID) == 0 then
			local choices = QuestReferences(quest.questID)
			choices[#choices + 1] = "[" .. quest.name .. "]"
			local fitted
			for _, reference in ipairs(choices) do
				references[#references + 1] = reference
				if #Message(references) <= room then
					fitted = true
					break
				end
				references[#references] = nil
			end
			if not fitted then
				break
			end
		end
	end
	return #references > 0 and Message(references) or nil
end

--------------------------------------------------------------------------------
-- Zone Share Notice
--------------------------------------------------------------------------------

-- What the player is told when new party members are missing count of their quests in a zone (Zone-Share-Offer.lua); Options shows it as its Example
function ns.BuildZoneShareNotice(count, zoneName)
	if count == 1 then
		return L["CHAT_ZONE_SHARE_NOTICE_ONE"]:format(zoneName)
	end
	return L["CHAT_ZONE_SHARE_NOTICE"]:format(count, zoneName)
end
