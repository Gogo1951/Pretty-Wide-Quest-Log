local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "ruRU")
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
	"Версия %s. Параметры (в том числе возможность отключить это сообщение) находятся в разделе Настройки > Модификации > Pretty Wide Quest Log. Нравится этот аддон? Расскажите о нём другу, добавьте его в избранное на CurseForge или поставьте ему Star на GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] =
	"В целях безопасности окно настроек нельзя открыть во время боя."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Без Questie карта заданий показывает меньше, а цепочки заданий и итог Сдача скрыты. Включите Questie в списке модификаций, чтобы их увидеть."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus тоже включён, и два аддона будут мешать друг другу в журнале заданий. Отключите Wide Quest Log Plus в списке модификаций и перезагрузите интерфейс."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Широкий журнал заданий с маршрутом и стрелкой заданий. Вы выбираете задания, а мы помогаем проложить чистый маршрут, чтобы быстро их выполнить. Уровни заданий, метки, награды, цепочки заданий, карта заданий и передача заданий группе. Работает с Questie, Spoken, VoiceOver и ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Включить приветственное сообщение"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] =
	"Показывает приветственное сообщение Pretty Wide Quest Log при входе в игру."
L["OPTIONS_FEATURES_HEADER"] = "Функции"
L["ENABLE_WIDE_QUEST_LOG"] = "Включить широкий журнал заданий"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Заменяет журнал заданий Blizzard широким, с картой рядом. Вступает в силу после перезагрузки интерфейса."
L["ENABLE_QUALITY_OF_LIFE"] = "Включить удобные функции"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	'Упорядочивает окно заданий НИП и помогает группе получить ваши задания: темп передачи, шёпот, если передача кого-то не достигла, а также объявление и передача заданий подземелья. Кнопка "Поделиться заданиями" у зоны в журнале заданий работает и при выключенном параметре.'
L["ENABLE_ROUTES_MAP"] = "Включить маршруты на карте зоны"
L["FEATURE_ROUTES_MAP_DESCRIPTION"] =
	"Прокладывает на карте зоны маршрут через цели ваших заданий и места их сдачи, начиная с ближайших, в виде бегущих точек между метками."
L["ENABLE_QUEST_ARROW"] = "Включить Стрелку заданий"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Показывает на экране стрелку, Стрелку заданий, которая указывает на следующую путевую точку маршрута, с заданиями и целями, которые там нужно выполнить. По умолчанию она скрывается в рейдовых группах и подземельях."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Параметр Включить широкий журнал заданий вступит в силу после перезагрузки интерфейса, которую предложат при закрытии окна настроек."
L["RELOAD_PROMPT"] =
	"Pretty Wide Quest Log сменит журнал заданий после перезагрузки интерфейса. Перезагрузить сейчас?"
L["OPTIONS_COMMANDS_HEADER"] = "/Команды"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Открывает окно настроек этого аддона."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Широкий журнал заданий"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Заменяет журнал заданий Blizzard широким: задания сгруппированы по зонам, а рядом видны подробности выбранного задания и его карта."
L["QUEST_LOG_SORTING_HEADER"] = "Сортировка"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Выберите порядок зон и заданий в них."
L["QUEST_LOG_ROWS_HEADER"] = "Строки заданий"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Выберите, что показывать в каждой строке."
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "Окно и карта"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"Подгоните размер окна и карты под свой экран и выберите их поведение."
L["ZONE_ORDER"] = "Порядок зон"
L["ZONE_ORDER_DESCRIPTION"] = "Меняет порядок зон в списке заданий."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] =
	"Средний уровень, сначала высокий (по умолчанию)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Средний уровень, сначала низкий"
L["SORT_ALPHABETICAL"] = "По алфавиту"
L["CURRENT_ZONE_FIRST"] = "Показывать текущую зону первой"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Ставит зону, в которой вы находитесь, в начало списка при любом порядке зон."
L["ZONE_GAP"] = "Добавлять отступ над названиями зон"
L["ZONE_GAP_DESCRIPTION"] =
	"Добавляет небольшой отступ над каждым названием зоны. Удобно, если ваши задания разбросаны по многим зонам."
