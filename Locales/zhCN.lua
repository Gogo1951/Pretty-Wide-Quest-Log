local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "zhCN")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"版本 %s。设置（包括关闭此消息的选项）位于 选项 > 插件 > Pretty Wide Quest Log。喜欢这个插件吗？推荐给朋友，在 CurseForge 上收藏，或在 GitHub 上点 Star 吧。(="
L["CHAT_OPTIONS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开设置界面。"
L["CHAT_QUESTIE_MISSING"] =
	"本插件的许多功能依赖 Questie 的数据，因此没有 Questie 时部分功能会受限。"
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus 也已启用，两者会争夺任务日志。请在插件列表中禁用 Wide Quest Log Plus，然后重新加载界面。"

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"宽版双栏任务日志，可调整大小，显示任务等级、地下城与精英标签、奖励、任务链，并为每个任务显示地图。与队伍分享任务，自动通报地下城任务。兼容 Questie、VoiceOver 和 ElvUI。"
L["ENABLE_WELCOME_MESSAGE"] = "启用欢迎消息"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "登录时显示 Pretty Wide Quest Log 的欢迎语。"
L["OPTIONS_FEATURES_HEADER"] = "功能"
L["ENABLE_WIDE_QUEST_LOG"] = "启用宽版任务日志"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"将暴雪任务日志换成宽版任务日志，地图就在旁边。重新加载界面后生效。"
L["ENABLE_QUALITY_OF_LIFE"] = "启用便利功能"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"开启任务NPC窗口整理、自定义分享任务的节奏、分享任务失败时的密语，以及地下城任务的通报和分享。关闭后恢复暴雪的任务NPC窗口，并按默认节奏分享。"
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"启用宽版任务日志需要重新加载界面才能生效，关闭设置界面时会提示你重新加载。"
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log 需要重新加载界面才能切换任务日志。现在重新加载吗？"
L["OPTIONS_COMMANDS_HEADER"] = "/命令"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开此插件的设置界面。"

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG_DESCRIPTION"] =
	"用宽版任务日志替换暴雪任务日志：任务按区域列出，旁边显示所选任务的详情及其地图。"
L["QUEST_LOG_LAYOUT_HEADER"] = "任务日志布局"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"按你的玩法排列任务，选择每行显示的内容，并调整窗口和地图大小以适合你的屏幕。"
L["ZONE_ORDER"] = "区域顺序"
L["ZONE_ORDER_DESCRIPTION"] = "更改任务列表中区域的顺序。"
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "平均等级，从高到低（默认）"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "平均等级，从低到高"
L["SORT_ALPHABETICAL"] = "按名称"
L["CURRENT_ZONE_FIRST"] = "优先显示当前区域"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] = "无论区域顺序如何，都将你所在的区域置于列表顶部。"
L["ZONE_GAP"] = "在区域名称上方添加空白"
L["ZONE_GAP_DESCRIPTION"] =
	"在每个区域名称上方留出一点间距。如果你的任务分布在许多区域，会很方便。"
