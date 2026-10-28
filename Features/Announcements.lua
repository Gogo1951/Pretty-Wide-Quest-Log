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

-- The quest log window's title: the print line's colors, the other way round ("Quest Log // PWQL")
function ns.BuildWindowTitle()
	return GetColor("TEXT")
		.. QUEST_LOG
		.. "|r "
		.. GetColor("SEPARATOR")
		.. "//"
		.. "|r "
		.. GetColor("INFO")
		.. L["ADDON_SHORT_NAME"]
		.. "|r"
end

function ns:PrintMessage(message)
	print(ns.BuildPrintLine(message))
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