L["QUEST_ORDER"] = "Порядок заданий"
L["QUEST_ORDER_DESCRIPTION"] = "Меняет порядок заданий внутри каждой зоны."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Уровень, сначала высокий (по умолчанию)"
L["SORT_LEVEL_LOWEST"] = "Уровень, сначала низкий"
L["COMPLETED_FIRST"] = "Показывать выполненные задания первыми"
L["COMPLETED_FIRST_DESCRIPTION"] =
	"Поднимает задания, которые можно сдать, в начало их зоны."
L["SHOW_QUEST_LEVELS"] = "Показывать уровни заданий"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Ставит уровень и тип каждого задания перед его названием в списке, например %s для задания 40-го уровня в подземелье."
L["MARK_UNTRACKED"] = "Отмечать неотслеживаемые задания"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Отслеживаемые задания теряют галочку %s, а неотслеживаемые вместо этого получают глаз %s. Удобно, если вы отслеживаете почти всё."
L["CLOSE_IN_COMBAT"] = "Закрывать при начале боя"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Закрывает журнал заданий, когда начинается бой, чтобы он никогда не загораживал происходящее."
L["SHOW_OBJECTIVE_AREAS"] = "Показывать области целей"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Выделяет цветом на карте рядом с журналом заданий места, где находятся противники и объекты каждой цели, с одним значком на область вместо значка на каждой точке появления."
L["NEEDS_QUESTIE_HINT"] = "Включите Questie, чтобы пользоваться этим."
L["WINDOW_SCALE"] = "Масштаб журнала заданий"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Увеличивает или уменьшает журнал заданий. Карта рядом с ним меняет размер вместе с ним."
L["MAP_SCALE"] = "Масштаб карты"
L["MAP_SCALE_DESCRIPTION"] =
	"Увеличивает или уменьшает карту рядом с журналом заданий, в дополнение к масштабу журнала заданий."
L["RESET_WINDOW_BUTTON"] = "Сбросить окно"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Возвращает высоту и масштаб журнала заданий, а также масштаб карты к значениям по умолчанию."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Возвращает высоту и масштаб журнала заданий, а также масштаб карты к значениям по умолчанию и перемещает окно на начальное место."
L["RESET_WINDOW_SCALE_CONFIRM"] =
	"Сбросить высоту и масштаб журнала заданий, а также масштаб карты?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Сбросить высоту и масштаб журнала заданий, масштаб карты и положение окна на экране?"
L["HANDY_CLICKS_HEADER"] = "Полезные щелчки"
L["HANDY_CLICK_TRACK"] = "Shift-щелчок по заданию"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "Отслеживать его или снять отслеживание."
L["HANDY_CLICK_MENU"] = "Правый щелчок по заданию"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "Отслеживать, поделиться или отказаться."
L["HANDY_CLICK_ID"] = "Щелчок по ID задания"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Получить ссылку на Wowhead."

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Удобные функции"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Небольшие помощники вне самого журнала заданий: для окна заданий НИП, для передачи заданий группе и для подземелий."
L["QUEST_GIVERS_HEADER"] = "НИП с заданиями"
L["QUEST_GIVERS_DESCRIPTION"] =
	"Окно, которое открывает НИП, где вы берёте и сдаёте задания."
L["GIVER_CLEANUP"] = "Улучшенное окно заданий НИП"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Оформляет текст окна заданий НИП так же, как в журнале заданий, с теми же заголовками и межстрочным интервалом, и показывает под заданием его ID со ссылкой на Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Добавляет метки уровня из журнала заданий, например %s, в список заданий НИП."
L["QUEST_SHARING_HEADER"] = "Передача заданий"
L["QUEST_SHARING_INTRO"] =
	'Наведите курсор на название зоны в журнале заданий и нажмите "Поделиться заданиями", чтобы по очереди предложить группе все её задания, которыми можно поделиться. Эти параметры задают темп и то, что происходит, если кто-то пропустит задание.'
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	'Для кнопки "Поделиться заданиями" у названия зоны нужен параметр Включить широкий журнал заданий. Передача заданий подземелья работает и без него.'
L["SHARE_INTERVAL"] = "Секунд между передачами"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Сколько ждать между одним переданным заданием и следующим, когда вы передаёте задания зоны или подземелья. Чем дольше, тем больше времени у группы, чтобы принять каждое."
L["SHARE_WHISPERS"] = "Шептать, если передача не удалась"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Если участник группы занят, слишком далеко или его журнал заданий заполнен, ему отправляется шёпот с названием задания, которое вы пытались передать, и просьбой напомнить вам. Ничего не отправляется, если задание ему недоступно, он уже выполняет его или уже выполнил."
L["SAMPLE_EXAMPLE"] = "Пример: %s"
L["SAMPLE_QUEST_LOADING"] = "Загрузка ID задания: %d"
L["DUNGEON_QUESTS_HEADER"] = "Задания подземелий"
L["DUNGEON_QUESTS_INTRO"] =
	"Когда вы входите в подземелье с группой, ваши задания для него объявляются и передаются, как только все окажутся в зоне досягаемости (в WoW Forever сразу), и никогда дважды одной и той же группе. С Questie учитываются и задания, цели которых находятся внутри, включая классовые. В рейдовой группе ничего не происходит."
