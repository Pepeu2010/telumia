# Telumia — ciclo de vida dos previews

Incremento sobre os componentes e resolvers existentes. Não encerra Cinematic Preview nem o redesign da Home.

## Desktop: entrega verificada

`HomePosterHoverPreview` agora possui uma vaga exclusiva por montagem do card. Abrir outro card invalida o anterior; desmontar o anterior não libera a vaga do novo. A resolução começa depois do hover estável, possui deadline de cinco segundos e é cancelada ao sair, trocar de card ou desmontar. Falha/ausência de trailer conserva a arte estática. As transições do popup e do trailer respeitam o movimento configurado no perfil. O som continua opt-in.

Commit `57385d2e92d34ff39527e38566534939d86c87ad`, publicado em `telumia-desktop/main`. Gate: 174 testes selecionados, zero falhas, erros ou skips; MSI compilado e preservado, SHA-256 `92c7c62939a4f729f59a5ed47cd259b50ce51255bdb60f71f06b50fe0a0a206b`. [Vínculo entre fontes e pacote](telumia-hover-lifecycle-desktop-bound-build-binding.json) e [inspeção do instalador](telumia-hover-lifecycle-desktop-package-inspection.json).

Cinco testes verificam ownership, timeout, falhas e propagação de cancelamento. Um teste Compose usa o popup real, transfere o mouse do card para ele, cancela um resolver controlado ao sair e verifica a liberação da vaga. A captura abaixo foi revisada; demonstra o estado estático com consulta pendente, sem afirmar disponibilidade ou reprodução de um trailer.

![Popup real durante resolução controlada](evidence/telumia-hover-lifecycle/desktop-static-pending-preview.png)

**Limite da entrega inicial:** a política herdada já resolvia trailers no Windows, mas o stub de `HeroTrailerPlayerSurface` não os reproduzia. O teste de cancelamento daquela rodada injetava a capacidade de resolver trailers; não habilitava a superfície nativa. A continuação Windows abaixo substitui o stub pelo player libmpv existente; o AVI local agora valida o controlador nativo, enquanto o trailer real integrado ao card e sua revisão visual continuam como gates separados.

### Continuação Windows — superfície inline com libmpv

`HeroTrailerPlayerSurface` no Windows agora monta o host AWT existente e usa `NativePlayerController`/libmpv. O bridge omite WebView2 e os controles completos nesse modo; a reprodução só começa depois de carregar a duração, aplica mute antes do play e descarta a superfície se o carregamento exceder 12 segundos. A política herdada de previews silenciosos é preservada. Se o usuário habilitar som mas o resolver entregar vídeo e áudio separados, o card retorna à arte em vez de tocar um preview sem a faixa de áudio correta. A proporção `Fit`/`Fill` é temporária e não muda a preferência global do player.

No Windows, `buildWindowsPlayerBridge`, `compileKotlinDesktop`, `desktopJar` e as classes `NativePlayerControllerTeardownTest`, `NativeTimelineFramesTest` e `WindowsHeroTrailerPlayerSurfaceTest` passaram; **32 testes, zero falhas/erros/skips**. O gate nativo monta o `NativePlayerHost` num peer HWND de propriedade do teste, abre um AVI original local com o controlador inline sem WebView de controles, confirma a duração, aplica mute/Fit e verifica que o libmpv começa a reproduzir. Outro gate compõe `WindowsHeroTrailerPlayerSurface` num `ComposePanel`/janela AWT real, confirma o primeiro paint integral do host e o callback de mídia pronta, e então observa a reprodução chegar ao callback de fim. Isso comprova o ciclo de vida Compose→Swing/AWT→libmpv com vídeo local; não comprova o frame de vídeo visualmente dentro do card nem a integração pai do hero/hover, URLs reais/remotas do resolver ou revisão visual de Home/detalhes. Também faltam MSI para esta revisão e inclusão em release; os binários públicos permanecem na revisão anterior.

Tentativas anteriores com erro de compilação do teste, timeout e condição de capacidade estão preservadas em `artifacts/`; não são usadas como gate aprovado. O teste final aguarda a recomposição e simula a transferência real do ponteiro para o popup.

## TV: entrega verificada

