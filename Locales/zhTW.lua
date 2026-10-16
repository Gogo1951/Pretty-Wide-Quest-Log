local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "zhTW")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"版本 %s。設定（包括關閉此訊息的選項）位於 選項 > 插件 > Pretty Wide Quest Log。喜歡這個插件嗎？推薦給朋友，在 CurseForge 上收藏，或在 GitHub 上按 Star 吧。(="
L["CHAT_OPTIONS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟設定介面。"
L["CHAT_QUESTIE_MISSING"] =
	"本插件的許多功能仰賴 Questie 的資料，因此沒有 Questie 時部分功能會受限。"
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus 也已啟用，兩者會互相搶奪任務日誌。請在插件列表中停用 Wide Quest Log Plus，然後重新載入介面。"

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"寬版雙欄任務日誌，可調整大小，顯示任務等級、地城與精英標籤、獎勵、任務鏈，並為每個任務顯示地圖。與隊伍分享任務，自動通報地城任務。相容 Questie、VoiceOver 和 ElvUI。"
L["ENABLE_WELCOME_MESSAGE"] = "啟用歡迎訊息"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "登入時顯示 Pretty Wide Quest Log 的歡迎詞。"
L["OPTIONS_FEATURES_HEADER"] = "功能"
L["ENABLE_QUEST_LOG_CLEANUP"] = "啟用任務日誌整理"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"將暴雪任務日誌換成寬版任務日誌，地圖就在旁邊。重新載入介面後生效。"
L["ENABLE_QUALITY_OF_LIFE"] = "啟用便利功能"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"開啟任務NPC視窗整理、自訂分享任務的節奏、分享任務失敗時的密語，以及地城任務的通報和分享。關閉後恢復暴雪的任務NPC視窗，並以預設節奏分享。"
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"啟用任務日誌整理需要重新載入介面才會生效，關閉設定介面時會提示你重新載入。"
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log 需要重新載入介面才能切換任務日誌。現在重新載入嗎？"
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的設定介面。"

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG"] = "任務日誌"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"以寬版任務日誌取代暴雪任務日誌：任務依區域列出，旁邊顯示所選任務的詳細資訊及其地圖。"
L["QUEST_LOG_LAYOUT_HEADER"] = "任務日誌版面"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"依你的玩法排列任務，選擇每列顯示的內容，並調整視窗和地圖大小以符合你的螢幕。"
L["ZONE_ORDER"] = "區域順序"
L["ZONE_ORDER_DESCRIPTION"] = "變更任務清單中區域的順序。"
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "平均等級，由高到低（預設）"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "平均等級，由低到高"
L["SORT_ALPHABETICAL"] = "依名稱"
L["CURRENT_ZONE_FIRST"] = "優先顯示目前區域"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] = "無論區域順序為何，都將你所在的區域置於清單頂端。"
L["ZONE_GAP"] = "區域名稱上方留空"
L["ZONE_GAP_DESCRIPTION"] =
	"在每個區域名稱上方留出一點間距。如果你的任務分散在許多區域，會很方便。"
L["QUEST_ORDER"] = "任務順序"
L["QUEST_ORDER_DESCRIPTION"] = "變更每個區域下任務的順序。"
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "等級，由高到低（預設）"
L["SORT_LEVEL_LOWEST"] = "等級，由低到高"
L["COMPLETED_FIRST"] = "優先顯示已完成任務"
L["COMPLETED_FIRST_DESCRIPTION"] = "將可以回報的任務移到所在區域的頂端。"
L["SHOW_QUEST_LEVELS"] = "顯示任務等級"
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"在清單中每個任務名稱前顯示其等級和類型，例如 [40副] 表示40級地城任務。"
L["MARK_UNTRACKED"] = "標記未追蹤的任務"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"已追蹤的任務不再顯示勾號 %s，改為在未追蹤的任務前顯示眼睛 %s。如果你幾乎追蹤所有任務，會很方便。"
L["CLOSE_IN_COMBAT"] = "戰鬥開始時關閉"
L["CLOSE_IN_COMBAT_DESCRIPTION"] = "戰鬥開始時關閉任務日誌，避免遮住戰鬥畫面。"
L["WINDOW_SCALE"] = "任務日誌縮放"
L["WINDOW_SCALE_DESCRIPTION"] = "放大或縮小任務日誌。旁邊的地圖會隨之一起縮放。"
L["MAP_SCALE"] = "地圖縮放"
L["MAP_SCALE_DESCRIPTION"] = "在任務日誌縮放的基礎上，放大或縮小任務日誌旁的地圖。"
L["RESET_WINDOW"] = "重設大小和位置"
L["RESET_WINDOW_DESCRIPTION"] = "將任務日誌恢復為預設大小和位置。"
L["RESET_WINDOW_CONFIRM"] = "要將任務日誌重設為預設大小和位置嗎？"

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "便利功能"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"任務日誌之外的小幫手，用於任務NPC視窗、與隊友分享任務以及地城。"
L["QUEST_GIVERS_HEADER"] = "任務NPC"
L["QUEST_GIVERS_DESCRIPTION"] = "任務NPC開啟的視窗，你在這裡接受和回報任務。"
L["GIVER_CLEANUP"] = "任務NPC視窗整理"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"讓任務NPC視窗的文字排版與任務日誌一致，使用相同的標題和行距，並在任務下方顯示連結到 Wowhead 的任務ID。"
L["GIVER_LEVELS"] = "顯示任務等級"
L["GIVER_LEVELS_DESCRIPTION"] = "在任務NPC的任務清單中加上任務日誌的等級標籤，例如 [40副]。"
L["QUEST_SHARING_HEADER"] = "任務分享"
L["QUEST_SHARING_DESCRIPTION"] =
	"在任務日誌中右鍵點擊區域，選單裡的分享任務會把該區域中遊戲允許分享的每個任務逐一分享給隊伍。這些選項設定分享的節奏，以及隊友錯過任務時該怎麼辦。"
