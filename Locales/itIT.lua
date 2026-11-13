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
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Per precauzione, la finestra Assegnazione tasti del gioco non può essere aperta durante il combattimento."
-- TRANSLATORS: the first %s is the game menu's Options label, the second its Key Bindings label, both from the client
L["KEY_BINDINGS_LOCATION"] = "Apri il menu di gioco, poi %s, poi %s, e cerca la sezione Pretty Wide Quest Log."
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
	"Aiuta il tuo gruppo a prendere le tue missioni: ritmo di condivisione, sussurri quando una condivisione non raggiunge qualcuno, e annuncio e condivisione delle missioni delle spedizioni. Il pulsante Condividi missioni di una zona nel registro delle missioni funziona anche con questa opzione disattivata."
L["ENABLE_WAYPOINT_MARKERS"] = "Attiva Indicatori dei punti di passaggio"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Raccoglie le icone delle missioni di ogni obiettivo sulla mappa della zona in un solo indicatore, un punto di passaggio, dove si trova la maggior parte dei suoi nemici od oggetti, più uno per ogni consegna. Passa il mouse su un indicatore per vedere le icone che sostituisce."
L["ENABLE_QUEST_ROUTE"] = "Attiva Percorso delle missioni"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"Traccia sulla mappa della zona un percorso tra i tuoi indicatori dei punti di passaggio, partendo dal più vicino, con puntini in movimento da te a ogni indicatore, uno alla volta. Richiede gli Indicatori dei punti di passaggio."
L["ENABLE_QUEST_ARROW"] = "Attiva Freccia delle missioni"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Mostra sullo schermo una freccia, la Freccia delle missioni, che punta al prossimo punto di passaggio del percorso, con le missioni e gli obiettivi da completare lì. Per impostazione predefinita si nasconde nei gruppi da incursione e nelle istanze."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Attiva registro delle missioni largo ha effetto dopo un ricaricamento, che ti verrà proposto alla chiusura dell'interfaccia delle opzioni."
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log cambia registro delle missioni dopo un ricaricamento. Ricaricare ora?"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Assegnazione tasti"
L["OPTIONS_KEY_SET"] = "Assegna tasto"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Apre l'Assegnazione tasti del gioco, dove Pretty Wide Quest Log ha una sezione tutta sua."
L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] =
	"Usa l'oggetto del primo pulsante Usa l'oggetto della Freccia delle missioni, come se ci facessi clic, anche in combattimento."
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di questo add-on."

--------------------------------------------------------------------------------
-- Options: Wide Quest Log Panels
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Registro delle missioni largo"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Sostituisce il registro delle missioni di Blizzard con uno largo: le tue missioni elencate per zona, con accanto i dettagli della missione selezionata e la sua mappa."
L["QUEST_LOG_SORTING_HEADER"] = "Ordinamento"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Scegli l'ordine delle tue zone e delle missioni sotto di esse."
L["QUEST_LOG_ROWS_HEADER"] = "Righe delle missioni"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Scegli cosa mostra ogni riga."
L["TAB_WINDOW_MAP"] = "Finestra e mappa"
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
L["SHOW_ZONE_INFO"] = "Mostra info zona"
L["SHOW_ZONE_INFO_DESCRIPTION"] =
	"Sotto la mappa, le missioni di altre zone che potresti prendere per la zona mostrata, e gli oggetti che chiedono le missioni di quella zona. La mappa si riduce a metà dell'altezza della finestra per fare spazio."
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
L["QUEST_LOG_SUB_PANELS_DESCRIPTION"] =
	"Le sue impostazioni sono nei pannelli sotto questo: Elenco delle missioni, Dettagli della missione, Finestra e mappa e Dialogo con i PNG."
L["NEEDS_WIDE_QUEST_LOG"] =
	"Queste impostazioni sono per il registro delle missioni largo. Spunta Attiva registro delle missioni largo nel pannello Registro delle missioni largo per usarle."