L["DUNGEON_ANNOUNCE"] = "Автоматическое объявление заданий подземелья"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Сообщает группе, какие ваши задания ещё нужно выполнить в подземелье, куда вы только что вошли, чтобы все знали, на что обратить внимание. Задания, готовые к сдаче, не упоминаются."
L["DUNGEON_SHARE"] = "Автоматическая передача заданий подземелья"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Передаёт каждое задание этого подземелья, которое игра позволяет передать, в темпе, заданном в разделе Передача заданий, как только все будут в зоне досягаемости (или через минуту; в WoW Forever сразу). Каждый член группы получает их один раз за подземелье, поэтому тот, кто присоединится позже, тоже их получит, а выход и повторный вход ничего не передают. При включённом параметре Шептать, если передача не удалась, тот, кто пропустит передачу, получит шёпот и сможет попросить ещё раз."

--------------------------------------------------------------------------------
-- Options: Routes on Zone Map Panel
--------------------------------------------------------------------------------

L["TAB_ROUTES_MAP"] = "Маршруты на карте зоны"
L["TAB_ROUTES_MAP_DESCRIPTION"] =
	"Маршрут через цели ваших заданий и места их сдачи на карте зоны, в том порядке, в котором их выполнять, от того места, где вы стоите."
L["ROUTES_MAP_HEADER"] = "Карта зоны"
L["FULL_SIZE_MAP"] = "Открывать карту зоны в полном размере"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Открывает карту зоны развёрнутой, как это делает её собственная кнопка развёртывания, чтобы маршруту хватало места. Если вы уменьшите карту, в следующий раз она снова откроется в полном размере."
L["HIDE_QUESTIE_ICONS"] = "Скрывать значки Questie на маршруте"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Скрывает значки Questie на карте для всего, что есть на маршруте, чтобы их заменили метки. Наведите курсор на метку, чтобы увидеть её значки."
L["ROUTES_MARKERS_HEADER"] = "Метки"
L["MARKER_SIZE"] = "Размер меток"
L["MARKER_SIZE_DESCRIPTION"] = "Насколько крупные метки маршрута на карте зоны."
L["MARKER_SIZE_SMALL"] = "Маленький"
L["MARKER_SIZE_MEDIUM"] = "Средний"
L["MARKER_SIZE_LARGE"] = "Большой"
L["MARKER_SIZE_HUGE"] = "Огромный"
L["ROUTES_LINE_HEADER"] = "Линия маршрута"
L["SHOW_ROUTE_LINE"] = "Показывать линию маршрута"
L["SHOW_ROUTE_LINE_DESCRIPTION"] =
	"Рисует бегущие точки от вас к каждой метке по очереди. Если выключено, видны только метки."
L["LINE_SPEED"] = "Скорость линии"
L["LINE_SPEED_DESCRIPTION"] = "Как быстро точки бегут к следующей метке."
L["LINE_SPEED_STILL"] = "Неподвижная"
L["LINE_SPEED_SLOW"] = "Медленная"
L["LINE_SPEED_NORMAL"] = "Обычная"
L["LINE_SPEED_FAST"] = "Быстрая"
L["LINE_OPACITY"] = "Непрозрачность линии"
L["LINE_OPACITY_DESCRIPTION"] =
	"Насколько плотные точки; чем ниже, тем больше карты просвечивает сквозь них."
