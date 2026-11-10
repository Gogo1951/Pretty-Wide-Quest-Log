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
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"沒有 Questie 時，任務地圖顯示的內容會變少，任務鏈和回報總計也會隱藏。請在插件列表中啟用 Questie 以顯示它們。"
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus 也已啟用，兩者會互相搶奪任務日誌。請在插件列表中停用 Wide Quest Log Plus，然後重新載入介面。"

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"附任務路線與任務箭頭的寬版任務日誌。你挑選任務，我們幫你規劃一條清楚的路線，快速完成。任務等級、標籤、獎勵、任務鏈、任務地圖，以及與隊伍分享任務。相容 Questie、Spoken、VoiceOver 和 ElvUI。"
L["ENABLE_WELCOME_MESSAGE"] = "啟用歡迎訊息"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "登入時顯示 Pretty Wide Quest Log 的歡迎訊息。"
L["OPTIONS_FEATURES_HEADER"] = "功能"
L["ENABLE_WIDE_QUEST_LOG"] = "啟用寬版任務日誌"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"將暴雪任務日誌換成寬版任務日誌，地圖就在旁邊。重新載入介面後生效。"
L["ENABLE_QUALITY_OF_LIFE"] = "啟用便利功能"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"整理任務NPC視窗，並幫助隊友接到你的任務：分享節奏、分享未送達時的密語，以及地城任務的通報和分享。即使關閉此項，任務日誌中每個區域的分享任務按鈕仍然可用。"
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
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的設定介面。"

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "寬版任務日誌"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"以寬版任務日誌取代暴雪任務日誌：任務依區域列出，旁邊顯示所選任務的詳細資訊及其地圖。"
L["QUEST_LOG_SORTING_HEADER"] = "排序"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "選擇區域及其下任務的順序。"
L["QUEST_LOG_ROWS_HEADER"] = "任務列"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "選擇每列顯示的內容。"
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "視窗與地圖"
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
L["WINDOW_SCALE"] = "任務日誌縮放"
L["WINDOW_SCALE_DESCRIPTION"] = "放大或縮小任務日誌。旁邊的地圖會隨之一起縮放。"
L["MAP_SCALE"] = "地圖縮放"
L["MAP_SCALE_DESCRIPTION"] = "在任務日誌縮放的基礎上，放大或縮小任務日誌旁的地圖。"
L["RESET_WINDOW_BUTTON"] = "重設視窗"
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

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "便利功能"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"任務日誌本身之外的小幫手：用於任務NPC視窗、與隊友分享任務以及地城。"
L["QUEST_GIVERS_HEADER"] = "任務NPC"
L["QUEST_GIVERS_DESCRIPTION"] = "任務NPC開啟的視窗，你在這裡接受和回報任務。"
L["GIVER_CLEANUP"] = "任務NPC視窗整理"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"讓任務NPC視窗的文字排版與任務日誌一致，使用相同的標題和行距，並在任務下方顯示連結到 Wowhead 的任務ID。"
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] = "在任務NPC的任務清單中加上任務日誌的等級標籤，例如 %s。"
L["QUEST_SHARING_HEADER"] = "任務分享"
L["QUEST_SHARING_INTRO"] =
	"在任務日誌中將滑鼠游標停在區域名稱上並點擊分享任務按鈕，即可把該區域中你能分享的所有任務逐一分享給隊伍。這些選項設定分享的節奏，以及有人錯過任務時該怎麼辦。"
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"區域名稱上的分享任務按鈕需要啟用寬版任務日誌。地城任務分享無需此項即可使用。"
L["SHARE_INTERVAL"] = "分享間隔秒數"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"分享一個任務後到下一個任務之間的等待時間，適用於分享區域或地城的任務時。時間越長，隊友就有越多時間接受每個任務。"
L["SHARE_WHISPERS"] = "分享失敗時密語"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"當隊友正忙、距離太遠或任務日誌已滿時，密語告訴對方你嘗試分享的任務，並請對方提醒你。如果對方不符合任務條件、已經接了該任務或已經完成，則不傳送任何訊息。"
L["SAMPLE_EXAMPLE"] = "範例：%s"
L["SAMPLE_QUEST_LOADING"] = "正在載入任務ID：%d"
L["DUNGEON_QUESTS_HEADER"] = "地城任務"
L["DUNGEON_QUESTS_INTRO"] =
	"當你和隊伍進入地城時，會在所有人都進入範圍後（在 WoW Forever 上立即）通報並分享你在其中的任務，且不會對同一支隊伍進行兩次。裝有 Questie 時，目標位於其中的任務也算在內，包括職業任務。在團隊中不會進行。"
