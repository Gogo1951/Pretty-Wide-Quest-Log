local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "koKR")
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
	"버전 %s. 설정(이 메시지를 끄는 옵션 포함)은 설정 > 애드온 > Pretty Wide Quest Log에 있습니다. 이 애드온이 마음에 드시나요? 친구에게 알려 주시거나, CurseForge에서 즐겨찾기에 추가하시거나, GitHub에서 Star를 눌러 주세요. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 창을 열 수 없습니다."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"안전을 위해 전투 중에는 게임의 단축키 설정을 열 수 없습니다."
-- TRANSLATORS: the first %s is the game menu's Options label, the second its Key Bindings label, both from the client
L["KEY_BINDINGS_LOCATION"] =
	"게임 메뉴를 열고 %s, %s 순서로 들어간 다음 Pretty Wide Quest Log 항목을 찾으세요."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Questie가 없으면 퀘스트 지도에 표시되는 내용이 줄고, 연계 퀘스트와 완료 보상 합계가 숨겨집니다. 보려면 애드온 목록에서 Questie를 켜세요."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus도 켜져 있어 두 애드온이 퀘스트 목록을 두고 충돌합니다. 애드온 목록에서 Wide Quest Log Plus를 끈 다음 UI를 다시 불러오세요."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"레벨업을 위한 넓은 퀘스트 목록이자 퀘스트 도우미입니다. 직접 고른 퀘스트를 잇는 퀘스트 경로, 경유지 화살표, 퀘스트 레벨, 태그, 보상, 연계 퀘스트, 퀘스트 지도, 파티 퀘스트 공유를 지원합니다. Questie, Spoken, VoiceOver, ElvUI와 함께 작동합니다."
L["ENABLE_WELCOME_MESSAGE"] = "환영 메시지 사용"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "접속할 때 Pretty Wide Quest Log 환영 메시지를 표시합니다."
L["OPTIONS_FEATURES_HEADER"] = "기능"
L["ENABLE_WIDE_QUEST_LOG"] = "넓은 퀘스트 목록 사용"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"블리자드 퀘스트 목록을 지도가 옆에 붙은 넓은 퀘스트 목록으로 바꿉니다. UI를 다시 불러온 후에 적용됩니다."
L["ENABLE_QUALITY_OF_LIFE"] = "편의 기능 사용"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"파티원이 내 퀘스트를 받도록 돕습니다. 공유 속도 조절, 공유를 놓친 파티원에게 귓속말, 던전 퀘스트 알림과 공유가 포함됩니다. 퀘스트 목록에서 지역마다 있는 퀘스트 공유 버튼은 이 설정을 꺼도 작동합니다."
L["ENABLE_WAYPOINT_MARKERS"] = "경유지 표식 사용"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"지역 지도에서 각 목표의 퀘스트 아이콘을 몬스터나 물체가 가장 많은 곳의 표식 하나, 즉 경유지로 묶고, 완료 보고 장소마다 표식을 하나씩 둡니다. 표식에 마우스를 올리면 그 표식이 대신하는 아이콘을 볼 수 있습니다."
L["ENABLE_QUEST_ROUTE"] = "퀘스트 경로 사용"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"지역 지도에 경유지 표식을 가까운 곳부터 잇는 경로를 그리며, 내 위치에서 각 표식까지 차례로 움직이는 점으로 표시합니다. 경유지 표식이 필요합니다."
L["ENABLE_QUEST_ARROW"] = "퀘스트 화살표 사용"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"경로의 다음 경유지를 가리키는 화살표인 퀘스트 화살표를 화면에 표시하고, 그곳에서 할 퀘스트와 목표를 함께 보여 줍니다. 기본적으로 공격대와 인스턴스에서는 숨겨집니다."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"넓은 퀘스트 목록 사용은 UI를 다시 불러온 후에 적용되며, 설정 창을 닫을 때 다시 불러오기를 안내합니다."
L["RELOAD_PROMPT"] =
	"Pretty Wide Quest Log는 UI를 다시 불러온 후에 퀘스트 목록을 전환합니다. 지금 다시 불러오시겠습니까?"
L["OPTIONS_KEY_BINDINGS_HEADER"] = "단축키 설정"
L["OPTIONS_KEY_SET"] = "키 지정"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"게임의 단축키 설정을 엽니다. 그곳에 Pretty Wide Quest Log 전용 항목이 있습니다."
L["OPTIONS_KEY_BINDING_USE_QUEST_ITEM_DESCRIPTION"] =
	"퀘스트 화살표의 첫 번째 아이템 사용 버튼에 있는 아이템을 버튼을 클릭한 것과 똑같이 사용합니다. 전투 중에도 작동합니다."
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 창을 엽니다."

--------------------------------------------------------------------------------
-- Options: Wide Quest Log Panels
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "넓은 퀘스트 목록"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"블리자드 퀘스트 목록을 넓은 목록으로 바꿉니다. 퀘스트가 지역별로 나열되고, 옆에 선택한 퀘스트의 세부 정보와 지도가 표시됩니다."
L["QUEST_LOG_SORTING_HEADER"] = "정렬"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "지역과 그 아래 퀘스트의 순서를 고르세요."
L["QUEST_LOG_ROWS_HEADER"] = "퀘스트 줄"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "각 줄에 표시할 내용을 고르세요."
L["TAB_WINDOW_MAP"] = "창 및 지도"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"창과 지도 크기를 화면에 맞게 조절하고, 어떻게 동작할지 고르세요."
L["ZONE_ORDER"] = "지역 순서"
L["ZONE_ORDER_DESCRIPTION"] = "퀘스트 목록에서 지역의 순서를 바꿉니다."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "평균 레벨, 높은 순 (기본값)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "평균 레벨, 낮은 순"
L["SORT_ALPHABETICAL"] = "이름순"
L["CURRENT_ZONE_FIRST"] = "현재 지역 먼저 표시"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"지역 순서와 관계없이 지금 있는 지역을 목록 맨 위에 둡니다."
L["ZONE_GAP"] = "지역 이름 위에 여백 추가"
L["ZONE_GAP_DESCRIPTION"] =
	"각 지역 이름 위에 약간의 여백을 추가합니다. 퀘스트가 여러 지역에 흩어져 있다면 유용합니다."
