local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "frFR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > AddOns > Pretty Wide Quest Log. L'add-on vous plaît ? Parlez-en à un ami ! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Par mesure de sécurité, l'interface des options ne peut pas être ouverte en combat."
L["CHAT_QUESTIE_MISSING"] =
	"Une grande partie de cet add-on repose sur les données de Questie. Sans Questie, vous aurez moins de fonctionnalités."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus est aussi activé, et les deux vont se disputer le journal de quêtes. Désactivez Wide Quest Log Plus dans la liste des AddOns, puis rechargez."

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Un journal de quêtes large, redimensionnable et à double volet, avec le niveau des quêtes, des repères donjon et élite, les récompenses, les suites de quêtes et une carte pour chaque quête. Partagez des quêtes avec votre groupe et annoncez automatiquement les quêtes de donjon. Compatible avec Questie, VoiceOver et ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Activer le message de bienvenue"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Affiche le message d'accueil de Pretty Wide Quest Log à la connexion."
L["OPTIONS_FEATURES_HEADER"] = "Fonctionnalités"
L["ENABLE_QUEST_LOG_CLEANUP"] = "Activer le journal de quêtes épuré"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Remplace le journal de quêtes de Blizzard par le journal large, avec la carte à côté. Désactivez-le pour utiliser le journal de quêtes de Blizzard. Prend effet après un rechargement."
L["ENABLE_QUALITY_OF_LIFE"] = "Activer les améliorations de confort"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Active la fenêtre de donneur de quêtes épurée, votre propre rythme pour partager des quêtes, les chuchotements quand un partage échoue ainsi que l'annonce et le partage des quêtes de donjon. Désactivez-le pour retrouver la fenêtre de donneur de quêtes de Blizzard et partager au rythme par défaut."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Activer le journal de quêtes épuré prend effet après un rechargement, proposé à la fermeture de l'interface des options."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log change de journal de quêtes après un rechargement. Recharger maintenant ?"
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre l'interface des options de cet add-on."
L["FEEDBACK_HEADER"] = "Commentaires et assistance"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG"] = "Journal de quêtes"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Remplace le journal de quêtes de Blizzard par un journal large : vos quêtes classées par zone, avec à côté les détails de la quête sélectionnée et sa carte."
L["QUEST_LOG_LAYOUT_HEADER"] = "Disposition du journal de quêtes"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"Triez vos quêtes selon votre façon de jouer, choisissez ce qu'affiche chaque ligne et adaptez la taille de la fenêtre et de la carte à votre écran."
L["ZONE_ORDER"] = "Ordre des zones"
L["ZONE_ORDER_DESCRIPTION"] = "Change l'ordre des zones dans la liste des quêtes."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Niveau moyen, le plus haut d'abord (par défaut)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Niveau moyen, le plus bas d'abord"
L["SORT_ALPHABETICAL"] = "Alphabétique"
L["CURRENT_ZONE_FIRST"] = "Afficher la zone actuelle en premier"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Place la zone où vous vous trouvez en haut de la liste, quel que soit l'ordre des zones."
L["ZONE_GAP"] = "Espace au-dessus des noms de zone"
L["ZONE_GAP_DESCRIPTION"] =
	"Ajoute un peu d'espace au-dessus de chaque nom de zone. Pratique si vos quêtes sont réparties sur de nombreuses zones."
