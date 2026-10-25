# Evidências — Scene Info Desktop R1

Validação selecionada executada em 25/10/2026. Os 10 relatórios XML anexos cobrem painel, provider de capítulos embutidos, projeção e timeline, além das regressões de Momentos salvos.

## Entrega

O painel Scene Info usa somente capítulos embutidos associados à edição que está tocando e ao ponto atual da timeline. O provider não infere elenco, música ou curiosidades. Código no commit `4df39a52b1c6d612e3adc6530361045c40f3dd27` (pai `83eae71f6aa17fc04d075e940ea7a6614118e36c`), branch `codex/enhanced-foundation` do fork `Pepeu2010/telumia-desktop`.

## Verificação

- 43 testes de metadata em 10 relatórios XML, sem falhas, erros ou skips.
- `compileKotlinDesktop` e `desktopJar`: `BUILD SUCCESSFUL`.

## Limites

Esta rodada não produziu MSI Windows: o ambiente não tem Visual Studio Build Tools nem o SDK NuGet do WebView2 necessários para a ponte nativa. Os testes de painel não substituem uma sessão de reprodução ponta a ponta com mídia real via JNI/WebView2. Não há provider licenciado/confiável de metadata temporal de atores, música ou curiosidades integrado.
