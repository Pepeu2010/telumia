# Telumia

![Telumia](assets/brand/telumia-banner.png)

**Seu cinema, suas séries e novelas — com foco no Brasil.**

Telumia é um media center open source para PC e Android TV, com marca própria e uma experiência cinematográfica em evolução. Usa os clientes nativos e o ecossistema do Nuvio como base técnica, preservando contas, biblioteca, progresso, addons Stremio e os motores de reprodução.

O projeto acrescenta busca voltada ao Brasil, editores de avatar, cache configurável, navegação por teclado/controle, movimento adaptável, controle remoto local de celular e melhorias de Home, detalhes, timeline e sincronização. O redesign integral e os demais recursos do [plano aprovado](docs/ROADMAP.md) continuam em implementação.

## Baixar e instalar

Na [release estável combinada 1.0.5](https://github.com/Pepeu2010/telumia/releases/tag/v1.0.5), escolha:

| Aparelho | Arquivo |
|---|---|
| PC Windows de 64 bits | [Instalador MSI Desktop 1.0.4](https://github.com/Pepeu2010/telumia/releases/download/v1.0.5/Telumia-Windows-x64-1.0.4.msi) |
| Android TV/TV Box, sem identificar a arquitetura | [APK universal 1.0.5](https://github.com/Pepeu2010/telumia/releases/download/v1.0.5/Telumia-TV-1.0.5-universal-debug.apk) |
| Android TV/TV Box ARM 64 bits | [APK arm64-v8a](https://github.com/Pepeu2010/telumia/releases/download/v1.0.5/Telumia-TV-1.0.5-arm64-v8a-debug.apk) |
| Android TV/TV Box ARM 32 bits | [APK armeabi-v7a](https://github.com/Pepeu2010/telumia/releases/download/v1.0.5/Telumia-TV-1.0.5-armeabi-v7a-debug.apk) |
| Android TV/TV Box x86 | [APK x86](https://github.com/Pepeu2010/telumia/releases/download/v1.0.5/Telumia-TV-1.0.5-x86-debug.apk) |
| Android TV/TV Box x86 64 bits | [APK x86_64](https://github.com/Pepeu2010/telumia/releases/download/v1.0.5/Telumia-TV-1.0.5-x86_64-debug.apk) |

Confira os checksums SHA-256 incluídos na release. Os APKs são **Android TV Full Debug**, assinados pela chave persistente do CI, com `versionName` 1.0.5 e `versionCode` 10015. A instalação sobre a versão Android 1.0.0 exige uma migração inicial porque ela usava outro certificado: faça backup dos dados locais, desinstale a versão antiga e instale o APK 1.0.5. Depois dessa migração, as versões assinadas pela chave atual podem atualizar a instalação existente. O MSI é o Desktop 1.0.4, com versão interna Windows Installer 2.0.4; a numeração Desktop é independente da Android.

As próximas versões estáveis e de desenvolvimento, com pacotes de Android TV/TV Box e Windows PC na mesma página, ficam em [Releases](https://github.com/Pepeu2010/telumia/releases). O Desktop 1.0.4 e a TV 1.0.5 consultam apenas releases estáveis; ao atualizar, mostram o progresso do download e entregam a instalação ao instalador padrão de cada sistema.

**Versão Android TV estável mais recente: 1.0.5.** A release principal reúne cinco APKs, o MSI Windows PC Desktop 1.0.4, fontes, manifesto e checksums conferidos. O atualizador TV busca a release estável no repositório principal, exibe o progresso e abre o instalador Android; o sistema ainda pede confirmação para instalar. O Phone Remote local oferece pareamento por QR/código e aprovação explícita na TV; validação com aparelhos físicos continua pendente. [Detalhes do Phone Remote](docs/PHONE_REMOTE.md) · [Histórico das releases](docs/RELEASES.md) · [Automação de APKs e MSI](docs/RELEASE_AUTOMATION.md).

## Melhorias já implementadas

- **Brasil:** português do Brasil como idioma inicial dos metadados em perfis novos e busca com nomes alternativos de obras. Preferências salvas são preservadas.
- **Home e detalhes:** destaque cinematográfico, metadata real, ações de reprodução/biblioteca e foco próprio para teclado e D-pad. [Entrega e capturas](docs/TELUMIA_HOME.md), [detalhes](docs/CINEMATIC_DETAILS.md).
- **Profile Studio:** 64 avatares licenciados e editor local com importação, recorte, zoom e versões otimizadas. O PC também oferece clipboard e drag-and-drop. Avatares pessoais ficam isolados por conta/perfil no aparelho. [Alcance e validação](docs/PROFILE_STUDIO.md).
- **Cache Auto/Manual:** orçamento ajustável ao aparelho e espaço livre. 1 GiB no PC e 256 MiB na TV são defaults iniciais configuráveis. A integração de todos os caches e o funcionamento offline completo continuam pendentes. [Política de cache](docs/MEDIA_CACHE.md).
- **Navegação e movimento:** menu lateral com feedback de foco/seleção, transições nas principais rotas e movimento Completo, Reduzido ou Desligado. [Conta, menu e motion](docs/ACCOUNT_SYNC_MOTION.md).
- **Movimento no player PC:** painéis e controles nativos seguem a preferência de movimento e intensidade do perfil, com navegação por teclado e tempos de interação preservados. [Builds e validação visual](docs/NATIVE_PLAYER_MOTION.md).
- **Timeline e momentos salvos:** eventos temporais disponíveis de intro, recap e créditos nos dois players; momentos com nome/data, renomear, remover e voltar à cena no código PC e TV. No PC, o botão do player e a tecla D abrem o painel; a tecla B continua alternando áudio. Os momentos ficam neste aparelho, por conta/perfil/episódio, com confirmação para outra fonte. A reprodução e o seek reais continuam com gates próprios. [Timeline](docs/TIMED_METADATA.md), [momentos](docs/SCENE_BOOKMARKS.md).
- **Miniaturas e filmstrip no player PC:** a timeline solicita frames a um decoder libmpv separado, com cancelamento e cache por conta/perfil/fonte. Ao arrastar por mais tempo, exibe frames vizinhos disponíveis. Na preparação da 1.0.0, passaram 279 testes selecionados e 1.092 verificações do renderer, incluindo extração JNI local, HTTP controlado e seek/reprodução do player principal Windows. A interface TV, provedores externos/HDR e interação completa com WebView2 continuam pendentes. [Extração](docs/NATIVE_TIMELINE_FRAMES.md), [gates da versão](docs/VERSION_100.md).
- **Composição do player PC:** título e episódio no topo, dock de reprodução centralizado, rótulo visível, thumb e PiP compacto. O incremento passou em verificações do renderer, incluindo loading, erro, recuperação e movimento reduzido. O redesign integral do player continua em andamento. [Captura de QA e limites](docs/ALPHA_022.md).
- **Capítulos do arquivo:** o PC lê capítulos nomeados pelo libmpv e os mostra nos marcadores da timeline existente. O incremento anterior passou em 279 testes; seleção/seek de capítulos pela interface e o caminho TV continuam em desenvolvimento. [Evidências](docs/EMBEDDED_CHAPTERS.md).
- **Extração de frames na TV:** base Media3 com decoder separado, timestamps reais, cache RAM limitado e headers restritos à origem da prévia. A integração com o seek por controle remoto continua pendente. [Estado e evidências](docs/TV_TIMELINE_FRAMES.md).
- **Seek visual na TV em desenvolvimento:** o código posterior à 1.0.0 integra thumbnail e filmstrip ao D-pad. Além da QA de componentes em 720p/1080p/4K, o fluxo real de instalação de addon, seleção de fonte, reprodução Media3 e seek passou em uma AVD nova API 36/1080p, com vídeo original e modo convidado. Essa melhoria ainda não integra os APKs publicados da 1.0.0. [Capturas e limites](docs/TV_TIMELINE_SEEK.md).
- **Mesma conta:** atualização de perfis, configurações suportadas, addons, plugins, biblioteca, progresso, coleções e Home ao retornar ao app e periodicamente em atividade. Coleções e addons nos dois clientes possuem mesclagem durável de alterações pendentes. A comprovação ponta a ponta com a conta nos clientes oficial e Telumia continua pendente. [Evidências e limites](docs/ACCOUNT_SYNC_MOTION.md).

### Novelas e edições brasileiras

Buscar **Iludida** também consulta **Sadakatsiz**, **The Unfaithful** e **A Woman Scorned**, preservando a identidade da obra. Quando um catálogo instalado oferece a edição brasileira de **78 capítulos**, o Telumia usa seus IDs de reprodução e numeração. Se a fonte só oferece a edição de **31 episódios**, conserva essa edição, sem inventar capítulos.

As edições têm durações e divisões diferentes. É necessário configurar uma fonte que ofereça o corte desejado. A proteção de metadados evita aplicar resumos e miniaturas de outra edição sobre essa numeração. [Implementação e limites](docs/TELUMIA.md).

## O que continua em desenvolvimento

O objetivo é transformar toda a experiência dos clientes existentes, conforme a [meta integral](docs/GOAL_OBJECTIVE_2026-10-05.md). Ainda não estão concluídos o redesign completo de todas as telas, previews de vídeo embutidos no Windows, validação de todas as rotas das thumbnails/filmstrip na TV, Scene Info, Source Intelligence, Live TV/EPG, QA física do Phone Remote, downloads avançados, Smart Collections e os demais critérios do plano. Os componentes preparatórios de TV/EPG não aparecem como funcionalidades prontas.

Os builds nativos de Linux x64 (DEB), macOS Intel e Apple Silicon (DMG) passaram, com 38 testes aprovados e um caso exclusivo de Windows ignorado por plataforma. Os pacotes baixados tiveram seus hashes conferidos. Ainda falta validar execução autenticada e reprodução nessas plataformas; esses pacotes de CI não foram adicionados à release 1.0.0. [Resultados de portabilidade](docs/DESKTOP_PORTABILITY.md).

Os incrementos de previews já têm exclusividade, cancelamento, timeout e preload conservador; vídeo remoto e desempenho físico ainda precisam de validação. [Previews](docs/PREVIEWS.md). Recursos locais exclusivos, como arquivos de avatar e momentos salvos, não são anunciados como sincronizados com formatos que o cliente oficial não suporta.

## Código e evidências

| Repositório | Plataforma |
|---|---|
| [telumia](https://github.com/Pepeu2010/telumia) | Documentação, evidências e releases |
| [telumia-desktop](https://github.com/Pepeu2010/telumia-desktop) | Kotlin Multiplatform/Compose, libmpv e ponte nativa Windows |
| [telumia-tv](https://github.com/Pepeu2010/telumia-tv) | Kotlin/Compose TV e Media3 |

Cada cliente mantém seu histórico e build; a implementação amplia os aplicativos existentes. Commits de referência e binários de desenvolvimento ficam vinculados nos [registros do projeto](docs/fork-lock.json). Testes selecionados, builds e QA nativa têm evidências próprias; não equivalem a prova integral de conta, playback ou desempenho em aparelho físico. As falhas herdadas das suítes completas permanecem documentadas na [fundação](docs/NATIVE_FOUNDATION.md).

## Conteúdo e licenças

O aplicativo não inclui canais, listas ou conteúdo protegido. Configure fontes que você tenha autorização para usar. Código GPL-3.0, com avisos e [créditos de origem preservados](docs/UPSTREAM_CREDITS.md). O nome, logo, ícones e identidade visual Telumia são próprios.