L["QUEST_ORDER"] = "퀘스트 순서"
L["QUEST_ORDER_DESCRIPTION"] = "각 지역 아래 퀘스트의 순서를 바꿉니다."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "레벨, 높은 순 (기본값)"
L["SORT_LEVEL_LOWEST"] = "레벨, 낮은 순"
L["COMPLETED_FIRST"] = "완료한 퀘스트 먼저 표시"
L["COMPLETED_FIRST_DESCRIPTION"] = "완료 보고할 수 있는 퀘스트를 해당 지역의 맨 위로 옮깁니다."
L["SHOW_QUEST_LEVELS"] = "퀘스트 레벨 표시"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"목록에서 각 퀘스트 이름 앞에 레벨과 유형을 붙입니다. 예를 들어 40레벨 던전 퀘스트는 %s(으)로 표시됩니다."
L["MARK_UNTRACKED"] = "추적하지 않는 퀘스트 표시"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"추적 중인 퀘스트의 체크 %s 표시가 사라지고, 대신 추적하지 않는 퀘스트에 눈 %s 표시가 붙습니다. 거의 모든 퀘스트를 추적한다면 유용합니다."
L["CLOSE_IN_COMBAT"] = "전투 시작 시 닫기"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"전투가 시작되면 퀘스트 목록을 닫아 화면을 가리지 않게 합니다."
L["SHOW_OBJECTIVE_AREAS"] = "목표 구역 표시"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"퀘스트 목록 옆 지도에 각 목표의 몬스터와 사물이 있는 곳을 음영으로 표시하고, 생성 지점마다 아이콘을 두는 대신 구역마다 아이콘을 하나만 표시합니다."
L["NEEDS_QUESTIE_HINT"] = "이 기능을 사용하려면 Questie를 켜세요."
L["SHOW_ZONE_INFO"] = "지역 정보 표시"
L["SHOW_ZONE_INFO_DESCRIPTION"] =
	"지도 아래에 지도가 보여 주는 지역을 위해 다른 지역에서 받을 수 있는 퀘스트와, 그 지역 퀘스트가 요구하는 아이템을 보여 줍니다. 자리를 만들기 위해 지도가 창 높이의 절반으로 줄어듭니다."
L["WINDOW_SCALE"] = "퀘스트 목록 크기 비율"
L["WINDOW_SCALE_DESCRIPTION"] =
	"퀘스트 목록을 크게 또는 작게 만듭니다. 옆의 지도도 함께 커지고 작아집니다."
L["MAP_SCALE"] = "지도 크기 비율"
L["MAP_SCALE_DESCRIPTION"] =
	"퀘스트 목록 옆의 지도를 크게 또는 작게 만듭니다. 퀘스트 목록 크기 비율에 더해 적용됩니다."
L["RESET_WINDOW_BUTTON"] = "창 초기화"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"퀘스트 목록의 높이와 크기 비율, 지도 크기 비율을 기본값으로 되돌립니다."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"퀘스트 목록의 높이와 크기 비율, 지도 크기 비율을 기본값으로 되돌리고, 창을 처음 위치로 옮깁니다."
L["RESET_WINDOW_SCALE_CONFIRM"] =
	"퀘스트 목록의 높이와 크기 비율, 지도 크기 비율을 초기화할까요?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"퀘스트 목록의 높이와 크기 비율, 지도 크기 비율, 창의 화면 위치를 초기화할까요?"
L["HANDY_CLICKS_HEADER"] = "유용한 클릭"
L["HANDY_CLICK_TRACK"] = "퀘스트 Shift-클릭"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "추적하거나 추적을 해제합니다."
L["HANDY_CLICK_MENU"] = "퀘스트 오른쪽 클릭"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "추적, 공유 또는 포기합니다."
L["HANDY_CLICK_ID"] = "퀘스트 ID 클릭"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Wowhead 링크를 받습니다."
L["QUEST_LOG_SUB_PANELS_DESCRIPTION"] =
	"세부 설정은 이 패널 아래에 있는 퀘스트 리스트, 퀘스트 세부 정보, 창 및 지도, NPC 대화 패널에 있습니다."
L["NEEDS_WIDE_QUEST_LOG"] =
	"넓은 퀘스트 목록을 위한 설정입니다. 사용하려면 넓은 퀘스트 목록 패널에서 넓은 퀘스트 목록 사용을 켜세요."
L["TAB_QUEST_LIST"] = "퀘스트 리스트"
L["TAB_QUEST_LIST_DESCRIPTION"] = "퀘스트 목록 왼쪽에 지역별로 나열되는 내 퀘스트입니다."
L["TAB_QUEST_DETAILS"] = "퀘스트 세부 정보"
L["TAB_QUEST_DETAILS_DESCRIPTION"] =
	"퀘스트 리스트 옆 양피지에 표시되는, 선택한 퀘스트의 세부 정보입니다."

--------------------------------------------------------------------------------
-- Options: NPC Dialogue Panel
--------------------------------------------------------------------------------

L["TAB_NPC_DIALOGUE"] = "NPC 대화"
L["TAB_NPC_DIALOGUE_DESCRIPTION"] =
	"NPC에게 말을 걸면 열리는 창으로, 퀘스트 NPC 창과 대화 창입니다. 이 설정은 넓은 퀘스트 목록 사용 여부와 관계없이 작동합니다."
L["QUEST_GIVERS_HEADER"] = "퀘스트 NPC"
L["QUEST_GIVERS_DESCRIPTION"] =
	"퀘스트 NPC가 여는 창으로, 여기서 퀘스트를 받고 완료 보고합니다."
L["GIVER_CLEANUP"] = "퀘스트 NPC 창 정리"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"퀘스트 NPC 창의 글을 퀘스트 목록과 같은 제목과 줄 간격으로 배치하고, 퀘스트 아래에 Wowhead로 연결되는 퀘스트 ID를 표시합니다."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"퀘스트 NPC의 퀘스트 목록에 %s 같은 퀘스트 목록의 레벨 태그를 붙입니다."
L["FONT_DIALOGUE_NEEDS_CLEANUP"] =
	"글꼴은 퀘스트 NPC 창 정리의 일부이므로, 그 설정을 켜야 합니다."

--------------------------------------------------------------------------------
-- Options: Font Sections
--------------------------------------------------------------------------------

L["FONT_HEADER"] = "글꼴"
L["FONT_LIST_DESCRIPTION"] = "퀘스트 리스트의 지역 이름과 퀘스트에 쓰는 글꼴입니다."
L["FONT_DETAILS_DESCRIPTION"] =
	"퀘스트 세부 정보의 제목, 소제목, 퀘스트 내용에 쓰는 글꼴입니다."
