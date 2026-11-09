local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "esMX")
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
	"Versión %s. La configuración (incluida la opción para desactivar este mensaje) está en Opciones > Accesorios > Pretty Wide Quest Log. ¿Te gusta este accesorio? Cuéntale a un amigo, márcalo como favorito en CurseForge o dale Star en GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por seguridad, la interfaz de opciones no se puede abrir durante el combate."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Sin Questie, el mapa de misiones muestra menos, y las cadenas de misiones y el total de Entrega quedan ocultos. Activa Questie en la lista de accesorios para verlos."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus también está activado y los dos se pelearán por el registro de misiones. Desactiva Wide Quest Log Plus en la lista de accesorios y después recarga."

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
	"Cambia el registro de misiones de Blizzard por el ancho, con el mapa al lado. Se aplica después de recargar."
L["ENABLE_QUALITY_OF_LIFE"] = "Activar mejoras de comodidad"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Ordena la ventana de misiones del PNJ y ayuda a tu grupo a obtener tus misiones: ritmo al compartir, susurros cuando un envío no le llega a alguien, y anuncio y envío de misiones de calabozo. El botón Compartir misiones de una zona en el registro de misiones también funciona con esto desactivado."
L["ENABLE_WAYPOINT_MARKERS"] = "Activar Marcadores de puntos de ruta"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Reúne los íconos de misión de cada objetivo en el mapa de zona en un solo marcador, un punto de ruta, donde están la mayoría de sus enemigos u objetos, y uno más por cada entrega. Pasa el mouse sobre un marcador para ver los íconos a los que sustituye."
L["ENABLE_QUEST_ROUTE"] = "Activar Ruta de misiones"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"Dibuja en el mapa de zona una ruta por tus marcadores de puntos de ruta, empezando por lo más cercano, con puntos en marcha desde ti hasta cada marcador, uno tras otro. Necesita Marcadores de puntos de ruta."
L["ENABLE_QUEST_ARROW"] = "Activar Flecha de misiones"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Muestra en pantalla una flecha, la Flecha de misiones, que apunta al siguiente punto de ruta, con las misiones y objetivos que hacer ahí. De forma predeterminada se oculta en grupos de banda y en instancias."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Activar registro de misiones ancho se aplica después de recargar, algo que se te ofrecerá al cerrar la interfaz de opciones."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia de registro de misiones después de recargar. ¿Recargar ahora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este accesorio."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Registro de misiones ancho"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Reemplaza el registro de misiones de Blizzard por uno ancho: tus misiones agrupadas por zona, con los detalles de la misión seleccionada y su mapa al lado."
L["QUEST_LOG_SORTING_HEADER"] = "Orden"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Elige el orden de tus zonas y de las misiones que hay debajo."
L["QUEST_LOG_ROWS_HEADER"] = "Filas de misiones"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Elige qué muestra cada fila."
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "Ventana y mapa"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"Ajusta el tamaño de la ventana y del mapa a tu pantalla, y elige cómo se comportan."
L["ZONE_ORDER"] = "Orden de zonas"
L["ZONE_ORDER_DESCRIPTION"] = "Cambia el orden de las zonas en la lista de misiones."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Nivel promedio, el más alto primero (predeterminado)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Nivel promedio, el más bajo primero"
L["SORT_ALPHABETICAL"] = "Alfabético"
L["CURRENT_ZONE_FIRST"] = "Mostrar primero la zona actual"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Coloca la zona en la que estás al principio de la lista, sin importar el orden de zonas."
L["ZONE_GAP"] = "Agregar espacio sobre los nombres de zona"
L["ZONE_GAP_DESCRIPTION"] =
	"Agrega un poco de espacio sobre cada nombre de zona. Útil si tus misiones están repartidas en muchas zonas."