L["TAB_QUEST_LIST"] = "Elenco delle missioni"
L["TAB_QUEST_LIST_DESCRIPTION"] = "Le tue missioni, elencate per zona sul lato sinistro del registro delle missioni."
L["TAB_QUEST_DETAILS"] = "Dettagli della missione"
L["TAB_QUEST_DETAILS_DESCRIPTION"] =
	"I dettagli della missione selezionata, sulla pergamena accanto all'elenco delle missioni."

--------------------------------------------------------------------------------
-- Options: NPC Dialogue Panel
--------------------------------------------------------------------------------

L["TAB_NPC_DIALOGUE"] = "Dialogo con i PNG"
L["TAB_NPC_DIALOGUE_DESCRIPTION"] =
	"Le finestre che un PNG apre quando gli parli: la finestra del datore di missioni e la finestra di dialogo. Queste impostazioni funzionano con o senza il registro delle missioni largo."
L["QUEST_GIVERS_HEADER"] = "Datori di missioni"
L["QUEST_GIVERS_DESCRIPTION"] = "La finestra che apre un datore di missioni, dove accetti e consegni le missioni."
L["GIVER_CLEANUP"] = "Finestra del datore di missioni ordinata"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Impagina il testo della finestra del datore di missioni come quello del registro delle missioni, con gli stessi titoli e la stessa interlinea, e mostra sotto la missione il suo ID, con un link a Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Aggiunge le etichette di livello del registro delle missioni, come %s, all'elenco delle missioni di un datore di missioni."
L["FONT_DIALOGUE_NEEDS_CLEANUP"] =
	"Il carattere fa parte di Finestra del datore di missioni ordinata, quindi richiede che questa opzione sia attiva."

--------------------------------------------------------------------------------
-- Options: Font Sections
--------------------------------------------------------------------------------

L["FONT_HEADER"] = "Carattere"
L["FONT_LIST_DESCRIPTION"] = "Il carattere dei nomi delle zone e delle missioni nell'elenco delle missioni."
L["FONT_DETAILS_DESCRIPTION"] =
	"Il carattere dei dettagli della missione: il titolo, le intestazioni e il testo della missione."
L["FONT_DIALOGUE_DESCRIPTION"] =
	"Il carattere delle finestre del datore di missioni e di dialogo: il titolo, le intestazioni e il testo della missione."
L["FONT_WINDOW_DESCRIPTION"] = "Il carattere del titolo della finestra, del numero di missioni e della riga Consegna."
L["FONT_FACE"] = "Tipo di carattere"
L["FONT_FACE_DESCRIPTION"] =
	"Il tipo di carattere. Predefinito del gioco segue il carattere del gioco e qualsiasi add-on che lo cambi. Sono elencati anche i caratteri aggiunti tramite SharedMedia."
L["FONT_GAME_DEFAULT"] = "Predefinito del gioco"
L["FONT_GAME_STANDARD"] = "Testo standard"
L["FONT_GAME_NAMES"] = "Nomi dei personaggi"
L["FONT_GAME_DAMAGE"] = "Numeri dei danni"
L["FONT_SIZE"] = "Dimensione"
L["FONT_SIZE_DESCRIPTION"] =
	"Ingrandisce o rimpicciolisce il testo, in punti rispetto alla dimensione del gioco. 0 mantiene la dimensione del gioco."
L["FONT_OUTLINE"] = "Contorno"
L["FONT_OUTLINE_DESCRIPTION"] =
	"Un contorno nero attorno a ogni lettera. Predefinito del gioco mantiene il contorno che ha il carattere del gioco, e Nessuno lo toglie."
L["FONT_OUTLINE_DEFAULT"] = "Predefinito del gioco"
L["FONT_OUTLINE_NONE"] = "Nessuno"
L["FONT_OUTLINE_THIN"] = "Sottile"
L["FONT_OUTLINE_THICK"] = "Spesso"
L["FONT_SHADOW"] = "Ombra del testo"
L["FONT_SHADOW_DESCRIPTION"] =
	"Mantiene l'ombra proiettata che il carattere del gioco ha dietro il testo. Disattivala per togliere l'ombra, il che aiuta con un carattere che sembra sfocato o sbavato."
