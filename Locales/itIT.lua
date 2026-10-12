local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "itIT")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disattivare questo messaggio) si trovano in Opzioni > AddOn > Pretty Wide Quest Log. Ti piace l'add-on? Parlane a un amico! (="
L["CHAT_OPTIONS_IN_COMBAT"] =
	"Per precauzione, l'interfaccia delle opzioni non può essere aperta durante il combattimento."
L["CHAT_QUESTIE_MISSING"] =
	"Gran parte di questo add-on si basa sui dati di Questie. Senza Questie avrai meno funzioni a disposizione."
L["CHAT_PREDECESSOR_LOADED"] =
	"Anche Wide Quest Log Plus è attivo e i due si contenderanno il registro delle missioni. Disattiva Wide Quest Log Plus nell'elenco degli AddOn, poi ricarica."

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Un registro delle missioni largo, ridimensionabile e a doppio pannello, con livelli delle missioni, etichette per spedizioni ed élite, ricompense, catene di missioni e una mappa per ogni missione. Condividi le missioni con il tuo gruppo e annuncia in automatico le missioni delle spedizioni. Funziona con Questie, VoiceOver ed ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Attiva messaggio di benvenuto"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra il saluto di Pretty Wide Quest Log quando accedi."
L["OPTIONS_FEATURES_HEADER"] = "Funzioni"
L["ENABLE_QUEST_LOG_CLEANUP"] = "Attiva registro delle missioni ordinato"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Sostituisce il registro delle missioni di Blizzard con quello largo, con la mappa accanto. Disattivalo per usare il registro delle missioni di Blizzard. Ha effetto dopo un ricaricamento."
L["ENABLE_QUALITY_OF_LIFE"] = "Attiva funzioni di comodità"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Attiva la finestra del datore di missioni ordinata, il tuo ritmo per condividere le missioni, i sussurri quando una condivisione non riesce e l'annuncio e la condivisione delle missioni delle spedizioni. Disattivalo per riavere la finestra del datore di missioni di Blizzard e condividere al ritmo predefinito."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Attiva registro delle missioni ordinato ha effetto dopo un ricaricamento, che ti verrà proposto alla chiusura dell'interfaccia delle opzioni."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia registro delle missioni dopo un ricaricamento. Ricaricare ora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di questo add-on."
L["FEEDBACK_HEADER"] = "Feedback e supporto"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versione %s"

--------------------------------------------------------------------------------
-- Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG"] = "Registro delle missioni"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Sostituisce il registro delle missioni di Blizzard con uno largo: le tue missioni elencate per zona, con accanto i dettagli della missione selezionata e la sua mappa."
L["QUEST_LOG_LAYOUT_HEADER"] = "Layout del registro delle missioni"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"Ordina le missioni come preferisci, scegli cosa mostra ogni riga e adatta le dimensioni della finestra e della mappa al tuo schermo."
L["ZONE_ORDER"] = "Ordine delle zone"
L["ZONE_ORDER_DESCRIPTION"] = "Cambia l'ordine delle zone nell'elenco delle missioni."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Livello medio, prima il più alto (predefinito)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Livello medio, prima il più basso"
L["SORT_ALPHABETICAL"] = "Alfabetico"
L["CURRENT_ZONE_FIRST"] = "Mostra prima la zona attuale"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Mette in cima all'elenco la zona in cui ti trovi, qualunque sia l'ordine delle zone."
L["ZONE_GAP"] = "Spazio sopra i nomi delle zone"
L["ZONE_GAP_DESCRIPTION"] =
	"Aggiunge un po' di spazio sopra ogni nome di zona. Utile se le tue missioni sono sparse in molte zone."
