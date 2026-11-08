local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "deDE")
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
	"Breites Questlog mit Questroute und Questpfeil. Du wählst die Quests, wir helfen dir mit einer sauberen Route, um sie schnell zu erledigen. Queststufen, Kürzel, Belohnungen, Questreihen, eine Questkarte und Quests mit der Gruppe teilen. Funktioniert mit Questie, Spoken, VoiceOver und ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Willkommensnachricht aktivieren"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Zeigt beim Einloggen die Willkommensnachricht von Pretty Wide Quest Log."
L["OPTIONS_FEATURES_HEADER"] = "Funktionen"
L["ENABLE_WIDE_QUEST_LOG"] = "Breites Questlog aktivieren"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Ersetzt Blizzards Questlog durch das breite, mit der Karte daneben. Wird nach einem Neuladen wirksam."
L["ENABLE_QUALITY_OF_LIFE"] = "Komfortfunktionen aktivieren"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Räumt das Questgeberfenster auf und hilft deiner Gruppe, deine Quests zu bekommen: Tempo beim Teilen, Flüsternachrichten, wenn ein Teilen jemanden verfehlt, sowie Ansage und Teilen von Dungeonquests. Die Schaltfläche Quests teilen einer Zone im Questlog funktioniert auch, wenn dies ausgeschaltet ist."
L["ENABLE_ROUTES_MAP"] = "Routen auf der Zonenkarte aktivieren"
L["FEATURE_ROUTES_MAP_DESCRIPTION"] =
	"Zeichnet auf der Zonenkarte eine Route durch deine Questziele und Abgaben, das Nächste zuerst, als wandernde Punkte zwischen Markierungen."
L["ENABLE_QUEST_ARROW"] = "Questpfeil aktivieren"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Zeigt einen Pfeil auf dem Bildschirm, den Questpfeil, der zum nächsten Wegpunkt der Route zeigt, mit den Quests und Zielen, die dort zu erledigen sind. Standardmäßig wird er in Schlachtzugsgruppen und Instanzen ausgeblendet."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Breites Questlog aktivieren wird nach einem Neuladen wirksam, das dir beim Schließen des Optionsmenüs angeboten wird."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log wechselt das Questlog erst nach einem Neuladen. Jetzt neu laden?"
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet das Optionsmenü für dieses Add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Breites Questlog"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Ersetzt Blizzards Questlog durch ein breites: deine Quests nach Zone sortiert, daneben die Details der gewählten Quest und ihre Karte."
L["QUEST_LOG_SORTING_HEADER"] = "Sortierung"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Wähle die Reihenfolge deiner Zonen und der Quests darunter."
L["QUEST_LOG_ROWS_HEADER"] = "Questzeilen"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Wähle, was jede Zeile zeigt."
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "Fenster & Karte"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"Passe Fenster und Karte an deinen Bildschirm an und wähle, wie sie sich verhalten."
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
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Verfolgte Quests verlieren ihr Häkchen %s, und nicht verfolgte Quests bekommen stattdessen ein Auge %s. Praktisch, wenn du fast alles verfolgst."
L["CLOSE_IN_COMBAT"] = "Bei Kampfbeginn schließen"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Schließt das Questlog, sobald ein Kampf beginnt, damit es nie das Geschehen verdeckt."
L["SHOW_OBJECTIVE_AREAS"] = "Zielgebiete anzeigen"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Schattiert auf der Karte neben dem Questlog, wo die Gegner und Objekte jedes Ziels zu finden sind, mit einem Symbol pro Gebiet statt einem auf jedem Spawnpunkt."
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
L["RESET_WINDOW_SCALE_CONFIRM"] = "Höhe und Skalierung des Questlogs sowie die Skalierung der Karte zurücksetzen?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Höhe und Skalierung des Questlogs, die Skalierung der Karte und die Position des Fensters auf dem Bildschirm zurücksetzen?"
L["HANDY_CLICKS_HEADER"] = "Praktische Klicks"
L["HANDY_CLICK_TRACK"] = "Umschalt-Klick auf eine Quest"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "Verfolge sie oder beende die Verfolgung."
L["HANDY_CLICK_MENU"] = "Rechtsklick auf eine Quest"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "Verfolge sie, teile sie oder brich sie ab."
L["HANDY_CLICK_ID"] = "Klick auf eine Quest-ID"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Hol dir ihren Wowhead-Link."

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
	"Fahre im Questlog mit der Maus über einen Zonennamen und klicke auf Quests teilen, um deiner Gruppe nacheinander alle Quests dieser Zone anzubieten, die du teilen kannst. Diese Einstellungen bestimmen das Tempo und was passiert, wenn jemand eine verpasst."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"Die Schaltfläche Quests teilen an einem Zonennamen benötigt Breites Questlog aktivieren. Das Teilen von Dungeonquests funktioniert auch ohne."
