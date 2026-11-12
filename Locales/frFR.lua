local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "frFR")
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
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > AddOns > Pretty Wide Quest Log. Cet add-on vous plaît ? Parlez-en à un ami, ajoutez-le à vos favoris sur CurseForge ou mettez-lui une Star sur GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Par mesure de sécurité, l'interface des options ne peut pas être ouverte en combat."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Par mesure de sécurité, les Raccourcis du jeu ne peuvent pas être ouverts en combat."
-- TRANSLATORS: the first %s is the game menu's Options label, the second its Key Bindings label, both from the client
L["KEY_BINDINGS_LOCATION"] = "Ouvrez le menu du jeu, puis %s, puis %s, et cherchez la section Pretty Wide Quest Log."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Sans Questie, la carte de quêtes en montre moins, et les suites de quêtes ainsi que le total À rendre restent masqués. Activez Questie dans la liste des AddOns pour les voir."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus est aussi activé, et les deux vont se disputer le journal de quêtes. Désactivez Wide Quest Log Plus dans la liste des AddOns, puis rechargez."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Journal de quêtes large avec un itinéraire de quêtes et une flèche de quête. Vous choisissez les quêtes, nous vous aidons avec un itinéraire clair pour les terminer vite. Niveau des quêtes, repères, récompenses, suites de quêtes, carte de quête et partage de quêtes avec le groupe. Compatible avec Questie, Spoken, VoiceOver et ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Activer le message de bienvenue"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Affiche le message de bienvenue de Pretty Wide Quest Log à la connexion."
L["OPTIONS_FEATURES_HEADER"] = "Fonctionnalités"
L["ENABLE_WIDE_QUEST_LOG"] = "Activer le journal de quêtes large"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Remplace le journal de quêtes de Blizzard par le journal large, avec la carte à côté. Prend effet après un rechargement."
L["ENABLE_QUALITY_OF_LIFE"] = "Activer les améliorations de confort"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Aide votre groupe à prendre vos quêtes : rythme de partage, chuchotements quand un partage rate quelqu'un, et annonce et partage des quêtes de donjon. Le bouton Partager les quêtes d'une zone dans le journal de quêtes fonctionne aussi quand cette option est désactivée."
L["ENABLE_WAYPOINT_MARKERS"] = "Activer les Marqueurs de points de passage"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Regroupe les icônes de quête de chaque objectif sur la carte de zone en un seul marqueur, un point de passage, là où se trouvent la plupart de ses monstres ou objets, avec un marqueur pour chaque remise de quête. Survolez un marqueur pour voir les icônes qu'il remplace."
L["ENABLE_QUEST_ROUTE"] = "Activer l'Itinéraire de quête"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"Trace sur la carte de zone un itinéraire passant par vos marqueurs de points de passage, du plus proche au plus lointain, sous forme de points qui défilent de vous jusqu'à chaque marqueur, tour à tour. Nécessite les Marqueurs de points de passage."
L["ENABLE_QUEST_ARROW"] = "Activer la Flèche de quête"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Affiche à l'écran une flèche, la Flèche de quête, qui pointe vers le prochain point de passage de l'itinéraire, avec les quêtes et objectifs à y accomplir. Par défaut, elle se masque en groupe de raid et en instance."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Activer le journal de quêtes large prend effet après un rechargement, proposé à la fermeture de l'interface des options."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log change de journal de quêtes après un rechargement. Recharger maintenant ?"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Raccourcis"
L["OPTIONS_KEY_SET"] = "Attribuer une touche"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "Ouvre les Raccourcis du jeu, où Pretty Wide Quest Log a sa propre section."
L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] =
	"Utilise l'objet du premier bouton Utiliser l'objet de la Flèche de quête, comme si vous cliquiez dessus, même en combat."
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre l'interface des options de cet add-on."

--------------------------------------------------------------------------------
-- Options: Wide Quest Log Panels
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Journal de quêtes large"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Remplace le journal de quêtes de Blizzard par un journal large : vos quêtes classées par zone, avec à côté les détails de la quête sélectionnée et sa carte."
L["QUEST_LOG_SORTING_HEADER"] = "Tri"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Choisissez l'ordre de vos zones et des quêtes en dessous."
L["QUEST_LOG_ROWS_HEADER"] = "Lignes de quêtes"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Choisissez ce qu'affiche chaque ligne."
L["TAB_WINDOW_MAP"] = "Fenêtre et carte"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"Adaptez la taille de la fenêtre et de la carte à votre écran, et choisissez leur comportement."
L["ZONE_ORDER"] = "Ordre des zones"
L["ZONE_ORDER_DESCRIPTION"] = "Change l'ordre des zones dans la liste des quêtes."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Niveau moyen, le plus haut d'abord (par défaut)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Niveau moyen, le plus bas d'abord"
L["SORT_ALPHABETICAL"] = "Alphabétique"
L["CURRENT_ZONE_FIRST"] = "Afficher la zone actuelle en premier"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Place la zone où vous vous trouvez en haut de la liste, quel que soit l'ordre des zones."
L["ZONE_GAP"] = "Ajouter de l'espace au-dessus des noms de zone"
L["ZONE_GAP_DESCRIPTION"] =
	"Ajoute un peu d'espace au-dessus de chaque nom de zone. Pratique si vos quêtes sont réparties sur de nombreuses zones."
