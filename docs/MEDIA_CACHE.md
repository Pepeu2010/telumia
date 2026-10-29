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

Estado após as continuações registradas: `PREVIEWS` e a pré-checagem de espaço nos loaders de imagem já foram integrados, assim como thumbnails, filmstrip e o cache EPG na TV. Ainda faltam concluir a auditoria global dos caminhos legados/regeneráveis, a revisão das gravações de arquivos e URLs, validar fluxos offline reais e fazer QA em PC/TV Box físicos. A categoria `SCENE_INFO` continua sem um cache persistente de fatos de cena legítimo para conectar à quota; o Scene Info R1 atual projeta fatos temporais fornecidos por providers, então não se cria uma gravação em disco artificial apenas para consumir a categoria.

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

## Migração resiliente do cache legado MDBList na TV — 27 de outubro

A migração do arquivo legado `filesDir/mdblist_cache/ratings_v1.json` agora só o remove depois que uma cópia válida em `cacheDir/metadata/mdblist` foi gravada com sucesso. Em modo somente leitura ou se a quota não comportar os itens ainda válidos, a única cópia permanece disponível após reiniciar o app. Se o cache novo estiver inválido, a leitura volta ao arquivo legado preservado. A medição Auto da TV inclui somente a pasta allowlisted `filesDir/mdblist_cache`; DataStore e dados duráveis continuam fora da conta.

Passaram 29 testes unitários focados: 8 de migração MDBList, 11 de ocupação e 10 da política. `:app:assembleFullDebug` compilou os cinco APKs Full Debug; o gate Desktop de política, JAR e MSI também retornou sucesso sem alterações de fonte Desktop. Não foi executado novo teste instrumentado neste recorte nem houve QA físico. Os APKs têm ID `.debug`, são artefatos de validação e não atualizam a instalação de produção.

