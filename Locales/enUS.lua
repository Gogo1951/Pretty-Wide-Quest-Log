local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "enUS", true)
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT_NAME"] = "PWQL"
-- TRANSLATORS: joins the items of a list, such as quest links or the letters after a quest's level
L["LIST_SEPARATOR"] = ", "
L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) are under Options > AddOns > Pretty Wide Quest Log. Enjoying this add-on? Tell a friend, Favorite it on CurseForge, or Star it on GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "As a safety precaution, the game's Key Bindings cannot be opened during combat."
-- TRANSLATORS: the first %s is the game menu's Options label, the second its Key Bindings label, both from the client
L["KEY_BINDINGS_LOCATION"] = "Open the game menu, then %s, then %s, and find the Pretty Wide Quest Log section."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Without Questie, the quest map shows less, and quest chains and the Turn-In total stay hidden. Turn on Questie in the AddOns list to see them."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus is also turned on, and the two will fight over the quest log. Turn off Wide Quest Log Plus in the AddOns list, then reload."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Wide quest log and quest helper for leveling: a quest route through the quests you pick, a waypoint arrow, quest levels, tags, rewards, quest chains, a quest map, and party quest sharing. Works with Questie, Spoken, VoiceOver, and ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Shows the Pretty Wide Quest Log welcome message when you log in."
L["OPTIONS_FEATURES_HEADER"] = "Features"
L["ENABLE_WIDE_QUEST_LOG"] = "Enable Wide Quest Log"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Swaps Blizzard's quest log for the wide one, with the map beside it. Takes effect after a reload."
L["ENABLE_QUALITY_OF_LIFE"] = "Enable Quality of Life"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Helps your party get on your quests: share pacing, whispers when a share misses someone, and dungeon quest announcements and sharing. A zone's Share Quests button in the quest log works with this off too."
L["ENABLE_WAYPOINT_MARKERS"] = "Enable Waypoint Markers"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Gathers each objective's quest icons on the zone map into one marker, a waypoint, where most of its mobs or objects are, with one for each turn-in too. Hover a marker to see the icons it stands in for."
L["ENABLE_QUEST_ROUTE"] = "Enable Quest Route"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"Draws a route on the zone map through your waypoint markers, nearest first, as marching dots from you to each marker in turn. Needs Waypoint Markers."
L["ENABLE_QUEST_ARROW"] = "Enable Quest Arrow"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Shows an arrow on screen, the Quest Arrow, pointing to the next waypoint on the route, with the quests and objectives to do there. By default it hides in raid groups and instances."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Enable Wide Quest Log takes effect after a reload, offered when you close the Options Interface."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log switches quest logs after a reload. Reload now?"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Key Bindings"
L["OPTIONS_KEY_SET"] = "Set Key"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "Opens the game's Key Bindings, where Pretty Wide Quest Log has its own section."
L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] =
	"Uses the item on the Quest Arrow's first Use Item button, the same as clicking it, in combat too."
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

--------------------------------------------------------------------------------
-- Options: Wide Quest Log Panels
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Wide Quest Log"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Replaces Blizzard's quest log with a wide one: your quests listed by zone, with the selected quest's details and its map beside them."
L["QUEST_LOG_SORTING_HEADER"] = "Sorting"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Choose the order of your zones and the quests under them."
L["QUEST_LOG_ROWS_HEADER"] = "Quest Rows"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Choose what each row shows."
L["TAB_WINDOW_MAP"] = "Window & Map"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] = "Size the window and map to fit your screen, and choose how they behave."
L["ZONE_ORDER"] = "Zone Order"
L["ZONE_ORDER_DESCRIPTION"] = "Changes the order of the zones in the quest list."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Average Level, Highest First (Default)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Average Level, Lowest First"
L["SORT_ALPHABETICAL"] = "Alphabetical"
L["CURRENT_ZONE_FIRST"] = "Show Current Zone First"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] = "Puts the zone you're in at the top of the list, whatever the zone order."
L["ZONE_GAP"] = "Add Space Above Zone Names"
L["ZONE_GAP_DESCRIPTION"] =
	"Adds a little space above each zone name. Handy when your quests are spread across lots of zones."
