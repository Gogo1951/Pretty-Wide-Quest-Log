local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "itIT")
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
	"Registro delle missioni largo con percorso delle missioni e freccia delle missioni. Tu scegli le missioni, noi ti aiutiamo con un percorso pulito per completarle in fretta. Livelli delle missioni, etichette, ricompense, catene di missioni, una mappa delle missioni e condivisione delle missioni con il gruppo. Funziona con Questie, Spoken, VoiceOver ed ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Attiva messaggio di benvenuto"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra il messaggio di benvenuto di Pretty Wide Quest Log quando accedi."
L["OPTIONS_FEATURES_HEADER"] = "Funzioni"
L["ENABLE_WIDE_QUEST_LOG"] = "Attiva registro delle missioni largo"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Sostituisce il registro delle missioni di Blizzard con quello largo, con la mappa accanto. Ha effetto dopo un ricaricamento."
L["ENABLE_QUALITY_OF_LIFE"] = "Attiva funzioni di comodità"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Riordina la finestra del datore di missioni e aiuta il tuo gruppo a prendere le tue missioni: ritmo di condivisione, sussurri quando una condivisione non raggiunge qualcuno, e annuncio e condivisione delle missioni delle spedizioni. Il pulsante Condividi missioni di una zona nel registro delle missioni funziona anche con questa opzione disattivata."
L["ENABLE_ROUTES_MAP"] = "Attiva percorsi sulla mappa della zona"
L["FEATURE_ROUTES_MAP_DESCRIPTION"] =
	"Traccia sulla mappa della zona un percorso tra i tuoi obiettivi delle missioni e le consegne, partendo dal più vicino, con puntini in movimento tra gli indicatori."
L["ENABLE_QUEST_ARROW"] = "Attiva Freccia delle missioni"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Mostra sullo schermo una freccia, la Freccia delle missioni, che punta al prossimo punto di passaggio del percorso, con le missioni e gli obiettivi da completare lì. Per impostazione predefinita si nasconde nei gruppi da incursione e nelle istanze."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Attiva registro delle missioni largo ha effetto dopo un ricaricamento, che ti verrà proposto alla chiusura dell'interfaccia delle opzioni."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia registro delle missioni dopo un ricaricamento. Ricaricare ora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di questo add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Registro delle missioni largo"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Sostituisce il registro delle missioni di Blizzard con uno largo: le tue missioni elencate per zona, con accanto i dettagli della missione selezionata e la sua mappa."
L["QUEST_LOG_SORTING_HEADER"] = "Ordinamento"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Scegli l'ordine delle tue zone e delle missioni sotto di esse."
L["QUEST_LOG_ROWS_HEADER"] = "Righe delle missioni"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Scegli cosa mostra ogni riga."
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "Finestra e mappa"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"Adatta le dimensioni della finestra e della mappa al tuo schermo e scegli come si comportano."
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
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Le missioni seguite perdono la spunta %s e quelle non seguite hanno invece un occhio %s. Utile se segui quasi tutto."
L["CLOSE_IN_COMBAT"] = "Chiudi all'inizio del combattimento"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Chiude il registro delle missioni quando inizia un combattimento, così non copre mai l'azione."
L["SHOW_OBJECTIVE_AREAS"] = "Mostra le aree degli obiettivi"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Ombreggia sulla mappa accanto al registro delle missioni i punti in cui si trovano i nemici e gli oggetti di ogni obiettivo, con un'icona per area invece di una su ogni punto di comparsa."
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
L["RESET_WINDOW_SCALE_CONFIRM"] =
	"Ripristinare l'altezza e la scala del registro delle missioni, e la scala della mappa?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Ripristinare l'altezza e la scala del registro delle missioni, la scala della mappa e la posizione della finestra sullo schermo?"
L["HANDY_CLICKS_HEADER"] = "Clic utili"
L["HANDY_CLICK_TRACK"] = "Maiusc-clic su una missione"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "Seguila o smetti di seguirla."
L["HANDY_CLICK_MENU"] = "Clic destro su una missione"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "Seguila, condividila o abbandonala."
L["HANDY_CLICK_ID"] = "Clic su un ID missione"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Ottieni il suo link a Wowhead."

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
	"Passa il mouse sul nome di una zona nel registro delle missioni e fai clic su Condividi missioni per offrire al tuo gruppo, una dopo l'altra, tutte le sue missioni che puoi condividere. Queste opzioni regolano il ritmo e cosa succede quando qualcuno ne perde una."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"Il pulsante Condividi missioni sul nome di una zona richiede Attiva registro delle missioni largo. La condivisione delle missioni delle spedizioni funziona anche senza."