L["QUEST_ORDER"] = "Ordre des quêtes"
L["QUEST_ORDER_DESCRIPTION"] = "Change l'ordre des quêtes sous chaque zone."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Niveau, le plus haut d'abord (par défaut)"
L["SORT_LEVEL_LOWEST"] = "Niveau, le plus bas d'abord"
L["COMPLETED_FIRST"] = "Afficher les quêtes terminées en premier"
L["COMPLETED_FIRST_DESCRIPTION"] = "Place en haut de leur zone les quêtes prêtes à être rendues."
L["SHOW_QUEST_LEVELS"] = "Afficher le niveau des quêtes"
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Place le niveau et le type de chaque quête devant son nom dans la liste, comme [40D] pour une quête de donjon de niveau 40."
L["MARK_UNTRACKED"] = "Marquer les quêtes non suivies"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Les quêtes suivies perdent leur coche %s, et les quêtes non suivies ont un œil %s à la place. Pratique si vous suivez presque tout."
L["CLOSE_IN_COMBAT"] = "Fermer en début de combat"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Ferme le journal de quêtes quand un combat commence, pour qu'il ne cache jamais l'action."
L["WINDOW_SCALE"] = "Échelle du journal de quêtes"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Agrandit ou réduit le journal de quêtes. La carte à côté grandit et rétrécit avec lui."
L["MAP_SCALE"] = "Échelle de la carte"
L["MAP_SCALE_DESCRIPTION"] =
	"Agrandit ou réduit la carte à côté du journal de quêtes, en plus de l'échelle du journal de quêtes."
L["RESET_WINDOW"] = "Réinitialiser la taille et la position"
L["RESET_WINDOW_DESCRIPTION"] = "Remet le journal de quêtes à sa taille et à sa position par défaut."
L["RESET_WINDOW_CONFIRM"] = "Remettre le journal de quêtes à sa taille et à sa position par défaut ?"

--------------------------------------------------------------------------------
-- Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Améliorations de confort"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"De petites aides en dehors du journal de quêtes lui-même, pour la fenêtre de donneur de quêtes, pour partager des quêtes avec votre groupe et pour les donjons."
L["QUEST_GIVERS_HEADER"] = "Donneurs de quêtes"
L["QUEST_GIVERS_DESCRIPTION"] = "La fenêtre qu'ouvre un donneur de quêtes, où vous acceptez et rendez des quêtes."
L["GIVER_CLEANUP"] = "Fenêtre de donneur de quêtes épurée"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Met en forme le texte de la fenêtre de donneur de quêtes comme celui du journal de quêtes, avec les mêmes titres et le même interligne, et affiche sous la quête son ID, lié à Wowhead."
L["GIVER_LEVELS"] = "Afficher le niveau des quêtes"
L["GIVER_LEVELS_DESCRIPTION"] =
	"Ajoute les repères de niveau du journal de quêtes, comme [40D], à la liste de quêtes d'un donneur de quêtes."
L["QUEST_SHARING_HEADER"] = "Partage de quêtes"
L["QUEST_SHARING_DESCRIPTION"] =
	"Partager les quêtes, dans le menu clic droit d'une zone du journal de quêtes, propose à votre groupe, l'une après l'autre, toutes les quêtes de cette zone qu'il peut prendre. Ces options règlent le rythme et ce qui se passe quand un membre du groupe en rate une."
L["SHARE_INTERVAL"] = "Secondes entre les partages"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Le temps d'attente entre une quête partagée et la suivante, pour Partager les quêtes et pour le partage des quêtes de donjon. Plus il est long, plus votre groupe a le temps d'accepter chacune."
L["SHARE_WHISPERS"] = "Chuchoter quand un partage échoue"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quand un membre du groupe est occupé, trop loin ou a un journal de quêtes plein, lui chuchote la quête que vous avez essayé de partager et lui demande de vous la rappeler. Rien n'est envoyé s'il ne peut pas prendre la quête."
L["OPTIONS_EXAMPLE"] = "Exemple :"
L["OPTIONS_EXAMPLE_QUEST_NAME"] = "Nom de la quête"
L["DUNGEON_QUESTS_HEADER"] = "Quêtes de donjon"
L["DUNGEON_QUESTS_DESCRIPTION"] =
	"Ces options se déclenchent quand vous entrez dans un donjon ou un raid avec votre groupe, une fois par groupe pour chaque donjon. Une quête compte si elle est rangée sous le donjon dans votre journal de quêtes ou, avec Questie, si l'un de ses objectifs s'y trouve, ce qui inclut aussi les quêtes de classe."