TV: commit `707a3912482900464557b534b19454644838379d`, branch `codex/1d-tv-preserve-legacy-metadata-cache`, [PR draft #12](https://github.com/Pepeu2010/telumia-tv/pull/12) sobre [#11](https://github.com/Pepeu2010/telumia-tv/pull/11). Versão `1.0.2-alpha.3`, código `10008`. Tamanhos, checksums e comandos estão no [registro do build](telumia-cache-metadata-legacy-tv-r1-build.json).

Incremento parcial da Fase 1-D. A quota `SCENE_INFO` depende de um consumidor de dados de Scene Info já existente e não foi inventada neste passo; a contabilização dos demais caminhos legados, testes de fluxos offline e QA físico seguem pendentes.

## Ocupação Auto do snapshot Continue assistindo na TV — 27 de outubro

A medição de cache da TV agora inclui `filesDir/cw_enrichment`, onde o app mantém snapshots regeneráveis Next Up e Em andamento por perfil. Esses arquivos ficam no armazenamento persistente local, mas são cache reconstruível; contabilizá-los evita que ocupem espaço sem aparecer no cálculo Auto. A leitura continua por allowlist, somente estatísticas de arquivos, com limites de tempo/entradas e rejeição de links. DataStore, bookmarks de cena e os demais dados duráveis permanecem fora da medição e não são removidos nem movidos.

A regressão primeiro falhou com os 17 bytes ignorados; após a correção passaram os 29 testes unitários focados (MDBList 8, ocupação 11, política 10). `:app:assembleFullDebug` passou e gerou cinco APKs Full Debug. O gate Desktop de política, JAR e MSI retornou sucesso sem mudanças de fonte, com três tarefas executadas e 26 `UP-TO-DATE`. Sem teste instrumentado ou QA físico neste recorte. APKs usam ID `.debug`, não são atualização de produção e não foram publicados.

TV: commit `e42eb3283e1e856b159dd9cdfe7df5bef412e085`, branch `codex/1d-tv-count-cw-enrichment-cache`, [PR draft #13](https://github.com/Pepeu2010/telumia-tv/pull/13) sobre [#12](https://github.com/Pepeu2010/telumia-tv/pull/12). Builds e hashes: [registro](telumia-cache-continue-watching-occupancy-tv-r1-build.json).

Incremento parcial da Fase 1-D: a allowlist legado agora cobre MDBList e snapshots Continue assistindo, não todo o armazenamento legado. Permanecem a auditoria das demais pastas de cache, consumidores reais para eventual quota `SCENE_INFO`, fluxos offline e QA em PC/TV Box físicos.

## Ocupação dos caches de reprodução VOD e torrent na TV — 27 de outubro

A estimativa Auto da TV agora inclui os diretórios de reprodução `cacheDir/nuvio_vod_cache` e `cacheDir/nuvio-engine/payload`, além de diretórios VOD antigos com o prefixo gerado pelo próprio player. Os nomes ativos são constantes compartilhadas pelos produtores e pelo scanner. A descoberta dos diretórios antigos é limitada a 10 ms, 16.384 entradas e 128 raízes; ao atingir um limite, o snapshot marca `complete=false`. O scanner mantém a allowlist, limites de profundidade/entradas/tempo, não lê conteúdo e rejeita links.

Esta alteração só torna a ocupação conhecida para o cálculo Auto. Os limites próprios existentes do cache VOD e do motor torrent continuam valendo; este incremento não os reduz à quota global nem modifica as preferências de playback. `nuvio-engine/state`, bookmarks, downloads e arquivos de perfil continuam fora da soma. Portanto, essa contabilização não declara que a quota central controle toda gravação de playback.

Passaram 12 testes unitários de `OwnedMediaCacheOccupancyTest` e 7 testes instrumentados da classe `MediaCacheSettingsTvTest` num AVD Android TV API 33, 1920×1080, incluindo a verificação dos 79 bytes sintéticos de VOD/torrent e a preservação de bookmarks/downloads fora da medição. Foram compilados cinco APKs Full Debug e o APK de instrumentação. O ID é `io.github.pepeu2010.telumia.tv.debug`, versão `1.0.2-alpha.3`, código `10008`; são pacotes locais de validação, não atualizam instalação de produção e não foram publicados. O registro contém comandos e hashes: [cache VOD/torrent](telumia-cache-playback-occupancy-tv-r1-build.json).

TV: commit `69123dfd4535cbd3c74e4a71d00aa8d12944020d`, branch `codex/1d-tv-stream-cache-occupancy`, baseada no snapshot da Fase 1-D `e42eb3283e1e856b159dd9cdfe7df5bef412e085`.

Incremento parcial: a Fase 1-D continua aberta para outros consumidores/caminhos legados, vinculação da quota central às gravações de playback, fluxos offline e QA físico de TV Box/PC.

## Ocupação assíncrona do cache no Desktop e na TV — 27 de outubro de 2026

As consultas ao orçamento não percorrem mais os diretórios allowlisted de cache na thread chamadora. Desktop e TV usam um executor daemon dedicado; o Desktop e a TV rodam a thread abaixo da prioridade normal. A primeira consulta devolve o snapshot conhecido imediatamente e agenda uma varredura. As varreduras continuam limitadas, read-only e sem leitura de conteúdo. Depois de 15 segundos, a próxima consulta agenda outra amostra; quando ela termina, invalida o orçamento para que a leitura seguinte refaça a estimativa Auto com os bytes ocupados atuais. Durante a primeira varredura, a ocupação desconhecida é tratada de forma conservadora; o gate de espaço livre real continua valendo antes de novas gravações. Se o filesystem falhar, a soma conhecida é preservada e marcada incompleta.

O escopo retirado da thread chamadora é a enumeração dos arquivos allowlisted. A leitura pontual de RAM e espaço livre continua no caminho de amostragem. Esta entrega não muda limites de VOD/torrent, não remove arquivos e não conecta uma quota `SCENE_INFO` sem consumidor real.

Na TV passaram 25 testes JVM selecionados (ocupação 12, monitor 2, política 11), mais 7 instrumentados em AVD Android TV API 33, 1920×1080. Os cinco APKs Full Debug e o APK androidTest foram compilados; versão `1.0.2-alpha.3`, código `10008`, ID `io.github.pepeu2010.telumia.tv.debug`. No Desktop passaram 21 testes selecionados (ocupação 8, monitor 2, política 11), `desktopJar` e `packageMsi`.

Os APKs `.debug` e o MSI são artefatos de validação locais; não são atualizações de produção e não foram publicados. Não houve medição de FPS/latência em aparelho físico, QA em TV Box ou validação interativa de mouse no Windows. Comandos, hashes completos e limitações estão no [registro do build](telumia-cache-occupancy-async-tv-desktop-r1-build.json).

TV: commits `59d18cec82d7a24f2b99452585ef83a1df906dba` e `c9e27e8263fa784c863d010fee421f44b221644b`, branch `codex/1d-tv-async-cache-occupancy`, [PR draft #14](https://github.com/Pepeu2010/telumia-tv/pull/14) sobre [#13](https://github.com/Pepeu2010/telumia-tv/pull/13). Desktop: commit `7e03e5abd60cbf65b9d03e2ae5749a08bf7e1edc`, branch `codex/1d-desktop-async-cache-occupancy`, [PR draft #9](https://github.com/Pepeu2010/telumia-desktop/pull/9) sobre [#8](https://github.com/Pepeu2010/telumia-desktop/pull/8). Ambos ligados à issue [telumia#12](https://github.com/Pepeu2010/telumia/issues/12).

A Fase 1-D continua aberta: falta validar fluxos offline reais, QA físico e decidir os próximos consumidores de quota sem sobrepor limites configuráveis existentes de playback.

## Quota HTTP e de addons na TV e no Desktop — 27 de outubro de 2026

Na TV, requests first-party usam `HTTP` (5% do orçamento) em `cacheDir/http_cache_v2`. Requisições configuradas por addons usam `ADDONS` (5%) em `cacheDir/addon_http_cache`. O cliente permissivo de addons e o `baseClient` do Cloudstream compartilham a mesma instância OkHttp; assim ambos usam a mesma quota e os mesmos hits, sem abrir duas caches independentes no mesmo diretório. `METADATA` permanece isolado em 10%. As shares de categorias continuam somando 100%.

O cache legado `cacheDir/http_cache`, antes aberto pelo Cloudstream com 50 MiB fixos, não é mais aberto, migrado, apagado nem revalidado. Ele continua na allowlist apenas para a leitura dos tamanhos e atributos de arquivos na estimativa Auto. A lista também mede `http_cache_v2`, `addon_http_cache` e `metadata`. O scanner não lê corpos de respostas. No Desktop, a implementação já existente atende a categoria `ADDONS` em `media-cache-v1/addons/http`; a enumeração automática mede todas as pastas da raiz `media-cache-v1`, inclusive `addons` e `metadata`.

Uma resposta já armazenada continua disponível quando gravações estão desativadas. A resposta recebida da rede nesse modo recebe `Cache-Control: no-store`; respostas 4xx/5xx também não são persistidas. Os testes cobrem hit sem nova requisição, cache compartilhado entre os clientes de addon, respostas sem gravação, erro 503, quotas e medição das pastas ativas/legada.

Na TV passaram 27 testes JVM direcionados (interceptor HTTP 4, política 11, ocupação 12) e os 8 testes instrumentados de `MediaCacheSettingsTvTest` no AVD Android TV API 33/1080p. Foram compilados os cinco APKs Full Debug, versão `1.0.2-alpha.3`, código `10008`, application ID `.debug`, e o APK androidTest. No Desktop passaram 24 testes direcionados (cache addon 3, política 11, ocupação 8, monitor 2). `desktopJar` e `packageMsi` terminaram com sucesso e estavam `UP-TO-DATE`; o MSI de validação existente tem 210.948.200 bytes, SHA-256 `6B4309B29AF5C80616AC717E1DFF7D991FED93B19EFE4382B48CB0EFF5F2A1D6`.

Os APKs `.debug` e MSI são apenas artefatos locais de validação; nenhum foi publicado nem atualiza a instalação de produção. Não houve teste em TV Box/PC físico nem medição sustentada de memória, latência ou fluidez. O registro dos comandos, branches e hashes está em [JSON do build](telumia-cache-http-addon-tv-desktop-r1-build.json). TV: commit `1333565afcc95a1b6137de2279ec7514b30ed5d5`, [PR draft #15](https://github.com/Pepeu2010/telumia-tv/pull/15) sobre #14. Desktop sem alteração de fonte: commit `7e03e5abd60cbf65b9d03e2ae5749a08bf7e1edc`, [PR draft #9](https://github.com/Pepeu2010/telumia-desktop/pull/9). Ambos ligados à aprovação [telumia#12](https://github.com/Pepeu2010/telumia/issues/12).

Incremento parcial; a Fase 1-D ainda mantém pendentes os fluxos offline completos, QA de desempenho em hardware físico e os consumidores de cache restantes.

## Limite conjunto do cache legado de fundos de perfil no Desktop — 27 de outubro de 2026

O cache atual com chaves hash (`media-cache-v1/images/member-backgrounds`) e o diretório anterior `member_profile_backgrounds` agora compartilham a alocação configurável da categoria `IMAGES`, o limite de 64 arquivos e o máximo anterior de 8 MiB por imagem. A remoção por LRU considera arquivos próprios válidos nos dois diretórios. Entradas legadas são migradas por demanda: a cópia hash é validada antes da exclusão do arquivo antigo. Se gravações estiverem desativadas, a imagem antiga permanece legível pela URI existente. A limpeza começa quando uma imagem de perfil é lida ou salva; não foi adicionado um sweep no startup.

Passaram 9 testes direcionados sem falhas, erros ou skips: 4 de cota compartilhada, migração, leitura somente leitura e tamanho máximo; mais 5 do `BoundedFileCache`. `desktopJar` e `packageMsi` passaram. MSI Windows x64 local: 210.964.584 bytes; SHA-256 `082F472B23730C63A1B5614C299D36F60B4E3C5898B1F5B8BBEF3A229E079E02`. O artefato não foi publicado. Não foram alterados ou gerados APKs, e não houve QA em PC físico nem medição sustentada de desempenho.

Desktop: commit `01e0ef3c` (branch `codex/1d-desktop-bound-legacy-profile-background-cache`), [PR draft #10](https://github.com/Pepeu2010/telumia-desktop/pull/10) sobre [PR #9](https://github.com/Pepeu2010/telumia-desktop/pull/9), ligado à issue [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comandos, limites e hash completo estão no [registro do build](telumia-cache-legacy-profile-background-desktop-r1-build.json).

Incremento parcial da Fase 1-D: seguem pendentes os fluxos offline completos, QA físico e a auditoria dos demais consumidores/diretórios que ainda não aplicam a quota compartilhada.

## Limite conjunto do cache legado de GIFs no Desktop — 27 de outubro de 2026

O gerenciador reutilizável aplica uma só alocação da categoria `IMAGES` a `media-cache-v1/images/gifs` e ao cache antigo `gif-cache`. Arquivos legados continuam identificados pelo SHA-256 da URL de origem, usam o máximo existente de 8 MiB por GIF e compartilham o limite de 200 arquivos. A migração valida a cópia hash antes de remover a origem; hits legados e hashados continuam legíveis offline mesmo se a cota dinâmica cair a zero, limpando outros arquivos LRU quando possível. As leituras fazem a limpeza global no máximo uma vez a cada 15 segundos por instância; cada gravação ainda verifica toda a cota e remove por LRU o que for necessário.

Passaram 12 testes direcionados sem falhas, erros ou skips: 7 do gerenciador e 5 do `BoundedFileCache`, incluindo leitura offline com cota zero, por hash antigo e migração. `desktopJar` e `packageMsi` passaram. MSI Windows x64 local: 210.964.584 bytes; SHA-256 `7AA3680BC5878DFD003D07CE3727902A32EBCAF2E06046514EF212C329BABBCB`. Não foi publicado, e não houve APK, QA físico ou medição sustentada de desempenho.

Desktop: commits `375aeb28`, `74cad5cc` e `c09cd93672f2952446052361f58dbf8e8c917fc4`, branch `codex/1d-desktop-bound-legacy-gif-cache`, [PR draft #11](https://github.com/Pepeu2010/telumia-desktop/pull/11) sobre [PR #10](https://github.com/Pepeu2010/telumia-desktop/pull/10), ligado à issue [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Evidências completas em [JSON do build](telumia-cache-legacy-gif-desktop-r1-build.json).

Incremento parcial: seguem pendentes o cache legado de avatares, os fluxos offline completos, QA físico e a auditoria de outros caminhos de cache.

## Limite conjunto do cache legado de avatares no Desktop — 27 de outubro de 2026

A pasta antiga `member_profile_avatars` e o cache hash `media-cache-v1/avatars/member-assets` agora usam uma só alocação dinâmica da categoria `AVATARS`. O nome legado sem extensão continua compatível, após sanitizar a chave e rejeitar segmentos inválidos. Os dois diretórios compartilham o máximo existente de 2 MiB por avatar e 256 arquivos. Um item antigo só é removido depois de a cópia hash ter sido verificada. Hits existentes seguem legíveis mesmo quando novas gravações estão bloqueadas ou a cota dinâmica chega a zero.

Passaram 13 testes direcionados sem falhas, erros ou skips: 8 do gerenciador e 5 do `BoundedFileCache`. `desktopJar` e `packageMsi` passaram. MSI Windows x64 local: 210.968.680 bytes; SHA-256 `CAC6DC8641AC45B966A993B3264CA35A8FA0A2CFCEBA435E9B215ADFD7FF745D`. Não foi publicado, e não houve APK, QA físico ou medição sustentada de desempenho.

Desktop: commit `8818027e0029e14184da69ff3055ecee2c14a4a1`, branch `codex/1d-desktop-bound-legacy-avatar-cache`, [PR draft #12](https://github.com/Pepeu2010/telumia-desktop/pull/12) sobre [PR #11](https://github.com/Pepeu2010/telumia-desktop/pull/11), ligado à issue [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comandos e checksums completos em [JSON do build](telumia-cache-legacy-avatar-desktop-r1-build.json).

Incremento parcial: permanecem os fluxos offline completos, QA físico e os caches regeneráveis fora das categorias de mídia a auditar.

## Ocupação dos assets de runtime versionados no Auto do Desktop — 27 de outubro de 2026

O modo Auto do Desktop agora inclui na medição read-only, por atributos de arquivo, os assets regeneráveis/versionados em `cacheDir/quickjs`, `cacheDir/native-player-bridge` e `cacheDir/player-ui`. Isso permite considerar essa ocupação ao estimar o espaço do aparelho. Os diretórios não são atribuídos a uma categoria de mídia, não entram em quotas de eviction e não são limpos nem alterados por esta política. A fila diagnóstica Sentry, downloads e arquivos duráveis continuam fora da allowlist.

Passaram 22 testes selecionados (ocupação 9, monitor 2, política 11), sem falhas, erros ou skips. `desktopJar` e `packageMsi` passaram. MSI Windows x64 local: 210.964.584 bytes; SHA-256 `08F19EF2331BF0986F0B72B0B09D1B55BBD1520894BC5FE3FF79F960CED6A4F2`. Nenhum pacote foi publicado; não houve APK nem QA interativo em PC físico.

Desktop: commit `3829eaf3cf5780a1e80035910f94668020162af3`, branch `codex/1d-desktop-runtime-cache-occupancy`, [PR draft #13](https://github.com/Pepeu2010/telumia-desktop/pull/13) sobre [PR #12](https://github.com/Pepeu2010/telumia-desktop/pull/12). Comandos, resultados e limites estão no [registro do build](telumia-cache-runtime-assets-desktop-r1-build.json).

Incremento parcial da Fase 1-D: permanecem a revisão de outros caches regeneráveis e legados, fluxos offline reais e QA/performance em PC e TV Box físicos.

## Ocupação dos scripts de addons por perfil na estimativa Auto da TV — 27 de outubro de 2026

A estimativa Auto da TV passa a incluir os scripts JS regeneráveis mantidos em `filesDir/plugin_code` e `filesDir/plugin_code_p<id>`. A descoberta aceita apenas os nomes exatos gerados para a conta principal ou IDs numéricos de perfil; é limitada a 16.384 entradas, 128 diretórios e 10 ms. O scan dos diretórios encontrados continua read-only, assíncrono e limitado; ele lê atributos e tamanhos, nunca o conteúdo dos scripts.

Os scripts não recebem quota central nem eviction. `DataStore`, avatares locais do Profile Studio, bookmarks, downloads e demais dados duráveis não entram na soma e são mantidos intactos. O registro de build contém os resultados unitários, teste no AVD e hashes dos pacotes.

Passaram 25 testes unitários focados (ocupação 14, política 11), sem falhas, erros ou skips. `MediaCacheSettingsTvTest` passou 9/9 no AVD Android TV API 33. Foram gerados os cinco APKs Full Debug e o APK androidTest, versão `1.0.2-alpha.3`, código `10008`, application ID `.debug`; são pacotes de validação, não atualizam a instalação de produção e não foram publicados. Nenhuma fonte Desktop mudou neste incremento.

TV: commit `8a9376032`, branch `codex/1d-tv-plugin-code-cache-occupancy`, [PR draft #16](https://github.com/Pepeu2010/telumia-tv/pull/16) sobre [PR #15](https://github.com/Pepeu2010/telumia-tv/pull/15), ligado à issue [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comandos, seis hashes SHA-256 completos e limites estão no [registro do build](telumia-cache-plugin-code-occupancy-tv-r1-build.json).

Incremento parcial da Fase 1-D: permanecem fluxos offline completos, QA/performance em hardware físico e auditoria de outros caminhos regeneráveis/legados.

## Ocupação do APK staged pelo atualizador no Auto da TV — 27 de outubro de 2026

O modo Auto da TV agora inclui `cacheDir/updates`, onde o atualizador baixa o APK antes de solicitar a instalação. A allowlist mede somente atributos/tamanhos; não altera, move, apaga nem põe o pacote sob quotas de eviction. Assim, o arquivo continua disponível para o instalador. Nomes parecidos como `updates-backup`, downloads comuns e dados duráveis seguem fora.

Passaram 26 testes unitários focados (ocupação 15, política 11) e 10/10 testes instrumentados no AVD Android TV API 33, incluindo a conferência de que os bytes staged permanecem intactos. Foram gerados cinco APKs Full Debug e o APK androidTest, versão `1.0.2-alpha.3`, código `10008`, application ID `.debug`. São pacotes de validação, não atualizam instalações de produção e não foram publicados. Este teste de armazenamento não comprova uma atualização assinada real da `1.0.0` para `1.0.2`. Desktop não mudou.

TV: commit `f51e71e2e333b92c59efb29cd9b619fe710a964b`, branch `codex/1d-tv-updater-apk-cache-occupancy`, [PR draft #17](https://github.com/Pepeu2010/telumia-tv/pull/17) sobre [PR #16](https://github.com/Pepeu2010/telumia-tv/pull/16), ligado à issue [telumia#12](https://github.com/Pepeu2010/telumia/issues/12). Comandos, resultados e hashes SHA-256 completos estão no [registro do build](telumia-cache-updater-apk-occupancy-tv-r1-build.json).

Incremento parcial da Fase 1-D: continuam pendentes fluxos offline completos, QA/performance em hardware físico e a auditoria dos demais caminhos regeneráveis/legados.

## Limite do cache de memória de imagens no Desktop — 27 de outubro de 2026

Os `ImageLoader` principal e de badges agora compartilham um orçamento total de memória calculado em 1% da RAM física detectada, entre 16 e 96 MiB; quando a leitura da RAM falha, o fallback é 24 MiB. Sete oitavos ficam com imagens e um oitavo com badges. Assim, os loaders separados não recebem cada um o teto total. O loader de previews permanece isolado e os requests dessa superfície continuam com cache de memória desativado. As quotas de disco e a política de dados offline não mudaram.

Passaram 26 testes selecionados: 4 da política nova, 9 de ocupação, 2 do monitor e 11 da política de cache, sem falhas, erros ou skips. `desktopJar` e `packageMsi` passaram. MSI local Windows x64: 210.968.680 bytes; SHA-256 `00228831E75B2A9F75F2F1FA6C8416BD4A3B5D90825B4509635343A16AFE91DE`. Não houve QA interativo nem medição sustentada da memória/jank em PC físico; o MSI é validação local, não foi publicado.

Desktop: commit `c558178d815a993bdab234000da5f5db23f61236`, branch `codex/1d-desktop-image-memory-cache`, [PR draft #14](https://github.com/Pepeu2010/telumia-desktop/pull/14) sobre [PR #13](https://github.com/Pepeu2010/telumia-desktop/pull/13). API confirmada na Coil 3.6.3. Comandos, resultados e limites estão no [registro do build](telumia-cache-image-memory-desktop-r1-build.json).

Incremento parcial da Fase 1-D: seguem pendentes os caminhos de cache regenerável restantes, fluxos offline reais e QA/performance em hardware físico.

## Ocupação do DEX compilado dos addons no Auto da TV — 27 de outubro de 2026

O cálculo Auto da TV passa a medir também a raiz exata `codeCacheDir/cs_dex_cache`, que guarda DEX compilado pelo loader de addons. O scan reutiliza o medidor allowlisted, limitado e read-only; não lê os arquivos, apaga conteúdo ou liga esta raiz à quota de eviction. Os addons originais em `filesDir/cs_extensions`, outros diretórios de código compilado, DataStore e dados duráveis continuam fora.

Passaram 16 testes unitários de `OwnedMediaCacheOccupancyTest` e 10 testes instrumentados de `MediaCacheSettingsTvTest` no AVD Android TV API 33. Foram gerados cinco APKs Full Debug e o APK androidTest; application ID `io.github.pepeu2010.telumia.tv.debug`, versão `1.0.2-alpha.3`, código `10008`. São artefatos locais de validação, não atualizam a instalação de produção e não foram publicados. Não houve QA em TV Box física.

TV: commit `69686ffab0444de719631a5a47605a1d2b5c6492`, branch `codex/1d-tv-code-cache-occupancy`, [PR draft #18](https://github.com/Pepeu2010/telumia-tv/pull/18) sobre [PR #17](https://github.com/Pepeu2010/telumia-tv/pull/17). Comandos e os seis hashes SHA-256 estão no [registro do build](telumia-cache-plugin-dex-occupancy-tv-r1-build.json).

Incremento parcial da Fase 1-D: continuam pendentes a auditoria de outros arquivos regeneráveis, os fluxos offline reais e QA/performance em hardware físico.

## Ocupação de arquivos diretos da raiz de cache na TV — 27 de outubro de 2026

O modo Auto agora mede arquivos regulares colocados diretamente em `Context.cacheDir`, sem descer em subdiretórios. Isso cobre arquivos planos de cache do libmpv — cujo wrapper recebe essa raiz para o cache de shaders — e temporários que eventualmente restarem após uma interrupção. O scan é read-only, limitado a 16.384 entradas e 25 ms, e não abre conteúdo. Pastas continuam exclusivamente nas allowlists já existentes: `image_cache`, downloads e outros subdiretórios não são recursivamente medidos por este caminho nem duplicados.

Passaram 19 testes unitários de `OwnedMediaCacheOccupancyTest` e 10 instrumentados de `MediaCacheSettingsTvTest` no AVD Android TV API 33. Foram gerados cinco APKs Full Debug, application ID `.debug`, versão `1.0.2-alpha.3`, código `10008`; são builds locais de validação, sem publicação ou atualização de instalação de produção. Não houve QA em TV Box física. O [manual oficial do mpv](https://mpv.io/manual/stable/#cache) descreve o diretório configurado para shader cache.

TV: commit `4d23cb35d9b8e72f0612e3b4381f0543be487d3e`, branch `codex/1d-tv-cache-root-files`, [PR draft #19](https://github.com/Pepeu2010/telumia-tv/pull/19) sobre [PR #18](https://github.com/Pepeu2010/telumia-tv/pull/18). Comandos, APKs e hashes SHA-256 estão no [registro do build](telumia-cache-root-files-tv-r1-build.json).

Incremento parcial da Fase 1-D: seguem pendentes os fluxos offline reais, QA/performance físico e auditoria dos caminhos regeneráveis que não são caches de mídia.

## Quota de snapshots Continue assistindo na TV — 28 de outubro de 2026

O modo Auto já contabilizava `filesDir/cw_enrichment`, mas os snapshots de próximos episódios e progresso em andamento podiam crescer sem quota nem pré-checagem de espaço. Agora ambos usam a categoria `METADATA`, com alocação compartilhada: ratings MDBList recebem até 8 MiB e todos os snapshots de até seis perfis compartilham até 8 MiB. A quota restante da categoria limita o teto do Continue assistindo quando o orçamento do aparelho é menor.

Antes do staging atômico, a gravação confere os bytes UTF-8 exatos, o total dos snapshots de outros perfis e a reserva real de armazenamento. Falha de leitura, falta de espaço, snapshot acima da quota ou ocupação agregada excessiva recusam a gravação sem substituir/remover o arquivo anterior. Leituras continuam disponíveis em modo somente leitura; arquivos antigos válidos continuam sendo carregados.

Passaram 30 testes unitários selecionados: `BoundedContinueWatchingSnapshotStoreTest` (5), `ContinueWatchingCachePolicyTest` (4), `MdbListRatingsDiskCacheTest` (9) e `MediaCachePolicyTest` (12), sem falhas, erros ou skips. Mais 2 testes instrumentados passaram no AVD Android TV API 33, cobrindo a recusa e a gravação UTF-8 exata no filesystem Android. `:app:assembleFullDebug` compilou os cinco APKs de validação local, application ID `.debug`, versão `1.0.2-alpha.3`, código `10008`; não foram publicados e não atualizam instalação de produção. O cliente Desktop não mudou. Tamanhos, comandos e hashes estão no [registro do build](telumia-cache-cw-metadata-storage-preflight-tv-r1-build.json).

TV: commit `d0702181322ab7e53832e8946123097436ec0a35`, branch `codex/1d-tv-cw-metadata-quota`, [PR draft #26](https://github.com/Pepeu2010/telumia-tv/pull/26) sobre [#25](https://github.com/Pepeu2010/telumia-tv/pull/25), vinculado à issue aprovada [telumia#12](https://github.com/Pepeu2010/telumia/issues/12).

Limites: a instrumentação rodou em AVD API 33, não em API 24 ou TV Box física; a recusa foi injetada e não esgotou um volume real. O projeto habilita `desugar_jdk_libs_nio:2.1.4` para o `minSdk 24`, mas não havia AVD API 24 neste ambiente. A Fase 1-D continua aberta para os outros consumidores, validação offline completa e desempenho em hardware real.

## Ocupação de arquivos diretos da raiz de cache no Desktop — 28 de outubro de 2026

O modo Auto do Desktop inclui agora arquivos regulares colocados diretamente em `DesktopStorage.cacheDir`. A medição lê somente atributos e tamanho, não abre conteúdo, não segue links e não desce em diretórios. Ela para em 16.384 entradas ou 25 ms; se atingir um limite, informa a leitura parcial conservadoramente. As pastas de imagens, GIF, runtime, addons e demais caches continuam cobertas exclusivamente pelas allowlists atuais, evitando dupla contagem. A fila diagnóstica Sentry continua fora da estimativa.

Passaram 17 testes selecionados sem falhas, erros ou skips: `DirectCacheFileOccupancyTest` (4), `OwnedMediaCacheOccupancyTest` (9) e `DesktopMediaCachePreferencesTest` (4). `:composeApp:desktopJar` e `:composeApp:packageMsi` passaram. MSI Windows x64 local: 210.972.776 bytes; SHA-256 `50E81AC682AABB0361A60B17505411146C37E639D23E5895E68CF8A4EB45D9E2`. O MSI não foi publicado; nenhum APK mudou e não houve QA interativo/medição de desempenho em PC físico.

Desktop: commit `71dfb4c7f6b244d19c93d8bb82aa51d9ee224d65`, branch `codex/1d-desktop-cache-root-files`, [PR draft #15](https://github.com/Pepeu2010/telumia-desktop/pull/15) sobre a branch `codex/1d-desktop-image-memory-cache`. O build desabilitou alvos iOS por estar no host Windows e descartou o configuration cache por incompatibilidade da tarefa existente `packageMsi`; as tarefas Desktop terminaram com sucesso. Nenhuma release foi publicada.

Comandos usados:

```text
:composeApp:desktopTest --tests '*DirectCacheFileOccupancyTest' --tests '*OwnedMediaCacheOccupancyTest' --tests '*DesktopMediaCachePreferencesTest'
:composeApp:desktopJar
:composeApp:packageMsi
```

Limites: este incremento mede ocupação para a estimativa Auto, mas não atribui arquivo solto a uma categoria, não o apaga e não demonstra uso offline completo ou desempenho sustentado em hardware físico.

## Pré-checagem de espaço nos caches Coil da TV e do Desktop — 28 de outubro de 2026

Os loaders Coil principal, de previews e de badges dos dois clientes passaram a aplicar um interceptor de pré-checagem. Antes de prosseguir com uma requisição cuja política permite escrita, o interceptor consulta a quota efetiva da categoria e verifica se o espaço livre real continua acima da reserva do aparelho. Se a consulta falhar, a gravação é bloqueada. A checagem roda em IO e o último resultado é compartilhado por até um segundo entre requests do mesmo loader, evitando uma consulta de filesystem por imagem durante a rolagem.

Com espaço insuficiente, a política `ENABLED` do request vira `READ_ONLY`: uma imagem já no cache de disco continua legível, mas uma resposta nova não é gravada. Uma política explicitamente desativada continua desativada; `WRITE_ONLY` vira `DISABLED`, sem habilitar leituras que o request não pediu. O default do loader permanece `ENABLED` para permitir que gravações retomem automaticamente após a recuperação do espaço, sem reiniciar o app. O ajuste não remove conteúdo existente nem inclui downloads ou dados duráveis na quota.

TV: `CacheWritePreflightInterceptorTest` (6) e `MediaCachePolicyTest` (11) passaram; um teste instrumentado offline também passou no AVD Android TV API 33. `:app:assembleFullDebug` gerou os cinco APKs. Desktop: `CacheWritePreflightInterceptorTest` (7), `MediaCachePolicyTest` (12) e um teste offline integrado passaram (20 no total); `:composeApp:desktopJar` e `:composeApp:packageMsi` passaram. O teste fixture dos dois clientes baixou uma imagem pela rede, bloqueou novas gravações, desligou o servidor e confirmou que o segundo request veio do cache de disco. O MSI local é `Telumia-2.0.1.msi`, apenas validação da fonte desta branch; nenhum pacote foi publicado. Versões, comandos e hashes estão no [registro de build](telumia-cache-image-storage-preflight-r1-build.json).

O gate cobre a decisão antes do início de uma requisição e falha fechado quando a amostra não está disponível. Como o tamanho de respostas remotas é desconhecido nesse ponto e vários requests podem já estar em andamento, ainda pode haver consumo depois da amostra; esta checagem não é uma reserva de bytes durante toda a gravação. Os testes offline usam um loader isolado e servidor fixture; não esgotaram o volume nem validaram todos os fluxos numa instalação de release. QA em PC/TV Box físicos e jank/memória seguem pendentes.
## Reserva real antes da gravação do cache MDBList na TV — 28 de outubro de 2026

O cache de ratings MDBList agora passa o tamanho exato do snapshot codificado a TvMediaCache.canWriteCacheEntry(METADATA, bytes) antes de escrever o temporário. Esse caminho volta a consultar diretamente o espaço livre e a quota; não depende apenas da amostra de até 15 segundos usada pelo modo Auto. Falha de consulta impede a nova gravação.

Se a reserva não comporta o snapshot, o cache permanece em memória e o arquivo de ratings anterior não é substituído. Durante a migração do antigo filesDir/mdblist_cache/ratings_v1.json, a cópia só é removida após a gravação válida; portanto, a recusa por espaço preserva a única cópia legada. A leitura offline do arquivo já persistido continua disponível.

Passaram 9 testes focados de MdbListRatingsDiskCacheTest, sem falhas, erros ou skips, e os cinco APKs Full Debug foram gerados (application ID .debug, versão 1.0.2-alpha.3, código 10008). O gate Desktop não teve alterações de fonte: desktopTest, desktopJar e packageMsi passaram como UP-TO-DATE; o MSI local permanece Telumia-2.0.1.msi, apenas validação, sem publicação. Comandos, hashes e commit estão no registro de build telumia-cache-metadata-storage-preflight-tv-r1-build.json.

O teste simula a recusa da política de espaço e não esgota fisicamente o volume. A checagem é prévia e não reserva bytes durante a gravação; QA em aparelho real e restante dos consumidores de cache da Fase 1-D seguem pendentes.
## Pré-checagem de espaço no cache EPG da TV — 28 de outubro de 2026

Antes de serializar uma nova cópia do guia, `LiveTvGuideCache` consulta `TvMediaCache.canBeginCacheWrite(EPG)`, que verifica a reserva contra o espaço livre real no armazenamento. A checagem ocorre antes de criar a pasta, limpar temporários ou substituir o arquivo do guia. Falha da consulta ou falta de espaço bloqueia a gravação e preserva a cópia offline anterior. Leituras permanecem disponíveis em modo somente leitura.

Passaram 5 testes focados de `LiveTvGuideCacheTest` e 2 testes instrumentados de `LiveTvGuideCacheAtomicReplaceTest` no AVD Android TV API 33, sem falhas, erros ou skips. `:app:assembleFullDebug` compilou os cinco APKs Full Debug de validação, application ID `.debug`, versão `1.0.2-alpha.3`, código `10008`; não são atualizações instaláveis de produção e não foram publicados. O gate Desktop de testes de cache, `desktopJar` e `packageMsi` passou com tarefas `UP-TO-DATE`, pois este incremento só alterou o cliente TV; MSI novo não foi gerado.

TV: commit `dc718ea9c6a7bf0cf41f613d4cbf5ca857fb3dea`, branch `codex/1d-tv-epg-storage-preflight`, [PR draft #24](https://github.com/Pepeu2010/telumia-tv/pull/24), sobre o cache MDBList em [PR #23](https://github.com/Pepeu2010/telumia-tv/pull/23). Comandos, tamanhos e SHA-256 estão no [registro do build](telumia-cache-epg-storage-preflight-tv-r1-build.json).

Limites: o teste injeta a recusa de espaço; não esgota um volume físico. A checagem antecede o staging, mas não reserva espaço durante toda a gravação. QA em TV Box físico, desempenho e o fluxo offline completo permanecem pendentes.
## Pré-checagem de espaço nos caches HTTP de TV e Desktop — 28 de outubro de 2026

O interceptor de rede reavalia o orçamento e a disponibilidade de armazenamento antes de entregar uma nova resposta ao cache OkHttp. Na TV, isso cobre o cliente first-party e a mesma instância de cache usada por addons/Cloudstream; no Desktop, cobre o cache HTTP de addons. A política combina o limite que abriu o cache com o orçamento atual e o espaço livre atualizado contra a reserva do aparelho. Erro de leitura também bloqueia a persistência. O cliente ainda entrega a resposta solicitada; `Cache-Control: no-store` impede apenas que essa resposta entre no disco. Respostas já armazenadas continuam servidas offline.

Passaram 5 testes de `HttpCacheWritePolicyInterceptorTest` e 12 de `MediaCachePolicyTest` na TV, além de `:app:assembleFullDebug` para os cinco APKs. No Desktop passaram 4 testes de `AddonHttpCacheTest` e 13 de `MediaCachePolicyTest`, `desktopJar` e `packageMsi`. O MSI Windows x64 local tem 210.985.064 bytes e SHA-256 `30FA176C2ED8633D581A84D8909E0F8CE4167043FEC30231D92FE6F8EA5507F5`. APKs `.debug` e MSI são apenas validação local, não atualizam instalações públicas e não foram publicados.

TV: commit `df3727dadb2ee73d6a1163bb5950b6582153eb94`, [PR draft #25](https://github.com/Pepeu2010/telumia-tv/pull/25), sobre o preflight EPG em [#24](https://github.com/Pepeu2010/telumia-tv/pull/24). Desktop: commit `0f162d86e60a4f413bec49a5efd2e18a3d84e214`, [PR draft #19](https://github.com/Pepeu2010/telumia-desktop/pull/19), sobre [#18](https://github.com/Pepeu2010/telumia-desktop/pull/18). Comandos e todos os tamanhos/checksums estão no [registro do build](telumia-cache-http-storage-preflight-tv-desktop-r1-build.json).

Limites: o teste injeta o resultado da reserva e não esgota um volume físico. A checagem força uma amostra atual antes do cache, mas não reserva bytes durante toda a gravação; o tamanho desconhecido ou várias respostas concorrentes podem consumir espaço depois da amostra. Ainda faltam QA em PC/TV Box físicos e validação de todos os fluxos offline numa instalação de release.

## Cache de metadata de reprodução na TV e no Desktop — 29 de outubro de 2026

Os caches regeneráveis de links de reprodução e grupos de binge agora obedecem à categoria `METADATA` nos dois clientes. Eles continuam separados por perfil e mantêm os hits existentes disponíveis quando o modo de cache ou a reserva de armazenamento bloqueia novas gravações. Novas entradas são limitadas por bytes estimados e quantidade; entradas antigas do mesmo cache são removidas por ordem de uso. Preferências não relacionadas e dados duráveis não participam da eviction.

No Desktop, a política deixa até 8 MiB para Continue assistindo, aloca até 8 MiB para links de stream e até 2 MiB para grupos de binge a partir do restante da quota efetiva. Há no máximo 512 links e 1.024 grupos agregados entre perfis. A substituição de preferências é transacional e persiste o arquivo uma vez; grupos de binge agora guardam timestamps em sidecars. A inspeção de ocupação Auto inclui os arquivos de preferências desses caches. Os 1 GiB iniciais do Auto Desktop continuam configuráveis e adaptados ao aparelho; os valores acima são limites por consumidor dentro da quota atual.

Na TV, links de stream e grupos de binge compartilham a quota restante depois dos caches MDBList e Continue assistindo: até 8 MiB agregados para streams e até 2 MiB para binge, divididos entre os seis perfis. Cada perfil aceita até 128 links e 256 grupos. O estimador considera os arquivos DataStore primário e backup sombra; ambos entram na medição Auto para as seis posições de perfil. O timestamp de `cachedAtMs` ordena links e um campo timestamp separado ordena grupos. O default inicial configurável de 256 MiB da TV não é um teto rígido.

Validação local: 18 testes Desktop passaram em `BoundedPreferenceCachePolicyTest`, `DesktopStorageTest`, `BoundedDesktopPreferenceCacheTest` e `DesktopMetadataPreferenceCachePolicyTest`; o MSI Windows x64 compilou. Na TV, 34 testes passaram em `BoundedPreferenceCachePolicyTest`, `OwnedMediaCacheOccupancyTest`, `BoundedContinueWatchingSnapshotStoreTest` e `PlaybackMetadataCacheDataStoreTest`; os três testes novos exercitam os stores de produção sobre arquivos DataStore temporários, incluindo isolamento de perfil, leitura sem novas escritas e limites por perfil. `:app:assembleFullDebug` compilou os cinco APKs. O MSI (`Telumia-Windows-x64-1.0.2-alpha.1.msi`, 211.021.928 bytes, SHA-256 `6D90A72725B18466543AD8872FDC7CF587594DA05445C75784ACE74EFB704639`) e APKs com ID `.debug`, versão `1.0.2-alpha.3`, código 10008 são apenas validação local; nenhum foi publicado como release. Tamanhos e hashes de todos os pacotes estão em [telumia-cache-playback-metadata-tv-desktop-r1-build.json](telumia-cache-playback-metadata-tv-desktop-r1-build.json).

Fontes: Desktop `51bb8e41494c11212e588d168a1f3600fe087691`, branch `codex/1d-desktop-cw-metadata-quota`, [PR draft #20](https://github.com/Pepeu2010/telumia-desktop/pull/20); TV `5bac37ac76ac134b5e7900218283c5301b24906f`, branch `codex/1d-tv-cw-metadata-quota`, [PR draft #26](https://github.com/Pepeu2010/telumia-tv/pull/26). Ambos continuam vinculados à aprovação [Telumia #12](https://github.com/Pepeu2010/telumia/issues/12).

Limites: os testes novos da TV usam os stores reais e arquivos DataStore temporários, mas não são instrumentação Android nem validam o fluxo completo de playback offline. Também não houve reprodução offline completa em instalação de release nem QA em PC ou TV Box físicos. A Fase 1-D permanece aberta.

## Limpeza de assets versionados do Desktop — 29 de outubro de 2026

`DesktopCache.installVersionedFiles` extrai bibliotecas e arquivos de UI embarcados sob diretórios nomeados pelo hash do conteúdo. A cada atualização do app, o hash muda e as cópias anteriores ficavam indefinidamente. Depois que os arquivos da versão atual são instalados com sucesso, o Desktop agora remove somente diretórios antigos cujo nome corresponde ao formato de hash de 24 caracteres, dentro do namespace exato atualizado. A versão atual, diretórios sem esse formato e namespaces vizinhos ficam preservados. A limpeza é best-effort; arquivos bloqueados/permissão insuficiente permanecem para uma tentativa futura. Os assets são os mesmos arquivos embarcados e já contabilizados pelo Auto em `quickjs`, `native-player-bridge` e `player-ui`.

Passaram 14 testes Desktop: `DesktopCacheTest` (1), `OwnedMediaCacheOccupancyTest` (9) e `DirectCacheFileOccupancyTest` (4), sem falhas/erros/skips; `:composeApp:packageMsi` compilou Windows x64. MSI local alpha de validação: 211.021.928 bytes, SHA-256 `CC91AC8772988F01B16D2A15ADD6BD20E7C08300E00AFAF7617EE4F753D7DA9B`; não publicado. Detalhes e checksum em [telumia-cache-versioned-runtime-assets-desktop-r1-build.json](telumia-cache-versioned-runtime-assets-desktop-r1-build.json).

Desktop: commit `bfd1c6de1bb0ef95adf452d139b6ea7f32c2f2a2`, branch `codex/1d-desktop-versioned-runtime-cache`, [PR draft #21](https://github.com/Pepeu2010/telumia-desktop/pull/21) sobre o consumidor de metadata em [PR #20](https://github.com/Pepeu2010/telumia-desktop/pull/20), aprovado como parte da [fundação de cache Telumia #12](https://github.com/Pepeu2010/telumia/issues/12).

Limites: não houve QA físico nem medição de startup/jank. Se o sistema operacional impedir a remoção (por exemplo, arquivo ainda em uso), o diretório antigo continua sendo contado pelo Auto; a limpeza será tentada na próxima instalação desses assets. Não houve mudança de fonte nem rebuild de APK na TV. A Fase 1-D continua aberta.

## Quota Coil dinâmica diante de mudanças de orçamento — 29 de outubro de 2026

Os caches de imagem Coil do Desktop e da TV agora validam a quota efetiva da categoria antes de cada gravação. A capacidade permitida quando cada loader é aberto fica registrada; se uma alteração de preferências ou uma nova estimativa Auto reduzir depois o limite, o preflight bloqueia gravações quando a nova quota fica abaixo daquela capacidade ou quando a reserva de espaço do aparelho não está disponível. O request passa a `READ_ONLY`, preservando hits já existentes. Quando espaço e quota se recuperam, novas gravações podem voltar sem reiniciar o cliente. A política também limita o consumidor à quota da própria categoria.

O ajuste usa o preflight Coil existente e mantém a amostragem curta e compartilhada por loader; não acrescenta trabalho de filesystem por frame. A participação de imagens animadas e fundos de perfil na fração de imagem continua contabilizada na quota de cada plataforma. Os defaults iniciais de 1 GiB para Desktop e 256 MiB para TV continuam configuráveis, com Auto limitado por armazenamento e capacidade do aparelho; não são tetos rígidos.

Validação local: 22 testes Desktop (`MediaCachePolicyTest`, `CacheWritePreflightInterceptorTest` e teste offline integrado) e 19 testes TV (`MediaCachePolicyTest` e `CacheWritePreflightInterceptorTest`) passaram sem falhas. `:composeApp:packageMsi` e `:app:assembleFullDebug` também passaram. O CI da release `v1.0.5` passou a suíte Live TV e gerou cinco APKs Full Debug assinados pela chave persistente. Os commits finais são Desktop [`bed7ecf`](https://github.com/Pepeu2010/telumia-desktop/commit/bed7ecf756abb6f49e7e222acba2460f69a20039) e TV [`d58ca1c`](https://github.com/Pepeu2010/telumia-tv/commit/d58ca1c807e691127e9e694f003fc69199dd8bd9); evidências dos comandos, pacotes e checksums estão em [telumia-1.0.5-stable-release.json](telumia-1.0.5-stable-release.json).

Limites: a validação não esgotou um volume físico, não mediu jank em aparelhos e não comprova todos os fluxos offline. Requests que já começaram antes de uma alteração de quota podem terminar; esta proteção avalia novas decisões de escrita, não reserva cada byte durante toda a transferência. A Fase 1-D permanece aberta para os demais caches e QA em PC/TV Box físicos.

## Limites LRU para todos os caches TMDB em memória da TV — 29 de outubro de 2026

Uma auditoria do serviço encontrou caches além dos sete originalmente tratados: `collectionCache` e os mapas bidirecionais de ID do `TmdbService` também eram permanentes e sem limite. Agora os dez mapas usam LRU por quantidade. O tier de memória existente controla as capacidades; LOW_RAM/UNKNOWN usa 6–12 entradas para respostas volumosas e 128 IDs por direção, BALANCED usa 12–24 e 256, e HIGH_CAPACITY usa 24–48 e 512. Os limites completos por cache estão em [TMDB_METADATA_CACHE.md](https://github.com/Pepeu2010/telumia-tv/blob/codex/1d-tv-tmdb-memory-cache-on-stable/docs/TMDB_METADATA_CACHE.md).

Passaram 33 testes direcionados: `BoundedLruCacheTest` (3), `TmdbMetadataCacheLimitsTest` (2), `TmdbMetadataServiceTest` (27) e `TmdbServiceCacheTest` (1). `:app:assembleFullDebug` compilou as cinco variantes locais da TV (1.0.5/code10015, application ID `.debug`). No Desktop, sem alteração de fonte nesse incremento, passaram 22 testes focados; `:composeApp:packageMsi` ficou `UP-TO-DATE`. Fonte TV: commit [`5ddd99b`](https://github.com/Pepeu2010/telumia-tv/commit/5ddd99b31ca461fb9e20b40b896572a8da7aeb93), [PR #27](https://github.com/Pepeu2010/telumia-tv/pull/27), baseado na correção estável de Coil. Tamanhos, hashes e comandos estão no [registro](telumia-tmdb-memory-cache-tv.json).

Limites: são tetos de entradas, não orçamentos exatos de heap; itens têm tamanhos diferentes. O tier é avaliado ao construir os serviços e não é reamostrado nesta entrega. Não houve teste de heap, CPU, jank ou latência em aparelho físico, suíte completa, nem validação integral offline. Os APKs locais são debug de validação, não foram publicados nem atualizam produção. A Fase 1-D continua aberta.

## Limites LRU nos caches de trailers da TV — 29 de outubro de 2026

Os resultados de busca do `TrailerService` (positivos e negativos) e as fontes de reprodução resolvidas do YouTube agora usam LRU sincronizado por tier de memória. LOW_RAM/UNKNOWN retém até 12 buscas e 6 fontes YouTube; BALANCED, 24/12; HIGH_CAPACITY, 48/24. A expiração atual dos links e o TTL de três horas permanecem. A remoção condicional só apaga o valor que foi identificado como expirado, preservando uma atualização concorrente. Os limites são contagem de entradas, não bytes.

Passaram 19 testes JVM selecionados sem falhas, erros ou skips: `BoundedLruCacheTest` (4), `TrailerCacheLimitsTest` (2), `TrailerServiceBoundedCacheTest` (2), cancelamento (2), ranking (5), gate de trailers (2) e cache de sessão YouTube (2). `:app:assembleFullDebug` passou em 7m40s e compilou cinco APKs locais `.debug`, versão 1.0.6/código 10016. Os artefatos são validação local, não publicados e não atualizam a instalação estável. Tamanhos e hashes em [telumia-trailer-cache-tv-r1-build.json](telumia-trailer-cache-tv-r1-build.json).

O gate Desktop de cache/`desktopJar`/MSI terminou com sucesso e todas as tarefas Desktop selecionadas ficaram `UP-TO-DATE`, pois não houve mudança Desktop. Não houve QA físico, playback offline completo ou medição de heap/jank. PR TV [#29](https://github.com/Pepeu2010/telumia-tv/pull/29), commit `0b28e22da`, empilhado sobre o bump estável [#28](https://github.com/Pepeu2010/telumia-tv/pull/28) e a implementação TMDB [#27](https://github.com/Pepeu2010/telumia-tv/pull/27), vinculado à fundação aprovada [Telumia #12](https://github.com/Pepeu2010/telumia/issues/12). A Fase 1-D permanece aberta.
