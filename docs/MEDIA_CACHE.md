# Telumia — cache configurável por aparelho

Incremento nativo de 6 de outubro de 2026. Os dois clientes foram compilados e testados. A política central completa para todos os tipos de dados ainda não está concluída.

## Comportamento implementado no Desktop

No Desktop, 1 GiB é o default inicial do modo Auto, que adapta o orçamento à memória detectada e ao armazenamento disponível e mantém reserva de 2 GiB. Na TV, 256 MiB é o default inicial e o Auto considera memória e armazenamento, mantendo reserva de 256 MiB. Esses números são pontos de partida configuráveis, não limites rígidos finais. Manual permite escolher outro orçamento, respeitando o espaço disponível. A configuração pertence ao aparelho, em armazenamento Telumia versionado, e vale a partir da próxima abertura.

Os carregadores existentes de imagens/badges e o cache de GIFs usam quotas da política central. GIFs têm limites de bytes, quantidade e tamanho por entrada; nomes derivados de hash; substituição atômica e eviction por uso recente. Arquivos antigos de GIF são lidos e migrados sob demanda, sem exigir rede. Eles ainda precisam de contabilização/migração global para assegurar um teto sobre todo o legado.

Quando a reserva impede escrita, os carregadores preservam leitura dos caches disponíveis. Requests individuais de fundos/badges respeitam a política. Downloads, bookmarks, histórico, configurações e arquivos de usuário não pertencem às quotas de mídia. Os consumidores de cache são integrados por incrementos; confira o estado atualizado ao final deste documento. A fase ainda não contabiliza todos os caminhos legados nem cobre integralmente fluxos offline e QA físico.

Salvar uma preferência ocorre fora da thread de interface, desabilita novas edições durante a operação e mantém a seleção anterior se falhar. A gravação existente de preferências Desktop agora substitui o arquivo de maneira atômica quando suportado; um erro em `putString` restaura também o valor em memória.

## Gates Desktop

- 106 testes selecionados, sem falhas/erros/skips, e MSI real após revisão visual e correção do contraste do aviso de reinício.
- 13 testes adicionais de armazenamento/tema/persistência, sem falhas/erros/skips, com APPDATA temporário isolado. Uma primeira execução sem habilitar esse sandbox pulou corretamente o teste que protege o diretório real do usuário; a execução isolada cobriu esse teste.
- O runtime distribuído contém `java.management` e `jdk.management`, necessários à leitura da memória no JVM existente.
- [Resultados do cache](telumia-cache-results.json), [armazenamento isolado](storage-isolated-results.json) e [inspeção MSI](telumia-cache-desktop-package-inspection.json).

![Configuração Desktop](evidence/telumia-cache/desktop-cache-settings.png)

A captura usa um orçamento controlado para verificar os controles e a informação de que alterações exigem reinício. Não demonstra a operação completa do aplicativo offline nem o uso total de disco de todas as features.

## Continuidade obrigatória

A TV integra default de 256 MiB, Auto baseado em RAM/armazenamento, escolha Manual por D-pad e reserva de 256 MiB. Seus carregadores existentes de imagens/badges recebem quotas e política somente leitura quando a reserva impede escrita; backgrounds e revalidação respeitam a mesma política. A configuração é local ao aparelho, possui estado de gravação/erro e aplica mudanças na próxima abertura.

Passaram 96 testes unitários selecionados, sem falhas/erros/skips, e foram gerados os cinco APKs e o APK de instrumentação. Nove testes nativos em 720p/1080p/4K verificaram D-pad, seleção Manual/Auto, persistência real em SharedPreferences e fallback de schema futuro. Capturas e hashes estão na [instrumentação TV](telumia-cache-tv-ui-qa.json); a [inspeção dos APKs](telumia-cache-tv-package-inspection.json) registra sua identidade própria.

![Cache TV 720p](evidence/telumia-cache/tv-cache-settings-720.png)
![Cache TV 4K](evidence/telumia-cache/tv-cache-settings-2160.png)