L["QUEST_ORDER"] = "Ordre des quêtes"
L["QUEST_ORDER_DESCRIPTION"] = "Change l'ordre des quêtes sous chaque zone."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Niveau, le plus haut d'abord (par défaut)"
L["SORT_LEVEL_LOWEST"] = "Niveau, le plus bas d'abord"
L["COMPLETED_FIRST"] = "Afficher les quêtes terminées en premier"
L["COMPLETED_FIRST_DESCRIPTION"] = "Place en haut de leur zone les quêtes prêtes à être rendues."
L["SHOW_QUEST_LEVELS"] = "Afficher le niveau des quêtes"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Place le niveau et le type de chaque quête devant son nom dans la liste, comme %s pour une quête de donjon de niveau 40."
L["MARK_UNTRACKED"] = "Marquer les quêtes non suivies"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Les quêtes suivies perdent leur coche %s, et les quêtes non suivies ont un œil %s à la place. Pratique si vous suivez presque tout."
L["CLOSE_IN_COMBAT"] = "Fermer en début de combat"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Ferme le journal de quêtes quand un combat commence, pour qu'il ne cache jamais l'action."
L["SHOW_OBJECTIVE_AREAS"] = "Afficher les zones d'objectifs"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Colore sur la carte à côté du journal de quêtes les endroits où se trouvent les monstres et les objets de chaque objectif, avec une seule icône par zone au lieu d'une sur chaque point d'apparition."
L["NEEDS_QUESTIE_HINT"] = "Activez Questie pour utiliser cette option."
L["WINDOW_SCALE"] = "Échelle du journal de quêtes"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Agrandit ou réduit le journal de quêtes. La carte à côté grandit et rétrécit avec lui."
L["MAP_SCALE"] = "Échelle de la carte"
L["MAP_SCALE_DESCRIPTION"] =
	"Agrandit ou réduit la carte à côté du journal de quêtes, en plus de l'échelle du journal de quêtes."
L["RESET_WINDOW_BUTTON"] = "Réinitialiser la fenêtre"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Remet la hauteur et l'échelle du journal de quêtes, ainsi que l'échelle de la carte, à leurs valeurs par défaut."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Remet la hauteur et l'échelle du journal de quêtes, ainsi que l'échelle de la carte, à leurs valeurs par défaut, et ramène la fenêtre à son emplacement de départ."
L["RESET_WINDOW_SCALE_CONFIRM"] =
	"Réinitialiser la hauteur et l'échelle du journal de quêtes, ainsi que l'échelle de la carte ?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Réinitialiser la hauteur et l'échelle du journal de quêtes, l'échelle de la carte et l'emplacement de la fenêtre à l'écran ?"
L["HANDY_CLICKS_HEADER"] = "Clics pratiques"
L["HANDY_CLICK_TRACK"] = "Maj-clic sur une quête"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "Suivez-la ou arrêtez de la suivre."
L["HANDY_CLICK_MENU"] = "Clic droit sur une quête"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "Suivez-la, partagez-la ou abandonnez-la."
L["HANDY_CLICK_ID"] = "Clic sur un ID de quête"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Obtenez son lien Wowhead."
L["QUEST_LOG_SUB_PANELS_DESCRIPTION"] =
	"Ses paramètres se trouvent dans les panneaux sous celui-ci : Liste des quêtes, Détails de la quête, Fenêtre et carte, et Dialogue des PNJ."
L["NEEDS_WIDE_QUEST_LOG"] =
	"Ces paramètres concernent le journal de quêtes large. Cochez Activer le journal de quêtes large dans le panneau Journal de quêtes large pour les utiliser."
L["TAB_QUEST_LIST"] = "Liste des quêtes"
L["TAB_QUEST_LIST_DESCRIPTION"] = "Vos quêtes, classées par zone sur le côté gauche du journal de quêtes."
L["TAB_QUEST_DETAILS"] = "Détails de la quête"
L["TAB_QUEST_DETAILS_DESCRIPTION"] =
	"Les détails de la quête sélectionnée, sur le parchemin à côté de la liste des quêtes."

--------------------------------------------------------------------------------
-- Options: NPC Dialogue Panel
--------------------------------------------------------------------------------

L["TAB_NPC_DIALOGUE"] = "Dialogue des PNJ"
L["TAB_NPC_DIALOGUE_DESCRIPTION"] =
	"Les fenêtres qu'ouvre un PNJ quand vous lui parlez : la fenêtre de donneur de quêtes et la fenêtre de dialogue. Ces paramètres fonctionnent avec ou sans le journal de quêtes large."
