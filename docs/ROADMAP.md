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


