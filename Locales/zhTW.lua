local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "zhTW")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT_NAME"] = "PWQL"
-- TRANSLATORS: joins the items of a list, such as quest links or the letters after a quest's level
L["LIST_SEPARATOR"] = "、"
L["CHAT_LOADED"] =
	"版本 %s。設定（包括關閉此訊息的選項）位於 選項 > 插件 > Pretty Wide Quest Log。喜歡這個插件嗎？推薦給朋友，在 CurseForge 上收藏，或在 GitHub 上按 Star 吧。(="
L["CHAT_OPTIONS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟設定介面。"
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟遊戲的按鍵設定。"
-- TRANSLATORS: the first %s is the game menu's Options label, the second its Key Bindings label, both from the client
L["KEY_BINDINGS_LOCATION"] =
	"開啟遊戲選單，點擊 %s，再點擊 %s，然後找到 Pretty Wide Quest Log 區塊。"
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"沒有 Questie 時，沒有任務路線和任務箭頭，任務地圖顯示的內容會變少，任務鏈和回報總計也會隱藏。請在插件列表中啟用 Questie 以顯示它們。"
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus 也已啟用，兩者會互相搶奪任務日誌。請在插件列表中停用 Wide Quest Log Plus，然後重新載入介面。"

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_RESET"] = "重置"
L["OPTIONS_DESCRIPTION"] =
	"寬版任務日誌與升級任務助手：一條串起你所選任務的任務路線、一個指向路徑點的箭頭，還有任務等級、標籤、獎勵、任務鏈、任務地圖，以及與隊伍分享任務。相容 Questie、Spoken、VoiceOver 和 ElvUI。"
L["ENABLE_WELCOME_MESSAGE"] = "啟用歡迎訊息"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "登入時顯示 Pretty Wide Quest Log 的歡迎訊息。"
L["OPTIONS_FEATURES_HEADER"] = "功能"
L["ENABLE_WIDE_QUEST_LOG"] = "啟用寬版任務日誌"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"將暴雪任務日誌換成寬版任務日誌，地圖就在旁邊。重新載入介面後生效。"
L["ENABLE_QUALITY_OF_LIFE"] = "啟用便利功能"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"幫助隊友接到你的任務：分享節奏、分享漏掉某人時的密語，以及地城任務的通報和分享。即使關閉此項，任務日誌中每個區域的分享任務按鈕仍然可用。"
L["QUEST_TOOLTIPS"] = "任務滑鼠提示"
L["ENABLE_QUEST_TOOLTIPS"] = "啟用任務滑鼠提示"
L["FEATURE_QUEST_TOOLTIPS_DESCRIPTION"] =
	"將Questie加入怪物、物件、物品和地圖圖示滑鼠提示中的任務行，依任務箭頭列出路徑點的方式排列，並在每個目標下顯示隊友的進度。關閉後顯示Questie自己的任務行。"
L["ENABLE_WAYPOINT_MARKERS"] = "啟用路徑點標記"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"將區域地圖上每個任務目標的任務圖示合併為一個標記，也就是一個路徑點，放在其怪物或物品最多的地方，每個回報地點也各有一個。將滑鼠移到標記上可查看它所取代的圖示。"
L["ENABLE_QUEST_ROUTE"] = "啟用任務路線"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"在區域地圖上畫出一條經過你的路徑點標記的路線，由近而遠，以從你的位置依序通往每個標記的移動圓點顯示。需要路徑點標記。"
L["ENABLE_QUEST_ARROW"] = "啟用任務箭頭"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"在畫面上顯示一個箭頭，即任務箭頭，指向路線上的下一個路徑點，並列出要在那裡完成的任務和目標。預設在團隊和副本中隱藏。"
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"啟用寬版任務日誌需要重新載入介面才會生效，關閉設定介面時會提示你重新載入。"
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log 需要重新載入介面才能切換任務日誌。現在重新載入嗎？"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "按鍵設定"
L["OPTIONS_KEY_SET"] = "設定按鍵"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "開啟遊戲的按鍵設定，Pretty Wide Quest Log 在其中有自己的區塊。"
L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] =
	"使用任務箭頭上第一個使用物品按鈕中的物品，效果與點擊該按鈕相同，戰鬥中也能使用。"
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的設定介面。"

--------------------------------------------------------------------------------
-- Options: Wide Quest Log Panels
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "寬版任務日誌"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"以寬版任務日誌取代暴雪任務日誌：任務依區域列出，旁邊顯示所選任務的詳細資訊及其地圖。"
L["QUEST_LOG_SORTING_HEADER"] = "排序"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "選擇區域及其下任務的順序。"
L["QUEST_LOG_ROWS_HEADER"] = "任務列"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "選擇每列顯示的內容。"
L["TAB_WINDOW_MAP"] = "視窗與地圖"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"調整視窗和地圖大小以符合你的螢幕，並選擇它們的行為方式。"
L["ZONE_ORDER"] = "區域順序"
L["ZONE_ORDER_DESCRIPTION"] = "變更任務清單中區域的順序。"
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "平均等級，由高到低（預設）"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "平均等級，由低到高"
L["SORT_ALPHABETICAL"] = "依名稱"
L["CURRENT_ZONE_FIRST"] = "優先顯示目前區域"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] = "無論區域順序為何，都將你所在的區域置於清單頂端。"
L["ZONE_GAP"] = "在區域名稱上方加入空白"
L["ZONE_GAP_DESCRIPTION"] =
	"在每個區域名稱上方留出一點間距。如果你的任務分散在許多區域，會很方便。"