L["QUEST_ORDER"] = "Quest Order"
L["QUEST_ORDER_DESCRIPTION"] = "Changes the order of the quests under each zone."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Level, Highest First (Default)"
L["SORT_LEVEL_LOWEST"] = "Level, Lowest First"
L["COMPLETED_FIRST"] = "Show Completed Quests First"
L["COMPLETED_FIRST_DESCRIPTION"] = "Moves quests that are ready to turn in to the top of their zone."
L["SHOW_QUEST_LEVELS"] = "Show Quest Levels"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Puts each quest's level and type in front of its name in the list, like %s for a level 40 dungeon quest."
L["MARK_UNTRACKED"] = "Mark Untracked Quests"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Tracked quests lose their checkmark %s, and untracked quests get an eye %s instead. Handy if you track almost everything."
L["CLOSE_IN_COMBAT"] = "Close When Combat Starts"
L["CLOSE_IN_COMBAT_DESCRIPTION"] = "Closes the quest log when a fight starts, so it never covers the action."
L["SHOW_OBJECTIVE_AREAS"] = "Show Objective Areas"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Shades where each objective's mobs and objects are found on the map beside the quest log, with one icon in each area instead of one on every spawn."
L["NEEDS_QUESTIE_HINT"] = "Turn on Questie to use this."
L["SHOW_ZONE_INFO"] = "Show Zone Info"
L["SHOW_ZONE_INFO_DESCRIPTION"] =
	"Under the map, the quests from other zones you could pick up for the zone it shows, and the items that zone's quests ask you to bring. The map shrinks to half the window's height to make room."
L["WINDOW_SCALE"] = "Quest Log Scale"
L["WINDOW_SCALE_DESCRIPTION"] = "Makes the quest log bigger or smaller. The map beside it grows and shrinks with it."
L["MAP_SCALE"] = "Map Scale"
L["MAP_SCALE_DESCRIPTION"] = "Makes the map beside the quest log bigger or smaller, on top of the Quest Log Scale."
L["RESET_WINDOW_BUTTON"] = "Reset Window"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Puts the quest log's height and scale, and the map's scale, back to their defaults."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Puts the quest log's height and scale, and the map's scale, back to their defaults, and moves the window back to its starting spot."
L["RESET_WINDOW_SCALE_CONFIRM"] = "Reset the quest log's height and scale, and the map's scale?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Reset the quest log's height and scale, the map's scale, and the window's spot on screen?"
L["HANDY_CLICKS_HEADER"] = "Handy Clicks"
L["HANDY_CLICK_TRACK"] = "Shift-Click a Quest"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "Track or untrack it."
L["HANDY_CLICK_MENU"] = "Right-Click a Quest"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "Track it, share it, or abandon it."
L["HANDY_CLICK_ID"] = "Click a Quest ID"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Get its Wowhead link."
L["QUEST_LOG_SUB_PANELS_DESCRIPTION"] =
	"Its settings are on the panels under this one: Quest List, Quest Details, Window & Map, and NPC Dialogue."
L["NEEDS_WIDE_QUEST_LOG"] =
	"These settings are for the wide quest log. Turn on Enable Wide Quest Log on the Wide Quest Log panel to use them."
L["TAB_QUEST_LIST"] = "Quest List"
L["TAB_QUEST_LIST_DESCRIPTION"] = "Your quests, listed by zone down the left side of the quest log."
L["TAB_QUEST_DETAILS"] = "Quest Details"
L["TAB_QUEST_DETAILS_DESCRIPTION"] = "The selected quest's details, on the parchment beside the quest list."

--------------------------------------------------------------------------------
-- Options: NPC Dialogue Panel
--------------------------------------------------------------------------------

L["TAB_NPC_DIALOGUE"] = "NPC Dialogue"
L["TAB_NPC_DIALOGUE_DESCRIPTION"] =
	"The windows an NPC opens when you talk to them: the quest giver window and the gossip window. These settings work with or without the wide quest log."
L["QUEST_GIVERS_HEADER"] = "Quest Givers"
L["QUEST_GIVERS_DESCRIPTION"] = "The window a quest giver opens, where you pick up quests and turn them in."
L["GIVER_CLEANUP"] = "Quest Giver Window Cleanup"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Lays out the quest giver window's text like the quest log's, with the same headings and line spacing, and shows the quest ID, linked to Wowhead, under the quest."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] = "Adds the quest log's level tags, like %s, to a quest giver's list of quests."
L["FONT_DIALOGUE_NEEDS_CLEANUP"] = "The font is part of Quest Giver Window Cleanup, so it needs that turned on."

--------------------------------------------------------------------------------
-- Options: Font Sections
--------------------------------------------------------------------------------

L["FONT_HEADER"] = "Font"
L["FONT_LIST_DESCRIPTION"] = "The font of the zone names and quests in the quest list."
L["FONT_DETAILS_DESCRIPTION"] = "The font of the quest details: the title, the headings, and the quest text."
L["FONT_DIALOGUE_DESCRIPTION"] =
	"The font of the quest giver and gossip windows: the title, the headings, and the quest text."
