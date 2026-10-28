local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "deDE")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT_NAME"] = "PWQL"
L["CHAT_LOADED"] =
	"Version %s. Die Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) findest du unter Optionen > AddOns > Pretty Wide Quest Log. Gefällt dir dieses Add-on? Erzähl einem Freund davon, füge es auf CurseForge zu deinen Favoriten hinzu oder gib ihm auf GitHub einen Star. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen kann das Optionsmenü im Kampf nicht geöffnet werden."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Ohne Questie zeigt die Questkarte weniger, und Questreihen sowie die Abgabe-Übersicht bleiben verborgen. Aktiviere Questie in der AddOn-Liste, um sie zu sehen."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus ist ebenfalls aktiviert, und die beiden kommen sich beim Questlog in die Quere. Deaktiviere Wide Quest Log Plus in der AddOn-Liste und lade dann neu."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Ein breites, skalierbares Questlog mit zwei Spalten, Queststufen, Dungeon- und Elite-Kürzeln, Belohnungen, Questreihen und einer Questkarte für jede Quest. Teile Quests mit deiner Gruppe und sag Dungeonquests automatisch an. Funktioniert mit Questie, VoiceOver und ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Willkommensnachricht aktivieren"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Zeigt beim Einloggen die Willkommensnachricht von Pretty Wide Quest Log."
L["OPTIONS_FEATURES_HEADER"] = "Funktionen"
L["ENABLE_WIDE_QUEST_LOG"] = "Breites Questlog aktivieren"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Ersetzt Blizzards Questlog durch das breite, mit der Karte daneben. Wird nach einem Neuladen wirksam."
L["ENABLE_QUALITY_OF_LIFE"] = "Komfortfunktionen aktivieren"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Räumt das Questgeberfenster auf und hilft deiner Gruppe, deine Quests zu bekommen: Tempo beim Teilen, Flüsternachrichten, wenn ein Teilen jemanden verfehlt, sowie Ansage und Teilen von Dungeonquests. Quests teilen im Menü einer Zone funktioniert in jedem Fall."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Breites Questlog aktivieren wird nach einem Neuladen wirksam, das dir beim Schließen des Optionsmenüs angeboten wird."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log wechselt das Questlog erst nach einem Neuladen. Jetzt neu laden?"
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet das Optionsmenü für dieses Add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Ersetzt Blizzards Questlog durch ein breites: deine Quests nach Zone sortiert, daneben die Details der gewählten Quest und ihre Karte."
L["QUEST_LOG_LAYOUT_HEADER"] = "Aufbau des Questlogs"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"Sortiere deine Quests so, wie du spielst, wähle, was jede Zeile zeigt, und passe Fenster und Karte an deinen Bildschirm an."
L["ZONE_ORDER"] = "Reihenfolge der Zonen"
L["ZONE_ORDER_DESCRIPTION"] = "Ändert die Reihenfolge der Zonen in der Questliste."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Durchschnittsstufe, höchste zuerst (Standard)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Durchschnittsstufe, niedrigste zuerst"
L["SORT_ALPHABETICAL"] = "Alphabetisch"
L["CURRENT_ZONE_FIRST"] = "Aktuelle Zone zuerst zeigen"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Setzt die Zone, in der du dich befindest, an den Anfang der Liste, egal welche Reihenfolge der Zonen gewählt ist."
L["ZONE_GAP"] = "Abstand über Zonennamen einfügen"
L["ZONE_GAP_DESCRIPTION"] =
	"Fügt über jedem Zonennamen etwas Abstand ein. Praktisch, wenn deine Quests über viele Zonen verteilt sind."
L["QUEST_ORDER"] = "Reihenfolge der Quests"
L["QUEST_ORDER_DESCRIPTION"] = "Ändert die Reihenfolge der Quests unter jeder Zone."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Stufe, höchste zuerst (Standard)"
L["SORT_LEVEL_LOWEST"] = "Stufe, niedrigste zuerst"
L["COMPLETED_FIRST"] = "Abgeschlossene Quests zuerst zeigen"
L["COMPLETED_FIRST_DESCRIPTION"] = "Verschiebt Quests, die abgegeben werden können, an den Anfang ihrer Zone."
L["SHOW_QUEST_LEVELS"] = "Queststufen anzeigen"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Setzt die Stufe und Art jeder Quest vor ihren Namen in der Liste, etwa %s für eine Dungeonquest der Stufe 40."
L["MARK_UNTRACKED"] = "Nicht verfolgte Quests markieren"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Verfolgte Quests verlieren ihr Häkchen %s, und nicht verfolgte Quests bekommen stattdessen ein Auge %s. Praktisch, wenn du fast alles verfolgst."
L["CLOSE_IN_COMBAT"] = "Bei Kampfbeginn schließen"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Schließt das Questlog, sobald ein Kampf beginnt, damit es nie das Geschehen verdeckt."
L["SHOW_OBJECTIVE_AREAS"] = "Zielgebiete anzeigen"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Schattiert auf der Karte neben dem Questlog, wo die Gegner und Objekte jedes Ziels zu finden sind, mit einem Symbol pro Gebiet statt einem auf jedem Spawnpunkt. Benötigt Questie."
L["NEEDS_QUESTIE_HINT"] = "Aktiviere Questie, um dies zu nutzen."
L["WINDOW_SCALE"] = "Skalierung des Questlogs"
L["WINDOW_SCALE_DESCRIPTION"] = "Macht das Questlog größer oder kleiner. Die Karte daneben wächst und schrumpft mit."
L["MAP_SCALE"] = "Skalierung der Karte"
L["MAP_SCALE_DESCRIPTION"] =
	"Macht die Karte neben dem Questlog größer oder kleiner, zusätzlich zur Skalierung des Questlogs."
