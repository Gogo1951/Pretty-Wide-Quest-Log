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
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) ficam em Opções > AddOns > Pretty Wide Quest Log. Está gostando deste add-on? Conte para um amigo, favorite-o no CurseForge ou dê uma Star no GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por precaução, a interface de opções não pode ser aberta durante o combate."
L["CHAT_QUESTIE_MISSING"] =
	"Boa parte deste add-on funciona com os dados do Questie, então alguns recursos ficam limitados sem ele."
L["CHAT_PREDECESSOR_LOADED"] =
	"O Wide Quest Log Plus também está ativado, e os dois vão brigar pelo registro de missões. Desative o Wide Quest Log Plus na lista de AddOns e recarregue."

--------------------------------------------------------------------------------
-- Options: General Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Um registro de missões largo, redimensionável e com dois painéis, com níveis das missões, marcadores de masmorra e elite, recompensas, cadeias de missões e um mapa para cada missão. Compartilhe missões com seu grupo e anuncie automaticamente as missões de masmorra. Funciona com Questie, VoiceOver e ElvUI."
L["ENABLE_WELCOME_MESSAGE"] = "Ativar mensagem de boas-vindas"
L["ENABLE_WELCOME_MESSAGE_DESCRIPTION"] = "Mostra a mensagem de boas-vindas do Pretty Wide Quest Log ao entrar no jogo."
L["OPTIONS_FEATURES_HEADER"] = "Recursos"
L["ENABLE_WIDE_QUEST_LOG"] = "Ativar registro de missões largo"
L["FEATURE_QUEST_LOG_DESCRIPTION"] =
	"Troca o registro de missões da Blizzard pelo largo, com o mapa ao lado. Entra em vigor após recarregar."
L["ENABLE_QUALITY_OF_LIFE"] = "Ativar melhorias de conveniência"
L["FEATURE_QUALITY_OF_LIFE_DESCRIPTION"] =
	"Ativa a janela de missões do PNJ organizada, seu próprio ritmo ao compartilhar missões, os sussurros quando um compartilhamento falha e o anúncio e compartilhamento de missões de masmorra. Desative para ter de volta a janela de missões do PNJ da Blizzard e compartilhar no ritmo padrão."
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
L["SHOW_QUEST_LEVELS_DESCRIPTION"] =
	"Coloca o nível e o tipo de cada missão antes do nome dela na lista, como [40M] para uma missão de masmorra de nível 40."
L["MARK_UNTRACKED"] = "Marcar missões não acompanhadas"
L["MARK_UNTRACKED_DESCRIPTION"] =
	"Missões acompanhadas perdem a marca de seleção %s, e missões não acompanhadas ganham um olho %s no lugar. Útil se você acompanha quase tudo."
L["CLOSE_IN_COMBAT"] = "Fechar ao entrar em combate"
L["CLOSE_IN_COMBAT_DESCRIPTION"] =
	"Fecha o registro de missões quando uma luta começa, para que ele nunca cubra a ação."
L["SHOW_OBJECTIVE_AREAS"] = "Mostrar áreas dos objetivos"
L["SHOW_OBJECTIVE_AREAS_DESCRIPTION"] =
	"Sombreia no mapa ao lado do registro de missões onde ficam os inimigos e objetos de cada objetivo, com um ícone em cada área em vez de um em cada ponto de surgimento. Requer o Questie."
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
L["GIVER_LEVELS"] = "Mostrar níveis das missões"
L["GIVER_LEVELS_DESCRIPTION"] =
	"Adiciona as marcações de nível do registro de missões, como [40M], à lista de missões de um PNJ."
L["QUEST_SHARING_HEADER"] = "Compartilhamento de missões"
L["QUEST_SHARING_DESCRIPTION"] =
	"Compartilhar missões, no menu de clique direito de uma zona no registro de missões, oferece ao seu grupo, uma após a outra, todas as missões daquela zona que o jogo deixa você compartilhar. As opções abaixo definem o ritmo e o que acontece quando um membro do grupo perde uma."
L["SHARE_INTERVAL"] = "Segundos entre compartilhamentos"
L["SHARE_INTERVAL_DESCRIPTION"] =
	"Quanto tempo esperar entre uma missão compartilhada e a próxima, em Compartilhar missões e no compartilhamento de missões de masmorra. Quanto maior, mais tempo o seu grupo tem para aceitar cada uma."
L["SHARE_WHISPERS"] = "Sussurrar quando um compartilhamento falhar"
L["SHARE_WHISPERS_DESCRIPTION"] =
	"Quando um membro do grupo está ocupado, longe demais ou com o registro de missões cheio, sussurra para ele qual missão você tentou compartilhar e pede que ele te lembre. Nada é enviado quando ele não pode pegar a missão."
L["OPTIONS_EXAMPLE"] = "Exemplo:"
L["OPTIONS_EXAMPLE_QUEST_NAME"] = "Nome da missão"
L["DUNGEON_QUESTS_HEADER"] = "Missões de masmorra"
L["DUNGEON_QUESTS_DESCRIPTION"] =
	"Entram em ação quando você entra em uma masmorra ou raide com o seu grupo, uma vez por grupo para cada masmorra. Uma missão conta se estiver listada sob a masmorra no seu registro de missões ou, com o Questie, se algum dos objetivos dela estiver lá dentro, o que inclui também as missões de classe."
L["DUNGEON_ANNOUNCE"] = "Anúncio automático de missões de masmorra"
L["DUNGEON_ANNOUNCE_DESCRIPTION"] =
	"Diz ao seu grupo quais das suas missões ainda faltam fazer na masmorra em que você acabou de entrar, para todo mundo saber o que procurar. Missões prontas para entregar ficam de fora."
L["DUNGEON_SHARE"] = "Compartilhamento automático de missões de masmorra"
L["DUNGEON_SHARE_DESCRIPTION"] =
	"Compartilha cada missão da masmorra que o jogo deixa você compartilhar, no ritmo definido em Compartilhamento de missões. Com Sussurrar quando um compartilhamento falhar ativado, quem perder um compartilhamento recebe um sussurro e pode pedir de novo. Compartilha de novo sempre que alguém entra ou sai do grupo."

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

L["WHISPER_SHARE_FAILED"] =
	"Tentei compartilhar %s com você, mas não deu certo. Se quiser a missão, me chama quando puder que eu compartilho de novo."
L["WHISPER_SHARE_FAILED_AGAIN"] = "O mesmo vale para %s."
L["DUNGEON_QUESTS_ANNOUNCE"] = "Tenho %d missões para fazer aqui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_ONE"] = "Tenho 1 missão para fazer aqui: %s"
L["DUNGEON_QUESTS_ANNOUNCE_MORE"] = "%s"
L["DUNGEON_QUESTS_SEPARATOR"] = ", "

--------------------------------------------------------------------------------
-- Questie Tracking
--------------------------------------------------------------------------------

L["QUESTIE_CANNOT_SHOW"] =
	"O rastreador do Questie não consegue mostrar %s porque a missão não está no banco de dados do Questie."
L["QUESTIE_CANNOT_TRACK"] = "O Questie ainda não consegue acompanhar esta missão."
