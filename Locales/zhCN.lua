local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "zhCN")
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
	"版本 %s。设置（包括关闭此消息的选项）位于 选项 > 插件 > Pretty Wide Quest Log。喜欢这个插件吗？推荐给朋友，在 CurseForge 上收藏，或在 GitHub 上点 Star 吧。(="
L["CHAT_OPTIONS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开设置界面。"
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开游戏的按键设置。"
-- TRANSLATORS: the first %s is the game menu's Options label, the second its Key Bindings label, both from the client
L["KEY_BINDINGS_LOCATION"] =
	"打开游戏菜单，点击 %s，再点击 %s，然后找到 Pretty Wide Quest Log 一栏。"
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"没有 Questie 时，任务地图显示的内容会变少，任务链和交付总计也会隐藏。请在插件列表中启用 Questie 以显示它们。"
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus 也已启用，两者会争夺任务日志。请在插件列表中禁用 Wide Quest Log Plus，然后重新加载界面。"

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"带任务路线和任务箭头的宽版任务日志。你挑选任务，我们帮你规划一条清晰的路线，快速完成。任务等级、标签、奖励、任务链、任务地图，以及与队伍分享任务。兼容 Questie、Spoken、VoiceOver 和 ElvUI。"
L["ENABLE_WELCOME_MESSAGE"] = "启用欢迎消息"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "登录时显示 Pretty Wide Quest Log 的欢迎消息。"
L["OPTIONS_FEATURES_HEADER"] = "功能"
L["ENABLE_WIDE_QUEST_LOG"] = "启用宽版任务日志"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"将暴雪任务日志换成宽版任务日志，地图就在旁边。重新加载界面后生效。"
L["ENABLE_QUALITY_OF_LIFE"] = "启用便利功能"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"帮助队友接到你的任务：分享节奏、分享漏掉某人时的密语，以及地下城任务的通报和分享。即使关闭此项，任务日志中每个区域的分享任务按钮仍然可用。"
L["ENABLE_WAYPOINT_MARKERS"] = "启用路径点标记"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"将区域地图上每个任务目标的任务图标合并为一个标记，即一个路径点，放在其怪物或物品最多的地方，每个交付地点也各有一个。将鼠标悬停在标记上可查看它所代替的图标。"
L["ENABLE_QUEST_ROUTE"] = "启用任务路线"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"在区域地图上画出一条经过你的路径点标记的路线，由近及远，以从你的位置依次通向每个标记的移动圆点显示。需要路径点标记。"
L["ENABLE_QUEST_ARROW"] = "启用任务箭头"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"在屏幕上显示一个箭头，即任务箭头，指向路线上的下一个路径点，并列出要在那里完成的任务和目标。默认在团队和副本中隐藏。"
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"启用宽版任务日志需要重新加载界面才能生效，关闭设置界面时会提示你重新加载。"
L["RELOAD_PROMPT"] = "Pretty Wide Quest Log 需要重新加载界面才能切换任务日志。现在重新加载吗？"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "按键设置"
L["OPTIONS_KEY_SET"] = "设置按键"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "打开游戏的按键设置，Pretty Wide Quest Log 在其中有自己的一栏。"
L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] =
	"使用任务箭头上第一个使用物品按钮中的物品，效果与点击该按钮相同，战斗中也可使用。"
L["OPTIONS_COMMANDS_HEADER"] = "/命令"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开此插件的设置界面。"

