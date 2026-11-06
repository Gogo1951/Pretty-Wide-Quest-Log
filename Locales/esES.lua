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
	"Ordena la ventana de misiones del PNJ y ayuda a tu grupo a hacerse con tus misiones: ritmo al compartir, susurros cuando un envío no le llega a alguien, y anuncio y envío de misiones de mazmorra. El botón Compartir misiones de una zona en el registro de misiones funciona también con esto desactivado."
L["ENABLE_ROUTES_MAP"] = "Activar rutas en el mapa de zona"
L["FEATURE_ROUTES_MAP_DESCRIPTION"] =
	"Dibuja en el mapa de zona una ruta por tus objetivos de misión y entregas, empezando por lo más cercano, con puntos en marcha entre los marcadores."
L["ENABLE_QUEST_ARROW"] = "Activar Flecha de misiones"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Muestra en pantalla una flecha, la Flecha de misiones, que apunta al siguiente punto de ruta, con las misiones y objetivos que hacer allí. Por defecto se oculta en grupos de banda y en instancias."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Activar registro de misiones ancho surte efecto tras recargar, algo que se te ofrecerá al cerrar la interfaz de opciones."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia de registro de misiones tras recargar. ¿Recargar ahora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este accesorio."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Registro de misiones ancho"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Sustituye el registro de misiones de Blizzard por uno ancho: tus misiones agrupadas por zona, con los detalles de la misión seleccionada y su mapa al lado."
L["QUEST_LOG_SORTING_HEADER"] = "Orden"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Elige el orden de tus zonas y de las misiones que hay debajo."
L["QUEST_LOG_ROWS_HEADER"] = "Filas de misiones"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Elige qué muestra cada fila."
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "Ventana y mapa"
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

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Mejoras de comodidad"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Pequeñas ayudas fuera del propio registro de misiones: para la ventana de misiones del PNJ, para compartir misiones con tu grupo y para las mazmorras."
L["QUEST_GIVERS_HEADER"] = "PNJ de misiones"
L["QUEST_GIVERS_DESCRIPTION"] = "La ventana que abre un PNJ de misiones, donde aceptas y entregas misiones."
L["GIVER_CLEANUP"] = "Ventana de misiones del PNJ ordenada"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Da al texto de la ventana de misiones del PNJ el mismo formato que el del registro de misiones, con los mismos títulos e interlineado, y muestra bajo la misión su ID, enlazado a Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Añade las etiquetas de nivel del registro de misiones, como %s, a la lista de misiones de un PNJ."
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
	"Comparte cada misión de la mazmorra que el juego te deja compartir, al ritmo fijado en Compartir misiones, en cuanto todos estén a tu alcance (o pasado un minuto; al momento en WoW Forever). Cada miembro del grupo las recibe una vez por mazmorra, así que quien se une después también las recibe, y salir y volver a entrar no comparte nada. Con Susurrar cuando falle un envío activado, quien se pierda un envío recibe un susurro para que pueda volver a pedirla."

--------------------------------------------------------------------------------
-- Options: Routes on Zone Map Panel
--------------------------------------------------------------------------------

L["TAB_ROUTES_MAP"] = "Rutas en el mapa de zona"
L["TAB_ROUTES_MAP_DESCRIPTION"] =
	"Una ruta por tus objetivos de misión y entregas en el mapa de zona, en el orden en que hacerlos, desde donde estás."
L["ROUTES_MAP_HEADER"] = "Mapa de zona"
L["FULL_SIZE_MAP"] = "Abrir el mapa de zona a tamaño completo"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Abre el mapa de zona maximizado, como hace su propio botón de maximizar, para que la ruta tenga espacio. Si reduces el mapa, la próxima vez se vuelve a abrir a tamaño completo."
L["HIDE_QUESTIE_ICONS"] = "Ocultar los iconos de Questie en la ruta"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Oculta los iconos de mapa de Questie de lo que está en la ruta, para que los marcadores ocupen su lugar. Pasa el ratón por un marcador para ver sus iconos."
L["ROUTES_MARKERS_HEADER"] = "Marcadores"
L["MARKER_SIZE"] = "Tamaño de los marcadores"
L["MARKER_SIZE_DESCRIPTION"] = "Lo grandes que son los marcadores de la ruta en el mapa de zona."
L["MARKER_SIZE_SMALL"] = "Pequeño"
L["MARKER_SIZE_MEDIUM"] = "Mediano"
L["MARKER_SIZE_LARGE"] = "Grande"
L["MARKER_SIZE_HUGE"] = "Enorme"
L["ROUTES_LINE_HEADER"] = "Línea de ruta"
L["SHOW_ROUTE_LINE"] = "Mostrar la línea de ruta"
L["SHOW_ROUTE_LINE_DESCRIPTION"] =
	"Dibuja puntos en marcha desde ti hasta cada marcador, uno tras otro. Desactivada, solo se ven los marcadores."
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
L["PARTY_QUESTS"] = "Incluir las misiones de los miembros del grupo"
L["PARTY_QUESTS_DESCRIPTION"] =
	"En grupo, la ruta y la Flecha de misiones también incluyen las misiones que tienen los miembros de tu grupo y tú no, mostradas igual que las tuyas. Hace falta Questie en ambos lados para compartirlas. Sus misiones de mazmorra se dejan fuera, como las tuyas."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Flecha de misiones"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Una flecha en pantalla que apunta al siguiente punto de ruta, con las misiones y objetivos que hacer allí. Haz clic derecho en ella para desviar la ruta del objetivo actual; clic central para restablecer todas las rutas."
