# Roadmap e milestones verificáveis

**Identidade vigente: Telumia.** A solicitação de 05/10/2026 acrescenta marca/logo próprios, renomeação dos repositórios e foco no Brasil. [Implementação e limites](TELUMIA.md). Os registros anteriores preservam sua identidade histórica; o escopo completo aprovado continua válido.

Source of truth: APPROVED_SPEC.md + PRODUCT_REQUIREMENTS.md. Não há autorização
para trocar stack, login/backend, remover recursos ou publicar como oficial.

## Estado desta execução

Estado mais recente: a release combinada `v1.0.2-alpha.4` foi publicada em 25/10/2026 com cinco APKs TV/TV Box, o MSI Windows Desktop `1.0.2-alpha.1` (ProductVersion `2.0.1`), fontes, manifestos e checksums; os nove hashes foram conferidos contra os assets da [página de releases](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.2-alpha.4), e o workflow [40242583495](https://github.com/Pepeu2010/telumia/actions/runs/40242583495) passou. O Phone Remote R1 da Fase 8 foi integrado ao cliente Android TV: servidor LAN opt-in, QR/código temporário, aprovação explícita na TV e comandos ao player/navegação. O AVD Android TV API 30/1080p confirmou upgrade WebSocket, pedido na TV, aprovação por D-pad, estado `paired`, comando autenticado `back` e revogação ao desligar; navegador móvel, aparelhos separados e QA físico continuam pendentes ([registro sanitizado](PHONE_REMOTE_RUNTIME_QA_API30.json)). A release de PC é identificada separadamente; o workflow não recompila o Desktop quando só o cliente TV muda. [Detalhes e limitações do Phone Remote](PHONE_REMOTE.md), [Live TV](LIVE_TV.md), [timed metadata](TIMED_METADATA.md), [releases](RELEASES.md).

- Histórico da `v1.0.2-alpha.1`: foram preparados localmente um MSI Windows x64 e cinco APKs Android TV para Scene Info R1; essa versão não foi publicada no repositório principal. A sequência de versões combinadas foi retomada na `v1.0.2-alpha.2`, publicada em 25/10/2026. A preparação alpha.1 passou 24 testes Desktop e 5 TV; [detalhes](RELEASES.md).

- Fase 6 TV R2: se o WorkManager falha, a importação manual ainda carrega canais e guia e a tela informa que a atualização periódica está indisponível. Fixture HTTP local valida a junção M3U/XMLTV. Commit `25e741af4f00055b3b567df4cbfc0e82904315a2`; 32 testes JVM Live TV e 7 instrumentados API 30 passaram. A suíte completa teve 13 falhas, todas presentes no baseline registrado, e 1 teste ignorado. Playback com stream autorizado e QA de TV Box continuam abertos; [detalhes](LIVE_TV.md).

- Checkouts oficiais dos seis projetos concluídos e commits registrados.
- Auditoria estática e matriz de lacunas/contratos produzidas.
- Builds baseline Desktop e TV executados em fontes sem alterações. MSI e APKs
  gerados; suítes com 26/20 falhas herdadas, preservadas em BASELINE.md e JSONs.
- 0-A e 0-B concluídos com ressalvas; 0-C implementado, testado e compilado.
- Fundação: 31 testes direcionados Desktop e 84 TV aprovados; MSI/APKs do fork
  gerados. Código e commits independentes publicados no GitHub; detalhes e limites
  em FOUNDATION.md. Pré-release 0-C publicada com MSI, APK universal/quatro ABIs,
  fontes e hashes; registro em RELEASES.md.
- 1-A em execução: incremento 1-A.1 de movimento por perfil integrado a Aparência,
  tokens e navegação existentes; 22 testes Desktop e 19 TV aprovados, MSI/APKs
  compilados. QA do seletor Desktop e do APK instalado em emulador concluído,
  com seleção por D-pad, retorno de foco e persistência após reinício.
  Incremento distribuído na alpha.2; detalhes/limites em NATIVE_FOUNDATION.md.
  A identidade/shell completa e o QA global continuam pendentes; não se avançou
  para 1-B nem se declarou o redesign concluído.
- 1-A.2 estende motion ao shell, foco e skeletons existentes: 25 testes Desktop
  e 15 TV aprovados; MSI e cinco APKs compilados. D-pad e geração do QR passaram
  no APK novo em emulador. O provisionamento público foi corrigido. Código/evidência
  registrados, fora da alpha.2; motion global e identidade própria ainda pendentes.
- Nenhuma fase de produto é declarada concluída apenas pela auditoria.
- 1-A.3 acrescenta intensidade por perfil, com prioridade de Reduzido/Desligado:
  32 testes Desktop e 17 TV aprovados; MSI e cinco APKs compilados. Picker Desktop
  passou por mouse/teclado e o APK universal por D-pad/persistência após reiniciar
  o app em Android TV API 36. Incremento ainda fora da alpha.2; 1-A permanece aberto.
- Continuação Desktop do menu lateral padrão: 27 testes e MSI passaram, com
  captura/interação do componente real. Diagnósticos de login novos da TV foram
  protegidos: 36 testes e cinco APKs passaram; QR/markers no log verificados.
  A continuação da fila antiga passou em 37 testes e recompilou cinco APKs:
  sanitização no acesso ao arquivo e antes do upload. O restante de 1-A permanece
  pendente; estes incrementos estão fora da alpha.2.
- Marca nativa Desktop integrada ao wordmark e rodapé do menu existentes;
  selo de membro respeita a política de movimento. Passaram 30 testes e o MSI
  compilou; captura/interação do menu real verificadas. A continuação TV integra
  a mesma marca aos wordmarks/menus existentes e preserva estado, foco e ordem
  de Voltar ao trocar o estilo do menu. Passaram 38 testes e cinco APKs; D-pad,
  retorno às categorias/Home e persistência do estilo passaram no APK instalado
  em Android TV API 36. Demais superfícies e QA global continuam pendentes;
  1-A permanece aberto, fora da alpha.2.
- Continuação 1-A Desktop: um helper comum pausa loops visuais em telas inativas
  e modos Reduzido/Desligado. O indicador, o fluxo colorido de downloads e o
  pulso do overlay de abertura usam esse caminho; fades/progresso do overlay
  respeitam a duração por perfil. Os dois testes de movimento passaram com
  BroadcastFrameClock. Na suíte completa, uma primeira execução teve uma falha
  extra de seek nativo; o caso passou isoladamente e a repetição final teve
  1.621 testes, as mesmas 38 falhas da base e 5 ignorados. MSI gerado, +4 KiB
  versus base. Sem alterações TV: gate mais recente teve 2.052 testes, 13 falhas
  todas herdadas do conjunto de 20 e cinco APKs debug compilados. Não é QA físico
  de performance nem release; 1-A permanece aberto. Código no commit Desktop
  2bc945ce e no [PR #1](https://github.com/Pepeu2010/telumia-desktop/pull/1).
  [Detalhes e limites](NATIVE_FOUNDATION.md).
- Continuação 1-A: escala `MotionDurationScale` dos recomposers cobre animações
  Compose temporizadas ainda não mapeadas: Reduzido usa 0,5× da escala do
  sistema, Completo preserva a escala, Desligado usa zero. Testes direcionados
  passaram em ambos. Desktop: 1.622 testes/38 falhas, mesmos IDs da base, e MSI
  gerado. TV: 2.053 testes/14 falhas/1 ignorado; 13 IDs do baseline e a falha
  temporal restante reproduz na revisão base limpa; cinco APKs debug gerados.
  APK atual instalado e restaurado no AVD Android TV API 30/x86; navegação D-pad
  e processo passaram sem FATAL/ANR. Amostras PSS 208–213 MiB sem diferença
  conclusiva; abertura fria 9,2–10,5 s também lenta no baseline, precisa profiler.
  Artefatos não publicados. FPS sustentado, TV Box física e freezes continuam
  pendentes. Commits Desktop `63b4aa04` e TV `438e5f2f`; PRs Desktop #1 e TV #2.
  [Detalhes, tamanhos, hashes e limites](NATIVE_FOUNDATION.md).
- Continuação 1-A TV: leitura do consentimento Sentry saiu do caminho síncrono
  de `Application.onCreate`; testes direcionados e `assembleFullDebug` passaram.
  No mesmo AVD API 30/x86, três cold starts deram medianas de 3,972 s na base e
  3,986 s no candidato, sem ganho mensurável; as amostras PSS foram menores no
  candidato, mas ainda inconclusivas. O app ficou aberto sem FATAL/ANR. Este
  incremento não altera o Desktop, não fecha a validação PC/APK da Fase 1-A e
  não é release; hardware físico, jank/FPS e ausência de freeze sob carga seguem
  pendentes. Commit TV `34a4dcd5`, PR #2. [Evidências](NATIVE_FOUNDATION.md#continuação-1-a-tv-leitura-assíncrona-do-consentimento-sentry).

- Continuação 1-A Desktop: o aquecimento oculto do WebView2 foi adiado até abrir
  a superfície real do player; o carregamento da JNI no startup e o aquecimento
  WebKitGTK no Linux foram preservados. Em árvore de processos completa, a
  mediana do MSI passou de 594,1 para 323,1 MiB de working set agregado (-45,6%),
  de 573,2 para 464,5 MiB privados (-19,0%) e de 3,206 para 3,020 s até a
  primeira janela. WebView2 em repouso caiu de seis processos para zero. Testes
  nativos direcionados, bridge e MSI passaram. Há um outlier isolado de startup
  de 6,915 s; primeira abertura do player, carga contínua e interação real ainda
  não foram medidas. Nenhuma alteração APK nesta entrega; gate PC/APK e 1-A
  continuam abertos. Commit Desktop `9c5d9f58`, PR #1.
  [Medição, artefato, testes e limites](NATIVE_FOUNDATION.md#otimização-desktop-adiar-webview2-no-windows).
- Home: incremento nativo validado com 44 testes Desktop, 72 TV e 27 testes de componentes no emulador. [Entrega parcial](TELUMIA_HOME.md).
- 2-A: timeline temporal, providers limitados e adapter dos skips integrados aos players; 93 testes Desktop, 83 TV e nove testes nativos TV aprovados. Capítulos embutidos foram ligados à timeline Desktop/libmpv e TV/Media3 em incrementos posteriores. A entrega inicial de Scene Info R1 veio depois, sobre essa base; bookmarks têm incrementos próprios. [Fundação e Scene Info R1](TIMED_METADATA.md), [capítulos](EMBEDDED_CHAPTERS.md).
- 2-C parcial: Momentos salvos implementados na TV, com armazenamento durável e confirmação de fonte/corte. Passaram 153 testes selecionados, cinco APKs e 16 execuções nativas do painel em APIs 24/36 e 720p/1080p/4K. Desktop e validação completa no player continuam em execução; nenhuma nova release de bookmarks foi publicada. [Evidências e limites](SCENE_BOOKMARKS.md).
- 1-C: editores de avatar locais nos clientes reais, biblioteca com 64 ilustrações licenciadas, recorte/zoom, quatro variantes PNG e persistência isolada por conta/perfil. A seleção adaptativa tem gates posteriores de 155 testes/MSI no PC e 111 testes/cinco APKs na TV, mais 15 testes nativos TV e dez capturas finais revisadas. Configurações de apresentação/player, clonagem seletiva e tipos de perfil continuam pendentes. [Entregas e escopo da QA](PROFILE_STUDIO.md).
- Continuação 1-D/identidade: ocupação dos diretórios de cache conhecidos, preservação de schemas futuros, reserva real de espaço livre e pesos nativos da fonte. Passaram 168 testes selecionados/MSI Desktop e 120/cinco APKs TV, com 16 testes nativos de cache/fonte em APIs 24/36 e nova revisão dos seletores nas resoluções previstas. Os pacotes foram preservados por commit e permanecem posteriores à release 0.2.1-alpha.1. Cache global/offline, todas as superfícies e a meta integral seguem abertos. [Cache](MEDIA_CACHE.md), [tipografia](TYPOGRAPHY.md).
- Perfil de baixo consumo TV Box: política automática por RAM/heap para imagens, pré-carga, blur e movimento; em baixa RAM, imagens limitadas a 4 requisições simultâneas (2 por host), uma decodificação, sem prefetch, motion reduzido, carregamento/shimmer estáticos e sidebar sem blur em tempo real. O seek mantém só thumbnail central, cache de frames por tier e extrações em 300/180/120 ms; a Home Moderna desativa trabalho antecipado em baixa RAM. Os runs `39350246174` e `39351383602` passaram nos testes selecionados, compilaram a instrumentação e publicaram APKs universal, ARM64 e ARMv7. A variante ARM64 reduz o pacote em cerca de 48,7% frente ao universal. FPS, heap e latência reais ainda não foram medidos, pois nenhum aparelho estava conectado ao ADB. [Detalhes, evidência e limites](TV_PERFORMANCE.md), [seek adaptativo](TV_TIMELINE_SEEK.md#perfil-de-seek-adaptado-à-memória), [Home](TELUMIA_HOME.md), [pacotes por ABI](telumia-tv-abi-artifacts-r1-ci.json), [APK r6](telumia-tv-low-resource-r6-ci.json).
- Fase 6 na TV: modelos/parsers M3U/XMLTV (`289d81f`), fontes HTTP(S) isoladas por perfil/importação limitada (`e04c6b8d8`), rota `LiveTvScreen` com Agora/A seguir e player existente (`756592bae`), cache EPG offline (`7c3aa199a`), grade temporal (`ce23c9f88`), modos Agora/Guia/Canais/Favoritos/Recentes por perfil (`8d0bbdcc0`), atualização periódica resiliente no WorkManager (`47e432345`), fuso selecionável (`e8d8308cf`) e mini-player R1 para seleção rápida no player. ↑/↓ abrem o seletor; o vídeo continua no mesmo player enquanto a pessoa navega; só canais com stream configurado aparecem. A QA visual/D-pad do componente passou em AVD Android TV API 30 1080p: 6 testes de componentes, mais 4 testes JVM e 1 teste instrumentado do cache; Full Debug foi recompilado. O commit `2e31287521565d3e746767b9a5e7200f003e2773` está publicado na branch do PR draft. Falta validar reprodução e troca com fonte autorizada ponta a ponta, testar hardware real e concluir a revisão antes de release. A Fase 6 segue aberta. [Escopo, limites e APKs](LIVE_TV.md), [evidências API 30](evidence/telumia-tv-live-tv-r1-api30-qa), [registro r10](telumia-tv-live-tv-r10-ci.json), [registro local R1](telumia-tv-live-tv-mini-player-r1-local.json).
- Source Intelligence inicial: ranking por metadados declarados e modos configuráveis integrado aos seletores existentes da TV e do Desktop. A alpha.3 adiciona inventário de decoder Android; alpha.4 considera HDR declarado pela mídia e pela tela, sem alegar sucesso do bitstream real. O CI `39521569001` passou testes focados, compilou instrumentação e gerou APKs; alpha.4 foi publicada com MSI `1.0.0` e checksums conferidos. O publisher recebeu HTTP 403 ao criar a release, que foi publicada via CLI autenticado. No Desktop, o run Windows `39487966669` verificou os relatórios das duas classes de seleção/persistência e compilou `desktopTest`; o MSI correspondente não foi construído porque faltam os valores privados de release no GitHub, e o guard local bloqueou o build abaixo da reserva de espaço. O gate `39491977354` passou testes e empacotamento nativo para Linux x64 e macOS x64/ARM64. Pre-flight, medições reais de disponibilidade/estabilidade, failover, QA visual/nativa e integração demonstrada pelo fluxo real de reprodução continuam pendentes. [Estado e evidências](SOURCE_INTELLIGENCE.md).

## Gates e entregas

- Fase 7 R1 na TV e no Desktop: capítulos embutidos confiáveis agora aparecem em um painel Scene Info condicionado ao ponto da timeline e à edição em reprodução. A TV recompilou Full Debug, passou 21 testes unitários e 1 teste instrumentado de foco/fechamento D-pad no AVD API 30; Desktop passou 43 testes de metadata, `compileKotlinDesktop` e `desktopJar`. O commit Desktop `4df39a52b1c6d612e3adc6530361045c40f3dd27` está no fork; TV `d116375d5a76141b9bb9e748486db411f3ec2d0d` foi publicada na branch `codex/live-tv-mini-player`. O MSI Windows não foi produzido nesta rodada por ausência do toolchain/SDK nativo exigido no ambiente. Atores, música e curiosidades permanecem indisponíveis sem provider temporal licenciado/confiável; reprodução ponta a ponta com arquivos reais e hardware TV continuam como gates. A Fase 7 R1 entrega a base confiável e permanece aberta para esses providers e validações. [Detalhes e limites](TIMED_METADATA.md), [evidências Desktop](evidence/telumia-scene-info-desktop-r1), [evidências TV](evidence/telumia-scene-info-tv-r1), [registro R1](telumia-scene-info-r1-local.json).

- Continuação 2-A depois da alpha 0.2.2: capítulos embutidos lidos do libmpv e projetados no índice temporal/marcadores existentes, com posições/títulos reais, limites e ausência de confiança inventada. **279 testes selecionados/MSI, seis casos JNI e oito execuções/1084 verificações do renderer passaram nesse incremento.** O código Desktop está incluído na release 1.0.0. O incremento TV posterior integrou `ChapterFrame` à timeline, aos marcadores e ao seletor D-pad com seek; quatro testes dedicados e o build `fullDebug` passaram no CI (`00734dde`). QA físico permanece pendente; Scene Info recebeu sua primeira integração confiável R1 conforme [registro](TIMED_METADATA.md). [Evidências e limites](EMBEDDED_CHAPTERS.md).

- Continuação 3: ownership/cancelamento/timeout dos cards Desktop e consultas TV, pool Media3 exclusivo, preload conservador e movimento por perfil. 174 testes/MSI Desktop, 137 testes/cinco APKs TV e oito testes nativos de áudio local/ownership em APIs 24/36. O Windows agora tem uma superfície inline libmpv em código e reprodução local validada pelo controlador nativo; trailer remoto integrado ao card, QA visual e performance física continuam pendentes. [Previews](PREVIEWS.md).
- Continuação Desktop Windows: `HeroTrailerPlayerSurface` inline passa a usar o host e o libmpv já existentes, omitindo WebView2 de controles, iniciando pausado e silenciando antes do play; falha de carregamento expira em 12 s e streams com áudio separado não são apresentados como previews sonoros. O controlador nativo carregou um AVI local de seis segundos num peer HWND; um `ComposePanel` real compôs `WindowsHeroTrailerPlayerSurface`, recebeu readiness após o paint integral do host e confirmou o callback de término. **32 testes de lifecycle, frames e superfície Compose passaram**, junto a `buildWindowsPlayerBridge`, `compileKotlinDesktop` e `desktopJar`. Integração no fluxo pai de hero/hover, inspeção visual do frame no card, trailers remotos/resolvidos, MSI desta revisão e publicação APK+PC permanecem pendentes. [Previews](PREVIEWS.md).
- Prioridade de 08/10/2026: mesma conta Nuvio, atualização bidirecional, mesclagem e navegação fluida. Primeiro incremento compilado: 208 testes/MSI PC, 162 testes/cinco APKs TV, 12 execuções nativas do menu nos três modos de movimento e APIs 24/36. Reconciliação durável de coleções: 225 testes/MSI PC e 176 testes/cinco APKs TV passaram; journal, recuperação offline, alterações durante upload e exclusões confirmadas. Addons e conta real ainda precisam de entrega/prova. Depois desses incrementos, a meta integral segue aberta. [Conta e navegação](ACCOUNT_SYNC_MOTION.md).
- Continuação de conta no PC: journal de addons integrado aos mutators e ao pull/push existentes, preservação de nomes/configuração, merge de remoções/ordem/ativação e alterações durante upload. Falhas da biblioteca chegam ao coordenador; providers mantêm cooldowns. 240 testes selecionados e MSI passaram com APPDATA isolado. A implementação correspondente de addons TV e a conta real permanecem pendentes; nenhuma nova release foi publicada nesta rodada. [Evidências](ACCOUNT_SYNC_MOTION.md).
- Continuação de conta na TV: journal de addons integrado ao DataStore e RPC existentes, revisão atômica para os consumidores de manifests, alterações pendentes protegidas por conta/perfil/backend e herança somente leitura. **193 testes selecionados, cinco APKs e APK de instrumentação passaram**; a MainActivity real passou no gate de inicialização API 24. Falhas/interrupções anteriores foram preservadas. A comprovação autenticada entre cliente oficial e fork permanece pendente. [Evidências e limites](ACCOUNT_SYNC_MOTION.md).
- Player Desktop: a política visual local chega à ponte e aos controles nativos; Completo/Reduzido/Desligado e intensidades, sem encurtar tempos de leitura. **241 testes selecionados/MSI e oito execuções Chromium com 72 pares de modo/intensidade passaram**, preservando falhas anteriores. A integração JNI/WebView2 e reprodução continuam como gates separados. [Validação](NATIVE_PLAYER_MOTION.md).

- Momentos salvos Desktop: painel integrado aos controles existentes, persistência por proprietário/episódio/fonte, confirmação de outra fonte e estados de erro/retentativa. **257 testes selecionados/MSI e oito execuções Chromium com 828 verificações passaram**. As tentativas anteriores ficaram preservadas. Janela modal junto ao vídeo, foco WebView2 e seek real continuam como gates próprios; a meta integral segue aberta. [Entrega](SCENE_BOOKMARKS.md).
- Thumbnails e filmstrip: Desktop usa worker JNI libmpv isolado, cache configurável por owner/fonte e scrubbing com frames vizinhos; 267 testes selecionados e MSI passaram, mais renderer em oito execuções/980 verificações. TV integra extração Media3 e seek D-pad, com 222 testes, nove casos nativos nas APIs 24/36 e QA visual em 720p/1080p/4K; o perfil de memória agora reduz extrações extras em baixa RAM. Interação WebView2 completa Desktop, provedores externos/HDR, execução Linux/macOS e medição física TV continuam pendentes. [Desktop](NATIVE_TIMELINE_FRAMES.md), [TV](TV_TIMELINE_SEEK.md).

- Composição do player Desktop: masthead superior e dock de reprodução limitado, sem substituir o engine; 267 testes/MSI e oito execuções Chromium com 1044 verificações passaram. Carregamento, erro, recuperação e PiP verificados; redesign integral continua aberto. [Entrega e limites](PLAYER_DESKTOP_SURFACE.md).

| Milestone | Entrega concreta | Gate |
|---|---|---|
| 0-A | Checkouts, source lock, inventário real, cinco documentos | Todos os commits identificados; ausência de edits de aplicação no baseline |
| 0-B | Tests/build MSI Desktop e APK TV baseline | Exit codes, logs, outputs e alterações registrados; falhas classificadas |
| 0-C | Primeira fundação: identidade, paths, updater, redaction e regressão de contratos | Testes direcionados + builds; nenhuma alteração em conta/sync/engine |
| 1-A | Tokens/motion e shell nativo próprio por plataforma | Sem rotas perdidas; Reduced Motion/off; QA teclado/D-pad |
| 1-B | Home e detalhes preservando repositories/actions | Loading/empty/error e navegação real; lazy rendering |
| 1-C | Profile Studio/import/crop + biblioteca original/licenciada | Validação de arquivos; isolamento e alcance local explícito |
| 1-D | Image/cache foundation Auto e configurável; tokens/componentes EPG/Live TV | Quotas, eviction e storage reserve testados; nenhuma rota falsa de TV exposta |
| 2-A | Timed metadata genérica integrada a player/timeline | Intervalos/eventos e proveniência; adapters de chapter/skip/bookmark |
| 2-B | Player UI, thumbnails e filmstrip básico | Superfície JNI/WebView2 Windows e Media3 TV realmente testadas; timestamps corretos |
| 2-C | Bookmarks, áudio/subtitles/chapters/stats/transições | Persistência por profile/media; valores técnicos não inventados |
| 3 | PreviewCoordinator, hero, Ambient UI e transições | Um preview, silêncio default, lifecycle e cancelamento; perf budget |
| 4 | DeviceCapabilities, scoring/pre-flight/modos | Unknown explícito, parcelas do score testadas, escolha manual mantida |
| 5 | Completar TV UX e performance adaptativa | D-pad integral, retorno de foco, hardware 2 GB e QA 720p/1080p/4K |
| MVP 1 | Todos os requisitos obrigatórios do primeiro release | Login/sync/playback reais e builds; nenhum requisito obrigatório omitido |
| 6 | Live TV, source integration, channel model, EPG, favoritos/recents/troca rápida | Fonte legítima configurada; timezone/cache/foco do grid testados |
| 7 | Scene Info via providers confiáveis sobre timed metadata da Fase 2 | Proveniência/confiança; ausência não vira identidade inferida |
| 8 | Phone Remote local, QR/pairing/WS/teclado/controles | Confirmação, expiração/revogação, Origin, limites e sem exposição WAN default |
| MVP 2 | Live TV/EPG, failover avançado, remote, Smart Collections, downloads/Spoiler Shield | Integrações reais e limites das fontes documentados |
| MVP 3 | Advanced filmstrip, Scene Info, análise local, timeshift/multi-view/recomendações | Experimental flags e orçamento de decoders/disco; dados licenciados |

## Implementação incremental

### Progresso — Fase 1-D, cache de metadata na TV (27 de outubro de 2026)

- O cache de avaliações MDBList da TV passou a respeitar a quota `METADATA`, com TTL e limites de disco/memória, migração do arquivo legado e leitura preservada em política somente leitura. Implementação na branch `codex/1d-tv-mdblist-cache-quota`, commit `dc92702ef6977ff9b210a05a8c7244bec622a8c9`; [PR #4](https://github.com/Pepeu2010/telumia-tv/pull/4), vinculado à aprovação [telumia#10](https://github.com/Pepeu2010/telumia/issues/10).
- Passaram 16 testes focados de TV; o Desktop sem mudanças de fonte passou 12 testes focados e compilou JAR/MSI. Foram gerados cinco APKs Full Debug, identificados como `.debug`, apenas para validação. Não são atualizações de produção e não foram publicados.
- Incremento parcial. Fase 1-D permanece aberta para os consumidores restantes, adaptação dinâmica, fluxos offline e QA em hardware real. O build de ambos os clientes não comprova desempenho físico; nenhum aparelho foi medido neste recorte.

### Progresso — Fase 1-D, caches de metadata TMDB em RAM na TV (27 de outubro de 2026)

- As sete caches de respostas do `TmdbMetadataService` agora usam LRU com limite por tier de memória do dispositivo. `UNKNOWN` usa o limite conservador. Os itens em voo seguem separados e continuam coalescendo requests. Issue [telumia#11](https://github.com/Pepeu2010/telumia/issues/11), commit `8c1ba9fd07fc5e3ec395fbe024607957b47164fa`, [PR #5](https://github.com/Pepeu2010/telumia-tv/pull/5).
- Passaram 31 testes direcionados e os cinco APKs Full Debug foram compilados. O `applicationId` `.debug` identifica pacotes de validação, não atualizadores de produção. A suíte total fez 2.058 testes: 13 falhas e 1 skip; as mesmas 13 falhas foram reproduzidas em dez classes no commit-base `e1e7d992`.
- O gate Desktop sem mudança de fonte retornou sucesso, com tarefas de teste e MSI marcadas `UP-TO-DATE`. Não houve medição de heap, jank, CPU ou latência em hardware físico.
- Incremento parcial: os tetos são quantidade de entradas, não orçamento exato de bytes; a Fase 1-D ainda requer os consumidores restantes e adaptação dinâmica.

Cada milestone: inspecionar call sites → registrar impacto → implementar →
testar → compilar → corrigir regressões → QA → documentar → commit.
PRs serão feitos no fork quando houver remoto próprio; não enviar redesign ao
upstream. Branches locais seguem `codex/`. O usuário autorizou criar e publicar
os repositórios GitHub em 2026-10-04; releases instaláveis terão gates próprios.
Toda release instalável da Telumia deve apresentar no mesmo release os pacotes
Android APK e Windows PC MSI. O workflow de publicação valida que ambos estão
presentes e enviados; se faltar qualquer um, a release não passa pela verificação.
Cada milestone também deve revisar desempenho nos dois clientes, PC e APK,
comparando os caminhos afetados com a referência anterior e corrigindo regressões
antes de concluir a fase. Fluidez não fica acumulada para uma otimização final.

A Fase 2 fornece `TimedMetadata` genérica com media/episode identity, intervalo
ou instante, tipo, origem e dados do item; providers Scene Info entram depois.
Não acoplar playback a IMDb ou a um serviço de reconhecimento.

Cache Auto considera espaço livre, capacidade de memória/decoder e uso atual;
1 GiB/256 MiB são defaults ajustáveis, não constantes definitivas. Override do
usuário é validado contra condições operacionais e não apaga downloads.

Fase 1 prepara estilo/foco de channel tile, now-next, progress e program cell;
somente storybook/previews/testes internos até haver implementação real na Fase 6.

## Evidência e critérios

Baseline limpo não é aceitação de produto. Usar fixtures de protocolo locais,
fontes autorizadas e medições separadas. Visual QA: Desktop 1366x768, 1080p,
1440p e 4K; TV 720p, 1080p e 4K, texto grande/overscan/foco.
Meta de navegação 60 FPS e foco p95 abaixo de 100 ms; medir aparelho/contexto.
Para cada milestone, registrar antes/depois nos dois clientes com métricas
pertinentes ao caminho alterado: tempo de início/carregamento, resposta e
cadência da interface, jank, CPU, memória, crash/ANR e tamanho dos pacotes; no
player, acrescentar latência de seek e frames perdidos. Crash, ANR ou freeze
reproduzível introduzido pelo incremento precisa ser corrigido antes de concluir
a fase. Comparar o mesmo cenário e condições. PC e APK mantêm baselines separados.
Para Android, incluir a referência
de TV Box com 2 GiB / 1080p sempre que houver dispositivo disponível; no Windows,
registrar o hardware usado. Build, testes unitários ou emulador não demonstram
fluidez numa TV Box/PC físico. Quando não houver hardware disponível, documentar
a lacuna e limitar a conclusão à evidência obtida, sem chamar desempenho físico
de comprovado. Evitar trabalho sem limite, decodificações/preloads concorrentes
desnecessários e tarefas antigas que continuam após navegação; adaptar cache,
previews, imagens e motion às capacidades do aparelho.

Funções secundárias do documento original — busca Ctrl+K, histórico visual,
Escolha para mim, Guest/Kids, webcam/animated avatars, Cinema/Living Room/Ambient
Mode — recebem incrementos próprios, preservando seu comportamento/capability.
Nunca anunciá-las como prontas antes de implementação/QA.

### Progresso — Fase 1-D, quotas HTTP na TV e no Desktop (27 de outubro de 2026)

- Os caches HTTP fixos da TV agora usam `HTTP` e `ADDONS`; o cache de metadata MDBList conserva sua quota própria. O cache de GETs de addons foi integrado ao Desktop e recebe a mesma quota central. Todas as shares somam 100% e seus limites efetivos continuam subordinados ao modo Auto/Manual, à memória e ao armazenamento.
- O modo somente leitura conserva hits existentes e marca respostas de rede como `no-store`; erros 4xx/5xx não são armazenados. A ocupação considera diretórios allowlisted; o antigo `http_cache` da TV entra apenas como tamanho, sem abrir ou migrar suas respostas permissivas.
- Passaram 17 testes focados TV e 9 Desktop. Foram compilados cinco APKs Full Debug, JAR e MSI. Os APKs têm ID `.debug`; nenhum é instalador de atualização da versão de produção. Não houve medição em hardware físico. Evidência completa e hashes em [MEDIA_CACHE.md](MEDIA_CACHE.md#quotas-de-cache-http-na-tv-e-no-desktop--27-de-outubro) e [registro](telumia-cache-http-tv-desktop-r3-build.json).
- PRs sequenciais: TV [#6](https://github.com/Pepeu2010/telumia-tv/pull/6) sobre TV [#4](https://github.com/Pepeu2010/telumia-tv/pull/4); Desktop [#2](https://github.com/Pepeu2010/telumia-desktop/pull/2) sobre Desktop [#1](https://github.com/Pepeu2010/telumia-desktop/pull/1). A solicitação está em [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). As branches continuam abertas e Fase 1-D não está concluída.

### Continuação — reavaliação Auto durante a sessão (27 de outubro de 2026)

- TV e Desktop agora reamostram o orçamento quando consultado, no máximo a cada 15 segundos. A gravação HTTP pausa se a quota cair abaixo da alocação da instância aberta; os hits existentes permanecem disponíveis. Os caches de arquivo que consultam a quota por gravação recebem o valor reavaliado.
- Passaram 10 testes direcionados por cliente. Foram compilados cinco APKs Full Debug, JAR e MSI Windows x64. APKs `.debug`; não publicados, sem QA em hardware físico. OkHttp fixa o máximo no construtor: quedas pausam gravações sem aparar entradas existentes e aumentos só entram no limite de uma instância reaberta; o loader Coil também não é redimensionado em execução. [Detalhes e evidências](MEDIA_CACHE.md#reavaliação-automática-do-orçamento-durante-a-sessão--27-de-outubro) e [registro](telumia-cache-dynamic-budget-tv-desktop-r1-build.json).
- PRs sequenciais: TV [#7](https://github.com/Pepeu2010/telumia-tv/pull/7) sobre [#6](https://github.com/Pepeu2010/telumia-tv/pull/6); Desktop [#3](https://github.com/Pepeu2010/telumia-desktop/pull/3) sobre [#2](https://github.com/Pepeu2010/telumia-desktop/pull/2). Fase 1-D continua aberta para os demais consumidores, validação offline e QA físico.

### Continuação — cache de avatares remotos de membros na TV (27 de outubro de 2026)

- `member_profile_avatars` agora é contado na ocupação, usa a quota `AVATARS` e tem limite de 2 MiB por imagem, 256 arquivos, gravação atômica e eviction LRU. Hits existentes seguem legíveis sem escrita; imagens de perfil locais e duráveis permanecem fora do cache. Downloads concorrentes são limitados a dois.
- Passaram 24 testes direcionados de TV e 10 testes Desktop; cinco APKs Debug Full, `desktopJar` e MSI foram compilados. Os pacotes não foram publicados; APKs `.debug` não atualizam produção. Não houve QA físico. A API Supabase atual materializa a resposta em `ByteArray`; arquivos acima de 2 MiB são descartados antes da gravação, depois dessa alocação.
- TV: commit `d0b31840b012b8af6ff1de4c987f738b2b198907`, [PR #8](https://github.com/Pepeu2010/telumia-tv/pull/8) sobre [#7](https://github.com/Pepeu2010/telumia-tv/pull/7); aprovação acompanhada em [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Evidência e checksums em [MEDIA_CACHE.md](MEDIA_CACHE.md#cache-de-avatares-remotos-de-membros-na-tv--27-de-outubro) e [registro](telumia-cache-avatar-tv-r1-build.json).
- A Fase 1-D permanece aberta para os demais consumidores, fluxos offline e QA em PC/TV Box físicos.

### Continuação — cache remoto de avatar no Desktop (27 de outubro de 2026)

- O Desktop integrou avatares remotos de membros à quota `AVATARS`, com hash no nome do arquivo, 2 MiB por item, até 256 arquivos, LRU, reserva de armazenamento e leitura offline. Os arquivos antigos são migrados somente após validação; fundos legados agora são contados, mas ainda não limitados. Downloads autenticados simultâneos limitados a dois.
- Passaram 15 testes Desktop e `desktopJar`/MSI. A compilação do alvo Android opcional deste repositório falhou em APIs de ponteiro de três arquivos não alterados; o build Full Debug e os 24 testes do cliente TV em seu repositório dedicado passaram. Nenhum pacote foi publicado nem houve QA físico.
- Desktop: commit `6abb8401f20ebd6db50e9268310f7ab81d87fc31`, [PR #4](https://github.com/Pepeu2010/telumia-desktop/pull/4) sobre [#3](https://github.com/Pepeu2010/telumia-desktop/pull/3), vinculado a [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). MSI, testes e hashes de APK estão no [registro](telumia-cache-avatar-desktop-r1-build.json).
- Fase 1-D continua aberta para os demais consumidores de cache, fluxos offline e QA em PC/TV Box físicos.

### Continuação — cache remoto de fundos de perfil (27 de outubro de 2026)

- Os dois clientes agora alocam uma quota de 10% da categoria `IMAGES` para fundos remotos; TV reserva os outros 90% para Coil, e Desktop divide o restante entre Coil (80%) e GIFs (10%). Cada cache tem 8 MiB por arquivo, até 64 arquivos, LRU, gravação atômica, reserva livre de armazenamento e leitura offline/migração validada dos caminhos legados.
- Passaram 26 testes focados de TV e 24 Desktop, sem falhas/erros/skips. Cinco APKs Full Debug, `desktopJar` e MSI passaram. O MSI Windows x64 tem 210.919.528 bytes; checksums de todos os artefatos estão nos registros ligados em [MEDIA_CACHE.md](MEDIA_CACHE.md#cache-remoto-de-fundos-de-perfil--27-de-outubro).
- API Supabase ainda devolve `ByteArray`; o limite de tamanho é aplicado depois da alocação em memória. O Desktop mantém bytes no estado do catálogo durante a sessão, por isso o orçamento em disco ainda não limita o total de memória retido por esses fundos. Nenhum pacote foi publicado, APKs `.debug` não atualizam produção e não houve QA físico.
- TV: commit `42d66acd2f38906b3cf5a736b4d4b0dfbc3a5787`, [PR #9](https://github.com/Pepeu2010/telumia-tv/pull/9) sobre [#8](https://github.com/Pepeu2010/telumia-tv/pull/8). Desktop: commit `e7ff92e6242b8c98ceea2df671cb54ecc5b7997d`, [PR #5](https://github.com/Pepeu2010/telumia-desktop/pull/5) sobre [#4](https://github.com/Pepeu2010/telumia-desktop/pull/4); ambos vinculados a [telumia#12](https://github.com/Pepeu2010/telumia/issues/12).
- Fase 1-D segue aberta para os demais consumidores de cache, validação offline e QA físico de PC/TV Box.

### Continuação — limite de memória dos fundos de perfil no Desktop (27 de outubro de 2026)

- O catálogo passou a usar URIs locais em vez de guardar cópias dos fundos em `ByteArray`. Pré-carrega apenas arquivos locais existentes; baixa imagens quando a pessoa abre um perfil ou escolhe um fundo. Se o disco não puder gravar, um LRU limita os bytes retidos a 8 MiB com RAM baixa/desconhecida, 24 MiB até 4 GiB e 48 MiB acima de 4 GiB.
- Passaram 20 testes focados, sem falhas/erros/skips; `desktopJar` e MSI Windows x64 compilaram. MSI: 210.923.624 bytes; SHA-256 `B9720A6E0C1F0B543341AC4A1A4022B2D0547432525E2BD6E57EE56E03A44D80`. O build Android opcional falhou nos erros preexistentes de ponteiro fora do diff, sem gerar APK; iOS não pode ser compilado em Windows. Nenhum pacote foi publicado nem houve QA físico.
- Desktop: commit `9c195c96fc401eea7691f86ff6e9a4d9cdcad541`, [PR #6](https://github.com/Pepeu2010/telumia-desktop/pull/6) sobre [#5](https://github.com/Pepeu2010/telumia-desktop/pull/5), ligado a [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Detalhes no [registro de build](telumia-profile-background-memory-desktop-r1-build.json).
- Fase 1-D permanece aberta para os outros consumidores de cache, validação offline e QA físico em PC/TV Box.

### Continuação — quota do cache de legendas na TV e política Desktop (27 de outubro de 2026)

- A TV integra o cache local de legendas externas e sidecars normalizados do MPV a `SUBTITLES`: 2% da alocação configurável, 4 MiB por resposta/arquivo e até 64 itens, com leitura de rede limitada, quota agregada e gravação atômica. `IMAGES` passa de 40% para 38%, mantendo as shares em 100%. Quando não pode guardar a cópia local, a seleção conserva fallback pela URL original. O Desktop recebe a mesma política central; não há consumer runtime de arquivo de legenda nessa plataforma.
- TV: 13 testes unitários, `assembleFullDebug` e teste instrumentado em AVD Android TV API 33 e dispositivo conectado passaram. Foram gerados cinco APKs `1.0.2-alpha.3`, application ID `.debug`. Desktop: 9 testes da política, `desktopJar` e MSI Windows x64 passaram. Nenhuma medição física de memória/jank foi realizada; APKs/MSI são builds de validação, não foram publicados e os APKs não atualizam instalações de produção.
- PRs draft sequenciais: TV [#10](https://github.com/Pepeu2010/telumia-tv/pull/10) sobre [#9](https://github.com/Pepeu2010/telumia-tv/pull/9); Desktop [#7](https://github.com/Pepeu2010/telumia-desktop/pull/7) sobre [#6](https://github.com/Pepeu2010/telumia-desktop/pull/6). Ambos ligados a [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comandos, cinco hashes APK, hash MSI e limitações em [registro de build](telumia-cache-subtitles-tv-desktop-r1-build.json) e [MEDIA_CACHE.md](MEDIA_CACHE.md#cache-de-legendas-por-aparelho--27-de-outubro).
- Não encerra a Fase 1-D. PREVIEWS, integração da quota `SCENE_INFO`, contabilização global de legado, fluxos offline e QA físico continuam pendentes.

### Continuação — cache de artes em previews (27 de outubro de 2026)

- TV e Desktop direcionam artes e logos exibidos somente em preview para a quota `PREVIEWS` (10% inicial, configurável), em diretório Coil separado. O cache normal de pôsteres segue em `IMAGES`; o cálculo Auto da TV mede também a pasta de previews.
- TV: 20 testes unitários passaram e cinco APKs Full Debug foram gerados; instrumentação no AVD Android TV API 33 registra 1/1 aprovado no XML, embora o coletor Gradle tenha travado após o término do caso. Desktop: 10 testes de política passaram, além de `desktopJar` e MSI Windows x64. Sem release ou QA físico.
- TV: commit `fdf69cead6809c825d5f2c3953cf3e0db280355c`, [PR draft #11](https://github.com/Pepeu2010/telumia-tv/pull/11) sobre [#10](https://github.com/Pepeu2010/telumia-tv/pull/10). Desktop: commit `ed13fa8722dab1728442a8778478d68cce872ae2`, [PR draft #8](https://github.com/Pepeu2010/telumia-desktop/pull/8) sobre [#7](https://github.com/Pepeu2010/telumia-desktop/pull/7). Ambos vinculados a [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Detalhes e checksums no [registro de build](telumia-cache-previews-tv-desktop-r1-build.json) e em [MEDIA_CACHE.md](MEDIA_CACHE.md#cache-de-artes-em-previews--27-de-outubro).
- PREVIEWS foi integrado; Fase 1-D continua aberta para `SCENE_INFO`, legado global, fluxos offline e QA físico em PC/TV Box.

### Continuação — migração resiliente de metadata legada na TV (27 de outubro de 2026)

- O arquivo legado de avaliações MDBList permanece no armazenamento persistente até a gravação atômica do cache limitado ser confirmada. A leitura também usa o legado intacto quando a versão em cache está parcial/corrompida; modo somente leitura ou quota pequena não apagam a única cópia. Auto mede a allowlist `filesDir/mdblist_cache`, sem incluir DataStore/outros dados duráveis.
- Passaram 29 testes unitários focados (MDBList 8, ocupação 11, política 10); `:app:assembleFullDebug` compilou os cinco APKs. O gate cruzado de Desktop sem alteração de fonte retornou sucesso. APKs `.debug`; não são atualizações instaláveis. Sem novo teste instrumentado nem QA físico.
- TV: commit `707a3912482900464557b534b19454644838379d`, [PR draft #12](https://github.com/Pepeu2010/telumia-tv/pull/12) sobre [#11](https://github.com/Pepeu2010/telumia-tv/pull/11). Evidências e hashes em [MEDIA_CACHE.md](MEDIA_CACHE.md#migração-resiliente-do-cache-legado-mdblist-na-tv--27-de-outubro) e [registro](telumia-cache-metadata-legacy-tv-r1-build.json).
- Não encerra a Fase 1-D. Seguem pendentes a auditoria dos outros caminhos legados, uma quota `SCENE_INFO` quando existir consumidor real, fluxos offline reais e QA em PC/TV Box físicos.

### Continuação — ocupação Auto dos snapshots Continue assistindo na TV (27 de outubro de 2026)

- `filesDir/cw_enrichment` agora entra na medição do orçamento Auto porque guarda snapshots de home regeneráveis por perfil. O scan continua read-only e limitado à allowlist; DataStore e `scene-bookmarks-v1` seguem explicitamente fora. Nenhum arquivo foi movido ou apagado.
- O teste novo reproduziu primeiro a diferença (17 bytes ignorados). Depois da correção passaram 29 testes focados e os cinco APKs Full Debug foram compilados. Gate Desktop sem mudança de fonte passou (JAR/MSI/testes selecionados; 3 tarefas executadas, 26 up-to-date). Sem QA físico; APKs `.debug` não atualizam instalação de produção.
- TV: commit `e42eb3283e1e856b159dd9cdfe7df5bef412e085`, [PR draft #13](https://github.com/Pepeu2010/telumia-tv/pull/13) sobre [#12](https://github.com/Pepeu2010/telumia-tv/pull/12). Evidências em [MEDIA_CACHE.md](MEDIA_CACHE.md#ocupação-auto-do-snapshot-continue-assistindo-na-tv--27-de-outubro) e [registro](telumia-cache-continue-watching-occupancy-tv-r1-build.json).
- Parcial: Fase 1-D ainda precisa da auditoria dos outros caminhos legados, de fluxos offline reais e de QA físico; a categoria `SCENE_INFO` só será conectada quando houver um cache consumidor legítimo.
