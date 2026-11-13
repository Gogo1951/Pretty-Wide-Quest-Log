local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "esES")
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
	"Versión %s. Los ajustes (incluida la opción de desactivar este mensaje) están en Opciones > Accesorios > Pretty Wide Quest Log. ¿Te gusta este accesorio? Cuéntaselo a un amigo, márcalo como favorito en CurseForge o dale a Star en GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por seguridad, la interfaz de opciones no se puede abrir durante el combate."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Por seguridad, la Asignación de teclas del juego no se puede abrir durante el combate."
-- TRANSLATORS: the first %s is the game menu's Options label, the second its Key Bindings label, both from the client
L["KEY_BINDINGS_LOCATION"] = "Abre el menú del juego, ve a %s y luego a %s, y busca la sección Pretty Wide Quest Log."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Sin Questie, el mapa de misiones muestra menos, y las cadenas de misiones y el total de Entrega quedan ocultos. Activa Questie en la lista de accesorios para verlos."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus también está activado y los dos se pelearán por el registro de misiones. Desactiva Wide Quest Log Plus en la lista de accesorios y luego recarga."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Registro de misiones ancho con ruta de misiones y flecha de misiones. Tú eliges las misiones y nosotros te ayudamos con una ruta limpia para completarlas rápido. Niveles de misión, etiquetas, recompensas, cadenas de misiones, un mapa de misiones y misiones compartidas con el grupo. Funciona con Questie, Spoken, VoiceOver y ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] =
	"Muestra el mensaje de bienvenida de Pretty Wide Quest Log al iniciar sesión."
L["OPTIONS_FEATURES_HEADER"] = "Funciones"
L["ENABLE_WIDE_QUEST_LOG"] = "Activar registro de misiones ancho"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Cambia el registro de misiones de Blizzard por el ancho, con el mapa al lado. Surte efecto tras recargar."
L["ENABLE_QUALITY_OF_LIFE"] = "Activar mejoras de comodidad"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Ayuda a tu grupo a hacerse con tus misiones: ritmo al compartir, susurros cuando un envío no le llega a alguien, y anuncio y envío de misiones de mazmorra. El botón Compartir misiones de una zona en el registro de misiones funciona también con esto desactivado."
L["ENABLE_WAYPOINT_MARKERS"] = "Activar Marcadores de puntos de ruta"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Reúne los iconos de misión de cada objetivo en el mapa de zona en un solo marcador, un punto de ruta, donde están la mayoría de sus enemigos u objetos, y uno más por cada entrega. Pasa el ratón sobre un marcador para ver los iconos a los que sustituye."
L["ENABLE_QUEST_ROUTE"] = "Activar Ruta de misiones"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"Dibuja en el mapa de zona una ruta por tus marcadores de puntos de ruta, empezando por lo más cercano, con puntos en marcha desde ti hasta cada marcador, uno tras otro. Necesita Marcadores de puntos de ruta."
L["ENABLE_QUEST_ARROW"] = "Activar Flecha de misiones"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Muestra en pantalla una flecha, la Flecha de misiones, que apunta al siguiente punto de ruta, con las misiones y objetivos que hacer allí. Por defecto se oculta en grupos de banda y en instancias."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Activar registro de misiones ancho surte efecto tras recargar, algo que se te ofrecerá al cerrar la interfaz de opciones."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia de registro de misiones tras recargar. ¿Recargar ahora?"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Asignación de teclas"
L["OPTIONS_KEY_SET"] = "Asignar tecla"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Abre la Asignación de teclas del juego, donde Pretty Wide Quest Log tiene su propia sección."
L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] =
	"Usa el objeto del primer botón Usar objeto de la Flecha de misiones, igual que al hacer clic en él, también en combate."
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este accesorio."

--------------------------------------------------------------------------------
-- Options: Wide Quest Log Panels
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Registro de misiones ancho"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Sustituye el registro de misiones de Blizzard por uno ancho: tus misiones agrupadas por zona, con los detalles de la misión seleccionada y su mapa al lado."
L["QUEST_LOG_SORTING_HEADER"] = "Orden"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Elige el orden de tus zonas y de las misiones que hay debajo."
L["QUEST_LOG_ROWS_HEADER"] = "Filas de misiones"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Elige qué muestra cada fila."
L["TAB_WINDOW_MAP"] = "Ventana y mapa"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"Ajusta el tamaño de la ventana y del mapa a tu pantalla, y elige cómo se comportan."
L["ZONE_ORDER"] = "Orden de zonas"
L["ZONE_ORDER_DESCRIPTION"] = "Cambia el orden de las zonas en la lista de misiones."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Nivel medio, el más alto primero (predeterminado)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Nivel medio, el más bajo primero"
L["SORT_ALPHABETICAL"] = "Alfabético"
L["CURRENT_ZONE_FIRST"] = "Mostrar primero la zona actual"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Coloca la zona en la que estás al principio de la lista, sea cual sea el orden de zonas."
L["ZONE_GAP"] = "Añadir espacio sobre los nombres de zona"
L["ZONE_GAP_DESCRIPTION"] =
	"Añade un poco de espacio sobre cada nombre de zona. Útil si tus misiones están repartidas por muchas zonas."
