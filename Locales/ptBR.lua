local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "ptBR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT"] = "PWQL"
L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) ficam em Opções > AddOns > Pretty Wide Quest Log. Está gostando do add-on? Conte para um amigo! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por precaução, a interface de opções não pode ser aberta durante o combate."
L["CHAT_QUESTIE_MISSING"] =
	"Boa parte deste add-on funciona com os dados do Questie. Sem o Questie, você terá menos recursos."
L["CHAT_PREDECESSOR_LOADED"] =
	"O Wide Quest Log Plus também está ativado, e os dois vão brigar pelo registro de missões. Desative o Wide Quest Log Plus na lista de AddOns e recarregue."

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Um registro de missões maior e melhor, que dá mais espaço para ler e mais informações de relance. Mantenha o layout familiar da Blizzard enquanto vê, lado a lado, os níveis das missões, marcadores úteis, objetivos, recompensas e toda a sua lista de missões."
L["ENABLE_WELCOME_MESSAGE"] = "Ativar mensagem de boas-vindas"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra a saudação do Pretty Wide Quest Log ao entrar no jogo."
L["OPTIONS_FEATURES_HEADER"] = "Recursos"
L["ENABLE_QUEST_LOG_CLEANUP"] = "Ativar registro de missões organizado"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Troca o registro de missões da Blizzard pelo largo, com o mapa ao lado. Desative para usar o registro de missões da Blizzard. Entra em vigor após recarregar."
L["ENABLE_QUALITY_OF_LIFE"] = "Ativar melhorias de conveniência"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Ativa a janela de missões do PNJ organizada, seu próprio ritmo ao compartilhar missões e os sussurros quando um compartilhamento falha. Desative para ter de volta a janela de missões do PNJ da Blizzard e compartilhar no ritmo padrão."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Ativar registro de missões organizado entra em vigor após recarregar, o que será oferecido quando você fechar a interface de opções."
L["RELOAD_PROMPT"] = "O Pretty Wide Quest Log troca de registro de missões após recarregar. Recarregar agora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a interface de opções deste add-on."
L["FEEDBACK_HEADER"] = "Feedback e suporte"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versão %s"

--------------------------------------------------------------------------------
-- Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_LOG"] = "Registro de missões"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Substitui o registro de missões da Blizzard por um largo: suas missões listadas por zona, com os detalhes da missão selecionada e o mapa dela ao lado."
L["QUEST_LOG_LAYOUT_HEADER"] = "Layout do registro de missões"
L["QUEST_LOG_LAYOUT_DESCRIPTION"] =
	"Ordene suas missões do seu jeito, escolha o que cada linha mostra e ajuste o tamanho da janela e do mapa à sua tela."
L["ZONE_ORDER"] = "Ordem das zonas"
L["ZONE_ORDER_DESCRIPTION"] = "Muda a ordem das zonas na lista de missões."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Nível médio, maior primeiro (padrão)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Nível médio, menor primeiro"
L["SORT_ALPHABETICAL"] = "Alfabética"
L["CURRENT_ZONE_FIRST"] = "Mostrar a zona atual primeiro"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Coloca a zona onde você está no topo da lista, seja qual for a ordem das zonas."
L["ZONE_GAP"] = "Espaço acima dos nomes de zona"
L["ZONE_GAP_DESCRIPTION"] =
	"Adiciona um pouco de espaço acima de cada nome de zona. Útil se suas missões estão espalhadas por muitas zonas."
L["QUEST_ORDER"] = "Ordem das missões"
L["QUEST_ORDER_DESCRIPTION"] = "Muda a ordem das missões dentro de cada zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Nível, maior primeiro (padrão)"
L["SORT_LEVEL_LOWEST"] = "Nível, menor primeiro"
L["COMPLETED_FIRST"] = "Missões concluídas primeiro"
L["COMPLETED_FIRST_DESCRIPTION"] = "Leva para o topo da zona as missões prontas para entregar."
L["SHOW_QUEST_LEVELS"] = "Mostrar níveis das missões"
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Coloca o nível e o tipo de cada missão antes do nome dela na lista, como [40M] para uma missão de masmorra de nível 40."
L["MARK_UNTRACKED"] = "Marcar missões não acompanhadas"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Missões acompanhadas perdem a marca de seleção %s, e missões não acompanhadas ganham um olho %s no lugar. Útil se você acompanha quase tudo."
L["CLOSE_IN_COMBAT"] = "Fechar ao entrar em combate"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Fecha o registro de missões quando uma luta começa, para que ele nunca cubra a ação."
L["WINDOW_SCALE"] = "Escala do registro de missões"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Deixa o registro de missões maior ou menor. O mapa ao lado cresce e encolhe junto com ele."
L["MAP_SCALE"] = "Escala do mapa"
L["MAP_SCALE_DESCRIPTION"] =
	"Deixa o mapa ao lado do registro de missões maior ou menor, além da escala do registro de missões."
L["RESET_WINDOW"] = "Redefinir tamanho e posição"
L["RESET_WINDOW_DESCRIPTION"] = "Volta o registro de missões ao tamanho e à posição padrão."
L["RESET_WINDOW_CONFIRM"] = "Redefinir o registro de missões para o tamanho e a posição padrão?"