L["QUEST_ORDER"] = "Orden de misiones"
L["QUEST_ORDER_DESCRIPTION"] = "Cambia el orden de las misiones dentro de cada zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Nivel, el más alto primero (predeterminado)"
L["SORT_LEVEL_LOWEST"] = "Nivel, el más bajo primero"
L["COMPLETED_FIRST"] = "Mostrar primero las misiones completadas"
L["COMPLETED_FIRST_DESCRIPTION"] = "Sube al principio de su zona las misiones que ya puedes entregar."
L["SHOW_QUEST_LEVELS"] = "Mostrar niveles de misión"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Pone el nivel y el tipo de cada misión antes de su nombre en la lista, como %s para una misión de calabozo de nivel 40."
L["MARK_UNTRACKED"] = "Marcar misiones sin seguir"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Las misiones seguidas pierden su marca de verificación %s y las misiones sin seguir llevan un ojo %s en su lugar. Útil si sigues casi todo."
L["CLOSE_IN_COMBAT"] = "Cerrar al entrar en combate"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Cierra el registro de misiones cuando empieza un combate, para que nunca tape la acción."
L["SHOW_OBJECTIVE_AREAS"] = "Mostrar áreas de objetivos"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Sombrea en el mapa junto al registro de misiones dónde se encuentran los enemigos y objetos de cada objetivo, con un ícono en cada área en vez de uno en cada punto de aparición."
L["NEEDS_QUESTIE_HINT"] = "Activa Questie para usar esto."
L["WINDOW_SCALE"] = "Escala del registro de misiones"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Hace el registro de misiones más grande o más pequeño. El mapa de al lado crece y se encoge con él."
L["MAP_SCALE"] = "Escala del mapa"
L["MAP_SCALE_DESCRIPTION"] =
	"Hace el mapa junto al registro de misiones más grande o más pequeño, además de la escala del registro de misiones."
L["RESET_WINDOW_BUTTON"] = "Restablecer ventana"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Regresa la altura y la escala del registro de misiones, y la escala del mapa, a sus valores predeterminados."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Regresa la altura y la escala del registro de misiones, y la escala del mapa, a sus valores predeterminados, y regresa la ventana a su lugar inicial."
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

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Mejoras de comodidad"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Pequeñas ayudas fuera del propio registro de misiones: para la ventana de misiones del PNJ, para compartir misiones con tu grupo y para los calabozos."
L["QUEST_GIVERS_HEADER"] = "PNJ de misiones"
L["QUEST_GIVERS_DESCRIPTION"] = "La ventana que abre un PNJ de misiones, donde aceptas y entregas misiones."
L["GIVER_CLEANUP"] = "Ventana de misiones del PNJ ordenada"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Da al texto de la ventana de misiones del PNJ el mismo formato que el del registro de misiones, con los mismos títulos e interlineado, y muestra debajo de la misión su ID, enlazado a Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Agrega las etiquetas de nivel del registro de misiones, como %s, a la lista de misiones de un PNJ."
L["QUEST_SHARING_HEADER"] = "Compartir misiones"
L["QUEST_SHARING_INTRO"] =
	"Pasa el mouse sobre el nombre de una zona del registro de misiones y haz clic en Compartir misiones para ofrecerle a tu grupo, una tras otra, todas sus misiones que puedas compartir. Estas opciones fijan el ritmo y lo que pasa cuando a alguien se le pasa una."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"El botón Compartir misiones del nombre de una zona requiere Activar registro de misiones ancho. El envío de misiones de calabozo funciona sin esta opción."
L["SHARE_INTERVAL"] = "Segundos entre envíos"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Cuánto esperar entre una misión compartida y la siguiente, cuando compartes las misiones de una zona o de un calabozo. Entre más largo, más tiempo tiene tu grupo para aceptar cada una."
L["SHARE_WHISPERS"] = "Susurrar cuando falle un envío"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Cuando un miembro del grupo está ocupado, demasiado lejos o tiene el registro de misiones lleno, le susurra qué misión intentaste compartir y le pide que te lo recuerde. No se envía nada si no cumple los requisitos de la misión, ya la tiene o ya la completó."
L["SAMPLE_EXAMPLE"] = "Ejemplo: %s"
L["SAMPLE_QUEST_LOADING"] = "Cargando ID de misión: %d"
L["DUNGEON_QUESTS_HEADER"] = "Misiones de calabozo"
L["DUNGEON_QUESTS_INTRO"] =
	"Al entrar a un calabozo con tu grupo, tus misiones de ahí se anuncian y se comparten en cuanto todos estén a tu alcance (de inmediato en WoW Forever), y nunca dos veces al mismo grupo. Con Questie también cuentan las misiones cuyos objetivos están adentro, incluidas las de clase. En un grupo de banda no se hace nada."
