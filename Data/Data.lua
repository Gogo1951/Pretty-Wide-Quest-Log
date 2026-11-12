local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.ADDON_TITLE = ns.L["ADDON_TITLE"]
-- A fresh table: Wide Quest Log Plus's settings stay in its own, which this add-on can't read, so none carry over
ns.SAVED_VARIABLES_NAME = "PrettyWideQuestLogDB"

-- The add-on this one replaced. Both hook the quest log, so they must not run together.
ns.PREDECESSOR_ADDON_NAME = "WideQuestLogPlus"

--[[
	Questie's data powers the map, the quest chain and the XP to turn in. Without it, a chat line says so
	this long after login, once the welcome lines have scrolled past
]]
ns.QUESTIE_ADDON_NAME = "Questie"
ns.QUESTIE_NOTICE_DELAY = 20

-- VoiceOver and Spoken Quests, its fork, which keeps the VoiceOver global (ns.GetVoiceOver)
ns.VOICEOVER_ADDON_NAMES = { "AI_VoiceOver", "Spoken_Quests" }

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

ns.LINKS = {
	DISCORD = "https://discord.gg/eh8hKq992Q",
	GITHUB = "https://github.com/Gogo1951/Pretty-Wide-Quest-Log",
	CURSEFORGE = "https://www.curseforge.com/wow/addons/pretty-wide-quest-log",
	WAGO = "https://addons.wago.io/addons/pretty-wide-quest-log",
}

-- The chain link before a quest ID that opens its Wowhead page: white, so it takes the quest ID's color
ns.WOWHEAD_LINK_ICON = "Interface/AddOns/" .. ADDON_NAME .. "/Includes/Images/PWQL_Link"

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
	ARROW_ON_COURSE = "00FF00", -- Green: The Quest Arrow Pointing Ahead
	ARROW_TURN = "FFFF00", -- Yellow: The Quest Arrow Pointing to the Side
	ARROW_WRONG_WAY = "FF3333", -- Red: The Quest Arrow Pointing Behind
	ROUTE_LINE = "333333", -- Dark Gray: The Route's Line, Plain on the Yellow Maps
	ROUTE_ALERT_RING = "FF3333", -- Red: A Marker's Ring for a Dungeon Objective
	ROUTE_IGNORED_RING = "CCCCCC", -- Light Gray: A Marker's Ring for an Ignored Objective
	ROUTE_PARTY_RING = "FFFFFF", -- White: A Marker's Ring for a Party Member's Objective, and Join Up with Group's
	ROUTE_MEET = "FFD100", -- Gold: Join Up with Group's Disc, Under the Quest Log's Blue Party Icon
	ROUTE_ESCORT = "33CC33", -- Green: An Escort Quest's Pick-Up Marker, One to Leave for Later
	ROUTE_PREDICTED = "808080", -- Gray: A Marker's Disc for an Objective of a Quest Not Picked Up Yet
	ROUTE_FLIGHT = "33CC33", -- Green: A Flight Path's Marker, a Flight Master Not Yet Talked To
	QUEST_TIMER_LOW = "FF3333", -- Red: A Timed Quest's Last Minute on the Quest Arrow
	PARCHMENT_GAIN = "1D6B1D", -- Deep Green: A Skin's Experience Share, Read on the Parchment
}