--------------------------------------------------------------------------------
-- Options: Wide Quest Log Panels
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "宽版任务日志"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"用宽版任务日志替换暴雪任务日志：任务按区域列出，旁边显示所选任务的详情及其地图。"
L["QUEST_LOG_SORTING_HEADER"] = "排序"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "选择区域及其下任务的顺序。"
L["QUEST_LOG_ROWS_HEADER"] = "任务行"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "选择每行显示的内容。"
L["TAB_WINDOW_MAP"] = "窗口与地图"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"调整窗口和地图大小以适合你的屏幕，并选择它们的行为方式。"
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
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"在列表中每个任务名称前显示其等级和类型，例如 %s 表示40级地下城任务。"
L["MARK_UNTRACKED"] = "标记未追踪的任务"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"已追踪的任务不再显示对勾 %s，改为在未追踪的任务前显示眼睛 %s。如果你几乎追踪所有任务，会很方便。"
L["CLOSE_IN_COMBAT"] = "战斗开始时关闭"
L["CLOSE_IN_COMBAT_DESCRIPTION"] = "战斗开始时关闭任务日志，避免遮挡战斗画面。"
L["SHOW_OBJECTIVE_AREAS"] = "显示目标范围"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"在任务日志旁的地图上，用阴影标出每个目标的怪物和物体所在的范围，每个范围只显示一个图标，而不是每个刷新点各显示一个。"
L["NEEDS_QUESTIE_HINT"] = "启用 Questie 后才能使用此功能。"
L["WINDOW_SCALE"] = "任务日志缩放"
L["WINDOW_SCALE_DESCRIPTION"] = "放大或缩小任务日志。旁边的地图会随之一起缩放。"
L["MAP_SCALE"] = "地图缩放"
L["MAP_SCALE_DESCRIPTION"] = "在任务日志缩放的基础上，放大或缩小任务日志旁的地图。"
L["RESET_WINDOW_BUTTON"] = "重置窗口"
L["RESET_WINDOW_SCALE_DESCRIPTION"] = "将任务日志的高度和缩放以及地图缩放恢复为默认值。"
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"将任务日志的高度和缩放以及地图缩放恢复为默认值，并将窗口移回初始位置。"
L["RESET_WINDOW_SCALE_CONFIRM"] = "重置任务日志的高度和缩放以及地图缩放？"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"重置任务日志的高度和缩放、地图缩放以及窗口在屏幕上的位置？"
L["HANDY_CLICKS_HEADER"] = "实用点击"
L["HANDY_CLICK_TRACK"] = "Shift+点击任务"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "追踪或取消追踪该任务。"
L["HANDY_CLICK_MENU"] = "右键点击任务"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "追踪、分享或放弃该任务。"
L["HANDY_CLICK_ID"] = "点击任务ID"
L["HANDY_CLICK_ID_DESCRIPTION"] = "获取其 Wowhead 链接。"
L["QUEST_LOG_SUB_PANELS_DESCRIPTION"] =
	"其设置位于此面板下方的各个面板中：任务列表、任务详情、窗口与地图，以及NPC对话。"
L["NEEDS_WIDE_QUEST_LOG"] =
	"这些设置适用于宽版任务日志。请在宽版任务日志面板中勾选启用宽版任务日志后再使用。"
L["TAB_QUEST_LIST"] = "任务列表"
L["TAB_QUEST_LIST_DESCRIPTION"] = "你的任务，按区域列在任务日志左侧。"
L["TAB_QUEST_DETAILS"] = "任务详情"
L["TAB_QUEST_DETAILS_DESCRIPTION"] = "所选任务的详情，显示在任务列表旁的羊皮纸上。"

--------------------------------------------------------------------------------
-- Options: NPC Dialogue Panel
--------------------------------------------------------------------------------

L["TAB_NPC_DIALOGUE"] = "NPC对话"
L["TAB_NPC_DIALOGUE_DESCRIPTION"] =
	"与NPC交谈时打开的窗口：任务NPC窗口和对话窗口。无论是否使用宽版任务日志，这些设置都有效。"
L["QUEST_GIVERS_HEADER"] = "任务NPC"
L["QUEST_GIVERS_DESCRIPTION"] = "任务NPC打开的窗口，你在这里接受和交付任务。"
L["GIVER_CLEANUP"] = "任务NPC窗口整理"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"让任务NPC窗口的文字排版与任务日志一致，使用相同的标题和行距，并在任务下方显示链接到 Wowhead 的任务ID。"
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] = "在任务NPC的任务列表中加上任务日志的等级标签，例如 %s。"
L["FONT_DIALOGUE_NEEDS_CLEANUP"] = "此字体是任务NPC窗口整理的一部分，因此需要开启该功能。"