L["QUEST_ORDER"] = "任務順序"
L["QUEST_ORDER_DESCRIPTION"] = "變更每個區域下任務的順序。"
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "等級，由高到低（預設）"
L["SORT_LEVEL_LOWEST"] = "等級，由低到高"
L["COMPLETED_FIRST"] = "優先顯示已完成任務"
L["COMPLETED_FIRST_DESCRIPTION"] = "將可以回報的任務移到所在區域的頂端。"
L["SHOW_QUEST_LEVELS"] = "顯示任務等級"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"在清單中每個任務名稱前顯示其等級和類型，例如 %s 表示40級地城任務。"
L["MARK_UNTRACKED"] = "標記未追蹤的任務"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"已追蹤的任務不再顯示勾號 %s，改為在未追蹤的任務前顯示眼睛 %s。如果你幾乎追蹤所有任務，會很方便。"
L["CLOSE_IN_COMBAT"] = "戰鬥開始時關閉"
L["CLOSE_IN_COMBAT_DESCRIPTION"] = "戰鬥開始時關閉任務日誌，避免遮住戰鬥畫面。"
L["SHOW_OBJECTIVE_AREAS"] = "顯示目標範圍"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"在任務日誌旁的地圖上，以陰影標出每個目標的怪物和物件所在的範圍，每個範圍只顯示一個圖示，而不是每個重生點各顯示一個。"
L["NEEDS_QUESTIE_HINT"] = "啟用 Questie 後才能使用此功能。"
L["SHOW_ZONE_INFO"] = "顯示區域資訊"
L["SHOW_ZONE_INFO_DESCRIPTION"] =
	"在地圖下方列出：為地圖所示區域可在其他區域接取的任務，以及該區域任務要求帶去的物品。地圖會縮小到視窗高度的一半來騰出空間。"
L["WINDOW_SCALE"] = "任務日誌縮放"
L["WINDOW_SCALE_DESCRIPTION"] = "放大或縮小任務日誌。旁邊的地圖會隨之一起縮放。"
L["MAP_SCALE"] = "地圖縮放"
L["MAP_SCALE_DESCRIPTION"] = "在任務日誌縮放的基礎上，放大或縮小任務日誌旁的地圖。"
L["RESET_WINDOW"] = "重置視窗"
L["RESET_WINDOW_SCALE_DESCRIPTION"] = "將任務日誌的高度和縮放以及地圖縮放恢復為預設值。"
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"將任務日誌的高度和縮放以及地圖縮放恢復為預設值，並將視窗移回初始位置。"
L["RESET_WINDOW_SCALE_CONFIRM"] = "要重設任務日誌的高度和縮放以及地圖縮放嗎？"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"要重設任務日誌的高度和縮放、地圖縮放以及視窗在螢幕上的位置嗎？"
L["HANDY_CLICKS_HEADER"] = "實用點擊"
L["HANDY_CLICK_TRACK"] = "Shift+點擊任務"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "追蹤或取消追蹤該任務。"
L["HANDY_CLICK_MENU"] = "右鍵點擊任務"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "追蹤、分享或放棄該任務。"
L["HANDY_CLICK_ID"] = "點擊任務ID"
L["HANDY_CLICK_ID_DESCRIPTION"] = "取得其 Wowhead 連結。"
L["QUEST_LOG_SUB_PANELS_DESCRIPTION"] =
	"其設定位於此頁面下方的各個頁面中：任務清單、任務詳細資訊、視窗與地圖，以及NPC對話。"
L["NEEDS_WIDE_QUEST_LOG"] =
	"寬版任務日誌已關閉，因此這些設定不會生效。它的開關在寬版任務日誌頁面上。"
L["TAB_QUEST_LIST"] = "任務清單"
L["TAB_QUEST_LIST_DESCRIPTION"] = "你的任務，依區域列在任務日誌左側。"
L["TAB_QUEST_DETAILS"] = "任務詳細資訊"
L["TAB_QUEST_DETAILS_DESCRIPTION"] = "所選任務的詳細資訊，顯示在任務清單旁的羊皮紙上。"

--------------------------------------------------------------------------------
-- Options: NPC Dialogue Panel
--------------------------------------------------------------------------------

L["TAB_NPC_DIALOGUE"] = "NPC對話"
L["TAB_NPC_DIALOGUE_DESCRIPTION"] =
	"與NPC交談時開啟的視窗：任務NPC視窗和對話視窗。無論是否使用寬版任務日誌，這些設定都有效。"
L["QUEST_GIVERS_HEADER"] = "任務NPC"
L["QUEST_GIVERS_DESCRIPTION"] = "任務NPC開啟的視窗，你在這裡接受和回報任務。"
L["GIVER_CLEANUP"] = "任務NPC視窗整理"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"讓任務NPC視窗的文字排版與任務日誌一致，使用相同的標題和行距，並在任務下方顯示連結到 Wowhead 的任務ID。"
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] = "在任務NPC的任務清單中加上任務日誌的等級標籤，例如 %s。"
L["FONT_DIALOGUE_NEEDS_CLEANUP"] = "此字型是任務NPC視窗整理的一部分，因此需要開啟該功能。"

--------------------------------------------------------------------------------
-- Options: Font Sections
--------------------------------------------------------------------------------

L["FONT_HEADER"] = "字型"
L["FONT_LIST_DESCRIPTION"] = "任務清單中區域名稱和任務的字型。"
L["FONT_DETAILS_DESCRIPTION"] = "任務詳細資訊的字型：標題、小標題和任務文字。"
L["FONT_DIALOGUE_DESCRIPTION"] = "任務NPC視窗和對話視窗的字型：標題、小標題和任務文字。"
L["FONT_WINDOW_DESCRIPTION"] = "視窗標題、任務數量和回報列的字型。"
L["FONT_FACE"] = "字型"
L["FONT_FACE_DESCRIPTION"] =
	'字體樣式。"遊戲預設"會跟隨遊戲字型，以及任何變更遊戲字型的插件。透過 SharedMedia 加入的字型也會列出。'
L["FONT_GAME_DEFAULT"] = "遊戲預設"
L["FONT_GAME_STANDARD"] = "標準文字"
L["FONT_GAME_NAMES"] = "角色名稱"
L["FONT_GAME_DAMAGE"] = "傷害數字"
L["FONT_SIZE"] = "大小"
L["FONT_SIZE_DESCRIPTION"] = "以遊戲字級為基準，依點數放大或縮小文字。0 表示維持遊戲字級。"
L["FONT_OUTLINE"] = "外框"
L["FONT_OUTLINE_DESCRIPTION"] =
	'每個字周圍的黑色外框。"遊戲預設"保留遊戲字型原有的外框，"無"則移除外框。'