L["QUEST_ORDER"] = "Orden de misiones"
L["QUEST_ORDER_DESCRIPTION"] = "Cambia el orden de las misiones dentro de cada zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Nivel, el más alto primero (predeterminado)"
L["SORT_LEVEL_LOWEST"] = "Nivel, el más bajo primero"
L["COMPLETED_FIRST"] = "Mostrar primero las misiones completadas"
L["COMPLETED_FIRST_DESCRIPTION"] = "Sube al principio de su zona las misiones que ya puedes entregar."
L["SHOW_QUEST_LEVELS"] = "Mostrar niveles de misión"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Pone el nivel y el tipo de cada misión delante de su nombre en la lista, como %s para una misión de mazmorra de nivel 40."
L["MARK_UNTRACKED"] = "Marcar misiones sin seguir"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Las misiones seguidas pierden su marca de verificación %s y las misiones sin seguir llevan un ojo %s en su lugar. Útil si sigues casi todo."
L["CLOSE_IN_COMBAT"] = "Cerrar al entrar en combate"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Cierra el registro de misiones cuando empieza un combate, para que nunca tape la acción."
L["SHOW_OBJECTIVE_AREAS"] = "Mostrar áreas de objetivos"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Sombrea en el mapa junto al registro de misiones dónde se encuentran los enemigos y objetos de cada objetivo, con un icono en cada área en lugar de uno en cada punto de aparición."
L["NEEDS_QUESTIE_HINT"] = "Activa Questie para usar esto."
L["SHOW_ZONE_INFO"] = "Mostrar info de la zona"
L["SHOW_ZONE_INFO_DESCRIPTION"] =
	"Bajo el mapa, las misiones de otras zonas que podrías recoger para la zona que muestra, y los objetos que piden las misiones de esa zona. El mapa se reduce a la mitad de la altura de la ventana para dejar sitio."
L["WINDOW_SCALE"] = "Escala del registro de misiones"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Hace el registro de misiones más grande o más pequeño. El mapa de al lado crece y encoge con él."
L["MAP_SCALE"] = "Escala del mapa"
L["MAP_SCALE_DESCRIPTION"] =
	"Hace el mapa junto al registro de misiones más grande o más pequeño, además de la escala del registro de misiones."
L["RESET_WINDOW_BUTTON"] = "Restablecer ventana"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Devuelve la altura y la escala del registro de misiones, y la escala del mapa, a sus valores predeterminados."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Devuelve la altura y la escala del registro de misiones, y la escala del mapa, a sus valores predeterminados, y lleva la ventana de vuelta a su lugar inicial."
L["RESET_WINDOW_SCALE_CONFIRM"] = "¿Restablecer la altura y la escala del registro de misiones, y la escala del mapa?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"¿Restablecer la altura y la escala del registro de misiones, la escala del mapa y el lugar de la ventana en la pantalla?"
L["HANDY_CLICKS_HEADER"] = "Clics útiles"
L["HANDY_CLICK_TRACK"] = "Mayús-clic en una misión"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "Síguela o deja de seguirla."
L["HANDY_CLICK_MENU"] = "Clic derecho en una misión"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "Síguela, compártela o abandónala."
L["HANDY_CLICK_ID"] = "Clic en un ID de misión"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Obtén su enlace de Wowhead."
L["QUEST_LOG_SUB_PANELS_DESCRIPTION"] =
	"Sus ajustes están en los paneles que hay bajo este: Lista de misiones, Detalles de la misión, Ventana y mapa, y Diálogo con PNJ."
L["NEEDS_WIDE_QUEST_LOG"] =
	"Estos ajustes son para el registro de misiones ancho. Marca Activar registro de misiones ancho en el panel Registro de misiones ancho para usarlos."
L["TAB_QUEST_LIST"] = "Lista de misiones"
L["TAB_QUEST_LIST_DESCRIPTION"] =
	"Tus misiones, agrupadas por zona a lo largo del lado izquierdo del registro de misiones."
L["TAB_QUEST_DETAILS"] = "Detalles de la misión"
L["TAB_QUEST_DETAILS_DESCRIPTION"] =
	"Los detalles de la misión seleccionada, en el pergamino junto a la lista de misiones."

--------------------------------------------------------------------------------
-- Options: NPC Dialogue Panel
--------------------------------------------------------------------------------

L["TAB_NPC_DIALOGUE"] = "Diálogo con PNJ"
L["TAB_NPC_DIALOGUE_DESCRIPTION"] =
	"Las ventanas que abre un PNJ cuando hablas con él: la ventana de misiones del PNJ y la ventana de diálogo. Estos ajustes funcionan con o sin el registro de misiones ancho."
L["QUEST_GIVERS_HEADER"] = "PNJ de misiones"
L["QUEST_GIVERS_DESCRIPTION"] = "La ventana que abre un PNJ de misiones, donde aceptas y entregas misiones."
L["GIVER_CLEANUP"] = "Ventana de misiones del PNJ ordenada"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Da al texto de la ventana de misiones del PNJ el mismo formato que el del registro de misiones, con los mismos títulos e interlineado, y muestra bajo la misión su ID, enlazado a Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Añade las etiquetas de nivel del registro de misiones, como %s, a la lista de misiones de un PNJ."
L["FONT_DIALOGUE_NEEDS_CLEANUP"] =
	"La fuente forma parte de Ventana de misiones del PNJ ordenada, así que necesita que esté activada."