L["QUEST_GIVERS_HEADER"] = "Donneurs de quêtes"
L["QUEST_GIVERS_DESCRIPTION"] = "La fenêtre qu'ouvre un donneur de quêtes, où vous acceptez et rendez des quêtes."
L["GIVER_CLEANUP"] = "Fenêtre de donneur de quêtes épurée"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Met en page le texte de la fenêtre de donneur de quêtes comme celui du journal de quêtes, avec les mêmes titres et le même interligne, et affiche sous la quête son ID, lié à Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Ajoute les repères de niveau du journal de quêtes, comme %s, à la liste de quêtes d'un donneur de quêtes."
L["FONT_DIALOGUE_NEEDS_CLEANUP"] =
	"La police fait partie de Fenêtre de donneur de quêtes épurée, qui doit donc être activée."

--------------------------------------------------------------------------------
-- Options: Font Sections
--------------------------------------------------------------------------------

L["FONT_HEADER"] = "Police"
L["FONT_LIST_DESCRIPTION"] = "La police des noms de zone et des quêtes dans la liste des quêtes."
L["FONT_DETAILS_DESCRIPTION"] =
	"La police des détails de la quête : le titre, les intertitres et le texte de la quête."
L["FONT_DIALOGUE_DESCRIPTION"] =
	"La police des fenêtres de donneur de quêtes et de dialogue : le titre, les intertitres et le texte de la quête."
L["FONT_WINDOW_DESCRIPTION"] = "La police du titre de la fenêtre, du nombre de quêtes et de la ligne À rendre."
L["FONT_FACE"] = "Police"
L["FONT_FACE_DESCRIPTION"] =
	"Le style des caractères. Par défaut du jeu suit la police du jeu, et tout add-on qui la modifie. Les polices ajoutées via SharedMedia sont aussi proposées."
L["FONT_GAME_DEFAULT"] = "Par défaut du jeu"
L["FONT_GAME_STANDARD"] = "Texte standard"
L["FONT_GAME_NAMES"] = "Noms des personnages"
L["FONT_GAME_DAMAGE"] = "Chiffres de dégâts"
L["FONT_SIZE"] = "Taille"
L["FONT_SIZE_DESCRIPTION"] =
	"Agrandit ou réduit le texte, en points par rapport à la taille du jeu. 0 conserve la taille du jeu."
L["FONT_OUTLINE"] = "Contour"
L["FONT_OUTLINE_DESCRIPTION"] =
	"Un contour noir autour de chaque lettre. Par défaut du jeu garde le contour qu'a la police du jeu, quel qu'il soit, et Aucun le retire."
L["FONT_OUTLINE_DEFAULT"] = "Par défaut du jeu"
L["FONT_OUTLINE_NONE"] = "Aucun"
L["FONT_OUTLINE_THIN"] = "Fin"
L["FONT_OUTLINE_THICK"] = "Épais"
L["FONT_SHADOW"] = "Ombre du texte"
L["FONT_SHADOW_DESCRIPTION"] =
	"Garde l'ombre portée que la police du jeu a derrière le texte. Désactivez cette option pour retirer l'ombre, ce qui aide une police qui paraît floue ou baveuse."
L["FONT_SLUG"] = "Texte plus net (Slug)"
L["FONT_SLUG_DESCRIPTION"] =
	"Dessine le texte avec le nouveau moteur de rendu Slug de Blizzard, pour des lettres plus nettes à toutes les tailles. Slug ne peut pas dessiner de contour épais ni d'ombre, donc le texte qui a l'un ou l'autre est dessiné comme d'habitude."
L["FONT_RESET_BUTTON"] = "Réinitialiser la police"
L["FONT_RESET_DESCRIPTION"] = "Remet les paramètres de cette police à leurs valeurs par défaut."

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Améliorations de confort"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"De petites aides en dehors du journal de quêtes lui-même : pour partager des quêtes avec votre groupe et pour les donjons."
L["QUEST_SHARING_HEADER"] = "Partage de quêtes"
L["QUEST_SHARING_INTRO"] =
	"Survolez le nom d'une zone dans le journal de quêtes et cliquez sur Partager les quêtes pour proposer à votre groupe, l'une après l'autre, toutes ses quêtes que vous pouvez partager. Ces options règlent le rythme et ce qui se passe quand quelqu'un en rate une."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"Le bouton Partager les quêtes sur un nom de zone nécessite Activer le journal de quêtes large. Le partage des quêtes de donjon fonctionne sans."
L["SHARE_INTERVAL"] = "Secondes entre les partages"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Le temps d'attente entre une quête partagée et la suivante, quand vous partagez les quêtes d'une zone ou d'un donjon. Plus il est long, plus votre groupe a le temps d'accepter chacune."
L["SHARE_WHISPERS"] = "Chuchoter quand un partage échoue"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quand un membre du groupe est occupé, trop loin ou a un journal de quêtes plein, lui chuchote la quête que vous avez essayé de partager et lui demande de vous la rappeler. Rien n'est envoyé s'il ne remplit pas les conditions de la quête, l'a déjà ou l'a déjà terminée."
L["ZONE_SHARE_OFFERS"] = "Proposer les quêtes de ma zone aux nouveaux membres du groupe"
L["ZONE_SHARE_OFFERS_DESCRIPTION"] =
	"Quand vous rejoignez un groupe, ou que quelqu'un rejoint le vôtre, attend 20 secondes que Questie échange les journaux de quêtes, puis chuchote à chaque membre du groupe dans votre zone combien de vos quêtes ayant des objectifs là-bas il n'a pas, et lui demande s'il les veut. Seules les quêtes que vous pouvez partager comptent. Les membres dont les quêtes ne sont pas visibles (sans Questie, hors de portée) et ceux qui les ont déjà toutes ne reçoivent pas de chuchotement. Chaque membre n'est sollicité qu'une fois par groupe, et jamais dans un donjon ni dans un groupe de raid."
