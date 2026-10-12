local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "esES")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"Versión %s. Puedes encontrar los ajustes (incluida la opción de desactivar este mensaje) en Opciones > Accesorios > Pretty Wide Quest Log. ¿Te gusta el accesorio? ¡Cuéntaselo a un amigo! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por seguridad, la interfaz de opciones no se puede abrir durante el combate."
L["CHAT_QUESTIE_MISSING"] =
	"Gran parte de este accesorio funciona con los datos de Questie. Sin Questie, tendrás menos funciones disponibles."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus también está activado y los dos se pelearán por el registro de misiones. Desactiva Wide Quest Log Plus en la lista de accesorios y luego recarga."

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Un registro de misiones más grande y mejor que te da más espacio para leer y más información de un vistazo. Conserva el diseño habitual de Blizzard mientras ves, lado a lado, los niveles de las misiones, etiquetas útiles, objetivos, recompensas y toda tu lista de misiones."
L["ENABLE_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Muestra el saludo de Pretty Wide Quest Log al iniciar sesión."
L["OPTIONS_FEATURES_HEADER"] = "Funciones"
L["ENABLE_QUEST_LOG_CLEANUP"] = "Activar registro de misiones ordenado"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Cambia el registro de misiones de Blizzard por el ancho, con el mapa al lado. Desactívalo para usar el registro de misiones de Blizzard. Surte efecto tras recargar."
L["ENABLE_QUALITY_OF_LIFE"] = "Activar mejoras de comodidad"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Activa la ventana de misiones del PNJ ordenada, tu propio ritmo al compartir misiones y los susurros cuando falla un envío. Desactívalo para recuperar la ventana de misiones del PNJ de Blizzard y compartir al ritmo predeterminado."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Activar registro de misiones ordenado surte efecto tras recargar, algo que se te ofrecerá al cerrar la interfaz de opciones."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia de registro de misiones tras recargar. ¿Recargar ahora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este accesorio."
L["FEEDBACK_HEADER"] = "Comentarios y soporte"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versión %s"

--------------------------------------------------------------------------------
-- Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG"] = "Registro de misiones"
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
L["ZONE_GAP"] = "Espacio sobre los nombres de zona"
L["ZONE_GAP_DESCRIPTION"] =
	"Añade un poco de espacio sobre cada nombre de zona. Útil si tus misiones están repartidas por muchas zonas."
L["QUEST_ORDER"] = "Orden de misiones"
L["QUEST_ORDER_DESCRIPTION"] = "Cambia el orden de las misiones dentro de cada zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Nivel, el más alto primero (predeterminado)"
L["SORT_LEVEL_LOWEST"] = "Nivel, el más bajo primero"
L["COMPLETED_FIRST"] = "Misiones completadas primero"
L["COMPLETED_FIRST_DESCRIPTION"] = "Sube al principio de su zona las misiones que ya puedes entregar."
L["SHOW_QUEST_LEVELS"] = "Mostrar niveles de misión"
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Pone el nivel y el tipo de cada misión delante de su nombre en la lista, como [40M] para una misión de mazmorra de nivel 40."
L["MARK_UNTRACKED"] = "Marcar misiones sin seguir"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Las misiones seguidas pierden su marca de verificación %s y las misiones sin seguir llevan un ojo %s en su lugar. Útil si sigues casi todo."
L["CLOSE_IN_COMBAT"] = "Cerrar al entrar en combate"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Cierra el registro de misiones cuando empieza un combate, para que nunca tape la acción."
L["WINDOW_SCALE"] = "Escala del registro de misiones"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Hace el registro de misiones más grande o más pequeño. El mapa de al lado crece y encoge con él."
L["MAP_SCALE"] = "Escala del mapa"
L["MAP_SCALE_DESCRIPTION"] =
	"Hace el mapa junto al registro de misiones más grande o más pequeño, además de la escala del registro de misiones."
L["RESET_WINDOW"] = "Restablecer tamaño y posición"
L["RESET_WINDOW_DESCRIPTION"] = "Devuelve el registro de misiones a su tamaño y posición predeterminados."
L["RESET_WINDOW_CONFIRM"] = "¿Restablecer el registro de misiones a su tamaño y posición predeterminados?"

--------------------------------------------------------------------------------
-- Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Mejoras de comodidad"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Pequeñas ayudas fuera del propio registro de misiones, para la ventana de misiones del PNJ y para compartir misiones con tu grupo."
L["QUEST_GIVERS_HEADER"] = "PNJ de misiones"
L["QUEST_GIVERS_DESCRIPTION"] = "La ventana que abre un PNJ de misiones, donde aceptas y entregas misiones."
L["GIVER_CLEANUP"] = "Activar ventana de misiones del PNJ ordenada"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Da al texto de la ventana de misiones del PNJ el mismo formato que el del registro de misiones, con los mismos títulos e interlineado, y muestra bajo la misión su ID, enlazado a Wowhead."
L["GIVER_LEVELS"] = "Mostrar niveles de misión"
L["GIVER_LEVELS_DESCRIPTION"] =
	"Añade las etiquetas de nivel del registro de misiones, como [40M], a la lista de misiones de un PNJ."
L["QUEST_SHARING_HEADER"] = "Compartir misiones"
L["QUEST_SHARING_DESCRIPTION"] =
	"Compartir misiones, en el menú de clic derecho de una zona del registro de misiones, ofrece a tu grupo una tras otra todas las misiones de esa zona que pueden aceptar. Estas opciones fijan el ritmo y lo que pasa cuando a un miembro del grupo se le escapa una."
L["SHARE_INTERVAL"] = "Segundos entre envíos"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Cuánto espera Compartir misiones, en el menú de clic derecho de una zona, entre una misión y la siguiente. Cuanto más largo, más tiempo tiene tu grupo para aceptar cada una."
L["SHARE_WHISPERS"] = "Susurrar cuando falle un envío"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Cuando un miembro del grupo está ocupado, demasiado lejos o tiene el registro de misiones lleno, le susurra qué misión intentaste compartir y le pide que te lo recuerde. No se envía nada si no puede aceptar la misión."
L["SHARE_WHISPER_EXAMPLE"] = "Ejemplo:"
L["SHARE_WHISPER_EXAMPLE_QUEST_NAME"] = "Nombre de la misión"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "M"
L["QUEST_SUFFIX_RAID"] = "B"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "ID de misión %d"
L["QUEST_CHAIN"] = "Cadena de misiones"
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

L["ZONE_MENU_HINT"] = "Clic derecho para más opciones"
L["SHARE_ZONE_QUESTS"] = "Compartir %d misiones"
L["SHARE_ZONE_QUEST"] = "Compartir 1 misión"
L["SHARE_ZONE_TOOLTIP"] =
	"Se pueden compartir %d de las %d misiones de esta zona. Se envían de una en una cada %d segundos."
L["CHAT_SHARING_ZONE_ONE"] = "Compartiendo 1 misión de %s."
L["CHAT_SHARING_ZONE"] = "Compartiendo %d misiones de %s, una cada %d segundos."
L["WHISPER_SHARE_BUSY"] =
	"Intenté compartir %s contigo, pero parecía que estabas con otra cosa. Si la quieres, avísame cuando estés libre y te la vuelvo a enviar."
L["WHISPER_SHARE_TOO_FAR"] =
	"Intenté compartir %s contigo, pero estábamos demasiado lejos. Si la quieres, avísame cuando estemos más cerca y te la vuelvo a enviar."
L["WHISPER_SHARE_LOG_FULL"] =
	"Intenté compartir %s contigo, pero tu registro de misiones estaba lleno. Si la quieres, avísame cuando hayas hecho sitio y te la vuelvo a enviar."
L["ABANDON_GRAY_QUESTS"] = "Abandonar misiones grises"
L["ABANDON_GRAY_NONE"] = "Esta zona no tiene misiones grises que abandonar."
L["ABANDON_GRAY_CONFIRM"] = "¿Abandonar estas %d misiones grises?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "¿Abandonar esta misión gris?"
L["CHAT_ABANDONED_GRAY"] = "Has abandonado %d misiones grises."
L["CHAT_ABANDONED_GRAY_ONE"] = "Has abandonado 1 misión gris."

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"El seguimiento de Questie no puede mostrar %s porque la misión no está en la base de datos de Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie todavía no puede seguir esta misión."
