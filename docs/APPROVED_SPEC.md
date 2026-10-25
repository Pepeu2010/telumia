# Approved source of truth

Approved by the user on 2026-10-03 (America/Sao_Paulo). The complete original
requirements are preserved verbatim in PRODUCT_REQUIREMENTS.md. This document
records the approved architecture, delivery decisions and subsequent amendments.

## Non-negotiable decisions

- Independent native forks of NuvioDesktop and NuvioTV, retaining Git history.
- Kotlin Multiplatform / Compose Desktop and Kotlin / Jetpack Compose / Media3;
  preserve existing native player implementations and platform portability.
- Independent installation, local data, package identity, signing and updater.
- Existing Nuvio authentication, supported sync and Stremio addon contracts.
- Windows and Android TV first; 2 GB / 1080p TV Box performance reference.
- Nuvio Enhanced is a temporary name and explicitly an unofficial client.
- Small verified milestones; no rewrite, fake buttons, lost existing features,
  mandatory telemetry, embedded content/providers or invented server endpoints.
- Phase 0 audit and clean upstream builds precede application modifications.
- Continue directly into the first implementation foundation after Phase 0
  unless a genuine technical blocker prevents that work.

## Amendments approved before execution

1. **Adaptive cache:** 1 GiB Desktop and 256 MiB TV are configurable starting
   defaults, not permanent limits. Auto considers available storage and device
   capabilities; quotas, eviction and cleanup still bound cache growth. Downloads
   are separate. Explicit user settings remain available.
2. **Timed metadata:** Phase 2 introduces a generic timeline/player abstraction
   for time-bound metadata. Chapters, intro/recap/credits and bookmarks use the
   abstraction; Scene Info providers are implemented in Phase 7 without changing
   the underlying player contract. Unknown data stays unknown.
3. **Live TV design readiness:** Phase 1 prepares visual tokens/components for
   channels, now/next, program progress, EPG cells/grid and D-pad focus. No Live TV
   route or actionable control is exposed until Phase 6 has real source support.

## Execution amendment — 2026-10-04

The user's subsequent instruction is binding: **evolve the existing Nuvio,
do not rebuild it**. Before introducing a file or abstraction, inspect existing
components, ViewModels, models, repositories, settings, profiles/avatar/PIN,
navigation/focus, addon resolver, preview pool, cache/download and player code.
Extend the best existing integration point; refactor only where necessary.
Desktop KMP/commonMain/Compose/libmpv/JNI/WebView2 and TV Compose/TV Material 3/
Media3, focus restoration, progressive seek and trailer pool remain the base.
The separate clients retain their histories. A shared library is optional and
limited to genuinely platform-independent new rules, with demonstrated need.

Per feature, document existing behavior, gaps, changed files and extension point;
implement, test, compile and validate visually before declaring completion.
Never replace working login/sync/addon/player contracts, create a parallel app,
fake controls or advertise planned features as installed features. The complete
follow-up requirement is preserved in PRODUCT_REQUIREMENTS.md. This amendment
reinforces the approved phase order, including timed metadata in Phase 2,
Scene Info in Phase 7 and Live TV components in Phase 1 before real Phase 6 routes.

## Delivery boundaries

- MVP 1: all mandatory original requirements, both Windows and Android TV.
- MVP 2: Live TV/EPG, advanced failover, Phone Remote, Smart Collections,
  download improvements and complete Spoiler Shield.
- MVP 3: Scene Info, advanced filmstrip, experimental local analysis,
  timeshift, multi-view and advanced recommendations.
- Scene Info Phase 7 does not block earlier milestones. Timeshift/multi-view
  and local recognition are experimental and disabled until validated.
- Shared enhanced domain models stay small and platform-independent; current
  auth/sync repositories remain owned by their original clients.
- Local custom avatars/preferences are not advertised as officially synced;
  upload or cross-device support requires an existing verified server contract.

## Acceptance

The user explicitly requested completion of the entire approved scope on
2026-10-04. Partial development releases are checkpoints, not completion of that
objective. Continue all milestones and retain outstanding implementation and
verification gates until their actual evidence exists.