ns.CLASS_COLORS = {
	DEATHKNIGHT = "C41E3A",
	DRUID = "FF7C0A",
	HUNTER = "AAD372",
	MAGE = "3FC7EB",
	MONK = "00FF98",
	PALADIN = "F48CBA",
	PRIEST = "FFFFFF",
	ROGUE = "FFF468",
	SHAMAN = "0070DD",
	WARLOCK = "8788EE",
	WARRIOR = "C69B6D",
}

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	QuestLog = ADDON_NAME .. "_QuestLog",
	QuestList = ADDON_NAME .. "_QuestList",
	QuestDetails = ADDON_NAME .. "_QuestDetails",
	WindowMap = ADDON_NAME .. "_WindowMap",
	NPCDialogue = ADDON_NAME .. "_NPCDialogue",
	QualityOfLife = ADDON_NAME .. "_QualityOfLife",
	QuestRoute = ADDON_NAME .. "_QuestRoute",
	QuestArrow = ADDON_NAME .. "_QuestArrow",
	MapsObjectives = ADDON_NAME .. "_MapsObjectives",
	Minimap = ADDON_NAME .. "_Minimap",
	ZoneMap = ADDON_NAME .. "_ZoneMap",
	WideMap = ADDON_NAME .. "_WideMap",
	Profiles = ADDON_NAME .. "_Profiles",
	FeedbackSupport = ADDON_NAME .. "_FeedbackSupport",
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
	Every gap, margin and padding the add-on sets is a step on one scale, each step twice the last, so
	the space between two things says how closely they belong together:
	  2   pieces of one thing: a list row's padding, reward buttons side by side
	  4   lines of one paragraph, an icon and its label
	  8   a heading or title and the text it introduces, text and the buttons it introduces
	  16  margins inside the parchment, a blank line's worth between groups
	  32  one section and the next (Description, Rewards, the quest chain, the quest ID)
	Positions that line up with Blizzard's art, and Blizzard's own sizes, stay as they are
]]
local SPACE = { TIGHT = 2, LINE = 4, NEAR = 8, GROUP = 16, SECTION = 32 }
LAYOUT.SPACE = SPACE

--[[
	Quest details are as wide as two columns of reward buttons (147px each, 1px apart), which can't
	shrink, with TEXT_MARGIN of parchment on the left, right and top
]]
LAYOUT.REWARD_COLUMNS_WIDTH = 147 + 1 + 147
LAYOUT.TEXT_MARGIN = SPACE.GROUP

-- The classic art's parchment spans x 348-658; the window is widened by however much more it needs
local ART_PARCHMENT_LEFT, ART_PARCHMENT_RIGHT = 348, 658
LAYOUT.EXTRA_WIDTH = (LAYOUT.REWARD_COLUMNS_WIDTH + 2 * LAYOUT.TEXT_MARGIN) - (ART_PARCHMENT_RIGHT - ART_PARCHMENT_LEFT)

LAYOUT.BASE_WIDTH = 724 + LAYOUT.EXTRA_WIDTH
LAYOUT.BASE_HEIGHT = 513
LAYOUT.PANE_TOP = 75 -- Top of the quest list and the quest details
LAYOUT.PANE_INSET = 151 -- Vertical space the panes never occupy
LAYOUT.ROW_HEIGHT = 16 -- A quest list row's own frame: one line of text

--[[
	The quest list's rows are spaced out past that: a quest row gets ROW_PADDING above and below, and a
	zone header room for its Share Quests button (Zone-Share.lua) with ROW_PADDING above and below it
]]
LAYOUT.ROW_PADDING = SPACE.TIGHT
LAYOUT.ZONE_SHARE_BUTTON_HEIGHT = 16
LAYOUT.QUEST_ROW_HEIGHT = LAYOUT.ROW_HEIGHT + 2 * LAYOUT.ROW_PADDING
LAYOUT.HEADER_ROW_HEIGHT = LAYOUT.ZONE_SHARE_BUTTON_HEIGHT + 2 * LAYOUT.ROW_PADDING

-- The quest list on the left, and the quest details 41px to its right
LAYOUT.LIST_LEFT = 19
LAYOUT.LIST_WIDTH = 300
LAYOUT.DETAIL_LEFT = LAYOUT.LIST_LEFT + LAYOUT.LIST_WIDTH + 41

LAYOUT.PARCHMENT_LEFT = ART_PARCHMENT_LEFT
LAYOUT.PARCHMENT_RIGHT = ART_PARCHMENT_RIGHT + LAYOUT.EXTRA_WIDTH
LAYOUT.PARCHMENT_TOP = 74