--------------------------------------------------------------------------------
-- Options: Font Sections
--------------------------------------------------------------------------------

L["FONT_HEADER"] = "Fuente"
L["FONT_LIST_DESCRIPTION"] = "La fuente de los nombres de zona y de las misiones en la lista de misiones."
L["FONT_DETAILS_DESCRIPTION"] =
	"La fuente de los detalles de la misión: el título, los encabezados y el texto de la misión."
L["FONT_DIALOGUE_DESCRIPTION"] =
	"La fuente de la ventana de misiones del PNJ y de la ventana de diálogo: el título, los encabezados y el texto de la misión."
L["FONT_WINDOW_DESCRIPTION"] = "La fuente del título de la ventana, el número de misiones y la línea de Entrega."
L["FONT_FACE"] = "Fuente"
L["FONT_FACE_DESCRIPTION"] =
	"El tipo de letra. Predeterminada del juego sigue la fuente del juego y cualquier accesorio que la cambie. También aparecen las fuentes añadidas mediante SharedMedia."
L["FONT_GAME_DEFAULT"] = "Predeterminada del juego"
L["FONT_GAME_STANDARD"] = "Texto estándar"
L["FONT_GAME_NAMES"] = "Nombres de personajes"
L["FONT_GAME_DAMAGE"] = "Números de daño"
L["FONT_SIZE"] = "Tamaño"
L["FONT_SIZE_DESCRIPTION"] =
	"Hace el texto más grande o más pequeño, en puntos respecto al tamaño del juego. 0 mantiene el tamaño del juego."
L["FONT_OUTLINE"] = "Contorno"
L["FONT_OUTLINE_DESCRIPTION"] =
	"Un contorno negro alrededor de cada letra. Predeterminado del juego mantiene el contorno que tenga la fuente del juego, y Ninguno lo quita."
L["FONT_OUTLINE_DEFAULT"] = "Predeterminado del juego"
L["FONT_OUTLINE_NONE"] = "Ninguno"
L["FONT_OUTLINE_THIN"] = "Fino"
L["FONT_OUTLINE_THICK"] = "Grueso"
L["FONT_SHADOW"] = "Sombra del texto"
L["FONT_SHADOW_DESCRIPTION"] =
	"Mantiene la sombra que la fuente del juego proyecta detrás del texto. Desactívala para quitar la sombra, lo que ayuda con una fuente que se ve borrosa o emborronada."
L["FONT_SLUG"] = "Texto más nítido (Slug)"
L["FONT_SLUG_DESCRIPTION"] =
	"Dibuja el texto con Slug, el renderizador más reciente de Blizzard, para letras más nítidas a cualquier tamaño. Slug no puede dibujar un contorno grueso ni una sombra, así que el texto con cualquiera de los dos se dibuja de la forma habitual."
L["FONT_RESET_BUTTON"] = "Restablecer fuente"
L["FONT_RESET_DESCRIPTION"] = "Devuelve los ajustes de esta fuente a sus valores predeterminados."

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Mejoras de comodidad"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Pequeñas ayudas fuera del propio registro de misiones: para compartir misiones con tu grupo y para las mazmorras."
L["QUEST_SHARING_HEADER"] = "Compartir misiones"
L["QUEST_SHARING_INTRO"] =
	"Pasa el ratón por el nombre de una zona del registro de misiones y haz clic en Compartir misiones para ofrecer a tu grupo, una tras otra, todas sus misiones que puedas compartir. Estas opciones fijan el ritmo y lo que pasa cuando a alguien se le escapa una."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"El botón Compartir misiones del nombre de una zona necesita Activar registro de misiones ancho. El envío de misiones de mazmorra funciona sin esta opción."
L["SHARE_INTERVAL"] = "Segundos entre envíos"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Cuánto esperar entre una misión compartida y la siguiente, cuando compartes las misiones de una zona o de una mazmorra. Cuanto más largo, más tiempo tiene tu grupo para aceptar cada una."
L["SHARE_WHISPERS"] = "Susurrar cuando falle un envío"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Cuando un miembro del grupo está ocupado, demasiado lejos o tiene el registro de misiones lleno, le susurra qué misión intentaste compartir y le pide que te lo recuerde. No se envía nada si no cumple los requisitos de la misión, ya la tiene o ya la ha completado."
L["ZONE_SHARE_OFFERS"] = "Ofrecer las misiones de mi zona a los nuevos miembros del grupo"
L["ZONE_SHARE_OFFERS_DESCRIPTION"] =
	"Cuando te unes a un grupo, o alguien se une al tuyo, espera 20 segundos a que Questie intercambie los registros de misiones y luego susurra a cada miembro del grupo que esté en tu zona cuántas de tus misiones con objetivos allí no tiene, y le pregunta si las quiere. Solo cuentan las misiones que puedes compartir. No se susurra a los miembros cuyas misiones no se pueden ver (sin Questie, fuera de alcance) ni a quienes ya las tienen todas. Se pregunta a cada miembro una vez por grupo, y nunca en una mazmorra ni en un grupo de banda."
