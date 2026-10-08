local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "enUS", true)
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Pretty Wide Quest Log. Enjoying the add-on? Tell a friend about it! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus is also turned on, and the two will fight over the quest log. Turn off Wide Quest Log Plus in the AddOns list, then reload."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"A bigger, smarter quest log that gives you more room to read, more information at a glance, and control over how your quests are organized. Keep the familiar Blizzard look, just make the quest log work better for you."
L["ENABLE_WELCOME_MESSAGE"] = "Enable Welcome Message"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Shows the Pretty Wide Quest Log greeting when you log in."
L["ENABLE_WIDE_QUEST_LOG"] = "Enable Pretty Wide Quest Log for This Profile"
L["ENABLE_WIDE_QUEST_LOG_DESCRIPTION"] =
	"Makes the quest log key, the micro menu button and quest clicks in the objective tracker open this wide quest log. Turn it off to use Blizzard's default quest log, docked in the world map, instead. Takes effect after a reload."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log switches quest logs after a reload. Reload now?"
L["ZONE_ORDER"] = "Zone Order"
L["ZONE_ORDER_DESCRIPTION"] = "Changes the order of the zones in the quest list."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Average Level, Highest First (Default)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Average Level, Lowest First"
L["SORT_ALPHABETICAL"] = "Alphabetical"
L["ZONE_GAP"] = "Space Above Zone Names"
L["ZONE_GAP_DESCRIPTION"] =
	"Adds a little space above each zone name. Handy when your quests are spread across lots of zones."
L["QUEST_ORDER"] = "Quest Order"
L["QUEST_ORDER_DESCRIPTION"] = "Changes the order of the quests under each zone."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Level, Highest First (Default)"
L["SORT_LEVEL_LOWEST"] = "Level, Lowest First"
L["MARK_UNTRACKED"] = "Mark Untracked Quests"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Tracked quests lose their checkmark %s, and untracked quests get an eye %s instead. Handy if you track almost everything."
L["RESET_WINDOW"] = "Reset Size and Position"
L["RESET_WINDOW_DESCRIPTION"] = "Puts the quest log back to its default size and position."
L["RESET_WINDOW_CONFIRM"] = "Reset the quest log to its default size and position?"
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/wide"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."
L["FEEDBACK_HEADER"] = "Feedback & Support"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Quest List and Details
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "D"
L["QUEST_SUFFIX_RAID"] = "R"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "Quest ID %d"
L["EXPAND_ALL"] = "Expand All"
L["COLLAPSE_ALL"] = "Collapse All"
L["TRACK_ALL"] = "Track All"
L["UNTRACK_ALL"] = "Untrack All"
L["RESIZE_TOOLTIP"] = "Drag to resize the quest log"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] = "Questie's tracker can't show %s because the quest is missing from Questie's database."
L["QUESTIE_CANNOT_TRACK"] = "Questie can't track this quest yet"
