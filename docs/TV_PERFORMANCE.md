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

Isso reduz picos de CPU, heap e tráfego quando uma TV Box percorre a Home. O cache em disco, os provedores, os formatos de vídeo e a resolução pedida pelos cards continuam seguindo as configurações existentes. No perfil de baixa RAM, a preferência padrão de movimento `FULL` é aplicada como `REDUCED`, e a intensidade padrão `STANDARD` como `SUBTLE`; escolhas explícitas `REDUCED`, `OFF` e `CINEMATIC` são preservadas. O perfil também troca o blur animado da barra lateral por sua superfície gradiente leve. A preferência salva não é alterada: o ajuste só vale enquanto o perfil automático do dispositivo estiver ativo.

## Evidência e limites

Foram adicionados testes unitários para os tiers de baixa RAM, equilibrado e alta capacidade, incluindo a política de movimento automático e a preservação de `REDUCED`, `OFF` e `CINEMATIC`. A tentativa local `artifacts/tv-low-resource-r1/tv` usou um worker, sem emulador e heap Gradle de 1 GiB; o daemon entrou em coleta de lixo contínua ao compilar `fullDebug` e saiu com código 1 antes de registrar os testes. O GitHub Actions executou os filtros `TvPerformanceProfileTest`, `PlayerSourceSelectionStoreTest` e `com.nuvio.tv.updater.*`, compilou `fullDebug` e publicou o APK universal de depuração no run `39331215450`, commit `25f1b08e42728152316b91b3076889649e68d156`; o workflow concluiu com sucesso. O APK de 178.464.404 bytes tem retenção de sete dias. Nenhum dispositivo Android estava conectado ao ADB; ainda falta medir na TV Box do usuário.

Para aceitar a melhoria no aparelho real, registrar modelo, versão do Android e RAM, depois comparar a abertura fria da Home e uma rolagem fixa antes/depois com `dumpsys meminfo`, `dumpsys gfxinfo` ou Perfetto. A classe por RAM é uma heurística inicial; resultados do aparelho real podem justificar ajustar os limites sem reduzir a compatibilidade de vídeo.
