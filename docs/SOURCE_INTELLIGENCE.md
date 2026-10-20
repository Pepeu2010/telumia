# Source Intelligence

Estado: **seleção declarativa inicial implementada na TV e no Desktop; os testes dirigidos de ambos os clientes passaram no CI, mas QA nativa dos modos continua pendente**. Não é a entrega completa de Source Intelligence e não altera os binários da release 1.0.0.

Fonte: `repos/tv`, commit `f655a5802`, ampliando `StreamAutoPlaySelector`, `StreamAutoPlayPolicy`, `PlayerSettingsDataStore`, as configurações de reprodução e a lista de fontes existentes. Não cria outro player, repositório ou resolver.

## Comportamento implementado

O seletor mantém filtros de addon/plugin, exclusão de páginas externas e estados de debrid indisponíveis, prioridade de grupo de episódios configurada pelo usuário e desempate pela ordem original das fontes. A coleta continua usando a janela/timeout de seleção já configurada: a recomendação considera as fontes disponíveis naquela janela, não promete conhecer providers que ainda não responderam.

| Modo | Regra deste incremento |
| --- | --- |
| Melhor qualidade | Prefere maior resolução declarada reconhecida; cache debrid declarado contribui 10 pontos. |
| Equilibrado | Resolução declarada 1080p contribui 120 pontos, 720/800p 100, resoluções superiores 70, inferiores 50. Cache declarado contribui 10. |
| Economia de dados | Até 720p contribui 120 pontos, até 1080p 50, superiores 10. Tamanho positivo conhecido contribui até 80 pontos, decrescendo por blocos de 256 MiB; cache declarado contribui 10. |
| Manual | Conserva a escolha existente e sua preferência explícita de continuidade por grupo de episódios. |

Primeira fonte e Regex continuam disponíveis como opções avançadas existentes. A pontuação usa somente resolução estruturada do provider ou `qualityValue` existente, tamanho declarado positivo e estado de cache debrid. Não lê credenciais ou URLs para pontuar, não interpreta palavras publicitárias no nome como evidência e limita valores para evitar overflow. Informações ausentes são neutras; tamanho desconhecido não recebe o bônus reservado a tamanho conhecido. Não calcula bitrate a partir de duração com unidade desconhecida.

Os cards exibem a pontuação e suas contribuições quando um modo novo está ativo. A própria UI identifica que codec, HDR e rede não foram verificados. O picker existente oferece os modos com descrições pt-BR/inglês, preservando navegação/foco atuais; a geometria e a interação ainda precisam de QA no APK deste incremento.

## Persistência e conta

Os modos novos usam `telumia_source_mode_v1` no DataStore existente de cada perfil. Não substituem silenciosamente `stream_auto_play_mode` compartilhado com o cliente original. Selecionar Manual/Primeira fonte/Regex remove o override local e atualiza a preferência legada. O filtro de configurações remotas exclui a chave nova em envio e recepção; não anuncia que o cliente oficial conhece esses modos.

## Resultados de verificação

O build `telumia-tv-source-ranking-r1` terminou com saída 1: **47 testes, uma falha, zero erros e zero ignorados**. O snapshot `artifacts/telumia-tv-source-ranking-r1/tv/junit-snapshot/TEST-com.nuvio.tv.data.local.PlayerSourceSelectionStoreTest.xml` identificou a falha: `Resources.getSystem()` retorna nulo no ambiente JVM do teste, e a resolução do idioma de legendas não tinha fallback. `PlayerSettingsDataStore.resolveDeviceSubtitleLanguage` agora usa `Locale.getDefault()` quando a configuração Android não existe. O rerun local `artifacts/tv-low-resource-r1/tv` não teve heap suficiente e terminou durante `compileFullDebugKotlin`. Depois, o run remoto `39329340039` executou `PlayerSourceSelectionStoreTest` junto dos testes da política de desempenho, dos testes do updater e da montagem `fullDebug`; **o workflow concluiu com sucesso**, validando o fallback do locale e os testes selecionados. QA nativa dos novos modos continua pendente.

As regressões de TV cobrem escolha independente da ordem, qualidade versus equilíbrio, preferência por arquivos pequenos conhecidos, exclusão de páginas externas/debrid indisponível, empate com dados desconhecidos, filtros de addon, limites numéricos, isolamento da chave em sync e persistência/recriação/troca de perfil sem alterar o modo compartilhado. Seu run aprovado está registrado acima; QA nativa continua separada.

## Escopo ainda necessário

Faltam DeviceCapabilities centralizado, adequação de codec/decoder/HDR/áudio/legendas, preferência de idioma, bitrate com origem/unidade confiáveis, medições reais de latência/disponibilidade/estabilidade, pre-flight limitado e failover com posição e tentativas finitas. Também faltam QA visual/nativa dos novos modos e demonstração pelo caminho real de reprodução com seleção automática. O score declarativo é uma camada inicial do recurso completo, não prova esses requisitos.

## Implementação Desktop e gate de testes

Fonte Desktop: implementação no commit `50b152b2`; validação da branch `codex/enhanced-foundation`, commit `c9cad5b0c0891763042640a20c9b1c43a23b60fc`. Não houve publicação de instaladores.

O seletor Desktop existente recebeu os três modos e pontuações correspondentes, respeitando sua própria elegibilidade de debrid/P2P e a preferência de grupo de episódios. Utiliza resolução estruturada e tamanho declarados; esse model não possui o `qualityValue` adicional da TV. Empates conservam a ordem e palavras de qualidade no nome não viram evidência. Os cards exibem contribuições localizadas; o picker de reprodução oferece os modos e passa a rolar suas opções para evitar cortar o diálogo em janelas menores.

O storage Desktop/JVM preserva o override local versionado durante recebimento de configurações remotas e exporta somente o modo legado. Os actuals Android/iOS do mesmo código KMP receberam a separação correspondente para não exportar uma preferência desconhecida pelo cliente original; isso não constitui build iOS/Android KMP aprovado. Não se cria um cliente móvel novo.

As regressões Desktop cobrem escolhas por modo, dados ausentes, ordem/filtros e sync em armazenamento isolado de teste. O run Windows `39487966669` executou `:composeApp:desktopTest` e verificou os relatórios XML de `StreamAutoPlaySelectorTest` e `PlayerSourceSelectionStorageTest`: ambas as classes executaram testes, sem falhas ou erros. O mesmo comando compilou as fontes Desktop e de teste.

O gate de portabilidade `39491977354`, no commit `9f8df1baf7476279425b031efdb7a812dfab30da`, passou em Linux x64, macOS x64 e ARM64: testes compartilhados, verificação do pacote nativo e produção de DEB/DMGs concluíram nos três runners. Manifests e checksums por pacote foram preservados nos artefatos de CI por 14 dias. A tentativa anterior `39489143656` teve uma falha transitória ao validar o launcher do DEB; a execução completa posterior confirmou Linux sem alterar o critério de validação.

O MSI ainda não foi produzido neste incremento. O workflow `build-only` parou antes da compilação por falta de `LOCAL_PROPERTIES_BASE64`, `SENTRY_AUTH_TOKEN` e `SENTRY_DESKTOP_DSN` no ambiente de release; a validação de testes usa um modo separado que não requer esses valores. Localmente, a reserva de armazenamento também bloqueou builds: C tinha 34,9 GiB livres ante os 40 GiB exigidos pela política. Nenhuma release 1.0.0 foi alterada. A seleção automática real, experiência no player e QA visual/nativa ainda precisam de gates próprios.
