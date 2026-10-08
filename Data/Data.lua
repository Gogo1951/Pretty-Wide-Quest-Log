local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.ADDON_TITLE = ns.L["ADDON_TITLE"]
ns.SAVED_VARIABLES_NAME = "PrettyWideQuestLogDB"

-- The add-on this one replaced. Both hook the quest log, so they must not run together.
ns.PREDECESSOR_ADDON_NAME = "WideQuestLogPlus"

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

ns.URLS = {
	DISCORD = "https://discord.gg/eh8hKq992Q",
	GITHUB = "https://github.com/Gogo1951/Pretty-Wide-Quest-Log",
	CURSEFORGE = "https://www.curseforge.com/wow/addons/pretty-wide-quest-log",
	WAGO = "https://addons.wago.io/addons/pretty-wide-quest-log",
}

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

ns.PALETTE = {
	TITLE = "FFD100", -- Gold: Titles, Headers, Section Names, Field Titles
	INFO = "00BBFF", -- Blue: Interactions, Toggles, Links, Keybinds, Slash Commands
	BODY = "FFFFFF", -- White: Descriptions, Options Body Text
	HELP = "CCCCCC", -- Silver: Pro Tips, Helper Text
	TEXT = "FFFFFF", -- White: Messages, Values, Spell Names
	ON = "33CC33", -- Green: On
	OFF = "CC3333", -- Red: Off
	SEPARATOR = "AAAAAA", -- Gray: Separators, Dividers
	MUTED = "808080", -- Dark Gray: Meta-data, Version Numbers
}

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	Profiles = ADDON_NAME .. "_Profiles",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Options Layout Grid
--------------------------------------------------------------------------------

ns.OPTIONS_ROW_WIDTH = 3.4
ns.OPTIONS_LABEL_WIDTH = 2.1
ns.OPTIONS_CONTROL_WIDTH = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_LABEL_WIDTH
ns.OPTIONS_REMOVE_ICON_WIDTH = 0.25 -- the item lists' remove column, sized to its icon
ns.OPTIONS_SUB_INDENT_WIDTH = 0.115 -- the blank cell a sub-option row leads with

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

local LAYOUT = {}
ns.LAYOUT = LAYOUT

-- Window geometry shared by every client's quest log; x/y values are offsets from the window's top-left corner.

--[[
	Quest details are as wide as two columns of reward buttons (147px each, 1px apart), which can't
	shrink, with TEXT_MARGIN of parchment on the left, right and top
]]
LAYOUT.REWARD_COLUMNS_WIDTH = 147 + 1 + 147
LAYOUT.TEXT_MARGIN = 17

-- The classic art's parchment spans x 348-658; the window is widened by however much more it needs
local ART_PARCHMENT_LEFT, ART_PARCHMENT_RIGHT = 348, 658
LAYOUT.EXTRA_WIDTH = (LAYOUT.REWARD_COLUMNS_WIDTH + 2 * LAYOUT.TEXT_MARGIN) - (ART_PARCHMENT_RIGHT - ART_PARCHMENT_LEFT)

LAYOUT.BASE_WIDTH = 724 + LAYOUT.EXTRA_WIDTH
LAYOUT.BASE_HEIGHT = 513
LAYOUT.PANE_TOP = 75 -- Top of the quest list and the quest details
LAYOUT.PANE_INSET = 151 -- Vertical space the panes never occupy
LAYOUT.ROW_HEIGHT = 16

-- The quest list on the left, and the quest details 41px to its right
LAYOUT.LIST_LEFT = 19
LAYOUT.LIST_WIDTH = 300
LAYOUT.DETAIL_LEFT = LAYOUT.LIST_LEFT + LAYOUT.LIST_WIDTH + 41

LAYOUT.PARCHMENT_LEFT = ART_PARCHMENT_LEFT
LAYOUT.PARCHMENT_RIGHT = ART_PARCHMENT_RIGHT + LAYOUT.EXTRA_WIDTH
LAYOUT.PARCHMENT_TOP = 74

--[[
	Where the quest text goes: TEXT_MARGIN inside the parchment, and level with the first quest row of
	the list (one row below the top, under the first zone header)
]]
LAYOUT.CONTENT_LEFT = LAYOUT.PARCHMENT_LEFT + LAYOUT.TEXT_MARGIN
LAYOUT.CONTENT_WIDTH = LAYOUT.REWARD_COLUMNS_WIDTH
LAYOUT.CONTENT_TOP = LAYOUT.PANE_TOP + LAYOUT.ROW_HEIGHT

--[[
	Quest text, headings included, is set with lines LINE_HEIGHT times its font size apart. Blizzard
	leaves none between lines on Classic Era, which reads tight, and a little on WoW Forever; this makes
	both the same
]]
LAYOUT.LINE_HEIGHT = 1.2