L["FONT_DIALOGUE_DESCRIPTION"] =
	"퀘스트 NPC 창과 대화 창의 제목, 소제목, 퀘스트 내용에 쓰는 글꼴입니다."
L["FONT_WINDOW_DESCRIPTION"] = "창 제목, 퀘스트 개수, 완료 보상 줄에 쓰는 글꼴입니다."
L["FONT_FACE"] = "글꼴"
L["FONT_FACE_DESCRIPTION"] =
	"글자 모양입니다. 게임 기본값은 게임 글꼴을 따르며, 게임 글꼴을 바꾸는 애드온도 따릅니다. SharedMedia로 추가한 글꼴도 목록에 표시됩니다."
L["FONT_GAME_DEFAULT"] = "게임 기본값"
L["FONT_GAME_STANDARD"] = "일반 텍스트"
L["FONT_GAME_NAMES"] = "캐릭터 이름"
L["FONT_GAME_DAMAGE"] = "피해량 숫자"
L["FONT_SIZE"] = "크기"
L["FONT_SIZE_DESCRIPTION"] =
	"게임 글자 크기를 기준으로 포인트 단위로 글자를 크게 또는 작게 만듭니다. 0이면 게임 크기를 그대로 유지합니다."
L["FONT_OUTLINE"] = "외곽선"
L["FONT_OUTLINE_DESCRIPTION"] =
	"각 글자 둘레의 검은 외곽선입니다. 게임 기본값은 게임 글꼴의 외곽선을 그대로 유지하고, 없음은 외곽선을 없앱니다."
L["FONT_OUTLINE_DEFAULT"] = "게임 기본값"
L["FONT_OUTLINE_NONE"] = "없음"
L["FONT_OUTLINE_THIN"] = "얇게"
L["FONT_OUTLINE_THICK"] = "두껍게"
L["FONT_SHADOW"] = "글자 그림자"
L["FONT_SHADOW_DESCRIPTION"] =
	"게임 글꼴이 글자 뒤에 넣는 그림자를 유지합니다. 끄면 그림자가 사라지며, 글꼴이 흐릿하거나 번져 보일 때 도움이 됩니다."
L["FONT_SLUG"] = "더 선명한 글자 (Slug)"
L["FONT_SLUG_DESCRIPTION"] =
	"블리자드의 새 Slug 렌더러로 글자를 그려, 어떤 크기에서도 글자가 더 선명해집니다. Slug는 두꺼운 외곽선이나 그림자를 그릴 수 없으므로, 둘 중 하나가 있는 글자는 원래 방식으로 그립니다."
L["FONT_RESET_BUTTON"] = "글꼴 초기화"
L["FONT_RESET_DESCRIPTION"] = "이 글꼴의 설정을 기본값으로 되돌립니다."

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "편의 기능"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"퀘스트 목록 바깥에서 돕는 작은 기능들입니다. 파티원과의 퀘스트 공유와 던전을 위한 기능이 있습니다."
L["QUEST_SHARING_HEADER"] = "퀘스트 공유"
L["QUEST_SHARING_INTRO"] =
	"퀘스트 목록에서 지역 이름에 마우스를 올리고 퀘스트 공유를 클릭하면 그 지역에서 공유할 수 있는 퀘스트를 모두 하나씩 차례로 파티에 제안합니다. 이 설정에서 그 속도와 누군가 퀘스트를 놓쳤을 때 어떻게 할지 정합니다."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"지역 이름의 퀘스트 공유 버튼을 사용하려면 넓은 퀘스트 목록 사용이 필요합니다. 던전 퀘스트 공유는 이 설정 없이도 작동합니다."
L["SHARE_INTERVAL"] = "공유 간격(초)"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"공유한 퀘스트 하나와 다음 퀘스트 사이에 기다리는 시간으로, 지역이나 던전의 퀘스트를 공유할 때 적용됩니다. 길수록 파티원이 각 퀘스트를 수락할 시간이 늘어납니다."
L["SHARE_WHISPERS"] = "공유 실패 시 귓속말"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"파티원이 다른 일을 하고 있거나, 너무 멀리 있거나, 퀘스트 목록이 가득 찼을 때 공유하려던 퀘스트를 귓속말로 알려 주고 다시 말해 달라고 부탁합니다. 파티원이 퀘스트를 받을 자격이 없거나, 이미 진행 중이거나, 이미 완료했다면 아무것도 보내지 않습니다."
L["ZONE_SHARE_OFFERS"] = "새 파티원에게 내 지역 퀘스트가 없을 때 알림"
L["ZONE_SHARE_OFFERS_DESCRIPTION"] =
	"파티에 들어가거나 누군가 내 파티에 들어오면 Questie가 퀘스트 목록을 주고받도록 20초 기다린 뒤, 내 지역에 목표가 있는 내 퀘스트 중 새 파티원에게 없는 퀘스트 수를 대화창에 알려 주어 퀘스트 공유를 누를 수 있게 합니다. 공유할 수 있는 퀘스트만 세며, 여러 명에게 없어도 한 번만 셉니다. 누구에게도 메시지를 보내지 않습니다. 퀘스트를 확인할 수 없는 파티원(Questie 없음, 거리 밖)은 세지 않습니다. 누군가 들어올 때마다 한 번 알리며, 던전이나 공격대에서는 알리지 않습니다."
L["ZONE_SHARE_OFFERS_SOUND"] = "소리 재생"
L["ZONE_SHARE_OFFERS_SOUND_DESCRIPTION"] =
	"대화창이 바쁠 때를 위해 알림과 함께 경고음을 재생합니다."
L["ZONE_SHARE_SOUND_PREVIEW"] = "클릭하면 경고음을 들어 볼 수 있습니다."
L["SAMPLE_EXAMPLE"] = "예시: %s"
L["SAMPLE_QUEST_LOADING"] = "퀘스트 ID 불러오는 중: %d"
L["DUNGEON_QUESTS_HEADER"] = "던전 퀘스트"
L["DUNGEON_QUESTS_INTRO"] =
	"파티와 함께 던전에 들어가면 모두가 거리 안에 들어왔을 때(WoW Forever에서는 바로) 그곳의 내 퀘스트를 알리고 공유하며, 같은 파티에 두 번 하지는 않습니다. Questie가 있으면 목표가 안에 있는 퀘스트도 포함되며, 직업 퀘스트도 들어갑니다. 공격대에서는 작동하지 않습니다."