L["DUNGEON_ANNOUNCE"] = "地城任務自動通報"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"告訴隊友你在剛進入的地城裡還有哪些任務要做，讓大家知道要留意什麼。可以回報的任務不會列出。"
L["DUNGEON_SHARE"] = "地城任務自動分享"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"依任務分享中設定的節奏，在所有人都進入範圍後（或一分鐘後；在 WoW Forever 上立即）分享該地城裡所有遊戲允許分享的任務。每位隊友在每個地城只會收到一次，所以之後加入的人也會收到，而離開再進入不會再次分享。開啟分享失敗時密語後，錯過分享的隊友會收到密語，可以再找你要。"

--------------------------------------------------------------------------------
-- Options: Waypoint Markers Panel
--------------------------------------------------------------------------------

L["TAB_WAYPOINT_MARKERS"] = "路徑點標記"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"區域地圖上每個任務目標和回報地點各一個標記，取代成堆的任務圖示。"
L["ROUTES_MAP_HEADER"] = "區域地圖"
L["ROUTES_MAP_DESCRIPTION"] = "區域地圖顯示路線時的開啟方式。"
L["FULL_SIZE_MAP"] = "以最大尺寸開啟區域地圖"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"像地圖本身的最大化按鈕一樣，以最大化狀態開啟區域地圖，讓路線有足夠空間。即使你把地圖縮小，下次也會再次以最大尺寸開啟。"
L["HIDE_QUESTIE_ICONS"] = "隱藏路線上的任務圖示"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"隱藏路線上目標的 Questie 地圖圖示，以及暴雪內建的任務標識和目標區域，由路線標記代替顯示。隊友目標的 Questie 半透明圖示也會隱藏。將滑鼠游標停在標記上可查看 Questie 圖示。"
L["ROUTES_MARKERS_HEADER"] = "標記"
L["ROUTES_MARKERS_DESCRIPTION"] = "路線上每個路徑點的標記。"
L["MARKER_SIZE"] = "標記大小"
L["MARKER_SIZE_DESCRIPTION"] = "路線標記在區域地圖上的大小。"
L["MARKER_SIZE_SMALL"] = "小"
L["MARKER_SIZE_MEDIUM"] = "中"
L["MARKER_SIZE_LARGE"] = "大"
L["MARKER_SIZE_HUGE"] = "特大"

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "任務路線"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"區域地圖上的一條路線，從你所在的位置出發，按完成順序經過你的路徑點標記。"
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"任務路線連接各個路徑點標記，因此只有在啟用路徑點標記開啟時才會顯示。"
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
L["ROUTES_PARTY_HEADER"] = "隊伍"
L["ROUTES_PARTY_DESCRIPTION"] = "你的隊伍為路線增加的內容。"
L["PARTY_QUESTS"] = "包含隊友的任務"
L["PARTY_QUESTS_DESCRIPTION"] =
	"在隊伍中，路線和任務箭頭也會包含隊友有而你沒有的任務，顯示方式與你自己的任務相同。雙方都需要裝有 Questie 才能共享這些任務。他們的地城任務會被排除，因為任務目標在地城內。"

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
L["RESET_ARROW_BUTTON"] = "重設"
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
	"在任務箭頭列出的每個有可用物品的任務旁放一個按鈕，例如需要投擲、種下或對目標使用的物品。點擊按鈕即可使用該物品，也可以在遊戲的按鍵設定中為使用任務物品設定按鍵，以使用第一個物品。戰鬥中按鈕會保持原位，直到戰鬥結束。"
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_NEXT_OBJECTIVE"] = "顯示下一個目標"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'在"%s"時，於其下方以暗色列出"%s"：一個指向再下一個路徑點的小箭頭，以及在那裡要做的事。'
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_UPCOMING_TURN_INS"] = "顯示將來交付的任務"
L["SHOW_UPCOMING_TURN_INS_DESCRIPTION"] =
	"在任務目標完成之前就把交任務的地點加入路線，並以 Questie 的灰色問號標出，讓你看到將在哪裡交付。關閉後，任務完成時才會把交付地點加入路線。"
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_LOCAL_QUESTS"] = "將附近可接任務顯示為目標"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"把你能接的任務加入路線：Questie 顯示為可接，且發布任務的 NPC 或物件在 %s以內，並以 Questie 的驚嘆號標出。由掉落物品開始的任務以及地城和團隊副本任務不會加入。"
L["LOCAL_QUESTS_HEADER"] = "附近可接任務"
L["LOCAL_QUESTS_DESCRIPTION"] =
	"任務箭頭會帶你去哪些附近的任務。被跳過的任務仍可顯示在世界地圖上，但沒有路線連到那裡。"
