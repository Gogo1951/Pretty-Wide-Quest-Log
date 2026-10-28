local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "esES")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT_NAME"] = "PWQL"
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
	"Un registro de misiones ancho, redimensionable y de doble panel, con niveles de misión, etiquetas de mazmorra y élite, recompensas, cadenas de misiones y un mapa para cada misión. Comparte misiones con tu grupo y anuncia automáticamente las misiones de mazmorra. Funciona con Questie, VoiceOver y ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] =
	"Muestra el mensaje de bienvenida de Pretty Wide Quest Log al iniciar sesión."
L["OPTIONS_FEATURES_HEADER"] = "Funciones"
L["ENABLE_WIDE_QUEST_LOG"] = "Activar registro de misiones ancho"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Cambia el registro de misiones de Blizzard por el ancho, con el mapa al lado. Surte efecto tras recargar."
L["ENABLE_QUALITY_OF_LIFE"] = "Activar mejoras de comodidad"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Ordena la ventana de misiones del PNJ y ayuda a tu grupo a hacerse con tus misiones: ritmo al compartir, susurros cuando un envío no le llega a alguien, y anuncio y envío de misiones de mazmorra. Compartir misiones de una zona funciona en ambos casos."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Activar registro de misiones ancho surte efecto tras recargar, algo que se te ofrecerá al cerrar la interfaz de opciones."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia de registro de misiones tras recargar. ¿Recargar ahora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este accesorio."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Sustituye el registro de misiones de Blizzard por uno ancho: tus misiones agrupadas por zona, con los detalles de la misión seleccionada y su mapa al lado."
L["QUEST_LOG_LAYOUT_HEADER"] = "Diseño del registro de misiones"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"Ordena tus misiones a tu manera, elige qué muestra cada fila y ajusta el tamaño de la ventana y del mapa a tu pantalla."
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
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Las misiones seguidas pierden su marca de verificación %s y las misiones sin seguir llevan un ojo %s en su lugar. Útil si sigues casi todo."
L["CLOSE_IN_COMBAT"] = "Cerrar al entrar en combate"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Cierra el registro de misiones cuando empieza un combate, para que nunca tape la acción."
L["SHOW_OBJECTIVE_AREAS"] = "Mostrar áreas de objetivos"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Sombrea en el mapa junto al registro de misiones dónde se encuentran los enemigos y objetos de cada objetivo, con un icono en cada área en lugar de uno en cada punto de aparición. Necesita Questie."
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
L["RESET_WINDOW_SCALE_CONFIRM"] = "¿Restablecer la altura y la escala del registro de misiones?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"¿Restablecer la altura y la escala del registro de misiones, y su lugar en la pantalla?"

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
	"Haz clic derecho en el nombre de una zona del registro de misiones para ofrecer a tu grupo, una tras otra, todas sus misiones que puedas compartir. Estas opciones fijan el ritmo y lo que pasa cuando a alguien se le escapa una."
L["SHARE_INTERVAL"] = "Segundos entre envíos"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Cuánto esperar entre una misión compartida y la siguiente, tanto en Compartir misiones como en el envío automático de misiones de mazmorra. Cuanto más largo, más tiempo tiene tu grupo para aceptar cada una."
L["SHARE_WHISPERS"] = "Susurrar cuando falle un envío"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Cuando un miembro del grupo está ocupado, demasiado lejos o tiene el registro de misiones lleno, le susurra qué misión intentaste compartir y le pide que te lo recuerde. No se envía nada si no cumple los requisitos de la misión, ya la tiene o ya la ha completado."
L["SAMPLE_EXAMPLE"] = "Ejemplo: %s"
L["SAMPLE_QUEST_LOADING"] = "Cargando ID de misión: %d"
L["DUNGEON_QUESTS_HEADER"] = "Misiones de mazmorra"
L["DUNGEON_QUESTS_INTRO"] =
	"Al entrar en una mazmorra o banda con tu grupo, se anuncian y comparten tus misiones de ella, una vez por grupo en cada mazmorra. Con Questie también cuentan las misiones cuyos objetivos están dentro, incluidas las de clase."
L["DUNGEON_ANNOUNCE"] = "Anuncios automáticos de misiones de mazmorra"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Le dice a tu grupo qué misiones te quedan por hacer en la mazmorra en la que acabas de entrar, para que todos sepan qué buscar. Se omiten las misiones listas para entregar."
L["DUNGEON_SHARE"] = "Envío automático de misiones de mazmorra"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Comparte cada misión de la mazmorra que el juego te deja compartir, al ritmo fijado en Compartir misiones. Con Susurrar cuando falle un envío activado, quien se pierda un envío recibe un susurro para que pueda volver a pedirla. Vuelve a compartir cada vez que alguien se une al grupo o lo deja."

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
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_LEVEL_LEGEND_SEPARATOR"] = ", "
L["QUEST_ID"] = "ID de misión %d"
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
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_ACTIONS_HINT"] = "Clic derecho para compartir misiones o abandonar las grises"
L["SHARE_ZONE_QUESTS"] = "Compartir %d misiones"
L["SHARE_ZONE_QUEST"] = "Compartir 1 misión"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Ofrece a tu grupo las misiones de esta zona que el juego te deja compartir, una cada %d segundos."
L["SHARE_ZONE_QUEST_TOOLTIP"] = "Ofrece a tu grupo la única misión de esta zona que el juego te deja compartir."
L["CHAT_SHARING_ZONE_ONE"] = "Compartiendo 1 misión de %s."
L["CHAT_SHARING_ZONE"] = "Compartiendo %d misiones de %s, una cada %d segundos."
L["ABANDON_GRAY_QUESTS"] = "Abandonar misiones grises"
L["ABANDON_GRAY_NONE"] = "Esta zona no tiene misiones grises que abandonar."
L["ABANDON_GRAY_CONFIRM"] = "¿Abandonar estas %d misiones grises?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "¿Abandonar esta misión gris?"
L["CHAT_ABANDONED_GRAY"] = "Has abandonado %d misiones grises."
L["CHAT_ABANDONED_GRAY_ONE"] = "Has abandonado 1 misión gris."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_FAILED"] =
	"Intenté compartir %s contigo, pero no funcionó. Si quieres la misión, avísame cuando puedas y te la vuelvo a compartir"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Lo mismo con %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Tengo %d misiones por hacer aquí: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Tengo 1 misión por hacer aquí: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Más misiones por hacer aquí: %s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"El seguimiento de Questie no puede mostrar %s porque la misión no está en la base de datos de Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie todavía no puede seguir esta misión."