L["SHARE_INTERVAL"] = "Sekunden zwischen dem Teilen"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Wie lange zwischen einer geteilten Quest und der nächsten gewartet wird, wenn du die Quests einer Zone oder eines Dungeons teilst. Je länger, desto mehr Zeit hat deine Gruppe, jede einzelne anzunehmen."
L["SHARE_WHISPERS"] = "Bei fehlgeschlagenem Teilen anflüstern"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Ist ein Gruppenmitglied beschäftigt, zu weit weg oder hat ein volles Questlog, flüsterst du ihm, welche Quest du teilen wolltest, und bittest es, dich daran zu erinnern. Nichts wird gesendet, wenn es die Voraussetzungen für die Quest nicht erfüllt, sie schon hat oder sie bereits erledigt hat."
L["SAMPLE_EXAMPLE"] = "Beispiel: %s"
L["SAMPLE_QUEST_LOADING"] = "Lade Quest-ID: %d"
L["DUNGEON_QUESTS_HEADER"] = "Dungeonquests"
L["DUNGEON_QUESTS_INTRO"] =
	"Wenn du mit deiner Gruppe einen Dungeon betrittst, werden deine Quests dafür angesagt und geteilt, sobald alle in Reichweite sind (auf WoW Forever sofort), und nie zweimal an dieselbe Gruppe. Mit Questie zählen auch Quests, deren Ziele darin liegen, Klassenquests eingeschlossen. In einer Schlachtzugsgruppe passiert nichts."
L["DUNGEON_ANNOUNCE"] = "Automatische Ansage von Dungeonquests"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Sagt deiner Gruppe, welche deiner Quests im eben betretenen Dungeon noch zu erledigen sind, damit alle wissen, worauf sie achten müssen. Quests, die bereit zur Abgabe sind, werden ausgelassen."
L["DUNGEON_SHARE"] = "Automatisches Teilen von Dungeonquests"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Teilt jede Quest für den Dungeon, die das Spiel teilen lässt, im unter Quests teilen eingestellten Tempo, sobald alle in Reichweite sind (oder nach einer Minute; auf WoW Forever sofort). Jedes Gruppenmitglied erhält sie einmal pro Dungeon, also auch, wer später beitritt, und Raus- und wieder Reinzonen teilt nichts. Ist Bei fehlgeschlagenem Teilen anflüstern aktiviert, wird jeder angeflüstert, den ein Teilen verfehlt, damit er noch einmal fragen kann."

--------------------------------------------------------------------------------
-- Options: Routes on Zone Map Panel
--------------------------------------------------------------------------------

L["TAB_ROUTES_MAP"] = "Routen auf der Zonenkarte"
L["TAB_ROUTES_MAP_DESCRIPTION"] =
	"Eine Route durch deine Questziele und Abgaben auf der Zonenkarte, in der Reihenfolge, in der du sie erledigst, ausgehend von deinem Standort."
L["ROUTES_MAP_HEADER"] = "Zonenkarte"
L["ROUTES_MAP_DESCRIPTION"] = "Wie sich die Zonenkarte öffnet, während sie die Route zeigt."
L["FULL_SIZE_MAP"] = "Zonenkarte in voller Größe öffnen"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Öffnet die Zonenkarte maximiert, wie es ihr eigener Maximieren-Button tut, damit die Route Platz hat. Verkleinerst du die Karte, öffnet sie sich beim nächsten Mal wieder in voller Größe."
L["HIDE_QUESTIE_ICONS"] = "Questie-Symbole auf der Route ausblenden"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Blendet die Kartensymbole von Questie für alles auf der Route aus, sodass die Markierungen sie ersetzen. Fahre mit der Maus über eine Markierung, um ihre Symbole zu sehen."
L["ROUTES_MARKERS_HEADER"] = "Markierungen"
L["ROUTES_MARKERS_DESCRIPTION"] = "Die Markierungen für jeden Wegpunkt der Route."
L["MARKER_SIZE"] = "Größe der Markierungen"
L["MARKER_SIZE_DESCRIPTION"] = "Wie groß die Markierungen der Route auf der Zonenkarte sind."
L["MARKER_SIZE_SMALL"] = "Klein"
L["MARKER_SIZE_MEDIUM"] = "Mittel"
L["MARKER_SIZE_LARGE"] = "Groß"
L["MARKER_SIZE_HUGE"] = "Riesig"
L["ROUTES_LINE_HEADER"] = "Routenlinie"
L["ROUTES_LINE_DESCRIPTION"] = "Die wandernden Punkte, die von dir zu jeder Markierung führen."
L["SHOW_ROUTE_LINE"] = "Routenlinie anzeigen"
L["SHOW_ROUTE_LINE_DESCRIPTION"] =
	"Zeichnet wandernde Punkte von dir zu jeder Markierung, eine nach der anderen. Ausgeschaltet sind nur die Markierungen zu sehen."