--------------------------------------------------------------------------------
-- Options: Font Sections
--------------------------------------------------------------------------------

L["FONT_HEADER"] = "字体"
L["FONT_LIST_DESCRIPTION"] = "任务列表中区域名称和任务的字体。"
L["FONT_DETAILS_DESCRIPTION"] = "任务详情的字体：标题、小标题和任务文本。"
L["FONT_DIALOGUE_DESCRIPTION"] = "任务NPC窗口和对话窗口的字体：标题、小标题和任务文本。"
L["FONT_WINDOW_DESCRIPTION"] = "窗口标题、任务数量和交付行的字体。"
L["FONT_FACE"] = "字体"
L["FONT_FACE_DESCRIPTION"] =
	'字体样式。"游戏默认"会跟随游戏字体，以及任何更改游戏字体的插件。通过 SharedMedia 添加的字体也会列出。'
L["FONT_GAME_DEFAULT"] = "游戏默认"
L["FONT_GAME_STANDARD"] = "标准文字"
L["FONT_GAME_NAMES"] = "角色名称"
L["FONT_GAME_DAMAGE"] = "伤害数字"
L["FONT_SIZE"] = "大小"
L["FONT_SIZE_DESCRIPTION"] = "以游戏字号为基准，按磅数放大或缩小文字。0 表示保持游戏字号。"
L["FONT_OUTLINE"] = "描边"
L["FONT_OUTLINE_DESCRIPTION"] =
	'每个字周围的黑色描边。"游戏默认"保留游戏字体原有的描边，"无"则去掉描边。'
L["FONT_OUTLINE_DEFAULT"] = "游戏默认"
L["FONT_OUTLINE_NONE"] = "无"
L["FONT_OUTLINE_THIN"] = "细"
L["FONT_OUTLINE_THICK"] = "粗"
L["FONT_SHADOW"] = "文字阴影"
L["FONT_SHADOW_DESCRIPTION"] =
	"保留游戏字体在文字后面的投影。关闭后会去掉阴影，有助于改善看起来模糊或发虚的字体。"
L["FONT_SLUG"] = "更清晰的文字（Slug）"
L["FONT_SLUG_DESCRIPTION"] =
	"使用暴雪较新的 Slug 渲染器绘制文字，在任何字号下都更清晰。Slug 无法绘制粗描边或阴影，因此带有其中任一效果的文字会按常规方式绘制。"
L["FONT_RESET_BUTTON"] = "重置字体"
L["FONT_RESET_DESCRIPTION"] = "将此字体的设置恢复为默认值。"

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "便利功能"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"任务日志本身之外的小帮手：用于与队伍分享任务，以及用于地下城。"
L["QUEST_SHARING_HEADER"] = "任务分享"
L["QUEST_SHARING_INTRO"] =
	"在任务日志中将鼠标悬停在区域名称上并点击分享任务按钮，即可把该区域中你能分享的所有任务逐一分享给队伍。这些选项设置分享的节奏，以及有人错过任务时该怎么办。"
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"区域名称上的分享任务按钮需要启用宽版任务日志。地下城任务分享无需此项即可使用。"
L["SHARE_INTERVAL"] = "分享间隔秒数"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"分享一个任务后到下一个任务之间的等待时间，适用于分享区域或地下城的任务时。时间越长，队友就有越多时间接受每个任务。"
L["SHARE_WHISPERS"] = "分享失败时密语"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"当队友正忙、距离太远或任务日志已满时，密语告诉对方你尝试分享的任务，并请对方提醒你。如果对方不符合任务条件、已经接了该任务或已经完成，则不发送任何消息。"
L["ZONE_SHARE_OFFERS"] = "向新队友提供我所在区域的任务"
L["ZONE_SHARE_OFFERS_DESCRIPTION"] =
	"当你加入队伍，或有人加入你的队伍时，先等待20秒让 Questie 交换任务日志，然后密语你所在区域的每位队友：你在该区域有目标的任务中有多少是对方没有的，并询问对方是否需要。只计算你可以分享的任务。无法看到其任务的队友（没有 Questie、超出范围）以及已全部拥有这些任务的队友不会收到密语。每位队友在每个队伍中只会被询问一次，在地下城或团队中不会询问。"