L["QUEST_ORDER"] = "Ordine delle missioni"
L["QUEST_ORDER_DESCRIPTION"] = "Cambia l'ordine delle missioni sotto ogni zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Livello, prima il più alto (predefinito)"
L["SORT_LEVEL_LOWEST"] = "Livello, prima il più basso"
L["COMPLETED_FIRST"] = "Mostra prima le missioni completate"
L["COMPLETED_FIRST_DESCRIPTION"] = "Sposta in cima alla loro zona le missioni pronte da consegnare."
L["SHOW_QUEST_LEVELS"] = "Mostra i livelli delle missioni"
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Mette il livello e il tipo di ogni missione davanti al suo nome nell'elenco, come [40S] per una missione da spedizione di livello 40."
L["MARK_UNTRACKED"] = "Segna le missioni non seguite"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Le missioni seguite perdono la spunta %s e quelle non seguite hanno invece un occhio %s. Utile se segui quasi tutto."
L["CLOSE_IN_COMBAT"] = "Chiudi all'inizio del combattimento"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Chiude il registro delle missioni quando inizia un combattimento, così non copre mai l'azione."
L["WINDOW_SCALE"] = "Scala del registro delle missioni"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Ingrandisce o rimpicciolisce il registro delle missioni. La mappa accanto cresce e si riduce insieme a lui."
L["MAP_SCALE"] = "Scala della mappa"
L["MAP_SCALE_DESCRIPTION"] =
	"Ingrandisce o rimpicciolisce la mappa accanto al registro delle missioni, in aggiunta alla scala del registro delle missioni."
L["RESET_WINDOW"] = "Ripristina dimensioni e posizione"
L["RESET_WINDOW_DESCRIPTION"] = "Riporta il registro delle missioni alle dimensioni e alla posizione predefinite."
L["RESET_WINDOW_CONFIRM"] = "Ripristinare le dimensioni e la posizione predefinite del registro delle missioni?"

--------------------------------------------------------------------------------
-- Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Funzioni di comodità"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Piccoli aiuti al di fuori del registro delle missioni, per la finestra del datore di missioni, per condividere le missioni con il tuo gruppo e per le spedizioni."
L["QUEST_GIVERS_HEADER"] = "Datori di missioni"
L["QUEST_GIVERS_DESCRIPTION"] = "La finestra che apre un datore di missioni, dove accetti e consegni le missioni."
L["GIVER_CLEANUP"] = "Finestra del datore di missioni ordinata"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Imposta il testo della finestra del datore di missioni come quello del registro delle missioni, con gli stessi titoli e la stessa interlinea, e mostra sotto la missione il suo ID, con un link a Wowhead."
L["GIVER_LEVELS"] = "Mostra i livelli delle missioni"
L["GIVER_LEVELS_DESCRIPTION"] =
	"Aggiunge le etichette di livello del registro delle missioni, come [40S], all'elenco delle missioni di un datore di missioni."
L["QUEST_SHARING_HEADER"] = "Condivisione delle missioni"
L["QUEST_SHARING_DESCRIPTION"] =
	"Condividi missioni, nel menu del clic destro su una zona del registro delle missioni, offre al tuo gruppo, una dopo l'altra, tutte le missioni di quella zona che possono accettare. Queste opzioni regolano il ritmo e cosa succede quando un membro del gruppo ne perde una."
L["SHARE_INTERVAL"] = "Secondi tra le condivisioni"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Quanto attendere tra una missione condivisa e la successiva, per Condividi missioni e per la condivisione delle missioni delle spedizioni. Più è lungo, più tempo ha il tuo gruppo per accettare ciascuna."
L["SHARE_WHISPERS"] = "Sussurra quando una condivisione non riesce"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quando un membro del gruppo è occupato, troppo lontano o ha il registro delle missioni pieno, gli sussurra quale missione hai provato a condividere e gli chiede di ricordartelo. Non viene inviato nulla se non può accettare la missione."
L["OPTIONS_EXAMPLE"] = "Esempio:"
L["OPTIONS_EXAMPLE_QUEST_NAME"] = "Nome della missione"
L["DUNGEON_QUESTS_HEADER"] = "Missioni delle spedizioni"
L["DUNGEON_QUESTS_DESCRIPTION"] =
	"Entrano in azione quando entri in una spedizione o in un'incursione con il tuo gruppo, una volta per gruppo per ogni spedizione. Una missione conta se è elencata sotto la spedizione nel tuo registro delle missioni o, con Questie, se uno dei suoi obiettivi si trova al suo interno, così rientrano anche le missioni di classe."
