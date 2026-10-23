local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "koKR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지를 끄는 옵션 포함)은 설정 > 애드온 > Pretty Wide Quest Log에 있습니다. 이 애드온이 마음에 드시나요? 친구에게 알려 주시거나, CurseForge에서 즐겨찾기에 추가하시거나, GitHub에서 Star를 눌러 주세요. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 창을 열 수 없습니다."
L["CHAT_QUESTIE_MISSING"] =
	"이 애드온의 많은 기능이 Questie 데이터를 사용하므로, Questie가 없으면 일부 기능이 제한됩니다."
L["CHAT_PREDECESSOR_LOADED"] =
	"Wide Quest Log Plus도 켜져 있어 두 애드온이 퀘스트 목록을 두고 충돌합니다. 애드온 목록에서 Wide Quest Log Plus를 끈 다음 UI를 다시 불러오세요."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"퀘스트 레벨, 던전 및 정예 태그, 보상, 연계 퀘스트, 퀘스트별 지도를 보여 주는 넓고 크기 조절이 가능한 2단 퀘스트 목록입니다. 파티에 퀘스트를 공유하고 던전 퀘스트를 자동으로 알립니다. Questie, VoiceOver, ElvUI와 함께 작동합니다."
L["ENABLE_WELCOME_MESSAGE"] = "환영 메시지 사용"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "접속할 때 Pretty Wide Quest Log 환영 메시지를 표시합니다."
L["OPTIONS_FEATURES_HEADER"] = "기능"
L["ENABLE_WIDE_QUEST_LOG"] = "넓은 퀘스트 목록 사용"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"블리자드 퀘스트 목록을 지도가 옆에 붙은 넓은 퀘스트 목록으로 바꿉니다. UI를 다시 불러온 후에 적용됩니다."
L["ENABLE_QUALITY_OF_LIFE"] = "편의 기능 사용"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"퀘스트 NPC 창 정리, 원하는 속도로 퀘스트 공유하기, 퀘스트 공유 실패 시 귓속말, 던전 퀘스트 알림과 공유를 켭니다. 끄면 블리자드 퀘스트 NPC 창으로 돌아가고 기본 속도로 공유합니다."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"넓은 퀘스트 목록 사용은 UI를 다시 불러온 후에 적용되며, 설정 창을 닫을 때 다시 불러오기를 안내합니다."
L["RELOAD_PROMPT"] =
	"Pretty Wide Quest Log는 UI를 다시 불러온 후에 퀘스트 목록을 전환합니다. 지금 다시 불러오시겠습니까?"
L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 창을 엽니다."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG_DESCRIPTION"] =
	"블리자드 퀘스트 목록을 넓은 목록으로 바꿉니다. 퀘스트가 지역별로 나열되고, 옆에 선택한 퀘스트의 세부 정보와 지도가 표시됩니다."
L["QUEST_LOG_LAYOUT_HEADER"] = "퀘스트 목록 구성"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"플레이 방식에 맞게 퀘스트를 정렬하고, 각 줄에 표시할 내용을 고르고, 창과 지도 크기를 화면에 맞게 조절하세요."
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
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"목록에서 각 퀘스트 이름 앞에 레벨과 유형을 붙입니다. 예를 들어 40레벨 던전 퀘스트는 [40던]으로 표시됩니다."
L["MARK_UNTRACKED"] = "추적하지 않는 퀘스트 표시"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"추적 중인 퀘스트의 체크 %s 표시가 사라지고, 대신 추적하지 않는 퀘스트에 눈 %s 표시가 붙습니다. 거의 모든 퀘스트를 추적한다면 유용합니다."
L["CLOSE_IN_COMBAT"] = "전투 시작 시 닫기"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"전투가 시작되면 퀘스트 목록을 닫아 화면을 가리지 않게 합니다."
L["SHOW_OBJECTIVE_AREAS"] = "목표 구역 표시"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"퀘스트 목록 옆 지도에 각 목표의 몬스터와 사물이 있는 곳을 음영으로 표시하고, 생성 지점마다 아이콘을 두는 대신 구역마다 아이콘을 하나만 표시합니다. Questie가 필요합니다."
L["WINDOW_SCALE"] = "퀘스트 목록 크기 비율"
L["WINDOW_SCALE_DESCRIPTION"] =
	"퀘스트 목록을 크게 또는 작게 만듭니다. 옆의 지도도 함께 커지고 작아집니다."