L["SAMPLE_EXAMPLE"] = "Exemple : %s"
L["SAMPLE_QUEST_LOADING"] = "Chargement de l'ID de quête : %d"
L["DUNGEON_QUESTS_HEADER"] = "Quêtes de donjon"
L["DUNGEON_QUESTS_INTRO"] =
	"Quand vous entrez dans un donjon avec votre groupe, vos quêtes pour celui-ci sont annoncées et partagées dès que tout le monde est à portée (immédiatement sur WoW Forever), et jamais deux fois au même groupe. Avec Questie, les quêtes dont les objectifs s'y trouvent comptent aussi, quêtes de classe comprises. Rien ne se passe dans un groupe de raid."
L["DUNGEON_ANNOUNCE"] = "Annonces automatiques des quêtes de donjon"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Indique à votre groupe quelles quêtes il vous reste à faire dans le donjon où vous venez d'entrer, pour que tout le monde sache quoi surveiller. Les quêtes prêtes à être rendues sont omises."
L["DUNGEON_SHARE"] = "Partage automatique des quêtes de donjon"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Partage chaque quête du donjon que le jeu vous laisse partager et qu'il manque encore à quelqu'un du groupe, au rythme réglé dans Partage de quêtes, dès que tout le monde est à portée (ou au bout d'une minute ; immédiatement sur WoW Forever). Chaque membre du groupe les reçoit une fois par donjon, donc quelqu'un qui rejoint plus tard les reçoit aussi, et sortir de l'instance puis y revenir ne partage rien. Avec Chuchoter quand un partage échoue activé, quiconque rate un partage reçoit un chuchotement pour pouvoir la redemander."

--------------------------------------------------------------------------------
-- Options: Maps & Objectives Panels
--------------------------------------------------------------------------------

L["TAB_MAPS_OBJECTIVES"] = "Cartes et objectifs"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Un marqueur sur la carte de zone pour chaque objectif et chaque remise de quête, à la place d'un amas d'icônes de quête."
L["MAPS_SUB_PANELS_DESCRIPTION"] =
	"Les paramètres de chaque carte se trouvent dans les panneaux sous celui-ci : Mini-carte, Carte de zone, et Carte du continent et du monde."
L["MAPS_NEED_MARKERS"] =
	"Les marqueurs ne s'affichent que lorsque Activer les Marqueurs de points de passage est coché."
L["TAB_MINIMAP"] = "Mini-carte"
L["TAB_MINIMAP_DESCRIPTION"] =
	"Les icônes de Questie sur la mini-carte montrent exactement où les choses apparaissent et où les ramasser, elles restent donc toujours affichées. Les marqueurs de l'itinéraire peuvent s'afficher à côté."
L["SHOW_MINIMAP_MARKERS"] = "Afficher les marqueurs de points de passage sur la mini-carte"
L["SHOW_MINIMAP_MARKERS_DESCRIPTION"] =
	"Place un petit marqueur sur la mini-carte pour chaque point de passage de l'itinéraire, à côté des icônes de Questie. Survolez-en un pour voir ses quêtes."
L["MINIMAP_MARKER_SIZE_DESCRIPTION"] = "La taille des marqueurs de l'itinéraire sur la mini-carte."
L["TAB_ZONE_MAP"] = "Carte de zone"
L["TAB_ZONE_MAP_DESCRIPTION"] = "La carte d'une zone, où l'itinéraire passe entre ses marqueurs de points de passage."
L["FULL_SIZE_MAP"] = "Ouvrir la carte de zone en grand"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Ouvre la carte de zone agrandie, comme le fait son propre bouton d'agrandissement, pour laisser de la place à l'itinéraire. Si vous réduisez la carte, elle s'ouvre de nouveau en grand la fois suivante."
L["HIDE_QUESTIE_ICONS"] = "Masquer les icônes de quête sur l'itinéraire"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Pour ce qui se trouve sur l'itinéraire, masque les icônes de carte de Questie, ainsi que les indicateurs de quête et les zones d'objectif de Blizzard, afin que les marqueurs de l'itinéraire les remplacent. Les icônes estompées de Questie pour les objectifs des membres du groupe sont aussi masquées. Survolez un marqueur pour voir les icônes de Questie."
L["MARKER_SIZE"] = "Taille des marqueurs"
L["MARKER_SIZE_DESCRIPTION"] = "La taille des marqueurs de l'itinéraire sur la carte de zone."
L["MARKER_SIZE_SMALL"] = "Petite"
L["MARKER_SIZE_MEDIUM"] = "Moyenne"
L["MARKER_SIZE_LARGE"] = "Grande"
L["MARKER_SIZE_HUGE"] = "Énorme"
L["TAB_WIDE_MAP"] = "Carte du continent et du monde"
L["TAB_WIDE_MAP_DESCRIPTION"] =
	"Les cartes qui regroupent de nombreuses zones à la fois, où chaque objectif et chaque remise de quête ont un marqueur plus petit."
L["SHOW_WIDE_MAP_MARKERS"] = "Afficher les marqueurs de points de passage sur les cartes du continent et du monde"
L["SHOW_WIDE_MAP_MARKERS_DESCRIPTION"] =
	"Place un marqueur sur les cartes du continent et du monde pour chaque objectif et chaque remise de quête, à la place des icônes de Questie. Désactivez cette option pour y voir plutôt les icônes de Questie."
L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"] =
	"La taille des marqueurs de l'itinéraire sur les cartes du continent et du monde. Chaque taille y est plus petite que sur la carte de zone, car ces cartes regroupent de nombreuses zones."

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "Itinéraire de quête"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"Un itinéraire passant par vos marqueurs de points de passage sur la carte de zone, dans l'ordre où les faire, depuis l'endroit où vous êtes."
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"L'Itinéraire de quête passe entre les marqueurs de points de passage, il ne s'affiche donc que lorsque Activer les Marqueurs de points de passage est coché."
L["ROUTES_LINE_HEADER"] = "Ligne d'itinéraire"
L["ROUTES_LINE_DESCRIPTION"] = "Les points qui défilent de vous jusqu'à chaque marqueur."
L["LINE_SPEED"] = "Vitesse de la ligne"
L["LINE_SPEED_DESCRIPTION"] = "La vitesse à laquelle les points défilent vers le prochain marqueur."
L["LINE_SPEED_STILL"] = "Immobile"
L["LINE_SPEED_SLOW"] = "Lente"
L["LINE_SPEED_NORMAL"] = "Normale"
L["LINE_SPEED_FAST"] = "Rapide"
L["LINE_OPACITY"] = "Opacité de la ligne"
L["LINE_OPACITY_DESCRIPTION"] = "L'opacité des points ; plus elle est basse, plus la carte transparaît."
L["ROUTES_PARTY_HEADER"] = "Groupe"
L["ROUTES_PARTY_DESCRIPTION"] = "Ce que votre groupe ajoute à l'itinéraire."
L["PARTY_QUESTS"] = "Inclure les quêtes des membres du groupe"
L["PARTY_QUESTS_DESCRIPTION"] =
	"En groupe, l'itinéraire et la Flèche de quête prennent aussi en compte les quêtes que les membres de votre groupe ont et pas vous, affichées comme les vôtres. Questie doit être installé des deux côtés pour les partager. Leurs quêtes de donjon sont exclues, car leurs objectifs se trouvent dans le donjon."
L["GROUP_UP"] = "Se regrouper"
L["GROUP_UP_DESCRIPTION"] =
	"En groupe, quand quelqu'un de votre zone n'est plus sur votre mini-carte, la Flèche de quête affiche Se regrouper et pointe vers lui, ou vers le milieu de tout le monde, et la carte du monde marque l'endroit, pour que vous puissiez faire vos quêtes ensemble."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Flèche de quête"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Une flèche à l'écran qui pointe vers le prochain point de passage de l'itinéraire, avec les quêtes et objectifs à y accomplir. Survolez-la pour ouvrir un menu où vous pouvez ignorer un objectif à la fois et voir ce que vous avez ignoré. Faites un clic milieu dessus pour réinitialiser la zone et remettre ce que vous y avez ignoré."
L["QUEST_ARROW_HEADER"] = "Flèche"
L["QUEST_ARROW_DESCRIPTION"] = "Où se trouve la Flèche de quête et quelle est sa taille."
L["ARROW_SIZE"] = "Taille de la flèche"
L["ARROW_SIZE_DESCRIPTION"] = "La taille de la Flèche de quête, avec le texte en dessous."
L["LOCK_ARROW"] = "Verrouiller la Flèche de quête"
L["LOCK_ARROW_DESCRIPTION"] = "Garde la Flèche de quête à sa place, pour que la faire glisser n'ait aucun effet."
L["RESET_ARROW"] = "Position de la flèche"
L["RESET_ARROW_BUTTON"] = "Réinitialiser"
L["RESET_ARROW_CONFIRM"] = "Remettre la Flèche de quête à sa place de départ ?"
L["RESET_ARROW_DESCRIPTION"] = "Remet la Flèche de quête à sa place de départ, en haut au centre de l'écran."
L["QUEST_ARROW_TEXT_HEADER"] = "Sous la flèche"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "Ce que la Flèche de quête liste sous elle."
L["SHOW_DISTANCE"] = "Afficher la distance"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'Indique à combien de mètres se trouve le prochain point de passage. "%s" et "%s" s\'affichent dans tous les cas.'
L["SHOW_ARROW_QUESTS"] = "Afficher les quêtes et objectifs"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"Liste les quêtes du prochain point de passage, chacune avec ce qu'il reste à y faire."
L["QUESTS_LISTED"] = "Nombre maximal de quêtes listées"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'Le nombre maximal de quêtes que la Flèche de quête liste sous elle pour un point de passage. Les suivantes sont comptées sur une ligne à part, comme "%s".'
L["SHOW_ITEM_BUTTONS"] = "Afficher les boutons d'objets de quête"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"Place un bouton à côté de chaque quête listée par la Flèche de quête qui a un objet à utiliser, par exemple à lancer, à planter ou à utiliser sur une cible. Cliquez dessus pour utiliser l'objet, ou attribuez une touche à Utiliser l'objet de quête sous Raccourcis dans le panneau Pretty Wide Quest Log pour utiliser le premier. En combat, les boutons restent où ils sont jusqu'à la fin du combat."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_NEXT_OBJECTIVE
L["SHOW_NEXT_OBJECTIVE"] = "Afficher l'objectif suivant"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'Dans une "%s", liste "%s" en dessous, estompé : une petite flèche vers le point de passage suivant, et ce qu\'il y a à y faire.'
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_PREDICTIVE
L["PREDICTIVE_ROUTES"] = "Itinéraires de quête prédictifs"
L["PREDICTIVE_ROUTES_DESCRIPTION"] =
	"Planifie les quêtes que vous pouvez terminer dans cette zone, où que se trouve leur donneur, et pas seulement à proximité : leurs objectifs, leur remise et les quêtes qui les suivent. L'itinéraire vous fait alors prendre tout ce qu'il faut pour une partie de la zone avant de vous y mener, pour que vous n'y alliez qu'une fois. Une suite de quêtes s'arrête à la première quête qui mène à une autre zone. Les objectifs d'une quête que vous n'avez pas encore prise ont un marqueur gris. La remise de chaque quête s'affiche aussi avant qu'elle soit terminée, marquée du point d'interrogation gris de Questie."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_FLIGHTS
L["SHOW_FLIGHT_PATHS"] = "Afficher les trajets aériens non découverts comme objectifs"
L["SHOW_FLIGHT_PATHS_DESCRIPTION"] =
	"Ajoute à l'itinéraire chaque maître de vol de votre zone dont vous n'avez pas encore le trajet aérien, marqué de l'icône de maître de vol. Sur un personnage qui avait déjà des trajets aériens, ouvrez une fois n'importe quelle carte de vol pour que l'itinéraire sache lesquels vous avez ; d'ici là, aucun n'est ajouté."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_LOCAL
L["SHOW_LOCAL_QUESTS"] = "Afficher les quêtes disponibles proches comme objectifs"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"Place sur l'itinéraire les quêtes que vous pouvez prendre, quand Questie les affiche comme disponibles et qu'un PNJ ou un objet qui les donne se trouve à %s ou moins, marquées du point d'exclamation de Questie. Les quêtes lancées par un objet ramassé sur un butin, et les quêtes de donjon et de raid, sont laissées de côté."
L["LOCAL_QUESTS_HEADER"] = "Quêtes disponibles proches"
L["LOCAL_QUESTS_DESCRIPTION"] =
	"Vers quelles quêtes proches la flèche de quête vous mène. Une quête qu'elle ignore peut quand même apparaître sur la carte du monde, sans ligne de route jusqu'à elle."
L["LOCAL_QUEST_RANGE"] = "Rayon de recherche"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"À combien de mètres de vous un donneur de quête peut se trouver pour compter. En dessous de 400, un donneur croisé entre deux calculs de la route peut être manqué."
L["LOCAL_ESCORT_QUESTS"] = "Quêtes d'escorte"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] =
	"Quêtes où vous protégez un PNJ en chemin ; elles prennent du temps et souvent un groupe. Leur marqueur sur la carte est vert."