L["FONT_OUTLINE_DEFAULT"] = "遊戲預設"
L["FONT_OUTLINE_NONE"] = "無"
L["FONT_OUTLINE_THIN"] = "細"
L["FONT_OUTLINE_THICK"] = "粗"
L["FONT_SHADOW"] = "文字陰影"
L["FONT_SHADOW_DESCRIPTION"] =
	"保留遊戲字型在文字後方的投影。關閉後會移除陰影，有助於改善看起來模糊或暈開的字型。"
L["FONT_SLUG"] = "更清晰的文字（Slug）"
L["FONT_SLUG_DESCRIPTION"] =
	"使用暴雪較新的 Slug 繪製引擎來繪製文字，在任何字級下都更清晰。Slug 無法繪製粗外框或陰影，因此帶有其中任一效果的文字會以一般方式繪製。"
L["FONT_RESET"] = "重置字型"
L["FONT_RESET_CONFIRM"] = "要將此字型的字體、大小、外框、陰影和 Slug 恢復為預設值嗎？"
L["FONT_RESET_DESCRIPTION"] = "將此字型的設定恢復為預設值。"

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "便利功能"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"任務日誌本身之外的小幫手：用於與隊伍分享任務，以及用於地城。"
L["QUEST_SHARING_HEADER"] = "任務分享"
L["QUEST_SHARING_INTRO"] =
	"在任務日誌中將滑鼠游標停在區域名稱上並點擊分享任務按鈕，即可把該區域中你能分享的所有任務逐一分享給隊伍。這些選項設定分享的節奏，以及有人錯過任務時該怎麼辦。"
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"區域名稱上的分享任務按鈕需要寬版任務日誌。地城任務分享無需此項即可使用。"
L["SHARE_INTERVAL"] = "分享間隔秒數"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"分享一個任務後到下一個任務之間的等待時間，適用於分享區域或地城的任務時。時間越長，隊友就有越多時間接受每個任務。"
L["SHARE_WHISPERS"] = "分享失敗時密語"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"當隊友正忙、距離太遠或任務日誌已滿時，密語告訴對方你嘗試分享的任務，並請對方提醒你。如果對方不符合任務條件、已經接了該任務或已經完成，則不傳送任何訊息。"
L["ZONE_SHARE_OFFERS"] = "告訴我新隊友需要什麼"
L["ZONE_SHARE_OFFERS_DESCRIPTION"] =
	"有人加入你的隊伍時，在聊天框告訴你：你在這個區域的任務中，有多少是對方沒有而你可以分享的，方便你點擊分享任務。不會向任何人發送訊息。在地城或團隊中不會提醒。"
L["ZONE_SHARE_OFFERS_SOUND"] = "播放音效"
L["ZONE_SHARE_OFFERS_SOUND_DESCRIPTION"] = "在訊息的同時播放提示音，適合聊天繁忙的時候。"
L["OPTIONS_SOUND_PREVIEW_DESCRIPTION"] = "立即播放這個音效，無論音效是否開啟。"
L["SAMPLE_EXAMPLE"] = "範例"
L["SAMPLE_QUEST_LOADING"] = "正在載入任務ID：%d"
L["DUNGEON_QUESTS_HEADER"] = "地城任務"
L["DUNGEON_QUESTS_INTRO"] =
	"當你和隊伍進入地城時，會在所有人都進入範圍後（在 WoW Forever 上立即）通報並分享你在其中的任務，且不會對同一支隊伍進行兩次。裝有 Questie 時，目標位於其中的任務也算在內，包括職業任務。在團隊中不會進行。"
L["DUNGEON_ANNOUNCE"] = "地城任務自動通報"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"告訴隊友你在剛進入的地城裡還有哪些任務要做，讓大家知道要留意什麼。可以回報的任務不會列出。"
L["DUNGEON_SHARE"] = "地城任務自動分享"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"依任務分享中設定的節奏，把你剛進入的地城裡的每個任務分享給還沒有該任務的每位隊友。每位隊友在每個地城只會收到一次，所以晚加入的人也會收到。"

--------------------------------------------------------------------------------
-- Options: Maps & Objectives Panels
--------------------------------------------------------------------------------

L["TAB_MAPS_OBJECTIVES"] = "地圖與目標"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"區域地圖上每個任務目標和回報地點各一個標記，取代成堆的任務圖示。"
L["MAPS_SUB_PANELS_DESCRIPTION"] =
	"每張地圖的設定位於此頁面下方的各個頁面中：小地圖、區域地圖，以及大陸與世界地圖。"
L["ROUTES_NEED_QUESTIE"] = "Questie 已關閉，因此沒有可顯示的路線。請在插件列表中啟用 Questie。"
L["MAPS_NEED_MARKERS"] =
	"路徑點標記已關閉，因此這些設定不會生效。它的開關在地圖與目標頁面上。"
L["TAB_MINIMAP"] = "小地圖"
L["TAB_MINIMAP_DESCRIPTION"] =
	"小地圖上的 Questie 圖示會準確顯示目標的重生位置和拾取地點，因此始終保留。路線標記可以顯示在它們旁邊。"
L["SHOW_MINIMAP_MARKERS"] = "在小地圖上顯示路徑點標記"
L["SHOW_MINIMAP_MARKERS_DESCRIPTION"] =
	"在小地圖上為路線的每個路徑點放置一個小標記，位於 Questie 圖示旁邊。將滑鼠游標停在標記上可查看其任務。"