L["QUEST_ARROW_HEADER"] = "Flecha"
L["ARROW_SIZE"] = "Tamaño de la flecha"
L["ARROW_SIZE_DESCRIPTION"] = "Lo grande que es la Flecha de misiones, con el texto que lleva debajo."
L["ARROW_CYCLE"] = "Ciclo de ojo y flecha (segundos)"
L["ARROW_CYCLE_DESCRIPTION"] =
	"En un área de objetivo, la Flecha de misiones se alterna: primero el ojo, que enumera los objetivos a tu alrededor, y luego la flecha, que apunta al siguiente punto de ruta. Cada uno dura la mitad de este tiempo."
L["LOCK_ARROW"] = "Bloquear la Flecha de misiones"
L["LOCK_ARROW_DESCRIPTION"] = "Deja la Flecha de misiones donde está, así que arrastrarla no hace nada."
L["RESET_ARROW"] = "Posición de la flecha"
L["RESET_ARROW_BUTTON"] = "Restablecer"
L["RESET_ARROW_DESCRIPTION"] = "Devuelve la Flecha de misiones a su sitio inicial, arriba en el centro de la pantalla."
L["QUEST_ARROW_TEXT_HEADER"] = "Bajo la flecha"
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
L["QUEST_ARROW_HIDING_HEADER"] = "Ocultar"
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
L["QUEST_LEVEL_LEGEND"] = "Letras tras el nivel: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID de misión %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Cadena de misiones (%d de %d)"
L["DAILY_RESET"] = "Las misiones diarias se reinician en %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Haz clic para obtener un enlace de Wowhead."
L["WOWHEAD_LINK_COPY"] = "Pulsa Ctrl+C (Cmd+C en un Mac) para copiar el enlace de Wowhead."
L["EXPAND_ALL"] = "Expandir todo"
L["COLLAPSE_ALL"] = "Contraer todo"
L["TRACK_ALL"] = "Seguir todas"
L["UNTRACK_ALL"] = "Dejar de seguir todas"
L["HIDE_MAP"] = "Ocultar mapa"
L["TURN_IN_XP"] = "%s EXP"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "Entrega: %s"
L["TURN_IN_TOOLTIP"] = "Lista para entregar"
L["RESIZE_TOOLTIP"] = "Arrastra para cambiar el tamaño del registro de misiones."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Compartir misiones"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Ofrece a tu grupo las misiones de esta zona que el juego te deja compartir, una cada %d segundos."
L["CHAT_SHARING_ZONE_ONE"] = "Compartiendo 1 misión de %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Compartiendo %d misiones de %s, una cada %d segundos."
L["CHAT_SHARING_ZONE_NONE"] = "No puedes compartir ninguna de tus misiones de %s."

--------------------------------------------------------------------------------
-- Routes on Zone Map and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Has llegado"
L["ROUTES_OBJECTIVE_AREA"] = "Área de objetivo"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d m"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d más aquí"
L["ROUTES_TURN_IN"] = "Entregar misión"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Entregar %s"
L["ROUTES_CORPSE"] = "Tu cadáver"
L["ROUTES_CORPSE_HINT"] = "Vuelve corriendo hasta él para resucitar"
-- TRANSLATORS: Heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Busca"
-- TRANSLATORS: %s is the party members a waypoint's objective is for, such as "Alice, Bob"
L["ROUTES_FOR_MEMBERS"] = "Para %s"
L["ROUTES_CLICK_DRAG"] = "Arrastrar"
L["ROUTES_CLICK_RIGHT"] = "Clic derecho"
L["ROUTES_CLICK_MIDDLE"] = "Clic central"
L["ROUTES_DRAG_MOVE"] = "Mover la Flecha de misiones"
L["ROUTES_RIGHT_CLICK_REROUTE"] = "Desviar la ruta del objetivo actual"
L["ROUTES_MIDDLE_CLICK_RESET"] = "Restablecer todas las rutas"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Ruta desviada para evitar %s."
L["CHAT_FULL_SIZE_MAP_SET"] =
	"El mapa de zona se volverá a abrir a tamaño completo. Para que siga pequeño, desactiva Abrir el mapa de zona a tamaño completo en Rutas en el mapa de zona."
L["ROUTES_RESET"] = "Todas las rutas restablecidas: los objetivos desviados vuelven a estar en la ruta."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

-- TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
-- each %s is a quest link or a list of them, and each %d is how many quests
L["WHISPER_SHARE_FAILED"] =
	"Intenté compartir %s contigo, pero no funcionó. Si quieres la misión, avísame cuando puedas y te la vuelvo a compartir"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Lo mismo con %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Tengo %d misiones por hacer aquí: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Tengo 1 misión por hacer aquí: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Más misiones por hacer aquí: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"El seguimiento de Questie no puede mostrar %s porque la misión no está en la base de datos de Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie todavía no puede seguir esta misión."