L["LINE_SPEED"] = "Geschwindigkeit der Linie"
L["LINE_SPEED_DESCRIPTION"] = "Wie schnell die Punkte zur nächsten Markierung wandern."
L["LINE_SPEED_STILL"] = "Stillstehend"
L["LINE_SPEED_SLOW"] = "Langsam"
L["LINE_SPEED_NORMAL"] = "Normal"
L["LINE_SPEED_FAST"] = "Schnell"
L["LINE_OPACITY"] = "Deckkraft der Linie"
L["LINE_OPACITY_DESCRIPTION"] = "Wie deckend die Punkte sind; je niedriger, desto mehr von der Karte scheint durch."
L["ROUTES_PARTY_HEADER"] = "Gruppe"
L["ROUTES_PARTY_DESCRIPTION"] = "Was deine Gruppe zur Route beiträgt."
L["PARTY_QUESTS"] = "Quests von Gruppenmitgliedern einbeziehen"
L["PARTY_QUESTS_DESCRIPTION"] =
	"In einer Gruppe beziehen die Route und der Questpfeil auch Quests ein, die deine Gruppenmitglieder haben und du nicht, und zeigen sie genau wie deine eigenen. Zum Teilen braucht es Questie auf beiden Seiten. Ihre Dungeonquests werden ausgelassen, da deren Ziele im Dungeon liegen."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Questpfeil"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Ein Pfeil auf dem Bildschirm, der zum nächsten Wegpunkt der Route zeigt, mit den Quests und Zielen, die dort zu erledigen sind. Fahre mit der Maus darüber, um ein Menü zu sehen, in dem du jeweils ein Ziel ignorieren und sehen kannst, was du ignoriert hast. Klicke ihn mit der mittleren Maustaste, um die Ignorierliste zu leeren."
L["QUEST_ARROW_HEADER"] = "Pfeil"
L["QUEST_ARROW_DESCRIPTION"] = "Wo der Questpfeil sitzt und wie groß er ist."
L["ARROW_SIZE"] = "Größe des Pfeils"
L["ARROW_SIZE_DESCRIPTION"] = "Wie groß der Questpfeil ist, samt dem Text darunter."
L["LOCK_ARROW"] = "Questpfeil sperren"
L["LOCK_ARROW_DESCRIPTION"] = "Hält den Questpfeil an seinem Platz, sodass Ziehen nichts bewirkt."
L["RESET_ARROW"] = "Position des Pfeils"
L["RESET_ARROW_BUTTON"] = "Zurücksetzen"
L["RESET_ARROW_CONFIRM"] = "Den Questpfeil an seine Ausgangsposition zurücksetzen?"
L["RESET_ARROW_DESCRIPTION"] =
	"Bringt den Questpfeil an seine Ausgangsposition oben in der Mitte des Bildschirms zurück."
L["QUEST_ARROW_TEXT_HEADER"] = "Unter dem Pfeil"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "Was der Questpfeil unter sich auflistet."
L["SHOW_DISTANCE"] = "Entfernung anzeigen"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'Zeigt, wie viele Meter der nächste Wegpunkt entfernt ist. "%s" und "%s" werden so oder so angezeigt.'
L["SHOW_ARROW_QUESTS"] = "Quests und Ziele anzeigen"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"Listet die Quests am nächsten Wegpunkt auf, jede mit dem, was dort noch zu tun ist."
L["QUESTS_LISTED"] = "Höchstens aufgelistete Quests"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'So viele Quests listet der Questpfeil für einen Wegpunkt höchstens unter sich auf. Weitere werden in einer eigenen Zeile gezählt, etwa "%s".'
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_NEXT_OBJECTIVE"] = "Nächstes Ziel anzeigen"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'Zeigt bei "%s" gedimmt "%s" darunter an: einen kleinen Pfeil zum darauffolgenden Wegpunkt und was dort zu tun ist.'
L["SHOW_UPCOMING_TURN_INS"] = "Kommende Abgaben anzeigen"
L["SHOW_UPCOMING_TURN_INS_DESCRIPTION"] =
	"Setzt die Abgabe jeder Quest schon vor dem Erfüllen der Ziele auf die Route, markiert mit Questies grauem Fragezeichen, damit du siehst, wo du sie abgibst. Ausgeschaltet kommt eine Abgabe erst auf die Route, wenn die Quest abgeschlossen ist."
