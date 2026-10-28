local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "itIT")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT_NAME"] = "PWQL"
L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disattivare questo messaggio) si trovano in Opzioni > AddOn > Pretty Wide Quest Log. Ti piace questo add-on? Parlane a un amico, aggiungilo ai preferiti su CurseForge o mettigli una Star su GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] =
	"Per precauzione, l'interfaccia delle opzioni non può essere aperta durante il combattimento."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Senza Questie, la mappa delle missioni mostra meno cose, e le catene di missioni e il totale di Consegna restano nascosti. Attiva Questie nell'elenco degli AddOn per vederli."
L["CHAT_PREDECESSOR_LOADED"] =
	"Anche Wide Quest Log Plus è attivo e i due si contenderanno il registro delle missioni. Disattiva Wide Quest Log Plus nell'elenco degli AddOn, poi ricarica."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Un registro delle missioni largo, ridimensionabile e a doppio pannello, con livelli delle missioni, etichette per spedizioni ed élite, ricompense, catene di missioni e una mappa per ogni missione. Condividi le missioni con il tuo gruppo e annuncia in automatico le missioni delle spedizioni. Funziona con Questie, VoiceOver ed ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Attiva messaggio di benvenuto"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra il messaggio di benvenuto di Pretty Wide Quest Log quando accedi."
L["OPTIONS_FEATURES_HEADER"] = "Funzioni"
L["ENABLE_WIDE_QUEST_LOG"] = "Attiva registro delle missioni largo"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Sostituisce il registro delle missioni di Blizzard con quello largo, con la mappa accanto. Ha effetto dopo un ricaricamento."
L["ENABLE_QUALITY_OF_LIFE"] = "Attiva funzioni di comodità"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Riordina la finestra del datore di missioni e aiuta il tuo gruppo a prendere le tue missioni: ritmo di condivisione, sussurri quando una condivisione non raggiunge qualcuno, e annuncio e condivisione delle missioni delle spedizioni. Condividi missioni di una zona funziona in ogni caso."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Attiva registro delle missioni largo ha effetto dopo un ricaricamento, che ti verrà proposto alla chiusura dell'interfaccia delle opzioni."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia registro delle missioni dopo un ricaricamento. Ricaricare ora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di questo add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

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
L["ZONE_GAP"] = "Aggiungi spazio sopra i nomi delle zone"
L["ZONE_GAP_DESCRIPTION"] =
	"Aggiunge un po' di spazio sopra ogni nome di zona. Utile se le tue missioni sono sparse in molte zone."
L["QUEST_ORDER"] = "Ordine delle missioni"
L["QUEST_ORDER_DESCRIPTION"] = "Cambia l'ordine delle missioni sotto ogni zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Livello, prima il più alto (predefinito)"
L["SORT_LEVEL_LOWEST"] = "Livello, prima il più basso"
L["COMPLETED_FIRST"] = "Mostra prima le missioni completate"
L["COMPLETED_FIRST_DESCRIPTION"] = "Sposta in cima alla loro zona le missioni pronte da consegnare."
L["SHOW_QUEST_LEVELS"] = "Mostra i livelli delle missioni"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Mette il livello e il tipo di ogni missione davanti al suo nome nell'elenco, come %s per una missione da spedizione di livello 40."
L["MARK_UNTRACKED"] = "Segna le missioni non seguite"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Le missioni seguite perdono la spunta %s e quelle non seguite hanno invece un occhio %s. Utile se segui quasi tutto."
L["CLOSE_IN_COMBAT"] = "Chiudi all'inizio del combattimento"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Chiude il registro delle missioni quando inizia un combattimento, così non copre mai l'azione."
L["SHOW_OBJECTIVE_AREAS"] = "Mostra le aree degli obiettivi"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Ombreggia sulla mappa accanto al registro delle missioni i punti in cui si trovano i nemici e gli oggetti di ogni obiettivo, con un'icona per area invece di una su ogni punto di comparsa. Richiede Questie."
L["NEEDS_QUESTIE_HINT"] = "Attiva Questie per usare questa opzione."
L["WINDOW_SCALE"] = "Scala del registro delle missioni"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Ingrandisce o rimpicciolisce il registro delle missioni. La mappa accanto cresce e si riduce insieme a lui."
L["MAP_SCALE"] = "Scala della mappa"
L["MAP_SCALE_DESCRIPTION"] =
	"Ingrandisce o rimpicciolisce la mappa accanto al registro delle missioni, in aggiunta alla scala del registro delle missioni."
L["RESET_WINDOW_BUTTON"] = "Ripristina finestra"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Riporta l'altezza e la scala del registro delle missioni, e la scala della mappa, ai valori predefiniti."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Riporta l'altezza e la scala del registro delle missioni, e la scala della mappa, ai valori predefiniti, e riporta la finestra nella sua posizione iniziale."
L["RESET_WINDOW_SCALE_CONFIRM"] = "Ripristinare l'altezza e la scala del registro delle missioni?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Ripristinare l'altezza e la scala del registro delle missioni, e la sua posizione sullo schermo?"

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Funzioni di comodità"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Piccoli aiuti al di fuori del registro delle missioni stesso: per la finestra del datore di missioni, per condividere le missioni con il tuo gruppo e per le spedizioni."
L["QUEST_GIVERS_HEADER"] = "Datori di missioni"
L["QUEST_GIVERS_DESCRIPTION"] = "La finestra che apre un datore di missioni, dove accetti e consegni le missioni."
L["GIVER_CLEANUP"] = "Finestra del datore di missioni ordinata"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Impagina il testo della finestra del datore di missioni come quello del registro delle missioni, con gli stessi titoli e la stessa interlinea, e mostra sotto la missione il suo ID, con un link a Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Aggiunge le etichette di livello del registro delle missioni, come %s, all'elenco delle missioni di un datore di missioni."
L["QUEST_SHARING_HEADER"] = "Condivisione delle missioni"
L["QUEST_SHARING_INTRO"] =
	"Fai clic destro sul nome di una zona nel registro delle missioni per offrire al tuo gruppo, una dopo l'altra, tutte le sue missioni che puoi condividere. Queste opzioni regolano il ritmo e cosa succede quando qualcuno ne perde una."
