local _, ns = ...

--[[
	Quest text's styling: the section heading font, the line spacing quest text takes, Blizzard's own style
	kept to put back, the QuestInfo pieces the quest giver window cleanup restyles, and the room left under
	a quest giver page's last piece
]]

--[[
	The Description and Rewards headings: the title's font, LAYOUT.SECTION_HEADING_SHRINK smaller, or
	the title's size under ElvUI, whose plain title font is already small beside Blizzard's.
	Skins (ElvUI) set QuestTitleFont after the headings are styled, and again when their font options
	change, so it follows every change to QuestTitleFont's font and shadow
]]
local sectionHeadingFont = CreateFont("PrettyWideQuestLogSectionHeadingFont")
local headingShrink = C_AddOns.IsAddOnLoaded("ElvUI") and 0 or ns.LAYOUT.SECTION_HEADING_SHRINK

local function SyncSectionHeadingFont()
	local file, size, flags = QuestTitleFont:GetFont()
	if file and size then
		sectionHeadingFont:CopyFontObject(QuestTitleFont)
		sectionHeadingFont:SetFont(file, size - headingShrink, flags)
	end
end
SyncSectionHeadingFont()
for _, method in ipairs({ "SetFont", "SetShadowColor", "SetShadowOffset" }) do
	hooksecurefunc(QuestTitleFont, method, SyncSectionHeadingFont)
end

-- Sets a FontString's font object, keeping its color
local function SetFontObjectKeepingColor(region, fontObject)
	local red, green, blue, alpha = region:GetTextColor()
	region:SetFontObject(fontObject)
	region:SetTextColor(red, green, blue, alpha)
end

-- Each FontString's font and line spacing as Blizzard left it, kept the first time it's restyled
local blizzardStyle = {}

function ns.RememberBlizzardStyle(region)
	if blizzardStyle[region] then
		return
	end
	local file, size, flags = region:GetFont()
	blizzardStyle[region] = {
		fontObject = region:GetFontObject(),
		file = file,
		size = size,
		flags = flags,
		spacing = region:GetSpacing(),
	}
end

-- Puts a remembered FontString's font and line spacing back, keeping its color
function ns.RestoreBlizzardStyle(region)
	local style = blizzardStyle[region]
	if not style then
		return
	end
	local red, green, blue, alpha = region:GetTextColor()
	if style.fontObject then
		region:SetFontObject(style.fontObject)
	else
		region:SetFont(style.file, style.size, style.flags)
	end
	region:SetTextColor(red, green, blue, alpha)
	region:SetSpacing(style.spacing)
end

--[[
	Sets a FontString of quest text LAYOUT.LINE_SPACING between lines, and with sectionHeading true gives
	it the section heading font first
]]
function ns.StyleQuestText(region, sectionHeading)
	if sectionHeading and region:GetFontObject() ~= sectionHeadingFont then
		SetFontObjectKeepingColor(region, sectionHeadingFont)
	end
	region:SetSpacing(ns.LAYOUT.LINE_SPACING)
end

--[[
	QuestInfo pieces, shared on every client by the quest giver window's detail and reward pages, and on
	WoW Forever and Mists by Blizzard's own quest details (the map's on WoW Forever, the quest log's on
	Mists) too. They follow the quest giver window cleanup (ns.ApplyQuestGiverCleanup), going back to
	Blizzard's while it's off. A piece a client lacks is skipped
]]
local QUEST_INFO_TEXT = {
	"QuestInfoTitleHeader",
	"QuestInfoObjectivesText",
	"QuestInfoDescriptionText",
	"QuestInfoRewardText",
}
local QUEST_INFO_HEADINGS = { "QuestInfoObjectivesHeader", "QuestInfoDescriptionHeader" }

-- Calls back with each QuestInfo piece this client has, and whether it's a section heading
local function EachQuestInfoPiece(callback)
	for _, name in ipairs(QUEST_INFO_TEXT) do
		if _G[name] then
			callback(_G[name], false)
		end
	end
	for _, name in ipairs(QUEST_INFO_HEADINGS) do
		if _G[name] then
			callback(_G[name], true)
		end
	end
	local rewards = QuestInfoRewardsFrame
	if rewards then
		for _, region in pairs({ rewards.ItemChooseText, rewards.ItemReceiveText }) do -- pairs, so any this client lacks drop out
			callback(region, false)
		end
		if rewards.Header then
			callback(rewards.Header, true)
		end
	end
end

local function StyleQuestInfoPiece(region, sectionHeading)
	ns.RememberBlizzardStyle(region)
	ns.StyleQuestText(region, sectionHeading)
end

function ns.StyleQuestInfo()
	EachQuestInfoPiece(StyleQuestInfoPiece)
end

function ns.RestoreQuestInfoStyle()
	EachQuestInfoPiece(ns.RestoreBlizzardStyle)
end

--[[
	An empty piece PAGE_TOP tall under region (the quest ID at the end of a quest giver page), showing
	whenever region does. A scroll frame scrolls as far as the last thing on its page, so this leaves the
	page's own margin under region when scrolled to the bottom, rather than region against the edge.
	Returns it, for a region that moves to another parent
]]
function ns.CreateRoomBelow(parent, region)
	local room = parent:CreateTexture(nil, "BACKGROUND")
	room:SetColorTexture(0, 0, 0, 0)
	room:SetSize(1, ns.LAYOUT.PAGE_TOP)
	room:SetPoint("TOPRIGHT", region, "BOTTOMRIGHT")
	room:SetShown(region:IsShown())
	hooksecurefunc(region, "Show", function()
		room:Show()
	end)
	hooksecurefunc(region, "Hide", function()
		room:Hide()
	end)
	return room
end