L["FONT_SLUG"] = "Testo più nitido (Slug)"
L["FONT_SLUG_DESCRIPTION"] =
	"Disegna il testo con il più recente renderer Slug di Blizzard, per lettere più nitide a qualsiasi dimensione. Slug non può disegnare un contorno spesso né un'ombra, quindi il testo che ha l'uno o l'altra viene disegnato nel modo consueto."
L["FONT_RESET_BUTTON"] = "Ripristina carattere"
L["FONT_RESET_DESCRIPTION"] = "Riporta le impostazioni di questo carattere ai valori predefiniti."

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Funzioni di comodità"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Piccoli aiuti al di fuori del registro delle missioni stesso: per condividere le missioni con il tuo gruppo e per le spedizioni."
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
L["ZONE_SHARE_OFFERS"] = "Offri le missioni della mia zona ai nuovi membri del gruppo"
L["ZONE_SHARE_OFFERS_DESCRIPTION"] =
	"Quando entri in un gruppo, o qualcuno entra nel tuo, attende 20 secondi che Questie scambi i registri delle missioni, poi sussurra a ogni membro del gruppo nella tua zona quante delle tue missioni con obiettivi lì non ha e gli chiede se le vuole. Contano solo le missioni che puoi condividere. Non ricevono sussurri i membri di cui non si vedono le missioni (senza Questie, fuori portata) né chi le ha già tutte. Ogni membro viene interpellato una volta per gruppo, mai in una spedizione o in un gruppo da incursione."
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
	"Condivide ogni missione della spedizione che il gioco ti permette di condividere e che a qualcuno del gruppo ancora manca, al ritmo impostato in Condivisione delle missioni, appena tutti sono a portata (o dopo un minuto; subito su WoW Forever). Ogni membro del gruppo le riceve una volta per spedizione, quindi le riceve anche chi entra dopo, e uscire e rientrare non condivide nulla. Con Sussurra quando una condivisione non riesce attivo, chi si perde una condivisione riceve un sussurro, così può richiederla."

--------------------------------------------------------------------------------
-- Options: Maps & Objectives Panels
--------------------------------------------------------------------------------

L["TAB_MAPS_OBJECTIVES"] = "Mappe e obiettivi"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Un indicatore sulla mappa della zona per ogni obiettivo e consegna, al posto di un mucchio di icone delle missioni."
L["MAPS_SUB_PANELS_DESCRIPTION"] =
	"Le impostazioni di ogni mappa sono nei pannelli sotto questo: Minimappa, Mappa della zona e Mappa del continente e del mondo."
L["MAPS_NEED_MARKERS"] = "Gli indicatori appaiono solo mentre Attiva Indicatori dei punti di passaggio è attivo."
L["TAB_MINIMAP"] = "Minimappa"
L["TAB_MINIMAP_DESCRIPTION"] =
	"Le icone di Questie sulla minimappa mostrano esattamente dove compaiono le cose e dove si ottiene il bottino, quindi restano sempre. Gli indicatori del percorso possono apparire accanto a loro."
L["SHOW_MINIMAP_MARKERS"] = "Mostra gli indicatori dei punti di passaggio sulla minimappa"
L["SHOW_MINIMAP_MARKERS_DESCRIPTION"] =
	"Mette un piccolo indicatore sulla minimappa per ogni punto di passaggio del percorso, accanto alle icone di Questie. Passa il mouse su uno per vederne le missioni."
L["MINIMAP_MARKER_SIZE_DESCRIPTION"] = "Quanto sono grandi gli indicatori del percorso sulla minimappa."
L["TAB_ZONE_MAP"] = "Mappa della zona"
L["TAB_ZONE_MAP_DESCRIPTION"] =
	"La mappa di una zona, dove il percorso passa tra i suoi indicatori dei punti di passaggio."