L["MINIMAP_MARKER_SIZE_DESCRIPTION"] = "路線標記在小地圖上的大小。"
L["TAB_ZONE_MAP"] = "區域地圖"
L["TAB_ZONE_MAP_DESCRIPTION"] = "區域的地圖，路線在其中的路徑點標記之間延伸。"
L["FULL_SIZE_MAP"] = "以最大尺寸開啟區域地圖"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"像地圖本身的最大化按鈕一樣，以最大化狀態開啟區域地圖，讓路線有足夠空間。即使你把地圖縮小，下次也會再次以最大尺寸開啟。"
L["HIDE_QUESTIE_ICONS"] = "隱藏路線上的任務圖示"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"隱藏路線上目標的 Questie 地圖圖示，以及暴雪內建的任務標識和目標區域，由路線標記代替顯示。隊友目標的 Questie 半透明圖示也會隱藏。將滑鼠游標停在標記上可查看 Questie 圖示。"
L["MARKER_SIZE"] = "標記大小"
L["MARKER_SIZE_DESCRIPTION"] = "路線標記在區域地圖上的大小。"
L["MARKER_SIZE_SMALL"] = "小"
L["MARKER_SIZE_MEDIUM"] = "中"
L["MARKER_SIZE_LARGE"] = "大"
L["MARKER_SIZE_HUGE"] = "特大"
L["WAYPOINTS_SHOWN"] = "顯示的路徑點"
L["WAYPOINTS_SHOWN_DESCRIPTION"] =
	"區域地圖繪製多少路線。完整路線仍會規劃：在這些路徑點之後，一個 … 標記指向路線的下一步，滑鼠懸停即可看到其餘部分。點擊它會顯示完整路線，直到你關閉地圖。"
-- TRANSLATORS: a Waypoints Shown choice; %d is how many waypoints, 5, 10 or 20
L["WAYPOINTS_SHOWN_NEXT"] = "接下來 %d 個"
L["WAYPOINTS_SHOWN_ALL"] = "完整路線"
L["TAB_WIDE_MAP"] = "大陸與世界地圖"
L["TAB_WIDE_MAP_DESCRIPTION"] =
	"同時包含許多區域的地圖，每個目標和回報地點在這裡各有一個較小的標記。"
L["SHOW_WIDE_MAP_MARKERS"] = "在大陸和世界地圖上顯示路徑點標記"
L["SHOW_WIDE_MAP_MARKERS_DESCRIPTION"] =
	"在大陸和世界地圖上為每個目標和回報地點放置一個標記，取代 Questie 的圖示。關閉後會在那裡改為顯示 Questie 的圖示。"
L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"] =
	"路線標記在大陸和世界地圖上的大小。由於這些地圖包含許多區域，每種大小在那裡都比區域地圖上小。"

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "任務路線"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"區域地圖上的一條路線，從你所在的位置出發，按完成順序經過你的路徑點標記。"
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"任務路線連接各個路徑點標記，因此只有在路徑點標記開啟時才會顯示。"
L["ROUTES_LINE_HEADER"] = "路線線條"
L["ROUTES_LINE_DESCRIPTION"] = "從你的位置通往每個標記的移動圓點。"
L["LINE_SPEED"] = "線條速度"
L["LINE_SPEED_DESCRIPTION"] = "圓點向下一個標記移動的速度。"
L["LINE_SPEED_STILL"] = "靜止"
L["LINE_SPEED_SLOW"] = "慢"
L["LINE_SPEED_NORMAL"] = "正常"
L["LINE_SPEED_FAST"] = "快"
L["LINE_OPACITY"] = "線條不透明度"
L["LINE_OPACITY_DESCRIPTION"] = "圓點的不透明程度；越低，透出的地圖越多。"
-- TRANSLATORS: a popup with an Okay button each time Plan Ahead (PLAN_AHEAD_ZONE) is chosen
L["PREDICTIVE_ROUTES_POPUP"] =
	"提示：提前規劃會預先安排整個區域，所以你的地圖看起來可能有點亂。但亂中有序！跟著任務箭頭走，少跑路，多拿經驗。(="
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_FLIGHTS
L["SHOW_FLIGHT_PATHS"] = "將未發現的飛行點顯示為目標"
L["SHOW_FLIGHT_PATHS_DESCRIPTION"] =
	"把你所在區域中你還沒取得其飛行點的每位飛行管理員加入路線，並以飛行管理員圖示標出。如果角色之前已經擁有飛行點，請先開啟任意飛行地圖一次，讓路線知道你擁有哪些；在此之前不會加入任何飛行點。"
L["LOCAL_QUEST_RANGE"] = "搜尋範圍"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"發布任務者離你多少碼以內才算數。低於 400 時，在兩次路線規劃之間路過的任務發布者可能會被漏掉。"
L["LOCAL_ESCORT_QUESTS"] = "護送任務"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] = "需要一路保護 NPC 的任務，耗時且常需隊伍。"
L["LOCAL_OTHER_ZONE_QUESTS"] = "目標在其他區域的任務"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"有目標或交任務地點只在你所在區域之外的任務，例如讓你前往下一個城鎮的任務。"
L["LOCAL_QUEST_LEVEL"] = "最低任務等級"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	'比你低這麼多級以上的任務不計入。"無限制"也包含灰色任務，以 Questie 顯示的為準。'
L["LOCAL_HIGHEST_QUEST_LEVEL"] = "最高任務等級"
L["LOCAL_HIGHEST_QUEST_LEVEL_DESCRIPTION"] =
	"比你高出這麼多級以上的任務會在地圖上顯示為灰色，並標出它們加入路線的等級，這樣路線不會帶你去仍然太難的任務。"
-- TRANSLATORS: %d is a number of levels, 3, 6 or 9, above or below the player's own
L["LOCAL_LEVELS_ABOVE"] = "比你高 %d 級"
-- TRANSLATORS: Highest Quest Level's choice that leaves off every quest above the player's own level
L["LOCAL_LEVELS_YOUR_LEVEL"] = "你的等級"
L["LOCAL_LEVELS_BELOW"] = "比你低 %d 級"
-- TRANSLATORS: Lowest Quest Level's choice that leaves no quest off for being too low, gray ones included
L["LOCAL_LEVELS_NO_LIMIT"] = "無限制"
-- TRANSLATORS: a section of the Quest Route panel: which quests the route guides you to pick up
L["WHAT_TO_ROUTE_HEADER"] = "路線包含什麼"
L["WHAT_TO_ROUTE_DESCRIPTION"] =
	"你接受的每個任務都會一直在路線上。這些設定決定路線沿途引導你去接哪些任務，以符合你喜歡的解任務方式。"