L["QUEST_ORDER"] = "任务顺序"
L["QUEST_ORDER_DESCRIPTION"] = "更改每个区域下任务的顺序。"
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "等级，从高到低（默认）"
L["SORT_LEVEL_LOWEST"] = "等级，从低到高"
L["COMPLETED_FIRST"] = "优先显示已完成任务"
L["COMPLETED_FIRST_DESCRIPTION"] = "将可以交付的任务移到所在区域的顶部。"
L["SHOW_QUEST_LEVELS"] = "显示任务等级"
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"在列表中每个任务名称前显示其等级和类型，例如 [40副] 表示40级地下城任务。"
L["MARK_UNTRACKED"] = "标记未追踪的任务"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"已追踪的任务不再显示对勾 %s，改为在未追踪的任务前显示眼睛 %s。如果你几乎追踪所有任务，会很方便。"
L["CLOSE_IN_COMBAT"] = "战斗开始时关闭"
L["CLOSE_IN_COMBAT_DESCRIPTION"] = "战斗开始时关闭任务日志，避免遮挡战斗画面。"
L["SHOW_OBJECTIVE_AREAS"] = "显示目标范围"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"在任务日志旁的地图上，用阴影标出每个目标的怪物和物体所在的范围，每个范围只显示一个图标，而不是每个刷新点各显示一个。需要 Questie。"
L["WINDOW_SCALE"] = "任务日志缩放"
L["WINDOW_SCALE_DESCRIPTION"] = "放大或缩小任务日志。旁边的地图会随之一起缩放。"
L["MAP_SCALE"] = "地图缩放"
L["MAP_SCALE_DESCRIPTION"] = "在任务日志缩放的基础上，放大或缩小任务日志旁的地图。"
L["RESET_WINDOW"] = "重置大小和位置"
L["RESET_WINDOW_DESCRIPTION"] = "将任务日志恢复为默认大小和位置。"
L["RESET_WINDOW_CONFIRM"] = "将任务日志重置为默认大小和位置？"

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "便利功能"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"任务日志之外的小帮手，用于任务NPC窗口、与队友分享任务以及地下城。"
L["QUEST_GIVERS_HEADER"] = "任务NPC"
L["QUEST_GIVERS_DESCRIPTION"] = "任务NPC打开的窗口，你在这里接受和交付任务。"
L["GIVER_CLEANUP"] = "任务NPC窗口整理"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"让任务NPC窗口的文字排版与任务日志一致，使用相同的标题和行距，并在任务下方显示链接到 Wowhead 的任务ID。"
L["GIVER_LEVELS"] = "显示任务等级"
L["GIVER_LEVELS_DESCRIPTION"] = "在任务NPC的任务列表中加上任务日志的等级标签，例如 [40副]。"
L["QUEST_SHARING_HEADER"] = "任务分享"
L["QUEST_SHARING_DESCRIPTION"] =
	"在任务日志中右键点击区域，菜单里的分享任务会把该区域中游戏允许分享的每个任务逐一分享给队伍。这些选项设置分享的节奏，以及队友错过任务时该怎么办。"
L["SHARE_INTERVAL"] = "分享间隔秒数"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"分享一个任务后到下一个任务之间的等待时间，适用于分享任务和地下城任务分享。时间越长，队友就有越多时间接受每个任务。"
L["SHARE_WHISPERS"] = "分享失败时密语"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"当队友正忙、距离太远或任务日志已满时，密语告诉对方你尝试分享的任务，并请对方提醒你。如果对方无法接受该任务，则不发送任何消息。"
L["OPTIONS_EXAMPLE"] = "示例："
L["OPTIONS_EXAMPLE_QUEST_NAME"] = "任务名称"
L["DUNGEON_QUESTS_HEADER"] = "地下城任务"
L["DUNGEON_QUESTS_DESCRIPTION"] =
	"当你和队伍进入地下城或团队副本时触发，每支队伍在每个地下城只触发一次。任务日志中列在该地下城下的任务都算在内；装有Questie时，任何目标位于其中的任务也算，职业任务也能找到。"
