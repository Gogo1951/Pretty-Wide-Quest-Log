local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "esES")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["CHAT_LOADED"] =
	"Versión %s. Puedes encontrar los ajustes (incluida la opción de desactivar este mensaje) en Opciones > Accesorios > Pretty Wide Quest Log. ¿Te gusta el accesorio? ¡Cuéntaselo a un amigo! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por seguridad, la interfaz de opciones no se puede abrir durante el combate."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus también está activado y los dos se pelearán por el registro de misiones. Desactiva Wide Quest Log Plus en la lista de accesorios y luego recarga."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Un registro de misiones más grande y mejor que te da más espacio para leer y más información de un vistazo. Conserva el diseño habitual de Blizzard mientras ves, lado a lado, los niveles de las misiones, etiquetas útiles, objetivos, recompensas y toda tu lista de misiones."
L["ENABLE_WELCOME_MESSAGE"] = "Activar mensaje de bienvenida"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Muestra el saludo de Pretty Wide Quest Log al iniciar sesión."
L["ENABLE_WIDE_QUEST_LOG"] = "Activar Pretty Wide Quest Log para este perfil"
L["ENABLE_WIDE_QUEST_LOG_DESCRIPTION"] =
	"Hace que la tecla del registro de misiones, el botón del micromenú y los clics en misiones del seguimiento de objetivos abran este registro de misiones ancho. Desactívalo para usar en su lugar el registro de misiones predeterminado de Blizzard, integrado en el mapa del mundo. Surte efecto tras recargar."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia de registro de misiones tras recargar. ¿Recargar ahora?"
L["ZONE_ORDER"] = "Orden de zonas"
L["ZONE_ORDER_DESCRIPTION"] = "Cambia el orden de las zonas en la lista de misiones."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Nivel medio, el más alto primero (predeterminado)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Nivel medio, el más bajo primero"
L["SORT_ALPHABETICAL"] = "Alfabético"
L["ZONE_GAP"] = "Espacio sobre los nombres de zona"
L["ZONE_GAP_DESCRIPTION"] =
	"Añade un poco de espacio sobre cada nombre de zona. Útil si tus misiones están repartidas por muchas zonas."
L["QUEST_ORDER"] = "Orden de misiones"
L["QUEST_ORDER_DESCRIPTION"] = "Cambia el orden de las misiones dentro de cada zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Nivel, el más alto primero (predeterminado)"
L["SORT_LEVEL_LOWEST"] = "Nivel, el más bajo primero"
L["MARK_UNTRACKED"] = "Marcar misiones sin seguir"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Las misiones seguidas pierden su marca de verificación %s y las misiones sin seguir llevan un ojo %s en su lugar. Útil si sigues casi todo."
L["RESET_WINDOW"] = "Restablecer tamaño y posición"
L["RESET_WINDOW_DESCRIPTION"] = "Devuelve el registro de misiones a su tamaño y posición predeterminados."
L["RESET_WINDOW_CONFIRM"] = "¿Restablecer el registro de misiones a su tamaño y posición predeterminados?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/wide"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este accesorio."
L["FEEDBACK_HEADER"] = "Comentarios y soporte"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versión %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "M"
L["QUEST_SUFFIX_RAID"] = "B"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "ID de misión %d"
L["EXPAND_ALL"] = "Expandir todo"
L["COLLAPSE_ALL"] = "Contraer todo"
L["TRACK_ALL"] = "Seguir todas"
L["UNTRACK_ALL"] = "Dejar de seguir todas"
L["HIDE_MAP"] = "Ocultar mapa"
L["RESIZE_TOOLTIP"] = "Arrastra para cambiar el tamaño del registro de misiones"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"El seguimiento de Questie no puede mostrar %s porque la misión no está en la base de datos de Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie todavía no puede seguir esta misión"