A implementação evolui o pipeline do `HomeViewModel` e o `TrailerPlayerPool` existentes. Cancela pedidos antigos antes de consultar caches, preserva pedidos repetidos do mesmo item, aplica deadline de seis segundos e descarta respostas atrasadas. Os mapas de URLs e o cache negativo ficam limitados a 64 entradas. Cancelamento, timeout e erro transitório não se tornam ausência permanente. Consultas de fallback usam IO; publicação e retry usam Main. Sair da Home cancela consultas; parar o scroll permite repetir o preview do item ainda focado.

O pool Media3 entrega uma vaga exclusiva por componente. Trocar de card interrompe a mídia anterior; callbacks e desmontagem do card antigo não param o novo. Entregar o decoder ao player principal invalida a vaga e impede aquisição até sua devolução. A preparação começa silenciosa, com alvo de buffer de 16 MiB, até dez segundos e seleção adaptativa limitada inicialmente a 720p/4 Mbps. Esse alvo não é um teto de memória total nem a implementação definitiva de DeviceCapabilities. As transições respeitam movimento reduzido/desligado. Sem primeiro frame em doze segundos, retorna à arte estática.

Commit `e593acdd8ab0b906a9cf99aff51c751bf3cea5fb`: 137 testes selecionados, zero falhas/erros/skips, cinco APKs e APK de instrumentação compilados e preservados. APK universal SHA-256 `7ddd3c50b5ea8e7281e9702f024efe390092ea63fecfb553582d98030f34d7f5`. [Build e vínculo de fontes](telumia-preview-owner-tv-build-binding.json), [inspeção dos APKs](telumia-preview-owner-tv-package-inspection.json) e [testes nativos](telumia-preview-owner-native.json).

Quatro testes nativos passaram em cada API, Android 7 e Android 16, com os mesmos APKs. O Media3 real prepara áudio WAV local; são verificados ownership, desmontagem de dois componentes Compose sobrepostos, silêncio inicial e entrega/retorno do decoder. Isso não comprova frames de vídeo, trailers remotos, HDR ou desempenho físico. Uma tentativa anterior falhou por comparação de identidade de um conjunto no teste; o teste foi corrigido para comparar seu conteúdo. [Histórico dos gates](telumia-hover-lifecycle-results.json) e [gate final](telumia-preview-owner-results.json).

## Pendências

Ainda é necessário implementar trailers embutidos Windows e validar vídeo remoto, todas as superfícies de preview, DeviceCapabilities e desempenho físico. O código desta entrega é posterior à release `v0.2.1-alpha.1`; seus binários públicos continuam fixos nos commits originais. As falhas herdadas da suíte completa e os fluxos de conta/sync não são cobertos por este gate.

## Gate de interop do hover preview Windows — 27 de outubro

Antes de habilitar trailers no hover do Windows, executei o fluxo real `HomePosterHoverPreview` com `trailerPreviewSupported=true` e a superfície libmpv dentro do popup. O popup e o host Compose aparecem, mas a composição de `SwingPanel` falha com `IllegalStateException: LocalInteropContainer not provided` (`InteropContainer.skiko.kt:38`). A API Compose atual não fornece o container de interop nesse caminho de `Popup`; a superfície nativa continua funcional numa janela/ComposePanel normal, conforme os gates locais anteriores.

Por isso o flag `hoverTrailerPlaybackSupported` e o controle default permanecem desativados no Windows. Nenhuma funcionalidade falsa foi exposta. O primeiro teste identificou o caminho para montar o host nativo num overlay da janela principal; a validação desse caminho está registrada abaixo.

### Continuação — portal na janela principal

O `AppEnvironment` do Windows agora oferece um portal `SubcomposeLayout` sobre a janela Compose principal. Ele reutiliza o posicionador do popup, mede o card real e monta o `SwingPanel` dentro do host de interop da janela. O popup original continua sendo usado nos outros desktops. A rota só é escolhida quando trailers estão habilitados; o controle continua oculto por política no Windows.