L["FONT_WINDOW_DESCRIPTION"] = "The font of the window's title, the quest count, and the Turn-In line."
L["FONT_FACE"] = "Font"
L["FONT_FACE_DESCRIPTION"] =
	"The typeface. Game Default follows the game's font, and any add-on that changes it. Fonts added through SharedMedia are listed too."
L["FONT_GAME_DEFAULT"] = "Game Default"
L["FONT_GAME_STANDARD"] = "Standard Text"
L["FONT_GAME_NAMES"] = "Character Names"
L["FONT_GAME_DAMAGE"] = "Damage Numbers"
L["FONT_SIZE"] = "Size"
L["FONT_SIZE_DESCRIPTION"] =
	"Makes the text bigger or smaller, in points from the game's size. 0 keeps the game's size."
L["FONT_OUTLINE"] = "Outline"
L["FONT_OUTLINE_DESCRIPTION"] =
	"A black outline around each letter. Game Default keeps whatever outline the game's font has, and None takes it away."
L["FONT_OUTLINE_DEFAULT"] = "Game Default"
L["FONT_OUTLINE_NONE"] = "None"
L["FONT_OUTLINE_THIN"] = "Thin"
L["FONT_OUTLINE_THICK"] = "Thick"
L["FONT_SHADOW"] = "Text Shadow"
L["FONT_SHADOW_DESCRIPTION"] =
	"Keeps the drop shadow the game's font has behind the text. Turn it off to take the shadow away, which helps a font that looks blurry or smudged."
L["FONT_SLUG"] = "Sharper Text (Slug)"
L["FONT_SLUG_DESCRIPTION"] =
	"Draws the text with Blizzard's newer Slug renderer, for crisper letters at any size. Slug can't draw a thick outline or a shadow, so text with either is drawn the usual way."
L["FONT_RESET_BUTTON"] = "Reset Font"
L["FONT_RESET_DESCRIPTION"] = "Puts this font's settings back to their defaults."

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Quality of Life"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Small helpers outside the quest log itself: for sharing quests with your party and for dungeons."
L["QUEST_SHARING_HEADER"] = "Quest Sharing"
L["QUEST_SHARING_INTRO"] =
	"Hover a zone name in the quest log and click Share Quests to offer your party all of its quests you can share, one after another. These settings control the pace and what happens when someone misses one."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"Share Quests on a zone name needs Enable Wide Quest Log. Dungeon quest sharing works without it."
L["SHARE_INTERVAL"] = "Seconds Between Shares"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"How long to wait between one shared quest and the next, when you share a zone's quests or a dungeon's. Longer gives your party more time to accept each one."
L["SHARE_WHISPERS"] = "Whisper When a Share Fails"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"When a party member is busy, too far away, or has a full quest log, whispers them which quest you tried to share and asks them to remind you. Nothing is sent when they aren't eligible for the quest, are already on it, or have done it."
L["ZONE_SHARE_OFFERS"] = "Tell Me When New Party Members Are Missing My Zone's Quests"
L["ZONE_SHARE_OFFERS_DESCRIPTION"] =
	"When you join a party, or someone joins yours, waits 20 seconds for Questie to swap quest logs, then tells you in chat how many of your quests with objectives in your zone the new members are missing, so you can click Share Quests. Only quests you can share count, each once however many members lack it. Nothing is sent to anyone. Members whose quests can't be seen (no Questie, out of range) aren't counted. Once each time someone joins, never in a dungeon or a raid group."
L["ZONE_SHARE_OFFERS_SOUND"] = "Play Sound"
L["ZONE_SHARE_OFFERS_SOUND_DESCRIPTION"] = "Plays an alert alongside the notice, for when chat is busy."
L["ZONE_SHARE_SOUND_PREVIEW"] = "Click to hear the alert."
L["SAMPLE_EXAMPLE"] = "Example: %s"
L["SAMPLE_QUEST_LOADING"] = "Loading Quest ID: %d"
L["DUNGEON_QUESTS_HEADER"] = "Dungeon Quests"
L["DUNGEON_QUESTS_INTRO"] =
	"When you enter a dungeon with your party, your quests for it are announced and shared once everyone is in range (right away on WoW Forever), and never twice to the same party. With Questie, quests whose objectives are inside count too, class quests included. Nothing happens in a raid group."
L["DUNGEON_ANNOUNCE"] = "Automatic Dungeon Quest Announcements"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Tells your party which of your quests still need doing in the dungeon you just entered, so everyone knows what to look out for. Quests ready to turn in are left out."
L["DUNGEON_SHARE"] = "Automatic Dungeon Quest Sharing"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Shares every quest for the dungeon that the game lets you share and someone in your party doesn't have yet, at the pace set under Quest Sharing, once everyone is in range (or after a minute; right away on WoW Forever). Each party member gets them once per dungeon, so someone who joins later gets them too, and zoning out and back in shares nothing. With Whisper When a Share Fails on, anyone a share misses is whispered so they can ask again."