L["DUNGEON_ANNOUNCE"] = "Anuncios automáticos de misiones de calabozo"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Le dice a tu grupo qué misiones te quedan por hacer en el calabozo al que acabas de entrar, para que todos sepan qué buscar. Se omiten las misiones listas para entregar."
L["DUNGEON_SHARE"] = "Envío automático de misiones de calabozo"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Comparte cada misión del calabozo que el juego te deja compartir, al ritmo fijado en Compartir misiones, en cuanto todos estén a tu alcance (o después de un minuto; de inmediato en WoW Forever). Cada miembro del grupo las recibe una vez por calabozo, así que quien se une después también las recibe, y salir y volver a entrar no comparte nada. Con Susurrar cuando falle un envío activado, quien se pierda un envío recibe un susurro para que pueda volver a pedirla."

--------------------------------------------------------------------------------
-- Options: Waypoint Markers Panel
--------------------------------------------------------------------------------

L["TAB_WAYPOINT_MARKERS"] = "Marcadores de puntos de ruta"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Un marcador en el mapa de zona por cada objetivo y entrega, en lugar de un montón de íconos de misión."
L["ROUTES_MAP_HEADER"] = "Mapa de zona"
L["ROUTES_MAP_DESCRIPTION"] = "Cómo se abre el mapa de zona mientras muestra la ruta."
L["FULL_SIZE_MAP"] = "Abrir el mapa de zona a tamaño completo"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Abre el mapa de zona maximizado, como hace su propio botón de maximizar, para que la ruta tenga espacio. Si reduces el mapa, la próxima vez se vuelve a abrir a tamaño completo."
L["HIDE_QUESTIE_ICONS"] = "Ocultar los íconos de misión en la ruta"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Para lo que está en la ruta, oculta los íconos de mapa de Questie, y los indicadores de misión y las áreas de objetivo de Blizzard, para que los marcadores de la ruta ocupen su lugar. También oculta los íconos atenuados de Questie para los objetivos de los miembros del grupo. Pasa el mouse sobre un marcador para ver los íconos de Questie."
L["ROUTES_MARKERS_HEADER"] = "Marcadores"
L["ROUTES_MARKERS_DESCRIPTION"] = "Los marcadores de cada punto de ruta."
L["MARKER_SIZE"] = "Tamaño de los marcadores"
L["MARKER_SIZE_DESCRIPTION"] = "Lo grandes que son los marcadores de la ruta en el mapa de zona."
L["MARKER_SIZE_SMALL"] = "Pequeño"
L["MARKER_SIZE_MEDIUM"] = "Mediano"
L["MARKER_SIZE_LARGE"] = "Grande"
L["MARKER_SIZE_HUGE"] = "Enorme"

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
L["ROUTES_PARTY_DESCRIPTION"] = "Lo que tu grupo agrega a la ruta."
L["PARTY_QUESTS"] = "Incluir las misiones de los miembros del grupo"
L["PARTY_QUESTS_DESCRIPTION"] =
	"En grupo, la ruta y la Flecha de misiones también incluyen las misiones que tienen los miembros de tu grupo y tú no, mostradas igual que las tuyas. Se necesita Questie en ambos lados para compartirlas. Sus misiones de calabozo se dejan fuera, ya que sus objetivos están dentro del calabozo."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Flecha de misiones"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Una flecha en pantalla que apunta al siguiente punto de ruta, con las misiones y objetivos que hacer ahí. Pasa el mouse por encima para ver un menú donde puedes ignorar los objetivos uno por uno y ver lo que ignoraste. Haz clic central en ella para vaciar la lista de ignorados."
