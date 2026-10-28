local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

-- Every client: the menu a right-click on a zone name in the quest list opens, acting through each client's Zone-Actions file.

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

-- Confirms with every gray quest listed by name; data is their quest IDs
StaticPopupDialogs.PRETTYWIDEQUESTLOG_ABANDON_GRAY = {
	text = "%s",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(_, questIDs)
		local count = ns.AbandonQuests(questIDs)
		if count == 1 then
			ns:PrintMessage(L["CHAT_ABANDONED_GRAY_ONE"])
		else
			ns:PrintMessage(L["CHAT_ABANDONED_GRAY"]:format(count))
		end
	end,
	showAlert = true,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- Confirms abandoning the zone's gray quests found as the menu opened, naming each with its level tag ("[30D] Name")
local function AbandonGrayQuests(quests)
	local titles, questIDs = {}, {}
	for _, quest in ipairs(quests) do
		titles[#titles + 1] = ns.LevelTitle(quest.level, quest.title, quest.suffix)
		questIDs[#questIDs + 1] = quest.questID
	end
	local confirm = #quests == 1 and L["ABANDON_GRAY_CONFIRM_ONE"] or L["ABANDON_GRAY_CONFIRM"]:format(#quests)
	StaticPopup_Show("PRETTYWIDEQUESTLOG_ABANDON_GRAY", confirm .. "\n\n" .. table.concat(titles, "\n"), nil, questIDs)
end

-- The tooltip on a zone name, saying a right-click opens this menu
function ns.ShowZoneMenuHint(owner)
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:AddLine(
		GetColor("INFO")
			.. L["ADDON_SHORT_NAME"]
			.. "|r "
			.. GetColor("SEPARATOR")
			.. "//|r "
			.. GetColor("TEXT")
			.. L["ZONE_MENU_ACTIONS_HINT"]
			.. "|r"
	)
	GameTooltip:Show()
end

function ns.HideZoneMenuHint(owner)
	if GameTooltip:IsOwned(owner) then
		GameTooltip:Hide()
	end
end

function ns.OpenZoneMenu(owner, zoneTitle)
	MenuUtil.CreateContextMenu(owner, function(_, root)
		root:CreateTitle(zoneTitle)

		--[[
			Counts only the quests the game lets you share, and shares those, one every ns.GetShareInterval()
			seconds. Left out when none can be shared; grayed out while solo and while a share is still going
		]]
		local inGroup = IsInGroup()
		local shareable = ns.ShareableZoneQuests(zoneTitle)
		if #shareable > 0 then
			local label = #shareable == 1 and L["SHARE_ZONE_QUEST"] or L["SHARE_ZONE_QUESTS"]:format(#shareable)
			local share = root:CreateButton(label, function()
				local questIDs = ns.ShareableZoneQuests(zoneTitle)
				if #questIDs == 1 then
					ns:PrintMessage(L["CHAT_SHARING_ZONE_ONE"]:format(zoneTitle))
				else
					ns:PrintMessage(L["CHAT_SHARING_ZONE"]:format(#questIDs, zoneTitle, ns.GetShareInterval()))
				end
				ns.ShareQuests(questIDs)
			end)
			share:SetEnabled(inGroup and not ns.sharingQuests)
			share:SetTooltip(function(tooltip)
				if not inGroup then
					GameTooltip_SetTitle(tooltip, ERR_NOT_IN_GROUP)
				elseif #shareable == 1 then
					GameTooltip_AddNormalLine(tooltip, L["SHARE_ZONE_QUEST_TOOLTIP"], true)
				else
					GameTooltip_AddNormalLine(
						tooltip,
						L["SHARE_ZONE_QUESTS_TOOLTIP"]:format(ns.GetShareInterval()),
						true
					)
				end
			end)
		end

		-- Always there, so players know it exists; grayed out, saying why, when the zone has no gray quests
		local grayQuests = ns.GrayQuests(zoneTitle)
		local abandonGray = root:CreateButton(L["ABANDON_GRAY_QUESTS"], function()
			AbandonGrayQuests(grayQuests)
		end)
		abandonGray:SetEnabled(#grayQuests > 0)
		if #grayQuests == 0 then
			abandonGray:SetTooltip(function(tooltip)
				GameTooltip_SetTitle(tooltip, L["ABANDON_GRAY_NONE"])
			end)
		end
		root:CreateButton(CANCEL, function() end)
	end)
end