L["PLAN_AHEAD_HEADER"] = "提前規劃"
L["PLAN_AHEAD_DESCRIPTION"] = "路線向前尋找可接任務的範圍。"
-- TRANSLATORS: Plan Ahead's three choices are also switches on the Quest Arrow's menu
L["PLAN_AHEAD_YOURS"] = "僅你的任務"
L["PLAN_AHEAD_YOURS_DESCRIPTION"] = "只有你任務日誌裡的任務，就像以前的 QuestHelper 插件。"
L["PLAN_AHEAD_NEARBY"] = "你的任務和附近可接任務"
L["PLAN_AHEAD_NEARBY_DESCRIPTION"] = "你附近的任務發布者，作為去接任務的路徑點。"
-- TRANSLATORS: the same words as PLAN_AHEAD_HEADER: the choice that plans the whole zone ahead
L["PLAN_AHEAD_ZONE"] = "提前規劃"
L["PLAN_AHEAD_ZONE_DESCRIPTION"] =
	"整個區域的接任務、目標和交任務，以及後續任務，讓你在前往區域某處之前就接好那裡的所有任務。尚未接受的任務目標顯示為灰色標記。規劃得越遠，計算時間越長。"
L["QUEST_DIFFICULTY_HEADER"] = "任務難度"
L["QUEST_DIFFICULTY_DESCRIPTION"] =
	"路線引導你去接的任務等級。任務日誌裡的任務無論等級都會留在路線上。"
L["QUEST_TYPES_HEADER"] = "沿途要接的任務類型"
L["QUEST_TYPES_DESCRIPTION"] =
	"路線引導你去接的任務類型。未勾選的類型仍會以灰色顯示在地圖上並註明原因，但路線不會帶你去接。"
-- TRANSLATORS: Era and Forever call quests with tag 1 Elite; TBC and later call them Group (PICK_UP_GROUP)
L["PICK_UP_ELITE"] = "精英任務"
L["PICK_UP_ELITE_DESCRIPTION"] = "與你同級的精英任務單人可解；高 4 級的可能需要一兩個朋友。"
L["PICK_UP_GROUP"] = "團體任務"
L["PICK_UP_GROUP_DESCRIPTION"] =
	"為隊伍設計的任務。與你同級的通常單人可解；高幾級的可能需要一兩個朋友。"
L["PICK_UP_PVP"] = "PvP 任務"
L["PICK_UP_PVP_DESCRIPTION"] = "需要你與其他玩家戰鬥，或把你送進戰場的任務。"
L["PICK_UP_DUNGEON"] = "地城任務"
-- TRANSLATORS: PICK_UP_DUNGEON on games with heroic dungeons (TBC and later)
L["PICK_UP_DUNGEON_HEROIC"] = "地城和英雄任務"
L["PICK_UP_RAID"] = "團隊副本任務"
L["PICK_UP_INSTANCE_DESCRIPTION"] = "只引導你去接任務；目標在副本裡面。"
L["ROUTE_FOCUS_HEADER"] = "路線側重"
L["ROUTE_FOCUS_DESCRIPTION"] = "路線如何選擇和安排你要接的任務。"
L["ROUTE_FOCUS_FASTEST"] = "最快完成"
L["ROUTE_FOCUS_FASTEST_DESCRIPTION"] = "你的設定允許的所有任務，走最少的路。"
L["ROUTE_FOCUS_EASIEST"] = "先易後難"
L["ROUTE_FOCUS_EASIEST_DESCRIPTION"] = "在多走不了幾步的情況下，先解較簡單的任務。"
-- TRANSLATORS: Experimental: the option is new and may change
L["ROUTE_FOCUS_XP"] = "每小時最多經驗（實驗性）"
L["ROUTE_FOCUS_XP_DESCRIPTION"] = "跳過路程遠、回報少的任務。這是新功能，歡迎回饋。"
L["ROUTES_PARTY_HEADER"] = "隊伍"
L["ROUTES_PARTY_DESCRIPTION"] = "你的隊伍為路線增加的內容。"
L["PARTY_QUESTS"] = "包含隊友的任務"
L["PARTY_QUESTS_DESCRIPTION"] =
	"在隊伍中，路線和任務箭頭也會包含隊友有而你沒有的任務，顯示方式與你自己的任務相同。雙方都需要裝有 Questie 才能共享這些任務。他們的地城任務會被排除，因為任務目標在地城內。"
