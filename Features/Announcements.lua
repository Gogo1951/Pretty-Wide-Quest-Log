local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

function ns:PrintMessage(message)
	print(
		GetColor("INFO")
			.. L["ADDON_TITLE"]
			.. "|r "
			.. GetColor("SEPARATOR")
			.. "//"
			.. "|r "
			.. GetColor("TEXT")
			.. message
			.. "|r"
	)
end

--[[
	A message for other players, not yet sent: the add-on's marker, its short name, so a whisper or a
	line in group chat isn't half name (README-Notes), and the body from L[formatKey]. WoW Forever blocks raid-marker tokens in
	chat, so the marker is left off there. Bodies can carry quest links, so pipes are kept: stripping them
	would break the links
]]
function ns:BuildAnnounceMessage(formatKey, ...)
	local body = L[formatKey]:format(...)
	local marker = ns.FLAVOR ~= "Camelot" and (ns.TARGET_MARKER .. " ") or ""
	return marker .. L["ADDON_SHORT"] .. " // " .. body
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
