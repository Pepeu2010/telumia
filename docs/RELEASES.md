# Releases da Telumia

Toda release combinada deve listar APK Android TV e instalador Windows PC na mesma página, inclusive no repositório principal `Pepeu2010/telumia`, além das releases dos clientes Desktop e TV. Cada versão de plataforma fica identificada nos assets e checksums. A regra foi aplicada às releases públicas de `v0.2.0-alpha.1` até `v1.0.1`, incluindo as estáveis `v1.0.0` e `v1.0.1`; onde faltava, o MSI Desktop foi anexado e os checksums regenerados. A preparação/publicação do repositório principal exige APK e MSI, e a verificação reconhece o MSI genérico ou com a versão própria da plataforma. O alpha.4 precisou ser publicado pela sessão GitHub autenticada porque o token do workflow recebeu HTTP 403 ao criar a release.

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