--------------------------------------------------------------------------------
-- Options: Maps & Objectives Panels
--------------------------------------------------------------------------------

L["TAB_MAPS_OBJECTIVES"] = "Maps & Objectives"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"One marker on the zone map for each objective and turn-in, in place of a cluster of quest icons."
L["MAPS_SUB_PANELS_DESCRIPTION"] =
	"Each map's settings are on the panels under this one: Mini-map, Zone Map, and Continent & World Map."
L["MAPS_NEED_MARKERS"] = "The markers show only while Enable Waypoint Markers is on."
L["TAB_MINIMAP"] = "Mini-map"
L["TAB_MINIMAP_DESCRIPTION"] =
	"Questie's icons on the mini-map show exactly where things spawn and where to loot them, so they always stay. The route's markers can show beside them."
L["SHOW_MINIMAP_MARKERS"] = "Show Waypoint Markers on the Mini-map"
L["SHOW_MINIMAP_MARKERS_DESCRIPTION"] =
	"Puts a small marker on the mini-map for each waypoint on the route, beside Questie's icons. Hover one to see its quests."
L["MINIMAP_MARKER_SIZE_DESCRIPTION"] = "How big the route's markers are on the mini-map."
L["TAB_ZONE_MAP"] = "Zone Map"
L["TAB_ZONE_MAP_DESCRIPTION"] = "The map of a zone, where the route runs between its waypoint markers."
L["FULL_SIZE_MAP"] = "Open the Zone Map Full Size"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Opens the zone map maximized, as its own maximize button does, so the route has room. If you shrink the map, it opens full size again next time."
L["HIDE_QUESTIE_ICONS"] = "Hide Quest Icons on the Route"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Hides Questie's map icons, and Blizzard's quest markers and objective areas, for what's on the route, so the route's markers stand in for them. Questie's faded icons for party members' objectives are hidden too. Hover a marker to see Questie's icons."
L["MARKER_SIZE"] = "Marker Size"
L["MARKER_SIZE_DESCRIPTION"] = "How big the route's markers are on the zone map."
L["MARKER_SIZE_SMALL"] = "Small"
L["MARKER_SIZE_MEDIUM"] = "Medium"
L["MARKER_SIZE_LARGE"] = "Large"
L["MARKER_SIZE_HUGE"] = "Huge"
L["WAYPOINTS_SHOWN"] = "Waypoints Shown"
L["WAYPOINTS_SHOWN_DESCRIPTION"] =
	"How much of the route the zone map draws. The whole route is still planned: past these waypoints a … marker points where it goes next, and hovering it shows the rest. Clicking it shows the whole route until you close the map."
-- TRANSLATORS: a Waypoints Shown choice; %d is how many waypoints, 5, 10 or 20
L["WAYPOINTS_SHOWN_NEXT"] = "Next %d"
L["WAYPOINTS_SHOWN_ALL"] = "Whole Route"
L["TAB_WIDE_MAP"] = "Continent & World Map"
L["TAB_WIDE_MAP_DESCRIPTION"] =
	"Maps that hold many zones at once, where each objective and turn-in gets one smaller marker."
L["SHOW_WIDE_MAP_MARKERS"] = "Show Waypoint Markers on Continent and World Maps"
L["SHOW_WIDE_MAP_MARKERS_DESCRIPTION"] =
	"Puts a marker on the continent and world maps for each objective and turn-in, in place of Questie's icons. Turn it off to see Questie's icons there instead."
L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"] =
	"How big the route's markers are on the continent and world maps. Each size is smaller there than on the zone map, as these maps hold many zones."

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "Quest Route"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"A route on the zone map through your waypoint markers, in the order to do them, from where you stand."
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"The Quest Route runs between the waypoint markers, so it shows only while Enable Waypoint Markers is on."
L["ROUTES_LINE_HEADER"] = "Route Line"
L["ROUTES_LINE_DESCRIPTION"] = "The marching dots that lead from you to each marker."
L["LINE_SPEED"] = "Line Speed"
L["LINE_SPEED_DESCRIPTION"] = "How fast the dots march toward the next marker."
L["LINE_SPEED_STILL"] = "Still"
L["LINE_SPEED_SLOW"] = "Slow"
L["LINE_SPEED_NORMAL"] = "Normal"
L["LINE_SPEED_FAST"] = "Fast"
L["LINE_OPACITY"] = "Line Opacity"
L["LINE_OPACITY_DESCRIPTION"] = "How solid the dots are; lower lets more of the map show through."
L["ROUTES_PLANNING_HEADER"] = "Planning"
L["ROUTES_PLANNING_DESCRIPTION"] = "What the route plans for beyond your own quests."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_PREDICTIVE
L["PREDICTIVE_ROUTES"] = "Predictive Questing Routes"
L["PREDICTIVE_ROUTES_DESCRIPTION"] =
	"Plans quests you can finish in this zone from wherever their giver stands, not only nearby: their objectives, their turn-in, and the quests that follow them. The route then picks up everything for a part of the zone before you go there, so you only go once. A chain stops at the first quest that leads to another zone. Objectives of a quest you haven't picked up yet have a gray marker. Each quest's turn-in shows before it's done too, marked with Questie's gray question mark."