--[[
	A heading sits close to the text it introduces and well clear of the text above, so it reads as the
	start of its section. Below a heading is about half the heading's own size: a little more under the
	quest's title than under the smaller Description and Rewards headings. Above Description and Rewards
	is HEADING_LINES_ABOVE lines of quest text, well clear of the blank line between two paragraphs.
	ns.SetTextSpacing works out QUEST_LINE (a line of quest text, in pixels), HEADING_SPACE_ABOVE and
	QUEST_ID_GAP once the quest text's font is known, as it differs between clients and languages
]]
LAYOUT.TITLE_SPACE_BELOW = 8
LAYOUT.HEADING_SPACE_BELOW = 6
LAYOUT.HEADING_LINES_ABOVE = 1.4
local BLIZZARD_HEADING_GAP = 5 -- What Blizzard leaves under a heading
LAYOUT.EXTRA_HEADING_GAP = LAYOUT.HEADING_SPACE_BELOW - BLIZZARD_HEADING_GAP

--[[
	Blizzard sets the quest's title and the Description and Rewards headings all in the same font. The
	section headings are this much smaller (18 to 15 in English) so the title reads as the one heading
	over them, while still a step above the quest text
]]
LAYOUT.SECTION_HEADING_SHRINK = 3

-- WoW Forever's Rewards heading sits 3px higher in its block than Description, so its gap is 3px more to match
LAYOUT.REWARDS_HEADING_RISE = 3

--[[
	Reward buttons sit this far under the line that introduces them ("You will be able to choose one of
	these rewards:"), and the next line ("You will also receive:") this far under them, clear of them
	like the rest of the text; Blizzard leaves them nearly touching
]]
LAYOUT.REWARD_BUTTONS_SPACE = 10

--[[
	Blizzard's money frames keep their last coin this far inside their right edge, so a money frame
	right-aligned to the text column sits this much further right
]]
LAYOUT.MONEY_RIGHT_PADDING = 13

--[[
	The quest ID sits under everything else in the quest details, QUEST_ID_LINES lines of quest text
	down (ns.SetTextSpacing sets QUEST_ID_GAP), right-aligned two spaces in from the edge of the text
	column like the other numbers, in the description's font a little smaller
]]
LAYOUT.QUEST_ID_LINES = 2
LAYOUT.QUEST_ID_FONT_SHRINK = 2

--[[
	Quest list rows: zone headers have their +/- at the left and their name after it; quest titles have
	a slot for the tracking mark in the same column as the +/-, there whether the quest is marked or not,
	and start just after it. The untracked eye fills its square edge to edge, unlike Blizzard's check, so
	a gap keeps it off the title
]]
LAYOUT.HEADER_TEXT_X = 20
LAYOUT.CHECK_X = 3
LAYOUT.CHECK_GAP = 4
LAYOUT.QUEST_TEXT_X = LAYOUT.CHECK_X + 16 + LAYOUT.CHECK_GAP

--[[
	The tracking mark in that slot: a teal check in front of each tracked quest, or with markUntracked
	on, where tracking everything is the norm, a red crossed-out eye in front of each quest that isn't,
	in the deep red of the zone headers' minus buttons (as bright as their highlight, so its thin lines
	still read)
]]
ns.TRACKING_MARKS = {
	tracked = { texture = "Interface/Buttons/UI-CheckBox-Check", r = 64 / 255, g = 224 / 255, b = 208 / 255 },
	untracked = {
		texture = "Interface/AddOns/" .. ADDON_NAME .. "/Includes/Images/PWQL_Untracked",
		r = 160 / 255,
		g = 16 / 255,
		b = 12 / 255,
	},
}

--[[
	Space above every zone header in the quest list except the first: half a row, so zones read as
	separate groups (about three times the space between two rows' text) without a full blank line
]]
LAYOUT.HEADER_GAP = LAYOUT.ROW_HEIGHT / 2

--[[
	Buttons along the bottom: the outer ones' offsets from the window's corners, and the size of the
	ones in between
]]
LAYOUT.BUTTON_BOTTOM = 54
LAYOUT.BUTTON_LEFT = 17
LAYOUT.BUTTON_RIGHT = 43
LAYOUT.BUTTON_WIDTH = 123
LAYOUT.BUTTON_HEIGHT = 21

--[[
	Expand All and Track All above the quest list, left to right from the quest log's own "All" spot.
	Each is at least as wide as a bottom button, and wider where a label needs it
]]
LAYOUT.LIST_BUTTONS_X = 74
LAYOUT.LIST_BUTTONS_Y = -53
LAYOUT.LABEL_PADDING = 32

-- Centre of the scroll bar slot to the right of the parchment
LAYOUT.DETAIL_SCROLL_SLOT_X = 673 + LAYOUT.EXTRA_WIDTH

--[[
	The drawn border stops short of the frame's own edges: the opaque part of Includes/Images/PWQL_BotRight stops
	176px into the piece and 211px down it. The resize grip sits GRIP_INSET inside that corner
]]
LAYOUT.ART_INSET_RIGHT = LAYOUT.BASE_WIDTH - (515 + LAYOUT.EXTRA_WIDTH + 176)
LAYOUT.ART_INSET_BOTTOM = 256 - 211 + 1
LAYOUT.GRIP_INSET = 4

-- A window dragged taller still leaves this much of the screen below it
LAYOUT.MINIMUM_BOTTOM_CLAMP = 20