Implementation defaults from the approved plan: PreviewCoordinator has a
750 ms Desktop and 1200 ms TV delay, silent autoplay and one active preview;
primary playback takes ownership of decoder resources. Source score starts with
quality 30, language/audio 20, hardware 20, availability/latency 20 and historical
stability 10, with visible evidence and Unknown states. Best Quality/Balanced/
Data Saver/Manual do not remove manual choice. Timeline adapters distinguish
requested/effective timestamp, consult cache, use declared source/sprites/metadata
and isolated local extraction, never repositioning the main player for previews.
Phone Remote is opt-in; random short-lived pairing expires after two minutes
and requires explicit host confirmation. External telemetry is off by default.

Every feature needs implementation, loading/empty/error states, keyboard or
D-pad behavior, accessibility, performance evidence, meaningful tests and docs.
Compilation is not runtime, visual, codec, HDR or modest-device proof. Accounts,
real sources and physical devices require explicit evidence, never invented
results. Preserve copyright, licenses, notices and corresponding source for
distributed modifications.

## Desempenho contínuo — requisito vigente em 2026-10-25

Cada fase e atualização deve manter os clientes Windows PC e Android TV leves,
responsivos e estáveis. Tratar desempenho como gate de cada milestone, não como
uma etapa final: comparar antes/depois nos fluxos afetados, limitar trabalho e
concorrência especulativos, cancelar tarefas obsoletas e adaptar previews,
cache, imagens e animações às capacidades detectadas. A referência de TV Box
continua sendo 2 GiB / 1080p; no PC, registrar o hardware e as condições da
medição em vez de presumir uma máquina de referência.

Em cada milestone, compilar os dois clientes e revisar regressões nas métricas
pertinentes: inicialização e resposta da interface, frame pacing/jank, CPU e
memória; no player, também frames perdidos e latência de seek; nos pacotes,
tamanho de APK/MSI. Manter como metas de navegação 60 FPS e foco p95 abaixo de
100 ms onde aplicável. Testes unitários, build ou emulador sozinhos não provam
fluidez em hardware físico. Se o dispositivo real não estiver disponível,
registrar essa limitação e não declarar a otimização comprovada. Corrigir
regressões mensuráveis antes de fechar a fase ou documentá-las como bloqueio
concreto, com evidência e próximo passo. Crash, ANR ou freeze reproduzível
introduzido pela fase impede sua conclusão até correção; problemas herdados devem
continuar identificados e não podem ser mascarados como resultado desta fase.

## Atualização de prioridade — 2026-10-05

O objetivo integral foi reforçado pelo usuário: interface sofisticada nos filmes e experiência contextual semelhante ao conceito do Prime Video, superior ao cliente de origem em funcionalidades. A marca definitiva é Telumia. Os critérios existentes continuam válidos: informação contextual confiável, sem scraping IMDb nem alegações de atores presentes em cena inferidas a partir do elenco geral. A entrega continua incremental com compilação, testes e evidências; releases parciais não encerram a meta integral.

## Meta integral atualizada — 2026-10-05

A [meta integral fornecida pelo usuário](GOAL_OBJECTIVE_2026-10-05.md) é requisito vigente e foi preservada integralmente. A preservação exigida diz respeito à infraestrutura, contratos e comportamentos úteis. **A camada visual deve ser profundamente redesenhada em todas as superfícies; componentes e layouts antigos podem ser refatorados ou substituídos quando limitarem a nova experiência.** Reposicionar componentes, trocar logo ou acrescentar um tema não satisfaz o resultado pedido.

Home, navegação, perfis, cards/previews, detalhes, player/timeline, Scene Info, busca, biblioteca, addons, configurações, downloads, TV e EPG precisam formar uma experiência própria e consistente. Os clientes nativos reais continuam a base; não há autorização para app paralelo, troca gratuita dos motores ou regressões nos contratos. Toda função exige comportamento real, estados, persistência aplicável, teclado/D-pad, acessibilidade, testes e validação visual. A meta também exige regressões de infraestrutura, portabilidade existente e auditoria de segurança.

Entrega de um incremento, compilação de uma fase ou publicação de alpha não encerra a meta. Bloqueios externos devem ser registrados e as partes executáveis devem continuar. Os incrementos documentados anteriormente são evidências intermediárias, não aceitação do redesign completo.