L["DUNGEON_ANNOUNCE"] = "Annonces automatiques des quêtes de donjon"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Indique à votre groupe quelles quêtes il vous reste à faire dans le donjon où vous venez d'entrer, pour que tout le monde sache quoi surveiller. Les quêtes prêtes à être rendues sont omises."
L["DUNGEON_SHARE"] = "Partage automatique des quêtes de donjon"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Partage chaque quête du donjon que le jeu vous laisse partager, au rythme réglé dans Partage de quêtes. Quiconque rate un partage reçoit le chuchotement habituel pour pouvoir la redemander. Partage à nouveau chaque fois que quelqu'un rejoint ou quitte le groupe."

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "D"
L["QUEST_SUFFIX_RAID"] = "R"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "ID de quête %d"
L["QUEST_CHAIN"] = "Suite de quêtes"
L["DAILY_RESET"] = "Les quêtes journalières se réinitialisent dans %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Cliquez pour obtenir un lien Wowhead."
L["WOWHEAD_LINK_COPY"] = "Appuyez sur Ctrl+C (Cmd+C sur Mac) pour copier le lien Wowhead."
L["EXPAND_ALL"] = "Tout développer"
L["COLLAPSE_ALL"] = "Tout réduire"
L["TRACK_ALL"] = "Tout suivre"
L["UNTRACK_ALL"] = "Ne rien suivre"
L["HIDE_MAP"] = "Masquer la carte"
L["TURN_IN_XP"] = "%s XP"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "À rendre : %s"
L["TURN_IN_TOOLTIP"] = "Prête à être rendue"
L["RESIZE_TOOLTIP"] = "Faites glisser pour redimensionner le journal de quêtes."

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_HINT"] = "Clic droit pour plus d'options"
L["SHARE_ZONE_QUESTS"] = "Partager %d quêtes"
L["SHARE_ZONE_QUEST"] = "Partager 1 quête"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Propose à votre groupe les quêtes de cette zone que le jeu vous laisse partager, une toutes les %d secondes."
L["SHARE_ZONE_QUEST_TOOLTIP"] = "Propose à votre groupe la seule quête de cette zone que le jeu vous laisse partager."
L["CHAT_SHARING_ZONE_ONE"] = "Partage de 1 quête de %s."
L["CHAT_SHARING_ZONE"] = "Partage de %d quêtes de %s, une toutes les %d secondes."
L["ABANDON_GRAY_QUESTS"] = "Abandonner les quêtes grises"
L["ABANDON_GRAY_NONE"] = "Cette zone n'a aucune quête grise à abandonner."
L["ABANDON_GRAY_CONFIRM"] = "Abandonner ces %d quêtes grises ?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "Abandonner cette quête grise ?"
L["CHAT_ABANDONED_GRAY"] = "%d quêtes grises abandonnées."
L["CHAT_ABANDONED_GRAY_ONE"] = "1 quête grise abandonnée."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_BUSY"] =
	"J'ai essayé de partager %s avec toi, mais tu n'avais pas l'air disponible. Si elle t'intéresse, fais-moi signe quand tu es libre et je te la renvoie."
L["WHISPER_SHARE_TOO_FAR"] =
	"J'ai essayé de partager %s avec toi, mais on était trop loin l'un de l'autre. Si elle t'intéresse, fais-moi signe quand on sera plus près et je te la renvoie."
L["WHISPER_SHARE_LOG_FULL"] =
	"J'ai essayé de partager %s avec toi, mais ton journal de quêtes était plein. Si elle t'intéresse, fais-moi signe quand tu auras fait de la place et je te la renvoie."
L["DUNGEON_QUESTS_ANNOUNCE"] = "J'ai %d quêtes à faire ici : %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "J'ai 1 quête à faire ici : %s"
L["DUNGEON_QUESTS_ANNOUNCE_MORE"] = "%s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Le suivi de Questie ne peut pas afficher %s, car la quête est absente de la base de données de Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie ne peut pas encore suivre cette quête."