L["SAMPLE_EXAMPLE"] = "示例：%s"
L["SAMPLE_QUEST_LOADING"] = "正在加载任务ID：%d"
L["DUNGEON_QUESTS_HEADER"] = "地下城任务"
L["DUNGEON_QUESTS_INTRO"] =
	"当你和队伍进入地下城时，会在所有人都进入范围后（在 WoW Forever 上立即）通报并分享你在其中的任务，且不会对同一支队伍进行两次。装有 Questie 时，目标位于其中的任务也算在内，包括职业任务。在团队中不会进行。"
L["DUNGEON_ANNOUNCE"] = "地下城任务自动通报"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"告诉队友你在刚进入的地下城里还有哪些任务要做，让大家知道要留意什么。可以交付的任务不会列出。"
L["DUNGEON_SHARE"] = "地下城任务自动分享"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"按任务分享中设定的节奏，在所有人都进入范围后（或一分钟后；在 WoW Forever 上立即）分享该地下城里所有游戏允许分享、且有队友还没有的任务。每位队友在每个地下城只会收到一次，所以之后加入的人也会收到，而离开再进入不会再次分享。开启分享失败时密语后，错过分享的队友会收到密语，可以再找你要。"

--------------------------------------------------------------------------------
-- Options: Maps & Objectives Panels
--------------------------------------------------------------------------------

L["TAB_MAPS_OBJECTIVES"] = "地图与目标"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"区域地图上每个任务目标和交付地点各一个标记，代替成堆的任务图标。"
L["MAPS_SUB_PANELS_DESCRIPTION"] =
	"每张地图的设置位于此面板下方的各个面板中：小地图、区域地图，以及大陆与世界地图。"
L["MAPS_NEED_MARKERS"] = "只有在启用路径点标记开启时才会显示这些标记。"
L["TAB_MINIMAP"] = "小地图"
L["TAB_MINIMAP_DESCRIPTION"] =
	"小地图上的 Questie 图标会准确显示目标的刷新位置和拾取地点，因此始终保留。路线标记可以显示在它们旁边。"
L["SHOW_MINIMAP_MARKERS"] = "在小地图上显示路径点标记"
L["SHOW_MINIMAP_MARKERS_DESCRIPTION"] =
	"在小地图上为路线的每个路径点放置一个小标记，位于 Questie 图标旁边。将鼠标悬停在标记上可查看其任务。"
L["MINIMAP_MARKER_SIZE_DESCRIPTION"] = "路线标记在小地图上的大小。"
L["TAB_ZONE_MAP"] = "区域地图"
L["TAB_ZONE_MAP_DESCRIPTION"] = "区域的地图，路线在其中的路径点标记之间延伸。"
L["FULL_SIZE_MAP"] = "以最大尺寸打开区域地图"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"像地图自带的最大化按钮一样，以最大化状态打开区域地图，让路线有足够空间。即使你把地图缩小，下次也会再次以最大尺寸打开。"
L["HIDE_QUESTIE_ICONS"] = "隐藏路线上的任务图标"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"隐藏路线上目标的 Questie 地图图标，以及暴雪自带的任务标识和目标区域，由路线标记代替显示。队友目标的 Questie 半透明图标也会隐藏。将鼠标悬停在标记上可查看 Questie 图标。"
L["MARKER_SIZE"] = "标记大小"
L["MARKER_SIZE_DESCRIPTION"] = "路线标记在区域地图上的大小。"
L["MARKER_SIZE_SMALL"] = "小"
L["MARKER_SIZE_MEDIUM"] = "中"
L["MARKER_SIZE_LARGE"] = "大"
L["MARKER_SIZE_HUGE"] = "特大"
L["TAB_WIDE_MAP"] = "大陆与世界地图"
L["TAB_WIDE_MAP_DESCRIPTION"] =
	"同时包含许多区域的地图，每个目标和交付地点在这里各有一个较小的标记。"