L["SAMPLE_EXAMPLE"] = "Ejemplo: %s"
L["SAMPLE_QUEST_LOADING"] = "Cargando ID de misión: %d"
L["DUNGEON_QUESTS_HEADER"] = "Misiones de mazmorra"
L["DUNGEON_QUESTS_INTRO"] =
	"Al entrar en una mazmorra con tu grupo, tus misiones de ella se anuncian y se comparten en cuanto todos estén a tu alcance (al momento en WoW Forever), y nunca dos veces al mismo grupo. Con Questie también cuentan las misiones cuyos objetivos están dentro, incluidas las de clase. En un grupo de banda no se hace nada."
L["DUNGEON_ANNOUNCE"] = "Anuncios automáticos de misiones de mazmorra"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Le dice a tu grupo qué misiones te quedan por hacer en la mazmorra en la que acabas de entrar, para que todos sepan qué buscar. Se omiten las misiones listas para entregar."
L["DUNGEON_SHARE"] = "Envío automático de misiones de mazmorra"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Comparte cada misión de la mazmorra que el juego te deja compartir y que a alguien del grupo aún le falta, al ritmo fijado en Compartir misiones, en cuanto todos estén a tu alcance (o pasado un minuto; al momento en WoW Forever). Cada miembro del grupo las recibe una vez por mazmorra, así que quien se une después también las recibe, y salir y volver a entrar no comparte nada. Con Susurrar cuando falle un envío activado, quien se pierda un envío recibe un susurro para que pueda volver a pedirla."

--------------------------------------------------------------------------------
-- Options: Maps & Objectives Panels
--------------------------------------------------------------------------------

L["TAB_MAPS_OBJECTIVES"] = "Mapas y objetivos"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Un marcador en el mapa de zona por cada objetivo y entrega, en lugar de un montón de iconos de misión."
L["MAPS_SUB_PANELS_DESCRIPTION"] =
	"Los ajustes de cada mapa están en los paneles que hay bajo este: Minimapa, Mapa de zona, y Mapa de continente y del mundo."
L["MAPS_NEED_MARKERS"] = "Los marcadores solo se muestran mientras Activar Marcadores de puntos de ruta está activado."
L["TAB_MINIMAP"] = "Minimapa"
L["TAB_MINIMAP_DESCRIPTION"] =
	"Los iconos de Questie en el minimapa muestran exactamente dónde aparecen las cosas y dónde despojarlas, así que siempre se mantienen. Los marcadores de la ruta pueden mostrarse junto a ellos."
L["SHOW_MINIMAP_MARKERS"] = "Mostrar marcadores de puntos de ruta en el minimapa"
L["SHOW_MINIMAP_MARKERS_DESCRIPTION"] =
	"Pone un marcador pequeño en el minimapa por cada punto de ruta, junto a los iconos de Questie. Pasa el ratón por encima de uno para ver sus misiones."
L["MINIMAP_MARKER_SIZE_DESCRIPTION"] = "Lo grandes que son los marcadores de la ruta en el minimapa."
L["TAB_ZONE_MAP"] = "Mapa de zona"
L["TAB_ZONE_MAP_DESCRIPTION"] = "El mapa de una zona, donde la ruta va entre sus marcadores de puntos de ruta."
L["FULL_SIZE_MAP"] = "Abrir el mapa de zona a tamaño completo"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Abre el mapa de zona maximizado, como hace su propio botón de maximizar, para que la ruta tenga espacio. Si reduces el mapa, la próxima vez se vuelve a abrir a tamaño completo."
L["HIDE_QUESTIE_ICONS"] = "Ocultar los iconos de misión en la ruta"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Para lo que está en la ruta, oculta los iconos de mapa de Questie, y los indicadores de misión y las áreas de objetivo de Blizzard, para que los marcadores de la ruta ocupen su lugar. También oculta los iconos atenuados de Questie para los objetivos de los miembros del grupo. Pasa el ratón por un marcador para ver los iconos de Questie."
L["MARKER_SIZE"] = "Tamaño de los marcadores"
L["MARKER_SIZE_DESCRIPTION"] = "Lo grandes que son los marcadores de la ruta en el mapa de zona."
L["MARKER_SIZE_SMALL"] = "Pequeño"
L["MARKER_SIZE_MEDIUM"] = "Mediano"
L["MARKER_SIZE_LARGE"] = "Grande"
L["MARKER_SIZE_HUGE"] = "Enorme"
L["TAB_WIDE_MAP"] = "Mapa de continente y del mundo"
L["TAB_WIDE_MAP_DESCRIPTION"] =
	"Mapas que abarcan muchas zonas a la vez, donde cada objetivo y cada entrega tiene un marcador más pequeño."
L["SHOW_WIDE_MAP_MARKERS"] = "Mostrar marcadores de puntos de ruta en los mapas de continente y del mundo"
L["SHOW_WIDE_MAP_MARKERS_DESCRIPTION"] =
	"Pone un marcador en los mapas de continente y del mundo por cada objetivo y entrega, en lugar de los iconos de Questie. Desactívalo para ver ahí los iconos de Questie."
