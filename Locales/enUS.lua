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
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Without Questie, the quest map shows less, and quest chains and the Turn In total stay hidden. Turn on Questie in the AddOns list to see them."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus is also turned on, and the two will fight over the quest log. Turn off Wide Quest Log Plus in the AddOns list, then reload."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Wide quest log with a quest route and quest arrow. You pick the quests, we help with a clean route to get them done fast. Quest levels, tags, rewards, quest chains, a quest map, and party quest sharing. Works with Questie, Spoken, VoiceOver, and ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Shows the Pretty Wide Quest Log welcome message when you log in."
L["OPTIONS_FEATURES_HEADER"] = "Features"
L["ENABLE_WIDE_QUEST_LOG"] = "Enable Wide Quest Log"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Swaps Blizzard's quest log for the wide one, with the map beside it. Takes effect after a reload."
L["ENABLE_QUALITY_OF_LIFE"] = "Enable Quality of Life"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Tidies the quest giver window and helps your party get on your quests: share pacing, whispers when a share misses someone, and dungeon quest announcements and sharing. A zone's Share Quests button in the quest log works with this off too."
L["ENABLE_ROUTES_MAP"] = "Enable Routes on Zone Map"
L["FEATURE_ROUTES_MAP_DESCRIPTION"] =
	"Draws a route through your quest objectives and turn-ins on the zone map, nearest first, as marching dots between markers."
L["ENABLE_QUEST_ARROW"] = "Enable Quest Arrow"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Shows an arrow on screen, the Quest Arrow, pointing to the next waypoint on the route, with the quests and objectives to do there. By default it hides in raid groups and instances."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Enable Wide Quest Log takes effect after a reload, offered when you close the Options Interface."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log switches quest logs after a reload. Reload now?"
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Wide Quest Log"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Replaces Blizzard's quest log with a wide one: your quests listed by zone, with the selected quest's details and its map beside them."
L["QUEST_LOG_SORTING_HEADER"] = "Sorting"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Choose the order of your zones and the quests under them."
L["QUEST_LOG_ROWS_HEADER"] = "Quest Rows"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Choose what each row shows."
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "Window & Map"
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

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Quality of Life"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Small helpers outside the quest log itself: for the quest giver window, for sharing quests with your party, and for dungeons."
L["QUEST_GIVERS_HEADER"] = "Quest Givers"
L["QUEST_GIVERS_DESCRIPTION"] = "The window a quest giver opens, where you pick up quests and turn them in."
L["GIVER_CLEANUP"] = "Quest Giver Window Cleanup"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Lays out the quest giver window's text like the quest log's, with the same headings and line spacing, and shows the quest ID, linked to Wowhead, under the quest."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] = "Adds the quest log's level tags, like %s, to a quest giver's list of quests."
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
	"Shares every quest for the dungeon that the game lets you share, at the pace set under Quest Sharing, once everyone is in range (or after a minute; right away on WoW Forever). Each party member gets them once per dungeon, so someone who joins later gets them too, and zoning out and back in shares nothing. With Whisper When a Share Fails on, anyone a share misses is whispered so they can ask again."

--------------------------------------------------------------------------------
-- Options: Routes on Zone Map Panel
--------------------------------------------------------------------------------

L["TAB_ROUTES_MAP"] = "Routes on Zone Map"
L["TAB_ROUTES_MAP_DESCRIPTION"] =
	"A route through your quest objectives and turn-ins on the zone map, in the order to do them, from where you stand."
L["ROUTES_MAP_HEADER"] = "Zone Map"
L["FULL_SIZE_MAP"] = "Open the Zone Map Full Size"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Opens the zone map maximized, as its own maximize button does, so the route has room. If you shrink the map, it opens full size again next time."
L["HIDE_QUESTIE_ICONS"] = "Hide Questie's Icons on the Route"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Hides Questie's map icons for what's on the route, so the markers stand in for them. Hover a marker to see its icons."
L["ROUTES_MARKERS_HEADER"] = "Markers"
L["MARKER_SIZE"] = "Marker Size"
L["MARKER_SIZE_DESCRIPTION"] = "How big the route's markers are on the zone map."
L["MARKER_SIZE_SMALL"] = "Small"
L["MARKER_SIZE_MEDIUM"] = "Medium"
L["MARKER_SIZE_LARGE"] = "Large"
L["MARKER_SIZE_HUGE"] = "Huge"
L["ROUTES_LINE_HEADER"] = "Route Line"
L["SHOW_ROUTE_LINE"] = "Show the Route Line"
L["SHOW_ROUTE_LINE_DESCRIPTION"] = "Draws marching dots from you to each marker in turn. Off shows just the markers."
L["LINE_SPEED"] = "Line Speed"
L["LINE_SPEED_DESCRIPTION"] = "How fast the dots march toward the next marker."
L["LINE_SPEED_STILL"] = "Still"
L["LINE_SPEED_SLOW"] = "Slow"
L["LINE_SPEED_NORMAL"] = "Normal"
L["LINE_SPEED_FAST"] = "Fast"
L["LINE_OPACITY"] = "Line Opacity"
L["LINE_OPACITY_DESCRIPTION"] = "How solid the dots are; lower lets more of the map show through."
L["ROUTES_PARTY_HEADER"] = "Party"
L["PARTY_QUESTS"] = "Include Party Members' Quests"
L["PARTY_QUESTS_DESCRIPTION"] =
	"In a party, the route and the Quest Arrow also take in quests your party members have and you don't, shown just like your own. It needs Questie on both ends to share them. Their dungeon quests are left out, as yours are."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Quest Arrow"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"An arrow on screen pointing to the next waypoint on the route, with the quests and objectives to do there. Right-click it to reroute around the current objective; middle-click it to reset all routes."