L["QUEST_ARROW_HEADER"] = "Flecha"
L["QUEST_ARROW_DESCRIPTION"] = "Dónde se ubica la Flecha de misiones y qué tamaño tiene."
L["ARROW_SIZE"] = "Tamaño de la flecha"
L["ARROW_SIZE_DESCRIPTION"] = "Lo grande que es la Flecha de misiones, con el texto que lleva debajo."
L["LOCK_ARROW"] = "Bloquear la Flecha de misiones"
L["LOCK_ARROW_DESCRIPTION"] = "Deja la Flecha de misiones donde está, así que arrastrarla no hace nada."
L["RESET_ARROW"] = "Posición de la flecha"
L["RESET_ARROW_BUTTON"] = "Restablecer"
L["RESET_ARROW_CONFIRM"] = "¿Regresar la Flecha de misiones a su lugar inicial?"
L["RESET_ARROW_DESCRIPTION"] = "Regresa la Flecha de misiones a su lugar inicial, arriba en el centro de la pantalla."
L["QUEST_ARROW_TEXT_HEADER"] = "Bajo la flecha"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "Lo que la Flecha de misiones muestra debajo de ella."
L["SHOW_DISTANCE"] = "Mostrar distancia"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'Muestra a cuántos metros está el siguiente punto de ruta. "%s" y "%s" se muestran de todas formas.'
L["SHOW_ARROW_QUESTS"] = "Mostrar misiones y objetivos"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"Enumera las misiones del siguiente punto de ruta, cada una con lo que falta hacer ahí."
L["QUESTS_LISTED"] = "Máximo de misiones mostradas"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'Cuántas misiones como máximo muestra la Flecha de misiones debajo de ella para un punto de ruta. Las demás se cuentan en una línea aparte, como "%s".'
L["SHOW_ITEM_BUTTONS"] = "Mostrar botones de objetos de misión"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"Pone un botón junto a cada misión de la lista de la Flecha de misiones que tenga un objeto para usar, como uno para lanzar, plantar o usar sobre un objetivo. Haz clic en él para usar el objeto, o asigna una tecla a Usar objeto de misión en la Asignación de teclas del juego para usar el primero. En combate, los botones se quedan donde están hasta que termina."
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_NEXT_OBJECTIVE"] = "Mostrar el siguiente objetivo"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'En "%s", muestra "%s" debajo, atenuado: una flechita hacia el punto de ruta siguiente y lo que hay que hacer ahí.'
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_UPCOMING_TURN_INS"] = "Mostrar entregas futuras"
L["SHOW_UPCOMING_TURN_INS_DESCRIPTION"] =
	"Pone la entrega de cada misión en la ruta antes de completar sus objetivos, marcada con el signo de interrogación gris de Questie, para que veas dónde la entregarás. Desactivado, una entrega se une a la ruta cuando la misión está completa."
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_LOCAL_QUESTS"] = "Mostrar misiones disponibles cercanas como objetivos"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"Pone en la ruta las misiones que puedes aceptar, cuando Questie las muestra como disponibles y un PNJ u objeto que las inicia está a %s o menos, marcadas con el signo de exclamación de Questie. Se dejan fuera las misiones que inicia un objeto que se obtiene como botín y las de calabozo y banda."
L["QUEST_ARROW_HIDING_HEADER"] = "Ocultar"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "Cuándo se aparta la Flecha de misiones."
L["HIDE_IN_RAIDS"] = "Ocultar en grupos de banda"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "Oculta la Flecha de misiones mientras estás en un grupo de banda."
L["HIDE_IN_INSTANCES"] = "Ocultar en instancias"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "Oculta la Flecha de misiones en calabozos, bandas y campos de batalla."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Ayuda a Pretty Wide Quest Log a subir de nivel"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Este accesorio lo crearon jugadores que aman este juego y quieren que sea lo más divertido posible para todos. Nunca pediremos donaciones. La verdadera satisfacción es saber que nuestro trabajo hace el juego un poco mejor para ti. Si es así, ¡nos encantaría saberlo!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Estas son algunas formas en que puedes ayudarnos a llegar a más jugadores."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Comparte tus comentarios: ¿Encontraste un error o tienes una idea? Avísanos en Discord. Tus comentarios nos ayudan a mejorar el accesorio, y los pull requests siempre son bienvenidos."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Cuéntale a un amigo: ¿Conoces a alguien a quien le podría gustar este accesorio? Platícale de él. Las recomendaciones de boca en boca ayudan a más jugadores a descubrir buenos accesorios."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Márcalo como favorito en CurseForge: Abre el enlace de CurseForge de abajo, inicia sesión y haz clic en la estrella debajo del botón de descarga. Los favoritos ayudan a más jugadores a descubrir el accesorio."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Dale Star en GitHub: Abre el enlace de GitHub de abajo, inicia sesión y haz clic en Star, arriba a la derecha. Las estrellas ayudan al proyecto a calificar para más herramientas gratuitas para desarrolladores."
L["OPTIONS_LEVEL_UP_THANKS"] = "¡Gracias por elegir Pretty Wide Quest Log!"
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Enlaces de comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Para copiar un enlace, haz clic en su casilla y luego presiona Ctrl+A y Ctrl+C."
L["OPTIONS_VERSION"] = "Versión %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "C"
L["QUEST_SUFFIX_RAID"] = "B"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "calabozo"
L["QUEST_TYPE_RAID"] = "banda"
L["QUEST_TYPE_GROUP"] = "grupo"
L["QUEST_TYPE_ELITE"] = "élite"
L["QUEST_TYPE_PVP"] = "JcJ"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "Letras después del nivel: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID de misión %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Cadena de misiones (%d de %d)"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "Las misiones diarias se reinician en %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Haz clic para obtener un enlace de Wowhead."
L["WOWHEAD_LINK_COPY"] = "Presiona Ctrl+C (Cmd+C en una Mac) para copiar el enlace de Wowhead."
L["EXPAND_ALL"] = "Expandir todo"
L["COLLAPSE_ALL"] = "Contraer todo"
L["TRACK_ALL"] = "Seguir todas"
L["UNTRACK_ALL"] = "Dejar de seguir todas"
L["HIDE_MAP"] = "Ocultar mapa"
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
	"Le ofrece a tu grupo las misiones de esta zona que el juego te deja compartir, una cada %d segundos."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "Compartiendo %s cuando termine el combate."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "Compartiendo 1 misión de %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Compartiendo %d misiones de %s, una cada %d segundos."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "No puedes compartir ninguna de tus misiones de %s."

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Llegaste"
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
L["ROUTES_CORPSE"] = "Regresa corriendo a tu cadáver"
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
L["ROUTES_MIDDLE_CLICK_RESET"] = "Restablecer todas las rutas"
L["ROUTES_MIDDLE_CLICK_CLEAR_IGNORED"] = "Vaciar la lista de ignorados"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Ignorando %s hasta que se vacíe la lista de ignorados."
L["ROUTES_RESET"] =
	"Todas las rutas restablecidas: los objetivos y miembros del grupo ignorados vuelven a estar en la ruta."
