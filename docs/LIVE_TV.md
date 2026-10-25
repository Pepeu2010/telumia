# Live TV — início da Fase 6 na Android TV

Este primeiro incremento integra regras reais ao cliente TV existente, sem criar uma rota paralela nem expor uma tela incompleta. A busca encontrou componentes visuais/tokens Live TV preparados na Fase 1 e a sincronização separada de Continue Assistindo para o launcher Android; não havia modelo de canal, importador M3U ou parser XMLTV da experiência Live TV.

## Entregue

- `LiveTvChannel`, `LiveTvProgram` e `LiveTvImportResult` representam fontes configuradas pelo usuário. `streamUrl` é opcional porque registros XMLTV descrevem canais e logos, mas não fornecem necessariamente um endereço de reprodução.
- `M3uPlaylistParser` interpreta `#EXTM3U`, metadados usuais `tvg-id`, `tvg-name`, `tvg-logo`, `group-title` e títulos com vírgulas. Aceita apenas URLs HTTP(S), limita a playlist a 8 MiB/5.000 canais, descarta duplicatas e cria um identificador determinístico por origem/endereço sem registrar o URL no log.
- `XmlTvParser` processa um `Reader` em fluxo, limita o documento a 16 Mi caracteres, canais a 5.000 e programas a 20.000, conserva título/descrição/categoria/logo, prefere nomes em português quando fornecidos e normaliza os horários para epoch UTC. Timestamp sem offset é interpretado como UTC.
- DTD e entidades externas são desativadas/recusadas. Falhas de parsing não incluem texto XML ou URLs sensíveis na mensagem pública.

## Validação