-- TRANSLATORS: a popup with an Okay button each time Predictive Questing Routes is turned on
L["PREDICTIVE_ROUTES_POPUP"] =
	"Heads up: Predictive Questing Routes plans the whole zone ahead, so your map might look a little crazy. But there's a method to the madness! Follow the Quest Arrow to spend less time running and more time earning XP. (="
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_FLIGHTS
L["SHOW_FLIGHT_PATHS"] = "Show Undiscovered Flight Paths as Objectives"
L["SHOW_FLIGHT_PATHS_DESCRIPTION"] =
	"Adds to the route each flight master in your zone whose flight path you don't have yet, marked with the flight master icon. On a character that already had flight paths, open any flight map once so the route knows which ones you have; until then none are added."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_LOCAL
L["SHOW_LOCAL_QUESTS"] = "Show Local Available Quests as Objectives"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"Puts quests you can pick up on the route, where Questie shows them as available and an NPC or object that starts them is within %s of you, marked with Questie's exclamation mark. Quests started by an item that drops, and dungeon and raid quests, are left out."
L["LOCAL_QUESTS_HEADER"] = "Local Available Quests"
L["LOCAL_QUESTS_DESCRIPTION"] =
	"Which quests near you the Quest Arrow takes you to. One it skips can still show on the world map, with no route line to it."
L["LOCAL_QUEST_RANGE"] = "Search Range"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"How many yards from you a quest giver can be and still count. Under 400, a giver you walk past between the route's plans can be missed."
L["LOCAL_ESCORT_QUESTS"] = "Escort Quests"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] =
	"Quests where you protect an NPC along the way, which take time and often a group. Their marker on the map is green."
L["LOCAL_GROUP_QUESTS"] = "Group and Elite Quests"
L["LOCAL_GROUP_QUESTS_DESCRIPTION"] = "Quests Questie marks as elite, made for a group."
L["LOCAL_OTHER_ZONE_QUESTS"] = "Objectives in Another Zone"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"Quests with an objective, or the turn-in, only outside the zone you're in, such as one that sends you on to the next town."
L["LOCAL_QUEST_LEVEL"] = "Lowest Quest Level"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	"Quests below this difficulty color are left off. Questie's Setting keeps the quests Questie shows on its map."
-- TRANSLATORS: a choice for a kind of nearby quest: the Quest Arrow takes you there
L["LOCAL_CHOICE_ROUTE"] = "On the Route"
-- TRANSLATORS: a choice for a kind of nearby quest: a marker on the world map, but the Quest Arrow skips it
L["LOCAL_CHOICE_MAP"] = "Map Only"
-- TRANSLATORS: a choice for a kind of nearby quest: neither the route nor its map markers show it
L["LOCAL_CHOICE_OFF"] = "Left Off"
L["LOCAL_LEVEL_QUESTIE"] = "Questie's Setting"
-- TRANSLATORS: quest difficulty colors, green being a few levels below the player
L["LOCAL_LEVEL_GREEN"] = "Green and Higher"
L["LOCAL_LEVEL_YELLOW"] = "Yellow and Higher"
L["ROUTES_PARTY_HEADER"] = "Party"
L["ROUTES_PARTY_DESCRIPTION"] = "What your party adds to the route."
L["PARTY_QUESTS"] = "Include Party Members' Quests"
L["PARTY_QUESTS_DESCRIPTION"] =
	"In a party, the route and the Quest Arrow also take in quests your party members have and you don't, shown just like your own. It needs Questie on both ends to share them. Their dungeon quests are left out, as the objectives are inside the dungeon."
