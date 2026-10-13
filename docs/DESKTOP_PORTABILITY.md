# Validação nativa Linux/macOS

Estado: **execução em andamento; portabilidade ainda não aprovada**. A release 1.0.0 continua com os pacotes Windows e Android já verificados.

O workflow manual `telumia-portability.yml` no cliente Desktop executa builds em Ubuntu 24.04 x64, macOS 15 arm64 e macOS 15 Intel. Usa os testes existentes de timed metadata, momentos salvos, cache, catálogo brasileiro e versões, seguidos das tasks nativas de DEB/DMG. Preserva relatórios, logs, commit, inventário LFS e hashes dos pacotes. Os DMGs são sem assinatura/notarização. Compilar e empacotar não comprova conta autenticada, reprodução nativa, HDR, revisão visual nem desempenho em hardware.

O workflow tem `contents: read`, não publica releases, não carrega secrets e não executa o upload de fontes Sentry presente no workflow herdado. O [empacotamento Compose precisa do sistema operacional correspondente](https://kotlinlang.org/docs/multiplatform/compose-native-distribution.html); a execução usa runners nativos, conforme o modelo de [permissões do GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax).

## Preparação e falhas preservadas

- [Primeira execução](https://github.com/Pepeu2010/telumia-desktop/actions/runs/38444759622): checkout bloqueado pelo orçamento LFS da conta, antes de compilar.
- O helper `scripts/restore-release-lfs.py` recupera apenas os objetos exigidos por HEAD do pacote público de fontes 1.0.0. Confere SHA-256 do ZIP, caminho, tamanho e SHA de cada objeto contra os pointers Git antes de qualquer substituição. Os **142 objetos foram conferidos e restaurados localmente**, sem diff no checkout. Não substitui fonte Kotlin, scripts, configurações ou Git por conteúdo antigo.
- A execução intermediária `38445238504` omitiu o helper porque `scripts/*` está ignorado; o arquivo foi acrescentado explicitamente ao Git. [Execução seguinte](https://github.com/Pepeu2010/telumia-desktop/actions/runs/38445356185): checkout revelou registro ausente de `libass-android`; o commit fixado foi conferido no upstream e registrado.
- [Execução posterior](https://github.com/Pepeu2010/telumia-desktop/actions/runs/38445750416): checkout revelou outros gitlinks herdados sem registro. Todos os cinco gitlinks de HEAD foram enumerados; `vendor/TorrServer` e `vendor/quickjs-kt` receberam URLs dos upstreams onde seus commits fixados existem. `git submodule foreach --recursive` passou localmente.

A [execução 38445976602](https://github.com/Pepeu2010/telumia-desktop/actions/runs/38445976602), em `57f618bf295e5e6e7adaca19760187991d2064c9`, avançou ao build nas três plataformas. Linux e macOS arm64 falharam porque `generateRuntimeConfigs.localPropertiesFile` apontava para um arquivo inexistente, embora declarado opcional. O job Intel restante foi cancelado após identificar a mesma configuração na fonte, preservando os erros já concluídos. Não houve aprovação de pacote.

O commit `14cd7b81` registra `local.properties` como input somente quando o arquivo existe; a geração já trata ausência e usa os valores disponíveis de configuração. Assim, o build não exige arquivo privado apenas para compilar. A [execução 38446641827](https://github.com/Pepeu2010/telumia-desktop/actions/runs/38446641827) usa essa correção; seus resultados estão registrados abaixo. O CI continua sem prova de conta autenticada. Esses commits não alteram os instaladores 1.0.0 já publicados.

## Resultados nativos e correção Linux

A execução `38446641827` terminou com sucesso nos dois jobs macOS. O DEB Linux foi gerado, mas seu verificador ainda exigia `Nuvio Media <contact@nuvio.tv>` em vez do mantenedor Telumia. O script compartilhado de atalhos também apontava para `/opt/nuvio`, com nome Nuvio; esses caminhos não representavam o novo pacote.

O commit `068ba7b95ee065e403c57787d0a08e311070eed4` corrige metadados e atalhos de Linux para Telumia, executável `/opt/telumia/bin/Telumia`, ícone `/opt/telumia/lib/Telumia.png` e arquivo `telumia.desktop`. Mantém os handlers de URI compatíveis e as verificações de dependências, integridade e ownership. O teste existente de DEB confere essas entradas após dois passes de patch e continua rejeitando ownership indevido e archive truncado. Os scripts de RPM/AppImage receberam os nomes/caminhos equivalentes; **esses formatos não foram compilados nesse gate**. Um commit posterior ajusta apenas o fallback de licença RPM para a versão GPL-3.0 já declarada no README.

A [execução 38449103384](https://github.com/Pepeu2010/telumia-desktop/actions/runs/38449103384), em `068ba7b9`, passou nos **três jobs nativos**, incluindo os testes selecionados e geração de DEB/DMG. O job Linux passou também no teste de ferramenta de pacote e no verificador do DEB real. A conferência dos pacotes baixados e relatórios JUnit dessa execução está em andamento; sucesso de CI não é prova de execução do app com conta ou reprodução nativa.

O DMG arm64 da execução anterior, em `14cd7b81`, foi baixado e conferido: **251223038 bytes**, SHA-256 `ab69e2f6702298e3c5f102120c5a27823c8ba56c71667361a3bdc0e03f94dd4f`, igual ao manifesto. Seu JUnit tem **38 casos aprovados e um ignorado**, em nove arquivos: o caso ignorado é explicitamente de JNI Windows, portanto não comprova reprodução macOS. [Registro](telumia-desktop-portability-r6-arm64-qa.json). Nenhum DEB/DMG desse CI foi publicado como instalador da release 1.0.0; a configuração de build não utiliza o arquivo privado de runtime/conta.