L["DUNGEON_ANNOUNCE"] = "던전 퀘스트 자동 알림"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"방금 들어간 던전에서 아직 해야 할 퀘스트를 파티에 알려, 모두가 무엇을 챙겨야 할지 알 수 있게 합니다. 완료 보고만 남은 퀘스트는 빠집니다."
L["DUNGEON_SHARE"] = "던전 퀘스트 자동 공유"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"그 던전의 퀘스트 중 게임이 공유를 허용하고 아직 없는 파티원이 있는 퀘스트를 모두, 퀘스트 공유에서 정한 속도로, 모두가 거리 안에 들어오면(또는 1분 뒤, WoW Forever에서는 바로) 공유합니다. 파티원마다 던전당 한 번 받으므로 나중에 들어온 사람도 받으며, 나갔다 다시 들어와도 다시 공유하지 않습니다. 공유 실패 시 귓속말이 켜져 있으면 공유를 놓친 파티원에게 귓속말을 보내 다시 요청할 수 있게 합니다."

--------------------------------------------------------------------------------
-- Options: Maps & Objectives Panels
--------------------------------------------------------------------------------

L["TAB_MAPS_OBJECTIVES"] = "지도 및 목표"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"여러 퀘스트 아이콘 대신, 지역 지도에 목표와 완료 보고 장소마다 표식을 하나씩 표시합니다."
L["MAPS_SUB_PANELS_DESCRIPTION"] =
	"각 지도의 설정은 이 패널 아래에 있는 미니맵, 지역 지도, 대륙 및 세계 지도 패널에 있습니다."
L["MAPS_NEED_MARKERS"] = "표식은 경유지 표식 사용이 켜져 있을 때만 표시됩니다."
L["TAB_MINIMAP"] = "미니맵"
L["TAB_MINIMAP_DESCRIPTION"] =
	"미니맵의 Questie 아이콘은 무엇이 어디에 나타나고 어디서 획득하는지 정확히 보여 주므로 항상 그대로 둡니다. 경로 표식은 그 옆에 표시할 수 있습니다."
L["SHOW_MINIMAP_MARKERS"] = "미니맵에 경유지 표식 표시"
L["SHOW_MINIMAP_MARKERS_DESCRIPTION"] =
	"경로의 각 경유지마다 미니맵의 Questie 아이콘 옆에 작은 표식을 표시합니다. 표식에 마우스를 올리면 해당 퀘스트를 볼 수 있습니다."
L["MINIMAP_MARKER_SIZE_DESCRIPTION"] = "미니맵에 표시되는 경로 표식의 크기입니다."
L["TAB_ZONE_MAP"] = "지역 지도"
L["TAB_ZONE_MAP_DESCRIPTION"] = "경로가 경유지 표식 사이를 잇는 지역의 지도입니다."
L["FULL_SIZE_MAP"] = "지역 지도를 최대 크기로 열기"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"지도의 최대화 버튼을 누른 것처럼 지역 지도를 최대화해서 열어 경로가 들어갈 공간을 확보합니다. 지도를 줄여도 다음에는 다시 최대 크기로 열립니다."
L["HIDE_QUESTIE_ICONS"] = "경로의 퀘스트 아이콘 숨기기"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"경로에 있는 대상의 Questie 지도 아이콘과 블리자드 퀘스트 마커 및 목표 지역을 숨기고, 경로의 표식이 대신 표시되게 합니다. 파티원 목표를 나타내는 Questie의 흐린 아이콘도 숨깁니다. 표식에 마우스를 올리면 Questie 아이콘을 볼 수 있습니다."
L["MARKER_SIZE"] = "표식 크기"
L["MARKER_SIZE_DESCRIPTION"] = "지역 지도에 표시되는 경로 표식의 크기입니다."
L["MARKER_SIZE_SMALL"] = "작게"
L["MARKER_SIZE_MEDIUM"] = "보통"
L["MARKER_SIZE_LARGE"] = "크게"
L["MARKER_SIZE_HUGE"] = "아주 크게"
L["WAYPOINTS_SHOWN"] = "표시할 경유지"
L["WAYPOINTS_SHOWN_DESCRIPTION"] =
	"지역 지도에 경로를 얼마나 그릴지 정합니다. 전체 경로는 계속 계획됩니다. 이 경유지들 다음에는 … 표식이 다음 방향을 가리키고, 마우스를 올리면 나머지가 보입니다. 클릭하면 지도를 닫을 때까지 전체 경로가 보입니다."
-- TRANSLATORS: a Waypoints Shown choice; %d is how many waypoints, 5, 10 or 20
L["WAYPOINTS_SHOWN_NEXT"] = "다음 %d개"
L["WAYPOINTS_SHOWN_ALL"] = "전체 경로"
L["TAB_WIDE_MAP"] = "대륙 및 세계 지도"
L["TAB_WIDE_MAP_DESCRIPTION"] =
	"여러 지역을 한 번에 담는 지도로, 각 목표와 완료 보고마다 더 작은 표식이 하나씩 표시됩니다."
L["SHOW_WIDE_MAP_MARKERS"] = "대륙 및 세계 지도에 경유지 표식 표시"
L["SHOW_WIDE_MAP_MARKERS_DESCRIPTION"] =
	"대륙 및 세계 지도에 각 목표와 완료 보고마다 Questie 아이콘 대신 표식을 표시합니다. 끄면 그곳에 Questie 아이콘이 대신 표시됩니다."
L["WIDE_MAP_MARKER_SIZE_DESCRIPTION"] =
	"대륙 및 세계 지도에 표시되는 경로 표식의 크기입니다. 이 지도들은 여러 지역을 담기 때문에 각 크기가 지역 지도보다 작습니다."

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "퀘스트 경로"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"현재 위치에서 시작해 경유지 표식을 할 순서대로 잇는, 지역 지도 위의 경로입니다."
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"퀘스트 경로는 경유지 표식 사이를 잇기 때문에, 경유지 표식 사용이 켜져 있을 때만 표시됩니다."
L["ROUTES_LINE_HEADER"] = "경로선"
L["ROUTES_LINE_DESCRIPTION"] = "내 위치에서 각 표식까지 이어지는 움직이는 점입니다."
L["LINE_SPEED"] = "경로선 속도"
L["LINE_SPEED_DESCRIPTION"] = "점이 다음 표식을 향해 움직이는 속도입니다."
L["LINE_SPEED_STILL"] = "정지"
L["LINE_SPEED_SLOW"] = "느리게"
L["LINE_SPEED_NORMAL"] = "보통"
L["LINE_SPEED_FAST"] = "빠르게"
L["LINE_OPACITY"] = "경로선 불투명도"
L["LINE_OPACITY_DESCRIPTION"] =
	"점이 얼마나 진하게 보이는지 정합니다. 낮을수록 지도가 더 많이 비쳐 보입니다."