L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"] =
	"Lo grandes que son los marcadores de la ruta en los mapas de continente y del mundo. Cada tamaño es menor ahí que en el mapa de zona, ya que estos mapas abarcan muchas zonas."

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "Ruta de misiones"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"Una ruta por tus marcadores de puntos de ruta en el mapa de zona, en el orden en que hacerlos, desde donde estás."
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"La Ruta de misiones va entre los marcadores de puntos de ruta, así que solo se muestra mientras Activar Marcadores de puntos de ruta está activado."
L["ROUTES_LINE_HEADER"] = "Línea de ruta"
L["ROUTES_LINE_DESCRIPTION"] = "Los puntos en marcha que van desde ti hasta cada marcador."
L["LINE_SPEED"] = "Velocidad de la línea"
L["LINE_SPEED_DESCRIPTION"] = "Lo rápido que avanzan los puntos hacia el siguiente marcador."
L["LINE_SPEED_STILL"] = "Quieta"
L["LINE_SPEED_SLOW"] = "Lenta"
L["LINE_SPEED_NORMAL"] = "Normal"
L["LINE_SPEED_FAST"] = "Rápida"
L["LINE_OPACITY"] = "Opacidad de la línea"
L["LINE_OPACITY_DESCRIPTION"] =
	"Lo sólidos que son los puntos; cuanto más baja, más se ve el mapa a través de ellos."
L["ROUTES_PARTY_HEADER"] = "Grupo"
L["ROUTES_PARTY_DESCRIPTION"] = "Lo que tu grupo añade a la ruta."
L["PARTY_QUESTS"] = "Incluir las misiones de los miembros del grupo"
L["PARTY_QUESTS_DESCRIPTION"] =
	"En grupo, la ruta y la Flecha de misiones también incluyen las misiones que tienen los miembros de tu grupo y tú no, mostradas igual que las tuyas. Hace falta Questie en ambos lados para compartirlas. Sus misiones de mazmorra se dejan fuera, ya que sus objetivos están dentro de la mazmorra."
L["GROUP_UP"] = "Reunirse con el grupo"
L["GROUP_UP_DESCRIPTION"] =
	"En grupo, cuando alguien de tu zona está fuera de tu minimapa, la Flecha de misiones indica Reunirse con el grupo y apunta hacia él, o al punto medio entre todos, y el mapa del mundo marca el lugar, para que podáis hacer misiones juntos."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Flecha de misiones"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Una flecha en pantalla que apunta al siguiente punto de ruta, con las misiones y objetivos que hacer allí. Pasa el ratón por encima para ver un menú donde puedes ignorar los objetivos de uno en uno y ver lo que has ignorado. Haz clic central en ella para restablecer la zona y recuperar lo que has ignorado allí."
L["QUEST_ARROW_HEADER"] = "Flecha"
L["QUEST_ARROW_DESCRIPTION"] = "Dónde se sitúa la Flecha de misiones y qué tamaño tiene."
L["ARROW_SIZE"] = "Tamaño de la flecha"
L["ARROW_SIZE_DESCRIPTION"] = "Lo grande que es la Flecha de misiones, con el texto que lleva debajo."
L["LOCK_ARROW"] = "Bloquear la Flecha de misiones"
L["LOCK_ARROW_DESCRIPTION"] = "Deja la Flecha de misiones donde está, así que arrastrarla no hace nada."
L["RESET_ARROW"] = "Posición de la flecha"
L["RESET_ARROW_BUTTON"] = "Restablecer"
L["RESET_ARROW_CONFIRM"] = "¿Devolver la Flecha de misiones a su sitio inicial?"
L["RESET_ARROW_DESCRIPTION"] = "Devuelve la Flecha de misiones a su sitio inicial, arriba en el centro de la pantalla."
L["QUEST_ARROW_TEXT_HEADER"] = "Bajo la flecha"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "Lo que la Flecha de misiones muestra debajo de ella."
L["SHOW_DISTANCE"] = "Mostrar distancia"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'Muestra a cuántos metros está el siguiente punto de ruta. "%s" y "%s" se muestran de todas formas.'
L["SHOW_ARROW_QUESTS"] = "Mostrar misiones y objetivos"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"Enumera las misiones del siguiente punto de ruta, cada una con lo que queda por hacer allí."
L["QUESTS_LISTED"] = "Máximo de misiones mostradas"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'Cuántas misiones como máximo muestra la Flecha de misiones debajo de ella para un punto de ruta. Las demás se cuentan en una línea aparte, como "%s".'
L["SHOW_ITEM_BUTTONS"] = "Mostrar botones de objetos de misión"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"Pone un botón junto a cada misión de la lista de la Flecha de misiones que tenga un objeto para usar, como uno para lanzar, plantar o usar sobre un objetivo. Haz clic en él para usar el objeto, o asigna una tecla a Usar objeto de misión en Asignación de teclas, en el panel Pretty Wide Quest Log, para usar el primero. En combate, los botones se quedan donde están hasta que termina."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_NEXT_OBJECTIVE
L["SHOW_NEXT_OBJECTIVE"] = "Mostrar el siguiente objetivo"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'En "%s", muestra "%s" debajo, atenuado: una flechita hacia el punto de ruta siguiente y lo que hay que hacer allí.'
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_PREDICTIVE
L["PREDICTIVE_ROUTES"] = "Rutas de misiones predictivas"
L["PREDICTIVE_ROUTES_DESCRIPTION"] =
	"Planifica las misiones que puedes terminar en esta zona, esté donde esté quien las da, no solo cerca: sus objetivos, su entrega y las misiones que las siguen. Así la ruta acepta todo lo de una parte de la zona antes de que vayas allí, y solo vas una vez. Una cadena se detiene en la primera misión que lleva a otra zona. Los objetivos de una misión que aún no has aceptado tienen un marcador gris. La entrega de cada misión también aparece antes de completarla, con el signo de interrogación gris de Questie."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_FLIGHTS