L["RESET_WINDOW_BUTTON"] = "Fenster zurücksetzen"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Setzt Höhe und Skalierung des Questlogs sowie die Skalierung der Karte auf ihre Standardwerte zurück."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Setzt Höhe und Skalierung des Questlogs sowie die Skalierung der Karte auf ihre Standardwerte zurück und bringt das Fenster an seine Ausgangsposition."
L["RESET_WINDOW_SCALE_CONFIRM"] = "Höhe und Skalierung des Questlogs zurücksetzen?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Höhe und Skalierung des Questlogs sowie seine Position auf dem Bildschirm zurücksetzen?"

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Komfortfunktionen"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Kleine Helfer außerhalb des Questlogs selbst: für das Questgeberfenster, zum Teilen von Quests mit deiner Gruppe und für Dungeons."
L["QUEST_GIVERS_HEADER"] = "Questgeber"
L["QUEST_GIVERS_DESCRIPTION"] = "Das Fenster, das ein Questgeber öffnet, in dem du Quests annimmst und abgibst."
L["GIVER_CLEANUP"] = "Aufgeräumtes Questgeberfenster"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Gestaltet den Text des Questgeberfensters wie den des Questlogs, mit denselben Überschriften und Zeilenabständen, und zeigt unter der Quest die Quest-ID mit einem Link zu Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] = "Ergänzt die Questliste eines Questgebers um die Stufenkürzel des Questlogs, etwa %s."
L["QUEST_SHARING_HEADER"] = "Quests teilen"
L["QUEST_SHARING_INTRO"] =
	"Rechtsklicke im Questlog auf einen Zonennamen, um deiner Gruppe nacheinander alle Quests dieser Zone anzubieten, die du teilen kannst. Diese Einstellungen bestimmen das Tempo und was passiert, wenn jemand eine verpasst."
L["SHARE_INTERVAL"] = "Sekunden zwischen dem Teilen"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Wie lange zwischen einer geteilten Quest und der nächsten gewartet wird, für Quests teilen und das Teilen von Dungeonquests. Je länger, desto mehr Zeit hat deine Gruppe, jede einzelne anzunehmen."
L["SHARE_WHISPERS"] = "Bei fehlgeschlagenem Teilen anflüstern"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Ist ein Gruppenmitglied beschäftigt, zu weit weg oder hat ein volles Questlog, flüsterst du ihm, welche Quest du teilen wolltest, und bittest es, dich daran zu erinnern. Nichts wird gesendet, wenn es die Voraussetzungen für die Quest nicht erfüllt, sie schon hat oder sie bereits erledigt hat."
L["SAMPLE_EXAMPLE"] = "Beispiel: %s"
L["SAMPLE_QUEST_LOADING"] = "Lade Quest-ID: %d"
L["DUNGEON_QUESTS_HEADER"] = "Dungeonquests"
L["DUNGEON_QUESTS_INTRO"] =
	"Wenn du mit deiner Gruppe einen Dungeon oder Schlachtzug betrittst, werden deine Quests dafür angesagt und geteilt, einmal pro Gruppe für jeden Dungeon. Mit Questie zählen auch Quests, deren Ziele darin liegen, Klassenquests eingeschlossen."