L["LOCAL_GROUP_QUESTS"] = "Quêtes de groupe et élites"
L["LOCAL_GROUP_QUESTS_DESCRIPTION"] = "Quêtes que Questie marque comme élites, faites pour un groupe."
L["LOCAL_OTHER_ZONE_QUESTS"] = "Objectifs dans une autre zone"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"Quêtes dont un objectif, ou le rendu, se trouve uniquement hors de votre zone, comme une quête qui vous envoie à la ville suivante."
L["LOCAL_QUEST_LEVEL"] = "Niveau de quête minimum"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	"Les quêtes sous cette couleur de difficulté sont écartées. Réglage de Questie garde les quêtes que Questie affiche sur sa carte."
-- TRANSLATORS: a choice for a kind of nearby quest: the Quest Arrow takes you there
L["LOCAL_CHOICE_ROUTE"] = "Sur la route"
-- TRANSLATORS: a choice for a kind of nearby quest: a marker on the world map, but the Quest Arrow skips it
L["LOCAL_CHOICE_MAP"] = "Carte seulement"
-- TRANSLATORS: a choice for a kind of nearby quest: neither the route nor its map markers show it
L["LOCAL_CHOICE_OFF"] = "Écartées"
L["LOCAL_LEVEL_QUESTIE"] = "Réglage de Questie"
-- TRANSLATORS: quest difficulty colors, green being a few levels below the player
L["LOCAL_LEVEL_GREEN"] = "Vertes et plus"
L["LOCAL_LEVEL_YELLOW"] = "Jaunes et plus"
L["QUEST_ARROW_HIDING_HEADER"] = "Masquage"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "Quand la Flèche de quête s'écarte."
L["HIDE_IN_RAIDS"] = "Masquer en groupe de raid"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "Masque la Flèche de quête quand vous êtes dans un groupe de raid."
L["HIDE_IN_INSTANCES"] = "Masquer en instance"
L["HIDE_IN_INSTANCES_DESCRIPTION"] =
	"Masque la Flèche de quête dans les donjons, les raids et les champs de bataille."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Aidez Pretty Wide Quest Log à monter de niveau"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Cet add-on a été créé par des joueurs qui adorent ce jeu et veulent le rendre aussi amusant que possible pour tout le monde. Nous ne demanderons jamais de dons. Notre vraie satisfaction, c'est de savoir que notre travail rend le jeu un peu meilleur pour vous. Si c'est le cas, nous serions ravis de le savoir !"