L["ROUTES_IGNORE_CLEARED"] = "Lista de ignorados vaciada: los objetivos ignorados vuelven a estar en la ruta."
L["ROUTES_GROUP_JOINED_CLEARED"] =
	"Te uniste a un grupo: los objetivos y miembros del grupo ignorados vuelven a estar en la ruta."
L["ROUTES_GROUP_LEFT_CLEARED"] =
	"Dejaste el grupo: los objetivos y miembros del grupo ignorados vuelven a estar en la ruta."
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "Ignorar"
L["ROUTES_MENU_SECTION_SHOWN"] = "Qué se muestra"
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
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_SHOWN; Next Objective is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_TURN_INS"] = "Entregas futuras"
L["ROUTES_MENU_SHOWN_LOCAL"] = "Misiones disponibles cercanas"
L["ROUTES_MENU_SHOWN_PARTY"] = "Objetivos del grupo"
L["ROUTES_MENU_ON"] = "Activado"
L["ROUTES_MENU_OFF"] = "Desactivado"
L["ROUTES_MENU_OUT_OF_ZONE"] = "Fuera de la zona"
L["ROUTES_MENU_NO_QUESTIE"] = "Sin Questie"
L["ROUTES_MENU_OFFLINE"] = "Desconectado"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "Objetivos de %s"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "Ignorando %s de %s hasta que se vacíe la lista de ignorados."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s vuelve a estar en la ruta."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "Los objetivos de %s quedan fuera de la ruta."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "Los objetivos de %s vuelven a estar en la ruta."

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