L["SHOW_WIDE_MAP_MARKERS"] = "在大陆和世界地图上显示路径点标记"
L["SHOW_WIDE_MAP_MARKERS_DESCRIPTION"] =
	"在大陆和世界地图上为每个目标和交付地点放置一个标记，取代 Questie 的图标。关闭后会在那里改为显示 Questie 的图标。"
L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"] =
	"路线标记在大陆和世界地图上的大小。由于这些地图包含许多区域，每种大小在那里都比区域地图上小。"

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "任务路线"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"区域地图上的一条路线，从你所在的位置出发，按完成顺序经过你的路径点标记。"
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"任务路线连接各个路径点标记，因此只有在启用路径点标记开启时才会显示。"
L["ROUTES_LINE_HEADER"] = "路线线条"
L["ROUTES_LINE_DESCRIPTION"] = "从你的位置通向每个标记的移动圆点。"
L["LINE_SPEED"] = "线条速度"
L["LINE_SPEED_DESCRIPTION"] = "圆点向下一个标记移动的速度。"
L["LINE_SPEED_STILL"] = "静止"
L["LINE_SPEED_SLOW"] = "慢"
L["LINE_SPEED_NORMAL"] = "正常"
L["LINE_SPEED_FAST"] = "快"
L["LINE_OPACITY"] = "线条不透明度"
L["LINE_OPACITY_DESCRIPTION"] = "圆点的不透明程度；越低，透出的地图越多。"
L["ROUTES_PARTY_HEADER"] = "队伍"
L["ROUTES_PARTY_DESCRIPTION"] = "你的队伍为路线增加的内容。"
L["PARTY_QUESTS"] = "包括队友的任务"
L["PARTY_QUESTS_DESCRIPTION"] =
	"在队伍中，路线和任务箭头也会包括队友有而你没有的任务，显示方式与你自己的任务相同。双方都需要装有 Questie 才能共享这些任务。他们的地下城任务会被排除，因为任务目标在地下城内。"