L["SHARE_INTERVAL"] = "Secondi tra le condivisioni"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Quanto attendere tra una missione condivisa e la successiva, per Condividi missioni e per la condivisione delle missioni delle spedizioni. Più è lungo, più tempo ha il tuo gruppo per accettare ciascuna."
L["SHARE_WHISPERS"] = "Sussurra quando una condivisione non riesce"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quando un membro del gruppo è occupato, troppo lontano o ha il registro delle missioni pieno, gli sussurra quale missione hai provato a condividere e gli chiede di ricordartelo. Non viene inviato nulla se non ha i requisiti per la missione, ce l'ha già o l'ha già completata."
L["SAMPLE_EXAMPLE"] = "Esempio: %s"
L["SAMPLE_QUEST_LOADING"] = "Caricamento ID missione: %d"
L["DUNGEON_QUESTS_HEADER"] = "Missioni delle spedizioni"
L["DUNGEON_QUESTS_INTRO"] =
	"Quando entri in una spedizione o in un'incursione con il tuo gruppo, le tue missioni per quel luogo vengono annunciate e condivise, una volta per gruppo per ogni spedizione. Con Questie contano anche le missioni con obiettivi al suo interno, comprese quelle di classe."
L["DUNGEON_ANNOUNCE"] = "Annuncio automatico delle missioni delle spedizioni"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Dice al tuo gruppo quali delle tue missioni restano da fare nella spedizione in cui sei appena entrato, così tutti sanno cosa tenere d'occhio. Le missioni pronte da consegnare vengono escluse."
L["DUNGEON_SHARE"] = "Condivisione automatica delle missioni delle spedizioni"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Condivide ogni missione della spedizione che il gioco ti permette di condividere, al ritmo impostato in Condivisione delle missioni. Con Sussurra quando una condivisione non riesce attivo, chi si perde una condivisione riceve un sussurro, così può richiederla. Condivide di nuovo ogni volta che qualcuno entra o esce dal gruppo."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Aiuta Pretty Wide Quest Log a salire di livello"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Questo add-on è stato creato da giocatori che amano questo gioco e vogliono renderlo il più divertente possibile per tutti. Non chiederemo mai donazioni. La vera soddisfazione è sapere che il nostro lavoro rende il gioco un po' migliore per te. Se è così, ci farebbe piacere saperlo!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Ecco alcuni modi in cui puoi aiutarci a raggiungere più giocatori."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Condividi un feedback: Hai trovato un bug o hai un'idea? Faccelo sapere su Discord. Il tuo feedback ci aiuta a migliorare l'add-on, e le pull request sono sempre benvenute."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Parlane a un amico: Conosci qualcuno a cui potrebbe piacere questo add-on? Parlagliene. Il passaparola aiuta più giocatori a scoprire ottimi add-on."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Aggiungi ai preferiti su CurseForge: Apri il link di CurseForge qui sotto, accedi e clicca sulla stella sotto il pulsante di download. I preferiti aiutano più giocatori a scoprire l'add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Metti una Star su GitHub: Apri il link di GitHub qui sotto, accedi e clicca su Star in alto a destra. Le stelle aiutano il progetto a ottenere più strumenti gratuiti per sviluppatori."
L["OPTIONS_LEVEL_UP_THANKS"] = "Grazie per aver scelto Pretty Wide Quest Log!"
L["OPTIONS_FEEDBACK"] = "Feedback e supporto"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Link per feedback e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Per copiare un link, clicca nel suo riquadro, poi premi Ctrl+A e Ctrl+C."
L["OPTIONS_VERSION"] = "Versione %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "S"
L["QUEST_SUFFIX_RAID"] = "I"
L["QUEST_SUFFIX_PVP"] = "P"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "spedizione"
L["QUEST_TYPE_RAID"] = "incursione"
L["QUEST_TYPE_GROUP"] = "gruppo"
L["QUEST_TYPE_ELITE"] = "élite"
L["QUEST_TYPE_PVP"] = "PvP"
L["QUEST_LEVEL_LEGEND"] = "Lettere dopo il livello: %s."
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_LEVEL_LEGEND_SEPARATOR"] = ", "
L["QUEST_ID"] = "ID missione %d"
L["QUEST_CHAIN_PROGRESS"] = "Catena di missioni (%d di %d)"
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

L["ZONE_MENU_ACTIONS_HINT"] = "Clic destro per condividere le missioni o abbandonare quelle grigie"
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

L["WHISPER_SHARE_FAILED"] =
	"Ho provato a condividere %s con te, ma non è andata. Se ti interessa la missione, fammi un fischio quando puoi e te la ricondivido"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Lo stesso vale per %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Ho %d missioni da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Ho 1 missione da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Altre missioni da fare qui: %s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Il tracker di Questie non può mostrare %s perché la missione manca dal database di Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie non può ancora seguire questa missione."
