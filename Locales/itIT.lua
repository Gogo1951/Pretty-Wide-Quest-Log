local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "itIT")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disattivare questo messaggio) si trovano in Opzioni > AddOn > Pretty Wide Quest Log. Ti piace l'add-on? Parlane a un amico! (="
L["CHAT_OPTIONS_IN_COMBAT"] =
	"Per precauzione, l'interfaccia delle opzioni non può essere aperta durante il combattimento."
L["CHAT_PREDECESSOR_LOADED"] =
	"Anche Wide Quest Log Plus è attivo e i due si contenderanno il registro delle missioni. Disattiva Wide Quest Log Plus nell'elenco degli AddOn, poi ricarica."

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Un registro delle missioni più grande e migliore, che ti dà più spazio per leggere e più informazioni a colpo d'occhio. Mantieni il layout di Blizzard che conosci e vedi fianco a fianco i livelli delle missioni, etichette utili, obiettivi, ricompense e l'intero elenco delle missioni."
L["ENABLE_WELCOME_MESSAGE"] = "Attiva messaggio di benvenuto"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra il saluto di Pretty Wide Quest Log quando accedi."
L["ENABLE_WIDE_QUEST_LOG"] = "Attiva Pretty Wide Quest Log per questo profilo"
L["ENABLE_WIDE_QUEST_LOG_DESCRIPTION"] =
	"Fa sì che il tasto del registro delle missioni, il pulsante del micromenu e i clic sulle missioni nel tracciamento degli obiettivi aprano questo registro delle missioni largo. Disattivalo per usare invece il registro delle missioni predefinito di Blizzard, integrato nella mappa del mondo. Ha effetto dopo un ricaricamento."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia registro delle missioni dopo un ricaricamento. Ricaricare ora?"
L["ZONE_ORDER"] = "Ordine delle zone"
L["ZONE_ORDER_DESCRIPTION"] = "Cambia l'ordine delle zone nell'elenco delle missioni."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Livello medio, prima il più alto (predefinito)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Livello medio, prima il più basso"
L["SORT_ALPHABETICAL"] = "Alfabetico"
L["ZONE_GAP"] = "Spazio sopra i nomi delle zone"
L["ZONE_GAP_DESCRIPTION"] =
	"Aggiunge un po' di spazio sopra ogni nome di zona. Utile se le tue missioni sono sparse in molte zone."
L["QUEST_ORDER"] = "Ordine delle missioni"
L["QUEST_ORDER_DESCRIPTION"] = "Cambia l'ordine delle missioni sotto ogni zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Livello, prima il più alto (predefinito)"
L["SORT_LEVEL_LOWEST"] = "Livello, prima il più basso"
L["MARK_UNTRACKED"] = "Segna le missioni non seguite"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Le missioni seguite perdono la spunta %s e quelle non seguite hanno invece un occhio %s. Utile se segui quasi tutto."
L["RESET_WINDOW"] = "Ripristina dimensioni e posizione"
L["RESET_WINDOW_DESCRIPTION"] = "Riporta il registro delle missioni alle dimensioni e alla posizione predefinite."
L["RESET_WINDOW_CONFIRM"] = "Ripristinare le dimensioni e la posizione predefinite del registro delle missioni?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/wide"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di questo add-on."
L["FEEDBACK_HEADER"] = "Feedback e supporto"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versione %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "S"
L["QUEST_SUFFIX_RAID"] = "I"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "ID missione %d"
L["EXPAND_ALL"] = "Espandi tutto"
L["COLLAPSE_ALL"] = "Comprimi tutto"
L["TRACK_ALL"] = "Segui tutte"
L["UNTRACK_ALL"] = "Non seguire nessuna"
L["HIDE_MAP"] = "Nascondi mappa"
L["RESIZE_TOOLTIP"] = "Trascina per ridimensionare il registro delle missioni"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Il tracker di Questie non può mostrare %s perché la missione manca dal database di Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie non può ancora seguire questa missione"
