local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "deDE")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["CHAT_LOADED"] =
	"Version %s. Die Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) findest du unter Optionen > AddOns > Pretty Wide Quest Log. Gefällt dir das Add-on? Erzähl deinen Freunden davon! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen kann das Optionsmenü im Kampf nicht geöffnet werden."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus ist ebenfalls aktiviert, und die beiden kommen sich beim Questlog in die Quere. Deaktiviere Wide Quest Log Plus in der AddOn-Liste und lade dann neu."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Ein größeres, schlaueres Questlog, das dir mehr Platz zum Lesen, mehr Informationen auf einen Blick und die Kontrolle darüber gibt, wie deine Quests geordnet sind. Behalte den vertrauten Blizzard-Look und lass das Questlog einfach besser für dich arbeiten."
L["ENABLE_WELCOME_MESSAGE"] = "Willkommensnachricht aktivieren"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Zeigt beim Einloggen die Begrüßung von Pretty Wide Quest Log."
L["ENABLE_WIDE_QUEST_LOG"] = "Pretty Wide Quest Log für dieses Profil aktivieren"
L["ENABLE_WIDE_QUEST_LOG_DESCRIPTION"] =
	"Sorgt dafür, dass die Questlog-Taste, die Schaltfläche im Mikromenü und Klicks auf Quests in der Zielverfolgung dieses breite Questlog öffnen. Deaktiviert öffnen sie stattdessen Blizzards Standard-Questlog, das in der Weltkarte angedockt ist. Wird nach einem Neuladen wirksam."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log wechselt das Questlog erst nach einem Neuladen. Jetzt neu laden?"
L["ZONE_ORDER"] = "Reihenfolge der Zonen"
L["ZONE_ORDER_DESCRIPTION"] = "Ändert die Reihenfolge der Zonen in der Questliste."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Durchschnittsstufe, höchste zuerst (Standard)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Durchschnittsstufe, niedrigste zuerst"
L["SORT_ALPHABETICAL"] = "Alphabetisch"
L["ZONE_GAP"] = "Abstand über Zonennamen"
L["ZONE_GAP_DESCRIPTION"] =
	"Fügt über jedem Zonennamen etwas Abstand ein. Praktisch, wenn deine Quests über viele Zonen verteilt sind."
L["QUEST_ORDER"] = "Reihenfolge der Quests"
L["QUEST_ORDER_DESCRIPTION"] = "Ändert die Reihenfolge der Quests unter jeder Zone."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Stufe, höchste zuerst (Standard)"
L["SORT_LEVEL_LOWEST"] = "Stufe, niedrigste zuerst"
L["MARK_UNTRACKED"] = "Nicht verfolgte Quests markieren"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Verfolgte Quests verlieren ihr Häkchen %s, und nicht verfolgte Quests bekommen stattdessen ein Auge %s. Praktisch, wenn du fast alles verfolgst."
L["RESET_WINDOW"] = "Größe und Position zurücksetzen"
L["RESET_WINDOW_DESCRIPTION"] = "Setzt das Questlog auf seine Standardgröße und -position zurück."
L["RESET_WINDOW_CONFIRM"] = "Questlog auf Standardgröße und -position zurücksetzen?"
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/wide"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet das Optionsmenü für dieses Add-on."
L["FEEDBACK_HEADER"] = "Feedback & Unterstützung"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Quest List and Details
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "D"
L["QUEST_SUFFIX_RAID"] = "S"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "Quest-ID %d"
L["EXPAND_ALL"] = "Alle ausklappen"
L["COLLAPSE_ALL"] = "Alle einklappen"
L["TRACK_ALL"] = "Alle verfolgen"
L["UNTRACK_ALL"] = "Keine verfolgen"
L["RESIZE_TOOLTIP"] = "Ziehen, um die Größe des Questlogs zu ändern"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Der Tracker von Questie kann %s nicht anzeigen, weil die Quest in der Datenbank von Questie fehlt."
L["QUESTIE_CANNOT_TRACK"] = "Questie kann diese Quest noch nicht verfolgen"
