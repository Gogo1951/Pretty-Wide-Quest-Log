local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "enUS", true)
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) are under Options > AddOns > Pretty Wide Quest Log. Enjoying this add-on? Tell a friend, Favorite it on CurseForge, or Star it on GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."
L["CHAT_QUESTIE_MISSING"] =
	"We use Questie's data to power a lot of this add-on, so some features are limited without it."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus is also turned on, and the two will fight over the quest log. Turn off Wide Quest Log Plus in the AddOns list, then reload."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"A wide, resizable dual-pane quest log with quest levels, dungeon and elite tags, rewards, quest chains, and a quest map for every quest. Share quests with your party and auto-announce dungeon quests. Works with Questie, VoiceOver, and ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Shows the Pretty Wide Quest Log welcome message when you log in."
L["OPTIONS_FEATURES_HEADER"] = "Features"
L["ENABLE_WIDE_QUEST_LOG"] = "Enable Wide Quest Log"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Swaps Blizzard's quest log for the wide one, with the map beside it. Takes effect after a reload."
L["ENABLE_QUALITY_OF_LIFE"] = "Enable Quality of Life"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Turns on the quest giver window cleanup, your own pace for shared quests, whispers when a quest share fails, and dungeon quest announcements and sharing. Turn it off to get Blizzard's quest giver window back and share at the default pace."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Enable Wide Quest Log takes effect after a reload, offered when you close the Options Interface."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log switches quest logs after a reload. Reload now?"
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Replaces Blizzard's quest log with a wide one: your quests listed by zone, with the selected quest's details and its map beside them."
L["QUEST_LOG_LAYOUT_HEADER"] = "Quest Log Layout"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"Sort your quests the way you play, choose what each row shows, and size the window and map to fit your screen."
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
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Puts each quest's level and type in front of its name in the list, like [40D] for a level 40 dungeon quest."
L["MARK_UNTRACKED"] = "Mark Untracked Quests"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Tracked quests lose their checkmark %s, and untracked quests get an eye %s instead. Handy if you track almost everything."
L["CLOSE_IN_COMBAT"] = "Close When Combat Starts"
L["CLOSE_IN_COMBAT_DESCRIPTION"] = "Closes the quest log when a fight starts, so it never covers the action."
L["SHOW_OBJECTIVE_AREAS"] = "Show Objective Areas"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Shades where each objective's mobs and objects are found on the map beside the quest log, with one icon in each area instead of one on every spawn. Needs Questie."
L["WINDOW_SCALE"] = "Quest Log Scale"
L["WINDOW_SCALE_DESCRIPTION"] = "Makes the quest log bigger or smaller. The map beside it grows and shrinks with it."
L["MAP_SCALE"] = "Map Scale"
L["MAP_SCALE_DESCRIPTION"] = "Makes the map beside the quest log bigger or smaller, on top of the Quest Log Scale."
L["RESET_WINDOW"] = "Reset Size and Position"
L["RESET_WINDOW_DESCRIPTION"] = "Puts the quest log back to its default size and position."
L["RESET_WINDOW_CONFIRM"] = "Reset the quest log to its default size and position?"

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
L["GIVER_LEVELS"] = "Show Quest Levels"
L["GIVER_LEVELS_DESCRIPTION"] = "Adds the quest log's level tags, like [40D], to a quest giver's list of quests."
L["QUEST_SHARING_HEADER"] = "Quest Sharing"
L["QUEST_SHARING_DESCRIPTION"] =
	"Share Quests, on a zone's right-click menu in the quest log, offers your party every quest in that zone the game lets you share, one after another. The settings below set the pace and what happens when a party member misses one."
L["SHARE_INTERVAL"] = "Seconds Between Shares"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"How long to wait between one shared quest and the next, for Share Quests and dungeon quest sharing. Longer gives your party more time to accept each one."
L["SHARE_WHISPERS"] = "Whisper When a Share Fails"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"When a party member is busy, too far away, or has a full quest log, whispers them which quest you tried to share and asks them to remind you. Nothing is sent when they can't take the quest."
L["OPTIONS_EXAMPLE"] = "Example:"
L["OPTIONS_EXAMPLE_QUEST_NAME"] = "Quest Name"
L["DUNGEON_QUESTS_HEADER"] = "Dungeon Quests"
L["DUNGEON_QUESTS_DESCRIPTION"] =
	"These kick in when you enter a dungeon or raid with your group, once per group for each dungeon. A quest counts if it's listed under the dungeon in your quest log or, with Questie, if any of its objectives are inside, which catches class quests too."
L["DUNGEON_ANNOUNCE"] = "Automatic Dungeon Quest Announcements"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Tells your group which of your quests still need doing in the dungeon you just entered, so everyone knows what to look out for. Quests ready to turn in are left out."
L["DUNGEON_SHARE"] = "Automatic Dungeon Quest Sharing"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Shares every quest for the dungeon that the game lets you share, at the pace set under Quest Sharing. With Whisper When a Share Fails on, anyone a share misses is whispered so they can ask again. Shares again whenever someone joins or leaves the group."

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

L["QUEST_SUFFIX_DUNGEON"] = "D"
L["QUEST_SUFFIX_RAID"] = "R"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "Quest ID %d"
L["QUEST_CHAIN"] = "Quest Chain"
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
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_HINT"] = "Right-Click for More Options"
L["SHARE_ZONE_QUESTS"] = "Share %d Quests"
L["SHARE_ZONE_QUEST"] = "Share 1 Quest"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Offers your party the quests in this zone the game lets you share, one every %d seconds."
L["SHARE_ZONE_QUEST_TOOLTIP"] = "Offers your party the one quest in this zone the game lets you share."
L["CHAT_SHARING_ZONE_ONE"] = "Sharing 1 quest from %s."
L["CHAT_SHARING_ZONE"] = "Sharing %d quests from %s, one every %d seconds."
L["ABANDON_GRAY_QUESTS"] = "Abandon Gray Quests"
L["ABANDON_GRAY_NONE"] = "This zone has no gray quests to abandon."
L["ABANDON_GRAY_CONFIRM"] = "Abandon these %d gray quests?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "Abandon this gray quest?"
L["CHAT_ABANDONED_GRAY"] = "Abandoned %d gray quests."
L["CHAT_ABANDONED_GRAY_ONE"] = "Abandoned 1 gray quest."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_FAILED"] =
	"I tried to share %s with you, but it didn't go through. If you'd like the quest, just give me a shout when you're ready and I'll share it again."
L["WHISPER_SHARE_FAILED_AGAIN"] = "Same goes for %s."
L["DUNGEON_QUESTS_ANNOUNCE"] = "I have %d quests to do here: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "I have 1 quest to do here: %s"
L["DUNGEON_QUESTS_ANNOUNCE_MORE"] = "%s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] = "Questie's tracker can't show %s because the quest is missing from Questie's database."
L["QUESTIE_CANNOT_TRACK"] = "Questie can't track this quest yet."