L["SHARE_INTERVAL"] = "Secondi tra le condivisioni"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Quanto attendere tra una missione condivisa e la successiva, quando condividi le missioni di una zona o di una spedizione. Più è lungo, più tempo ha il tuo gruppo per accettare ciascuna."
L["SHARE_WHISPERS"] = "Sussurra quando una condivisione non riesce"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quando un membro del gruppo è occupato, troppo lontano o ha il registro delle missioni pieno, gli sussurra quale missione hai provato a condividere e gli chiede di ricordartelo. Non viene inviato nulla se non ha i requisiti per la missione, ce l'ha già o l'ha già completata."
L["SAMPLE_EXAMPLE"] = "Esempio: %s"
L["SAMPLE_QUEST_LOADING"] = "Caricamento ID missione: %d"
L["DUNGEON_QUESTS_HEADER"] = "Missioni delle spedizioni"
L["DUNGEON_QUESTS_INTRO"] =
	"Quando entri in una spedizione con il tuo gruppo, le tue missioni per quel luogo vengono annunciate e condivise appena tutti sono a portata (subito su WoW Forever), e mai due volte allo stesso gruppo. Con Questie contano anche le missioni con obiettivi al suo interno, comprese quelle di classe. In un gruppo da incursione non succede nulla."
L["DUNGEON_ANNOUNCE"] = "Annuncio automatico delle missioni delle spedizioni"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Dice al tuo gruppo quali delle tue missioni restano da fare nella spedizione in cui sei appena entrato, così tutti sanno cosa tenere d'occhio. Le missioni pronte da consegnare vengono escluse."
L["DUNGEON_SHARE"] = "Condivisione automatica delle missioni delle spedizioni"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Condivide ogni missione della spedizione che il gioco ti permette di condividere, al ritmo impostato in Condivisione delle missioni, appena tutti sono a portata (o dopo un minuto; subito su WoW Forever). Ogni membro del gruppo le riceve una volta per spedizione, quindi le riceve anche chi entra dopo, e uscire e rientrare non condivide nulla. Con Sussurra quando una condivisione non riesce attivo, chi si perde una condivisione riceve un sussurro, così può richiederla."

--------------------------------------------------------------------------------
-- Options: Routes on Zone Map Panel
--------------------------------------------------------------------------------

L["TAB_ROUTES_MAP"] = "Percorsi sulla mappa della zona"
L["TAB_ROUTES_MAP_DESCRIPTION"] =
	"Un percorso tra i tuoi obiettivi delle missioni e le consegne sulla mappa della zona, nell'ordine in cui farli, a partire da dove ti trovi."
L["ROUTES_MAP_HEADER"] = "Mappa della zona"
L["FULL_SIZE_MAP"] = "Apri la mappa della zona ingrandita"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Apre la mappa della zona ingrandita, come fa il suo pulsante di ingrandimento, così il percorso ha spazio. Se rimpicciolisci la mappa, la volta dopo si apre di nuovo ingrandita."
L["HIDE_QUESTIE_ICONS"] = "Nascondi le icone di Questie sul percorso"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Nasconde le icone di Questie sulla mappa per ciò che è sul percorso, così gli indicatori le sostituiscono. Passa il mouse su un indicatore per vederne le icone."
L["ROUTES_MARKERS_HEADER"] = "Indicatori"
L["MARKER_SIZE"] = "Dimensione degli indicatori"
L["MARKER_SIZE_DESCRIPTION"] = "Quanto sono grandi gli indicatori del percorso sulla mappa della zona."
L["MARKER_SIZE_SMALL"] = "Piccola"
L["MARKER_SIZE_MEDIUM"] = "Media"
L["MARKER_SIZE_LARGE"] = "Grande"
L["MARKER_SIZE_HUGE"] = "Enorme"
L["ROUTES_LINE_HEADER"] = "Linea del percorso"
L["SHOW_ROUTE_LINE"] = "Mostra la linea del percorso"
L["SHOW_ROUTE_LINE_DESCRIPTION"] =
	"Traccia puntini in movimento da te a ogni indicatore, uno alla volta. Se disattivata, mostra solo gli indicatori."
L["LINE_SPEED"] = "Velocità della linea"
L["LINE_SPEED_DESCRIPTION"] = "Quanto velocemente i puntini avanzano verso il prossimo indicatore."
L["LINE_SPEED_STILL"] = "Ferma"
L["LINE_SPEED_SLOW"] = "Lenta"
L["LINE_SPEED_NORMAL"] = "Normale"
L["LINE_SPEED_FAST"] = "Veloce"
L["LINE_OPACITY"] = "Opacità della linea"
L["LINE_OPACITY_DESCRIPTION"] = "Quanto sono pieni i puntini; più è bassa, più la mappa traspare."
L["ROUTES_PARTY_HEADER"] = "Gruppo"
L["PARTY_QUESTS"] = "Includi le missioni dei membri del gruppo"
L["PARTY_QUESTS_DESCRIPTION"] =
	"In gruppo, il percorso e la Freccia delle missioni includono anche le missioni che i membri del tuo gruppo hanno e tu no, mostrate come le tue. Serve Questie da entrambe le parti per condividerle. Le loro missioni delle spedizioni restano escluse, come le tue."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Freccia delle missioni"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Una freccia sullo schermo che punta al prossimo punto di passaggio del percorso, con le missioni e gli obiettivi da completare lì. Facci clic destro per aggirare l'obiettivo attuale; clic centrale per ripristinare tutti i percorsi."