L["ROUTES_PARTY_HEADER"] = "Группа"
L["PARTY_QUESTS"] = "Учитывать задания участников группы"
L["PARTY_QUESTS_DESCRIPTION"] =
	"В группе маршрут и Стрелка заданий учитывают и задания, которые есть у участников группы, но нет у вас, и показывают их так же, как ваши. Чтобы делиться ими, Questie нужен у обеих сторон. Их задания подземелий не учитываются, как и ваши."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Стрелка заданий"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Стрелка на экране, указывающая на следующую путевую точку маршрута, с заданиями и целями, которые там нужно выполнить. Щёлкните по ней правой кнопкой, чтобы проложить маршрут в обход текущей цели; средней кнопкой, чтобы сбросить все маршруты."
L["QUEST_ARROW_HEADER"] = "Стрелка"
L["ARROW_SIZE"] = "Размер стрелки"
L["ARROW_SIZE_DESCRIPTION"] =
	"Насколько крупная Стрелка заданий вместе с текстом под ней."
L["ARROW_CYCLE"] = "Цикл глаза и стрелки (секунды)"
L["ARROW_CYCLE_DESCRIPTION"] =
	"В области цели Стрелка заданий чередуется: сначала глаз, перечисляющий цели вокруг вас, затем стрелка, указывающая дальше, на следующую путевую точку. Каждому достаётся половина этого времени."
L["LOCK_ARROW"] = "Закрепить Стрелку заданий"
L["LOCK_ARROW_DESCRIPTION"] =
	"Оставляет Стрелку заданий на месте, так что перетаскивание ничего не делает."
L["RESET_ARROW"] = "Положение стрелки"
L["RESET_ARROW_BUTTON"] = "Сбросить"
L["RESET_ARROW_DESCRIPTION"] =
	"Возвращает Стрелку заданий на исходное место, вверху по центру экрана."
L["QUEST_ARROW_TEXT_HEADER"] = "Под стрелкой"
L["SHOW_DISTANCE"] = "Показывать расстояние"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'Показывает, сколько метров до следующей путевой точки. "%s" и "%s" показываются в любом случае.'
L["SHOW_ARROW_QUESTS"] = "Показывать задания и цели"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"Перечисляет задания у следующей путевой точки, у каждого то, что там осталось сделать."
L["QUESTS_LISTED"] = "Максимум заданий в списке"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'Сколько заданий самое большее Стрелка заданий перечисляет под собой для одной путевой точки. Остальные считаются отдельной строкой, например "%s".'
L["QUEST_ARROW_HIDING_HEADER"] = "Скрытие"
L["HIDE_IN_RAIDS"] = "Скрывать в рейдовых группах"
L["HIDE_IN_RAIDS_DESCRIPTION"] =
	"Скрывает Стрелку заданий, пока вы в рейдовой группе."
L["HIDE_IN_INSTANCES"] = "Скрывать в подземельях"
L["HIDE_IN_INSTANCES_DESCRIPTION"] =
	"Скрывает Стрелку заданий в подземельях, рейдах и на полях боя."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Помогите Pretty Wide Quest Log повысить уровень"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Этот аддон создали игроки, которые любят эту игру и хотят сделать её как можно интереснее для всех. Мы никогда не будем просить пожертвований. Настоящая награда для нас в том, чтобы знать, что наша работа делает игру для вас чуточку лучше. Если это так, мы будем рады об этом услышать!"
L["OPTIONS_LEVEL_UP_WAYS"] =
	"Вот несколько способов помочь нам охватить больше игроков."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Поделитесь отзывом: Нашли ошибку или есть идея? Напишите нам в Discord. Ваши отзывы помогают нам улучшать аддон, а пул-реквесты всегда приветствуются."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Расскажите другу: Знаете кого-то, кому может понравиться этот аддон? Расскажите ему. Сарафанное радио помогает большему числу игроков находить отличные аддоны."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Добавьте в избранное на CurseForge: Откройте ссылку на CurseForge ниже, войдите в аккаунт и нажмите на звёздочку под кнопкой загрузки. Избранное помогает большему числу игроков находить аддон."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Поставьте Star на GitHub: Откройте ссылку на GitHub ниже, войдите в аккаунт и нажмите Star в правом верхнем углу. Звёзды помогают проекту получать больше бесплатных инструментов для разработчиков."