L["FULL_SIZE_MAP"] = "Apri la mappa della zona ingrandita"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Apre la mappa della zona ingrandita, come fa il suo pulsante di ingrandimento, così il percorso ha spazio. Se rimpicciolisci la mappa, la volta dopo si apre di nuovo ingrandita."
L["HIDE_QUESTIE_ICONS"] = "Nascondi le icone delle missioni sul percorso"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Per ciò che è sul percorso, nasconde le icone di Questie sulla mappa, e i segnalini delle missioni e le aree degli obiettivi di Blizzard, così gli indicatori del percorso le sostituiscono. Nasconde anche le icone sbiadite di Questie per gli obiettivi dei membri del gruppo. Passa il mouse su un indicatore per vedere le icone di Questie."
L["MARKER_SIZE"] = "Dimensione degli indicatori"
L["MARKER_SIZE_DESCRIPTION"] = "Quanto sono grandi gli indicatori del percorso sulla mappa della zona."
L["MARKER_SIZE_SMALL"] = "Piccola"
L["MARKER_SIZE_MEDIUM"] = "Media"
L["MARKER_SIZE_LARGE"] = "Grande"
L["MARKER_SIZE_HUGE"] = "Enorme"
L["TAB_WIDE_MAP"] = "Mappa del continente e del mondo"
L["TAB_WIDE_MAP_DESCRIPTION"] =
	"Mappe che contengono molte zone insieme, dove ogni obiettivo e ogni consegna ha un solo indicatore, più piccolo."
L["SHOW_WIDE_MAP_MARKERS"] = "Mostra gli indicatori dei punti di passaggio sulle mappe del continente e del mondo"
L["SHOW_WIDE_MAP_MARKERS_DESCRIPTION"] =
	"Mette un indicatore sulle mappe del continente e del mondo per ogni obiettivo e consegna, al posto delle icone di Questie. Disattivalo per vedere lì le icone di Questie al loro posto."
L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"] =
	"Quanto sono grandi gli indicatori del percorso sulle mappe del continente e del mondo. Ogni dimensione lì è più piccola che sulla mappa della zona, perché queste mappe contengono molte zone."

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "Percorso delle missioni"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"Un percorso tra i tuoi indicatori dei punti di passaggio sulla mappa della zona, nell'ordine in cui farli, a partire da dove ti trovi."
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"Il Percorso delle missioni passa tra gli indicatori dei punti di passaggio, quindi appare solo mentre Attiva Indicatori dei punti di passaggio è attivo."
L["ROUTES_LINE_HEADER"] = "Linea del percorso"
L["ROUTES_LINE_DESCRIPTION"] = "I puntini in movimento che vanno da te a ogni indicatore."
L["LINE_SPEED"] = "Velocità della linea"
L["LINE_SPEED_DESCRIPTION"] = "Quanto velocemente i puntini avanzano verso il prossimo indicatore."
L["LINE_SPEED_STILL"] = "Ferma"
L["LINE_SPEED_SLOW"] = "Lenta"
L["LINE_SPEED_NORMAL"] = "Normale"
L["LINE_SPEED_FAST"] = "Veloce"
L["LINE_OPACITY"] = "Opacità della linea"
L["LINE_OPACITY_DESCRIPTION"] = "Quanto sono pieni i puntini; più è bassa, più la mappa traspare."
L["ROUTES_PARTY_HEADER"] = "Gruppo"
L["ROUTES_PARTY_DESCRIPTION"] = "Cosa aggiunge il tuo gruppo al percorso."
L["PARTY_QUESTS"] = "Includi le missioni dei membri del gruppo"
L["PARTY_QUESTS_DESCRIPTION"] =
	"In gruppo, il percorso e la Freccia delle missioni includono anche le missioni che i membri del tuo gruppo hanno e tu no, mostrate come le tue. Serve Questie da entrambe le parti per condividerle. Le loro missioni delle spedizioni restano escluse, perché i loro obiettivi sono all'interno della spedizione."
