# Telumia 1.0.0

A versão pública passa a `1.0.0`, sem sufixo alpha. Os novos binários estão compilados e os gates de preparação passaram. A publicação será uma release regular do GitHub (`prerelease=false`); nenhum pacote ou tag das alphas é substituído. A conferência dos uploads e do estado remoto precede o anúncio da publicação.

## Pacotes e atualização

O pacote Windows x64 continua MSI com nome, caminhos próprios e o mesmo UpgradeCode Telumia. A versão apresentada pelo aplicativo é **1.0.0**, código 1000. A versão numérica interna do MSI é **2.0.0**, para superar os instaladores alpha que já usavam 1.2.2. Essa separação evita transformar a atualização em downgrade; não altera a numeração do aplicativo em Linux/macOS.

Android TV usa nome de versão **1.0.0**, código **10000**. São distribuídos APK universal e variantes ARM64, ARM32, x86 e x86_64. O package ID e a assinatura de desenvolvimento são preservados para permitir atualizar a distribuição Full Debug anterior. Esta entrega continua usando essa distribuição de desenvolvimento; uma assinatura de produção e migração para outro ID não são simuladas. Não há cliente específico de celular.

Os ZIPs de código incluem os objetos Git LFS reais. O manifesto relaciona commits, tamanho e SHA-256 de cada binário; a publicação só avança depois da conferência dos arquivos enviados. Os dois clientes mantêm releases correspondentes, além do repositório central.

## Conteúdo desta versão

Reúne os incrementos já desenvolvidos nos clientes existentes: identidade Telumia, busca com aliases brasileiros, Home e detalhes cinematográficos, navegação/motion configurável, seleção e edição local de avatares, cache Auto/Manual, mesclagem durável de coleções e addons nos contratos existentes, momentos salvos e timeline/player Windows com miniaturas, filmstrip e capítulos reais do arquivo.

A TV acrescenta uma fundação de extração de frames Media3, com fila limitada, sessão por origem, deadlines e transporte de prévia restrito à origem. A integração visual das miniaturas com o controle remoto ainda não está pronta; essa fundação não aparece como um recurso de seek concluído na interface.

## Evidências da preparação

O build TV do commit `6b58f39aa4af718d8208205115b45fa04f1359cb` passou em 214 testes selecionados, sem falhas, erros ou skips, e gerou os cinco APKs do aplicativo e o APK de testes. [Vínculo dos binários](telumia-v100-tv-r4-build-binding.json). A extração nativa passou em cinco casos por API, 24 e 36, com revisão dos frames AVC originais. A MainActivity passou nos gates de 30 segundos nessas duas APIs. [Detalhes e limites](TV_TIMELINE_FRAMES.md).

O build Windows do commit `470c38d5cc02e597c94ea562f5d645f49f8fad60` passou em 279 testes selecionados, sem falhas, erros ou skips, e gerou o MSI 1.0.0. [Vínculo dos binários](telumia-v100-desktop-r1-build-binding.json). O renderer passou oito execuções, quatro resoluções × dois modos de movimento do sistema, com **1.092 verificações**, 72 casos de política/intensidade e zero erros JavaScript. Usa os assets empacotados em Chromium com metadata e uma ponte de mensagens controladas; não comprova toda a experiência WebView2. [Registro](telumia-v100-renderer-qa.json).

O primeiro gate de renderer falhou na combinação 4K/movimento completo, na verificação conjunta de opacidade e liberação de cliques após uma espera fixa. A reprodução isolada com os mesmos assets passou. O teste agora observa a transição CSS real, com espera limitada, e acrescenta a verificação imediata de `pointer-events: none`. Os assets do produto permanecem iguais; a tentativa falha e a reprodução foram preservadas. A bateria completa passou depois desse ajuste. No teste 4K final, a ocultação levou 202 ms no modo completo e 128,8 ms no reduzido, com liberação imediata dos cliques; não são medidas de desempenho em hardware do usuário.

A [inspeção de atualização](telumia-v100-upgrade-inspection.json) confirmou ProductCode novo, UpgradeCode preservado e versão MSI crescente; os cinco APKs preservam ID/certificado e aumentam o código de versão. Isso verifica metadados de pacote, sem comprovar migração de dados instalados. Os ZIPs foram conferidos com 142 objetos LFS reais no Desktop e nenhum ponteiro pendente; o ZIP TV também passou. [Manifesto preparado](telumia-v100-release-manifest.json), [pacotes](telumia-v100-package-inspection.json), [gates vinculados por hash](telumia-v100-runtime-gates.json).

## Limites de entrega

O número 1.0.0 atende à mudança de versão solicitada e não encerra a [meta integral](GOAL_OBJECTIVE_2026-10-05.md). Continuam pendentes o redesign de todas as superfícies, previews Windows embutidos, thumbnails/D-pad TV, Scene Info completo, Source Intelligence, failover avançado, Live TV/EPG, Phone Remote, Smart Collections, downloads avançados e a integração completa de cache/offline.

As regras locais de sincronização têm testes, mas a sincronização ponta a ponta com uma conta oficial nos dois aplicativos ainda exige comprovação. Avatares locais e bookmarks não são anunciados como compatíveis com contratos remotos que não os suportam. As limitações e riscos do transporte legado estão no [modelo de segurança](SECURITY_THREAT_MODEL.md).

Testes selecionados não equivalem à aprovação da suíte inteira. Execução em TV física, HDR, Linux/macOS, atualização de dados de uma instalação existente e a experiência completa WebView2 exigem evidências próprias. Esses limites continuam registrados, sem transformar compilação em comprovação do produto inteiro.