L["GROUP_UP"] = "與隊伍會合"
L["GROUP_UP_DESCRIPTION"] =
	'在隊伍中，當你所在區域有任何隊友不在你的小地圖範圍內時，任務箭頭會顯示"與隊伍會合"並指向該隊友，或所有人的中間位置，世界地圖也會標出該位置，方便你們一起解任務。'

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "任務箭頭"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"畫面上的一個箭頭，指向路線上的下一個路徑點，並列出要在那裡完成的任務和目標。將滑鼠游標停在它上面會顯示一個選單，你可以在其中逐一忽略目標，並查看已忽略的項目。中鍵點擊它可重設區域，恢復你在那裡忽略的項目。"
L["QUEST_ARROW_HEADER"] = "箭頭"
L["QUEST_ARROW_DESCRIPTION"] = "任務箭頭的位置和大小。"
L["ARROW_SIZE"] = "箭頭大小"
L["ARROW_SIZE_DESCRIPTION"] = "任務箭頭及其下方文字的大小。"
L["LOCK_ARROW"] = "鎖定任務箭頭"
L["LOCK_ARROW_DESCRIPTION"] = "將任務箭頭固定在原位，拖曳不會有作用。"
L["RESET_ARROW"] = "箭頭位置"
L["RESET_ARROW_CONFIRM"] = "要將任務箭頭移回初始位置嗎？"
L["RESET_ARROW_DESCRIPTION"] = "將任務箭頭放回初始位置，即畫面頂端中間。"
L["QUEST_ARROW_TEXT_HEADER"] = "箭頭下方"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "任務箭頭在下方列出的內容。"
L["SHOW_DISTANCE"] = "顯示距離"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'顯示下一個路徑點還有多少碼。無論是否開啟，都會顯示"%s"和"%s"。'
L["SHOW_ARROW_QUESTS"] = "顯示任務和目標"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"列出下一個路徑點的任務，每個任務都附上在那裡還需要做的事。"
L["QUESTS_LISTED"] = "最多列出任務數"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'任務箭頭在一個路徑點下方最多列出的任務數。其餘的任務會在單獨一行中計數，例如"%s"。'
L["SHOW_ITEM_BUTTONS"] = "顯示任務物品按鈕"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"在任務箭頭列出的每個有可用物品的任務旁放一個按鈕，例如需要投擲、種下或對目標使用的物品。點擊按鈕即可使用該物品，也可以在 Pretty Wide Quest Log 頁面的按鍵設定中為使用任務物品設定按鍵，以使用第一個物品。戰鬥中按鈕會保持原位，直到戰鬥結束。"
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_NEXT_OBJECTIVE
L["SHOW_NEXT_OBJECTIVE"] = "顯示下一個目標"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'在"%s"時，於其下方以暗色列出"%s"：一個指向再下一個路徑點的小箭頭，以及在那裡要做的事。'
L["QUEST_ARROW_HIDING_HEADER"] = "隱藏"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "任務箭頭何時自動隱藏。"
L["HIDE_IN_RAIDS"] = "在團隊中隱藏"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "當你在團隊中時隱藏任務箭頭。"
L["HIDE_IN_INSTANCES"] = "在副本中隱藏"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "在地城、團隊副本和戰場中隱藏任務箭頭。"

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "幫助 Pretty Wide Quest Log 升級"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"這個插件由熱愛這款遊戲、希望讓每個人都玩得盡可能開心的玩家打造。我們永遠不會請求捐款。真正的滿足感來自知道我們的努力讓你的遊戲體驗更好一點。如果真是如此，我們很想聽你說說！"
L["OPTIONS_LEVEL_UP_WAYS"] = "以下是你可以幫助我們接觸更多玩家的幾種方式。"
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• 分享意見：發現錯誤或有新點子？請在 Discord 上告訴我們。你的意見能幫助我們改進插件，也隨時歡迎提交拉取請求。"
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• 告訴朋友：認識可能會喜歡這個插件的人嗎？告訴他們吧。口碑能幫助更多玩家發現優秀的插件。"
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• 在 CurseForge 上收藏：開啟下方的 CurseForge 連結，登入後點擊下載按鈕下方的星號。收藏能幫助更多玩家發現這個插件。"
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• 在 GitHub 上按 Star：開啟下方的 GitHub 連結，登入後點擊右上角的 Star。星號能幫助專案取得更多免費開發者工具的資格。"
L["OPTIONS_LEVEL_UP_THANKS"] = "感謝你選擇 Pretty Wide Quest Log！"
L["OPTIONS_FEEDBACK"] = "意見回饋與支援"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "意見回饋與支援連結"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "要複製連結，請點擊連結框，然後按 Ctrl+A 和 Ctrl+C。"
L["OPTIONS_VERSION"] = "版本 %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "副"
L["QUEST_SUFFIX_RAID"] = "團"
L["QUEST_SUFFIX_PVP"] = "戰"
L["QUEST_SUFFIX_GROUP"] = "組"
L["QUEST_SUFFIX_ELITE"] = "精"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "地城"
L["QUEST_TYPE_RAID"] = "團隊副本"
L["QUEST_TYPE_GROUP"] = "組隊"
L["QUEST_TYPE_ELITE"] = "精英"
L["QUEST_TYPE_PVP"] = "PvP"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "等級後的字：%s。"
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s（%s）"
L["QUEST_ID"] = "任務ID %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "任務鏈（%d/%d）"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "每日任務將在 %s 後重置。"
L["WOWHEAD_LINK_TOOLTIP"] = "點擊取得 Wowhead 連結。"
L["WOWHEAD_LINK_COPY"] = "按 Ctrl+C（Mac 上為 Cmd+C）複製 Wowhead 連結。"
L["EXPAND_ALL"] = "全部展開"
L["COLLAPSE_ALL"] = "全部收合"
L["TRACK_ALL"] = "全部追蹤"
L["UNTRACK_ALL"] = "全部取消追蹤"
L["HIDE_MAP"] = "隱藏地圖"
L["ZONE_INFO_QUESTS"] = "可接任務"
L["ZONE_INFO_ITEMS"] = "需要帶的東西"
-- TRANSLATORS: Zone Info's Things to Bring heading; %s is the zone the box shows, from the client
L["ZONE_INFO_ITEMS_TO"] = "帶到%s的東西"
L["ZONE_INFO_BACK"] = "返回任務"
L["ZONE_INFO_ASK"] = "請求分享"
L["ZONE_INFO_ASK_DESCRIPTION"] =
	"把這裡可分享的任務寫進你的聊天框；若你在 4 號頻道（尋求組隊），就寫在該頻道。按 Enter 前不會送出任何內容。"