L["ROUTES_PLANNING_HEADER"] = "계획"
L["ROUTES_PLANNING_DESCRIPTION"] = "경로가 내 퀘스트 외에 함께 계획하는 것입니다."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_PREDICTIVE
L["PREDICTIVE_ROUTES"] = "예측 퀘스트 경로"
L["PREDICTIVE_ROUTES_DESCRIPTION"] =
	"근처뿐 아니라 퀘스트를 주는 NPC가 어디에 있든, 이 지역에서 끝낼 수 있는 퀘스트를 미리 계획합니다. 목표, 완료 보고, 이어지는 퀘스트까지 포함됩니다. 경로는 지역의 한 구역에 가기 전에 그곳에 필요한 퀘스트를 모두 받게 하므로 한 번만 가면 됩니다. 연계 퀘스트는 다른 지역으로 이어지는 첫 퀘스트에서 멈춥니다. 아직 받지 않은 퀘스트의 목표는 회색 표식으로 표시됩니다. 각 퀘스트의 완료 보고 위치도 완료 전부터 Questie의 회색 물음표로 표시됩니다."
-- TRANSLATORS: a popup with an Okay button each time Predictive Questing Routes is turned on
L["PREDICTIVE_ROUTES_POPUP"] =
	"알림: 예측 퀘스트 경로는 지역 전체를 미리 계획하므로 지도가 좀 복잡해 보일 수 있습니다. 하지만 다 이유가 있습니다! 퀘스트 화살표를 따라가면 달리는 시간은 줄고 경험치를 얻는 시간은 늘어납니다. (="
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_FLIGHTS
L["SHOW_FLIGHT_PATHS"] = "발견하지 않은 비행 경로를 목표로 표시"
L["SHOW_FLIGHT_PATHS_DESCRIPTION"] =
	"현재 지역에서 아직 비행 경로를 얻지 않은 비행 조련사를 경로에 추가하고 비행 조련사 아이콘으로 표시합니다. 이미 비행 경로를 가진 캐릭터라면 아무 비행 지도나 한 번 열어 내가 가진 비행 경로를 경로가 알 수 있게 하세요. 그 전까지는 아무것도 추가되지 않습니다."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_MENU_SHOWN_LOCAL
L["SHOW_LOCAL_QUESTS"] = "주변의 받을 수 있는 퀘스트를 목표로 표시"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"Questie가 받을 수 있다고 표시하고, 퀘스트를 주는 NPC나 물체가 %s 이내에 있는 퀘스트를 경로에 넣고 Questie의 느낌표로 표시합니다. 전리품 아이템으로 시작하는 퀘스트와 던전 및 공격대 퀘스트는 제외됩니다."
L["LOCAL_QUESTS_HEADER"] = "주변의 받을 수 있는 퀘스트"
L["LOCAL_QUESTS_DESCRIPTION"] =
	"퀘스트 화살표가 주변의 어떤 퀘스트로 안내할지 정합니다. 건너뛴 퀘스트도 경로 선 없이 세계 지도에 표시될 수 있습니다."
L["LOCAL_QUEST_RANGE"] = "검색 범위"
L["LOCAL_QUEST_RANGE_DESCRIPTION"] =
	"퀘스트를 주는 대상이 몇 미터 안에 있어야 포함되는지 정합니다. 400 미만이면 경로를 다시 계산하는 사이에 지나친 대상을 놓칠 수 있습니다."
L["LOCAL_ESCORT_QUESTS"] = "호위 퀘스트"
L["LOCAL_ESCORT_QUESTS_DESCRIPTION"] =
	"가는 길에 NPC를 지켜야 하는 퀘스트로, 시간이 걸리고 파티가 필요한 경우가 많습니다. 지도 표식은 초록색입니다."
L["LOCAL_GROUP_QUESTS"] = "파티 및 정예 퀘스트"
L["LOCAL_GROUP_QUESTS_DESCRIPTION"] = "Questie가 정예로 표시한, 파티용 퀘스트입니다."
L["LOCAL_OTHER_ZONE_QUESTS"] = "다른 지역의 목표"
L["LOCAL_OTHER_ZONE_QUESTS_DESCRIPTION"] =
	"목표나 보고 장소가 현재 지역 밖에만 있는 퀘스트입니다. 다음 마을로 보내는 퀘스트 등이 해당합니다."
L["LOCAL_QUEST_LEVEL"] = "최저 퀘스트 레벨"
L["LOCAL_QUEST_LEVEL_DESCRIPTION"] =
	"이 난이도 색보다 낮은 퀘스트는 제외됩니다. Questie 설정은 Questie가 지도에 표시하는 퀘스트를 그대로 둡니다."
-- TRANSLATORS: a choice for a kind of nearby quest: the Quest Arrow takes you there
L["LOCAL_CHOICE_ROUTE"] = "경로에 포함"
-- TRANSLATORS: a choice for a kind of nearby quest: a marker on the world map, but the Quest Arrow skips it
L["LOCAL_CHOICE_MAP"] = "지도에만"
-- TRANSLATORS: a choice for a kind of nearby quest: neither the route nor its map markers show it
L["LOCAL_CHOICE_OFF"] = "제외"
L["LOCAL_LEVEL_QUESTIE"] = "Questie 설정"
-- TRANSLATORS: quest difficulty colors, green being a few levels below the player
L["LOCAL_LEVEL_GREEN"] = "초록색 이상"
L["LOCAL_LEVEL_YELLOW"] = "노란색 이상"
L["ROUTES_PARTY_HEADER"] = "파티"
L["ROUTES_PARTY_DESCRIPTION"] = "파티가 경로에 더하는 것입니다."
L["PARTY_QUESTS"] = "파티원의 퀘스트 포함"
L["PARTY_QUESTS_DESCRIPTION"] =
	"파티 중에는 경로와 퀘스트 화살표에 파티원에게는 있고 나에게는 없는 퀘스트도 포함하며, 내 퀘스트와 똑같이 표시합니다. 이를 공유하려면 양쪽 모두 Questie가 있어야 합니다. 파티원의 던전 퀘스트는 목표가 던전 안에 있으므로 제외됩니다."