L["MAP_SCALE"] = "지도 크기 비율"
L["MAP_SCALE_DESCRIPTION"] =
	"퀘스트 목록 옆의 지도를 크게 또는 작게 만듭니다. 퀘스트 목록 크기 비율에 더해 적용됩니다."
L["RESET_WINDOW"] = "크기 및 위치 초기화"
L["RESET_WINDOW_DESCRIPTION"] = "퀘스트 목록을 기본 크기와 위치로 되돌립니다."
L["RESET_WINDOW_CONFIRM"] = "퀘스트 목록을 기본 크기와 위치로 초기화할까요?"

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "편의 기능"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"퀘스트 목록 자체의 바깥에서 돕는 작은 기능들입니다. 퀘스트 NPC 창, 파티원과의 퀘스트 공유, 던전을 위한 기능입니다."
L["QUEST_GIVERS_HEADER"] = "퀘스트 NPC"
L["QUEST_GIVERS_DESCRIPTION"] =
	"퀘스트 NPC가 여는 창으로, 여기서 퀘스트를 받고 완료 보고합니다."
L["GIVER_CLEANUP"] = "퀘스트 NPC 창 정리"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"퀘스트 NPC 창의 글을 퀘스트 목록과 같은 제목과 줄 간격으로 배치하고, 퀘스트 아래에 Wowhead로 연결되는 퀘스트 ID를 표시합니다."
L["GIVER_LEVELS"] = "퀘스트 레벨 표시"
L["GIVER_LEVELS_DESCRIPTION"] =
	"퀘스트 NPC의 퀘스트 목록에 [40던] 같은 퀘스트 목록의 레벨 태그를 붙입니다."
L["QUEST_SHARING_HEADER"] = "퀘스트 공유"
L["QUEST_SHARING_DESCRIPTION"] =
	"퀘스트 목록에서 지역을 오른쪽 클릭하면 나오는 메뉴의 퀘스트 공유는 그 지역에서 게임이 공유를 허용하는 모든 퀘스트를 하나씩 차례로 파티에 제안합니다. 아래 설정에서 그 속도와 파티원이 퀘스트를 놓쳤을 때 어떻게 할지 정합니다."
L["SHARE_INTERVAL"] = "공유 간격(초)"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"공유한 퀘스트 하나와 다음 퀘스트 사이에 기다리는 시간으로, 퀘스트 공유와 던전 퀘스트 공유에 적용됩니다. 길수록 파티원이 각 퀘스트를 수락할 시간이 늘어납니다."
L["SHARE_WHISPERS"] = "공유 실패 시 귓속말"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"파티원이 다른 일을 하고 있거나, 너무 멀리 있거나, 퀘스트 목록이 가득 찼을 때 공유하려던 퀘스트를 귓속말로 알려 주고 다시 말해 달라고 부탁합니다. 파티원이 받을 수 없는 퀘스트라면 아무것도 보내지 않습니다."
L["OPTIONS_EXAMPLE"] = "예시:"
L["OPTIONS_EXAMPLE_QUEST_NAME"] = "퀘스트 이름"
L["DUNGEON_QUESTS_HEADER"] = "던전 퀘스트"
L["DUNGEON_QUESTS_DESCRIPTION"] =
	"아래 기능은 파티와 함께 던전이나 공격대에 들어갈 때 던전마다 파티당 한 번 작동합니다. 퀘스트 목록에서 그 던전 아래에 있는 퀘스트와, Questie가 있으면 목표가 던전 안에 있는 퀘스트도 포함되므로 직업 퀘스트도 잡아냅니다."