L["LOCAL_QUEST_RANGE"] = "搜尋範圍"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"發布任務者離你多少碼以內才算數。低於 400 時，在兩次路線規劃之間路過的任務發布者可能會被漏掉。"
L["LOCAL_QUESTS_WHAT_COUNTS"] = "計入哪些"
L["LOCAL_ESCORT_QUESTS"] = "護送任務"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] =
	"需要一路保護 NPC 的任務，耗時且常需隊伍。它們在地圖上的標記為綠色。"
L["LOCAL_GROUP_QUESTS"] = "團隊和精英任務"
L["LOCAL_GROUP_QUESTS_DESCRIPTION"] = "Questie 標為精英、適合組隊的任務。"
L["LOCAL_OTHER_ZONE_QUESTS"] = "目標在其他區域"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"有目標或交任務地點只在你所在區域之外的任務，例如讓你前往下一個城鎮的任務。"
L["LOCAL_QUEST_LEVEL"] = "最低任務等級"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	"低於此難度顏色的任務不計入。「Questie 設定」保留 Questie 在其地圖上顯示的任務。"
L["LOCAL_CHOICE_ROUTE"] = "加入路線"
L["LOCAL_CHOICE_MAP"] = "僅地圖"
L["LOCAL_CHOICE_OFF"] = "不計入"
L["LOCAL_LEVEL_QUESTIE"] = "Questie 設定"
L["LOCAL_LEVEL_GREEN"] = "綠色及以上"
L["LOCAL_LEVEL_YELLOW"] = "黃色及以上"
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
L["SHARE_ZONE_QUESTS_TOOLTIP"] = "把本區域中遊戲允許分享的任務分享給隊伍，每 %d 秒一個。"
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "戰鬥結束後分享 %s。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "正在分享 %s 的 1 個任務。"
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "正在分享 %d 個任務，來自 %s，每 %d 秒一個。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "%s 中沒有可以分享的任務。"

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
L["ROUTES_OFF_ROUTE_ESCORT"] = "護送任務，不在路線上"
L["ROUTES_OFF_ROUTE_GROUP"] = "組隊任務，不在路線上"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "通往其他區域，不在路線上"
L["ROUTES_CORPSE"] = "跑回你的屍體處"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "尋找"
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
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "重設此區域"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "忽略 %s，直到重設區域。"
L["ROUTES_ZONE_RESET"] = "區域已重設：在此忽略的目標已回到路線上。"
L["ROUTES_GROUP_LEFT_CLEARED"] = "已離開隊伍：已忽略的隊伍目標和隊友已回到路線上。"
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] = "%s 已離開隊伍：為其忽略的目標已回到路線上。"
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "忽略"
L["ROUTES_MENU_SECTION_SHOWN"] = "顯示內容"
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
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_SHOWN; Next Objective is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_TURN_INS"] = "將來交付的任務"
L["ROUTES_MENU_SHOWN_LOCAL"] = "附近可接任務"
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
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "%s 的目標已移出路線。"
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "%s 的目標已回到路線上。"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them, and each %d is how many quests
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