L["GROUP_UP"] = "파티와 합류"
L["GROUP_UP_DESCRIPTION"] =
	"파티 중에 같은 지역의 누군가가 내 미니맵 밖에 있으면, 퀘스트 화살표가 '파티와 합류'를 표시하고 그 사람이나 모두의 중간 지점을 가리키며, 세계 지도에도 그 위치가 표시되어 함께 퀘스트를 할 수 있습니다."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "퀘스트 화살표"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"경로의 다음 경유지를 가리키는 화면 위 화살표로, 그곳에서 할 퀘스트와 목표를 함께 보여 줍니다. 마우스를 올리면 목표를 하나씩 무시하고 무시한 항목을 확인할 수 있는 메뉴가 열립니다. 가운데 클릭하면 지역을 초기화하여 그곳에서 무시한 항목을 되돌립니다."
L["QUEST_ARROW_HEADER"] = "화살표"
L["QUEST_ARROW_DESCRIPTION"] = "퀘스트 화살표의 위치와 크기입니다."
L["ARROW_SIZE"] = "화살표 크기"
L["ARROW_SIZE_DESCRIPTION"] = "퀘스트 화살표와 그 아래 글자의 크기입니다."
L["LOCK_ARROW"] = "퀘스트 화살표 잠금"
L["LOCK_ARROW_DESCRIPTION"] = "퀘스트 화살표를 제자리에 고정해 끌어도 움직이지 않게 합니다."
L["RESET_ARROW"] = "화살표 위치"
L["RESET_ARROW_BUTTON"] = "초기화"
L["RESET_ARROW_CONFIRM"] = "퀘스트 화살표를 처음 위치로 되돌릴까요?"
L["RESET_ARROW_DESCRIPTION"] = "퀘스트 화살표를 처음 위치인 화면 위쪽 가운데로 되돌립니다."
L["QUEST_ARROW_TEXT_HEADER"] = "화살표 아래"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "퀘스트 화살표가 아래에 나열하는 내용입니다."
L["SHOW_DISTANCE"] = "거리 표시"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'다음 경유지까지 몇 미터 남았는지 표시합니다. "%s", "%s" 문구는 이 설정과 관계없이 표시됩니다.'
L["SHOW_ARROW_QUESTS"] = "퀘스트와 목표 표시"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"다음 경유지의 퀘스트를 나열하고, 각각 그곳에서 남은 할 일을 함께 표시합니다."
L["QUESTS_LISTED"] = "최대 표시 퀘스트 수"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'퀘스트 화살표가 한 경유지에 대해 아래에 나열하는 최대 퀘스트 수입니다. 나머지는 "%s"처럼 별도의 줄에 개수로 표시됩니다.'
L["SHOW_ITEM_BUTTONS"] = "퀘스트 아이템 버튼 표시"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"퀘스트 화살표가 나열하는 퀘스트 중 사용할 아이템이 있는 퀘스트 옆에 버튼을 놓습니다. 던지거나, 심거나, 대상에게 사용하는 아이템 등이 해당됩니다. 버튼을 클릭해 아이템을 사용하거나, Pretty Wide Quest Log 패널의 단축키 설정에서 퀘스트 아이템 사용에 키를 지정해 첫 번째 아이템을 사용하세요. 전투 중에는 전투가 끝날 때까지 버튼이 제자리에 있습니다."
-- TRANSLATORS: the same setting is a switch on the Quest Arrow's menu, labeled ROUTES_NEXT_OBJECTIVE
L["SHOW_NEXT_OBJECTIVE"] = "다음 목표 표시"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'"%s"일 때 그 아래에 "%s" 줄을 흐리게 표시해, 그다음 경유지를 가리키는 작은 화살표와 그곳에서 할 일을 보여 줍니다.'
L["QUEST_ARROW_HIDING_HEADER"] = "숨기기"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "퀘스트 화살표를 숨기는 경우입니다."
L["HIDE_IN_RAIDS"] = "공격대에서 숨기기"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "공격대에 있는 동안 퀘스트 화살표를 숨깁니다."
L["HIDE_IN_INSTANCES"] = "인스턴스에서 숨기기"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "던전, 공격대, 전장에서 퀘스트 화살표를 숨깁니다."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Pretty Wide Quest Log의 레벨 업을 도와주세요"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"이 애드온은 이 게임을 사랑하고 모두가 최대한 즐겁게 플레이하기를 바라는 플레이어들이 만들었습니다. 후원을 요청하는 일은 절대 없을 겁니다. 저희의 작업이 여러분의 게임을 조금 더 좋게 만든다는 것이 진정한 보람입니다. 그렇다면 꼭 이야기해 주세요!"
L["OPTIONS_LEVEL_UP_WAYS"] =
	"더 많은 플레이어에게 다가갈 수 있도록 도와주실 수 있는 방법을 소개합니다."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• 피드백 공유: 버그를 찾으셨거나 아이디어가 있으신가요? Discord에서 알려 주세요. 여러분의 피드백은 애드온을 개선하는 데 도움이 되며, 풀 리퀘스트도 언제나 환영합니다."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• 친구에게 알리기: 이 애드온을 좋아할 만한 사람을 알고 계신가요? 그분께 알려 주세요. 입소문은 더 많은 플레이어가 좋은 애드온을 발견하는 데 도움이 됩니다."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• CurseForge에서 즐겨찾기: 아래 CurseForge 링크를 열고 로그인한 다음, 다운로드 버튼 아래의 별을 클릭하세요. 즐겨찾기는 더 많은 플레이어가 애드온을 발견하는 데 도움이 됩니다."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• GitHub에서 Star 누르기: 아래 GitHub 링크를 열고 로그인한 다음, 오른쪽 위의 Star를 클릭하세요. 별이 많을수록 프로젝트가 더 많은 무료 개발자 도구를 받을 자격을 얻는 데 도움이 됩니다."