L["GROUP_UP"] = "Group Up"
L["GROUP_UP_DESCRIPTION"] =
	"In a party, when anyone in your zone is off your mini-map, the Quest Arrow says Group Up and points to them, or to the middle of everyone, and the world map marks the spot, so you can quest together."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Quest Arrow"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"An arrow on screen pointing to the next waypoint on the route, with the quests and objectives to do there. Hover it for a menu where you can ignore one objective at a time and see what you've ignored. Middle-click it to reset the zone, putting back what you ignored there."
L["QUEST_ARROW_HEADER"] = "Arrow"
L["QUEST_ARROW_DESCRIPTION"] = "Where the Quest Arrow sits and how big it is."
L["ARROW_SIZE"] = "Arrow Size"
L["ARROW_SIZE_DESCRIPTION"] = "How big the Quest Arrow is, with the text under it."
L["LOCK_ARROW"] = "Lock the Quest Arrow"
L["LOCK_ARROW_DESCRIPTION"] = "Keeps the Quest Arrow where it is, so dragging it does nothing."
L["RESET_ARROW"] = "Arrow Position"
L["RESET_ARROW_BUTTON"] = "Reset"
L["RESET_ARROW_CONFIRM"] = "Move the Quest Arrow back to its starting spot?"
L["RESET_ARROW_DESCRIPTION"] = "Puts the Quest Arrow back where it starts, near the top middle of the screen."
L["QUEST_ARROW_TEXT_HEADER"] = "Under the Arrow"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "What the Quest Arrow lists under itself."
L["SHOW_DISTANCE"] = "Show Distance"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] = 'Shows how many yards away the next waypoint is. "%s" and "%s" show either way.'
L["SHOW_ARROW_QUESTS"] = "Show Quests and Objectives"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] = "Lists the quests at the next waypoint, each with what's left to do there."
L["QUESTS_LISTED"] = "Maximum Quests Listed"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'The most quests the Quest Arrow lists under itself for one waypoint. Any more are counted on a line of their own, such as "%s".'
L["SHOW_ITEM_BUTTONS"] = "Show Quest Item Buttons"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"Puts a button beside each quest the Quest Arrow lists that has an item to use, such as one to throw, plant, or use on a target. Click it to use the item, or set a key for Use Quest Item under Key Bindings on the Pretty Wide Quest Log panel to use the first one. In combat the buttons stay where they are until it ends."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_NEXT_OBJECTIVE
L["SHOW_NEXT_OBJECTIVE"] = "Show Next Objective"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'At a "%s", lists "%s" under it, dimmed: a small arrow to the waypoint after, and what\'s to do there.'
L["QUEST_ARROW_HIDING_HEADER"] = "Hiding"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "When the Quest Arrow steps out of the way."
L["HIDE_IN_RAIDS"] = "Hide in Raid Groups"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "Hides the Quest Arrow while you're in a raid group."
L["HIDE_IN_INSTANCES"] = "Hide in Instances"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "Hides the Quest Arrow in dungeons, raids, and battlegrounds."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Help Pretty Wide Quest Log Level Up"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"This add-on was built by players who love this game and want to make it as fun as possible for everyone. We'll never ask for donations. The real satisfaction comes from knowing our work makes the game a little better for you. If it does, we'd love to hear about it!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Here are a few ways you can help us reach more players."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Share Feedback: Found a bug or have an idea? Let us know on Discord. Your feedback helps us improve the add-on, and pull requests are always welcome."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Tell a Friend: Know someone who might enjoy this add-on? Tell them about it. Word of mouth helps more players discover great add-ons."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Favorite on CurseForge: Open the CurseForge link below, sign in, and click the star beneath the Download button. Favorites help more players discover the add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Star on GitHub: Open the GitHub link below, sign in, and click Star in the top right. Stars help the project qualify for more free developer tools."
L["OPTIONS_LEVEL_UP_THANKS"] = "Thanks for choosing Pretty Wide Quest Log!"
L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Feedback & Support Links"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "To copy a link, click its box, then press Ctrl+A and Ctrl+C."
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "D"
L["QUEST_SUFFIX_RAID"] = "R"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "dungeon"
L["QUEST_TYPE_RAID"] = "raid"
L["QUEST_TYPE_GROUP"] = "group"
L["QUEST_TYPE_ELITE"] = "elite"
L["QUEST_TYPE_PVP"] = "PvP"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "Letters after the level: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "Quest ID %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Quest Chain (%d of %d)"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "Daily quests reset in %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Click for a Wowhead link."
L["WOWHEAD_LINK_COPY"] = "Press Ctrl+C (Cmd+C on a Mac) to copy the Wowhead link."
L["EXPAND_ALL"] = "Expand All"
L["COLLAPSE_ALL"] = "Collapse All"
L["TRACK_ALL"] = "Track All"
L["UNTRACK_ALL"] = "Untrack All"
L["HIDE_MAP"] = "Hide Map"
L["ZONE_INFO_QUESTS"] = "Quests to Pick Up"
L["ZONE_INFO_ITEMS"] = "Things to Bring"
-- TRANSLATORS: Zone Info's Things to Bring heading; %s is the zone the box shows, from the client
L["ZONE_INFO_ITEMS_TO"] = "Things to Bring to %s"
L["ZONE_INFO_BACK"] = "Back to Quest"
L["ZONE_INFO_ASK"] = "Ask for Shares"
L["ZONE_INFO_ASK_DESCRIPTION"] =
	"Writes the quests here that players can share into your chat box, on channel 4 (Looking for Group) when you're in it. Nothing is sent until you press Enter."