L["GROUP_UP"] = "Ricongiungiti al gruppo"
L["GROUP_UP_DESCRIPTION"] =
	"In gruppo, quando qualcuno nella tua zona è fuori dalla tua minimappa, la Freccia delle missioni mostra Ricongiungiti al gruppo e punta verso quella persona, o verso il punto centrale tra tutti, e la mappa del mondo segna il punto, così potete fare le missioni insieme."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Freccia delle missioni"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Una freccia sullo schermo che punta al prossimo punto di passaggio del percorso, con le missioni e gli obiettivi da completare lì. Passaci sopra con il mouse per un menu in cui ignorare un obiettivo alla volta e vedere cosa hai ignorato. Facci clic centrale per reimpostare la zona e rimettere ciò che hai ignorato lì."
L["QUEST_ARROW_HEADER"] = "Freccia"
L["QUEST_ARROW_DESCRIPTION"] = "Dove si trova la Freccia delle missioni e quanto è grande."
L["ARROW_SIZE"] = "Dimensione della freccia"
L["ARROW_SIZE_DESCRIPTION"] = "Quanto è grande la Freccia delle missioni, con il testo sotto di essa."
L["LOCK_ARROW"] = "Blocca la Freccia delle missioni"
L["LOCK_ARROW_DESCRIPTION"] = "Tiene la Freccia delle missioni dov'è, così trascinarla non ha effetto."
L["RESET_ARROW"] = "Posizione della freccia"
L["RESET_ARROW_BUTTON"] = "Ripristina"
L["RESET_ARROW_CONFIRM"] = "Riportare la Freccia delle missioni alla posizione iniziale?"
L["RESET_ARROW_DESCRIPTION"] =
	"Riporta la Freccia delle missioni alla posizione iniziale, in alto al centro dello schermo."
L["QUEST_ARROW_TEXT_HEADER"] = "Sotto la freccia"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "Cosa elenca la Freccia delle missioni sotto di sé."
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
L["SHOW_ITEM_BUTTONS"] = "Mostra i pulsanti degli oggetti delle missioni"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"Mette un pulsante accanto a ogni missione elencata dalla Freccia delle missioni che ha un oggetto da usare, per esempio da lanciare, piantare o usare su un bersaglio. Fai clic sul pulsante per usare l'oggetto, oppure assegna un tasto a Usa l'oggetto della missione in Assegnazione tasti nel pannello Pretty Wide Quest Log per usare il primo. In combattimento i pulsanti restano dove sono finché il combattimento non termina."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_NEXT_OBJECTIVE
L["SHOW_NEXT_OBJECTIVE"] = "Mostra il prossimo obiettivo"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'In "%s", elenca "%s" sotto, attenuato: una piccola freccia verso il punto di passaggio successivo e cosa c\'è da fare lì.'
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_PREDICTIVE
L["PREDICTIVE_ROUTES"] = "Percorsi di missioni predittivi"
L["PREDICTIVE_ROUTES_DESCRIPTION"] =
	"Pianifica le missioni che puoi completare in questa zona ovunque si trovi chi le assegna, non solo vicino: i loro obiettivi, la consegna e le missioni che le seguono. Il percorso ti fa poi accettare tutto ciò che serve per una parte della zona prima che tu ci vada, così ci vai una volta sola. Una catena si ferma alla prima missione che porta in un'altra zona. Gli obiettivi di una missione non ancora accettata hanno un indicatore grigio. Anche la consegna di ogni missione appare prima che sia completata, segnata dal punto interrogativo grigio di Questie."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_FLIGHTS
L["SHOW_FLIGHT_PATHS"] = "Mostra i percorsi di volo non scoperti come obiettivi"
L["SHOW_FLIGHT_PATHS_DESCRIPTION"] =
	"Aggiunge al percorso ogni maestro di volo della tua zona di cui non hai ancora il percorso di volo, segnato con l'icona del maestro di volo. Su un personaggio che aveva già dei percorsi di volo, apri una volta una mappa di volo qualsiasi perché il percorso sappia quali hai; fino ad allora non ne viene aggiunto nessuno."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_LOCAL
