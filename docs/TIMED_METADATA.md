# Telumia — metadata temporal integrada ao player

Fundação da Fase 2, integrada aos players existentes em 6 de outubro de 2026. A primeira entrega Scene Info da Fase 7 (R1) agora projeta capítulos embutidos confiáveis no contexto de reprodução, sem depender de um serviço externo.

Os dois clientes possuem um contrato de eventos temporais com identidade da obra, episódio e edição, tipos específicos, procedência e confiança explícita. A timeline limita quantidade, valida timestamps, elimina duplicatas e consulta intervalos também ao retroceder. Providers possuem timeout, cancelamento e isolamento de falhas. Eventos de cena exigem edição conhecida, provider de cena registrado e confiança suficiente; elenco geral não é convertido em elenco da cena. A Fase 7 usa esse contrato: o provider inicial converte somente capítulos ID3 da edição que está tocando em fatos temporais de capítulo.

Os segmentos recebidos pelo mecanismo existente de skip alimentam essa timeline sem criar requisições adicionais. Intro, recap, créditos e pós-créditos aparecem como marcações nas barras de progresso existentes. O contrato também permite capítulos e bookmarks. Um incremento posterior implementou [Momentos salvos na TV](SCENE_BOOKMARKS.md), com persistência real e projeção na timeline. Em continuações posteriores, capítulos reais passaram a vir dos arquivos Desktop/libmpv e TV/Media3; veja [capítulos embutidos](EMBEDDED_CHAPTERS.md). Eventos de atores, música e curiosidades não geram marcações arbitrárias.

No Desktop, a integração alcança as barras Compose e o payload da ponte nativa, com renderizador HTML incluído no JAR distribuído. O renderizador valida valores, limita eventos e utiliza texto literal. Na TV, o controller limpa metadata da identidade anterior, cancela carregamentos substituídos e entrega marcações à barra e ao overlay de seek. Sem duração válida, o D-pad não confirma posições fictícias.

## Verificação

- Desktop: 93 testes selecionados, sem falhas/erros/skips, e MSI real. Incluem consultas temporais, confiança, limites, cancelamento, serialização nativa e seek Compose. Dois testes Node verificam o renderizador HTML, inclusive texto malicioso e limpeza de eventos antigos.
- TV: 83 testes unitários selecionados, sem falhas/erros/skips; cinco APKs e APK de instrumentação.
- TV nativa: nove testes de D-pad, seek, duração desconhecida e substituição de marcações em 720p, 1080p e framebuffer 4K verificado pelas capturas.
- [Builds e commits](telumia-timed-results.json), [MSI](telumia-timed-desktop-package-inspection.json), [APKs](telumia-timed-tv-package-inspection.json), [UI Desktop](telumia-timed-desktop-ui-qa.json), [UI TV](telumia-timed-tv-ui-qa.json).

![Timeline Desktop](evidence/telumia-timed/desktop-timeline.png)
![Timeline TV 720p](evidence/telumia-timed/tv-timeline-720.png)
![Timeline TV 4K](evidence/telumia-timed/tv-timeline-2160.png)

As capturas utilizam fixtures controladas, incluindo um bookmark apenas para testar sua representação. Não comprovam playback completo, um bookmark persistido ou dados de cenas de uma fonte real. A ponte HTML foi testada e empacotada, mas a reprodução completa via JNI/WebView2 permanece um gate separado.

## Scene Info R1 — capítulos embutidos

O painel já está integrado ao player Desktop e à TV. Ele só aparece quando a timeline contém um capítulo embutido confiável para o ponto de reprodução atual. O provider exige correspondência entre a edição da fonte e a timeline, limita o intervalo ao próximo capítulo ou à duração conhecida e não inventa um término quando não há limite confiável. Trocar a mídia fecha o painel antigo. A TV também confirma foco inicial e fechamento pelo D-pad.

- Desktop: 43 testes de metadata aprovados em 10 relatórios XML; `compileKotlinDesktop` e `desktopJar` passaram.
- TV: 21 testes unitários aprovados em quatro relatórios XML; `assembleFullDebug` e compilação de instrumentação passaram. Um teste instrumentado aprovou no AVD API 30, com captura do painel em 1080p.
- [Evidência Desktop](evidence/telumia-scene-info-desktop-r1/README.md), [evidência TV](evidence/telumia-scene-info-tv-r1/README.md) e [registro da entrega](telumia-scene-info-r1-local.json).

A captura TV usa uma fixture controlada e comprova apresentação, proveniência, foco e interação do componente real; não prova reprodução ponta a ponta de um arquivo comercial. Ainda não há fonte confiável de dados temporais para atores, música ou curiosidades integrada. Esses itens continuam ocultos quando não há dados confiáveis. A geração local de identidades continua experimental e fora deste incremento.

## Continuidade

Scene Bookmarks no Desktop ainda têm gates de janela/modal, foco WebView2 e seek real. Thumbnails correspondentes ao timestamp e filmstrip foram integrados ao seek D-pad TV, com QA de componentes em API 24/36 e 720p/1080p/4K; o perfil posterior reduz trabalho especulativo em aparelhos de baixa RAM. A primeira versão do provider e painel Scene Info está entregue, mas a Fase 7 continua aberta para fontes licenciadas/confiáveis de atores, música e curiosidades, quando disponíveis, e reprodução ponta a ponta em ambos os clientes. Os bookmarks TV e cada incremento de chapters mantêm gates próprios. A evolução completa do player e os demais recursos continuam obrigatórios pela [meta integral](GOAL_OBJECTIVE_2026-10-05.md). A release pública atual `0.2.1-alpha.1` contém a fundação temporal e permanece imutável; incrementos posteriores não estão nesses binários.
