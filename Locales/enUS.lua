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
	"Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Pretty Wide Quest Log. Enjoying the add-on? Tell a friend about it! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."
L["CHAT_QUESTIE_MISSING"] =
	"We use Questie data to power a lot of this add-on. Without Questie, you will have reduced functionality."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus is also turned on, and the two will fight over the quest log. Turn off Wide Quest Log Plus in the AddOns list, then reload."

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"A bigger, better quest log that gives you more room to read and more information at a glance. Keep Blizzard's familiar layout while seeing quest levels, useful tags, objectives, rewards, and your entire quest list side by side."
L["ENABLE_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Shows the Pretty Wide Quest Log greeting when you log in."
L["OPTIONS_FEATURES_HEADER"] = "Features"
L["ENABLE_QUEST_LOG_CLEANUP"] = "Enable Quest Log Cleanup"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Swaps Blizzard's quest log for the wide one, with the map beside it. Turn it off to use Blizzard's quest log instead. Takes effect after a reload."
L["ENABLE_QUALITY_OF_LIFE"] = "Enable Quality of Life"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Turns on the quest giver window cleanup, your own pace for shared quests, and whispers when a quest share fails. Turn it off to get Blizzard's quest giver window back and share at the default pace."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Enable Quest Log Cleanup takes effect after a reload, offered when you close the Options Interface."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log switches quest logs after a reload. Reload now?"
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."
L["FEEDBACK_HEADER"] = "Feedback & Support"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG"] = "Quest Log"
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
L["ZONE_GAP"] = "Space Above Zone Names"
L["ZONE_GAP_DESCRIPTION"] =
	"Adds a little space above each zone name. Handy when your quests are spread across lots of zones."
L["QUEST_ORDER"] = "Quest Order"
L["QUEST_ORDER_DESCRIPTION"] = "Changes the order of the quests under each zone."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Level, Highest First (Default)"
L["SORT_LEVEL_LOWEST"] = "Level, Lowest First"
L["COMPLETED_FIRST"] = "Completed Quests First"
L["COMPLETED_FIRST_DESCRIPTION"] = "Moves quests that are ready to turn in to the top of their zone."
L["SHOW_QUEST_LEVELS"] = "Show Quest Levels"
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Puts each quest's level and type in front of its name in the list, like [40D] for a level 40 dungeon quest."
L["MARK_UNTRACKED"] = "Mark Untracked Quests"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Tracked quests lose their checkmark %s, and untracked quests get an eye %s instead. Handy if you track almost everything."
L["CLOSE_IN_COMBAT"] = "Close When Combat Starts"
L["CLOSE_IN_COMBAT_DESCRIPTION"] = "Closes the quest log when a fight starts, so it never covers the action."
L["WINDOW_SCALE"] = "Quest Log Scale"
L["WINDOW_SCALE_DESCRIPTION"] = "Makes the quest log bigger or smaller. The map beside it grows and shrinks with it."
L["MAP_SCALE"] = "Map Scale"
L["MAP_SCALE_DESCRIPTION"] = "Makes the map beside the quest log bigger or smaller, on top of the Quest Log Scale."
L["RESET_WINDOW"] = "Reset Size and Position"
L["RESET_WINDOW_DESCRIPTION"] = "Puts the quest log back to its default size and position."
L["RESET_WINDOW_CONFIRM"] = "Reset the quest log to its default size and position?"

--------------------------------------------------------------------------------
-- Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Quality of Life"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Small helpers outside the quest log itself, for the quest giver window and for sharing quests with your party."
L["QUEST_GIVERS_HEADER"] = "Quest Givers"
L["QUEST_GIVERS_DESCRIPTION"] = "The window a quest giver opens, where you pick up quests and turn them in."
L["GIVER_CLEANUP"] = "Enable Quest Giver Window Cleanup"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Sets the quest giver window's text like the quest log's, with the same headings and line spacing, and shows the quest ID, linked to Wowhead, under the quest."
L["GIVER_LEVELS"] = "Show Quest Levels"
L["GIVER_LEVELS_DESCRIPTION"] = "Adds the quest log's level tags, like [40D], to a quest giver's list of quests."
L["QUEST_SHARING_HEADER"] = "Quest Sharing"
L["QUEST_SHARING_DESCRIPTION"] =
	"Share Quests, on a zone's right-click menu in the quest log, offers your party every quest in that zone they can take, one after another. These set the pace, and what happens when a party member misses one."
L["SHARE_INTERVAL"] = "Seconds Between Shares"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"How long Share Quests, on a zone's right-click menu, waits between one quest and the next. Longer gives your party more time to accept each one."
L["SHARE_WHISPERS"] = "Whisper When a Share Fails"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"When a party member is busy, too far away, or has a full quest log, whispers them which quest you tried to share and asks them to remind you. Nothing is sent when they can't take the quest."
L["SHARE_WHISPER_EXAMPLE"] = "Example:"
L["SHARE_WHISPER_EXAMPLE_QUEST_NAME"] = "Quest Name"

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
L["SHARE_ZONE_TOOLTIP"] = "%d of the %d quests in this zone can be shared. They go out one every %d seconds."
L["CHAT_SHARING_ZONE_ONE"] = "Sharing 1 quest from %s."
L["CHAT_SHARING_ZONE"] = "Sharing %d quests from %s, one every %d seconds."
L["WHISPER_SHARE_BUSY"] =
	"I tried to share %s with you, but you looked busy. If you'd like it, just give me a shout when you're free and I'll send it again."
L["WHISPER_SHARE_TOO_FAR"] =
	"I tried to share %s with you, but we were too far apart. If you'd like it, just give me a shout when we're closer and I'll send it again."
L["WHISPER_SHARE_LOG_FULL"] =
	"I tried to share %s with you, but your quest log was full. If you'd like it, just give me a shout once you've made room and I'll send it again."
L["ABANDON_GRAY_QUESTS"] = "Abandon Gray Quests"
L["ABANDON_GRAY_NONE"] = "This zone has no gray quests to abandon."
L["ABANDON_GRAY_CONFIRM"] = "Abandon these %d gray quests?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "Abandon this gray quest?"
L["CHAT_ABANDONED_GRAY"] = "Abandoned %d gray quests."
L["CHAT_ABANDONED_GRAY_ONE"] = "Abandoned 1 gray quest."

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] = "Questie's tracker can't show %s because the quest is missing from Questie's database."
L["QUESTIE_CANNOT_TRACK"] = "Questie can't track this quest yet."
