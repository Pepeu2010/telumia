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

O commit `14cd7b81` registra `local.properties` como input somente quando o arquivo existe; a geração já trata ausência e usa os valores disponíveis de configuração. Assim, o build não exige arquivo privado apenas para compilar. A [execução atual 38446641827](https://github.com/Pepeu2010/telumia-desktop/actions/runs/38446641827) usa essa correção. Sua conclusão, testes e artefatos ainda precisam ser inspecionados. O CI continua sem prova de conta autenticada. Esses commits não alteram os instaladores 1.0.0 já publicados.
