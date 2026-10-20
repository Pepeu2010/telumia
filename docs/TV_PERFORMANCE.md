# Desempenho em TV Box

## Incremento de baixo consumo

O perfil de recursos da TV adapta automaticamente o trabalho de imagens conforme a memória total do aparelho, o limite de heap informado pelo Android e a flag `isLowRamDevice`. O perfil de baixa RAM entra em aparelhos com até 2 GiB ou marcados pelo sistema como limitados.

| Recurso de imagem e início da Home | Baixa RAM | Equilibrado | Alta capacidade |
| --- | ---: | ---: | ---: |
| Cache de bitmaps | 8% | 16% | 25% |
| Downloads de imagem simultâneos | 4 (2 por host) | 16 (8 por host) | 32 (16 por host) |
| Decodificações simultâneas | 1 | 2 | 4 |
| Linhas/imagens carregadas antes de serem exibidas | 0 | 1 | 2 |
| Itens compostos antecipadamente em listas internas da Home | 0 | 1 | 2 |
| Blur em tempo real da barra lateral | Desativado | Mantido | Mantido |
| Movimento automático | Reduzido, intensidade sutil | Preferência atual | Preferência atual |
| Espera de foco estável antes de trailer | 1,5 s | 1,2 s | 1,2 s |

Isso reduz picos de CPU, heap e tráfego quando uma TV Box percorre a Home. As Homes Moderna e Clássica agora leem o limite de pré-carga de catálogo do perfil automático, evitando buscar a próxima linha antes de exibi-la em baixa RAM. Os trailers só iniciam depois de foco estável: 1,5 s em baixa RAM e 1,2 s nos demais perfis, evitando rede e uso do decoder durante navegação rápida. O cache em disco, os provedores, os formatos de vídeo e a resolução pedida pelos cards continuam seguindo as configurações existentes. No perfil de baixa RAM, a preferência padrão de movimento `FULL` é aplicada como `REDUCED`, e a intensidade padrão `STANDARD` como `SUBTLE`; escolhas explícitas `REDUCED`, `OFF` e `CINEMATIC` são preservadas. O perfil também troca o blur animado da barra lateral por sua superfície gradiente leve. A preferência salva não é alterada: o ajuste só vale enquanto o perfil automático do dispositivo estiver ativo.

O commit `abea30964` reduz o limite de requisições de imagem simultâneas em aparelhos identificados como baixa RAM: de 8 para 4 no total e de 4 para 2 por host. A política global do Coil/OkHttp consome esses valores ao criar o loader; decodificações permanecem limitadas a uma e a pré-carga permanece desativada nesse tier. A mudança diminui a quantidade máxima de respostas de imagem concorrentes enquanto o foco percorre a Home. É uma redução de concorrência configurada, não uma medição de FPS ou heap.

