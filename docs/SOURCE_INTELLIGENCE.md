# Source Intelligence

Estado: **seleção declarativa inicial implementada na TV e no Desktop. O incremento de inventário de decoder Android e ranking por codec foi publicado na pré-release `v1.0.1-alpha.3`; o CI passou e os assets foram conferidos na página pública. QA nativa dos modos continua pendente.**

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

## Incremento TV de decoder anunciado

No commit `ef14013a6` (com correções intermediárias já integradas à branch), `DeviceCapabilities.videoCodecCapabilities()` passou a enumerar e armazenar em cache decoders de vídeo anunciados por `MediaCodecList`. Cada registro mantém MIME, dimensões máximas quando reportadas e o estado de aceleração por hardware; falhas de consulta permanecem desconhecidas, e uma lista vazia reportada pelo Android é distinta de uma falha. A consulta ocorre em IO enquanto os addons carregam.

O seletor mapeia aliases estruturados de AVC/H.264, HEVC/H.265, AV1, VP8/VP9, MPEG-2 e Dolby Vision para MIME Android. Para os modos pontuados, um formato declarado sem decoder compatível com as dimensões anunciadas recebe penalidade de -600, mas segue elegível como fallback. Decoder apenas por software recebe -160 nos modos Equilibrado e Economia de dados; Melhor qualidade preserva a preferência por resolução. Codec sem declaração reconhecida e inventário desconhecido ficam neutros. `FIRST_STREAM`, Regex e a seleção Manual continuam com a política anterior.

O auto-play da reprodução atual e do próximo episódio consome o mesmo snapshot; os cards exibem a contribuição de compatibilidade e distinguem suportado, somente software, não anunciado e desconhecido em português e inglês. Esses dados são anúncios do provider e do framework Android: não provam que o bitstream real esteja íntegro, que o player selecionará aquele decoder, nem que HDR, áudio, legendas ou rede serão compatíveis. A lógica ainda não executa pre-flight real nem failover.

## Persistência e conta

Os modos novos usam `telumia_source_mode_v1` no DataStore existente de cada perfil. Não substituem silenciosamente `stream_auto_play_mode` compartilhado com o cliente original. Selecionar Manual/Primeira fonte/Regex remove o override local e atualiza a preferência legada. O filtro de configurações remotas exclui a chave nova em envio e recepção; não anuncia que o cliente oficial conhece esses modos.

## Resultados de verificação

O build inicial `telumia-tv-source-ranking-r1` encontrou e levou à correção de um fallback de locale em teste JVM; o CI remoto `39329340039` confirmou a correção. Para este incremento, o workflow [39509908598](https://github.com/Pepeu2010/telumia-tv/actions/runs/39509908598) concluiu com sucesso os testes focados, a compilação dos testes instrumentados e os três APKs Full Debug. O release publisher [39511555672](https://github.com/Pepeu2010/telumia-tv/actions/runs/39511555672) validou a origem dos artefatos, o MSI Desktop 1.0.0 e publicou `v1.0.1-alpha.3` com APK universal, ARM64, ARMv7, MSI e `SHA256SUMS.txt`. QA nativa dos novos modos continua pendente.

As regressões de TV cobrem escolha independente da ordem, qualidade versus equilíbrio, preferência por arquivos pequenos conhecidos, exclusão de páginas externas/debrid indisponível, empate com dados desconhecidos, filtros de addon, limites numéricos, isolamento da chave em sync e persistência/recriação/troca de perfil sem alterar o modo compartilhado. Seu run aprovado está registrado acima; QA nativa continua separada.

## Escopo ainda necessário

Faltam integração Desktop equivalente, HDR/áudio/legendas, preferência de idioma, bitrate com origem/unidade confiáveis, medições reais de latência/disponibilidade/estabilidade, pre-flight limitado e failover com posição e tentativas finitas. Também faltam QA visual/nativa dos novos modos e demonstração manual de playback em aparelhos reais. O score declarativo é uma camada inicial do recurso completo, não prova esses requisitos.

## Implementação Desktop e gate de testes

Fonte Desktop: implementação no commit `50b152b2`; validação da branch `codex/enhanced-foundation`, commit `c9cad5b0c0891763042640a20c9b1c43a23b60fc`. Não houve publicação de instaladores.

O seletor Desktop existente recebeu os três modos e pontuações correspondentes, respeitando sua própria elegibilidade de debrid/P2P e a preferência de grupo de episódios. Utiliza resolução estruturada e tamanho declarados; esse model não possui o `qualityValue` adicional da TV. Empates conservam a ordem e palavras de qualidade no nome não viram evidência. Os cards exibem contribuições localizadas; o picker de reprodução oferece os modos e passa a rolar suas opções para evitar cortar o diálogo em janelas menores.

O storage Desktop/JVM preserva o override local versionado durante recebimento de configurações remotas e exporta somente o modo legado. Os actuals Android/iOS do mesmo código KMP receberam a separação correspondente para não exportar uma preferência desconhecida pelo cliente original; isso não constitui build iOS/Android KMP aprovado. Não se cria um cliente móvel novo.

As regressões Desktop cobrem escolhas por modo, dados ausentes, ordem/filtros e sync em armazenamento isolado de teste. O run Windows `39487966669` executou `:composeApp:desktopTest` e verificou os relatórios XML de `StreamAutoPlaySelectorTest` e `PlayerSourceSelectionStorageTest`: ambas as classes executaram testes, sem falhas ou erros. O mesmo comando compilou as fontes Desktop e de teste.

O gate de portabilidade `39491977354`, no commit `9f8df1baf7476279425b031efdb7a812dfab30da`, passou em Linux x64, macOS x64 e ARM64: testes compartilhados, verificação do pacote nativo e produção de DEB/DMGs concluíram nos três runners. Manifests e checksums por pacote foram preservados nos artefatos de CI por 14 dias. A tentativa anterior `39489143656` teve uma falha transitória ao validar o launcher do DEB; a execução completa posterior confirmou Linux sem alterar o critério de validação.

O MSI ainda não foi produzido neste incremento. O workflow `build-only` parou antes da compilação por falta de `LOCAL_PROPERTIES_BASE64`, `SENTRY_AUTH_TOKEN` e `SENTRY_DESKTOP_DSN` no ambiente de release; a validação de testes usa um modo separado que não requer esses valores. Localmente, a reserva de armazenamento também bloqueou builds: C tinha 34,9 GiB livres ante os 40 GiB exigidos pela política. Nenhuma release 1.0.0 foi alterada. A seleção automática real, experiência no player e QA visual/nativa ainda precisam de gates próprios.