L["GROUP_UP"] = "与队伍会合"
L["GROUP_UP_DESCRIPTION"] =
	'在队伍中，当你所在区域有任何队友不在你的小地图范围内时，任务箭头会显示"与队伍会合"并指向该队友，或所有人的中间位置，世界地图也会标出该位置，方便你们一起做任务。'

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "任务箭头"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"屏幕上的一个箭头，指向路线上的下一个路径点，并列出要在那里完成的任务和目标。鼠标悬停在它上面会显示一个菜单，你可以在其中逐个忽略目标，并查看已忽略的内容。中键点击它可重置区域，恢复你在那里忽略的内容。"
L["QUEST_ARROW_HEADER"] = "箭头"
L["QUEST_ARROW_DESCRIPTION"] = "任务箭头的位置和大小。"
L["ARROW_SIZE"] = "箭头大小"
L["ARROW_SIZE_DESCRIPTION"] = "任务箭头及其下方文字的大小。"
L["LOCK_ARROW"] = "锁定任务箭头"
L["LOCK_ARROW_DESCRIPTION"] = "将任务箭头固定在原位，拖动不起作用。"
L["RESET_ARROW"] = "箭头位置"
L["RESET_ARROW_BUTTON"] = "重置"
L["RESET_ARROW_CONFIRM"] = "将任务箭头移回初始位置？"
L["RESET_ARROW_DESCRIPTION"] = "将任务箭头放回初始位置，即屏幕顶部中间。"
L["QUEST_ARROW_TEXT_HEADER"] = "箭头下方"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "任务箭头在下方列出的内容。"
L["SHOW_DISTANCE"] = "显示距离"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'显示下一个路径点还有多少码。无论是否开启，都会显示"%s"和"%s"。'
L["SHOW_ARROW_QUESTS"] = "显示任务和目标"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"列出下一个路径点的任务，每个任务都附带在那里还需要做的事。"
L["QUESTS_LISTED"] = "最多列出任务数"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'任务箭头在一个路径点下方最多列出的任务数。其余的任务会在单独一行中计数，例如"%s"。'
L["SHOW_ITEM_BUTTONS"] = "显示任务物品按钮"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"在任务箭头列出的每个有可用物品的任务旁放一个按钮，例如需要投掷、种下或对目标使用的物品。点击按钮即可使用该物品，也可以在 Pretty Wide Quest Log 面板的按键设置中为使用任务物品设置按键，以使用第一个物品。战斗中按钮会保持原位，直到战斗结束。"
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_NEXT_OBJECTIVE
L["SHOW_NEXT_OBJECTIVE"] = "显示下一个目标"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'在"%s"时，于其下方以暗色列出"%s"：一个指向再下一个路径点的小箭头，以及在那里要做的事。'
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_PREDICTIVE
L["PREDICTIVE_ROUTES"] = "预测任务路线"
L["PREDICTIVE_ROUTES_DESCRIPTION"] =
	"规划你能在本区域完成的任务，无论任务发布者在哪里，而不只是附近的：包括它们的目标、交付，以及后续任务。路线会在你前往区域的某一部分之前，先接好那里需要的所有任务，这样你只需去一次。任务链会在第一个通往其他区域的任务处停止。尚未接受的任务，其目标以灰色标记显示。每个任务的交付地点也会在完成前显示，并以 Questie 的灰色问号标出。"
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_FLIGHTS
L["SHOW_FLIGHT_PATHS"] = "将未发现的飞行点显示为目标"
L["SHOW_FLIGHT_PATHS_DESCRIPTION"] =
	"把你所在区域中你还没有获得其飞行点的每位飞行管理员加入路线，并以飞行管理员图标标出。如果角色之前已经拥有飞行点，请先打开任意飞行地图一次，让路线知道你拥有哪些；在此之前不会加入任何飞行点。"
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_LOCAL
L["SHOW_LOCAL_QUESTS"] = "将附近可接任务显示为目标"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"把你能接的任务加入路线：Questie 显示为可接，且发布任务的 NPC 或物体在 %s以内，并以 Questie 的感叹号标出。由掉落物品开始的任务以及地下城和团队副本任务不会加入。"
L["LOCAL_QUESTS_HEADER"] = "附近可接任务"
L["LOCAL_QUESTS_DESCRIPTION"] =
	"任务箭头会带你去哪些附近的任务。被跳过的任务仍可显示在世界地图上，但没有路线连到那里。"
L["LOCAL_QUEST_RANGE"] = "搜索范围"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"发布任务者离你多少码以内才算数。低于 400 时，在两次路线规划之间路过的任务发布者可能会被漏掉。"
L["LOCAL_ESCORT_QUESTS"] = "护送任务"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] =
	"需要一路保护 NPC 的任务，耗时且常需队伍。它们在地图上的标记为绿色。"