-- TRANSLATORS: %s is quest links, or names in brackets, joined by commas; it's written into the chat box, never sent
L["ZONE_INFO_ASK_MESSAGE"] = "Could anyone share %s?"
-- TRANSLATORS: %s is a quest giver's name
L["ZONE_INFO_GIVER"] = "Given by %s"
-- TRANSLATORS: where a quest giver stands: map coordinates ("55,52"), then the zone
L["ZONE_INFO_GIVER_PLACE"] = "%s in %s"
L["ZONE_INFO_SHAREABLE"] = "Shareable"
L["ZONE_INFO_NOT_SHAREABLE"] = "Not Shareable"
L["ZONE_INFO_TRACK"] = "Add to Route"
L["ZONE_INFO_UNTRACK"] = "Take off Route"
-- TRANSLATORS: an item tooltip's heading after "PWQL //"; the quests that need the item are listed under it
L["ZONE_INFO_NEEDED_FOR"] = "Needed For"
L["ZONE_INFO_SHIFT_CLICK"] = "Shift-Click"
L["ZONE_INFO_LINK_ITEM"] = "Link in Chat"
L["ZONE_INFO_MENU_QUEST"] = "This Quest"
L["ZONE_INFO_MENU_HERE"] = "Where You Are"
L["ZONE_INFO_MENU_LOG"] = "Your Quests"
L["ZONE_INFO_MENU_AVAILABLE"] = "Most Quests for You"
L["ZONE_INFO_NO_QUESTS"] = "No quests from other zones to pick up for here."
L["ZONE_INFO_NO_ITEMS"] = "Nothing to buy or bring for here."
L["ZONE_INFO_WORKING"] = "Reading quests..."
-- TRANSLATORS: %d is the item's ID, shown until the client has loaded the item's name
L["ZONE_INFO_ITEM_LOADING"] = "Loading Item ID: %d"
L["ZONE_INFO_NEEDS_QUESTIE"] = "Turn on Questie to see what's here."
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "%s XP"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "Turn-In: %s"
L["TURN_IN_TOOLTIP"] = "Ready to Turn In"
L["RESIZE_TOOLTIP"] = "Drag to resize the quest log."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Share Quests"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Offers your party the quests in this zone the game lets you share and someone doesn't have yet, one every %d seconds."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "Sharing %s when combat ends."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "Sharing 1 quest from %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Sharing %d quests from %s, one every %d seconds."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "None of your quests from %s can be shared."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_PARTY_HAS"] = "Your party already has all your quests from %s."
-- TRANSLATORS: %s is the zone; printed when new party members are missing 1 of your quests there
L["CHAT_ZONE_SHARE_NOTICE_ONE"] = "You have 1 shareable quest in %s your party may need."
-- TRANSLATORS: %d is how many quests, %s is the zone; printed when new party members are missing them
L["CHAT_ZONE_SHARE_NOTICE"] = "You have %d shareable quests in %s your party may need."

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "You're There"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "Waypoint on Another Map"
L["ROUTES_OBJECTIVE_AREA"] = "Current Objective Area"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "Finish Here Before Moving On"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "More Along the Route"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "Next Objective"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "While You're Here"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d Yards"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d Yard"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d More Here"
L["ROUTES_TURN_IN"] = "Turn in Quest"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Turn in %s"
L["ROUTES_PICK_UP"] = "Pick up Quest"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "Pick up %s"
L["ROUTES_FLIGHT_PATH"] = "Get Flight Path"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_FLIGHT_PATH_FROM"] = "Get the Flight Path From %s"
-- TRANSLATORS: first %s is the flight master's name, such as "Omusa Thunderhorn"; second is where the flight lands, as the flight map names it, such as "Camp Taurajo"
L["ROUTES_FLY_FROM"] = "Talk to %s to Fly to %s"
-- TRANSLATORS: under a quest to pick up on the world map, why the route doesn't go there
L["ROUTES_OFF_ROUTE_ESCORT"] = "Escort Quest, Not on the Route"
L["ROUTES_OFF_ROUTE_GROUP"] = "Group Quest, Not on the Route"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "Leads to Another Zone, Not on the Route"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"; over a quest's objectives planned before it's picked up
L["ROUTES_AFTER_PICK_UP"] = "After You Pick up %s"
-- TRANSLATORS: %s is the quest's title with its level; under a quest to pick up once another is turned in
L["ROUTES_AFTER_TURN_IN"] = "After You Turn in %s"
-- TRANSLATORS: as ROUTES_AFTER_PICK_UP, for a party member's quest planned ahead, one you don't have
L["ROUTES_AFTER_PARTY_PICK_UP"] = "After Your Party Picks up %s"
-- TRANSLATORS: as ROUTES_AFTER_TURN_IN, for a party member's quest
L["ROUTES_AFTER_PARTY_TURN_IN"] = "After Your Party Turns in %s"
L["ROUTES_CORPSE"] = "Run Back to Your Corpse"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Look For"
-- TRANSLATORS: the title of the "…" marker's tooltip where the zone map stops drawing the route; %d is how many waypoints it hides
L["ROUTES_MORE_WAYPOINT"] = "1 More Waypoint"
L["ROUTES_MORE_WAYPOINTS"] = "%d More Waypoints"
L["ROUTES_MORE_WAYPOINTS_DESCRIPTION"] =
	"The rest of the route, shown while you hover. Waypoints Shown, under Zone Map in Options, sets how many the map draws."
