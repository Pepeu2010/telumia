# Miniaturas e filmstrip no seek da TV

Estado: **implementado no código local, em validação**. Não integra os APKs publicados da release 1.0.0. O incremento amplia `PlayerViewModel`, `PlayerScreen`, `PlayerProgressBar` e `PlayerTimelineFrames` existentes, mantendo Media3 e as ações de seek atuais.

## Comportamento

A posição pendente do controle remoto alimenta uma única fila de extração. O player principal recebe o seek pela ação existente de commit, no key-up; a prévia não o reposiciona. O foco continua na barra, e imagens/tiles não se tornam controles focáveis. Os incrementos de velocidade do D-pad existentes permanecem ativos.

O contexto inclui a conta/perfil e identidade local já resolvidos pelo repositório de momentos, obra, episódio, edição, URL, headers e duração. A composição revalida esse contexto antes de mostrar frames. Perder foco, abrir painéis/dialogs, trocar contexto ou sair do foreground encerra a sessão, cancela suas chamadas HTTP e libera o decoder. Sair do foreground também descarta a posição pendente, sem fazer seek no player principal.

Segurar o seek por 650 ms ativa o filmstrip. Repetições de posição não reiniciam esse timer. Se o usuário avança mais rápido que a decodificação, a fila pode apresentar uma amostra real da mesma sessão, com timestamp decodificado e aviso “Atualizando a cena…”, enquanto busca a posição mais recente. O destino da barra e o timestamp da imagem são distintos; não se atribui à imagem um horário inventado. Frames de outra sessão continuam rejeitados.

O filmstrip usa apenas frames distintos efetivamente decodificados, com no máximo cinco tiles. Durante movimento rápido, pode aproveitar amostras recentes em até 60 segundos ao redor do frame central; ao estabilizar, solicita os vizinhos próximos. Falha em um vizinho conserva o frame central válido. O cache RAM segue a quota existente, limitado a 4 MiB; isso não constitui um limite de memória total do decoder nem cache durável/offline.

No limite final, o pedido é normalizado para o último instante finito, sem inventar um frame no EOS. Áudio sem vídeo recebe fallback indisponível, sem poster disfarçado de cena. Loading, erro, recuperação e timestamps obsoletos têm estados separados.

## Apresentação e movimento

O visor de cena fica acima da barra, com imagem 16:9, destino solicitado e horário real do frame. Em tela compacta, usa imagem de 192 dp; nas demais, 272 dp. Durante seek nos controles completos, os detalhes textuais dão lugar ao visor, preservando a posição da barra e das ações inferiores. A paleta do player permanece escura para manter contraste, inclusive quando o restante do app usa tema claro.

O filmstrip e a entrada/saída do overlay usam a política de movimento do perfil; Reduzido e Desligado são respeitados. Não há blur, loop decorativo ou nova biblioteca de animação. A implementação utiliza as [transições nativas do Compose](https://developer.android.com/develop/ui/compose/animation/composables-modifiers) e preserva a [gestão de foco existente](https://developer.android.com/develop/ui/compose/touch-input/focus/change-focus-behavior).

## Prova disponível e pendente

Antes da integração visual, o commit `55cd5f33f27a1a63878614dfda8c182bc5a44915` passou em **215 testes selecionados e sete casos nativos por API 24/36**, incluindo cancelamento de corpo HTTP ativo, chamadas enfileiradas e recuperação. [Binding](telumia-tv-preview-lifecycle-r2-build-binding.json), [API 24](telumia-tv-preview-lifecycle-r2-api24-qa.json), [API 36](telumia-tv-preview-lifecycle-r2-api36-qa.json). A publicação em `main` acrescentou apenas a mesclagem do README da 1.0.0.

O novo incremento visual está no commit local `af115980da861b5b526005c7315745c6ac6f808d`. O primeiro build foi interrompido para incluir o respeito ao movimento no overlay de seek. O segundo perdeu seu runner/daemon antes de uma conclusão verificável. Essas tentativas foram preservadas; a recompilação atual usa o mesmo commit, com label `telumia-tv-timeline-ui-r3`.

O build `telumia-tv-timeline-ui-r3` passou em **222 testes selecionados**, sem falhas, erros ou skips; compilou os cinco APKs de desenvolvimento e o APK de instrumentação, com checkout limpo antes/depois. [Binding](telumia-tv-timeline-ui-r3-build-binding.json). Os **nove casos nativos de extração/seek vinculado passaram na API 36** com os mesmos APKs. [QA API 36](telumia-tv-timeline-ui-r3-api36-qa.json).

A suíte visual na API 36/1080p passou em **três dos quatro casos**. O caso de D-pad falhou ao exigir posição 6000 ms no vídeo local de seis segundos; o player efetivo reportou 5999 ms no limite final. A verificação deve tratar explicitamente esse limite e continuar exigindo posição exata para seek interior, isolamento antes do key-up e restauração de foco. Não se considera a suíte aprovada. A fila encerrou com falha e preservou a instrumentação; as configurações API 24, 720p e 4K desse incremento ainda não foram executadas. [Resultado visual](telumia-tv-timeline-surface-r3-api36-1080-qa.json). A melhoria permanece fora dos APKs 1.0.0 publicados.

A QA de componentes com AVC original gerado localmente não comprova todas as rotas da MainActivity, conta oficial autenticada, fontes remotas de terceiros, libmpv TV, HDR ou desempenho em TV física. A guarda atual de vídeo seekable usa o player Media3 efetivamente preparado; outros backends recebem fallback. Essas lacunas e a meta integral permanecem abertas.

## Continuação após o primeiro gate

O commit `f890570a46e3558f1f267005bc76d7702531a287` corrigiu a fixture de D-pad: vídeo original de 30 segundos, aplicação cumulativa do delta, seek interior exato (2 → 12 segundos), limite final explícito (29999 ms) e retorno exato (20 segundos). O build `telumia-tv-timeline-ui-r4` passou novamente nos **222 testes selecionados**, com cinco APKs e instrumentação, e nos **nove casos de extração API 36**. [Binding](telumia-tv-timeline-ui-r4-build-binding.json), [extração](telumia-tv-timeline-ui-r4-api36-qa.json).

A primeira suíte visual r4 teve timeout de extração no caso Reduzido; o caso D-pad passou. Uma repetição sem alterar fonte/APKs passou nos quatro casos API 36/1080p, mas a inspeção da captura Completo encontrou uma imagem branca. Portanto, o resultado da instrumentação não constitui aprovação visual. Na API 24, oito dos nove casos passaram: a fixture de seek contínuo encerrou o movimento após 1,8 s, antes de obter uma amostra no decoder frio. Não há aprovação dessa configuração. As tentativas anteriores permanecem preservadas.

O commit local `ddd55a9924c8bc58295f17fe55a462bac7d39f9b` mantém a amostra real da mesma sessão durante novas repetições, com estado provisório e timestamp decodificado, evitando substituir cada amostra por Loading. A captura passa a exigir pixels reais do frame azul e do viewport escuro antes de salvar. O teste de movimento cobre a preparação fria dentro de uma janela limitada e continua o seek por mais 1,8 s após a primeira amostra, sem aguardar soltar o controle para contar um frame. Build `telumia-tv-timeline-ui-r5` e gates posteriores estão em execução; nenhum resultado futuro é presumido.
