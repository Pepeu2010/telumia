# Fase 6 R1 — QA Android TV API 30

Executado em 25/10/2026 no AVD `Telumia_TV_API30` (AOSP TV x86, API 30, 1920×1080).

- `guide-cache-unit-tests.xml`: 4 testes JVM do cache EPG, sem falhas.
- Instrumentação `LiveTvGuideCacheAtomicReplaceTest`: 1 teste aprovado, validando substituição de cache com `File.renameTo` no Android.
- `visual-components-tests.xml`: 6 testes instrumentados aprovados, incluindo foco/seleção D-pad do seletor de canais e favorito.
- `quick-channel-overlay-api30.png`: captura do componente real com dois canais de fixture; não representa uma fonte ou programação distribuída pelo app.

O universal Full Debug foi recompilado. O emulador não valida desempenho de TV Box física nem reprodução/troca ponta a ponta com fonte configurada. Consulte [registro detalhado](../../telumia-tv-live-tv-r1-api30-qa.json) e [estado da Fase 6](../../LIVE_TV.md).