-- TRANSLATORS: %s is quest links, or names in brackets, joined by commas; it's written into the chat box, never sent
L["ZONE_INFO_ASK_MESSAGE"] = "有人能分享%s嗎？"
-- TRANSLATORS: %s is a quest giver's name
L["ZONE_INFO_GIVER"] = "發布者：%s"
-- TRANSLATORS: where a quest giver stands: map coordinates ("55,52"), then the zone
L["ZONE_INFO_GIVER_PLACE"] = "%s，%s"
L["ZONE_INFO_SHAREABLE"] = "可分享"
L["ZONE_INFO_NOT_SHAREABLE"] = "不可分享"
-- TRANSLATORS: an item tooltip's heading after "PWQL //"; the quests that need the item are listed under it
L["ZONE_INFO_NEEDED_FOR"] = "需要它的任務"
L["ZONE_INFO_SHIFT_CLICK"] = "Shift-點擊"
L["ZONE_INFO_LINK_ITEM"] = "在聊天中連結"
L["ZONE_INFO_MENU_QUEST"] = "此任務"
L["ZONE_INFO_MENU_HERE"] = "你所在的位置"
L["ZONE_INFO_MENU_LOG"] = "你的任務"
L["ZONE_INFO_MENU_AVAILABLE"] = "適合你的任務最多"
L["ZONE_INFO_NO_QUESTS"] = "沒有可在其他區域為這裡接取的任務。"
L["ZONE_INFO_NO_ITEMS"] = "沒有需要購買或帶上的東西。"
L["ZONE_INFO_WORKING"] = "正在讀取任務..."
-- TRANSLATORS: %d is the item's ID, shown until the client has loaded the item's name
L["ZONE_INFO_ITEM_LOADING"] = "正在載入物品ID：%d"
L["ZONE_INFO_NEEDS_QUESTIE"] = "啟用 Questie 以查看這裡的內容。"
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "%s 經驗"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "回報：%s"
L["TURN_IN_TOOLTIP"] = "可以回報"
L["RESIZE_TOOLTIP"] = "拖曳以調整任務日誌大小。"

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "分享任務"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"把本區域中遊戲允許分享、且有隊友還沒有的任務提供給隊伍，每 %d 秒一個。"
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "戰鬥結束後分享 %s。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "正在分享 %s 的 1 個任務。"
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "正在分享 %d 個任務，來自 %s，每 %d 秒一個。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "%s 中沒有可以分享的任務。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_PARTY_HAS"] = "你的隊伍已經擁有你在 %s 的所有任務。"
-- TRANSLATORS: %s is the zone; printed when new party members are missing 1 of your quests there
L["CHAT_ZONE_SHARE_NOTICE_ONE"] = "你有 1 個可分享的 %s 任務，你的隊伍可能需要。"
-- TRANSLATORS: %d is how many quests, %s is the zone; printed when new party members are missing them
L["CHAT_ZONE_SHARE_NOTICE"] = "你有 %d 個可分享的 %s 任務，你的隊伍可能需要。"

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "已到達"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "路徑點在另一張地圖上"
L["ROUTES_OBJECTIVE_AREA"] = "目前目標範圍"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "完成這裡再繼續"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "路線後面還有"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "下一個目標"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "順路可做"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d碼"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d碼"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "此處還有 +%d 個"
L["ROUTES_TURN_IN"] = "回報任務"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "回報 %s"
L["ROUTES_PICK_UP"] = "接受任務"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "接受 %s"
L["ROUTES_FLIGHT_PATH"] = "取得飛行點"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_FLIGHT_PATH_FROM"] = "從%s處取得飛行點"
-- TRANSLATORS: first %s is the flight master's name, such as "Omusa Thunderhorn"; second is where the flight lands, as the flight map names it, such as "Camp Taurajo"
L["ROUTES_FLY_FROM"] = "與%s交談，飛往%s"
-- TRANSLATORS: %s is where a city's gate leads, the zone around it or the city itself, such as "Durotar" or "Orgrimmar"
L["ROUTES_EXIT_TO"] = "前往%s"
-- TRANSLATORS: under a quest to pick up on the world map, why the route doesn't go there
L["ROUTES_OFF_ROUTE_ESCORT"] = "護送任務，不在路線上"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "通往其他區域，不在路線上"
L["ROUTES_OFF_ROUTE_DUNGEON"] = "地城任務，不在路線上"
L["ROUTES_OFF_ROUTE_RAID"] = "團隊任務，不在路線上"
L["ROUTES_OFF_ROUTE_LOG_FULL"] = "任務日誌已滿，不在路線上"
L["ROUTES_OFF_ROUTE_FAR"] = "超出搜尋範圍，不在路線上"
L["ROUTES_OFF_ROUTE_ELITE"] = "精英任務，不在路線上"
L["ROUTES_OFF_ROUTE_GROUP"] = "團體任務，不在路線上"
L["ROUTES_OFF_ROUTE_PVP"] = "PvP 任務，不在路線上"
-- TRANSLATORS: %d is the player level at which the quest goes on the route
L["ROUTES_OFF_ROUTE_LEVEL"] = "%d 級時加入路線"
L["ROUTES_OFF_ROUTE_XP"] = "路程經驗太少，不在路線上"
-- TRANSLATORS: under a quest to pick up on the map of a zone you are not in; a right-click puts it on the route for when you get there
L["ROUTES_OFF_ROUTE_ZONE"] = "其他區域，尚未加入路線"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"; over a quest's objectives planned before it's picked up
L["ROUTES_AFTER_PICK_UP"] = "接受 %s 後"
-- TRANSLATORS: %s is the quest's title with its level; under a quest to pick up once another is turned in
L["ROUTES_AFTER_TURN_IN"] = "回報 %s 後"
-- TRANSLATORS: as ROUTES_AFTER_PICK_UP, for a party member's quest planned ahead, one you don't have
L["ROUTES_AFTER_PARTY_PICK_UP"] = "隊友接受 %s 後"
-- TRANSLATORS: as ROUTES_AFTER_TURN_IN, for a party member's quest
L["ROUTES_AFTER_PARTY_TURN_IN"] = "隊友回報 %s 後"
L["ROUTES_CORPSE"] = "跑回你的屍體處"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "尋找"
-- TRANSLATORS: the title of the "…" marker's tooltip where the zone map stops drawing the route; in ROUTES_MORE_WAYPOINTS, %d is how many waypoints it hides
L["ROUTES_MORE_WAYPOINT"] = "還有 1 個路徑點"
L["ROUTES_MORE_WAYPOINTS"] = "還有 %d 個路徑點"
L["ROUTES_MORE_WAYPOINTS_DESCRIPTION"] =
	'懸停時顯示的其餘路線。在選項的區域地圖中，用"顯示的路徑點"設定地圖繪製多少個。'
