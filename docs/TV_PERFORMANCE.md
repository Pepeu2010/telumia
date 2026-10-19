# Desempenho em TV Box

## Incremento de baixo consumo

O perfil de recursos da TV adapta automaticamente o trabalho de imagens conforme a memória total do aparelho, o limite de heap informado pelo Android e a flag `isLowRamDevice`. O perfil de baixa RAM entra em aparelhos com até 2 GiB ou marcados pelo sistema como limitados.

| Recurso de imagem e início da Home | Baixa RAM | Equilibrado | Alta capacidade |
| --- | ---: | ---: | ---: |
| Cache de bitmaps | 8% | 16% | 25% |
| Downloads de imagem simultâneos | 8 (4 por host) | 16 (8 por host) | 32 (16 por host) |
| Decodificações simultâneas | 1 | 2 | 4 |
| Linhas/imagens carregadas antes de serem exibidas | 0 | 1 | 2 |
| Itens compostos antecipadamente em listas internas da Home | 0 | 1 | 2 |
| Blur em tempo real da barra lateral | Desativado | Mantido | Mantido |
| Movimento automático | Reduzido, intensidade sutil | Preferência atual | Preferência atual |
| Espera de foco estável antes de trailer | 1,5 s | 1,2 s | 1,2 s |

Isso reduz picos de CPU, heap e tráfego quando uma TV Box percorre a Home. As Homes Moderna e Clássica agora leem o limite de pré-carga de catálogo do perfil automático, evitando buscar a próxima linha antes de exibi-la em baixa RAM. Os trailers só iniciam depois de foco estável: 1,5 s em baixa RAM e 1,2 s nos demais perfis, evitando rede e uso do decoder durante navegação rápida. O cache em disco, os provedores, os formatos de vídeo e a resolução pedida pelos cards continuam seguindo as configurações existentes. No perfil de baixa RAM, a preferência padrão de movimento `FULL` é aplicada como `REDUCED`, e a intensidade padrão `STANDARD` como `SUBTLE`; escolhas explícitas `REDUCED`, `OFF` e `CINEMATIC` são preservadas. O perfil também troca o blur animado da barra lateral por sua superfície gradiente leve. A preferência salva não é alterada: o ajuste só vale enquanto o perfil automático do dispositivo estiver ativo.

## Seek e filmstrip do player

O mesmo perfil agora controla o custo do preview durante seek. Em aparelhos de baixa RAM (até 2 GiB ou sinalizados pelo Android), a captura mantém somente o frame central e o cache de bitmaps de seek fica limitado a 1 MiB. O perfil equilibrado habilita o filmstrip após 1,2 s sem novo seek e limita esse cache a 2 MiB. Alta capacidade mantém o filmstrip após 650 ms e até 4 MiB. Esses limites são tetos adicionais: a política ativa de cache ainda pode reservar menos. Capturas continuam sob demanda, em uma única lane Media3 separada da reprodução principal, limitada e cancelável.

Essa adaptação reduz decodificações especulativas, mas não desativa a thumbnail central; por isso, não deve ser interpretada como medição de fluidez ou de uso total de memória do aparelho. Na TV Box do usuário ainda faltam comparação real de FPS, heap, tempo de seek e dropped frames.

## Evidência e limites

Foram adicionados testes unitários para os tiers de baixa RAM, equilibrado e alta capacidade, incluindo a política de movimento, atraso de previews e preservação de `REDUCED`, `OFF` e `CINEMATIC`. A tentativa local `artifacts/tv-low-resource-r1/tv` usou um worker, sem emulador e heap Gradle de 1 GiB; o daemon entrou em coleta de lixo contínua ao compilar `fullDebug` e saiu com código 1 antes de registrar os testes. O GitHub Actions executou os filtros `TvPerformanceProfileTest`, `PlayerSourceSelectionStoreTest` e `com.nuvio.tv.updater.*`, compilou `fullDebug` e publicou o APK universal de depuração no run `39333239418`, commit `2a29d9087961cedffb4301539827fb00ea3f8dfe`; o workflow concluiu com sucesso. O APK de 178.466.176 bytes tem retenção de sete dias. Nenhum dispositivo Android estava conectado ao ADB; ainda falta medir na TV Box do usuário.

Para aceitar a melhoria no aparelho real, registrar modelo, versão do Android e RAM, depois comparar a abertura fria da Home e uma rolagem fixa antes/depois com `dumpsys meminfo`, `dumpsys gfxinfo` ou Perfetto. A classe por RAM é uma heurística inicial; resultados do aparelho real podem justificar ajustar os limites sem reduzir a compatibilidade de vídeo.

Na continuação de seek, o run `39338632273` passou `TvPerformanceProfileTest`, os testes selecionados de updater/fonte e `EmbeddedChapterMetadataTest`, compilou `compileFullDebugAndroidTestKotlin` e montou `fullDebug`. A alteração não executou os testes instrumentados nem substitui a medição física. O APK temporário e sua validade estão registrados em [telumia-tv-low-resource-r2-ci.json](telumia-tv-low-resource-r2-ci.json).
