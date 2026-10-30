# Releases da Telumia

Toda release combinada deve listar APK Android TV e instalador Windows PC na mesma página, inclusive no repositório principal `Pepeu2010/telumia`, além das releases dos clientes Desktop e TV. Cada versão de plataforma fica identificada nos assets e checksums. A regra vale para as releases públicas de `v0.2.0-alpha.1` até a estável `v1.0.10`, incluindo as estáveis `v1.0.0`–`v1.0.4`; onde faltava, o MSI Desktop foi anexado e os checksums regenerados. A preparação/publicação do repositório principal exige APK e MSI, e a verificação reconhece o MSI genérico ou com a versão própria da plataforma.

## v1.0.10 — limites LRU para remapeamento de episódios Trakt

[Release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.10), publicada pelo workflow [40987925313](https://github.com/Pepeu2010/telumia/actions/runs/40987925313). O job passou os testes selecionados de Live TV, compilou e assinou cinco APKs Android TV/TV Box Full Debug com a chave persistente e validou assets, manifesto e checksums. O job levou 9m09s; testes e compilação Android, 7m08s. Android 1.0.10 usa versionCode 10020.

A página contém o [APK universal](https://github.com/Pepeu2010/telumia/releases/download/v1.0.10/Telumia-TV-1.0.10-universal-debug.apk), variantes ARM64, ARM32, x86_64 e x86, fontes, manifesto e SHA256SUMS.txt. O MSI Windows é `Telumia-Windows-x64-1.0.4.msi` (Desktop 1.0.4, ProductVersion 2.0.4), copiado e verificado byte a byte da release Desktop [v1.0.4](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.4); o cliente Desktop não mudou e o MSI não foi recompilado.

Na TV, os remapeamentos diretos/reversos por episódio, listas do addon/Trakt e normalização de títulos passaram a usar TTL de dez minutos e limites LRU por tier. Seis testes focados passaram. A seleção ampliada executou 196 testes e teve uma falha herdada em `TraktAuthServiceTest`, reproduzida no commit-base limpo `6224107be17ed15db4b9a030c5409839b6dc7f3c`. A fonte TV é [`eb417f0`](https://github.com/Pepeu2010/telumia-tv/commit/eb417f089f2412dd56ac97f1735e6e8ada16363a), implementação no [PR #32](https://github.com/Pepeu2010/telumia-tv/pull/32), empilhado sobre [PR #31](https://github.com/Pepeu2010/telumia-tv/pull/31), dentro da aprovação [Telumia #12](https://github.com/Pepeu2010/telumia/issues/12). Fonte Desktop: `bed7ecf756abb6f49e7e222acba2460f69a20039`.

Tamanhos, SHA-256, manifesto, checksums e testes estão em [telumia-1.0.10-stable-release.json](telumia-1.0.10-stable-release.json). Não houve QA em TV Box/PC físico, medição de heap/jank ou teste offline integral; a Fase 1-D permanece aberta.

## v1.0.9 — cache limitado de resolução Simkl

[Release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.9), publicada pelo workflow [40985591359](https://github.com/Pepeu2010/telumia/actions/runs/40985591359). O CI passou os testes selecionados Live TV, compilou e assinou cinco APKs Android TV/TV Box Full Debug com a chave persistente e verificou os dez assets, manifesto e checksums. A execução levou 8m32s; testes/build Android levaram 6m32s. Android 1.0.9 usa versionCode 10019.

A release contém APK universal, ARM64, ARM32, x86_64 e x86, fontes, manifesto e SHA256SUMS.txt; o [APK universal está disponível diretamente](https://github.com/Pepeu2010/telumia/releases/download/v1.0.9/Telumia-TV-1.0.9-universal-debug.apk). O Windows PC permanece `Telumia-Windows-x64-1.0.4.msi` (Desktop 1.0.4, ProductVersion 2.0.4), copiado e validado byte a byte da release Desktop [v1.0.4](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.4). O código Desktop não mudou e o MSI não foi recompilado.

A mudança de TV limita por TTL/LRU os caches de IDs resolvidos, episódios Simkl↔TVDB e temporadas de anime. As capacidades iniciais dependem do tier: LOW_RAM/UNKNOWN 24 IDs, 4 listas de episódio e 8 temporadas; BALANCED 48/8/16; HIGH_CAPACITY 96/16/32. A fonte da release é [`201de3a`](https://github.com/Pepeu2010/telumia-tv/commit/201de3a4885dee43eb8c1ded9c6e0f933745ae36), com implementação no [PR #31](https://github.com/Pepeu2010/telumia-tv/pull/31) empilhado sobre o [#30](https://github.com/Pepeu2010/telumia-tv/pull/30), aprovado na fundação [Telumia #12](https://github.com/Pepeu2010/telumia/issues/12). Desktop: `bed7ecf756abb6f49e7e222acba2460f69a20039`.

Cinco testes novos passaram e o build local gerou as cinco variantes. A seleção ampliada executou 190 testes e encontrou a falha já conhecida da verificação de mock em `TraktAuthServiceTest`, reproduzida no commit-base limpo. Detalhes, limites e hashes em [RELATED_CACHE.md](https://github.com/Pepeu2010/telumia-tv/blob/codex/1d-tv-simkl-id-cache-lru/docs/RELATED_CACHE.md) e [telumia-1.0.9-stable-release.json](telumia-1.0.9-stable-release.json). Sem QA físico ou teste offline integral; a Fase 1-D continua aberta. Os APKs Full Debug usam assinatura persistente; a versão 1.0.0 ainda precisa da migração única de certificado aceita pelo usuário.

## v1.0.8 — limites LRU para caches relacionados da TV

[Release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.8), publicada pelo workflow [40983262987](https://github.com/Pepeu2010/telumia/actions/runs/40983262987). O CI passou os testes selecionados de Live TV, compilou e assinou cinco APKs Android TV/TV Box Full Debug pela chave persistente e verificou todos os dez assets, manifesto e checksums. A execução levou 9m35s; a etapa Gradle de testes/build Android levou 7m31s. Android 1.0.8 usa versionCode 10018.

A página oferece [APK universal](https://github.com/Pepeu2010/telumia/releases/download/v1.0.8/Telumia-TV-1.0.8-universal-debug.apk), ARM64, ARM32, x86_64 e x86, mais fontes, manifesto e SHA256SUMS.txt. O Windows PC está incluído como `Telumia-Windows-x64-1.0.4.msi` (Desktop 1.0.4, ProductVersion 2.0.4), copiado e verificado byte a byte da release Desktop estável [v1.0.4](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.4). Não houve mudança na fonte Desktop e o MSI não foi recompilado; a versão do PC é independente da versão Android.

A fonte TV distribuída é o commit [`11c17af`](https://github.com/Pepeu2010/telumia-tv/commit/11c17af1d2208a3081f4b7a43c07c0e328f43b33), branch `codex/1d-tv-related-cache-lru`, no [PR #30](https://github.com/Pepeu2010/telumia-tv/pull/30), empilhado sobre o PR de cache de trailers [#29](https://github.com/Pepeu2010/telumia-tv/pull/29). A fonte Desktop é `bed7ecf756abb6f49e7e222acba2460f69a20039`. Os caches Trakt e Simkl de itens relacionados agora têm TTL e LRU com limites de entradas por tier de memória; veja [detalhes e testes](MEDIA_CACHE.md#limites-lru-nos-caches-relacionados-de-trakt-e-simkl-na-tv--30-de-outubro-de-2026).

O registro [telumia-1.0.8-stable-release.json](telumia-1.0.8-stable-release.json) guarda tamanhos e SHA-256 de todos os APKs, MSI e fontes, além dos hashes do manifesto e checksums. A release está marcada como estável (`prerelease=false`). Não houve QA em PC ou TV Box física. Os APKs usam o flavor Full Debug; quem ainda usa o pacote Android 1.0.0 com o certificado antigo precisa completar a migração única aceita pelo usuário. A Fase 1-D permanece aberta.

## v1.0.7 — cache LRU de trailers e atualização estável

[Release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.7), publicada pelo workflow [40976480710](https://github.com/Pepeu2010/telumia/actions/runs/40976480710). O workflow passou os testes selecionados de Live TV, compilou e assinou cinco APKs Android TV/TV Box Full Debug pela chave persistente, verificou o MSI e validou assets, manifesto e checksums. O build Gradle terminou em 8m18s; a execução completa, incluindo publicação e verificações, em 11m16s. Android 1.0.7 usa versionCode 10017 e pode atualizar a versão 1.0.6 assinada pela chave atual.

A página contém APK universal, ARM64, ARM32, x86_64 e x86, além de MSI Windows x64, fontes das duas plataformas, manifesto e SHA256SUMS.txt. Os cinco APKs foram gerados nesta execução. O MSI Telumia-Windows-x64-1.0.4.msi foi copiado e verificado byte a byte da release Desktop estável v1.0.4; o cliente Desktop não mudou nesta entrega e o MSI não foi recompilado. A versão Windows permanece Desktop 1.0.4/ProductVersion 2.0.4, independente da versão Android.

A fonte TV é o commit [6224107](https://github.com/Pepeu2010/telumia-tv/commit/6224107be17ed15db4b9a030c5409839b6dc7f3c), atualização estável da implementação de cache de trailers no [PR #29](https://github.com/Pepeu2010/telumia-tv/pull/29), empilhada sobre os PRs [#28](https://github.com/Pepeu2010/telumia-tv/pull/28) e [#27](https://github.com/Pepeu2010/telumia-tv/pull/27). A fonte Desktop é o commit [bed7ecf](https://github.com/Pepeu2010/telumia-desktop/commit/bed7ecf756abb6f49e7e222acba2460f69a20039). O manifesto tem oito pacotes/fontes; os nove registros de SHA256SUMS e os dez assets publicados conferem com os metadados do GitHub. Tamanhos e hashes completos estão em [telumia-1.0.7-stable-release.json](telumia-1.0.7-stable-release.json).

Não houve QA em PC ou TV Box física nem teste físico de atualização do MSI. Quem ainda usa o APK Android 1.0.0 precisa da migração única de assinatura, com backup e reinstalação. Os limites do cache de trailers são por número de entradas, não bytes, e o tier é medido ao criar o serviço; a Fase 1-D continua aberta.

## v1.0.6 — cache LRU de metadata TMDB e atualização estável

[Release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.6), publicada pelo workflow [40973005685](https://github.com/Pepeu2010/telumia/actions/runs/40973005685). O job passou pelos testes Live TV, compilou e verificou cinco APKs Android TV/TV Box Full Debug assinados com a chave persistente, e conferiu manifesto, checksums e MSI antes da publicação. O Android usa `versionName` `1.0.6` e `versionCode` `10016`, permitindo atualização assinada sobre a versão 1.0.5.

Os APKs disponíveis são universal, ARM64, ARM32, x86_64 e x86. O Windows PC está incluído como `Telumia-Windows-x64-1.0.4.msi` (Desktop 1.0.4, `ProductVersion` 2.0.4), copiado byte a byte da release estável Desktop [v1.0.4](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.4); não houve mudança de fonte Desktop nem nova compilação do MSI nesta entrega. A versão Android e a versão Desktop são independentes.

Fonte Android: commit [`d3e9036`](https://github.com/Pepeu2010/telumia-tv/commit/d3e9036d5eb690da9455c243540b6af58f649ea9), PR de versão [#28](https://github.com/Pepeu2010/telumia-tv/pull/28) empilhada sobre a implementação de cache [#27](https://github.com/Pepeu2010/telumia-tv/pull/27). Fonte Desktop: commit [`bed7ecf`](https://github.com/Pepeu2010/telumia-desktop/commit/bed7ecf756abb6f49e7e222acba2460f69a20039). O workflow terminou com sucesso; o build e os testes Live TV duraram 7m55s. Na validação focada anterior da fonte TMDB passaram 33 testes e `:app:assembleFullDebug` gerou cinco variantes.

O manifesto contém oito artefatos e `SHA256SUMS.txt` lista os nove demais assets. Os dez uploads publicados coincidem com os tamanhos e digests do GitHub; hashes completos em [telumia-1.0.6-stable-release.json](telumia-1.0.6-stable-release.json). Não houve QA em PC ou TV Box física, nem teste físico de atualização do MSI.

## v1.0.5 — cache adaptativo e pacote estável combinado

A [release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.5) foi publicada pelo workflow [40968813219](https://github.com/Pepeu2010/telumia/actions/runs/40968813219), que passou as verificações de versão e assinatura, a suíte de Live TV, build dos cinco APKs, validação de APKs, MSI, fontes, manifesto e checksums. A página contém APK universal e variantes ARM64, ARM32, x86 e x86_64, MSI Windows x64, fontes das duas plataformas, `release-manifest.json` e `SHA256SUMS.txt`. Os oito artefatos binários/fontes cobertos por checksums coincidem com os tamanhos e digests informados pelo GitHub.

O Android usa `versionName` `1.0.5`, `versionCode` `10015` e a chave persistente do CI. O pacote Windows é `Telumia-Windows-x64-1.0.4.msi`, Desktop 1.0.4 e `ProductVersion` `2.0.4`; sua versão é separada da numeração Android. O MSI foi compilado localmente porque o workflow padrão Desktop parou antes de compilar por não encontrar `LOCAL_PROPERTIES_BASE64`, `SENTRY_AUTH_TOKEN` e `SENTRY_DESKTOP_DSN`. O pacote foi extraído administrativamente sem instalação e teve seus componentes Windows e runtime Java inspecionados; sua release de plataforma está em [telumia-desktop v1.0.4](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.4). A fonte Desktop foi arquivada com 142 objetos LFS resolvidos, sem ponteiros restantes. Commits usados: Desktop [`bed7ecf`](https://github.com/Pepeu2010/telumia-desktop/commit/bed7ecf756abb6f49e7e222acba2460f69a20039) e TV [`d58ca1c`](https://github.com/Pepeu2010/telumia-tv/commit/d58ca1c807e691127e9e694f003fc69199dd8bd9). Manifesto, checksums e validações estão em [telumia-1.0.5-stable-release.json](telumia-1.0.5-stable-release.json).

No incremento de quota dinâmica que acompanha a fonte da TV, passaram localmente 22 testes focados Desktop e 19 TV; builds locais de MSI e APK também passaram. O CI publicou os APKs assinados. A chave persistente mantém atualização sobre instalações posteriores à migração inicial; quem ainda usa Android 1.0.0 precisa fazer backup e desinstalar/reinstalar por causa do certificado antigo. Não houve instalação de atualização MSI em máquina real nem QA física de PC/TV Box nesta rodada. A assinatura e os hashes dos artefatos publicados foram verificados pelo workflow.

## v1.0.3 — atualizador estável na TV

A [release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.3) foi publicada pelo workflow [40783964313](https://github.com/Pepeu2010/telumia/actions/runs/40783964313). Ela contém cinco APKs Full Debug para Android TV/TV Box (universal, ARM64, ARM32, x86_64 e x86), MSI Windows x64 Desktop 1.0.2, fontes das duas plataformas, manifesto e `SHA256SUMS.txt`. Os nove arquivos cobertos pelos checksums foram verificados contra os digests publicados. O Android usa `versionName` `1.0.3`, `versionCode` `10011` e a chave persistente do CI.

O atualizador Android TV foi integrado ao cliente publicado. Ele consulta `GET /repos/Pepeu2010/telumia/releases/latest`, que retorna a release publicada mais recente sem draft/prerelease, e também aplica filtros de tag/título; seleciona o APK compatível, mostra o progresso e entrega o pacote ao instalador padrão do Android. O sistema pode exigir permissão de instalação e confirmação. A [política do atualizador](https://github.com/Pepeu2010/telumia-tv/blob/f007c243e52e19bf7b176e5d8cc59e2cc7cd82b4/UPDATE_POLICY.md) descreve o comportamento. O código-fonte é o commit TV [`f007c243e52e19bf7b176e5d8cc59e2cc7cd82b4`](https://github.com/Pepeu2010/telumia-tv/commit/f007c243e52e19bf7b176e5d8cc59e2cc7cd82b4).

O MSI `Telumia-Windows-x64-1.0.2.msi` foi reutilizado da [release Desktop v1.0.2](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.2), com `ProductVersion` `2.0.2`: não houve mudança no cliente Desktop nesta entrega. O atualizador estável para Windows permanece incluído nesse pacote. O Android 1.0.3 pode atualizar o Android 1.0.2 assinado pela chave persistente; quem ainda usa o APK 1.0.0 precisa da migração única documentada abaixo. A compilação local da variante Full Debug passou 19 testes de atualizador/identidade e gerou cinco APKs de validação; o CI produziu os APKs publicados, verificou assinatura/checksums e terminou com sucesso. AVD/API 30 ou TV Box física não foi testada nesta rodada.

## v1.0.2 — release estável combinada

A [release estável principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.2) contém cinco APKs Full Debug (universal, ARM64, ARM32, x86_64 e x86), o MSI Windows x64 `Telumia-Windows-x64-1.0.2.msi`, fontes Desktop e TV, manifesto e `SHA256SUMS.txt`. Os nove arquivos cobertos pelo manifesto/checksums conferem com os digests publicados. O workflow [40778936963](https://github.com/Pepeu2010/telumia/actions/runs/40778936963) terminou com sucesso e publicou os pacotes da TV e o MSI Desktop estável `v1.0.2`.

O MSI Desktop tem `ProductVersion` `2.0.2` e a release correspondente está em [telumia-desktop v1.0.2](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.2). Ela inclui o atualizador Desktop dentro do app, consulta somente releases estáveis e apresenta o progresso do download antes de iniciar o instalador do Windows.

Os APKs usam o certificado persistente atual `a8e12bfa…ecdd9` para permitir atualizações futuras entre releases assinadas pela mesma chave. O APK 1.0.0 usava o certificado `ff2d4eda…51b746`; portanto, a migração Android inicial exige desinstalar e reinstalar, com risco de perda dos dados locais. O usuário aceitou essa migração e as notas da release orientam a preservar os dados antes da troca. O atualizador Android TV permanece em revisão no [PR #21](https://github.com/Pepeu2010/telumia-tv/pull/21), aprovado pela issue [#13](https://github.com/Pepeu2010/telumia/issues/13); ele ainda não faz parte desta release combinada.

## v1.0.2-alpha.4 — assinatura persistente e pacotes combinados

A [pré-release combinada](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.2-alpha.4) foi publicada pelo workflow [40242583495](https://github.com/Pepeu2010/telumia/actions/runs/40242583495). A página contém cinco APKs Full Debug para Android TV/TV Box (universal, ARM64, ARM32, x86_64 e x86), o MSI Windows x64, fontes das duas plataformas, manifesto e SHA256SUMS. Os 9 arquivos cobertos por SHA256SUMS conferem com os digests dos assets publicados no GitHub; o APK ARM64 baixado da release também confere com o SHA listado.

Fonte Android TV: commit `e1e7d992c4ee1d9ccf9904e0ef54b0e8f23efd2f`, `versionName` `1.0.2-alpha.4` e `versionCode` `10009`. Os APKs Full são assinados com a chave persistente do CI, cujo certificado tem SHA-256 `a8e12bfa1adfe087baa573b27a77e07902b73ea707b3a9b82635206c725ecdd9`; ela mantém compatibilidade entre releases futuras. **Quem ainda usa o APK Android 1.0.0 precisa fazer uma migração única removendo a instalação antiga antes de instalar este APK**, porque os certificados são diferentes e a chave privada da assinatura antiga não foi recuperada. Remover o app pode apagar dados locais; confirme a sincronização ou faça backup antes. Para detalhes, veja a auditoria de compatibilidade abaixo.

O pacote PC é `Telumia-Windows-x64-1.0.2-alpha.1.msi`, `ProductVersion` `2.0.1`, da [release Desktop v1.0.2-alpha.1](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.2-alpha.1). Ele avança sobre o `ProductVersion` `2.0.0` do MSI 1.0.0 e mantém o mesmo `upgradeUuid`; portanto, foi preparado para atualizar a instalação existente pelo Windows Installer. A substituição sobre uma instalação 1.0.0 não foi exercitada numa máquina Windows nesta entrega.

## v1.0.2-alpha.3 — Phone Remote R1

A [pré-release combinada](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.2-alpha.3) foi publicada em 25/10/2026 no repositório principal. Ela contém cinco APKs Android TV/TV Box Full Debug (universal, ARM64, ARM32, x86_64 e x86), o MSI Windows x64 Desktop 1.0.0, fontes das duas plataformas, manifesto e SHA256SUMS. Os dez assets foram conferidos por estado, tamanho e digest SHA-256. O workflow [40233135869](https://github.com/Pepeu2010/telumia/actions/runs/40233135869) passou os testes Live TV e Phone Remote, compilou os APKs, verificou o MSI e publicou a release.

Fonte TV: commit `571b4ab475cd0d3caf5f1d111030c2bb75a4c806`, versionCode `10008`. Os APKs locais foram compilados em `assembleFullDebug` e verificados com `apksigner`; os APKs publicados foram recompilados no runner do GitHub Actions. O Windows MSI é a última release estável Desktop `v1.0.0` (ProductVersion 2.0.0), mantida separada da versão Android. O Phone Remote R1 funciona por opt-in na LAN; não houve QA em TV Box ou celular físicos. [Escopo e limites](PHONE_REMOTE.md).

## Compatibilidade de atualização 1.0.0 → 1.0.2-alpha.3

Auditoria dos pacotes publicados em 25/10/2026: o APK ARM64 de v1.0.0 e o de v1.0.2-alpha.3 mantêm o application ID **io.github.pepeu2010.telumia.tv.debug** e avançam o versionCode de **10000** para **10008**, mas não têm a mesma assinatura. O certificado publicado em v1.0.0 tem SHA-256 **ff2d4eda827287ee3ea1a6d87830c9e5427917d50e007ca4552271e54551b746**; em v1.0.2-alpha.3, **245885ebb967f1e409d3bc255a7e08f1b3ddaf299c4f33458e54de9a50a71c01**. O Android rejeita a instalação por cima quando os certificados divergem. A chave privada de v1.0.0 não está disponível nos segredos atuais do repositório nem pode ser reconstruída a partir do certificado público dentro do APK; sem recuperar o keystore original, essa instalação Android exige uma reinstalação inicial e pode perder dados locais.

Para o PC, v1.0.2-alpha.3 não traz uma versão Desktop nova: o MSI tem o mesmo SHA-256 **9f8e3cc98b716421da0784afa0fa3d9bb2f5b8cfadb59f44481c72f2d4aff306** e o mesmo tamanho do MSI da release v1.0.0; o manifesto identifica sourceReleaseTag v1.0.0 e ProductVersion 2.0.0. O cliente Desktop mantém upgradeUuid **1c69d968-d0e0-4b0f-b5c0-615b8ea92f90**, portanto um MSI posterior com versão do instalador maior pode substituir a instalação existente pela lógica de upgrade do Windows Installer. Esse MSI novo ainda precisa ser publicado no repositório principal.

O atualizador Android da fonte anterior consultava Pepeu2010/telumia-tv, não o repositório principal Pepeu2010/telumia. A nova branch TV agora aponta para o repositório principal, e o workflow usa a chave persistente guardada nos secrets. Ela foi validada num APK local: SHA-256 do certificado **a8e12bfa1adfe087baa573b27a77e07902b73ea707b3a9b82635206c725ecdd9**. O MSI Desktop 1.0.2-alpha.1 foi publicado em [sua release de plataforma](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.2-alpha.1), com ProductVersion 2.0.1, fonte LFS conferida e checksums. A release combinada principal v1.0.2-alpha.3 permanece intacta e ainda contém o MSI antigo 1.0.0; a execução seguinte do workflow principal deve produzir a nova release combinada. A chave persistente impede novas quebras de assinatura, mas não restaura compatibilidade retroativa com o APK v1.0.0, cuja instalação ainda exige reinstalação inicial.

## v1.0.2-alpha.2 — Live TV R2

A [pré-release combinada](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.2-alpha.2) foi publicada em 25/10/2026 no repositório principal. Reúne cinco APKs Android TV/TV Box Full Debug (universal, ARM64, ARM32, x86_64 e x86), o MSI Windows x64 Desktop 1.0.0, fontes de ambas as plataformas, manifesto e SHA256SUMS. Os dez assets foram conferidos no GitHub por estado, tamanho e digest SHA-256. Na [primeira execução](https://github.com/Pepeu2010/telumia/actions/runs/40221791258), os nove grupos de testes Live TV e o build passaram; a [execução de recuperação](https://github.com/Pepeu2010/telumia/actions/runs/40223189310) validou os assets do rascunho, publicou a tag e terminou com sucesso.

Fonte TV: commit `9e7d448a480094ac396298046a93c550eef0e1dc`, versionCode `10007`. O MSI é o pacote da release Desktop `v1.0.0` (versão do instalador 2.0.0), identificado separadamente da versão Android. Os APKs são assinados com chave de desenvolvimento. Não houve teste instrumentado nesta rodada nem validação em TV Box física. Os APKs também foram preservados localmente em `artifacts/builds/v1.0.2-alpha.2/`.

## v1.0.2-alpha.1 — pacote preparado

Os dez assets foram gerados e verificados localmente para uma pré-release combinada de Scene Info R1. **Ainda não publicada:** não há release nem tag `v1.0.2-alpha.1` no GitHub. A conexão GitHub desta sessão permite atualizar arquivos e branches, mas não oferece criação de releases ou upload de binários; o GitHub CLI e uma credencial local de publicação também não estão disponíveis. O conjunto pronto para upload está em `artifacts/releases/v1.0.2-alpha.1/`.

O pacote contém MSI Windows x64 do Desktop 1.0.2-alpha.1 (ProductVersion técnico 2.0.1) e cinco APKs Android TV Full Debug (universal, ARM64, ARM32, x86_64 e x86; versionCode 10006), mais dois arquivos de fonte, manifesto e checksums. O MSI não tem assinatura Authenticode; os APKs usam certificado de desenvolvimento e podem exigir desinstalação se a chave instalada for diferente.

Fontes compiladas: Desktop `3e7894659e7489772b06520e89776f3dc040ffe2`; TV `f3809b4027f91262732e722842b7c0bec2111c36`. Passaram 24 testes direcionados Desktop e 5 testes direcionados TV; `packageReleaseMsi`, `assembleFullDebug` e a compilação dos testes instrumentados Android passaram. Instrumentação TV, instalação, reprodução com mídia real e TV Box física não foram testadas nesta rodada. [Resultados](telumia-v102-alpha1-results.json), [inspeção dos pacotes](telumia-v102-alpha1-package-inspection.json), [notas preparadas](v1.0.2-alpha.1-release-notes.md).

## v1.0.1 — estável

As releases regulares [Telumia 1.0.1 no repositório principal](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.1) e [Telumia TV 1.0.1](https://github.com/Pepeu2010/telumia-tv/releases/tag/v1.0.1) estão publicadas como Latest, sem marca de pré-release. Ambas incluem APK universal, ARM64, ARM32, x86_64 e x86, além do MSI Windows. O Android usa `versionName` 1.0.1 e `versionCode` 10005. O MSI é o pacote estável Desktop 1.0.0 já publicado em [Telumia Desktop v1.0.0](https://github.com/Pepeu2010/telumia-desktop/releases/tag/v1.0.0); esta entrega não altera o cliente PC. O verificador agora permite que a versão PC tenha numeração própria, distinta da tag agregada.

Os cinco APKs são Full Debug para desenvolvimento, com assinatura de desenvolvimento e package ID `io.github.pepeu2010.telumia.tv.debug`; não são builds de loja/produção. Passaram 25 testes unitários direcionados; `assembleFullDebug` passou, os manifests foram conferidos e todas as assinaturas foram verificadas. Não houve teste instrumentado ou validação em TV Box física. A integridade remota dos oito assets em cada release, os estados Latest/pré-release e os commits fonte constam em [telumia-v101-tv-main-verification.json](telumia-v101-tv-main-verification.json). As fontes exatas são TV `776924e9abfda3120b1b5ec74e96de17c86b9ca4` e MSI Desktop `470c38d5cc02e597c94ea562f5d645f49f8fad60`.

## v1.0.1-alpha.4 — ranking compatível com HDR da tela

A [pré-release Telumia](https://github.com/Pepeu2010/telumia-tv/releases/tag/v1.0.1-alpha.4) está publicada com APK universal, ARM64, ARMv7, MSI Windows x64 Telumia Desktop **1.0.0** e `SHA256SUMS.txt`. A versão de PC está indicada separadamente da versão Android TV e o manifesto cobre todos os quatro pacotes. O workflow [39521569001](https://github.com/Pepeu2010/telumia-tv/actions/runs/39521569001) passou os testes focados, compilou a instrumentação Android e montou os três APKs. Os hashes remotos dos APKs coincidem com os artefatos do CI; o MSI coincide com a release Desktop `v1.0.0`.

A publicação pelo workflow [39522891457](https://github.com/Pepeu2010/telumia-tv/actions/runs/39522891457) validou os artefatos e o MSI, mas recebeu HTTP 403 ao criar uma nova release com `GITHUB_TOKEN`. A mesma release foi criada e publicada pela sessão GitHub autenticada, conferindo tamanhos e digests dos cinco assets. Os APKs são Full Debug assinados pela chave temporária do CI; pode ser preciso desinstalar uma versão anterior. HDR foi classificado pelo formato explicitamente anunciado e pelas capacidades atuais da tela/decoder; não houve reprodução/QA física em TV Box.

As três releases antigas `v0.2.0-alpha.1`, `v0.2.1-alpha.1` e `v0.2.2-alpha.1` também foram completadas com o MSI Desktop 1.0.0 e checksums atualizados pelos workflows [39522956180](https://github.com/Pepeu2010/telumia-tv/actions/runs/39522956180), [39522267169](https://github.com/Pepeu2010/telumia-tv/actions/runs/39522267169) e [39522354193](https://github.com/Pepeu2010/telumia-tv/actions/runs/39522354193). O commit `3f6ee5e` corrige a leitura dos manifests CRLF antigos.

## v1.0.1-alpha.3 — seleção com inventário de decoder Android

A [pré-release Telumia](https://github.com/Pepeu2010/telumia-tv/releases/tag/v1.0.1-alpha.3) foi publicada em 20/10/2026, sem alterar `v1.0.0`. Inclui APK universal, ARM64, ARMv7, MSI Windows x64 Desktop **1.0.0** e `SHA256SUMS.txt`; as versões Android TV e PC estão identificadas separadamente. Os testes focados passaram, os testes instrumentados foram compilados e os três APKs Full Debug foram montados no workflow [39509908598](https://github.com/Pepeu2010/telumia-tv/actions/runs/39509908598). O publicador [39511555672](https://github.com/Pepeu2010/telumia-tv/actions/runs/39511555672) validou os artefatos e o MSI antes de publicar; os hashes exibidos no GitHub correspondem aos três APKs do CI. A mudança pontua compatibilidade declarada de codec/resolução e mantém fontes desconhecidas ou não suportadas como opções de fallback. Os APKs são de desenvolvimento, assinados pela chave temporária de CI; pode ser necessário remover a versão anterior para instalar. A instrumentação não foi executada em dispositivo e não houve QA física em TV Box.

## v1.0.1-alpha.2 — capacidades de tela e decoder centralizadas

A [pré-release Telumia](https://github.com/Pepeu2010/telumia-tv/releases/tag/v1.0.1-alpha.2) foi publicada em 20/10/2026, sem alterar a release estável `v1.0.0`. Contém APK universal, ARM64, ARMv7 e o instalador Windows x64 da Desktop **1.0.0**, com `SHA256SUMS.txt` cobrindo os quatro pacotes. A versão Desktop é indicada separadamente porque ainda não há build PC `1.0.1-alpha.2`. Os APKs vieram do run [39503569320](https://github.com/Pepeu2010/telumia-tv/actions/runs/39503569320), commit `96fd0492b17ad79b7fa9103d3f12d313658c147e`; o MSI foi copiado byte a byte da release Desktop estável e seu hash coincide com a origem e com o asset publicado.

O incremento reúne em `DeviceCapabilities` a consulta dos modos da tela, HDR e perfis de decoder Dolby Vision. A política de escolha Dolby foi preservada. O CI passou 99 testes unitários selecionados, compilou os testes instrumentados e montou os três APKs. Os testes instrumentados não foram executados em dispositivo, e não houve validação física de desempenho em TV Box. Os APKs são builds Full Debug assinados por uma chave temporária de CI; pode ser preciso desinstalar uma versão anterior para instalar esta pré-release.

## v1.0.1-alpha.1 — recursos adaptados à memória

A [pré-release Telumia](https://github.com/Pepeu2010/telumia-tv/releases/tag/v1.0.1-alpha.1) foi publicada em 20/10/2026, sem alterar a release estável `v1.0.0`. Contém APK universal, ARM64, ARMv7 e o instalador Windows x64 da Desktop **1.0.0**, com `SHA256SUMS.txt` cobrindo os quatro pacotes. Os APKs vieram do run [39498212243](https://github.com/Pepeu2010/telumia-tv/actions/runs/39498212243), commit `f01f882b36a9fa854112f118229fd8be3dab79dd`; o pacote PC permanece claramente identificado como 1.0.0.

Os testes focados passaram, os testes instrumentados foram compilados e não executados em aparelho. Os APKs são de depuração, assinados pela chave temporária do CI; a chave pode não corresponder a uma instalação anterior. Não houve QA física da TV Box. Esta pré-release não é `Latest` e não encerra a meta.

## v1.0.0 — release regular

A [Telumia 1.0.0](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.0) foi publicada sem sufixo alpha, como release regular e “Latest” nos três repositórios. Inclui MSI Windows x64, APK TV universal/quatro ABIs, fontes, manifesto e SHA256SUMS. **22 assets remotos verificados por tamanho, estado e digest SHA-256.** [Verificação](telumia-v100-publication-r1-verification.json), [registro da publicação](telumia-v100-publication-results.json), [entrega e limites](VERSION_100.md).

Em 21/10/2026, a release do repositório principal foi conferida novamente: os cinco APKs Android TV e `Telumia-Windows-x64.msi` aparecem na mesma página; os dez assets centrais conferem com os hashes locais. [Verificação](telumia-v100-main-apk-pc-r3-verification.json).

Distribui Desktop `470c38d5cc02e597c94ea562f5d645f49f8fad60` e TV `6b58f39aa4af718d8208205115b45fa04f1359cb`; a tag central aponta para `ded35541178aa2bc36b43fcc33db7d382ee3a889`. Passaram 279 testes selecionados Windows e 214 TV, sem falhas/erros/skips. O renderer passou oito execuções/1.092 verificações; dez casos nativos de frames e startup real de 30 segundos passaram nas APIs 24 e 36. As fontes incluem 142 objetos Git LFS reais no Desktop, sem ponteiros pendentes.

Acrescenta capítulos reais do arquivo no PC, canal de atualização regular e a fundação de extração Media3 na TV, além dos incrementos anteriores. A numeração interna MSI 2.0.0 supera a alpha 1.2.2 com UpgradeCode preservado. APKs informam 1.0.0/código 10000 e conservam ID/certificado anteriores. Continuam **Android TV Full Debug de desenvolvimento**; integração visual/D-pad das miniaturas TV, conta oficial autenticada, hardware/HDR, migração de dados instalados e a meta integral permanecem pendentes. Nenhum arquivo das alphas foi alterado.

## v0.2.2-alpha.1 — conta, navegação, momentos e player

A [nova pré-release](https://github.com/Pepeu2010/telumia/releases/tag/v0.2.2-alpha.1) está publicada nos três repositórios: MSI Windows x64, APK TV universal/quatro ABIs, fontes, manifesto e SHA256SUMS. **22 assets remotos verificados por tamanho, estado e digest SHA-256.** [Verificação](telumia-v022-release-verification.json), [entrega e limites](ALPHA_022.md).

Distribui Desktop `b39b6ea79d37b7c9eb1383ef68692dd2309d664d` e TV `e1962f736410a288f3a8db92fa6d2eaa4eaaa66b`; tag central `62fa214f37300ca42759042a14fb4597eb40e5d7`. Passaram 268 testes selecionados Windows e 200 TV, sem falhas/erros/skips, com builds em árvores limpas. O renderer PC passou oito execuções/1.052 verificações; o painel TV passou 12 casos em 720p/1080p/4K, com seis capturas revisadas. A MainActivity real passou nas APIs 24 e 36 com o mesmo APK, sem crash/ANR nos 30 segundos observados.

Reúne os incrementos de seleção de perfis, motion/navegação, reconciliação durável de coleções/addons nos contratos existentes, momentos salvos e thumbnails/filmstrip/composição do player Windows. Inclui validação nativa de headers HTTP e remoção de uma injeção não utilizada na Application TV. ZIP Desktop com 142 objetos LFS conferidos; os APKs continuam Android TV Full Debug de desenvolvimento.

Essa alpha não encerra o plano. Conta oficial autenticada, WebView2 completo, hardware físico/HDR/DPI, execução Linux/macOS, thumbnails TV e as demais fases continuam pendentes. Rascunhos tiveram seus uploads conferidos por ID antes da publicação; a primeira tentativa de consulta pela tag retornou 404 e foi preservada. [Publicação e recuperação](telumia-v022-publication-results.json). Nenhum asset de versão anterior foi substituído.

## v0.2.1-alpha.1 — Home, cache e editores locais de avatar

A [pré-release](https://github.com/Pepeu2010/telumia/releases/tag/v0.2.1-alpha.1) está publicada nos três repositórios. Inclui MSI Windows x64, APK Android TV universal e variantes ARM64/ARM32/x86/x86_64, fontes correspondentes, manifesto e SHA256SUMS. Foram verificados os 22 assets remotos por tamanho e digest SHA-256. [Registro da publicação](telumia-profile-studio-release-verification.json).

Distribui Desktop `0a3b34aff26f032caf7b5b7b5296c840cdc70e5d` e TV `bb3faa3877a33db46eea3e08ac65ff1e21e291a0`, com 149 e 111 testes selecionados, sem falhas/erros/skips, e builds sobre árvores limpas. O incremento inclui Home/detalhes cinematográficos, base de timed metadata, orçamento de cache Auto/Manual e editores de avatar nos fluxos existentes. Os APKs continuam Full Debug de desenvolvimento para TV.

O manifesto e as fontes foram conferidos antes da publicação. O ZIP Desktop contém 142 objetos LFS com hashes/tamanhos verificados, sem ponteiros pendentes; o ZIP TV foi verificado sem objetos LFS. Os APKs de aplicativo e testes conferem byte a byte com os quatro testes raster Android e 15 testes de interface em três resoluções, com 12 capturas revisadas. [Gates](telumia-profile-studio-release-results.json), [pacotes](telumia-profile-studio-release-package-inspection.json) e [alcance do Profile Studio](PROFILE_STUDIO.md).

A release não encerra o produto: previews de vídeo, thumbnails/filmstrip, Scene Info, Source Intelligence, Live TV/EPG e o Profile Studio completo continuam pendentes. O redesenho posterior da seleção de perfis não está nestes binários. As suítes selecionadas não comprovam todos os fluxos de conta/reprodução ou desempenho em TV física. Não há cliente específico de celular nem instaladores Linux/macOS nesta entrega.

## v0.2.0-alpha.1 — marca própria e catálogos brasileiros

A [pré-release Telumia](https://github.com/Pepeu2010/telumia/releases/tag/v0.2.0-alpha.1) inclui o MSI Windows, APK Android TV universal e quatro variantes por arquitetura, fontes correspondentes, manifesto e checksums. Foram conferidos 22 assets entre o repositório central e os dois clientes, por tamanho e SHA-256. [Registro da publicação](telumia-release-verification.json).

As fontes distribuídas são Desktop `fdeaddfe3d0dc026ecd3d632210ce4dd212783ad` e TV `0355dfe4366ebce3067718eaf9dfb3139dd8f243`. Esta entrega inclui nome, logo, IDs e caminhos próprios, aliases brasileiros de Iludida e seleção da edição brasileira quando uma fonte configurada a disponibiliza. Não contém os incrementos posteriores de Home, detalhes, timed metadata, cache ou Profile Studio. Os APKs são Full Debug de desenvolvimento; não há pacote específico para celular, Linux ou macOS.

As releases históricas abaixo conservam seus arquivos e metadados. A nova geração utiliza os [repositórios Telumia](../README.md); os URLs antigos podem redirecionar no GitHub.

## Verificação dos próximos arquivos de fonte

O preparador agora confere os objetos Git LFS dentro do ZIP e recusa ponteiros sem os binários correspondentes. Na validação Desktop do commit `f2775da4f3722db19e0d1e2c619ff8154b87c548`, passaram os hashes e tamanhos de **142 objetos, 293.336.120 bytes**, sem ponteiros pendentes. Neste ambiente o próprio Git já expandiu esses arquivos; não foi necessário reidratá-los. [Evidência do arquivo de fonte](telumia-desktop-source-archive-inspection.json).

Essa validação não publica uma nova versão nem comprova execução em Linux/macOS. O binário libmpv também foi encontrado no ZIP da release Telumia já publicada; a hipótese inicial de que aquele arquivo conteria apenas um ponteiro não se confirmou.

## v0.1.0-alpha.2 — incremento nativo 1-A.1

[Pré-release publicada](https://github.com/Pepeu2010/nuvio-enhanced/releases/tag/v0.1.0-alpha.2).
Os dez assets foram conferidos no GitHub por tamanho e digest SHA-256 antes de
publicar; registro em [motion-release-publication.json](motion-release-publication.json).
Acrescenta à fundação 0-C o movimento completo/reduzido/desligado nas configurações
de Aparência dos clientes existentes, salvo por perfil e fora do payload oficial
de sync. Não representa o redesign completo de 1-A.

MSI Windows x64, APK TV universal e variantes ARM32/ARM64/x86/x86_64, fontes
correspondentes, manifest e checksums acompanham a entrega. Os APKs continuam
Full Debug de desenvolvimento e as versões internas continuam herdadas.

| Cliente | Commit distribuído |
|---|---|
| Desktop | `a704c6d7b1761484d163f809e27e6af6a72f4757` |
| TV | `024e60aca0d6edf190c6eab465c4e335e16a8da4` |

**22 testes Desktop e 19 TV aprovados** e pacotes recompilados. O APK universal
foi instalado em emulador 1080p: seleção por D-pad, retorno de foco e persistência
após reinício foram observados. A imagem disponível é phone Android API 37.1
x86_64/16 KB com preset TV; não valida Android TV OS, TV Box física ou performance.
O sistema avisou sobre alinhamento nativo e executou em page size compatible
mode. Não se declara compatibilidade nativa com 16 KB. O login original por QR
falhou nessa sessão; conta/sync/playback e MSI instalado permanecem pendentes.
As 46 falhas completas herdadas do baseline continuam registradas.

Detalhes/capturas: [NATIVE_FOUNDATION.md](NATIVE_FOUNDATION.md),
[motion-results.json](motion-results.json), [motion-ui-qa.json](motion-ui-qa.json)
e [motion-package-inspection.json](motion-package-inspection.json).
Para reconstruir, siga os passos dos forks e faça checkout dos commits acima
com Git LFS; os ZIPs podem conter ponteiros LFS. Esta release central exige
download manual, pois os updaters consultam os repositórios dos clientes.

Os MSIs alpha.1 e alpha.2 mantêm ProductVersion `1.1.27` e ProductCode
`{06995AB3-8E6B-3211-9441-084EA9B585D5}`. Para trocar entre eles, remova a instalação
anterior do **Nuvio Enhanced** antes de instalar alpha.2. Os APKs mantêm versionCode
1066 e assinatura própria de desenvolvimento: instale com substituição da versão
anterior. A tag central ainda não substitui um versionamento interno por entrega.

O rascunho só foi publicado após verificação dos uploads por tamanho e SHA-256.

## v0.1.0-alpha.1 — fundação 0-C

[Pré-release publicada](https://github.com/Pepeu2010/nuvio-enhanced/releases/tag/v0.1.0-alpha.1).
Os dez assets foram conferidos no GitHub por tamanho, estado de upload e digest
SHA-256 antes da publicação; registro em [release-publication.json](release-publication.json).

Entrega experimental dos clientes existentes do Nuvio com a fundação do fork.
Não contém ainda o redesign, Profile Studio, nova timeline, Source Intelligence,
Scene Info, Live TV/EPG ou Phone Remote. A tag do repositório central identifica
o conjunto; não altera as versões internas herdadas dos aplicativos.

### Pacotes

- Windows x64: `NuvioEnhanced-Windows-x64-foundation.msi`, app `0.1.27-alpha`.
- Android TV: `NuvioEnhanced-TV-universal-debug.apk` e APKs específicos
  arm64-v8a, armeabi-v7a, x86_64 e x86. Flavor Full Debug, app `1.1.0-beta.3`,
  ID `io.github.pepeu2010.nuvioenhanced.tv.debug`, assinatura de desenvolvimento.
- Código-fonte dos clientes nos commits exatos indicados abaixo.
- `CHECKSUMS-SHA256.txt` e `release-assets.json` para integridade/proveniência.

### Fontes correspondentes e build

| Cliente | Commit distribuído |
|---|---|
| Desktop | `5674b49d67817a20aef33a5878412f52163c1e3f` |
| TV | `023edae7aeb403e6bf1dd5cb1bef4e6546fa2430` |

Os ZIPs de fonte preservam os arquivos rastreados, GPL e avisos. Arquivos geridos
por Git LFS podem estar representados por ponteiros no ZIP; para obter os inputs
binários do upstream, use o clone com Git LFS no commit exato. Nenhuma chave de
assinatura, credencial, configuração privada ou log local integra os arquivos.

```powershell
git clone https://github.com/Pepeu2010/nuvio-enhanced-desktop.git
git -C nuvio-enhanced-desktop checkout 5674b49d67817a20aef33a5878412f52163c1e3f
git -C nuvio-enhanced-desktop lfs pull

git clone https://github.com/Pepeu2010/nuvio-enhanced-tv.git
git -C nuvio-enhanced-tv checkout 023edae7aeb403e6bf1dd5cb1bef4e6546fa2430
git -C nuvio-enhanced-tv lfs pull
```

Os passos/versões de ferramentas e fontes de dependências são registrados nos
READMEs dos forks, em [BASELINE.md](BASELINE.md), [upstream-lock.json](upstream-lock.json)
e nos build scripts. O repositório central contém ferramentas para restaurar o
workspace, provisionar configurações locais e executar as tarefas Gradle.
Os testes direcionados e limites de prova estão em [FOUNDATION.md](FOUNDATION.md).

### Validação e limites

31 testes direcionados Desktop e 84 TV passaram. MSI e cinco APKs foram compilados;
metadados do MSI, isolamento da DLL empacotada e identificadores/assinaturas dos
APKs foram inspecionados. Os hashes dos arquivos de publicação são conferidos
contra [package-inspection.json](package-inspection.json) antes do upload.

Há 26 falhas Desktop e 20 TV herdadas do baseline completo. Instalação, conta/sync,
reprodução com fontes reais, validação visual, D-pad e TV Box física permanecem
pendentes. Os APKs Debug não são uma distribuição de produção. Linux/macOS não
foram empacotados neste host Windows. As atualizações automáticas dos clientes
consultam seus forks específicos; esta entrega está na aba Releases central.

A publicação usa um rascunho até todos os assets terem tamanho/hash conferidos.
Só depois o rascunho é publicado como pré-release.
