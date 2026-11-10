local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "ptBR")
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
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) ficam em Opções > AddOns > Pretty Wide Quest Log. Está gostando deste add-on? Conte para um amigo, favorite-o no CurseForge ou dê uma Star no GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por precaução, a interface de opções não pode ser aberta durante o combate."
L["CHAT_QUESTIE_MISSING_FEATURES"] =
	"Sem o Questie, o mapa de missões mostra menos, e as sequências de missões e o total de Entrega ficam ocultos. Ative o Questie na lista de AddOns para vê-los."
L["CHAT_PREDECESSOR_LOADED"] =
	"O Wide Quest Log Plus também está ativado, e os dois vão brigar pelo registro de missões. Desative o Wide Quest Log Plus na lista de AddOns e recarregue."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Registro de missões largo com rota de missões e seta de missões. Você escolhe as missões, nós ajudamos com uma rota limpa para concluí-las rápido. Níveis das missões, marcadores, recompensas, cadeias de missões, um mapa de missões e compartilhamento de missões com o grupo. Funciona com Questie, Spoken, VoiceOver e ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Ativar mensagem de boas-vindas"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra a mensagem de boas-vindas do Pretty Wide Quest Log ao entrar no jogo."
L["OPTIONS_FEATURES_HEADER"] = "Recursos"
L["ENABLE_WIDE_QUEST_LOG"] = "Ativar registro de missões largo"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Troca o registro de missões da Blizzard pelo largo, com o mapa ao lado. Entra em vigor após recarregar."
L["ENABLE_QUALITY_OF_LIFE"] = "Ativar melhorias de conveniência"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Organiza a janela de missões do PNJ e ajuda seu grupo a pegar suas missões: ritmo de compartilhamento, sussurros quando um compartilhamento não chega a alguém, e anúncio e compartilhamento de missões de masmorra. O botão Compartilhar missões de uma zona no registro de missões também funciona com isto desativado."
L["ENABLE_WAYPOINT_MARKERS"] = "Ativar Marcadores de pontos de passagem"
L["FEATURE_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Junta os ícones de missão de cada objetivo no mapa da zona em um só marcador, um ponto de passagem, onde está a maioria dos seus inimigos ou objetos, mais um para cada entrega. Passe o mouse sobre um marcador para ver os ícones que ele substitui."
L["ENABLE_QUEST_ROUTE"] = "Ativar Rota de missões"
L["FEATURE_QUEST_ROUTE_DESCRIPTION"] =
	"Desenha no mapa da zona uma rota pelos seus marcadores de pontos de passagem, começando pelo mais próximo, com pontos em marcha de você até cada marcador, um de cada vez. Precisa dos Marcadores de pontos de passagem."
L["ENABLE_QUEST_ARROW"] = "Ativar Seta de missões"
L["FEATURE_QUEST_ARROW_DESCRIPTION"] =
	"Mostra uma seta na tela, a Seta de missões, apontando para o próximo ponto de passagem da rota, com as missões e objetivos a fazer lá. Por padrão, ela fica oculta em grupos de raide e instâncias."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Ativar registro de missões largo entra em vigor após recarregar, o que será oferecido quando você fechar a interface de opções."
L["RELOAD_PROMPT"] = "O Pretty Wide Quest Log troca de registro de missões após recarregar. Recarregar agora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a interface de opções deste add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

L["TAB_WIDE_QUEST_LOG"] = "Registro de missões largo"
L["TAB_QUEST_LOG_DESCRIPTION"] =
	"Substitui o registro de missões da Blizzard por um largo: suas missões listadas por zona, com os detalhes da missão selecionada e o mapa dela ao lado."
L["QUEST_LOG_SORTING_HEADER"] = "Ordenação"
L["QUEST_LOG_SORTING_DESCRIPTION"] = "Escolha a ordem das suas zonas e das missões dentro delas."
L["QUEST_LOG_ROWS_HEADER"] = "Linhas de missões"
L["QUEST_LOG_ROWS_DESCRIPTION"] = "Escolha o que cada linha mostra."
L["QUEST_LOG_WINDOW_MAP_HEADER"] = "Janela e mapa"
L["QUEST_LOG_WINDOW_MAP_DESCRIPTION"] =
	"Ajuste o tamanho da janela e do mapa à sua tela e escolha como eles se comportam."
L["ZONE_ORDER"] = "Ordem das zonas"
L["ZONE_ORDER_DESCRIPTION"] = "Muda a ordem das zonas na lista de missões."
L["SORT_AVERAGE_LEVEL_HIGHEST_DEFAULT"] = "Nível médio, maior primeiro (padrão)"
L["SORT_AVERAGE_LEVEL_LOWEST"] = "Nível médio, menor primeiro"
L["SORT_ALPHABETICAL"] = "Alfabética"
L["CURRENT_ZONE_FIRST"] = "Mostrar a zona atual primeiro"
L["CURRENT_ZONE_FIRST_DESCRIPTION"] =
	"Coloca a zona onde você está no topo da lista, seja qual for a ordem das zonas."
L["ZONE_GAP"] = "Adicionar espaço acima dos nomes de zona"
L["ZONE_GAP_DESCRIPTION"] =
	"Adiciona um pouco de espaço acima de cada nome de zona. Útil se suas missões estão espalhadas por muitas zonas."
L["QUEST_ORDER"] = "Ordem das missões"
L["QUEST_ORDER_DESCRIPTION"] = "Muda a ordem das missões dentro de cada zona."
L["SORT_LEVEL_HIGHEST_DEFAULT"] = "Nível, maior primeiro (padrão)"
L["SORT_LEVEL_LOWEST"] = "Nível, menor primeiro"
L["COMPLETED_FIRST"] = "Mostrar as missões concluídas primeiro"
L["COMPLETED_FIRST_DESCRIPTION"] = "Leva para o topo da zona as missões prontas para entregar."
L["SHOW_QUEST_LEVELS"] = "Mostrar níveis das missões"
-- TRANSLATORS: %s is the level tag for a level 40 dungeon quest, such as [40D], built from QUEST_SUFFIX_DUNGEON
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Coloca o nível e o tipo de cada missão antes do nome dela na lista, como %s para uma missão de masmorra de nível 40."
L["MARK_UNTRACKED"] = "Marcar missões não acompanhadas"
-- TRANSLATORS: each %s is an icon that follows the word it pictures
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Missões acompanhadas perdem a marca de seleção %s, e missões não acompanhadas ganham um olho %s no lugar. Útil se você acompanha quase tudo."
L["CLOSE_IN_COMBAT"] = "Fechar ao entrar em combate"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Fecha o registro de missões quando uma luta começa, para que ele nunca cubra a ação."
L["SHOW_OBJECTIVE_AREAS"] = "Mostrar áreas dos objetivos"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Sombreia no mapa ao lado do registro de missões onde ficam os inimigos e objetos de cada objetivo, com um ícone em cada área em vez de um em cada ponto de surgimento."
L["NEEDS_QUESTIE_HINT"] = "Ative o Questie para usar isto."
L["WINDOW_SCALE"] = "Escala do registro de missões"
L["WINDOW_SCALE_DESCRIPTION"] =
	"Deixa o registro de missões maior ou menor. O mapa ao lado cresce e encolhe junto com ele."
L["MAP_SCALE"] = "Escala do mapa"
L["MAP_SCALE_DESCRIPTION"] =
	"Deixa o mapa ao lado do registro de missões maior ou menor, além da escala do registro de missões."
L["RESET_WINDOW_BUTTON"] = "Redefinir janela"
L["RESET_WINDOW_SCALE_DESCRIPTION"] =
	"Volta a altura e a escala do registro de missões, e a escala do mapa, aos valores padrão."
L["RESET_WINDOW_MOVE_DESCRIPTION"] =
	"Volta a altura e a escala do registro de missões, e a escala do mapa, aos valores padrão, e leva a janela de volta ao lugar inicial."
L["RESET_WINDOW_SCALE_CONFIRM"] = "Redefinir a altura e a escala do registro de missões, e a escala do mapa?"
L["RESET_WINDOW_MOVE_CONFIRM"] =
	"Redefinir a altura e a escala do registro de missões, a escala do mapa e o lugar da janela na tela?"
L["HANDY_CLICKS_HEADER"] = "Cliques úteis"
L["HANDY_CLICK_TRACK"] = "Shift-clique em uma missão"
L["HANDY_CLICK_TRACK_DESCRIPTION"] = "Acompanhe a missão ou deixe de acompanhá-la."
L["HANDY_CLICK_MENU"] = "Clique direito em uma missão"
L["HANDY_CLICK_MENU_DESCRIPTION"] = "Acompanhe, compartilhe ou abandone a missão."
L["HANDY_CLICK_ID"] = "Clique em um ID de missão"
L["HANDY_CLICK_ID_DESCRIPTION"] = "Obtenha o link dela no Wowhead."

--------------------------------------------------------------------------------
-- Options: Quality of Life Panel
--------------------------------------------------------------------------------

L["TAB_QUALITY_OF_LIFE"] = "Melhorias de conveniência"
L["TAB_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Pequenas ajudas fora do registro de missões em si: para a janela de missões do PNJ, para compartilhar missões com o seu grupo e para masmorras."
L["QUEST_GIVERS_HEADER"] = "PNJs de missões"
L["QUEST_GIVERS_DESCRIPTION"] = "A janela que um PNJ de missões abre, onde você aceita e entrega missões."
L["GIVER_CLEANUP"] = "Janela de missões do PNJ organizada"
L["GIVER_CLEANUP_DESCRIPTION"] =
	"Formata o texto da janela de missões do PNJ como o do registro de missões, com os mesmos títulos e espaçamento entre linhas, e mostra abaixo da missão o ID dela, com link para o Wowhead."
-- TRANSLATORS: %s is a level tag such as [40D], as in SHOW_QUEST_LEVELS_DESCRIPTION
L["GIVER_LEVELS_DESCRIPTION"] =
	"Adiciona as marcações de nível do registro de missões, como %s, à lista de missões de um PNJ."
L["QUEST_SHARING_HEADER"] = "Compartilhamento de missões"
L["QUEST_SHARING_INTRO"] =
	"Passe o mouse sobre o nome de uma zona no registro de missões e clique em Compartilhar missões para oferecer ao seu grupo, uma após a outra, todas as missões dela que você pode compartilhar. Estas opções definem o ritmo e o que acontece quando alguém perde uma."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"O botão Compartilhar missões no nome de uma zona requer Ativar registro de missões largo. O compartilhamento de missões de masmorra funciona sem ele."
L["SHARE_INTERVAL"] = "Segundos entre compartilhamentos"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Quanto tempo esperar entre uma missão compartilhada e a próxima, ao compartilhar as missões de uma zona ou de uma masmorra. Quanto maior, mais tempo o seu grupo tem para aceitar cada uma."
L["SHARE_WHISPERS"] = "Sussurrar quando um compartilhamento falhar"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quando um membro do grupo está ocupado, longe demais ou com o registro de missões cheio, sussurra para ele qual missão você tentou compartilhar e pede que ele te lembre. Nada é enviado quando ele não atende aos requisitos da missão, já está com ela ou já a concluiu."
L["SAMPLE_EXAMPLE"] = "Exemplo: %s"
L["SAMPLE_QUEST_LOADING"] = "Carregando ID da missão: %d"
L["DUNGEON_QUESTS_HEADER"] = "Missões de masmorra"
L["DUNGEON_QUESTS_INTRO"] =
	"Quando você entra em uma masmorra com o seu grupo, suas missões de lá são anunciadas e compartilhadas assim que todos estiverem ao alcance (na hora no WoW Forever), e nunca duas vezes para o mesmo grupo. Com o Questie, as missões com objetivos lá dentro também contam, incluindo as de classe. Nada acontece em um grupo de raide."
L["DUNGEON_ANNOUNCE"] = "Anúncio automático de missões de masmorra"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Diz ao seu grupo quais das suas missões ainda faltam fazer na masmorra em que você acabou de entrar, para todo mundo saber o que procurar. Missões prontas para entregar ficam de fora."
L["DUNGEON_SHARE"] = "Compartilhamento automático de missões de masmorra"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Compartilha cada missão da masmorra que o jogo deixa você compartilhar, no ritmo definido em Compartilhamento de missões, assim que todos estiverem ao alcance (ou depois de um minuto; na hora no WoW Forever). Cada membro do grupo recebe as missões uma vez por masmorra, então quem entra depois também recebe, e sair e voltar não compartilha nada. Com Sussurrar quando um compartilhamento falhar ativado, quem perder um compartilhamento recebe um sussurro e pode pedir de novo."

--------------------------------------------------------------------------------
-- Options: Waypoint Markers Panel
--------------------------------------------------------------------------------

L["TAB_WAYPOINT_MARKERS"] = "Marcadores de pontos de passagem"
L["TAB_WAYPOINT_MARKERS_DESCRIPTION"] =
	"Um marcador no mapa da zona para cada objetivo e entrega, no lugar de um monte de ícones de missão."
L["ROUTES_MAP_HEADER"] = "Mapa da zona"
L["ROUTES_MAP_DESCRIPTION"] = "Como o mapa da zona abre enquanto mostra a rota."
L["FULL_SIZE_MAP"] = "Abrir o mapa da zona em tamanho máximo"
L["FULL_SIZE_MAP_DESCRIPTION"] =
	"Abre o mapa da zona maximizado, como faz o próprio botão de maximizar dele, para a rota ter espaço. Se você diminuir o mapa, ele abre em tamanho máximo de novo na próxima vez."
L["HIDE_QUESTIE_ICONS"] = "Ocultar os ícones de missão na rota"
L["HIDE_QUESTIE_ICONS_DESCRIPTION"] =
	"Para o que está na rota, oculta os ícones de mapa do Questie, e os indicadores de missão e as áreas de objetivo da Blizzard, para que os marcadores da rota fiquem no lugar deles. Também oculta os ícones esmaecidos do Questie para os objetivos dos membros do grupo. Passe o mouse sobre um marcador para ver os ícones do Questie."
L["ROUTES_MARKERS_HEADER"] = "Marcadores"
L["ROUTES_MARKERS_DESCRIPTION"] = "Os marcadores de cada ponto de passagem da rota."
L["MARKER_SIZE"] = "Tamanho dos marcadores"
L["MARKER_SIZE_DESCRIPTION"] = "O tamanho dos marcadores da rota no mapa da zona."
L["MARKER_SIZE_SMALL"] = "Pequeno"
L["MARKER_SIZE_MEDIUM"] = "Médio"
L["MARKER_SIZE_LARGE"] = "Grande"
L["MARKER_SIZE_HUGE"] = "Enorme"

--------------------------------------------------------------------------------
-- Options: Quest Route Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ROUTE"] = "Rota de missões"
L["TAB_QUEST_ROUTE_DESCRIPTION"] =
	"Uma rota pelos seus marcadores de pontos de passagem no mapa da zona, na ordem em que fazê-los, a partir de onde você está."
L["FEATURE_QUEST_ROUTE_NEEDS_MARKERS"] =
	"A Rota de missões passa entre os marcadores de pontos de passagem, então só aparece enquanto Ativar Marcadores de pontos de passagem está ligado."
L["ROUTES_LINE_HEADER"] = "Linha da rota"
L["ROUTES_LINE_DESCRIPTION"] = "Os pontos em marcha que vão de você até cada marcador."
L["LINE_SPEED"] = "Velocidade da linha"
L["LINE_SPEED_DESCRIPTION"] = "A rapidez com que os pontos avançam até o próximo marcador."
L["LINE_SPEED_STILL"] = "Parada"
L["LINE_SPEED_SLOW"] = "Lenta"
L["LINE_SPEED_NORMAL"] = "Normal"
L["LINE_SPEED_FAST"] = "Rápida"
L["LINE_OPACITY"] = "Opacidade da linha"
L["LINE_OPACITY_DESCRIPTION"] =
	"O quanto os pontos são sólidos; quanto mais baixa, mais o mapa aparece através deles."
L["ROUTES_PARTY_HEADER"] = "Grupo"
L["ROUTES_PARTY_DESCRIPTION"] = "O que o seu grupo acrescenta à rota."
L["PARTY_QUESTS"] = "Incluir missões dos membros do grupo"
L["PARTY_QUESTS_DESCRIPTION"] =
	"Em grupo, a rota e a Seta de missões também incluem missões que os membros do seu grupo têm e você não, mostradas como as suas. É preciso ter o Questie dos dois lados para compartilhá-las. As missões de masmorra deles ficam de fora, pois os objetivos ficam dentro da masmorra."

--------------------------------------------------------------------------------
-- Options: Quest Arrow Panel
--------------------------------------------------------------------------------

L["TAB_QUEST_ARROW"] = "Seta de missões"
L["TAB_QUEST_ARROW_DESCRIPTION"] =
	"Uma seta na tela apontando para o próximo ponto de passagem da rota, com as missões e objetivos a fazer lá. Passe o mouse sobre ela para ver um menu onde você pode ignorar um objetivo por vez e ver o que ignorou. Clique nela com o botão do meio para redefinir a zona e trazer de volta o que você ignorou lá."
L["QUEST_ARROW_HEADER"] = "Seta"
L["QUEST_ARROW_DESCRIPTION"] = "Onde a Seta de missões fica e qual é o tamanho dela."
L["ARROW_SIZE"] = "Tamanho da seta"
L["ARROW_SIZE_DESCRIPTION"] = "O tamanho da Seta de missões, com o texto embaixo dela."
L["LOCK_ARROW"] = "Travar a Seta de missões"
L["LOCK_ARROW_DESCRIPTION"] = "Mantém a Seta de missões onde está, então arrastá-la não faz nada."
L["RESET_ARROW"] = "Posição da seta"
L["RESET_ARROW_BUTTON"] = "Redefinir"
L["RESET_ARROW_CONFIRM"] = "Colocar a Seta de missões de volta no lugar inicial?"
L["RESET_ARROW_DESCRIPTION"] = "Coloca a Seta de missões de volta onde ela começa, no alto, no meio da tela."
L["QUEST_ARROW_TEXT_HEADER"] = "Embaixo da seta"
L["QUEST_ARROW_TEXT_DESCRIPTION"] = "O que a Seta de missões lista embaixo dela."
L["SHOW_DISTANCE"] = "Mostrar distância"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_ARRIVED, as the Quest Arrow shows them
L["SHOW_DISTANCE_DESCRIPTION"] =
	'Mostra a quantos metros fica o próximo ponto de passagem. "%s" e "%s" aparecem de qualquer forma.'
L["SHOW_ARROW_QUESTS"] = "Mostrar missões e objetivos"
L["SHOW_ARROW_QUESTS_DESCRIPTION"] =
	"Lista as missões do próximo ponto de passagem, cada uma com o que falta fazer lá."
L["QUESTS_LISTED"] = "Máximo de missões listadas"
-- TRANSLATORS: %s is ROUTES_MORE_TASKS for 2 quests, as the Quest Arrow shows it
L["QUESTS_LISTED_DESCRIPTION"] =
	'O máximo de missões que a Seta de missões lista embaixo dela para um ponto de passagem. As demais são contadas em uma linha própria, como "%s".'
L["SHOW_ITEM_BUTTONS"] = "Mostrar botões de itens de missão"
L["SHOW_ITEM_BUTTONS_DESCRIPTION"] =
	"Coloca um botão ao lado de cada missão listada pela Seta de missões que tenha um item para usar, como um para arremessar, plantar ou usar em um alvo. Clique nele para usar o item, ou defina uma tecla para Usar item de missão nas Teclas de Atalho do jogo para usar o primeiro. Em combate, os botões ficam onde estão até ele terminar."
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_NEXT_OBJECTIVE"] = "Mostrar próximo objetivo"
-- TRANSLATORS: the first %s is ROUTES_OBJECTIVE_AREA and the second is ROUTES_NEXT_OBJECTIVE, as the Quest Arrow shows them
L["SHOW_NEXT_OBJECTIVE_DESCRIPTION"] =
	'Em "%s", lista "%s" embaixo, esmaecido: uma setinha até o ponto de passagem seguinte e o que há para fazer lá.'
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_UPCOMING_TURN_INS"] = "Mostrar entregas futuras"
L["SHOW_UPCOMING_TURN_INS_DESCRIPTION"] =
	"Coloca a entrega de cada missão na rota antes de os objetivos serem concluídos, marcada com o ponto de interrogação cinza do Questie, para você ver onde vai entregá-la. Desligado, uma entrega entra na rota quando a missão estiver concluída."
-- TRANSLATORS: also a switch on the Quest Arrow's menu
L["SHOW_LOCAL_QUESTS"] = "Mostrar missões disponíveis próximas como objetivos"
-- TRANSLATORS: %s is ROUTES_YARDS, such as "400 Yards"
L["SHOW_LOCAL_QUESTS_DESCRIPTION"] =
	"Coloca na rota as missões que você pode pegar, quando o Questie as mostra como disponíveis e um PNJ ou objeto que as inicia está a até %s de você, marcadas com o ponto de exclamação do Questie. Missões iniciadas por um item de saque e missões de masmorra e raide ficam de fora."
L["QUEST_ARROW_HIDING_HEADER"] = "Ocultar"
L["QUEST_ARROW_HIDING_DESCRIPTION"] = "Quando a Seta de missões sai do caminho."
L["HIDE_IN_RAIDS"] = "Ocultar em grupos de raide"
L["HIDE_IN_RAIDS_DESCRIPTION"] = "Oculta a Seta de missões enquanto você está em um grupo de raide."
L["HIDE_IN_INSTANCES"] = "Ocultar em instâncias"
L["HIDE_IN_INSTANCES_DESCRIPTION"] = "Oculta a Seta de missões em masmorras, raides e campos de batalha."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

L["OPTIONS_LEVEL_UP_TITLE"] = "Ajude o Pretty Wide Quest Log a subir de nível"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Este add-on foi feito por jogadores que amam este jogo e querem deixá-lo o mais divertido possível para todos. Nunca vamos pedir doações. A verdadeira satisfação é saber que nosso trabalho deixa o jogo um pouco melhor para você. Se for o caso, adoraríamos saber!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Aqui estão algumas formas de nos ajudar a alcançar mais jogadores."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Envie feedback: Encontrou um bug ou tem uma ideia? Conte para nós no Discord. Seu feedback nos ajuda a melhorar o add-on, e pull requests são sempre bem-vindos."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Conte para um amigo: Conhece alguém que pode gostar deste add-on? Fale dele para essa pessoa. O boca a boca ajuda mais jogadores a descobrir ótimos add-ons."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Favorite no CurseForge: Abra o link do CurseForge abaixo, entre na sua conta e clique na estrela abaixo do botão de download. Os favoritos ajudam mais jogadores a descobrir o add-on."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	"• Dê uma Star no GitHub: Abra o link do GitHub abaixo, entre na sua conta e clique em Star no canto superior direito. As estrelas ajudam o projeto a se qualificar para mais ferramentas gratuitas de desenvolvimento."
L["OPTIONS_LEVEL_UP_THANKS"] = "Obrigado por escolher o Pretty Wide Quest Log!"
L["OPTIONS_FEEDBACK"] = "Feedback e suporte"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Links de feedback e suporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Para copiar um link, clique na caixa dele e depois pressione Ctrl+A e Ctrl+C."
L["OPTIONS_VERSION"] = "Versão %s"

--------------------------------------------------------------------------------
-- Quest Log Window
--------------------------------------------------------------------------------

-- TRANSLATORS: each QUEST_SUFFIX_* is one letter shown after a quest's level, as in [40D]
L["QUEST_SUFFIX_DUNGEON"] = "M"
L["QUEST_SUFFIX_RAID"] = "R"
L["QUEST_SUFFIX_PVP"] = "J"
L["QUEST_SUFFIX_GROUP"] = "G"
L["QUEST_SUFFIX_ELITE"] = "E"
-- TRANSLATORS: each QUEST_TYPE_* is what the matching QUEST_SUFFIX_* letter above stands for
L["QUEST_TYPE_DUNGEON"] = "masmorra"
L["QUEST_TYPE_RAID"] = "raide"
L["QUEST_TYPE_GROUP"] = "grupo"
L["QUEST_TYPE_ELITE"] = "elite"
L["QUEST_TYPE_PVP"] = "JxJ"
-- TRANSLATORS: %s is the QUEST_LEVEL_LEGEND_ENTRY pairs, joined by LIST_SEPARATOR
L["QUEST_LEVEL_LEGEND"] = "Letras após o nível: %s."
-- TRANSLATORS: the first %s is a QUEST_SUFFIX_* letter and the second is its QUEST_TYPE_* word, as in "D dungeon"
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_ID"] = "ID da missão %d"
-- TRANSLATORS: the first %d is this quest's step in its chain and the second is how many steps the chain has
L["QUEST_CHAIN_PROGRESS"] = "Sequência de missões (%d de %d)"
-- TRANSLATORS: %s is the time left as the game writes it, such as "3 Hr 12 Min"
L["DAILY_RESET"] = "As missões diárias são renovadas em %s."
L["WOWHEAD_LINK_TOOLTIP"] = "Clique para obter um link do Wowhead."
L["WOWHEAD_LINK_COPY"] = "Pressione Ctrl+C (Cmd+C no Mac) para copiar o link do Wowhead."
L["EXPAND_ALL"] = "Expandir tudo"
L["COLLAPSE_ALL"] = "Recolher tudo"
L["TRACK_ALL"] = "Acompanhar todas"
L["UNTRACK_ALL"] = "Não acompanhar nenhuma"
L["HIDE_MAP"] = "Ocultar mapa"
-- TRANSLATORS: %s is an amount of experience with its thousands separators, such as "12,345"
L["TURN_IN_XP"] = "%s XP"
L["TURN_IN_SEPARATOR"] = " / "
-- TRANSLATORS: %s is TURN_IN_XP and the money, joined by TURN_IN_SEPARATOR, such as "12,345 XP / 5g 12s"
L["TURN_IN_SUMMARY"] = "Entrega: %s"
L["TURN_IN_TOOLTIP"] = "Pronta para entregar"
L["RESIZE_TOOLTIP"] = "Arraste para redimensionar o registro de missões."

--------------------------------------------------------------------------------
-- Zone Sharing
--------------------------------------------------------------------------------

L["SHARE_QUESTS"] = "Compartilhar missões"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Oferece ao seu grupo as missões desta zona que o jogo deixa você compartilhar, uma a cada %d segundos."
-- TRANSLATORS: %s is a quest's name
L["CHAT_SHARING_AFTER_COMBAT"] = "Compartilhando %s quando o combate terminar."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_ONE"] = "Compartilhando 1 missão de %s."
-- TRANSLATORS: %d is how many quests, %s is the zone, and the last %d is the seconds between shares
L["CHAT_SHARING_ZONE"] = "Compartilhando %d missões de %s, uma a cada %d segundos."
-- TRANSLATORS: %s is the zone
L["CHAT_SHARING_ZONE_NONE"] = "Nenhuma das suas missões de %s pode ser compartilhada."

--------------------------------------------------------------------------------
-- Waypoint Markers, Quest Route and the Quest Arrow
--------------------------------------------------------------------------------

L["ROUTES_ARRIVED"] = "Você chegou"
-- TRANSLATORS: where the Quest Arrow would be while its waypoint is on another continent
L["ROUTES_OTHER_MAP"] = "Ponto de passagem em outro mapa"
L["ROUTES_OBJECTIVE_AREA"] = "Área do objetivo atual"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when an objective there can be done nowhere else on the route
L["ROUTES_AREA_FINISH"] = "Termine aqui antes de seguir"
-- TRANSLATORS: under ROUTES_OBJECTIVE_AREA, when the route passes more of these mobs or objects later
L["ROUTES_AREA_MORE"] = "Mais ao longo da rota"
-- TRANSLATORS: heads the one line under the Quest Arrow's list naming where the route goes after this area
L["ROUTES_NEXT_OBJECTIVE"] = "Próximo objetivo"
-- TRANSLATORS: heads the dimmed objectives the player is passing through, planned for later on the route
L["ROUTES_WHILE_HERE"] = "Já que você está aqui"
-- TRANSLATORS: %d is a distance in yards
L["ROUTES_YARDS"] = "%d metros"
-- TRANSLATORS: ROUTES_YARDS for a distance of exactly 1
L["ROUTES_YARD"] = "%d metro"
-- TRANSLATORS: %d is how many more quests the Quest Arrow has at this waypoint than it lists
L["ROUTES_MORE_TASKS"] = "+%d a mais aqui"
L["ROUTES_TURN_IN"] = "Entregar missão"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_TURN_IN_QUEST"] = "Entregar %s"
L["ROUTES_PICK_UP"] = "Pegar missão"
-- TRANSLATORS: %s is the quest's title with its level, such as "[2] Wayward Weapons"
L["ROUTES_PICK_UP_QUEST"] = "Pegar %s"
L["ROUTES_CORPSE"] = "Volte até o seu corpo"
-- TRANSLATORS: heads the list of NPCs, mobs and objects found at a route waypoint
L["ROUTES_LOOK_FOR"] = "Procure"
L["ROUTES_CLICK_DRAG"] = "Arrastar"
L["ROUTES_CLICK_RIGHT"] = "Clique direito"
L["ROUTES_CLICK_MIDDLE"] = "Clique do meio"
L["ROUTES_CLICK"] = "Clique"
-- TRANSLATORS: beside ROUTES_CLICK, or the bound key, on a Quest Arrow item button's tooltip
L["ROUTES_CLICK_USE_ITEM"] = "Usar item"
-- TRANSLATORS: the key binding's name in the game's Key Bindings list, under the add-on's name
L["BINDING_USE_QUEST_ITEM"] = "Usar item de missão"
L["ROUTES_DRAG_MOVE"] = "Mover a Seta de missões"
L["ROUTES_RIGHT_CLICK_IGNORE_WAYPOINT"] = "Ignorar este ponto de passagem"
-- TRANSLATORS: right-clicking a map marker for one objective, which leaves it off the route or puts it back
L["ROUTES_RIGHT_CLICK_IGNORE"] = "Ignorar este objetivo"
L["ROUTES_RIGHT_CLICK_UNIGNORE"] = "De volta à rota"
L["ROUTES_MIDDLE_CLICK_RESET_ZONE"] = "Redefinir esta zona"
-- TRANSLATORS: %s is a quest link or a list of them
L["ROUTES_SKIPPED"] = "Ignorando %s até você redefinir a zona."
L["ROUTES_ZONE_RESET"] = "Zona redefinida: os objetivos ignorados aqui voltaram para a rota."
L["ROUTES_GROUP_LEFT_CLEARED"] = "Você saiu do grupo: os objetivos de grupo e membros ignorados voltaram para a rota."
-- TRANSLATORS: %s is a party member's name, or a list of them
L["ROUTES_MEMBER_LEFT_CLEARED"] = "%s saiu do grupo: os objetivos ignorados correspondentes voltaram para a rota."
-- TRANSLATORS: the Quest Arrow menu's labels over its groups of rows
L["ROUTES_MENU_SECTION_IGNORE"] = "Ignorar"
L["ROUTES_MENU_SECTION_SHOWN"] = "O que é mostrado"
-- TRANSLATORS: beside an objective on the Quest Arrow's menu that is at the Next Objective, not the current one
L["ROUTES_MENU_NEXT"] = "Próximo"
-- TRANSLATORS: beside an ignored objective under the mouse on the Quest Arrow's menu; a click puts it back on the route
L["ROUTES_MENU_PUT_BACK"] = "Restaurar"
-- TRANSLATORS: the Quest Arrow menu's label over its ignore list
L["ROUTES_MENU_IGNORED"] = "Ignorados"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_TURN_IN"] = "Entrega de %s"
-- TRANSLATORS: %s is a quest's name, such as "Wayward Weapons"
L["ROUTES_MENU_PICK_UP"] = "Coleta de %s"
-- TRANSLATORS: the Quest Arrow menu's switches under ROUTES_MENU_SECTION_SHOWN; Next Objective is ROUTES_NEXT_OBJECTIVE
L["ROUTES_MENU_SHOWN_TURN_INS"] = "Entregas futuras"
L["ROUTES_MENU_SHOWN_LOCAL"] = "Missões disponíveis próximas"
L["ROUTES_MENU_SHOWN_PARTY"] = "Objetivos do grupo"
L["ROUTES_MENU_ON"] = "Ligado"
L["ROUTES_MENU_OFF"] = "Desligado"
L["ROUTES_MENU_OUT_OF_ZONE"] = "Fora da zona"
L["ROUTES_MENU_NO_QUESTIE"] = "Sem Questie"
L["ROUTES_MENU_OFFLINE"] = "Offline"
-- TRANSLATORS: %s is a party member's name; On or Off shows beside it
L["ROUTES_MENU_MEMBER_OBJECTIVES"] = "Objetivos de %s"
-- TRANSLATORS: the first %s is an objective or ROUTES_MENU_TURN_IN, the second a quest link
L["ROUTES_IGNORED"] = "Ignorando %s de %s até você redefinir a zona."
-- TRANSLATORS: as ROUTES_IGNORED, for a party member's objective, a quest the player doesn't have
L["ROUTES_IGNORED_PARTY"] = "Ignorando %s de %s até os membros do grupo com essa missão saírem do grupo."
-- TRANSLATORS: %s is an objective or ROUTES_MENU_TURN_IN
L["ROUTES_UNIGNORED"] = "%s voltou para a rota."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_IGNORED"] = "Os objetivos de %s ficam fora da rota."
-- TRANSLATORS: %s is a party member's name
L["ROUTES_MEMBER_INCLUDED"] = "Os objetivos de %s voltaram para a rota."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

--[[
	TRANSLATORS: every line in this section is sent to other players in chat, 255 bytes at most, with no closing period;
	each %s is a quest link or a list of them, and each %d is how many quests
]]
L["WHISPER_SHARE_FAILED"] =
	"Tentei compartilhar %s com você, mas não deu certo. Se quiser a missão, me chama quando puder que eu compartilho de novo"
L["WHISPER_SHARE_FAILED_AGAIN"] = "O mesmo vale para %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Tenho %d missões para fazer aqui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Tenho 1 missão para fazer aqui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Mais missões para fazer aqui: %s"

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

-- TRANSLATORS: %s is a quest link, or the quest's name or ID when there's no link
L["QUESTIE_CANNOT_SHOW"] =
	"O rastreador do Questie não consegue mostrar %s porque a missão não está no banco de dados do Questie."
L["QUESTIE_CANNOT_TRACK"] = "O Questie ainda não consegue acompanhar esta missão."