L["QUEST_ARROW_HEADER"] = "Arrow"
L["ARROW_SIZE"] = "Arrow Size"
L["ARROW_SIZE_DESCRIPTION"] = "How big the Quest Arrow is, with the text under it."
L["ARROW_CYCLE"] = "Eye and Arrow Cycle (Seconds)"
L["ARROW_CYCLE_DESCRIPTION"] =
	"In an objective area, the Quest Arrow takes turns: the eye, listing the objectives around you, then the arrow, pointing on to the next waypoint. Each gets half of this time."
L["LOCK_ARROW"] = "Lock the Quest Arrow"
L["LOCK_ARROW_DESCRIPTION"] = "Keeps the Quest Arrow where it is, so dragging it does nothing."
L["RESET_ARROW"] = "Arrow Position"
L["RESET_ARROW_BUTTON"] = "Reset"
L["RESET_ARROW_DESCRIPTION"] = "Puts the Quest Arrow back where it starts, near the top middle of the screen."
L["QUEST_ARROW_TEXT_HEADER"] = "Under the Arrow"
L["SHOW_DISTANCE"] = "Show Distance"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] = 'Shows how many yards away the next waypoint is. "%s" and "%s" show either way.'
L["SHOW_ARROW_QUESTS"] = "Show Quests and Objectives"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] = "Lists the quests at the next waypoint, each with what's left to do there."
L["QUESTS_LISTED"] = "Maximum Quests Listed"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'The most quests the Quest Arrow lists under itself for one waypoint. Any more are counted on a line of their own, such as "%s".'
L["QUEST_ARROW_HIDING_HEADER"] = "Hiding"
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
L["QUEST_LEVEL_LEGEND"] = "Letters after the level: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "Quest ID %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Quest Chain (%d of %d)"
L["DAILY_RESET"] = "Daily quests reset in %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Click for a Wowhead link."
L["WOWHEAD_LINK_COPY"] = "Press Ctrl+C (Cmd+C on a Mac) to copy the Wowhead link."
L["EXPAND_ALL"] = "Expand All"
L["COLLAPSE_ALL"] = "Collapse All"
L["TRACK_ALL"] = "Track All"
L["UNTRACK_ALL"] = "Untrack All"
L["HIDE_MAP"] = "Hide Map"
L["TURN_IN_XP"] = "%s XP"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "Turn In: %s"
L["TURN_IN_TOOLTIP"] = "Ready to Turn In"
L["RESIZE_TOOLTIP"] = "Drag to resize the quest log."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Share Quests"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Offers your party the quests in this zone the game lets you share, one every %d seconds."
L["CHAT_SHARING_ZONE_ONE"] = "Sharing 1 quest from %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Sharing %d quests from %s, one every %d seconds."
L["CHAT_SHARING_ZONE_NONE"] = "None of your quests from %s can be shared."

--------------------------------------------------------------------------------
-- Routes on Zone Map and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "You're there"
L["ROUTES_OBJECTIVE_AREA"] = "Objective Area"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d yds"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d more here"
L["ROUTES_TURN_IN"] = "Turn in quest"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Turn in %s"
L["ROUTES_CORPSE"] = "Your corpse"
L["ROUTES_CORPSE_HINT"] = "Run back to it to resurrect"
-- TRANSLATORS: Heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Look For"
L["ROUTES_CLICK_DRAG"] = "Drag"
L["ROUTES_CLICK_RIGHT"] = "Right-Click"
L["ROUTES_CLICK_MIDDLE"] = "Middle-Click"
L["ROUTES_DRAG_MOVE"] = "Move Quest Arrow"
L["ROUTES_RIGHT_CLICK_REROUTE"] = "Reroute Current Objective"
L["ROUTES_MIDDLE_CLICK_RESET"] = "Reset All Routes"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Rerouted around %s."
L["CHAT_FULL_SIZE_MAP_SET"] =
	"The zone map will open full size again. To keep it small, turn off Open the Zone Map Full Size under Routes on Zone Map."
L["ROUTES_RESET"] = "All routes reset: rerouted objectives are back on the route."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

-- TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
-- each %s is a quest link or a list of them, and each %d is how many quests
L["WHISPER_SHARE_FAILED"] =
	"I tried to share %s with you, but it didn't go through. If you'd like the quest, just give me a shout when you're ready and I'll share it again"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Same goes for %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "I have %d quests to do here: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "I have 1 quest to do here: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "More quests to do here: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] = "Questie's tracker can't show %s because the quest is missing from Questie's database."
L["QUESTIE_CANNOT_TRACK"] = "Questie can't track this quest yet."