L["OPTIONS_LEVEL_UP_THANKS"] = "Pretty Wide Quest Log를 선택해 주셔서 감사합니다!"
L["OPTIONS_FEEDBACK"] = "피드백 및 지원"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "피드백 및 지원 링크"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "링크를 복사하려면 링크 상자를 클릭한 다음 Ctrl+A와 Ctrl+C를 누르세요."
L["OPTIONS_VERSION"] = "버전 %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "던"
L["QUEST_SUFFIX_RAID"] = "공"
L["QUEST_SUFFIX_PVP"] = "전"
L["QUEST_SUFFIX_GROUP"] = "파"
L["QUEST_SUFFIX_ELITE"] = "정"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "던전"
L["QUEST_TYPE_RAID"] = "공격대"
L["QUEST_TYPE_GROUP"] = "파티"
L["QUEST_TYPE_ELITE"] = "정예"
L["QUEST_TYPE_PVP"] = "PvP"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "레벨 뒤 글자: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s(%s)"
L["QUEST_ID"] = "퀘스트 ID %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "연계 퀘스트 (%d/%d)"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "일일 퀘스트 초기화까지 %s 남았습니다."
L["WOWHEAD_LINK_TOOLTIP"] = "클릭하면 Wowhead 링크를 받습니다."
L["WOWHEAD_LINK_COPY"] = "Ctrl+C(Mac에서는 Cmd+C)를 눌러 Wowhead 링크를 복사하세요."
L["EXPAND_ALL"] = "모두 펼치기"
L["COLLAPSE_ALL"] = "모두 접기"
L["TRACK_ALL"] = "모두 추적"
L["UNTRACK_ALL"] = "모두 추적 해제"
L["HIDE_MAP"] = "지도 숨기기"
L["ZONE_INFO_QUESTS"] = "받을 수 있는 퀘스트"
L["ZONE_INFO_ITEMS"] = "챙겨 갈 것"
-- TRANSLATORS: Zone Info's Things to Bring heading; %s is the zone the box shows, from the client
L["ZONE_INFO_ITEMS_TO"] = "%s에 챙겨 갈 것"
L["ZONE_INFO_BACK"] = "퀘스트로 돌아가기"
L["ZONE_INFO_ASK"] = "공유 요청"
L["ZONE_INFO_ASK_DESCRIPTION"] =
	"이곳에서 공유할 수 있는 퀘스트를 대화창에 적어 둡니다. 4번 채널(파티 찾기)에 들어가 있으면 그 채널로 적습니다. Enter를 누르기 전에는 아무것도 보내지 않습니다."
-- TRANSLATORS: %s is quest links, or names in brackets, joined by commas; it's written into the chat box, never sent
L["ZONE_INFO_ASK_MESSAGE"] = "%s 공유해 주실 분 있나요?"
-- TRANSLATORS: %s is a quest giver's name
L["ZONE_INFO_GIVER"] = "제공: %s"
-- TRANSLATORS: where a quest giver stands: map coordinates ("55,52"), then the zone
L["ZONE_INFO_GIVER_PLACE"] = "%s - %s"
L["ZONE_INFO_SHAREABLE"] = "공유 가능"
L["ZONE_INFO_NOT_SHAREABLE"] = "공유 불가"
L["ZONE_INFO_TRACK"] = "경로에 추가"
L["ZONE_INFO_UNTRACK"] = "경로에서 빼기"
-- TRANSLATORS: an item tooltip's heading after "PWQL //"; the quests that need the item are listed under it
L["ZONE_INFO_NEEDED_FOR"] = "필요한 퀘스트"
L["ZONE_INFO_SHIFT_CLICK"] = "Shift-클릭"
L["ZONE_INFO_LINK_ITEM"] = "대화창에 링크"
L["ZONE_INFO_MENU_QUEST"] = "이 퀘스트"
L["ZONE_INFO_MENU_HERE"] = "현재 위치"
L["ZONE_INFO_MENU_LOG"] = "내 퀘스트"
L["ZONE_INFO_MENU_AVAILABLE"] = "퀘스트가 가장 많은 곳"
L["ZONE_INFO_NO_QUESTS"] = "이곳을 위해 다른 지역에서 받을 퀘스트가 없습니다."
L["ZONE_INFO_NO_ITEMS"] = "사거나 챙겨 갈 것이 없습니다."
L["ZONE_INFO_WORKING"] = "퀘스트 읽는 중..."
-- TRANSLATORS: %d is the item's ID, shown until the client has loaded the item's name
L["ZONE_INFO_ITEM_LOADING"] = "아이템 ID 불러오는 중: %d"
L["ZONE_INFO_NEEDS_QUESTIE"] = "Questie를 켜면 이곳의 정보를 볼 수 있습니다."
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "경험치 %s"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "완료 보상: %s"
L["TURN_IN_TOOLTIP"] = "완료 보고 가능"
L["RESIZE_TOOLTIP"] = "끌어서 퀘스트 목록 크기를 조절합니다."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "퀘스트 공유"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"이 지역에서 게임이 공유를 허용하고 아직 없는 파티원이 있는 퀘스트를 %d초마다 하나씩 파티에 제안합니다."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "전투가 끝나면 %s 퀘스트를 공유합니다."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "%s의 퀘스트 1개를 공유합니다."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "퀘스트 %d개를 공유합니다 (%s), %d초마다 하나씩."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "%s의 퀘스트 중 공유할 수 있는 퀘스트가 없습니다."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_PARTY_HAS"] = "파티원 모두가 %s의 내 퀘스트를 이미 가지고 있습니다."
-- TRANSLATORS: %s is the zone; printed when new party members are missing 1 of your quests there
L["CHAT_ZONE_SHARE_NOTICE_ONE"] =
	"파티에 필요할 수 있는 공유 가능한 퀘스트 1개가 %s에 있습니다."
