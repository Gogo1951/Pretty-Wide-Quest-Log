local L = LibStub("AceLocale-3.0"):NewLocale("Pretty-Wide-Quest-Log", "ptBR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Pretty Wide Quest Log"
L["ADDON_SHORT_NAME"] = "PWQL"
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
	"Um registro de missões largo, redimensionável e com dois painéis, com níveis das missões, marcadores de masmorra e elite, recompensas, cadeias de missões e um mapa para cada missão. Compartilhe missões com seu grupo e anuncie automaticamente as missões de masmorra. Funciona com Questie, Spoken, VoiceOver e ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Ativar mensagem de boas-vindas"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra a mensagem de boas-vindas do Pretty Wide Quest Log ao entrar no jogo."
L["OPTIONS_FEATURES_HEADER"] = "Recursos"
L["ENABLE_WIDE_QUEST_LOG"] = "Ativar registro de missões largo"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Troca o registro de missões da Blizzard pelo largo, com o mapa ao lado. Entra em vigor após recarregar."
L["ENABLE_QUALITY_OF_LIFE"] = "Ativar melhorias de conveniência"
L["FEATURE_QUALITY_OF_LIFE_SUMMARY"] =
	"Organiza a janela de missões do PNJ e ajuda seu grupo a pegar suas missões: ritmo de compartilhamento, sussurros quando um compartilhamento não chega a alguém, e anúncio e compartilhamento de missões de masmorra. Compartilhar as missões de uma zona com o botão direito no nome dela também funciona com isto desativado."
L["FEATURE_QUEST_LOG_RELOAD_PENDING"] =
	"Ativar registro de missões largo entra em vigor após recarregar, o que será oferecido quando você fechar a interface de opções."
L["RELOAD_PROMPT"] = "O Pretty Wide Quest Log troca de registro de missões após recarregar. Recarregar agora?"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/pwql"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a interface de opções deste add-on."

--------------------------------------------------------------------------------
-- Options: Quest Log Panel
--------------------------------------------------------------------------------

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
L["HANDY_CLICK_ZONE"] = "Clique direito no nome de uma zona"
L["HANDY_CLICK_ZONE_DESCRIPTION"] = "Compartilhe as missões dela ou abandone as cinzas."
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
	"Clique com o botão direito no nome de uma zona no registro de missões para oferecer ao seu grupo, uma após a outra, todas as missões dela que você pode compartilhar. Estas opções definem o ritmo e o que acontece quando alguém perde uma."
L["ZONE_SHARE_NEEDS_WIDE_LOG"] =
	"O clique direito no nome de uma zona requer Ativar registro de missões largo. O compartilhamento de missões de masmorra funciona sem ele."
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
L["QUEST_LEVEL_LEGEND"] = "Letras após o nível: %s."
L["QUEST_LEVEL_LEGEND_ENTRY"] = "%s %s"
L["QUEST_LEVEL_LEGEND_SEPARATOR"] = ", "
L["QUEST_ID"] = "ID da missão %d"
L["QUEST_CHAIN_PROGRESS"] = "Sequência de missões (%d de %d)"
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

L["ZONE_MENU_ACTIONS_HINT"] = "Clique direito para compartilhar missões ou abandonar as cinzas."
L["SHARE_ZONE_QUESTS"] = "Compartilhar %d missões"
L["SHARE_ZONE_QUEST"] = "Compartilhar 1 missão"
L["SHARE_ZONE_QUESTS_TOOLTIP"] =
	"Oferece ao seu grupo as missões desta zona que o jogo deixa você compartilhar, uma a cada %d segundos."
L["SHARE_ZONE_QUEST_TOOLTIP"] = "Oferece ao seu grupo a única missão desta zona que o jogo deixa você compartilhar."
L["CHAT_SHARING_ZONE_ONE"] = "Compartilhando 1 missão de %s."
L["CHAT_SHARING_ZONE"] = "Compartilhando %d missões de %s, uma a cada %d segundos."
L["ABANDON_GRAY_QUESTS"] = "Abandonar missões cinzas"
L["ABANDON_GRAY_NONE"] = "Esta zona não tem missões cinzas para abandonar."
L["ABANDON_GRAY_CONFIRM"] = "Abandonar estas %d missões cinzas?"
L["ABANDON_GRAY_CONFIRM_ONE"] = "Abandonar esta missão cinza?"
L["CHAT_ABANDONED_GRAY"] = "%d missões cinzas abandonadas."
L["CHAT_ABANDONED_GRAY_ONE"] = "1 missão cinza abandonada."

--------------------------------------------------------------------------------
-- Messages to Other Players
--------------------------------------------------------------------------------

-- TRANSLATORS: sent to other players in chat, 255 bytes at most, with no closing period; %s is a quest link or a list of them
L["WHISPER_SHARE_FAILED"] =
	"Tentei compartilhar %s com você, mas não deu certo. Se quiser a missão, me chama quando puder que eu compartilho de novo"
L["WHISPER_SHARE_FAILED_AGAIN"] = "O mesmo vale para %s"
L["DUNGEON_QUESTS_ANNOUNCE"] = "Tenho %d missões para fazer aqui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Tenho 1 missão para fazer aqui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_CONTINUED"] = "Mais missões para fazer aqui: %s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"O rastreador do Questie não consegue mostrar %s porque a missão não está no banco de dados do Questie."
L["QUESTIE_CANNOT_TRACK"] = "O Questie ainda não consegue acompanhar esta missão."
