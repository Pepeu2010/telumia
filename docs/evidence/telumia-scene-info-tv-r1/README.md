# Evidências — Scene Info TV R1

Executado em 25/10/2026 no AVD `Telumia_TV_API30`, Android 11/API 30, 1920×1080.

## Entrega

O player só oferece Scene Info quando há um capítulo ID3 confiável ativo na timeline da edição que está tocando. O painel mostra a origem do dado, recebe foco ao abrir e fecha pelo D-pad. A troca de fonte encerra o painel antigo. O código foi publicado na branch `codex/live-tv-mini-player` do fork `Pepeu2010/telumia-tv`.

- Commit local: `7cbbbcb343b39f3af26263bc43c4eda72f77b36f`.
- Commit GitHub: `d116375d5a76141b9bb9e748486db411f3ec2d0d` (pai `2e31287521565d3e746767b9a5e7200f003e2773`; árvore idêntica `05cce3a5786edf8653d8c5d4d6590b67322a2380`).

## Verificação

- `:app:testFullDebugUnitTest --tests com.nuvio.tv.ui.screens.player.EmbeddedChapterMetadataTest --tests com.nuvio.tv.ui.screens.player.EmbeddedChapterSceneMetadataProviderTest --tests com.nuvio.tv.core.player.metadata.TimedMetadataTimelineTest --tests com.nuvio.tv.ui.screens.player.PlayerSceneBookmarksTest`: 21 testes, 0 falhas/erros/skips; relatórios XML incluídos neste diretório.
- `:app:connectedFullDebugAndroidTest -Pandroid.testInstrumentationRunnerArguments.class=com.nuvio.tv.ui.screens.player.SceneInfoTvTest`: 1 teste aprovado no AVD. O relatório HTML e a captura mostram o componente Compose real com uma fixture controlada, foco inicial e fechamento pelo D-pad.
- `:app:assembleFullDebug` e `:app:compileFullDebugAndroidTestKotlin`: `BUILD SUCCESSFUL`.
- APK universal Full Debug SHA-256: `BB7944C478502AAC50A429F2C8C5139BD49EC24BF7C110F554D4C24D3C2FF72F`.

## Limites

A fixture comprova a apresentação do capítulo, a proveniência e o comportamento de foco; não comprova playback de um arquivo comercial ou integração com uma fonte externa de atores, música ou curiosidades. Nenhum dado temporal ausente é inventado. A validação em TV Box física e a reprodução/troca ponta a ponta permanecem pendentes. Este APK de depuração não foi publicado como release.