L["DUNGEON_ANNOUNCE"] = "Automatische Ansage von Dungeonquests"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Sagt deiner Gruppe, welche deiner Quests im eben betretenen Dungeon noch offen sind, damit alle wissen, worauf sie achten müssen. Quests, die bereit zur Abgabe sind, werden ausgelassen."
L["DUNGEON_SHARE"] = "Automatisches Teilen von Dungeonquests"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Teilt jede Quest für den Dungeon, die das Spiel teilen lässt, im unter Quests teilen eingestellten Tempo. Ist Bei fehlgeschlagenem Teilen anflüstern aktiviert, wird jeder angeflüstert, der eine geteilte Quest verpasst, damit er noch einmal fragen kann. Teilt erneut, sobald jemand der Gruppe beitritt oder sie verlässt."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Hilf Pretty Wide Quest Log beim Stufenaufstieg"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Dieses Add-on wurde von Spielern entwickelt, die dieses Spiel lieben und es für alle so unterhaltsam wie möglich machen wollen. Wir werden nie um Spenden bitten. Die eigentliche Belohnung ist das Wissen, dass unsere Arbeit das Spiel für dich ein bisschen besser macht. Wenn das so ist, würden wir uns freuen, davon zu hören!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Hier sind ein paar Möglichkeiten, wie du uns helfen kannst, mehr Spieler zu erreichen."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Feedback geben: Einen Fehler gefunden oder eine Idee? Sag uns auf Discord Bescheid. Dein Feedback hilft uns, das Add-on zu verbessern, und Pull Requests sind jederzeit willkommen."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Einem Freund erzählen: Kennst du jemanden, dem dieses Add-on gefallen könnte? Erzähl ihm davon. Mundpropaganda hilft mehr Spielern, großartige Add-ons zu entdecken."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Auf CurseForge favorisieren: Öffne unten den CurseForge-Link, melde dich an und klicke auf den Stern unter dem Download-Button. Favoriten helfen mehr Spielern, das Add-on zu entdecken."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Auf GitHub einen Star geben: Öffne unten den GitHub-Link, melde dich an und klicke oben rechts auf Star. Sterne helfen dem Projekt, sich für mehr kostenlose Entwicklerwerkzeuge zu qualifizieren."
L["OPTIONS_LEVEL_UP_THANKS"] = "Danke, dass du dich für Pretty Wide Quest Log entschieden hast!"
L["OPTIONS_FEEDBACK"] = "Feedback & Unterstützung"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Links für Feedback & Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Um einen Link zu kopieren, klicke in sein Feld und drücke dann Strg+A und Strg+C."
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "D"
L["QUEST_SUFFIX_RAID"] = "S"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "Dungeon"
L["QUEST_TYPE_RAID"] = "Schlachtzug"
L["QUEST_TYPE_GROUP"] = "Gruppe"
L["QUEST_TYPE_ELITE"] = "Elite"
L["QUEST_TYPE_PVP"] = "PvP"
L["QUEST_LEVEL_LEGEND"] = "Buchstaben nach der Stufe: %s."
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_LEVEL_LEGEND_SEPARATOR"] = ", "
L["QUEST_ID"] = "Quest-ID %d"
L["QUEST_CHAIN_PROGRESS"] = "Questreihe (%d von %d)"
L["DAILY_RESET"] = "Tägliche Quests werden in %s zurückgesetzt."
L["WOWHEAD_LINK_TOOLTIP"] = "Klicken für einen Wowhead-Link."
L["WOWHEAD_LINK_COPY"] = "Drücke Strg+C (Cmd+C auf dem Mac), um den Wowhead-Link zu kopieren."
L["EXPAND_ALL"] = "Alle ausklappen"
L["COLLAPSE_ALL"] = "Alle einklappen"
L["TRACK_ALL"] = "Alle verfolgen"
L["UNTRACK_ALL"] = "Keine verfolgen"
L["HIDE_MAP"] = "Karte verbergen"
L["TURN_IN_XP"] = "%s EP"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "Abgabe: %s"
L["TURN_IN_TOOLTIP"] = "Bereit zur Abgabe"
L["RESIZE_TOOLTIP"] = "Ziehen, um die Größe des Questlogs zu ändern."

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_ACTIONS_HINT"] = "Rechtsklick, um Quests zu teilen oder graue abzubrechen"
L["SHARE_ZONE_QUESTS"] = "%d Quests teilen"
L["SHARE_ZONE_QUEST"] = "1 Quest teilen"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Bietet deiner Gruppe die Quests dieser Zone an, die das Spiel teilen lässt, eine alle %d Sekunden."
L["SHARE_ZONE_QUEST_TOOLTIP"] = "Bietet deiner Gruppe die eine Quest dieser Zone an, die das Spiel teilen lässt."
L["CHAT_SHARING_ZONE_ONE"] = "Teile 1 Quest aus %s."
L["CHAT_SHARING_ZONE"] = "Teile %d Quests aus %s, eine alle %d Sekunden."
L["ABANDON_GRAY_QUESTS"] = "Graue Quests abbrechen"
L["ABANDON_GRAY_NONE"] = "In dieser Zone gibt es keine grauen Quests zum Abbrechen."
L["ABANDON_GRAY_CONFIRM"] = "Diese %d grauen Quests abbrechen?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "Diese graue Quest abbrechen?"
L["CHAT_ABANDONED_GRAY"] = "%d graue Quests abgebrochen."
L["CHAT_ABANDONED_GRAY_ONE"] = "1 graue Quest abgebrochen."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_FAILED"] =
	"Ich wollte %s mit dir teilen, aber es hat nicht geklappt. Wenn du die Quest möchtest, sag einfach Bescheid, sobald du bereit bist, dann teile ich sie noch mal"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Das gilt auch für %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Ich habe hier %d Quests zu erledigen: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Ich habe hier 1 Quest zu erledigen: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Weitere Quests, die ich hier erledigen muss: %s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Der Tracker von Questie kann %s nicht anzeigen, weil die Quest in der Datenbank von Questie fehlt."
L["QUESTIE_CANNOT_TRACK"] = "Questie kann diese Quest noch nicht verfolgen."
