# Live TV — início da Fase 6 na Android TV

Este primeiro incremento integra regras reais ao cliente TV existente, sem criar uma rota paralela nem expor uma tela incompleta. A busca encontrou componentes visuais/tokens Live TV preparados na Fase 1 e a sincronização separada de Continue Assistindo para o launcher Android; não havia modelo de canal, importador M3U ou parser XMLTV da experiência Live TV.

## Entregue

- `LiveTvChannel`, `LiveTvProgram` e `LiveTvImportResult` representam fontes configuradas pelo usuário. `streamUrl` é opcional porque registros XMLTV descrevem canais e logos, mas não fornecem necessariamente um endereço de reprodução.
- `M3uPlaylistParser` interpreta `#EXTM3U`, metadados usuais `tvg-id`, `tvg-name`, `tvg-logo`, `group-title` e títulos com vírgulas. Aceita apenas URLs HTTP(S), limita a playlist a 8 MiB/5.000 canais, descarta duplicatas e cria um identificador determinístico por origem/endereço sem registrar o URL no log.
- `XmlTvParser` processa um `Reader` em fluxo, limita o documento a 16 Mi caracteres, canais a 5.000 e programas a 20.000, conserva título/descrição/categoria/logo, prefere nomes em português quando fornecidos e normaliza os horários para epoch UTC. Timestamp sem offset é interpretado como UTC.
- DTD e entidades externas são desativadas/recusadas. Falhas de parsing não incluem texto XML ou URLs sensíveis na mensagem pública.

## Validação

O run [39343144126](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126) passou nos filtros unitários existentes e nos testes novos `M3uPlaylistParserTest`/`XmlTvParserTest`, compilou `compileFullDebugAndroidTestKotlin` e montou `fullDebug`. A primeira tentativa, [39342834370](https://github.com/Pepeu2010/telumia-tv/actions/runs/39342834370), falhou porque `ACCESS_EXTERNAL_DTD` e `ACCESS_EXTERNAL_SCHEMA` não fazem parte do `XMLConstants` disponibilizado pelo Android SDK. O código foi corrigido no commit `289d81f5` mantendo o bloqueio de DTD/entidades e o build posterior passou.

O CI publicou APKs do commit `289d81f5` por sete dias: [ARM64](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126/artifacts/12229822808), [ARMv7](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126/artifacts/12229583571) e [universal](https://github.com/Pepeu2010/telumia-tv/actions/runs/39343144126/artifacts/12230175419). São variantes de depuração. Testes instrumentados foram compilados, mas não executados; não há aparelho conectado para QA físico.

## Ainda não entregue

Este incremento ainda não importa arquivos/URLs pela interface, persiste a configuração, baixa playlists/EPG, resolve redirecionamentos/credenciais, agenda atualizações, aplica timezone por região, liga `tvg-id` a um guia atualizado, integra `Media3` para reproduzir o canal, nem implementa Agora/Guia/Canais/Favoritos/Recentes com foco D-pad. Nenhum canal ou conteúdo vem embutido. A Fase 6 permanece aberta até esses fluxos reais e seus estados de erro/offline/passagem de foco serem implementados e testados.