L["ROUTES_CLICK_DRAG"] = "拖曳"
L["ROUTES_CLICK_RIGHT"] = "右鍵點擊"
L["ROUTES_CLICK_MIDDLE"] = "中鍵點擊"
L["ROUTES_CLICK"] = "點擊"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "使用物品"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "使用任務物品"
L["ROUTES_DRAG_MOVE"] = "移動任務箭頭"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "忽略此路徑點"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "忽略此目標"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "放回路線"
-- TRANSLATORS: beside ROUTES_CLICK or ROUTES_CLICK_RIGHT, on Zone Info and on a map marker for a quest to pick up; puts the quest on the route
L["ROUTES_ADD_TO_ROUTE"] = "加入路線"
-- TRANSLATORS: as ROUTES_ADD_TO_ROUTE, for a quest to pick up already put on the route; takes it back off
L["ROUTES_TAKE_OFF_ROUTE"] = "移出路線"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "重設此區域"
-- TRANSLATORS: beside ROUTES_CLICK on the "…" marker's tooltip; the whole route shows until the map closes
L["ROUTES_CLICK_SHOW_ROUTE"] = "顯示完整路線"
-- TRANSLATORS: the rows of a zone's list on the continent and world maps, each with how many quests to pick up there have that level color (as WoW colors quests by level) on the right
L["ROUTES_ZONE_AVAILABLE_RED"] = "可接的紅色任務"
L["ROUTES_ZONE_AVAILABLE_ORANGE"] = "可接的橙色任務"
L["ROUTES_ZONE_AVAILABLE_YELLOW"] = "可接的黃色任務"
L["ROUTES_ZONE_AVAILABLE_GREEN"] = "可接的綠色任務"
L["ROUTES_ZONE_AVAILABLE_GRAY"] = "可接的灰色任務"
-- TRANSLATORS: the zone menu's row counting the group, dungeon and raid quests to pick up, on the continent and world maps
L["ROUTES_ZONE_AVAILABLE_GROUP"] = "可接的地城和組隊任務"
-- TRANSLATORS: the heading over the player's objectives in a zone, on the continent and world maps
L["ROUTES_ZONE_OBJECTIVES"] = "目標"
-- TRANSLATORS: under a zone's objectives, past the first few; %d is how many more it holds
L["ROUTES_ZONE_MORE"] = "還有 %d 個"
-- TRANSLATORS: beside ROUTES_CLICK on a zone's disc on the continent and world maps
L["ROUTES_CLICK_OPEN_ZONE_MAP"] = "開啟區域地圖"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "忽略 %s，直到重設區域。"
-- TRANSLATORS: on the world map while the route is planned again after clicks on its markers
L["ROUTES_REROUTING"] = "正在重新規劃路線..."
L["ROUTES_ZONE_RESET"] = "區域已重設：在此忽略的目標已回到路線上。"
L["ROUTES_GROUP_LEFT_CLEARED"] = "已離開隊伍：已忽略的隊伍目標和隊友已回到路線上。"
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] = "%s 已離開隊伍：為其忽略的目標已回到路線上。"
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_CURRENT"] = "目前目標"
L["ROUTES_MENU_IGNORE"] = "忽略"
L["ROUTES_MENU_SECTION_ROUTE"] = "路線"
L["ROUTES_MENU_SECTION_SHOW"] = "顯示"
L["ROUTES_MENU_SECTION_ALSO_ROUTE"] = "同時加入路線"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "下一個"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "恢復"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "已忽略"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "回報 %s"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "接受 %s"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_MENU_FLIGHT_PATH"] = "%s飛行點"
-- TRANSLATORS: %s is where the flight lands, such as "Camp Taurajo"
L["ROUTES_MENU_FLY"] = "飛往%s"
-- TRANSLATORS: %s is where a city's gate leads, such as "Durotar"
L["ROUTES_MENU_EXIT"] = "通往%s"
L["ROUTES_MENU_SHOWN_FLIGHTS"] = "飛行點"
L["ROUTES_MENU_SHOWN_PARTY"] = "隊友目標"
L["ROUTES_MENU_ON"] = "開啟"
L["ROUTES_MENU_OFF"] = "關閉"
L["ROUTES_MENU_OUT_OF_ZONE"] = "不在本區域"
L["ROUTES_MENU_NO_QUESTIE"] = "無 Questie"
L["ROUTES_MENU_OFFLINE"] = "離線"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "%s 的目標"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "忽略 %s（%s），直到重設區域。"
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] = "忽略 %s（%s），直到有該任務的隊友離開隊伍。"
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s 已回到路線上。"
-- TRANSLATORS: %s is a quest link
L["ROUTES_ADDED"] = "%s 已加入路線，直到重設區域。"
-- TRANSLATORS: %s is a quest link
L["ROUTES_REMOVED"] = "%s 已移出路線。"
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "%s 的目標已移出路線。"
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "%s 的目標已回到路線上。"
-- TRANSLATORS: on the Quest Arrow and the world map's marker, while it points to where to join up with your party
L["ROUTES_GROUP_UP"] = "與隊伍會合"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them,
	and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"我剛才想把 %s 分享給你，但沒成功。如果需要，等你準備好時叫我一聲，我再分享一次"
L["WHISPER_SHARE_FAILED_AGAIN"] = "%s 也一樣"
L["DUNGEON_QUESTS_ANNOUNCE"] = "我在這裡還有 %d 個任務要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "我在這裡還有 1 個任務要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "我在這裡還有更多任務要做：%s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] = "Questie 追蹤器無法顯示 %s，因為 Questie 資料庫中缺少該任務。"
L["QUESTIE_CANNOT_TRACK"] = "Questie 暫時無法追蹤此任務。"
