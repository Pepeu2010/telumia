# Telumia — cache configurável por aparelho

Incremento nativo de 6 de outubro de 2026. Os dois clientes foram compilados e testados. A política central completa para todos os tipos de dados ainda não está concluída.

## Comportamento implementado no Desktop

O modo Auto começa em 1 GiB, adapta o orçamento à memória detectada e ao armazenamento disponível e mantém reserva de 2 GiB. Manual permite escolher outro orçamento, inclusive superior ao default, respeitando o espaço disponível. A configuração pertence ao aparelho, em armazenamento Telumia versionado, e vale a partir da próxima abertura.

Os carregadores existentes de imagens/badges e o cache de GIFs usam quotas da política central. GIFs têm limites de bytes, quantidade e tamanho por entrada; nomes derivados de hash; substituição atômica e eviction por uso recente. Arquivos antigos de GIF são lidos e migrados sob demanda, sem exigir rede. Eles ainda precisam de contabilização/migração global para assegurar um teto sobre todo o legado.

Quando a reserva impede escrita, os carregadores preservam leitura dos caches disponíveis. Requests individuais de fundos/badges respeitam a política. Downloads, bookmarks, histórico, configurações e arquivos de usuário não pertencem às quotas de mídia. As outras categorias possuem quotas preparadas, mas seus consumidores ainda precisam ser integrados.

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

Ainda faltam contabilização global de legado, integração das caches de metadata/addons/EPG/previews/thumbnails/filmstrip/Scene Info e avatar remoto, adaptação dinâmica durante a sessão e QA de fluxos offline reais. O limite de armazenamento antes de baixar imagens e a validação de arquivos/URLs também exigem revisão própria. O índice de metadata temporal não substitui um cache de Scene Info.

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