L["SHOW_LOCAL_QUESTS"] = "Mostra missioni disponibili vicine come obiettivi"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"Mette sul percorso le missioni che puoi accettare, quando Questie le mostra come disponibili e un PNG o un oggetto che le avvia è entro %s, segnate dal punto esclamativo di Questie. Restano fuori le missioni avviate da un oggetto bottino e quelle di spedizione e incursione."
L["LOCAL_QUESTS_HEADER"] = "Missioni disponibili vicine"
L["LOCAL_QUESTS_DESCRIPTION"] =
	"Verso quali missioni vicine ti guida la freccia delle missioni. Una che salta può comunque comparire sulla mappa del mondo, senza linea del percorso fino a lì."
L["LOCAL_QUEST_RANGE"] = "Raggio di ricerca"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"A quanti metri da te può trovarsi chi dà la missione per contare ancora. Sotto i 400, un datore che superi tra due calcoli del percorso può sfuggire."
L["LOCAL_ESCORT_QUESTS"] = "Missioni di scorta"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] =
	"Missioni in cui proteggi un PNG lungo la strada; richiedono tempo e spesso un gruppo. Il loro indicatore sulla mappa è verde."
L["LOCAL_GROUP_QUESTS"] = "Missioni di gruppo ed élite"
L["LOCAL_GROUP_QUESTS_DESCRIPTION"] = "Missioni che Questie segna come élite, pensate per un gruppo."
L["LOCAL_OTHER_ZONE_QUESTS"] = "Obiettivi in un'altra zona"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"Missioni con un obiettivo, o la consegna, solo fuori dalla tua zona, come una che ti manda al villaggio successivo."
L["LOCAL_QUEST_LEVEL"] = "Livello minimo delle missioni"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	"Le missioni sotto questo colore di difficoltà restano fuori. Impostazione di Questie tiene le missioni che Questie mostra sulla sua mappa."
-- TRANSLATORS: a choice for a kind of nearby quest: the Quest Arrow takes you there
L["LOCAL_CHOICE_ROUTE"] = "Nel percorso"
-- TRANSLATORS: a choice for a kind of nearby quest: a marker on the world map, but the Quest Arrow skips it
L["LOCAL_CHOICE_MAP"] = "Solo mappa"
-- TRANSLATORS: a choice for a kind of nearby quest: neither the route nor its map markers show it
L["LOCAL_CHOICE_OFF"] = "Escluse"
L["LOCAL_LEVEL_QUESTIE"] = "Impostazione di Questie"
-- TRANSLATORS: quest difficulty colors, green being a few levels below the player
L["LOCAL_LEVEL_GREEN"] = "Verdi e superiori"
L["LOCAL_LEVEL_YELLOW"] = "Gialle e superiori"
L["QUEST_ARROW_HIDING_HEADER"] = "Quando nascondere"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "Quando la Freccia delle missioni si fa da parte."
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
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "Lettere dopo il livello: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID missione %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Catena di missioni (%d di %d)"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "Le missioni giornaliere si azzerano tra %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Clicca per ottenere un link a Wowhead."
L["WOWHEAD_LINK_COPY"] = "Premi Ctrl+C (Cmd+C su Mac) per copiare il link a Wowhead."
L["EXPAND_ALL"] = "Espandi tutto"
L["COLLAPSE_ALL"] = "Comprimi tutto"
L["TRACK_ALL"] = "Segui tutte"
L["UNTRACK_ALL"] = "Non seguire nessuna"
L["HIDE_MAP"] = "Nascondi mappa"
L["ZONE_INFO_QUESTS"] = "Missioni da prendere"
L["ZONE_INFO_ITEMS"] = "Cose da portare"
L["ZONE_INFO_BACK"] = "Torna alla missione"
L["ZONE_INFO_ASK"] = "Chiedi condivisioni"
L["ZONE_INFO_ASK_DESCRIPTION"] =
	"Scrive nella chat le missioni di qui che i giocatori possono condividere, nel canale 4 (Cerca gruppo) se ci sei. Non viene inviato nulla finché non premi Invio."