L["SHARE_INTERVAL"] = "分享間隔秒數"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"分享一個任務後到下一個任務之間的等待時間，適用於分享任務和地城任務分享。時間越長，隊友就有越多時間接受每個任務。"
L["SHARE_WHISPERS"] = "分享失敗時密語"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"當隊友正忙、距離太遠或任務日誌已滿時，密語告訴對方你嘗試分享的任務，並請對方提醒你。如果對方無法接受該任務，則不傳送任何訊息。"
L["OPTIONS_EXAMPLE"] = "範例："
L["OPTIONS_EXAMPLE_QUEST_NAME"] = "任務名稱"
L["DUNGEON_QUESTS_HEADER"] = "地城任務"
L["DUNGEON_QUESTS_DESCRIPTION"] =
	"當你和隊伍進入地城或團隊副本時觸發，每支隊伍在每個地城只觸發一次。任務日誌中列在該地城下的任務都算在內；裝有Questie時，任何目標位於其中的任務也算，職業任務也能找到。"
L["DUNGEON_ANNOUNCE"] = "地城任務自動通報"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"告訴隊友你在剛進入的地城裡還有哪些任務要做，讓大家知道要留意什麼。可以回報的任務不會列出。"
L["DUNGEON_SHARE"] = "地城任務自動分享"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"依任務分享中設定的節奏，分享該地城裡所有遊戲允許分享的任務。開啟分享失敗時密語後，錯過分享的隊友會收到密語，可以再找你要。有人加入或離開隊伍時會再次分享。"

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

L["QUEST_SUFFIX_DUNGEON"] = "副"
L["QUEST_SUFFIX_RAID"] = "團"
L["QUEST_SUFFIX_PVP"] = "戰"
L["QUEST_SUFFIX_GROUP"] = "組"
L["QUEST_SUFFIX_ELITE"] = "精"
L["QUEST_ID"] = "任務ID %d"
L["QUEST_CHAIN"] = "任務鏈"
L["DAILY_RESET"] = "每日任務將在 %s 後重置。"
L["WOWHEAD_LINK_TOOLTIP"] = "點擊取得 Wowhead 連結。"
L["WOWHEAD_LINK_COPY"] = "按 Ctrl+C（Mac 上為 Cmd+C）複製 Wowhead 連結。"
L["EXPAND_ALL"] = "全部展開"
L["COLLAPSE_ALL"] = "全部收合"
L["TRACK_ALL"] = "全部追蹤"
L["UNTRACK_ALL"] = "全部取消追蹤"
L["HIDE_MAP"] = "隱藏地圖"
L["TURN_IN_XP"] = "%s 經驗"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "回報：%s"
L["TURN_IN_TOOLTIP"] = "可以回報"
L["RESIZE_TOOLTIP"] = "拖曳以調整任務日誌大小。"

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_HINT"] = "右鍵點擊查看更多選項"
L["SHARE_ZONE_QUESTS"] = "分享 %d 個任務"
L["SHARE_ZONE_QUEST"] = "分享 1 個任務"
L["SHARE_ZONE_QUESTS_TOOLTIP"] = "把本區域中遊戲允許分享的任務分享給隊伍，每 %d 秒一個。"
L["SHARE_ZONE_QUEST_TOOLTIP"] = "把本區域中遊戲允許分享的那一個任務分享給隊伍。"
L["CHAT_SHARING_ZONE_ONE"] = "正在分享 %s 的 1 個任務。"
L["CHAT_SHARING_ZONE"] = "正在分享 %d 個任務，來自 %s，每 %d 秒一個。"
L["ABANDON_GRAY_QUESTS"] = "放棄灰色任務"
L["ABANDON_GRAY_NONE"] = "此區域沒有可放棄的灰色任務。"
L["ABANDON_GRAY_CONFIRM"] = "要放棄這 %d 個灰色任務嗎？"
L["ABANDON_GRAY_CONFIRM_ONE"] = "要放棄這個灰色任務嗎？"
L["CHAT_ABANDONED_GRAY"] = "已放棄 %d 個灰色任務。"
L["CHAT_ABANDONED_GRAY_ONE"] = "已放棄 1 個灰色任務。"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_FAILED"] =
	"我剛才想把 %s 分享給你，但沒成功。如果需要，等你準備好時叫我一聲，我再分享一次。"
L["WHISPER_SHARE_FAILED_AGAIN"] = "%s 也一樣。"
L["DUNGEON_QUESTS_ANNOUNCE"] = "我在這裡還有 %d 個任務要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "我在這裡還有 1 個任務要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_MORE"] = "%s"
L["DUNGEON_QUESTS_SEPARATOR"] = "、"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] = "Questie 追蹤器無法顯示 %s，因為 Questie 資料庫中缺少該任務。"
L["QUESTIE_CANNOT_TRACK"] = "Questie 暫時無法追蹤此任務。"