L["DUNGEON_ANNOUNCE"] = "던전 퀘스트 자동 알림"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"방금 들어간 던전에서 아직 해야 할 퀘스트를 파티에 알려, 모두가 무엇을 챙겨야 할지 알 수 있게 합니다. 완료 보고만 남은 퀘스트는 빠집니다."
L["DUNGEON_SHARE"] = "던전 퀘스트 자동 공유"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"게임이 공유를 허용하는 그 던전의 퀘스트를 모두 퀘스트 공유에서 정한 속도로 공유합니다. 공유 실패 시 귓속말이 켜져 있으면 공유를 놓친 파티원에게 귓속말을 보내 다시 요청할 수 있게 합니다. 누군가 파티에 들어오거나 나가면 다시 공유합니다."

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

L["QUEST_SUFFIX_DUNGEON"] = "던"
L["QUEST_SUFFIX_RAID"] = "공"
L["QUEST_SUFFIX_PVP"] = "전"
L["QUEST_SUFFIX_GROUP"] = "파"
L["QUEST_SUFFIX_ELITE"] = "정"
L["QUEST_ID"] = "퀘스트 ID %d"
L["QUEST_CHAIN"] = "연계 퀘스트"
L["DAILY_RESET"] = "일일 퀘스트 초기화까지 %s 남았습니다."
L["WOWHEAD_LINK_TOOLTIP"] = "클릭하면 Wowhead 링크를 받습니다."
L["WOWHEAD_LINK_COPY"] = "Ctrl+C(Mac에서는 Cmd+C)를 눌러 Wowhead 링크를 복사하세요."
L["EXPAND_ALL"] = "모두 펼치기"
L["COLLAPSE_ALL"] = "모두 접기"
L["TRACK_ALL"] = "모두 추적"
L["UNTRACK_ALL"] = "모두 추적 해제"
L["HIDE_MAP"] = "지도 숨기기"
L["TURN_IN_XP"] = "경험치 %s"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "완료 보상: %s"
L["TURN_IN_TOOLTIP"] = "완료 보고 가능"
L["RESIZE_TOOLTIP"] = "끌어서 퀘스트 목록 크기를 조절합니다."

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_HINT"] = "오른쪽 클릭으로 추가 옵션"
L["SHARE_ZONE_QUESTS"] = "퀘스트 %d개 공유"
L["SHARE_ZONE_QUEST"] = "퀘스트 1개 공유"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"이 지역에서 게임이 공유를 허용하는 퀘스트를 %d초마다 하나씩 파티에 제안합니다."
L["SHARE_ZONE_QUEST_TOOLTIP"] =
	"이 지역에서 게임이 공유를 허용하는 퀘스트 하나를 파티에 제안합니다."
L["CHAT_SHARING_ZONE_ONE"] = "%s의 퀘스트 1개를 공유합니다."
L["CHAT_SHARING_ZONE"] = "퀘스트 %d개를 공유합니다 (%s), %d초마다 하나씩."
L["ABANDON_GRAY_QUESTS"] = "회색 퀘스트 포기"
L["ABANDON_GRAY_NONE"] = "이 지역에는 포기할 회색 퀘스트가 없습니다."
L["ABANDON_GRAY_CONFIRM"] = "회색 퀘스트 %d개를 포기할까요?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "이 회색 퀘스트를 포기할까요?"
L["CHAT_ABANDONED_GRAY"] = "회색 퀘스트 %d개를 포기했습니다."
L["CHAT_ABANDONED_GRAY_ONE"] = "회색 퀘스트 1개를 포기했습니다."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

L["WHISPER_SHARE_FAILED"] =
	"%s 퀘스트를 공유하려고 했는데 전달되지 않았어요. 필요하면 준비됐을 때 말해 주세요. 다시 공유해 드릴게요."
L["WHISPER_SHARE_FAILED_AGAIN"] = "%s 퀘스트도 마찬가지예요."
L["DUNGEON_QUESTS_ANNOUNCE"] = "여기서 할 퀘스트가 %d개 있어요: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "여기서 할 퀘스트가 1개 있어요: %s"
L["DUNGEON_QUESTS_ANNOUNCE_MORE"] = "%s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"Questie 데이터베이스에 없는 퀘스트라서 Questie 추적기에 %s 퀘스트를 표시할 수 없습니다."
L["QUESTIE_CANNOT_TRACK"] = "Questie가 아직 이 퀘스트를 추적할 수 없습니다."