L["ROUTES_CLICK_DRAG"] = "Drag"
L["ROUTES_CLICK_RIGHT"] = "Right-Click"
L["ROUTES_CLICK_MIDDLE"] = "Middle-Click"
L["ROUTES_CLICK"] = "Click"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "Use Item"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "Use Quest Item"
L["ROUTES_DRAG_MOVE"] = "Move Quest Arrow"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "Ignore This Waypoint"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "Ignore This Objective"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "Back on the Route"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "Reset This Zone"
-- TRANSLATORS: beside ROUTES_CLICK on the "…" marker's tooltip; the whole route shows until the map closes
L["ROUTES_CLICK_SHOW_ROUTE"] = "Show the Whole Route"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Ignoring %s until you reset the zone."
L["ROUTES_ZONE_RESET"] = "Zone reset: objectives ignored here are back on the route."
L["ROUTES_GROUP_LEFT_CLEARED"] = "Left the group: party objectives and members you ignored are back on the route."
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] = "%s left the group: the objectives you ignored for them are back on the route."
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "Ignore"
L["ROUTES_MENU_SECTION_ROUTE"] = "Route"
L["ROUTES_MENU_SECTION_SHOW"] = "Show"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "Next"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "Put Back"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "Ignored"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "%s Turn-In"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "%s Pick-Up"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_MENU_FLIGHT_PATH"] = "%s Flight Path"
-- TRANSLATORS: %s is where the flight lands, such as "Camp Taurajo"
L["ROUTES_MENU_FLY"] = "Flight to %s"
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_ROUTE; Next Objective, under ROUTES_MENU_SECTION_SHOW, is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_PREDICTIVE"] = "Predictive Questing Routes"
L["ROUTES_MENU_SHOWN_LOCAL"] = "Local Available Quests"
L["ROUTES_MENU_SHOWN_FLIGHTS"] = "Flight Paths"
L["ROUTES_MENU_SHOWN_PARTY"] = "Party Objectives"
L["ROUTES_MENU_ON"] = "On"
L["ROUTES_MENU_OFF"] = "Off"
L["ROUTES_MENU_OUT_OF_ZONE"] = "Out of Zone"
L["ROUTES_MENU_NO_QUESTIE"] = "No Questie"
L["ROUTES_MENU_OFFLINE"] = "Offline"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "Objectives From %s"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "Ignoring %s for %s until you reset the zone."
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] = "Ignoring %s for %s until the party members on it leave the group."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s is back on the route."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "Leaving %s's objectives off the route."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "%s's objectives are back on the route."
-- TRANSLATORS: on the Quest Arrow and the world map's marker, while it points to where to join up with your party
L["ROUTES_GROUP_UP"] = "Group Up"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them,
	and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"I tried to share %s with you, but it didn't go through. If you'd like the quest, just give me a shout when you're ready and I'll share it again"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Same goes for %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "I have %d quests to do here: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "I have 1 quest to do here: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "More quests to do here: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] = "Questie's tracker can't show %s because the quest is missing from Questie's database."
L["QUESTIE_CANNOT_TRACK"] = "Questie can't track this quest yet."