Ainda faltam contabilização global dos caches legados, integração de PREVIEWS e da quota SCENE_INFO, validação de armazenamento antes de baixar imagens, revisão de arquivos/URLs, fluxos offline reais e QA físico. Fundos remotos e avatares de membros já usam quotas; thumbnails e filmstrip têm consumidores integrados à timeline, e EPG usa quota na TV. O índice de timed metadata não substitui uma cache de dados enriquecidos de Scene Info.

Esta entrega não encerra a Fase 1-D nem a [meta integral](GOAL_OBJECTIVE_2026-10-05.md). A release `0.2.0-alpha.1` não inclui essas mudanças.

## Contabilização e proteção de versões futuras — 7 de outubro

O snapshot de armazenamento agora inclui o tamanho dos arquivos nos diretórios conhecidos de mídia. No PC, mede as categorias de `media-cache-v1` e os GIFs legados. Na TV, mede `image_cache` e `badge_cache`, usados pelos carregadores existentes. A política Auto recebe esses bytes junto com o espaço livre: preencher o próprio cache não passa a parecer uma perda equivalente de capacidade do aparelho na próxima abertura.

A medição apenas lê atributos de arquivo. Não percorre diretórios pessoais, downloads ou o armazenamento durável de avatares. Ignora symlinks/junctions, verifica o destino dos caminhos e evita contabilizar duas vezes arquivos com a mesma identidade. Possui limites de 16.384 entradas, oito níveis e 100 ms entre operações de filesystem; se uma leitura falhar ou atingir um limite, conserva a soma parcial como estimativa conservadora. Esses bytes representam tamanhos lógicos dos arquivos, não uma medição de blocos físicos do volume. O snapshot continua valendo durante a sessão; adaptação dinâmica e isolamento completo de IO da thread principal seguem pendentes.

Clientes antigos usam defaults na leitura de uma configuração com schema desconhecido, mas recusam sua gravação. O PC também conserva documentos JSON ilegíveis; a TV conserva schemas com tipo incompatível. O erro mantém a preferência anterior na interface. Testes TV agora usam SharedPreferences e diretórios temporários próprios, sem alterar a configuração pessoal do aplicativo.

No PC, passaram inicialmente 163 testes selecionados e o MSI foi gerado em fonte limpa. O pacote desse incremento foi preservado antes das mudanças seguintes. [Vínculo de fonte/build](telumia-cache-occupancy-desktop-build-binding.json) e [inspeção MSI](telumia-cache-occupancy-desktop-package-inspection.json). O conjunto posterior de cache/tipografia passou 168 testes, sem falhas/erros/skips, e preservou outro MSI sobre a fonte limpa. [Vinculação final Desktop](telumia-native-fonts-desktop-bound-build-binding.json).

A contabilização expôs um caso em que somar o cache ocupado ainda concedia escrita quando o espaço livre real estava abaixo da reserva. A política agora concede zero bytes de escrita nessa situação, em Auto e Manual, preservando a leitura dos dados disponíveis. O defeito foi reproduzido no JAR compilado anterior e a correção foi executada no JAR novo com as mesmas entradas controladas. [Reprodução antes/depois](telumia-cache-reserve-reproduction.json). Isso não equivale a encher o disco de um aparelho real.

Na TV, passaram 120 testes unitários selecionados, sem falhas/erros/skips, e foram gerados os cinco APKs e o APK de testes sobre a fonte limpa. Dezesseis testes nativos, oito em cada versão Android API 24 e 36, verificaram persistência, recusa de schema futuro/tipo incompatível, contabilização real nos diretórios conhecidos, exclusão de symlink/dados duráveis, limite de entradas, D-pad e recursos/pesos nativos da fonte. Os hashes vinculam a instrumentação aos APKs preservados. [QA nativa](telumia-cache-occupancy-tv-native.json), [build e pacotes](telumia-native-fonts-tv-build-binding.json). A tentativa anterior passou 118 testes e gerou os APKs do aplicativo, mas falhou ao compilar o APK de testes por usar `Os.unlink`, oculto no SDK público; o fixture foi corrigido para a remoção NIO sem seguir o link.