O run [39343144126](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126) passou nos filtros unitários existentes e nos testes novos `M3uPlaylistParserTest`/`XmlTvParserTest`, compilou `compileFullDebugAndroidTestKotlin` e montou `fullDebug`. A primeira tentativa, [39342834370](https://github.com/Pepeu2010/telumia-tv/actions/runs/39342834370), falhou porque `ACCESS_EXTERNAL_DTD` e `ACCESS_EXTERNAL_SCHEMA` não fazem parte do `XMLConstants` disponibilizado pelo Android SDK. O código foi corrigido no commit `289d81f5` mantendo o bloqueio de DTD/entidades e o build posterior passou.

O CI publicou APKs do commit `289d81f5` por sete dias: [ARM64](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126/artifacts/12229822808), [ARMv7](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126/artifacts/12229583571) e [universal](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126/artifacts/12230175419). São variantes de depuração. Testes instrumentados foram compilados, mas não executados; não há aparelho conectado para QA físico.

## Ainda não entregue

Este incremento ainda não importa arquivos/URLs pela interface, persiste a configuração, baixa playlists/EPG, resolve redirecionamentos/credenciais, agenda atualizações, aplica timezone por região, liga `tvg-id` a um guia atualizado, integra `Media3` para reproduzir o canal, nem implementa Agora/Guia/Canais/Favoritos/Recentes com foco D-pad. Nenhum canal ou conteúdo vem embutido. A Fase 6 permanece aberta até esses fluxos reais e seus estados de erro/offline/passagem de foco serem implementados e testados.

## Incremento seguinte: configuração e importação segura

O commit `e04c6b8d8` acrescenta `LiveTvSourceStore`, isolado pelo perfil ativo, para cadastrar/remover/ativar até 20 fontes M3U e XMLTV. O DataStore guarda apenas metadados/URLs (até 64 KiB); canais e programação não são serializados nele. URLs precisam ser HTTP(S), sem credenciais embutidas ou fragmentos.

`LiveTvSourceImporter` baixa apenas as URLs configuradas pelo usuário com TLS padrão, sem redirects, conexão de 10 s, leitura de 20 s e chamada total de 30 s. Os corpos ficam limitados a 8 MiB para M3U e 16 MiB para XMLTV; então os parsers já existentes aplicam limites adicionais de caracteres, campos e registros. O import combina canais e guia sem inventar endereço de reprodução para entradas que só existem no XMLTV. O cliente está pronto para a camada de fluxo/UI consumir; essa camada ainda não foi exposta.

Testes de integração local cobrem playlist válida, redirect recusado e resposta acima do limite. O run [39344159603](https://github.com/Pepeu2010/telumia-tv/actions/runs/39344159603) passou em 8 min 3 s, incluindo os testes unitários selecionados (com `LiveTvSourceImporterTest`), compilação do source set instrumentado e `assembleFullDebug`. Foram publicados por sete dias: [universal — 178.513.208 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39344159603/artifacts/12230786299), [ARM64 — 91.541.966 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39344159603/artifacts/12230771274) e [ARMv7 — 89.440.380 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39344159603/artifacts/12229884144). O código está no commit `e04c6b8d8` do fork. APKs são builds de debug; testes instrumentados foram compilados, mas não executados em aparelho.

A persistência do catálogo/EPG, atualização agendada, correspondência e janela temporal do guia, interface D-pad, favoritos/recents e reprodução Media3 continuam pendentes; a Fase 6 segue aberta. Não houve QA em TV Box física.

## Tela, canais e reprodução

O commit `756592bae` fecha a primeira ligação da Fase 6 ao produto: a rota `LiveTvScreen` entra no menu lateral existente, cadastra/ativa/desativa/remove fontes, atualiza listas, apresenta canais e Agora/A seguir do XMLTV e encaminha streams reais para o player Media3 existente. Voltar do player restaura a lista de canais. Entradas presentes apenas no EPG não recebem ação de reprodução; o app não inventa URLs.

A correspondência usa `sourceId + tvg-id`, horários XMLTV são apresentados no fuso configurado no aparelho e o progresso do programa atual é atualizado a cada 30 segundos. O guia é indexado por canal ao renderizar a lista para evitar varrer milhares de programas a cada linha/foco na TV Box. A interface tem estados de carregamento, erro, lista vazia e tradução pt-BR.

O run final [39345894765](https://github.com/Pepeu2010/telumia-tv/actions/runs/39345894765) passou nos testes selecionados, compilou os testes instrumentados e concluiu `assembleFullDebug` em 7 min 48 s. Foram publicados por sete dias: [universal — 178.561.844 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39345894765/artifacts/12230959671), [ARM64 — 91.590.606 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39345894765/artifacts/12230999431) e [ARMv7 — 89.489.016 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39345894765/artifacts/12231044091). O commit contém os testes de estado para importação e fonte desativada. Houve avisos de opt-in experimental em `runCurrent` nos testes, sem falha.

Ainda falta persistir o catálogo/EPG entre sessões, agendar atualização, oferecer grade temporal navegável, favoritos, recentes, mini-player e configuração explícita de fuso. A compilação instrumentada não foi executada em hardware e não houve validação visual em TV Box física; a Fase 6 permanece aberta.

## EPG persistido dentro do orçamento de cache

O commit `7c3aa199a` adiciona retomada offline do guia entre sessões. Após carregar as fontes configuradas no perfil ativo, o ViewModel mostra o último catálogo EPG salvo e tenta atualizá-lo da rede; uma falha de rede mantém os dados existentes visíveis e informa o erro da fonte. Remover uma fonte também remove sua entrada de cache.

O guia é guardado em arquivos binários gzip sob o cache privado do app, com nome derivado por hash do identificador da fonte. O formato serializa campos em fluxo, sem formar um JSON grande na memória; contagens, strings, bytes comprimidos e bytes descomprimidos têm limites. Escritas respeitam a cota EPG e a reserva global de armazenamento, substituem via arquivo temporário no mesmo diretório e expulsam entradas antigas por LRU ao exceder a cota. Leituras continuam disponíveis em modo somente leitura quando a reserva de espaço bloqueia novas gravações. Os arquivos `live_tv_guide` entram no cálculo central de ocupação.

O primeiro CI (`39347601646`) revelou que kotlinx.serialization `1.8.0` não contém as APIs de streaming usadas na implementação inicial; o formato foi substituído por binário em fluxo. O run final [39348949175](https://github.com/Pepeu2010/telumia-tv/actions/runs/39348949175) passou nos testes unitários selecionados, compilou os testes instrumentados e concluiu `assembleFullDebug` em 7 min 39 s no commit `49a7cc8fc`. Inclui testes de round-trip, leitura offline, quota, LRU, substituição e retenção do guia ao falhar a rede. Os APKs de depuração ficam disponíveis por sete dias: [universal — 178.582.084 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39348949175/artifacts/12232397369), [ARM64 — 91.610.842 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39348949175/artifacts/12232417414) e [ARMv7 — 89.509.256 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39348949175/artifacts/12232262961). O build usou assinatura de debug do CI. Testes instrumentados foram compilados, mas não executados em aparelho; não houve QA físico em TV Box.

A agenda de atualização em segundo plano, timezone selecionável, favoritos, recentes, mini-player e validação de fonte/stream continuam pendentes. A Fase 6 segue aberta.

## Grade EPG temporal navegável

O commit `ce23c9f88` integra o modo Guia aos componentes e à rota existentes. Quando há programação XMLTV correspondente aos canais, Agora e Guia ficam disponíveis; sem dados EPG, o seletor não aparece. A grade apresenta três horas a partir da hora corrente, posiciona programas pela duração e pelas lacunas, recorta entradas para a janela e remove sobreposições visuais. Os horários usam o fuso local do aparelho. No modo Guia, o relógio periódico de 30 segundos fica suspenso para evitar recomposição da tela inteira; ao entrar no Guia a janela é recalculada.

O D-pad percorre canais e programas com os componentes Lazy existentes. Somente canais com URL de stream configurada recebem ações de reprodução; linhas/células vindas apenas do XMLTV são apresentadas como conteúdo sem botão. Testes JVM cobrem recorte temporal, lacunas, sobreposição e janela inválida; um teste instrumentado verifica que dados XMLTV sem stream não expõem ações falsas.

O run [39353005423](https://github.com/Pepeu2010/telumia-tv/actions/runs/39353005423) passou nos testes JVM selecionados, compilou os testes instrumentados e concluiu `assembleFullDebug` em 8 min 2 s no commit `dc1c22093`. Os APKs de depuração ficam disponíveis até 27/10/2026: [universal — 178.599.020 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39353005423/artifacts/12234026767), [ARM64 — 91.627.782 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39353005423/artifacts/12233942711) e [ARMv7 — 89.526.192 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39353005423/artifacts/12234081619). O build usa assinatura de debug do CI. Testes instrumentados foram compilados, não executados em aparelho; não houve QA físico em TV Box.

O registro estruturado do build está em [telumia-tv-live-tv-r7-ci.json](telumia-tv-live-tv-r7-ci.json).

## Favoritos e canais recentes por perfil

O commit `8d0bbdcc0` adiciona os cinco modos da área Live TV: Agora, Guia, Canais, Favoritos e Recentes. A alternância para Guia só aparece com dados XMLTV correspondentes. Favoritos e recentes são persistidos localmente no DataStore isolado pelo perfil ativo; o estado guarda apenas IDs de canais, sem duplicar URL de stream ou conteúdo do EPG. O limite é de 2.000 favoritos e 30 recentes, ordenados pelo início mais recente de reprodução. Remover uma fonte elimina somente IDs de canais daquela fonte. A troca de perfil limpa a tela imediatamente e carrega as listas do novo perfil.

Os canais podem ser favoritados em Agora, Guia ou Canais, com ação acessível no D-pad. Recentes só é atualizado quando o usuário inicia a reprodução pelo player existente. Estados vazios são apresentados em pt-BR. Testes cobrem persistência após recriar o store, isolamento entre perfis, ordenação/limite, remoção da fonte, atualização do ViewModel e nome acessível da ação de favorito.

O run [39354781031](https://github.com/Pepeu2010/telumia-tv/actions/runs/39354781031) passou nos testes JVM selecionados, compilou a instrumentação e concluiu `assembleFullDebug` em 7 min 42 s no commit `b5459a542`. Os APKs de depuração ficam disponíveis até 27/10/2026: [universal — 178.624.128 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39354781031/artifacts/12234902678), [ARM64 — 91.652.886 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39354781031/artifacts/12235495298) e [ARMv7 — 89.551.300 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39354781031/artifacts/12234484783). Testes instrumentados foram compilados, mas não executados; não houve QA em TV Box física.

O registro estruturado do build está em [telumia-tv-live-tv-r8-ci.json](telumia-tv-live-tv-r8-ci.json).

## Atualização periódica do guia

O commit `47e432345` adiciona trabalho periódico do WorkManager para fontes Live TV habilitadas no perfil ativo. O agendamento usa intervalo de 12 horas com janela flexível de 2 horas e exige rede conectada e armazenamento disponível. Ao desativar ou remover todas as fontes habilitadas, o trabalho periódico é cancelado; mudanças de perfil reconciliam o agendamento e a leitura do cache acompanha somente o perfil ativo.

Cada fonte é importada sequencialmente. Falha parcial preserva o guia em cache daquela fonte; a política de repetição exponencial é ativada apenas se todas as fontes habilitadas falharem. A atualização manual continua disponível. Testes selecionados cobrem filtragem de fontes desativadas, retenção de cache em falha parcial, execução sem fontes e sincronização do agendador com o perfil/fontes.

O run [39358003957](https://github.com/Pepeu2010/telumia-tv/actions/runs/39358003957) passou nos testes JVM selecionados, compilou os testes instrumentados e concluiu `assembleFullDebug` em 10 min 59 s no commit `fe20a3380`. APKs de depuração ficam disponíveis até 27/10/2026: [universal — 179.151.718 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39358003957/artifacts/12235314872), [ARM64 — 92.180.480 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39358003957/artifacts/12235983212) e [ARMv7 — 90.078.890 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39358003957/artifacts/12235514524). O build usa assinatura de debug do CI. Testes instrumentados foram compilados, mas não executados em aparelho; não houve QA físico em TV Box.

O registro estruturado está em [telumia-tv-live-tv-r9-ci.json](telumia-tv-live-tv-r9-ci.json).

## Fuso horário do guia por perfil

Os commits `b369ea40e` e `e8d8308cf` adicionam um seletor acessível por D-pad para usar o fuso do aparelho ou Brasília, Manaus, Rio Branco, Fernando de Noronha e UTC. A escolha fica no mesmo estado DataStore já isolado por perfil para favoritos e canais recentes. A grade, Agora/A seguir e o horário da última atualização das fontes formatam os mesmos instantes no fuso selecionado; não mudam horários de eventos, ordenação nem reprodução. Identificadores inválidos voltam ao fuso do aparelho.

O run [39359528952](https://github.com/Pepeu2010/telumia-tv/actions/runs/39359528952) passou nos testes JVM selecionados, compilou os testes instrumentados e concluiu `assembleFullDebug` em 7 min 50 s no commit `e8d8308cf`. APKs de depuração ficam disponíveis até 27/10/2026: [universal — 179.161.338 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39359528952/artifacts/12237345254), [ARM64 — 92.190.096 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39359528952/artifacts/12236239064) e [ARMv7 — 90.088.510 bytes](https://github.com/Pepeu2010/telumia-tv/actions/runs/39359528952/artifacts/12236931962). O build usa assinatura de debug do CI. Testes instrumentados foram compilados, mas não executados em aparelho; não houve QA físico em TV Box.

O registro estruturado está em [telumia-tv-live-tv-r10-ci.json](telumia-tv-live-tv-r10-ci.json).

## Mini-player e troca rápida — R1 após v1.0.1

O incremento está no commit TV `09272944db0b039d4eac2ae102af9775fa0a937a` da branch remota `codex/live-tv-mini-player`, derivada do marco `v1.0.1`. O checkout local preserva o commit equivalente `fca368158`.

O player aberto pela rota Live TV agora aceita ↑/↓ durante reprodução com os controles ocultos e as teclas dedicadas Channel Up/Down. O seletor ocupa a lateral esquerda; a superfície de vídeo do mesmo `PlayerScreen` e do mesmo controlador é reduzida no canto superior direito e continua reproduzindo enquanto a lista recebe foco. Voltar ou Fechar restaura a tela cheia. O seletor compartilha o `LiveTvViewModel` que permanece na pilha de navegação, por isso mostra favoritos, Agora/A seguir e o fuso já escolhido sem carregar outra fonte.

Entram na lista somente canais que têm URL de stream não vazia. Selecionar outro canal registra o recente, encerra o controlador atual e troca a rota do player; o novo canal mantém o seletor aberto enquanto carrega. Selecionar o canal atual apenas fecha o seletor. Itens EPG sem URL continuam sem ação de reprodução, e nenhuma fonte/conteúdo é distribuído pelo app.

No checkout TV derivado do marco estável `v1.0.1`, passaram 9 testes JVM focados (`LiveTvQuickChannelPolicyTest` e `PlaybackProfileRouteTest`), `:app:assembleFullDebug` gerou os cinco APKs Full Debug e `:app:compileFullDebugAndroidTestKotlin` compilou os testes instrumentados. Em 25/10/2026, a revisão de QA localizou e corrigiu dois contrastes no seletor (título sobre painel escuro e textos de Agora/A seguir na linha focada). O commit TV publicado `2e31287521565d3e746767b9a5e7200f003e2773` preserva também dois consertos do cache EPG: falha ao substituir o destino no teste JVM Windows e limpeza de temporário quando a quota é excedida. A implementação Android continua usando `File.renameTo` no mesmo diretório; o teste de integração confirmou que a substituição ocorre no Android.

Validação no AVD `Telumia_TV_API30` (Android TV, x86, API 30, 1920×1080): `LiveTvGuideCacheTest` passou 4/4; `LiveTvGuideCacheAtomicReplaceTest` passou 1/1 com a implementação Android; `LiveTvVisualComponentsTest` passou 6/6, incluindo navegação/seleção por D-pad, Agora/A seguir, favoritos, guia sem ações falsas para XMLTV sem stream e ausência de conteúdo inventado. A captura revisada do seletor e os relatórios JUnit estão em [evidence/telumia-tv-live-tv-r1-api30-qa](evidence/telumia-tv-live-tv-r1-api30-qa); o APK universal Full Debug recompilado tem SHA-256 `2fb880fe9daa913f7f8de9bdfb1cb15746695d8ba91437fc723e76b9a8dfd2a7`. `:app:assembleFullDebug` concluiu com sucesso. O registro local com tamanhos e SHA-256 está em [telumia-tv-live-tv-mini-player-r1-local.json](telumia-tv-live-tv-mini-player-r1-local.json).

Este QA valida os componentes reais do seletor no emulador; não demonstra troca durante reprodução de uma fonte legítima configurada nem desempenho/decodificação em TV Box física. R1 continua em PR draft, sem release, e a Fase 6 permanece aberta até provar a integração ponta a ponta com M3U/XMLTV e stream autorizado, revisar o PR e validar em hardware representativo.