--[[
	Where the quest text goes: TEXT_MARGIN inside the parchment, and level with the first quest row of
	the list (under the first zone header, inside its padding)
]]
LAYOUT.CONTENT_LEFT = LAYOUT.PARCHMENT_LEFT + LAYOUT.TEXT_MARGIN
LAYOUT.CONTENT_WIDTH = LAYOUT.REWARD_COLUMNS_WIDTH
LAYOUT.CONTENT_TOP = LAYOUT.PANE_TOP + LAYOUT.HEADER_ROW_HEIGHT + LAYOUT.ROW_PADDING

--[[
	Quest text, headings included, is set with LINE_SPACING between its lines. Blizzard leaves none on
	Classic Era, which reads tight, and a little on WoW Forever; this makes both the same
]]
LAYOUT.LINE_SPACING = SPACE.LINE

--[[
	A heading sits close to the text it introduces and well clear of the text above, so it reads as the
	start of its section: a step of the scale under it, and the section step above it, well clear of
	the blank line between two paragraphs
]]
LAYOUT.TITLE_SPACE_BELOW = SPACE.NEAR
LAYOUT.DAILY_RESET_SPACE_BELOW = SPACE.NEAR -- Under TBC's daily reset line, which sits between the title and the objectives
LAYOUT.HEADING_SPACE_BELOW = SPACE.NEAR
LAYOUT.HEADING_SPACE_ABOVE = SPACE.SECTION

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
LAYOUT.REWARD_BUTTONS_SPACE = SPACE.NEAR

--[[
	Between one line of the rewards and the next section of them ("You will also receive:" under the
	gold, the experience under that); Blizzard leaves 5. With gold and experience both shown, a blank
	line's worth between the two, so each reads as its own reward
]]
LAYOUT.REWARD_LINE_SPACE = SPACE.NEAR
LAYOUT.MONEY_EXPERIENCE_SPACE = SPACE.GROUP

--[[
	The quest giver window's pages: the first line (the quest's title, the greeting) PAGE_TOP below the
	top of the page. Their left edge stays Blizzard's, as the page is only as wide as two columns of
	reward buttons
]]
LAYOUT.PAGE_TOP = SPACE.GROUP

-- Between the quest lines in a quest giver's list of quests, each its own choice; Blizzard leaves 2
LAYOUT.QUEST_LINE_SPACE = SPACE.NEAR

--[[
	Blizzard's money frames keep their last coin this far inside their right edge, so a money frame
	right-aligned to the text column sits this much further right
]]
LAYOUT.MONEY_RIGHT_PADDING = 13

--[[
	The quest ID sits under everything else in the quest details, a section's space down, right-aligned
	two spaces in from the edge of the text column like the other numbers, in the description's font a
	little smaller
]]
LAYOUT.QUEST_ID_GAP = SPACE.SECTION
LAYOUT.QUEST_ID_FONT_SHRINK = 2

--[[
	The chain link before a linked quest ID is drawn inline, a line tall, which sets it level with the top
	of the line and so above the letters beside it. It drops this far to sit centered on their capitals
]]
LAYOUT.LINK_ICON_DROP = SPACE.LINE

--[[
	Quest list rows: zone headers have their +/- at the left and their name after it; quest titles have
	a slot for the tracking mark in the same column as the +/-, there whether the quest is marked or not,
	and start just after it, level with the zone names. The untracked eye fills its square edge to edge,
	unlike Blizzard's check, so a gap keeps it off the title
]]
LAYOUT.CHECK_X = SPACE.LINE
LAYOUT.CHECK_GAP = SPACE.LINE
LAYOUT.QUEST_TEXT_X = LAYOUT.CHECK_X + 16 + LAYOUT.CHECK_GAP
LAYOUT.HEADER_TEXT_X = LAYOUT.QUEST_TEXT_X

--[[
	The tracking mark in that slot: a teal check in front of each tracked quest, or with markUntracked
	on, where tracking everything is the norm, a red crossed-out eye in front of each quest that isn't,
	in the deep red of the zone headers' minus buttons (as bright as their highlight, so its thin lines
	still read)
]]
ns.TRACKING_MARKS = {
	tracked = { texture = "Interface/Buttons/UI-CheckBox-Check", color = "40E0D0" },
	untracked = {
		texture = "Interface/AddOns/" .. ADDON_NAME .. "/Includes/Images/PWQL_Untracked",
		color = "A0100C",
	},
}