L["QUEST_ARROW_HIDING_HEADER"] = "Ausblenden"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "Wann der Questpfeil aus dem Weg geht."
L["HIDE_IN_RAIDS"] = "In Schlachtzugsgruppen ausblenden"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "Blendet den Questpfeil aus, solange du in einer Schlachtzugsgruppe bist."
L["HIDE_IN_INSTANCES"] = "In Instanzen ausblenden"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "Blendet den Questpfeil in Dungeons, Schlachtzügen und auf Schlachtfeldern aus."

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

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
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
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "Quest-ID %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
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
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Quests teilen"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Bietet deiner Gruppe die Quests dieser Zone an, die das Spiel teilen lässt, eine alle %d Sekunden."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "Teile %s, sobald der Kampf endet."
L["CHAT_SHARING_ZONE_ONE"] = "Teile 1 Quest aus %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Teile %d Quests aus %s, eine alle %d Sekunden."
L["CHAT_SHARING_ZONE_NONE"] = "Keine deiner Quests aus %s kann geteilt werden."

--------------------------------------------------------------------------------
-- Routes on Zone Map and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Du bist da"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "Wegpunkt auf einer anderen Karte"
L["ROUTES_OBJECTIVE_AREA"] = "Aktuelles Zielgebiet"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "Hier abschließen, bevor es weitergeht"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "Weitere entlang der Route"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "Nächstes Ziel"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "Wenn du schon hier bist"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d Meter"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d Meter"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d weitere hier"
L["ROUTES_TURN_IN"] = "Quest abgeben"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "%s abgeben"
L["ROUTES_CORPSE"] = "Lauf zurück zu deinem Leichnam"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Suche nach"
L["ROUTES_CLICK_DRAG"] = "Ziehen"
L["ROUTES_CLICK_RIGHT"] = "Rechtsklick"
L["ROUTES_CLICK_MIDDLE"] = "Mittelklick"
L["ROUTES_DRAG_MOVE"] = "Questpfeil verschieben"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "Diesen Wegpunkt ignorieren"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "Dieses Ziel ignorieren"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "Wieder auf die Route"
L["ROUTES_MIDDLE_CLICK_RESET"] = "Alle Routen zurücksetzen"
L["ROUTES_MIDDLE_CLICK_CLEAR_IGNORED"] = "Ignorierliste leeren"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Die Route ignoriert %s, bis die Ignorierliste geleert wird."
L["ROUTES_RESET"] = "Alle Routen zurückgesetzt: ignorierte Ziele und Gruppenmitglieder sind wieder auf der Route."
L["ROUTES_IGNORE_CLEARED"] = "Ignorierliste geleert: ignorierte Ziele sind wieder auf der Route."
L["ROUTES_GROUP_JOINED_CLEARED"] =
	"Einer Gruppe beigetreten: ignorierte Ziele und Gruppenmitglieder sind wieder auf der Route."
L["ROUTES_GROUP_LEFT_CLEARED"] = "Gruppe verlassen: ignorierte Ziele und Gruppenmitglieder sind wieder auf der Route."
-- TRANSLATORS: the Quest Arrow's menu. %s is an objective, such as "Kodo Liver", or ROUTES_MENU_TURN_IN
L["ROUTES_MENU_IGNORE"] = "%s ignorieren"
-- TRANSLATORS: beside each objective or turn-in on the Quest Arrow menu's ignore list
L["ROUTES_MENU_IGNORED"] = "Ignoriert"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "Abgabe von %s"
L["ROUTES_MENU_GROUP_OBJECTIVES"] = "Gruppenziele anzeigen"
L["ROUTES_MENU_ON"] = "An"
L["ROUTES_MENU_OFF"] = "Aus"
L["ROUTES_MENU_OUT_OF_ZONE"] = "Außerhalb der Zone"
L["ROUTES_MENU_NO_QUESTIE"] = "Kein Questie"
L["ROUTES_MENU_OFFLINE"] = "Offline"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "Ziele von %s"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "Die Route ignoriert %s für %s, bis die Ignorierliste geleert wird."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s ist wieder auf der Route."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "Die Ziele von %s werden von der Route ausgenommen."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "Die Ziele von %s sind wieder auf der Route."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

-- TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
-- each %s is a quest link or a list of them, and each %d is how many quests
L["WHISPER_SHARE_FAILED"] =
	"Ich wollte %s mit dir teilen, aber es hat nicht geklappt. Wenn du die Quest möchtest, sag einfach Bescheid, sobald du bereit bist, dann teile ich sie noch mal"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Das gilt auch für %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Ich habe hier %d Quests zu erledigen: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Ich habe hier 1 Quest zu erledigen: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Weitere Quests, die ich hier erledigen muss: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Der Tracker von Questie kann %s nicht anzeigen, weil die Quest in der Datenbank von Questie fehlt."
L["QUESTIE_CANNOT_TRACK"] = "Questie kann diese Quest noch nicht verfolgen."