L["OPTIONS_LEVEL_UP_WAYS"] = "Voici quelques façons de nous aider à toucher plus de joueurs."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Donnez votre avis : Vous avez trouvé un bug ou vous avez une idée ? Dites-le-nous sur Discord. Vos retours nous aident à améliorer l'add-on, et les pull requests sont toujours les bienvenues."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Parlez-en à un ami : Vous connaissez quelqu'un qui pourrait aimer cet add-on ? Parlez-lui-en. Le bouche-à-oreille aide plus de joueurs à découvrir de bons add-ons."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Ajoutez-le aux favoris sur CurseForge : Ouvrez le lien CurseForge ci-dessous, connectez-vous et cliquez sur l'étoile sous le bouton de téléchargement. Les favoris aident plus de joueurs à découvrir l'add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Mettez une Star sur GitHub : Ouvrez le lien GitHub ci-dessous, connectez-vous et cliquez sur Star en haut à droite. Les étoiles aident le projet à obtenir davantage d'outils de développement gratuits."
L["OPTIONS_LEVEL_UP_THANKS"] = "Merci d'avoir choisi Pretty Wide Quest Log !"
L["OPTIONS_FEEDBACK"] = "Commentaires et assistance"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Liens de commentaires et d'assistance"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Pour copier un lien, cliquez dans son champ, puis appuyez sur Ctrl+A et Ctrl+C."
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "D"
L["QUEST_SUFFIX_RAID"] = "R"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "donjon"
L["QUEST_TYPE_RAID"] = "raid"
L["QUEST_TYPE_GROUP"] = "groupe"
L["QUEST_TYPE_ELITE"] = "élite"
L["QUEST_TYPE_PVP"] = "JcJ"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "Lettres après le niveau : %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID de quête %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Suite de quêtes (%d sur %d)"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "Les quêtes journalières se réinitialisent dans %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Cliquez pour obtenir un lien Wowhead."
L["WOWHEAD_LINK_COPY"] = "Appuyez sur Ctrl+C (Cmd+C sur Mac) pour copier le lien Wowhead."
L["EXPAND_ALL"] = "Tout développer"
L["COLLAPSE_ALL"] = "Tout réduire"
L["TRACK_ALL"] = "Tout suivre"
L["UNTRACK_ALL"] = "Ne rien suivre"
L["HIDE_MAP"] = "Masquer la carte"
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "%s XP"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "À rendre : %s"
L["TURN_IN_TOOLTIP"] = "Prête à être rendue"
L["RESIZE_TOOLTIP"] = "Faites glisser pour redimensionner le journal de quêtes."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Partager les quêtes"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Propose à votre groupe les quêtes de cette zone que le jeu vous laisse partager et qu'il manque encore à quelqu'un, une toutes les %d secondes."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "Partage de %s à la fin du combat."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "Partage de 1 quête de %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Partage de %d quêtes de %s, une toutes les %d secondes."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "Aucune de vos quêtes de %s ne peut être partagée."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_PARTY_HAS"] = "Votre groupe a déjà toutes vos quêtes de %s."

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Vous y êtes"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "Point de passage sur une autre carte"
L["ROUTES_OBJECTIVE_AREA"] = "Zone d'objectif actuelle"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "Terminez ici avant de continuer"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "D'autres plus loin sur l'itinéraire"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "Objectif suivant"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "Tant que vous êtes là"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d mètres"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d mètre"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d de plus ici"
L["ROUTES_TURN_IN"] = "Rendre la quête"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Rendre %s"
L["ROUTES_PICK_UP"] = "Prendre la quête"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "Prendre %s"
L["ROUTES_FLIGHT_PATH"] = "Obtenir le trajet aérien"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_FLIGHT_PATH_FROM"] = "Obtenir le trajet aérien auprès de %s"
L["ROUTES_FLY_FROM"] = "Parlez à %s pour voler vers %s"
-- TRANSLATORS: under a quest to pick up on the world map, why the route doesn't go there
L["ROUTES_OFF_ROUTE_ESCORT"] = "Quête d'escorte, hors de la route"
L["ROUTES_OFF_ROUTE_GROUP"] = "Quête de groupe, hors de la route"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "Mène à une autre zone, hors de la route"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"; over a quest's objectives planned before it's picked up
L["ROUTES_AFTER_PICK_UP"] = "Après avoir pris %s"
-- TRANSLATORS: %s is the quest's title with its level; under a quest to pick up once another is turned in
L["ROUTES_AFTER_TURN_IN"] = "Après avoir rendu %s"
-- TRANSLATORS: as ROUTES_AFTER_PICK_UP, for a party member's quest planned ahead, one you don't have
L["ROUTES_AFTER_PARTY_PICK_UP"] = "Après que votre groupe a pris %s"
-- TRANSLATORS: as ROUTES_AFTER_TURN_IN, for a party member's quest
L["ROUTES_AFTER_PARTY_TURN_IN"] = "Après que votre groupe a rendu %s"
L["ROUTES_CORPSE"] = "Retournez à votre cadavre"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Cherchez"
L["ROUTES_CLICK_DRAG"] = "Glisser"
L["ROUTES_CLICK_RIGHT"] = "Clic droit"
L["ROUTES_CLICK_MIDDLE"] = "Clic milieu"
L["ROUTES_CLICK"] = "Clic"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "Utiliser l'objet"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "Utiliser l'objet de quête"
L["ROUTES_DRAG_MOVE"] = "Déplacer la Flèche de quête"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "Ignorer ce point de passage"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "Ignorer cet objectif"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "Remettre sur l'itinéraire"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "Réinitialiser cette zone"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "L'itinéraire ignore %s jusqu'à ce que vous réinitialisiez la zone."
L["ROUTES_ZONE_RESET"] = "Zone réinitialisée : les objectifs ignorés ici sont de retour sur l'itinéraire."
L["ROUTES_GROUP_LEFT_CLEARED"] =
	"Groupe quitté : les objectifs de groupe et membres ignorés sont de retour sur l'itinéraire."
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] =
	"%s a quitté le groupe : les objectifs ignorés correspondants sont de retour sur l'itinéraire."
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "Ignorer"
L["ROUTES_MENU_SECTION_ROUTE"] = "Itinéraire"
L["ROUTES_MENU_SECTION_SHOW"] = "Afficher"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "Suivant"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "Rétablir"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "Ignorés"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "Remise de %s"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "Prise de %s"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_MENU_FLIGHT_PATH"] = "Trajet aérien de %s"
L["ROUTES_MENU_FLY"] = "Vol vers %s"
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_ROUTE; Next Objective, under ROUTES_MENU_SECTION_SHOW, is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_PREDICTIVE"] = "Itinéraires de quête prédictifs"
L["ROUTES_MENU_SHOWN_LOCAL"] = "Quêtes disponibles proches"
L["ROUTES_MENU_SHOWN_FLIGHTS"] = "Trajets aériens"
L["ROUTES_MENU_SHOWN_PARTY"] = "Objectifs du groupe"
L["ROUTES_MENU_ON"] = "Activé"
L["ROUTES_MENU_OFF"] = "Désactivé"
L["ROUTES_MENU_OUT_OF_ZONE"] = "Hors de la zone"
L["ROUTES_MENU_NO_QUESTIE"] = "Sans Questie"
L["ROUTES_MENU_OFFLINE"] = "Hors ligne"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "Objectifs de %s"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "L'itinéraire ignore %s pour %s jusqu'à ce que vous réinitialisiez la zone."
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] =
	"L'itinéraire ignore %s pour %s jusqu'à ce que les membres du groupe qui l'ont quittent le groupe."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s est de retour sur l'itinéraire."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "Les objectifs de %s sont retirés de l'itinéraire."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "Les objectifs de %s sont de retour sur l'itinéraire."
-- TRANSLATORS: on the Quest Arrow and the world map's marker, while it points to where to join up with your party
L["ROUTES_GROUP_UP"] = "Se regrouper"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them, and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"J'ai essayé de partager %s avec toi, mais ça n'a pas marché. Si la quête t'intéresse, fais-moi signe quand tu peux et je te la repartage"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Pareil pour %s"
L["ZONE_SHARE_OFFER"] = "J'ai %d quêtes dans la zone %s que tu n'as pas. Tu veux que j'essaie de te les partager ?"
L["ZONE_SHARE_OFFER_ONE"] = "J'ai 1 quête dans la zone %s que tu n'as pas. Tu veux que j'essaie de te la partager ?"
L["DUNGEON_QUESTS_ANNOUNCE"] = "J'ai %d quêtes à faire ici : %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "J'ai 1 quête à faire ici : %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Autres quêtes à faire ici : %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] =
	"Le suivi de Questie ne peut pas afficher %s, car la quête est absente de la base de données de Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie ne peut pas encore suivre cette quête."