O commit `94a7d8afd` estende `REDUCED`/`OFF` aos componentes de carregamento que antes continuavam animando por conta própria. `LoadingIndicator` agora desenha um arco estático sem criar uma transição infinita, enquanto `rememberPlaceholderShimmerOffsetState` entrega um offset fixo e deixa de acordar o relógio de frames. O modo `FULL` mantém os efeitos existentes. O run [39351383602](https://github.com/Pepeu2010/telumia-tv/actions/runs/39351383602) passou nos testes unitários selecionados, compilou testes instrumentados e publicou três APKs `fullDebug` em 8 min 8 s; [artefatos e limites](telumia-tv-low-resource-r6-ci.json). A instrumentação foi compilada, não executada, e não houve device conectado; o ganho de fluidez e o impacto em FPS ainda precisam ser medidos fisicamente.

## Seek e filmstrip do player

O mesmo perfil agora controla o custo do preview durante seek. Em aparelhos de baixa RAM (até 2 GiB ou sinalizados pelo Android), a captura mantém somente o frame central e o cache de bitmaps de seek fica limitado a 1 MiB. O perfil equilibrado habilita o filmstrip após 1,2 s sem novo seek e limita esse cache a 2 MiB. Alta capacidade mantém o filmstrip após 650 ms e até 4 MiB. Esses limites são tetos adicionais: a política ativa de cache ainda pode reservar menos. Capturas continuam sob demanda, em uma única lane Media3 separada da reprodução principal, limitada e cancelável.

Essa adaptação reduz decodificações especulativas, mas não desativa a thumbnail central; por isso, não deve ser interpretada como medição de fluidez ou de uso total de memória do aparelho. Na TV Box do usuário ainda faltam comparação real de FPS, heap, tempo de seek e dropped frames.

## Evidência e limites

Foram adicionados testes unitários para os tiers de baixa RAM, equilibrado e alta capacidade, incluindo a política de movimento, atraso de previews e preservação de `REDUCED`, `OFF` e `CINEMATIC`. A tentativa local `artifacts/tv-low-resource-r1/tv` usou um worker, sem emulador e heap Gradle de 1 GiB; o daemon entrou em coleta de lixo contínua ao compilar `fullDebug` e saiu com código 1 antes de registrar os testes. O GitHub Actions executou os filtros `TvPerformanceProfileTest`, `PlayerSourceSelectionStoreTest` e `com.nuvio.tv.updater.*`, compilou `fullDebug` e publicou o APK universal de depuração no run `39333239418`, commit `2a29d9087961cedffb4301539827fb00ea3f8dfe`; o workflow concluiu com sucesso. O APK de 178.466.176 bytes tem retenção de sete dias. Nenhum dispositivo Android estava conectado ao ADB; ainda falta medir na TV Box do usuário.

Para aceitar a melhoria no aparelho real, registrar modelo, versão do Android e RAM, depois comparar a abertura fria da Home e uma rolagem fixa antes/depois com `dumpsys meminfo`, `dumpsys gfxinfo` ou Perfetto. A classe por RAM é uma heurística inicial; resultados do aparelho real podem justificar ajustar os limites sem reduzir a compatibilidade de vídeo.

Na continuação de seek, o run `39338632273` passou `TvPerformanceProfileTest`, os testes selecionados de updater/fonte e `EmbeddedChapterMetadataTest`, compilou `compileFullDebugAndroidTestKotlin` e montou `fullDebug`. A alteração não executou os testes instrumentados nem substitui a medição física. O APK temporário e sua validade estão registrados em [telumia-tv-low-resource-r2-ci.json](telumia-tv-low-resource-r2-ci.json).

O incremento seguinte, commit `13b7966f212b1c3ee061e7c70ad9c3f56d4c3270`, limita também a cadência de extrações repetidas durante seek: 300 ms em baixa RAM, 180 ms no perfil equilibrado e 120 ms em alta capacidade. A primeira captura continua imediata; os pedidos intermediários são conflados, e a posição mais recente continua sendo processada. O run `39339978937` passou nos testes unitários selecionados, compilou `compileFullDebugAndroidTestKotlin` e concluiu `assembleFullDebug`. O APK universal debug tem 178.477.072 bytes e expira em 26/10/2026; [registro completo](telumia-tv-low-resource-r3-ci.json). Isso verifica a política e a compilação, mas não mede fluidez física, uso de heap, latência de seek ou frames perdidos na TV Box.

Na Home Moderna, o commit `f330f0165ec91cf8f00f5e0a15fa54ac2b51967c` conecta a composição antecipada da `LazyRow` e o pré-carregamento horizontal de imagens ao mesmo perfil: baixa RAM desativa ambos, equilibrado prepara um item e alta capacidade prepara dois. Assim, reduzimos composição, decodificação e rede especulativas na navegação por D-pad dos aparelhos modestos, mantendo antecipação maior nos aparelhos com mais recursos. O run `39340926875` passou nos testes direcionados, compilou a instrumentação e montou `fullDebug`; [artefato e escopo](telumia-tv-low-resource-r4-ci.json). Ainda não há medição comparativa em aparelho físico.

## APK por arquitetura

O workflow também publica APKs específicos ARM64 e ARMv7, além do universal. No run `39341729947`, o universal ficou com 178.478.836 bytes; ARM64, 91.507.598 bytes; ARMv7, 89.406.008 bytes. A variante ARM64 reduz o pacote baixado em 48,7% em relação ao universal e evita instalar as bibliotecas das outras arquiteturas. Isso diminui a transferência e o espaço de instalação, mas não demonstra aceleração durante a execução. Os três artefatos do mesmo commit expiram em 26/10/2026; [registro e links](telumia-tv-abi-artifacts-r1-ci.json).

O run [39350246174](https://github.com/Pepeu2010/telumia-tv/actions/runs/39350246174) validou a política atualizada com testes selecionados, compilação instrumentada e três builds `fullDebug` em 7 min 59 s. Os APKs universal, ARM64 e ARMv7 foram publicados por sete dias, até 27/10/2026; [registro completo](telumia-tv-low-resource-r5-ci.json). Não havia aparelho ADB conectado, então ainda falta comparar FPS, heap, duração de carregamento e dropped frames na TV Box real.