L["QUEST_ARROW_HEADER"] = "Freccia"
L["ARROW_SIZE"] = "Dimensione della freccia"
L["ARROW_SIZE_DESCRIPTION"] = "Quanto è grande la Freccia delle missioni, con il testo sotto di essa."
L["ARROW_CYCLE"] = "Ciclo occhio e freccia (secondi)"
L["ARROW_CYCLE_DESCRIPTION"] =
	"In un'area dell'obiettivo, la Freccia delle missioni si alterna: l'occhio, che elenca gli obiettivi intorno a te, poi la freccia, che punta al prossimo punto di passaggio. Ognuno occupa metà di questo tempo."
L["LOCK_ARROW"] = "Blocca la Freccia delle missioni"
L["LOCK_ARROW_DESCRIPTION"] = "Tiene la Freccia delle missioni dov'è, così trascinarla non ha effetto."
L["RESET_ARROW"] = "Posizione della freccia"
L["RESET_ARROW_BUTTON"] = "Ripristina"
L["RESET_ARROW_DESCRIPTION"] =
	"Riporta la Freccia delle missioni alla posizione iniziale, in alto al centro dello schermo."
L["QUEST_ARROW_TEXT_HEADER"] = "Sotto la freccia"
L["SHOW_DISTANCE"] = "Mostra distanza"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'Mostra a quanti metri si trova il prossimo punto di passaggio. "%s" e "%s" vengono mostrati comunque.'
L["SHOW_ARROW_QUESTS"] = "Mostra missioni e obiettivi"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"Elenca le missioni al prossimo punto di passaggio, ognuna con ciò che resta da fare lì."
L["QUESTS_LISTED"] = "Numero massimo di missioni elencate"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'Il numero massimo di missioni che la Freccia delle missioni elenca sotto di sé per un punto di passaggio. Le altre vengono contate su una riga a parte, come "%s".'
L["QUEST_ARROW_HIDING_HEADER"] = "Quando nascondere"
L["HIDE_IN_RAIDS"] = "Nascondi nei gruppi da incursione"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "Nasconde la Freccia delle missioni mentre sei in un gruppo da incursione."
L["HIDE_IN_INSTANCES"] = "Nascondi nelle istanze"
L["HIDE_IN_INSTANCES_DESCRIPTION"] =
	"Nasconde la Freccia delle missioni in spedizioni, incursioni e campi di battaglia."

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

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
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
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID missione %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
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
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Condividi missioni"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Offre al tuo gruppo le missioni di questa zona che il gioco ti permette di condividere, una ogni %d secondi."
L["CHAT_SHARING_ZONE_ONE"] = "Condivisione di 1 missione da %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Condivisione di %d missioni da %s, una ogni %d secondi."
L["CHAT_SHARING_ZONE_NONE"] = "Nessuna delle tue missioni di %s può essere condivisa."

--------------------------------------------------------------------------------
-- Routes on Zone Map and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Ci sei"
L["ROUTES_OBJECTIVE_AREA"] = "Area dell'obiettivo"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d m"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d in più qui"
L["ROUTES_TURN_IN"] = "Consegna la missione"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Consegna %s"
L["ROUTES_CORPSE"] = "Torna di corsa al tuo cadavere"
-- TRANSLATORS: Heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Cerca"
-- TRANSLATORS: %s is the party members a waypoint's objective is for, such as "Alice, Bob"
L["ROUTES_FOR_MEMBERS"] = "Per %s"
L["ROUTES_CLICK_DRAG"] = "Trascina"
L["ROUTES_CLICK_RIGHT"] = "Clic destro"
L["ROUTES_CLICK_MIDDLE"] = "Clic centrale"
L["ROUTES_DRAG_MOVE"] = "Sposta la Freccia delle missioni"
L["ROUTES_RIGHT_CLICK_REROUTE"] = "Aggira l'obiettivo attuale"
L["ROUTES_MIDDLE_CLICK_RESET"] = "Ripristina tutti i percorsi"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Percorso modificato per aggirare %s."
L["ROUTES_RESET"] = "Tutti i percorsi ripristinati: gli obiettivi aggirati sono di nuovo sul percorso."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

-- TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
-- each %s is a quest link or a list of them, and each %d is how many quests
L["WHISPER_SHARE_FAILED"] =
	"Ho provato a condividere %s con te, ma non è andata. Se ti interessa la missione, fammi un fischio quando puoi e te la ricondivido"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Lo stesso vale per %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Ho %d missioni da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Ho 1 missione da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Altre missioni da fare qui: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Il tracker di Questie non può mostrare %s perché la missione manca dal database di Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie non può ancora seguire questa missione."