L["LOCAL_GROUP_QUESTS"] = "团队和精英任务"
L["LOCAL_GROUP_QUESTS_DESCRIPTION"] = "Questie 标为精英、适合组队的任务。"
L["LOCAL_OTHER_ZONE_QUESTS"] = "目标在其他区域"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"有目标或交任务地点只在你所在区域之外的任务，例如让你前往下一个城镇的任务。"
L["LOCAL_QUEST_LEVEL"] = "最低任务等级"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	'低于此难度颜色的任务不计入。"Questie 设置"保留 Questie 在其地图上显示的任务。'
-- TRANSLATORS: a choice for a kind of nearby quest: the Quest Arrow takes you there
L["LOCAL_CHOICE_ROUTE"] = "加入路线"
-- TRANSLATORS: a choice for a kind of nearby quest: a marker on the world map, but the Quest Arrow skips it
L["LOCAL_CHOICE_MAP"] = "仅地图"
-- TRANSLATORS: a choice for a kind of nearby quest: neither the route nor its map markers show it
L["LOCAL_CHOICE_OFF"] = "不计入"
L["LOCAL_LEVEL_QUESTIE"] = "Questie 设置"
-- TRANSLATORS: quest difficulty colors, green being a few levels below the player
L["LOCAL_LEVEL_GREEN"] = "绿色及以上"
L["LOCAL_LEVEL_YELLOW"] = "黄色及以上"
L["QUEST_ARROW_HIDING_HEADER"] = "隐藏"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "任务箭头何时自动隐藏。"
L["HIDE_IN_RAIDS"] = "在团队中隐藏"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "当你在团队中时隐藏任务箭头。"
L["HIDE_IN_INSTANCES"] = "在副本中隐藏"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "在地下城、团队副本和战场中隐藏任务箭头。"

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

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "副"
L["QUEST_SUFFIX_RAID"] = "团"
L["QUEST_SUFFIX_PVP"] = "战"
L["QUEST_SUFFIX_GROUP"] = "组"
L["QUEST_SUFFIX_ELITE"] = "精"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "地下城"
L["QUEST_TYPE_RAID"] = "团队副本"
L["QUEST_TYPE_GROUP"] = "组队"
L["QUEST_TYPE_ELITE"] = "精英"
L["QUEST_TYPE_PVP"] = "PvP"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "等级后的字：%s。"
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s（%s）"
L["QUEST_ID"] = "任务ID %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "任务链（%d/%d）"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "日常任务将在 %s 后重置。"
L["WOWHEAD_LINK_TOOLTIP"] = "点击获取 Wowhead 链接。"
L["WOWHEAD_LINK_COPY"] = "按 Ctrl+C（Mac 上为 Cmd+C）复制 Wowhead 链接。"
L["EXPAND_ALL"] = "全部展开"
L["COLLAPSE_ALL"] = "全部折叠"
L["TRACK_ALL"] = "全部追踪"
L["UNTRACK_ALL"] = "全部取消追踪"
L["HIDE_MAP"] = "隐藏地图"
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "%s 经验"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "交付：%s"
L["TURN_IN_TOOLTIP"] = "可以交付"
L["RESIZE_TOOLTIP"] = "拖动以调整任务日志大小。"

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "分享任务"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"把本区域中游戏允许分享、且有队友还没有的任务提供给队伍，每 %d 秒一个。"
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "战斗结束后分享 %s。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "正在分享 %s 的 1 个任务。"
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "正在分享 %d 个任务，来自 %s，每 %d 秒一个。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "%s 中没有可以分享的任务。"
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_PARTY_HAS"] = "你的队伍已经拥有你在 %s 的所有任务。"

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "已到达"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "路径点在另一张地图上"
L["ROUTES_OBJECTIVE_AREA"] = "当前目标范围"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "完成这里再继续"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "路线后面还有"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "下一个目标"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "顺路可做"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d码"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d码"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "此处还有 +%d 个"
L["ROUTES_TURN_IN"] = "交付任务"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "交付 %s"
L["ROUTES_PICK_UP"] = "接受任务"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "接受 %s"
L["ROUTES_FLIGHT_PATH"] = "获取飞行点"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_FLIGHT_PATH_FROM"] = "从%s处获取飞行点"
-- TRANSLATORS: under a quest to pick up on the world map, why the route doesn't go there
L["ROUTES_OFF_ROUTE_ESCORT"] = "护送任务，不在路线上"
L["ROUTES_OFF_ROUTE_GROUP"] = "组队任务，不在路线上"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "通往其他区域，不在路线上"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"; over a quest's objectives planned before it's picked up
L["ROUTES_AFTER_PICK_UP"] = "接受 %s 后"
-- TRANSLATORS: %s is the quest's title with its level; under a quest to pick up once another is turned in
L["ROUTES_AFTER_TURN_IN"] = "交付 %s 后"
-- TRANSLATORS: as ROUTES_AFTER_PICK_UP, for a party member's quest planned ahead, one you don't have
L["ROUTES_AFTER_PARTY_PICK_UP"] = "队友接受 %s 后"
-- TRANSLATORS: as ROUTES_AFTER_TURN_IN, for a party member's quest
L["ROUTES_AFTER_PARTY_TURN_IN"] = "队友交付 %s 后"
L["ROUTES_CORPSE"] = "跑回你的尸体处"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "寻找"
L["ROUTES_CLICK_DRAG"] = "拖动"
L["ROUTES_CLICK_RIGHT"] = "右键点击"
L["ROUTES_CLICK_MIDDLE"] = "中键点击"
L["ROUTES_CLICK"] = "点击"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "使用物品"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "使用任务物品"
L["ROUTES_DRAG_MOVE"] = "移动任务箭头"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "忽略此路径点"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "忽略此目标"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "放回路线"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "重置此区域"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "忽略 %s，直到重置区域。"
L["ROUTES_ZONE_RESET"] = "区域已重置：在此忽略的目标已回到路线上。"
L["ROUTES_GROUP_LEFT_CLEARED"] = "已离开队伍：已忽略的队伍目标和队友已回到路线上。"
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] = "%s 已离开队伍：为其忽略的目标已回到路线上。"
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "忽略"
L["ROUTES_MENU_SECTION_ROUTE"] = "路线"
L["ROUTES_MENU_SECTION_SHOW"] = "显示"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "下一个"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "恢复"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "已忽略"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "交付 %s"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "接受 %s"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_MENU_FLIGHT_PATH"] = "%s飞行点"
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_ROUTE; Next Objective, under ROUTES_MENU_SECTION_SHOW, is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_PREDICTIVE"] = "预测任务路线"
L["ROUTES_MENU_SHOWN_LOCAL"] = "附近可接任务"
L["ROUTES_MENU_SHOWN_FLIGHTS"] = "飞行点"
L["ROUTES_MENU_SHOWN_PARTY"] = "队友目标"
L["ROUTES_MENU_ON"] = "开启"
L["ROUTES_MENU_OFF"] = "关闭"
L["ROUTES_MENU_OUT_OF_ZONE"] = "不在本区域"
L["ROUTES_MENU_NO_QUESTIE"] = "无 Questie"
L["ROUTES_MENU_OFFLINE"] = "离线"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "%s 的目标"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "忽略 %s（%s），直到重置区域。"
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] = "忽略 %s（%s），直到有该任务的队友离开队伍。"
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s 已回到路线上。"
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "%s 的目标已移出路线。"
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "%s 的目标已回到路线上。"
-- TRANSLATORS: on the Quest Arrow and the world map's marker, while it points to where to join up with your party
L["ROUTES_GROUP_UP"] = "与队伍会合"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them, and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"我刚才想把 %s 分享给你，但没成功。如果需要，等你准备好时喊我一声，我再分享一次"
L["WHISPER_SHARE_FAILED_AGAIN"] = "%s 也一样"
L["ZONE_SHARE_OFFER"] = "我有%d个%s的任务你还没有，要我试着分享给你吗？"
L["ZONE_SHARE_OFFER_ONE"] = "我有1个%s的任务你还没有，要我试着分享给你吗？"
L["DUNGEON_QUESTS_ANNOUNCE"] = "我在这里还有 %d 个任务要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "我在这里还有 1 个任务要做：%s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "我在这里还有更多任务要做：%s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] = "Questie 追踪器无法显示 %s，因为 Questie 数据库中缺少该任务。"
L["QUESTIE_CANNOT_TRACK"] = "Questie 暂时无法追踪此任务。"