L["DUNGEON_ANNOUNCE"] = "Annuncio automatico delle missioni delle spedizioni"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Dice al tuo gruppo quali delle tue missioni restano da fare nella spedizione in cui sei appena entrato, così tutti sanno cosa tenere d'occhio. Le missioni pronte da consegnare vengono escluse."
L["DUNGEON_SHARE"] = "Condivisione automatica delle missioni delle spedizioni"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Condivide ogni missione della spedizione che il gioco ti permette di condividere, al ritmo impostato in Condivisione delle missioni. Chi si perde una condivisione riceve il solito sussurro, così può richiederla. Condivide di nuovo ogni volta che qualcuno entra o esce dal gruppo."

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "S"
L["QUEST_SUFFIX_RAID"] = "I"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "ID missione %d"
L["QUEST_CHAIN"] = "Catena di missioni"
L["DAILY_RESET"] = "Le missioni giornaliere si azzerano tra %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Clicca per ottenere un link a Wowhead."
L["WOWHEAD_LINK_COPY"] = "Premi Ctrl+C (Cmd+C su Mac) per copiare il link a Wowhead."
L["EXPAND_ALL"] = "Espandi tutto"
L["COLLAPSE_ALL"] = "Comprimi tutto"
L["TRACK_ALL"] = "Segui tutte"
L["UNTRACK_ALL"] = "Non seguire nessuna"
L["HIDE_MAP"] = "Nascondi mappa"
L["TURN_IN_XP"] = "%s PE"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "Consegna: %s"
L["TURN_IN_TOOLTIP"] = "Pronta da consegnare"
L["RESIZE_TOOLTIP"] = "Trascina per ridimensionare il registro delle missioni."

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_HINT"] = "Clic destro per altre opzioni"
L["SHARE_ZONE_QUESTS"] = "Condividi %d missioni"
L["SHARE_ZONE_QUEST"] = "Condividi 1 missione"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Offre al tuo gruppo le missioni di questa zona che il gioco ti permette di condividere, una ogni %d secondi."
L["SHARE_ZONE_QUEST_TOOLTIP"] =
	"Offre al tuo gruppo l'unica missione di questa zona che il gioco ti permette di condividere."
L["CHAT_SHARING_ZONE_ONE"] = "Condivisione di 1 missione da %s."
L["CHAT_SHARING_ZONE"] = "Condivisione di %d missioni da %s, una ogni %d secondi."
L["ABANDON_GRAY_QUESTS"] = "Abbandona le missioni grigie"
L["ABANDON_GRAY_NONE"] = "Questa zona non ha missioni grigie da abbandonare."
L["ABANDON_GRAY_CONFIRM"] = "Abbandonare queste %d missioni grigie?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "Abbandonare questa missione grigia?"
L["CHAT_ABANDONED_GRAY"] = "%d missioni grigie abbandonate."
L["CHAT_ABANDONED_GRAY_ONE"] = "1 missione grigia abbandonata."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_BUSY"] =
	"Ho provato a condividere %s con te, ma mi sa che avevi da fare. Se ti interessa, fammi un fischio quando hai un momento e te la rimando."
L["WHISPER_SHARE_TOO_FAR"] =
	"Ho provato a condividere %s con te, ma eravamo troppo lontani. Se ti interessa, fammi un fischio quando siamo più vicini e te la rimando."
L["WHISPER_SHARE_LOG_FULL"] =
	"Ho provato a condividere %s con te, ma il tuo registro delle missioni era pieno. Se ti interessa, fammi un fischio quando hai fatto spazio e te la rimando."
L["DUNGEON_QUESTS_ANNOUNCE"] = "Ho %d missioni da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Ho 1 missione da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_MORE"] = "%s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Il tracker di Questie non può mostrare %s perché la missione manca dal database di Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie non può ancora seguire questa missione."