A TV usa a variante NIO do desugaring para disponibilizar a iteração de diretórios também nas APIs 24/25 suportadas. [Documentação oficial Android](https://developer.android.com/studio/write/java11-nio-support-table). A compatibilidade de todos os fluxos do aplicativo nessas versões não pode ser deduzida apenas da compilação.

Essas alterações são posteriores à publicação `v0.2.1-alpha.1`; seus binários publicados permanecem preservados. A integração completa dos consumidores e o QA offline continuam obrigatórios.

## Integração do cache de avaliações MDBList na TV — 27 de outubro

O cache em disco de avaliações MDBList agora usa a categoria `METADATA` da política central na TV. A gravação fica limitada pela quota disponível e por 8 MiB por arquivo, expira após 12 horas, mantém no máximo 25 mil entradas em memória e executa leitura/gravação fora da thread de interface. O leitor rejeita arquivos maiores que 8 MiB. A migração lê o cache antigo em `filesDir` uma vez e o remove; em modo somente leitura, os dados ainda podem ser lidos e não recebem novas gravações.

Os 5 testes de `MdbListRatingsDiskCacheTest` e 11 de `MdbListRatingsLoaderTest` passaram. Foram compilados os cinco APKs Full Debug e o APK de instrumentação. O identificador desses APKs termina em `.debug`; não são pacotes para atualizar instalações de produção nem foram publicados como release. O cliente Desktop não teve mudança de fonte: 12 testes selecionados de política/ocupação passaram junto com `desktopJar` e `packageMsi`, como gate cruzado da mesma entrega. Nenhum teste foi executado em hardware físico, portanto fluidez e impacto em aparelhos reais permanecem sem medição.

Fonte: branch `codex/1d-tv-mdblist-cache-quota`, commit `dc92702ef6977ff9b210a05a8c7244bec622a8c9`; [PR #4](https://github.com/Pepeu2010/telumia-tv/pull/4), vinculado à aprovação [telumia#10](https://github.com/Pepeu2010/telumia/issues/10). Pacotes, versões, tamanhos, hashes e comandos estão em [telumia-cache-metadata-tv-r1-build.json](telumia-cache-metadata-tv-r1-build.json). Este é um recorte parcial: ainda faltam os outros consumidores de cache, adaptação durante a sessão e QA de fluxos offline; a Fase 1-D segue aberta.

## Quotas de cache HTTP na TV e no Desktop — 27 de outubro

Os dois caches OkHttp da TV deixaram de usar o limite fixo de 50 MiB. `http_cache_v2` usa a quota `HTTP` e continua separado de `addon_http_cache`, que usa `ADDONS`. `METADATA` permanece independente para caches como o arquivo de avaliações MDBList. O cliente Desktop também passou a ter um cache HTTP isolado para GETs de addons, sob `media-cache-v1/addons/http`.

As shares centrais agora são: imagens 40%, badges 4%, avatares 6%, previews 10%, thumbnails 8%, filmstrip 4%, metadata 10%, HTTP 5%, addons 5%, EPG 5% e Scene Info 3%. A soma é 100% nos dois clientes. Com os defaults iniciais, antes dos ajustes Auto por aparelho/armazenamento, `HTTP` e `ADDONS` começam em 12,8 MiB cada na TV e 51,2 MiB cada no Desktop. O total continua configurável; esses valores não são limites fixos por dispositivo. A redução de imagens de 50% para 40% abre espaço para os novos consumidores dentro da mesma partilha total.

O Auto passou a incluir as pastas `http_cache_v2`, `addon_http_cache`, `metadata` e `http_cache` da TV. `http_cache` é uma pasta legada que pode conter respostas do antigo cliente permissivo; ela só é medida por atributos e nunca é migrada, aberta pelo cliente first-party ou apagada por esta política. No Desktop, o cache usa a pasta da categoria `ADDONS`, que já faz parte da enumeração allowlisted. Downloads, arquivos pessoais e dados duráveis seguem fora da medição.

Em modo somente leitura, a política de rede marca a resposta recebida da rede com `Cache-Control: no-store`, inclusive para erros HTTP 4xx/5xx; um hit existente continua sendo servido sem passar pelo interceptor de rede. As duas origens continuam em diretórios separados. No Desktop, o OkHttp só grava GETs quando os cabeçalhos do servidor permitem; POSTs não entram no cache. Nenhum `max-age` artificial foi adicionado.

Passaram 17 testes focados de TV e 9 testes focados de Desktop. Os cinco APKs Full Debug e o MSI Windows x64 foram compilados. Os APKs têm application ID `.debug`, portanto servem para validação e não atualizam a instalação de produção. Não houve teste de desempenho em hardware físico e os pacotes deste incremento não foram publicados em release. O código TV está no commit `860ac552` / [PR #6](https://github.com/Pepeu2010/telumia-tv/pull/6); Desktop `29ff6916` / [PR #2](https://github.com/Pepeu2010/telumia-desktop/pull/2), ambos ligados à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Tamanhos, versões, comandos e SHA-256 estão em [telumia-cache-http-tv-desktop-r3-build.json](telumia-cache-http-tv-desktop-r3-build.json).

Incremento parcial: a Fase 1-D continua aberta para os demais consumidores de cache, adaptação durante a sessão, fluxos offline reais e QA em hardware. A política não prova que toda ocupação de disco histórica já tenha sido contabilizada.

## Caches TMDB limitadas por tier de memória — 27 de outubro

As sete caches em memória de `TmdbMetadataService` agora usam LRU separado e tetos por tier do `DeviceCapabilities`: LOW_RAM/UNKNOWN 62 entradas no total, BALANCED 124 e HIGH_CAPACITY 248. Os tetos individuais por tipo constam na [documentação do cliente TV](https://github.com/Pepeu2010/telumia-tv/blob/codex/1d-tv-tmdb-memory-cache/docs/TMDB_METADATA_CACHE.md). Eviction libera respostas antigas e uma consulta futura pode buscar novamente a metadata. As caches de requisições em voo mantêm sua função de coalescência.

Passaram 31 testes direcionados (3 de LRU/concorrência, 2 de seleção por tier e 26 de `TmdbMetadataService`). A suíte completa executou 2.058 testes, 13 falharam e 1 foi ignorado. As mesmas 13 falhas nas mesmas 10 classes foram reproduzidas em 88 testes focados no commit-base `e1e7d992c4ee1d9ccf9904e0ef54b0e8f23efd2f`; portanto já existiam antes deste incremento. O registro com nomes, resultados e hashes está em [telumia-cache-tmdb-tv-r2-build.json](telumia-cache-tmdb-tv-r2-build.json).

Os cinco APKs foram compilados com package ID `io.github.pepeu2010.telumia.tv.debug`; servem apenas para validação. No Desktop, que não teve mudança de fonte, os testes selecionados e o empacotamento MSI retornaram sucesso como tarefas `UP-TO-DATE`. Nenhuma medição de heap/jank ou teste de desempenho físico foi feita; as capacidades são limites iniciais por quantidade de entradas e são avaliadas ao criar o serviço. O incremento não conclui a Fase 1-D nem publica release.

## Reavaliação automática do orçamento durante a sessão — 27 de outubro

A política Auto agora atualiza a amostra de armazenamento sob demanda, no máximo uma vez a cada 15 segundos; não inicia polling contínuo em segundo plano. Os caches HTTP da TV e de addons Desktop suspendem novas gravações se a quota recalculada ficar abaixo da cota com que a instância foi aberta. Hits já existentes continuam legíveis. Os caches de arquivo que consultam quota a cada gravação passam a receber o orçamento atual.

A API do OkHttp fixa o tamanho máximo ao construir `Cache`. Por isso, uma queda de quota pausa novas respostas em cache sem remover as antigas; o espaço já ocupado pode continuar acima da nova quota, pois esta alteração não limpa hits automaticamente. Aumento do teto da instância também requer reabertura do app. Os caches de imagem Coil são igualmente dimensionados na construção do loader e ainda não são redimensionados em execução. Alterações manuais permanecem aplicadas na próxima abertura.

A alteração passou 10 testes direcionados em cada cliente. No Windows, `desktopJar` e MSI compilaram; na TV, cinco APKs Full Debug compilaram. O universal foi inspecionado como `io.github.pepeu2010.telumia.tv.debug`, versionCode 10008, versão `1.0.2-alpha.3`. Os APKs são validação e não atualizam o aplicativo de produção. Nenhum pacote foi publicado nesta etapa e não houve QA em TV Box/PC físico ou medição de jank/consumo.

TV: commit `a66e237ffecb5767c36174b796fa9c2661eee0dc`, [PR #7](https://github.com/Pepeu2010/telumia-tv/pull/7) sobre [PR #6](https://github.com/Pepeu2010/telumia-tv/pull/6). Desktop: `4168dcb81bf20fb66d8d95537b0e663d6a723181`, [PR #3](https://github.com/Pepeu2010/telumia-desktop/pull/3) sobre [PR #2](https://github.com/Pepeu2010/telumia-desktop/pull/2). Os dois permanecem abertos e vinculados à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comandos, tamanhos e SHA-256: [registro de build](telumia-cache-dynamic-budget-tv-desktop-r1-build.json).

A Fase 1-D permanece aberta para integrar e validar os demais consumidores, cobrir fluxos offline reais e fazer QA de desempenho em hardware. O intervalo de 15 segundos limita a frequência de amostra, mas não substitui uma medição física de armazenamento, jank ou consumo.

## Cache de avatares remotos de membros na TV — 27 de outubro

O cache remoto `cacheDir/member_profile_avatars` agora entra na categoria `AVATARS` (6% da partilha central) e na estimativa de ocupação Auto. Cada arquivo tem limite de 2 MiB; o diretório mantém no máximo 256 entradas e respeita o orçamento reavaliado. Ao escrever, usa arquivo temporário, renomeação atômica e eviction LRU. Os downloads autenticados simultâneos são limitados a dois.

Hits anteriores no mesmo diretório e nomes versionados continuam legíveis quando a gravação fica suspensa. A evicção por quota preserva o arquivo usado mais recentemente. Avatares que a pessoa importou ou editou no armazenamento durável local não participam do cache e não são apagados. Uma redução automática sem nova gravação não remove imediatamente os hits já guardados; o aparo ocorre na próxima gravação.

A API Supabase já usada por este cliente devolve o arquivo inteiro em `ByteArray`. A aplicação rejeita dados vazios ou acima de 2 MiB antes de escrevê-los em disco, mas o corpo remoto já foi materializado em memória. Limitar bytes antes dessa alocação exigirá uma API de streaming suportada pelo SDK; este incremento preserva a chamada atual.

Passaram 24 testes unitários TV (cache de avatares, política, ocupação e interceptor HTTP), sem falhas/erros/skips; os cinco APKs Full Debug foram compilados. No Desktop, sem mudanças de fonte, passaram 10 testes de política/HTTP e `desktopJar`/`packageMsi` concluíram. Os APKs continuam com ID `.debug`, e nenhum pacote foi publicado ou testado em hardware físico. Versões, tamanhos, hashes e comandos estão no [registro do build](telumia-cache-avatar-tv-r1-build.json).

TV: branch `codex/1d-tv-member-avatar-cache-quota`, commit `d0b31840b012b8af6ff1de4c987f738b2b198907`, [PR #8](https://github.com/Pepeu2010/telumia-tv/pull/8), empilhado sobre [PR #7](https://github.com/Pepeu2010/telumia-tv/pull/7). O MSI Desktop foi um gate cruzado sem alterações de fonte. A Fase 1-D ainda requer a integração dos demais caches, validação dos fluxos offline e QA em PC/TV Box físicos.

## Cache remoto de avatar no Desktop — 27 de outubro

O cliente Desktop agora grava avatares autenticados em `media-cache-v1/avatars/member-assets`, sob a categoria `AVATARS`. Os identificadores ficam somente como hash no nome do arquivo; cada entrada tem limite de 2 MiB e o diretório comporta até 256 arquivos, com eviction LRU e gravação atômica. A leitura retorna uma URI local compatível com o carregador existente, inclusive em modo somente leitura. Avatares remotos antigos em `member_profile_avatars` continuam legíveis e são migrados apenas depois que a entrada nova é validada. Os diretórios legados de avatar e fundo são contados pelo Auto; o cache legado de fundos ainda precisa ser limitado em outro incremento.

A busca do catálogo de avatares de membros limita a dois downloads autenticados simultâneos. O SDK Supabase ainda devolve o conteúdo como `ByteArray`; acima de 2 MiB os bytes são descartados antes da gravação, após já estarem alocados em memória. A API de streaming não foi alterada.

No Desktop, passaram 15 testes focados: `BoundedFileCacheTest` (5), `MediaCachePolicyTest` (7) e `AddonHttpCacheTest` (3). `desktopJar` e `packageMsi` passaram. O MSI Windows x64 teve 210.911.336 bytes, igual ao tamanho do pacote de referência anterior; seu SHA-256 é `141957377F4AE9676BF7FA1E38434DEC72B70A46C967FFE4ECCFDE884015D327`. Não houve medição em PC físico.

O alvo Android opcional deste repositório foi compilado até `compileAndroidMain`, que falhou em referências de pointer de arquivos não alterados: `PointerButton`/`button` em `MainAppContent.kt` e `PlayerScreenContent.kt`, e `onPointerEvent` em `HomePosterHoverPreview.kt`. O APK TV é construído pelo repositório próprio `telumia-tv`; seu gate cruzado de 24 testes e cinco APKs Full Debug passou no commit TV `d0b31840b012b8af6ff1de4c987f738b2b198907`. APKs Debug são somente validação e não foram publicados.

Desktop: branch `codex/1d-desktop-member-asset-cache-quota`, commit `6abb8401f20ebd6db50e9268310f7ab81d87fc31`, [PR #4](https://github.com/Pepeu2010/telumia-desktop/pull/4) sobre [PR #3](https://github.com/Pepeu2010/telumia-desktop/pull/3). Ambos os clientes continuam ligados à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). O [registro do Desktop](telumia-cache-avatar-desktop-r1-build.json) contém comandos e checksums dos pacotes TV usados no gate cruzado. A Fase 1-D segue aberta para os demais consumidores, fluxos offline e QA físico.

## Cache remoto de fundos de perfil — 27 de outubro

O cache de imagens de fundo remoto dos perfis passou a ter quota dedicada, dentro da categoria `IMAGES`, nos dois clientes. Na TV, 90% da parcela `IMAGES` fica para Coil e 10% para fundos remotos. No Desktop, a divisão é Coil 80%, GIFs 10% e fundos remotos 10%, impedindo que cada consumidor use a parcela inteira de forma independente.

Cada fundo remoto pode ocupar até 8 MiB; cada cache mantém no máximo 64 arquivos, aplica LRU e exige a reserva de armazenamento livre já definida para o aparelho. A gravação é atômica. Hits existentes seguem legíveis sem gravação; arquivos antigos continuam elegíveis para leitura e só são removidos depois de migração confirmada no cache limitado. A ocupação automática mede os diretórios antigos e novos. Downloads autenticados concorrentes continuam limitados a dois.

A API Supabase atual materializa cada resposta completa como `ByteArray`; o teto de 8 MiB evita a gravação de dados maiores, mas é verificado depois da alocação. No Desktop, o catálogo guardava bytes das imagens carregadas em memória mesmo após a cópia para disco. Esse estado em memória e os downloads em massa foram limitados no incremento seguinte, documentado abaixo.

Passaram 26 testes focados de TV e 24 do Desktop, sem falhas, erros ou skips. `:app:assembleFullDebug` gerou cinco APKs Full Debug; `:composeApp:desktopJar` e `:composeApp:packageMsi` passaram. O MSI Windows x64 tem 210.919.528 bytes e SHA-256 `3A8C1D412386FCECF48EA0D2976C2A349AA27FFC32D13CBB1A64F4D6ACB105FE`. Os APKs têm ID `.debug`, servem para validação e não atualizam a instalação de produção. Nenhum pacote foi publicado e não houve medição em aparelho físico.

TV: branch `codex/1d-tv-member-background-cache-quota`, commit `42d66acd2f38906b3cf5a736b4d4b0dfbc3a5787`, [PR #9](https://github.com/Pepeu2010/telumia-tv/pull/9) sobre [PR #8](https://github.com/Pepeu2010/telumia-tv/pull/8). Desktop: branch `codex/1d-desktop-member-background-cache-quota`, commit `e7ff92e6242b8c98ceea2df671cb54ecc5b7997d`, [PR #5](https://github.com/Pepeu2010/telumia-desktop/pull/5) sobre [PR #4](https://github.com/Pepeu2010/telumia-desktop/pull/4). Ambos ligados à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comandos, cinco APKs, MSI, tamanhos e hashes: [registro da TV](telumia-cache-profile-backgrounds-tv-desktop-r1-build.json) e [registro do Desktop](telumia-cache-profile-backgrounds-desktop-r1-build.json).

Incremento parcial. A Fase 1-D segue aberta para limitar também memória/preload no Desktop, integrar os outros consumidores, validar fluxos offline e fazer QA de desempenho em PC e TV Box físicos.

## Limite de memória para fundos de perfil no Desktop — 27 de outubro

Quando há cache local, o catálogo agora mantém URI de arquivo, sem copiar cada imagem inteira para `StateFlow`. Abrir o seletor apenas carrega caminhos locais já disponíveis; a rede é acessada ao abrir um perfil ou escolher um fundo. Se a gravação em disco estiver indisponível, um LRU conserva bytes até 8 MiB quando a RAM é desconhecida/baixa, 24 MiB até 4 GiB e 48 MiB acima disso. Os downloads seguem limitados a dois por vez, e cada resposta é aceita até 8 MiB.

O teste Desktop passou 20 casos focados de policy, ocupação, memória LRU e seleção de fundo, sem falhas/erros/skips. `desktopJar` e MSI passaram. MSI Windows x64: 210.923.624 bytes; SHA-256 `B9720A6E0C1F0B543341AC4A1A4022B2D0547432525E2BD6E57EE56E03A44D80`. Nenhum APK foi produzido neste repositório. A tentativa Android falhou antes de empacotar, nos erros de ponteiro preexistentes em `MainAppContent.kt`, `HomePosterHoverPreview.kt` e `PlayerScreenContent.kt`, que não foram alterados. O host Windows não compila os alvos iOS. Sem QA físico e sem release.

Desktop: branch `codex/1d-desktop-profile-background-memory-budget`, commit `9c195c96fc401eea7691f86ff6e9a4d9cdcad541`, [PR #6](https://github.com/Pepeu2010/telumia-desktop/pull/6) sobre [PR #5](https://github.com/Pepeu2010/telumia-desktop/pull/5), ligado à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comando, resultados, falha Android e checksum estão no [registro de build](telumia-profile-background-memory-desktop-r1-build.json).

Incremento parcial; a Fase 1-D segue aberta para integrar os demais consumidores ainda sem quota própria, testar fluxos offline e fazer QA de desempenho em PC e TV Box físicos.

## Cache de legendas por aparelho — 27 de outubro

A TV integra arquivos de legendas externas e sidecars normalizados do MPV à categoria `SUBTITLES`, com 2% do orçamento atual de cache. A categoria `IMAGES` passa de 40% para 38%, mantendo a soma de todas as shares em 100%. A resposta HTTP é lida em streaming e rejeitada acima de 4 MiB antes da materialização completa; a escrita também aplica 4 MiB por arquivo, no máximo 64 arquivos, quota agregada atual, reserva de armazenamento e substituição atômica. Quando cache local não é permitido, a reprodução pode continuar pela URL externa original.

O cliente Desktop não possui esse cache runtime de arquivos de legenda; ele recebe a mesma política compartilhada para manter a alocação consistente entre plataformas. A Fase 1-D continua aberta: PREVIEWS, quota SCENE_INFO, legado global, fluxos offline completos e QA físico permanecem pendentes.

TV: commit `34ff591411ac039db5e3cc770a76a25b398d4e51`, [PR #10](https://github.com/Pepeu2010/telumia-tv/pull/10) sobre [PR #9](https://github.com/Pepeu2010/telumia-tv/pull/9). Desktop: commit `adfa1b38a9452cb5dc6c40db8b58c8dd05590127`, [PR #7](https://github.com/Pepeu2010/telumia-desktop/pull/7) sobre [PR #6](https://github.com/Pepeu2010/telumia-desktop/pull/6). Ambos são draft e vinculados à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Os 13 testes unitários TV, 9 testes Desktop, 2 execuções instrumentadas (AVD Android TV API 33 e dispositivo Android conectado), cinco APKs `1.0.2-alpha.3` Full Debug, JAR e MSI Windows passaram. Os APKs têm ID `.debug`; nenhum pacote foi publicado ou é atualizador da instalação de produção. Hashes, comandos, dimensões e limites constam no [registro de build](telumia-cache-subtitles-tv-desktop-r1-build.json). Não houve medição de fluidez ou memória sustentada em TV Box/PC físico.

## Cache de artes em previews — 27 de outubro

Artes e logos que só aparecem em previews expandidos da TV e no hover preview do Desktop usam a categoria configurável `PREVIEWS`, com quota inicial de 10% do orçamento por aparelho. O loader Coil de preview tem diretório próprio; pôsteres da navegação normal permanecem em `IMAGES`. Requests de preview não mantêm uma segunda cópia no memory cache. Na TV, o cliente HTTP continua compartilhado e a revalidação invalida o loader que recebeu a imagem. A ocupação de `PREVIEWS` entra no cálculo automático da TV; o Desktop já mede as categorias por diretório.

TV: 20 testes unitários direcionados passaram e cinco APKs Full Debug foram gerados. O XML do teste instrumentado no AVD Android TV API 33 registra 1/1 aprovado, incluindo loader e diretório separados. O runner encerrou o teste, mas o Gradle não concluiu a coleta final; o processo foi cancelado após conferir o XML. Desktop: 10 testes de política passaram, junto com `desktopJar` e MSI Windows x64. O MSI de validação tem 210.927.720 bytes e SHA-256 `70156FD59E0E59FB99E0D709DBDF939D78A1F619A078CE16223C1B3C5B7D5C5B`. Os cinco APKs, IDs, hashes, comandos e branches estão no [registro deste marco](telumia-cache-previews-tv-desktop-r1-build.json).

Nenhum binário foi publicado. Os APKs têm application ID `.debug` e não atualizam instalações públicas. O MSI é somente artefato de validação; não houve teste de atualização, medição sustentada de jank/memória nem QA em TV Box ou PC físico.

TV: commit `fdf69cead6809c825d5f2c3953cf3e0db280355c`, [PR draft #11](https://github.com/Pepeu2010/telumia-tv/pull/11) sobre [#10](https://github.com/Pepeu2010/telumia-tv/pull/10). Desktop: commit `ed13fa8722dab1728442a8778478d68cce872ae2`, [PR draft #8](https://github.com/Pepeu2010/telumia-desktop/pull/8) sobre [#7](https://github.com/Pepeu2010/telumia-desktop/pull/7). Ambos ligados à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). A Fase 1-D segue aberta para a quota `SCENE_INFO`, contabilização global do legado, fluxos offline reais e QA físico.