O teste `HomePosterHoverLifecycleTest` aciona a interação `hover` do componente por `MutableInteractionSource` dentro de um `ComposePanel`/`JFrame` real, abre um AVI local no player libmpv existente e confirma a resolução, `media-ready`, ownership e liberação ao sair. **Os três testes da classe passaram**, incluindo a transferência do ponteiro de teste do card para o overlay e o cancelamento do resolver. `desktopJar` e MSI Windows x64 também compilaram. O MSI é local, continua com a versão de validação e não foi publicado. Resultados e checksum: [registro do build](telumia-hover-preview-windows-overlay-r1-build.json).

O runner não forneceu entrada OS real: `Robot.mouseMove` não alcançou o card. A captura por `Robot` foi preta, portanto não serve como evidência visual. O teste comprova integração de composição, lifecycle e callback do player com mídia local; não comprova o movimento real do mouse nem que o frame de vídeo esteja visível no card. **O preview de trailer permanece desativado no Windows** até o QA visual e de ponteiro num desktop interativo. O bloqueio de popup `LocalInteropContainer not provided` foi contornado tecnicamente pelo portal, mas a Fase 3 e as pendências gerais de preview continuam abertas.

### Gate com ponteiro real, vídeo visível e opt-in no Windows — 31 de outubro de 2026

A superfície AWT/`SwingPanel` agora publica a entrada/saída do ponteiro para o mesmo `MutableInteractionSource` do card enquanto a preview nativa está montada. Isso mantém o ownership durante a transição do poster para o HWND, evita reabrir o resolver e preserva exclusividade ao trocar de card. O polling fica limitado à única superfície nativa ativa; cada ciclo é cancelado ao desmontar.

O gate no Windows usa `Robot`/ponteiro OS real e um AVI local de seis segundos. Sem cursor na janela, não há owner nem resolução; cada um de dois cards resolve uma vez, mantém o mesmo handle ao entrar no vídeo e renderiza 99.120/99.120 pixels RGB esperados. O volume JNI é `0.0`; sair da janela/trocar de card libera o decoder anterior, owner e fixture. O teste confirma que o vídeo não termina nos primeiros 500 ms e finaliza após 6.055 ms. A causa do vídeo ausente era `decoderPriority=0`, que desativava fallback de software; a preview agora usa prioridade automática com fallback disponível.

No Windows, a capacidade de preview volta a aparecer em Configurações, mas reprodução e som permanecem desligados por padrão; escolhas explicitamente salvas são preservadas. Passaram 13 testes Desktop focados, sem falhas/erros/skips; `:composeApp:desktopJar` e `:composeApp:packageMsi` passaram. Commit [`81e2ebe`](https://github.com/Pepeu2010/telumia-desktop/commit/81e2ebe37fa1e81dc6a4ec0acacd3bdcfb75f86a), [PR draft #32](https://github.com/Pepeu2010/telumia-desktop/pull/32), empilhado sobre a branch base do portal Windows. MSI Windows x64 local: 210.944.104 bytes, SHA-256 `8A16B74B74CBEDEC1EE1D0DC3AEEE69BA74F905405E216600820694C52B86C4A`; não publicado. [Captura antes](https://github.com/Pepeu2010/telumia-desktop/blob/81e2ebe37fa1e81dc6a4ec0acacd3bdcfb75f86a/artifacts/phase3-hover-preview/before.png), [vídeo local visível depois](https://github.com/Pepeu2010/telumia-desktop/blob/81e2ebe37fa1e81dc6a4ec0acacd3bdcfb75f86a/artifacts/phase3-hover-preview/after.png), [troca de card](https://github.com/Pepeu2010/telumia-desktop/blob/81e2ebe37fa1e81dc6a4ec0acacd3bdcfb75f86a/artifacts/phase3-hover-preview/card-switch.png) e [binding de build](https://github.com/Pepeu2010/telumia-desktop/blob/81e2ebe37fa1e81dc6a4ec0acacd3bdcfb75f86a/artifacts/phase3-hover-preview/build-binding.json).

Limites: teste em um Windows runner, monitor único e escala 1.0; não valida DPI misto/multimonitor, trailers remotos ou áudio combinado, nem CPU/jank em hardware. O fallback de software pode usar CPU alta em aparelho sem decoder compatível, por isso o playback continua opt-in/off por padrão. A Fase 3 permanece aberta para esses gates e revisão do PR.
