local _, ns = ...

--[[
	Objective lines, on both quest logs: a check for a finished objective and its count in a column of its
	own (ns.StyleObjective), and the inline icons and two-space inset other numbers share with them
]]

--[[
	Objective lines in the quest details: a green check for a finished objective (or
	a blank the same size, so the names line up), the objective's name, and its count ("8 / 8")
	right-aligned in a column of its own, two spaces in from the right edge of the text column
]]
local CHECK_TEXTURE = "Interface\\RaidFrame\\ReadyCheck-Ready"
local NO_CHECK_TEXTURE = "Interface\\Common\\spacer"

--[[
	The check (or the blank in its place) for a line in region's font, sized to the font in so many
	pixels, and CHECK_DROP of its size lower than the game would put it, which is high beside the
	text, so its foot sits on the line the letters sit on. Left to size itself (":0"), it came out small
	and riding high beside the text in ElvUI's quest font. The quest chain's turned-in parts use it too
	(Quest-Chain.lua). ns.InlineIcon does the same for any texture, as the route's corpse line's gravestone
]]
local CHECK_DROP = 0.25

--[[
	coords, where given, crop the texture as SetTexCoord would ({ left, right, top, bottom }, 0 to 1); the
	inline form takes them in texels of a stated size, which only matter as a share of it
]]
local COORD_SCALE = 1024

function ns.InlineIcon(region, texture, coords)
	local _, size = region:GetFont()
	size = size or 12
	local pixels = math.floor(size + 0.5)
	local drop = math.floor(size * CHECK_DROP + 0.5)
	if coords then
		return format(
			"|T%s:%d:%d:0:%d:%d:%d:%d:%d:%d:%d|t",
			texture,
			pixels,
			pixels,
			-drop,
			COORD_SCALE,
			COORD_SCALE,
			coords[1] * COORD_SCALE,
			coords[2] * COORD_SCALE,
			coords[3] * COORD_SCALE,
			coords[4] * COORD_SCALE
		)
	end
	return format("|T%s:%d:%d:0:%d|t", texture, pixels, pixels, -drop)
end

function ns.CheckIcon(region, checked)
	return ns.InlineIcon(region, checked and CHECK_TEXTURE or NO_CHECK_TEXTURE)
end
local COUNT_GAP = ns.LAYOUT.SPACE.NEAR -- Between a name and its count

--[[
	Body text wraps short of the column's edge, so a number flush against it (an objective's count, gold,
	experience, the quest ID) looks like it runs past the text. Those numbers end two spaces in instead, measured in
	the font given, on a hidden FontString: a pair of spaces between two zeros, less the zeros alone,
	since a FontString may not draw trailing spaces
]]
local measure = UIParent:CreateFontString(nil, "ARTWORK")
measure:Hide()

function ns.TwoSpacesWide(fontSource)
	local fontObject = fontSource:GetFontObject()
	if fontObject then
		measure:SetFontObject(fontObject)
	else
		measure:SetFont(fontSource:GetFont())
	end
	measure:SetText("0  0")
	local spaced = measure:GetStringWidth()
	measure:SetText("00")
	return spaced - measure:GetStringWidth()
end

--[[
	"8/8 Ragefire Trogg slain" (WoW Forever) or "Ragefire Trogg slain: 8/8" (Classic). Anything else, a
	reputation objective say, is all name
]]
local function SplitObjective(text)
	local have, need, name = text:match("^%s*(%d+)%s*/%s*(%d+)%s+(.+)$")
	if not have then
		name, have, need = text:match("^(.-):%s*(%d+)%s*/%s*(%d+)%s*$")
	end
	if not have then -- zhCN and zhTW write a full-width colon
		name, have, need = text:match("^(.-)：%s*(%d+)%s*/%s*(%d+)%s*$")
	end
	if have then
		return name, format("%s / %s", have, need)
	end
	return text
end

local objectiveCounts = {} -- Count column for each objective line, by line

-- Skins (ElvUI) recolor the lines in hooks that may run after styling, so the counts match them again a frame later
local recolorPending
local function RecolorCounts()
	recolorPending = nil
	for line, count in pairs(objectiveCounts) do
		if count:IsShown() then
			count:SetTextColor(line:GetTextColor())
		end
	end
end

-- Hides every count, before the objective lines showing now are styled
function ns.ClearObjectiveCounts()
	for _, count in pairs(objectiveCounts) do
		count:Hide()
	end
end

-- Gives a FontString the same font and line spacing as another, keeping its own color
local function MatchFont(region, source)
	local red, green, blue, alpha = region:GetTextColor()
	local fontObject = source:GetFontObject()
	if fontObject then
		region:SetFontObject(fontObject)
	else
		region:SetFont(source:GetFont())
	end
	region:SetSpacing(source:GetSpacing())
	region:SetTextColor(red, green, blue, alpha)
end

--[[
	Styles an objective line (a FontString: Blizzard's in the Classic quest log, the window's own on WoW
	Forever and Mists), whose left edge is the left edge of a text column width wide. text and finished
	are the objective's, from GetQuestLogLeaderBoard(). Blizzard draws objectives a size smaller than the
	rest of the quest text; they take fontSource's font (the description's) instead
]]
function ns.StyleObjective(line, text, finished, width, fontSource)
	local name, countText = SplitObjective(text or "")
	MatchFont(line, fontSource)
	line:SetText(ns.CheckIcon(line, finished) .. " " .. name)

	local count = objectiveCounts[line]
	if not count then
		count = line:GetParent():CreateFontString(nil, "ARTWORK")
		count:SetJustifyH("RIGHT")
		objectiveCounts[line] = count
	end
	if not countText then
		line:SetWidth(width)
		return
	end

	MatchFont(count, line)
	count:SetTextColor(line:GetTextColor())
	if not recolorPending then
		recolorPending = true
		C_Timer.After(0, RecolorCounts)
	end
	local inset = ns.TwoSpacesWide(count)
	count:SetText(countText)
	count:ClearAllPoints()
	count:SetPoint("TOPRIGHT", line, "TOPLEFT", width - inset, 0)
	count:Show()
	line:SetWidth(width - inset - count:GetStringWidth() - COUNT_GAP)
end