-- After the name of the zone the player is in, in every zone order: the green check of a completed objective, as tall as the text
ns.CURRENT_ZONE_MARK = "|TInterface/RaidFrame/ReadyCheck-Ready:0|t"

--[[
	Space above every zone header in the quest list except the first: half a row, so zones read as
	separate groups (twice the space between two rows' text) without a full blank line
]]
LAYOUT.HEADER_GAP = SPACE.NEAR

--[[
	Buttons along the bottom: the outer ones' offsets from the window's corners, and the size of the
	ones in between
]]
LAYOUT.BUTTON_BOTTOM = 54
LAYOUT.BUTTON_LEFT = 17
LAYOUT.BUTTON_RIGHT = 43
LAYOUT.BUTTON_WIDTH = 123
LAYOUT.BUTTON_HEIGHT = 21

-- Room either side of the Share Quests button's label (its height is with the row heights above)
LAYOUT.ZONE_SHARE_BUTTON_PADDING = SPACE.GROUP

--[[
	Expand All and Track All above the quest list, left to right from the quest log's own "All" spot.
	Each is at least as wide as a bottom button, and wider where a label needs it, with a gap between each
	and the next (Show Map's too)
]]
LAYOUT.LIST_BUTTONS_X = 74
LAYOUT.LIST_BUTTONS_Y = -53
LAYOUT.LIST_BUTTONS_GAP = SPACE.NEAR
LAYOUT.LABEL_PADDING = SPACE.SECTION

-- Center of the scroll bar slot to the right of the parchment
LAYOUT.DETAIL_SCROLL_SLOT_X = 673 + LAYOUT.EXTRA_WIDTH

--[[
	The drawn border stops short of the frame's own edges: the opaque part of Includes/Images/PWQL_BotRight stops
	176px into the piece and 211px down it. The resize grip sits GRIP_INSET inside that corner
]]
LAYOUT.ART_INSET_RIGHT = LAYOUT.BASE_WIDTH - (515 + LAYOUT.EXTRA_WIDTH + 176)
LAYOUT.ART_INSET_BOTTOM = 256 - 211 + 1
LAYOUT.GRIP_INSET = SPACE.LINE

-- A window dragged taller still leaves this much of the screen below it
LAYOUT.MINIMUM_BOTTOM_CLAMP = SPACE.GROUP

--------------------------------------------------------------------------------
-- Messages
--------------------------------------------------------------------------------

--[[
	Leads every message the add-on sends to other players (the master list's Target marker column), except
	on WoW Forever, which blocks raid-marker tokens in chat
]]
ns.TARGET_MARKER = "{rt3}"

-- SendChatMessage rejects anything longer, in bytes
ns.CHAT_MESSAGE_MAX_LENGTH = 255

--[[
	Share Quests shares one quest at a time, ns.GetShareInterval() seconds apart, within these bounds (the
	Quality of Life panel's slider). Any sooner than the shortest and the game calls a party member busy
]]
ns.SHARE_INTERVAL_MIN = 3
ns.SHARE_INTERVAL_MAX = 10

--[[
	In a dungeon with a party (Dungeon-Quests.lua): how often to look whether the party has gathered, and
	the longest the announcement and the shares wait for everyone to be in range before going out to
	whoever is. After a login or reload inside one, the party seen this long from when its first member
	shows up counts as already served
]]
ns.DUNGEON_CHECK_INTERVAL = 2
ns.DUNGEON_SHARE_MAX_WAIT = 60
ns.DUNGEON_LOGIN_GRACE = 10

--[[
	Offering a zone's quests to a party member (Zone-Share-Offer.lua): how long after they join, or the
	player does, to wait for Questie to swap quest logs; how long past that to keep trying while where they
	are or what quests they have isn't known yet; and after a login or reload in a group, the longest to
	wait for Questie to start before asking it for the party's quest logs
]]
ns.ZONE_OFFER_DELAY = 20
ns.ZONE_OFFER_MAX_WAIT = 60
ns.ZONE_OFFER_QUESTIE_WAIT = 30