L["SHOW_FLIGHT_PATHS"] = "Mostrar rutas de vuelo sin descubrir como objetivos"
L["SHOW_FLIGHT_PATHS_DESCRIPTION"] =
	"Añade a la ruta los maestros de vuelo de tu zona cuya ruta de vuelo aún no tienes, marcados con el icono de maestro de vuelo. En un personaje que ya tenía rutas de vuelo, abre cualquier mapa de vuelo una vez para que la ruta sepa cuáles tienes; hasta entonces no se añade ninguna."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_LOCAL
L["SHOW_LOCAL_QUESTS"] = "Mostrar misiones disponibles cercanas como objetivos"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"Pone en la ruta las misiones que puedes aceptar, cuando Questie las muestra como disponibles y un PNJ u objeto que las inicia está a %s o menos, marcadas con el signo de exclamación de Questie. Se dejan fuera las misiones que inicia un objeto que se obtiene como botín y las de mazmorra y banda."
L["LOCAL_QUESTS_HEADER"] = "Misiones disponibles cercanas"
L["LOCAL_QUESTS_DESCRIPTION"] =
	"A qué misiones cercanas te lleva la flecha de misión. Una que se salta puede seguir apareciendo en el mapa del mundo, sin línea de ruta hasta ella."
L["LOCAL_QUEST_RANGE"] = "Radio de búsqueda"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"A cuántos metros de ti puede estar quien da la misión para que cuente. Por debajo de 400, puedes pasar junto a uno entre dos planificaciones de la ruta sin que aparezca."
L["LOCAL_ESCORT_QUESTS"] = "Misiones de escolta"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] =
	"Misiones en las que proteges a un PNJ por el camino; llevan tiempo y a menudo un grupo. Su marcador en el mapa es verde."
L["LOCAL_GROUP_QUESTS"] = "Misiones de grupo y élite"
L["LOCAL_GROUP_QUESTS_DESCRIPTION"] = "Misiones que Questie marca como élite, pensadas para un grupo."
L["LOCAL_OTHER_ZONE_QUESTS"] = "Objetivos en otra zona"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"Misiones con un objetivo, o la entrega, solo fuera de tu zona, como una que te envía al siguiente pueblo."
L["LOCAL_QUEST_LEVEL"] = "Nivel mínimo de misión"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	"Las misiones por debajo de este color de dificultad se quedan fuera. Ajuste de Questie mantiene las misiones que Questie muestra en su mapa."
-- TRANSLATORS: a choice for a kind of nearby quest: the Quest Arrow takes you there
L["LOCAL_CHOICE_ROUTE"] = "En la ruta"
-- TRANSLATORS: a choice for a kind of nearby quest: a marker on the world map, but the Quest Arrow skips it
L["LOCAL_CHOICE_MAP"] = "Solo mapa"
-- TRANSLATORS: a choice for a kind of nearby quest: neither the route nor its map markers show it
L["LOCAL_CHOICE_OFF"] = "Fuera"
L["LOCAL_LEVEL_QUESTIE"] = "Ajuste de Questie"
-- TRANSLATORS: quest difficulty colors, green being a few levels below the player
L["LOCAL_LEVEL_GREEN"] = "Verde o superior"
L["LOCAL_LEVEL_YELLOW"] = "Amarillo o superior"
L["QUEST_ARROW_HIDING_HEADER"] = "Ocultar"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "Cuándo se aparta la Flecha de misiones."
L["HIDE_IN_RAIDS"] = "Ocultar en grupos de banda"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "Oculta la Flecha de misiones mientras estás en un grupo de banda."
L["HIDE_IN_INSTANCES"] = "Ocultar en instancias"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "Oculta la Flecha de misiones en mazmorras, bandas y campos de batalla."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Ayuda a Pretty Wide Quest Log a subir de nivel"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Este accesorio lo han creado jugadores a los que les encanta este juego y que quieren que sea lo más divertido posible para todos. Nunca pediremos donaciones. La verdadera satisfacción es saber que nuestro trabajo hace el juego un poco mejor para ti. Si es así, ¡nos encantaría saberlo!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Estas son algunas formas de ayudarnos a llegar a más jugadores."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Comparte tus comentarios: ¿Has encontrado un error o tienes una idea? Cuéntanoslo en Discord. Tus comentarios nos ayudan a mejorar el accesorio, y las pull requests siempre son bienvenidas."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Cuéntaselo a un amigo: ¿Conoces a alguien a quien le podría gustar este accesorio? Háblale de él. El boca a boca ayuda a más jugadores a descubrir buenos accesorios."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Márcalo como favorito en CurseForge: Abre el enlace de CurseForge de abajo, inicia sesión y haz clic en la estrella bajo el botón de descarga. Los favoritos ayudan a más jugadores a descubrir el accesorio."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Dale a Star en GitHub: Abre el enlace de GitHub de abajo, inicia sesión y haz clic en Star, arriba a la derecha. Las estrellas ayudan al proyecto a optar a más herramientas gratuitas para desarrolladores."
L["OPTIONS_LEVEL_UP_THANKS"] = "¡Gracias por elegir Pretty Wide Quest Log!"
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Enlaces de comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Para copiar un enlace, haz clic en su casilla y pulsa Ctrl+A y luego Ctrl+C."
L["OPTIONS_VERSION"] = "Versión %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "M"
L["QUEST_SUFFIX_RAID"] = "B"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "mazmorra"
L["QUEST_TYPE_RAID"] = "banda"
L["QUEST_TYPE_GROUP"] = "grupo"
L["QUEST_TYPE_ELITE"] = "élite"
L["QUEST_TYPE_PVP"] = "JcJ"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "Letras tras el nivel: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID de misión %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Cadena de misiones (%d de %d)"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "Las misiones diarias se reinician en %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Haz clic para obtener un enlace de Wowhead."
L["WOWHEAD_LINK_COPY"] = "Pulsa Ctrl+C (Cmd+C en un Mac) para copiar el enlace de Wowhead."
L["EXPAND_ALL"] = "Expandir todo"
L["COLLAPSE_ALL"] = "Contraer todo"
L["TRACK_ALL"] = "Seguir todas"
L["UNTRACK_ALL"] = "Dejar de seguir todas"
L["HIDE_MAP"] = "Ocultar mapa"
L["ZONE_INFO_QUESTS"] = "Misiones por recoger"
L["ZONE_INFO_ITEMS"] = "Cosas que llevar"
L["ZONE_INFO_BACK"] = "Volver a la misión"
L["ZONE_INFO_ASK"] = "Pedir que compartan"
L["ZONE_INFO_ASK_DESCRIPTION"] =
	"Escribe en tu chat las misiones de aquí que se pueden compartir, en el canal 4 (Buscar grupo) si estás en él. No se envía nada hasta que pulses Intro."