--------------------------------------------------------------------------------
-- Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Melhorias de conveniência"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Pequenas ajudas fora do registro de missões em si, para a janela de missões do PNJ e para compartilhar missões com o seu grupo."
L["QUEST_GIVERS_HEADER"] = "PNJs de missões"
L["QUEST_GIVERS_DESCRIPTION"] = "A janela que um PNJ de missões abre, onde você aceita e entrega missões."
L["GIVER_CLEANUP"] = "Ativar janela de missões do PNJ organizada"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Formata o texto da janela de missões do PNJ como o do registro de missões, com os mesmos títulos e espaçamento entre linhas, e mostra abaixo da missão o ID dela, com link para o Wowhead."
L["GIVER_LEVELS"] = "Mostrar níveis das missões"
L["GIVER_LEVELS_DESCRIPTION"] =
	"Adiciona as marcações de nível do registro de missões, como [40M], à lista de missões de um PNJ."
L["QUEST_SHARING_HEADER"] = "Compartilhamento de missões"
L["QUEST_SHARING_DESCRIPTION"] =
	"Compartilhar missões, no menu de clique direito de uma zona no registro de missões, oferece ao seu grupo, uma após a outra, todas as missões daquela zona que eles podem pegar. Estas opções definem o ritmo e o que acontece quando um membro do grupo perde uma."
L["SHARE_INTERVAL"] = "Segundos entre compartilhamentos"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Quanto tempo Compartilhar missões, no menu de clique direito de uma zona, espera entre uma missão e a próxima. Quanto maior, mais tempo o seu grupo tem para aceitar cada uma."
L["SHARE_WHISPERS"] = "Sussurrar quando um compartilhamento falhar"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quando um membro do grupo está ocupado, longe demais ou com o registro de missões cheio, sussurra para ele qual missão você tentou compartilhar e pede que ele te lembre. Nada é enviado quando ele não pode pegar a missão."
L["SHARE_WHISPER_EXAMPLE"] = "Exemplo:"
L["SHARE_WHISPER_EXAMPLE_QUEST_NAME"] = "Nome da missão"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

L["QUEST_SUFFIX_DUNGEON"] = "M"
L["QUEST_SUFFIX_RAID"] = "R"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
L["QUEST_ID"] = "ID da missão %d"
L["QUEST_CHAIN"] = "Sequência de missões"
L["DAILY_RESET"] = "As missões diárias são renovadas em %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Clique para obter um link do Wowhead."
L["WOWHEAD_LINK_COPY"] = "Pressione Ctrl+C (Cmd+C no Mac) para copiar o link do Wowhead."
L["EXPAND_ALL"] = "Expandir tudo"
L["COLLAPSE_ALL"] = "Recolher tudo"
L["TRACK_ALL"] = "Acompanhar todas"
L["UNTRACK_ALL"] = "Não acompanhar nenhuma"
L["HIDE_MAP"] = "Ocultar mapa"
L["TURN_IN_XP"] = "%s XP"
L["TURN_IN_SEPARATOR"] = " / "
L["TURN_IN_SUMMARY"] = "Entrega: %s"
L["TURN_IN_TOOLTIP"] = "Pronta para entregar"
L["RESIZE_TOOLTIP"] = "Arraste para redimensionar o registro de missões."

--------------------------------------------------------------------------------
-- Zone Menu
--------------------------------------------------------------------------------

L["ZONE_MENU_HINT"] = "Clique direito para mais opções"
L["SHARE_ZONE_QUESTS"] = "Compartilhar %d missões"
L["SHARE_ZONE_QUEST"] = "Compartilhar 1 missão"
L["SHARE_ZONE_TOOLTIP"] =
	"%d das %d missões desta zona podem ser compartilhadas. Elas são enviadas uma por vez, a cada %d segundos."
L["CHAT_SHARING_ZONE_ONE"] = "Compartilhando 1 missão de %s."
L["CHAT_SHARING_ZONE"] = "Compartilhando %d missões de %s, uma a cada %d segundos."
L["WHISPER_SHARE_BUSY"] =
	"Tentei compartilhar %s com você, mas parecia que você estava no meio de algo. Se quiser, me chama quando estiver livre que eu mando de novo."
L["WHISPER_SHARE_TOO_FAR"] =
	"Tentei compartilhar %s com você, mas estávamos longe demais. Se quiser, me chama quando estivermos mais perto que eu mando de novo."
L["WHISPER_SHARE_LOG_FULL"] =
	"Tentei compartilhar %s com você, mas seu registro de missões estava cheio. Se quiser, me chama quando tiver aberto espaço que eu mando de novo."
L["ABANDON_GRAY_QUESTS"] = "Abandonar missões cinzas"
L["ABANDON_GRAY_NONE"] = "Esta zona não tem missões cinzas para abandonar."
L["ABANDON_GRAY_CONFIRM"] = "Abandonar estas %d missões cinzas?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "Abandonar esta missão cinza?"
L["CHAT_ABANDONED_GRAY"] = "%d missões cinzas abandonadas."
L["CHAT_ABANDONED_GRAY_ONE"] = "1 missão cinza abandonada."

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"O rastreador do Questie não consegue mostrar %s porque a missão não está no banco de dados do Questie."
L["QUESTIE_CANNOT_TRACK"] = "O Questie ainda não consegue acompanhar esta missão."