-- TRANSLATORS: %d is how many quests, %s is the zone; printed when new party members are missing them
L["CHAT_ZONE_SHARE_NOTICE"] = "파티에 필요할 수 있는 공유 가능한 퀘스트 %d개가 %s에 있습니다."

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "도착"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "다른 지도에 있는 경유지"
L["ROUTES_OBJECTIVE_AREA"] = "현재 목표 구역"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "다음으로 가기 전에 여기서 마치세요"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "경로상에 더 있음"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "다음 목표"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "여기 온 김에"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d미터"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d미터"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "여기에 +%d개 더"
L["ROUTES_TURN_IN"] = "퀘스트 완료 보고"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "%s 완료 보고"
L["ROUTES_PICK_UP"] = "퀘스트 받기"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "%s 받기"
L["ROUTES_FLIGHT_PATH"] = "비행 경로 얻기"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_FLIGHT_PATH_FROM"] = "%s에게서 비행 경로 얻기"
-- TRANSLATORS: first %s is the flight master's name, such as "Omusa Thunderhorn"; second is where the flight lands, as the flight map names it, such as "Camp Taurajo"
L["ROUTES_FLY_FROM"] = "%s에게 말을 걸어 %s(으)로 비행하기"
-- TRANSLATORS: under a quest to pick up on the world map, why the route doesn't go there
L["ROUTES_OFF_ROUTE_ESCORT"] = "호위 퀘스트, 경로에 없음"
L["ROUTES_OFF_ROUTE_GROUP"] = "파티 퀘스트, 경로에 없음"
L["ROUTES_OFF_ROUTE_ELSEWHERE"] = "다른 지역으로 이어짐, 경로에 없음"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"; over a quest's objectives planned before it's picked up
L["ROUTES_AFTER_PICK_UP"] = "%s 받은 후"
-- TRANSLATORS: %s is the quest's title with its level; under a quest to pick up once another is turned in
L["ROUTES_AFTER_TURN_IN"] = "%s 완료 보고 후"
-- TRANSLATORS: as ROUTES_AFTER_PICK_UP, for a party member's quest planned ahead, one you don't have
L["ROUTES_AFTER_PARTY_PICK_UP"] = "파티원이 %s 받은 후"
-- TRANSLATORS: as ROUTES_AFTER_TURN_IN, for a party member's quest
L["ROUTES_AFTER_PARTY_TURN_IN"] = "파티원이 %s 완료 보고 후"
L["ROUTES_CORPSE"] = "내 시체로 달려가세요"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "찾을 대상"
-- TRANSLATORS: the title of the "…" marker's tooltip where the zone map stops drawing the route; %d is how many waypoints it hides
L["ROUTES_MORE_WAYPOINT"] = "경유지 1개 더"
L["ROUTES_MORE_WAYPOINTS"] = "경유지 %d개 더"
L["ROUTES_MORE_WAYPOINTS_DESCRIPTION"] =
	"마우스를 올린 동안 보이는 나머지 경로입니다. 설정의 지역 지도에 있는 표시할 경유지에서 지도에 그릴 수를 정합니다."
L["ROUTES_CLICK_DRAG"] = "끌기"
L["ROUTES_CLICK_RIGHT"] = "오른쪽 클릭"
L["ROUTES_CLICK_MIDDLE"] = "가운데 클릭"
L["ROUTES_CLICK"] = "클릭"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "아이템 사용"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "퀘스트 아이템 사용"
L["ROUTES_DRAG_MOVE"] = "퀘스트 화살표 이동"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "이 경유지 무시"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "이 목표 무시"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "다시 경로에 포함"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "이 지역 초기화"
-- TRANSLATORS: beside ROUTES_CLICK on the "…" marker's tooltip; the whole route shows until the map closes
L["ROUTES_CLICK_SHOW_ROUTE"] = "전체 경로 표시"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "지역을 초기화할 때까지 %s 항목을 무시합니다."
L["ROUTES_ZONE_RESET"] = "지역 초기화: 이곳에서 무시한 목표가 다시 경로에 포함되었습니다."
L["ROUTES_GROUP_LEFT_CLEARED"] =
	"파티를 떠났습니다: 무시한 파티 목표와 파티원이 다시 경로에 포함되었습니다."
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] =
	"%s 님이 파티를 떠났습니다: 무시했던 해당 목표가 다시 경로에 포함되었습니다."
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "무시"
L["ROUTES_MENU_SECTION_ROUTE"] = "경로"
L["ROUTES_MENU_SECTION_SHOW"] = "표시"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "다음"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "되돌리기"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "무시됨"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "%s 완료 보고"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "%s 받기"
-- TRANSLATORS: %s is the flight master's name, such as "Devrak"
L["ROUTES_MENU_FLIGHT_PATH"] = "%s 비행 경로"
-- TRANSLATORS: %s is where the flight lands, such as "Camp Taurajo"
L["ROUTES_MENU_FLY"] = "%s(으)로 비행"
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_ROUTE; Next Objective, under ROUTES_MENU_SECTION_SHOW, is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_PREDICTIVE"] = "예측 퀘스트 경로"
L["ROUTES_MENU_SHOWN_LOCAL"] = "주변의 받을 수 있는 퀘스트"
L["ROUTES_MENU_SHOWN_FLIGHTS"] = "비행 경로"
L["ROUTES_MENU_SHOWN_PARTY"] = "파티 목표"
L["ROUTES_MENU_ON"] = "켜짐"
L["ROUTES_MENU_OFF"] = "꺼짐"
L["ROUTES_MENU_OUT_OF_ZONE"] = "다른 지역"
L["ROUTES_MENU_NO_QUESTIE"] = "Questie 없음"
L["ROUTES_MENU_OFFLINE"] = "오프라인"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "%s 님의 목표"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "%s 항목(%s)을 지역을 초기화할 때까지 무시합니다."
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] =
	"%s 항목(%s)을 해당 퀘스트를 가진 파티원이 파티를 떠날 때까지 무시합니다."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s 항목이 다시 경로에 포함되었습니다."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "%s 님의 목표를 경로에서 제외합니다."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "%s 님의 목표가 다시 경로에 포함되었습니다."
-- TRANSLATORS: on the Quest Arrow and the world map's marker, while it points to where to join up with your party
L["ROUTES_GROUP_UP"] = "파티와 합류"

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them,
	and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"%s 퀘스트를 공유하려고 했는데 전달되지 않았어요. 필요하면 준비됐을 때 말해 주세요. 다시 공유해 드릴게요"
L["WHISPER_SHARE_FAILED_AGAIN"] = "%s 퀘스트도 마찬가지예요"
L["DUNGEON_QUESTS_ANNOUNCE"] = "여기서 할 퀘스트가 %d개 있어요: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "여기서 할 퀘스트가 1개 있어요: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "여기서 할 퀘스트가 더 있어요: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] =
	"Questie 데이터베이스에 없는 퀘스트라서 Questie 추적기에 %s 퀘스트를 표시할 수 없습니다."
L["QUESTIE_CANNOT_TRACK"] = "Questie가 아직 이 퀘스트를 추적할 수 없습니다."