-- TRANSLATORS: %s is the names of quests, joined by commas; it's written into the chat box, never sent
L["ZONE_INFO_ASK_MESSAGE"] = "¿Alguien puede compartir %s?"
-- TRANSLATORS: the first %s is a quest giver's name, the second the zone they stand in
L["ZONE_INFO_GIVER"] = "La ofrece %s"
L["ZONE_INFO_GIVER_PLACE"] = "%s en %s"
L["ZONE_INFO_SHAREABLE"] = "Compartible"
L["ZONE_INFO_NOT_SHAREABLE"] = "No compartible"
L["ZONE_INFO_TRACK"] = "Añadir a la ruta"
L["ZONE_INFO_UNTRACK"] = "Quitar de la ruta"
L["ZONE_INFO_NEEDED_FOR"] = "Necesario para"
L["ZONE_INFO_SHIFT_CLICK"] = "Mayús-clic"
L["ZONE_INFO_LINK_ITEM"] = "Enlazar en el chat"
L["ZONE_INFO_MENU_QUEST"] = "Esta misión"
L["ZONE_INFO_MENU_HERE"] = "Donde estás"
L["ZONE_INFO_MENU_LOG"] = "Tus misiones"
L["ZONE_INFO_MENU_AVAILABLE"] = "Más misiones para ti"
L["ZONE_INFO_NO_QUESTS"] = "No hay misiones de otras zonas que recoger para aquí."
L["ZONE_INFO_NO_ITEMS"] = "Nada que comprar ni llevar."
L["ZONE_INFO_WORKING"] = "Leyendo misiones..."
L["ZONE_INFO_NEEDS_QUESTIE"] = "Activa Questie para ver qué hay aquí."
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "%s EXP"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "Entrega: %s"
L["TURN_IN_TOOLTIP"] = "Lista para entregar"
L["RESIZE_TOOLTIP"] = "Arrastra para cambiar el tamaño del registro de misiones."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Compartir misiones"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Ofrece a tu grupo las misiones de esta zona que el juego te deja compartir y que a alguien aún le faltan, una cada %d segundos."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "Compartiendo %s cuando termine el combate."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "Compartiendo 1 misión de %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Compartiendo %d misiones de %s, una cada %d segundos."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "No puedes compartir ninguna de tus misiones de %s."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_PARTY_HAS"] = "Tu grupo ya tiene todas tus misiones de %s."

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Has llegado"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "Punto de ruta en otro mapa"
L["ROUTES_OBJECTIVE_AREA"] = "Área de objetivo actual"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "Termina aquí antes de seguir"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "Más a lo largo de la ruta"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "Siguiente objetivo"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "Ya que estás aquí"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d metros"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d metro"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d más aquí"
L["ROUTES_TURN_IN"] = "Entregar misión"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Entregar %s"
L["ROUTES_PICK_UP"] = "Aceptar misión"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "Aceptar %s"
L["ROUTES_FLIGHT_PATH"] = "Conseguir ruta de vuelo"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_FLIGHT_PATH_FROM"] = "Conseguir la ruta de vuelo de %s"
L["ROUTES_FLY_FROM"] = "Habla con %s para volar a %s"
-- TRANSLATORS: under a quest to pick up on the world map, why the route doesn't go there
L["ROUTES_OFF_ROUTE_ESCORT"] = "Misión de escolta, fuera de la ruta"
L["ROUTES_OFF_ROUTE_GROUP"] = "Misión de grupo, fuera de la ruta"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "Lleva a otra zona, fuera de la ruta"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"; over a quest's objectives planned before it's picked up
L["ROUTES_AFTER_PICK_UP"] = "Después de aceptar %s"
-- TRANSLATORS: %s is the quest's title with its level; under a quest to pick up once another is turned in
L["ROUTES_AFTER_TURN_IN"] = "Después de entregar %s"
-- TRANSLATORS: as ROUTES_AFTER_PICK_UP, for a party member's quest planned ahead, one you don't have
L["ROUTES_AFTER_PARTY_PICK_UP"] = "Después de que tu grupo acepte %s"
-- TRANSLATORS: as ROUTES_AFTER_TURN_IN, for a party member's quest
L["ROUTES_AFTER_PARTY_TURN_IN"] = "Después de que tu grupo entregue %s"
L["ROUTES_CORPSE"] = "Vuelve corriendo a tu cadáver"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Busca"
L["ROUTES_CLICK_DRAG"] = "Arrastrar"
L["ROUTES_CLICK_RIGHT"] = "Clic derecho"
L["ROUTES_CLICK_MIDDLE"] = "Clic central"
L["ROUTES_CLICK"] = "Clic"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "Usar objeto"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "Usar objeto de misión"
L["ROUTES_DRAG_MOVE"] = "Mover la Flecha de misiones"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "Ignorar este punto de ruta"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "Ignorar este objetivo"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "Volver a la ruta"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "Restablecer esta zona"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Ignorando %s hasta que restablezcas la zona."
L["ROUTES_ZONE_RESET"] = "Zona restablecida: los objetivos ignorados aquí vuelven a estar en la ruta."
L["ROUTES_GROUP_LEFT_CLEARED"] =
	"Has dejado el grupo: los objetivos de grupo y los miembros ignorados vuelven a estar en la ruta."
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] = "%s ha dejado el grupo: sus objetivos ignorados vuelven a estar en la ruta."
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "Ignorar"
L["ROUTES_MENU_SECTION_ROUTE"] = "Ruta"
L["ROUTES_MENU_SECTION_SHOW"] = "Mostrar"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "Siguiente"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "Restaurar"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "Ignorados"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "Entrega de %s"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "Aceptación de %s"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_MENU_FLIGHT_PATH"] = "Ruta de vuelo de %s"
L["ROUTES_MENU_FLY"] = "Vuelo a %s"
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_ROUTE; Next Objective, under ROUTES_MENU_SECTION_SHOW, is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_PREDICTIVE"] = "Rutas de misiones predictivas"
L["ROUTES_MENU_SHOWN_LOCAL"] = "Misiones disponibles cercanas"
L["ROUTES_MENU_SHOWN_FLIGHTS"] = "Rutas de vuelo"
L["ROUTES_MENU_SHOWN_PARTY"] = "Objetivos del grupo"
L["ROUTES_MENU_ON"] = "Activado"
L["ROUTES_MENU_OFF"] = "Desactivado"
L["ROUTES_MENU_OUT_OF_ZONE"] = "Fuera de la zona"
L["ROUTES_MENU_NO_QUESTIE"] = "Sin Questie"
L["ROUTES_MENU_OFFLINE"] = "Desconectado"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "Objetivos de %s"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "Ignorando %s de %s hasta que restablezcas la zona."
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] = "Ignorando %s de %s hasta que los miembros del grupo que la tienen dejen el grupo."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s vuelve a estar en la ruta."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "Los objetivos de %s quedan fuera de la ruta."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "Los objetivos de %s vuelven a estar en la ruta."
-- TRANSLATORS: on the Quest Arrow and the world map's marker, while it points to where to join up with your party
L["ROUTES_GROUP_UP"] = "Reunirse con el grupo"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them, and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"Intenté compartir %s contigo, pero no funcionó. Si quieres la misión, avísame cuando puedas y te la vuelvo a compartir"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Lo mismo con %s"
L["ZONE_SHARE_OFFER"] = "Tengo %d misiones en %s que no tienes. ¿Quieres que intente compartírtelas?"
L["ZONE_SHARE_OFFER_ONE"] = "Tengo 1 misión en %s que no tienes. ¿Quieres que intente compartírtela?"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Tengo %d misiones por hacer aquí: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Tengo 1 misión por hacer aquí: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Más misiones por hacer aquí: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] =
	"El seguimiento de Questie no puede mostrar %s porque la misión no está en la base de datos de Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie todavía no puede seguir esta misión."