L["OPTIONS_LEVEL_UP_THANKS"] = "Спасибо, что выбрали Pretty Wide Quest Log!"
L["OPTIONS_FEEDBACK"] = "Отзывы и поддержка"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Ссылки для отзывов и поддержки"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] =
	"Чтобы скопировать ссылку, щелкните по её полю, затем нажмите Ctrl+A и Ctrl+C."
L["OPTIONS_VERSION"] = "Версия %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "Д"
L["QUEST_SUFFIX_RAID"] = "Р"
L["QUEST_SUFFIX_PVP"] = "П"
L["QUEST_SUFFIX_GROUP"] = "Г"
L["QUEST_SUFFIX_ELITE"] = "Э"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "подземелье"
L["QUEST_TYPE_RAID"] = "рейд"
L["QUEST_TYPE_GROUP"] = "группа"
L["QUEST_TYPE_ELITE"] = "элитное"
L["QUEST_TYPE_PVP"] = "ПвП"
L["QUEST_LEVEL_LEGEND"] = "Буквы после уровня: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID задания %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Цепочка заданий (%d из %d)"
L["DAILY_RESET"] = "Ежедневные задания обновятся через %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Щелкните, чтобы получить ссылку на Wowhead."
L["WOWHEAD_LINK_COPY"] =
	"Нажмите Ctrl+C (Cmd+C на Mac), чтобы скопировать ссылку на Wowhead."
L["EXPAND_ALL"] = "Развернуть все"
L["COLLAPSE_ALL"] = "Свернуть все"
L["TRACK_ALL"] = "Отслеживать все"
L["UNTRACK_ALL"] = "Снять отслеживание"
L["HIDE_MAP"] = "Скрыть карту"
L["TURN_IN_XP"] = "%s опыта"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "Сдача: %s"
L["TURN_IN_TOOLTIP"] = "Можно сдать"
L["RESIZE_TOOLTIP"] = "Перетащите, чтобы изменить размер журнала заданий."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Поделиться заданиями"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Предлагает группе задания этой зоны, которые игра позволяет передать, по одному каждые %d сек."
L["CHAT_SHARING_ZONE_ONE"] = "Передаётся 1 задание из зоны %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] =
	"Передаётся заданий: %d из зоны %s, по одному каждые %d сек."
L["CHAT_SHARING_ZONE_NONE"] =
	"Ни одним из ваших заданий из зоны %s нельзя поделиться."

--------------------------------------------------------------------------------
-- Routes on Zone Map and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Вы на месте"
L["ROUTES_OBJECTIVE_AREA"] = "Область цели"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d м"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "Ещё +%d здесь"
L["ROUTES_TURN_IN"] = "Сдать задание"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Сдать: %s"
L["ROUTES_CORPSE"] = "Ваше тело"
L["ROUTES_CORPSE_HINT"] = "Вернитесь к нему, чтобы воскреснуть"
-- TRANSLATORS: Heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Ищите"
-- TRANSLATORS: %s is the party members a waypoint's objective is for, such as "Alice, Bob"
L["ROUTES_FOR_MEMBERS"] = "Для: %s"
L["ROUTES_CLICK_DRAG"] = "Перетаскивание"
L["ROUTES_CLICK_RIGHT"] = "Правый щелчок"
L["ROUTES_CLICK_MIDDLE"] = "Средний щелчок"
L["ROUTES_DRAG_MOVE"] = "Переместить Стрелку заданий"
L["ROUTES_RIGHT_CLICK_REROUTE"] = "Обойти текущую цель"
L["ROUTES_MIDDLE_CLICK_RESET"] = "Сбросить все маршруты"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Маршрут проложен в обход: %s."
L["ROUTES_RESET"] =
	"Все маршруты сброшены: обойдённые цели снова на маршруте."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

-- TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
-- each %s is a quest link or a list of them, and each %d is how many quests
L["WHISPER_SHARE_FAILED"] =
	"Не вышло передать %s. Нужно задание? Напиши, как сможешь, передам снова"
L["WHISPER_SHARE_FAILED_AGAIN"] = "И %s тоже"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Мои задания здесь (%d): %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Моё задание здесь: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Ещё мои задания здесь: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Отслеживание Questie не может показать %s, потому что этого задания нет в базе данных Questie."
L["QUESTIE_CANNOT_TRACK"] = "Questie пока не может отслеживать это задание."