L["DUNGEON_ANNOUNCE"] = "地下城任务自动通报"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"告诉队友你在刚进入的地下城里还有哪些任务要做，让大家知道要留意什么。可以交付的任务不会列出。"
L["DUNGEON_SHARE"] = "地下城任务自动分享"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"按任务分享中设定的节奏，分享该地下城里所有游戏允许分享的任务。开启分享失败时密语后，错过分享的队友会收到密语，可以再找你要。有人加入或离开队伍时会再次分享。"

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "帮助 Pretty Wide Quest Log 升级"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"这个插件由热爱这款游戏、希望让每个人都玩得尽可能开心的玩家打造。我们永远不会请求捐赠。真正的满足感来自知道我们的工作让你的游戏体验更好一点。如果确实如此，我们很想听你说说！"
L["OPTIONS_LEVEL_UP_WAYS"] = "以下是你可以帮助我们触及更多玩家的几种方式。"
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• 分享反馈：发现了错误或有新点子？请在 Discord 上告诉我们。你的反馈能帮助我们改进插件，也随时欢迎提交拉取请求。"
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• 告诉朋友：认识可能会喜欢这个插件的人吗？告诉他们吧。口碑能帮助更多玩家发现优秀的插件。"
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• 在 CurseForge 上收藏：打开下方的 CurseForge 链接，登录后点击下载按钮下方的星标。收藏能帮助更多玩家发现这个插件。"
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• 在 GitHub 上点 Star：打开下方的 GitHub 链接，登录后点击右上角的 Star。星标能帮助项目获得更多免费开发者工具的资格。"
L["OPTIONS_LEVEL_UP_THANKS"] = "感谢你选择 Pretty Wide Quest Log！"
L["OPTIONS_FEEDBACK"] = "反馈与支持"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "反馈与支持链接"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "要复制链接，请点击链接框，然后按 Ctrl+A 和 Ctrl+C。"
L["OPTIONS_VERSION"] = "版本 %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "副"
L["QUEST_SUFFIX_RAID"] = "团"
L["QUEST_SUFFIX_PVP"] = "战"
L["QUEST_SUFFIX_GROUP"] = "组"
L["QUEST_SUFFIX_ELITE"] = "精"
L["QUEST_ID"] = "任务ID %d"
L["QUEST_CHAIN"] = "任务链"
L["DAILY_RESET"] = "日常任务将在 %s 后重置。"
L["WOWHEAD_LINK_TOOLTIP"] = "点击获取 Wowhead 链接。"
L["WOWHEAD_LINK_COPY"] = "按 Ctrl+C（Mac 上为 Cmd+C）复制 Wowhead 链接。"
L["EXPAND_ALL"] = "全部展开"
L["COLLAPSE_ALL"] = "全部折叠"
L["TRACK_ALL"] = "全部追踪"
L["UNTRACK_ALL"] = "全部取消追踪"
L["HIDE_MAP"] = "隐藏地图"
L["TURN_IN_XP"] = "%s 经验"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "交付：%s"
L["TURN_IN_TOOLTIP"] = "可以交付"
L["RESIZE_TOOLTIP"] = "拖动以调整任务日志大小。"

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_HINT"] = "右键点击查看更多选项"
L["SHARE_ZONE_QUESTS"] = "分享 %d 个任务"
L["SHARE_ZONE_QUEST"] = "分享 1 个任务"
L["SHARE_ZONE_QUESTS_TOOLTIP"] = "把本区域中游戏允许分享的任务分享给队伍，每 %d 秒一个。"
L["SHARE_ZONE_QUEST_TOOLTIP"] = "把本区域中游戏允许分享的那一个任务分享给队伍。"
L["CHAT_SHARING_ZONE_ONE"] = "正在分享 %s 的 1 个任务。"
L["CHAT_SHARING_ZONE"] = "正在分享 %d 个任务，来自 %s，每 %d 秒一个。"
L["ABANDON_GRAY_QUESTS"] = "放弃灰色任务"
L["ABANDON_GRAY_NONE"] = "该区域没有可放弃的灰色任务。"
L["ABANDON_GRAY_CONFIRM"] = "放弃这 %d 个灰色任务吗？"
L["ABANDON_GRAY_CONFIRM_ONE"] = "放弃这个灰色任务吗？"
L["CHAT_ABANDONED_GRAY"] = "已放弃 %d 个灰色任务。"
L["CHAT_ABANDONED_GRAY_ONE"] = "已放弃 1 个灰色任务。"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_FAILED"] =
	"我刚才想把 %s 分享给你，但没成功。如果需要，等你准备好时喊我一声，我再分享一次。"
L["WHISPER_SHARE_FAILED_AGAIN"] = "%s 也一样。"
L["DUNGEON_QUESTS_ANNOUNCE"] = "我在这里还有 %d 个任务要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "我在这里还有 1 个任务要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_MORE"] = "%s"
L["DUNGEON_QUESTS_SEPARATOR"] = "、"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] = "Questie 追踪器无法显示 %s，因为 Questie 数据库中缺少该任务。"
L["QUESTIE_CANNOT_TRACK"] = "Questie 暂时无法追踪此任务。"