-- TRANSLATORS: %s is the names of quests, joined by commas; it's written into the chat box, never sent
L["ZONE_INFO_ASK_MESSAGE"] = "Qualcuno può condividere %s?"
-- TRANSLATORS: the first %s is a quest giver's name, the second the zone they stand in
L["ZONE_INFO_GIVER"] = "Assegnata da %s"
L["ZONE_INFO_GIVER_PLACE"] = "%s (%s)"
L["ZONE_INFO_SHAREABLE"] = "Condivisibile"
L["ZONE_INFO_NOT_SHAREABLE"] = "Non condivisibile"
L["ZONE_INFO_TRACK"] = "Aggiungi al percorso"
L["ZONE_INFO_UNTRACK"] = "Togli dal percorso"
L["ZONE_INFO_NEEDED_FOR"] = "Serve per"
L["ZONE_INFO_SHIFT_CLICK"] = "Maiusc-clic"
L["ZONE_INFO_LINK_ITEM"] = "Collega in chat"
L["ZONE_INFO_MENU_QUEST"] = "Questa missione"
L["ZONE_INFO_MENU_HERE"] = "Dove sei"
L["ZONE_INFO_MENU_LOG"] = "Le tue missioni"
L["ZONE_INFO_MENU_AVAILABLE"] = "Più missioni per te"
L["ZONE_INFO_NO_QUESTS"] = "Nessuna missione di altre zone da prendere per qui."
L["ZONE_INFO_NO_ITEMS"] = "Niente da comprare o portare."
L["ZONE_INFO_WORKING"] = "Lettura delle missioni..."
L["ZONE_INFO_NEEDS_QUESTIE"] = "Attiva Questie per vedere cosa c'è qui."
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "%s PE"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "Consegna: %s"
L["TURN_IN_TOOLTIP"] = "Pronta da consegnare"
L["RESIZE_TOOLTIP"] = "Trascina per ridimensionare il registro delle missioni."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Condividi missioni"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Offre al tuo gruppo le missioni di questa zona che il gioco ti permette di condividere e che a qualcuno ancora mancano, una ogni %d secondi."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "Condivisione di %s alla fine del combattimento."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "Condivisione di 1 missione da %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Condivisione di %d missioni da %s, una ogni %d secondi."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "Nessuna delle tue missioni di %s può essere condivisa."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_PARTY_HAS"] = "Il tuo gruppo ha già tutte le tue missioni della zona %s."

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Ci sei"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "Punto di passaggio su un'altra mappa"
L["ROUTES_OBJECTIVE_AREA"] = "Area dell'obiettivo attuale"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "Completa qui prima di proseguire"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "Altri lungo il percorso"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "Prossimo obiettivo"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "Già che sei qui"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d metri"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d metro"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d in più qui"
L["ROUTES_TURN_IN"] = "Consegna la missione"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Consegna %s"
L["ROUTES_PICK_UP"] = "Accetta la missione"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "Accetta %s"
L["ROUTES_FLIGHT_PATH"] = "Ottieni il percorso di volo"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_FLIGHT_PATH_FROM"] = "Ottieni il percorso di volo da %s"
L["ROUTES_FLY_FROM"] = "Parla con %s per volare a %s"
-- TRANSLATORS: under a quest to pick up on the world map, why the route doesn't go there
L["ROUTES_OFF_ROUTE_ESCORT"] = "Missione di scorta, fuori dal percorso"
L["ROUTES_OFF_ROUTE_GROUP"] = "Missione di gruppo, fuori dal percorso"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "Porta in un'altra zona, fuori dal percorso"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"; over a quest's objectives planned before it's picked up
L["ROUTES_AFTER_PICK_UP"] = "Dopo aver accettato %s"
-- TRANSLATORS: %s is the quest's title with its level; under a quest to pick up once another is turned in
L["ROUTES_AFTER_TURN_IN"] = "Dopo aver consegnato %s"
-- TRANSLATORS: as ROUTES_AFTER_PICK_UP, for a party member's quest planned ahead, one you don't have
L["ROUTES_AFTER_PARTY_PICK_UP"] = "Dopo che il tuo gruppo ha accettato %s"
-- TRANSLATORS: as ROUTES_AFTER_TURN_IN, for a party member's quest
L["ROUTES_AFTER_PARTY_TURN_IN"] = "Dopo che il tuo gruppo ha consegnato %s"
L["ROUTES_CORPSE"] = "Torna di corsa al tuo cadavere"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Cerca"
L["ROUTES_CLICK_DRAG"] = "Trascina"
L["ROUTES_CLICK_RIGHT"] = "Clic destro"
L["ROUTES_CLICK_MIDDLE"] = "Clic centrale"
L["ROUTES_CLICK"] = "Clic"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "Usa l'oggetto"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "Usa l'oggetto della missione"
L["ROUTES_DRAG_MOVE"] = "Sposta la Freccia delle missioni"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "Ignora questo punto di passaggio"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "Ignora questo obiettivo"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "Rimetti nel percorso"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "Reimposta questa zona"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Il percorso ignora %s finché non reimposti la zona."
L["ROUTES_ZONE_RESET"] = "Zona reimpostata: gli obiettivi ignorati qui sono di nuovo sul percorso."
L["ROUTES_GROUP_LEFT_CLEARED"] =
	"Gruppo lasciato: gli obiettivi di gruppo e i membri ignorati sono di nuovo sul percorso."
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] =
	"%s ha lasciato il gruppo: gli obiettivi ignorati corrispondenti sono di nuovo sul percorso."
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "Ignora"
L["ROUTES_MENU_SECTION_ROUTE"] = "Percorso"
L["ROUTES_MENU_SECTION_SHOW"] = "Mostra"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "Successivo"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "Ripristina"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "Ignorati"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "Consegna di %s"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "Accettazione di %s"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_MENU_FLIGHT_PATH"] = "Percorso di volo di %s"
L["ROUTES_MENU_FLY"] = "Volo per %s"
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_ROUTE; Next Objective, under ROUTES_MENU_SECTION_SHOW, is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_PREDICTIVE"] = "Percorsi di missioni predittivi"
L["ROUTES_MENU_SHOWN_LOCAL"] = "Missioni disponibili vicine"
L["ROUTES_MENU_SHOWN_FLIGHTS"] = "Percorsi di volo"
L["ROUTES_MENU_SHOWN_PARTY"] = "Obiettivi del gruppo"
L["ROUTES_MENU_ON"] = "Attivo"
L["ROUTES_MENU_OFF"] = "Disattivo"
L["ROUTES_MENU_OUT_OF_ZONE"] = "Fuori zona"
L["ROUTES_MENU_NO_QUESTIE"] = "Senza Questie"
L["ROUTES_MENU_OFFLINE"] = "Non in linea"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "Obiettivi di %s"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "Il percorso ignora %s per %s finché non reimposti la zona."
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] =
	"Il percorso ignora %s per %s finché i membri del gruppo che ce l'hanno non lasciano il gruppo."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s è di nuovo sul percorso."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "Gli obiettivi di %s restano fuori dal percorso."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "Gli obiettivi di %s sono di nuovo sul percorso."
-- TRANSLATORS: on the Quest Arrow and the world map's marker, while it points to where to join up with your party
L["ROUTES_GROUP_UP"] = "Ricongiungiti al gruppo"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them, and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"Ho provato a condividere %s con te, ma non è andata. Se ti interessa la missione, fammi un fischio quando puoi e te la ricondivido"
L["WHISPER_SHARE_FAILED_AGAIN"] = "Lo stesso vale per %s"
L["ZONE_SHARE_OFFER"] = "Ho %d missioni nella zona %s che ti mancano. Vuoi che provi a condividerle?"
L["ZONE_SHARE_OFFER_ONE"] = "Ho 1 missione nella zona %s che ti manca. Vuoi che provi a condividerla?"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Ho %d missioni da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Ho 1 missione da fare qui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Altre missioni da fare qui: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] =
	"Il tracker di Questie non può mostrare %s perché la missione manca dal database di Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie non può ancora seguire questa missione."
