# Telumia

![Banner do Telumia](assets/brand/telumia-banner.png)

**Sua experiência de entretenimento, do seu jeito.**

Telumia é um **media center open source para Windows e Android TV/TV Box**, com uma interface pensada para explorar filmes e séries, organizar sua biblioteca e assistir pelo computador ou pela televisão.

O projeto é independente e evolui os clientes de código aberto do ecossistema **Nuvio**, com identidade visual própria, melhorias na navegação e recursos de personalização. O desenvolvimento é contínuo: algumas experiências já estão disponíveis e outras ainda estão em validação.

<p align="center">
  <a href="https://github.com/Pepeu2010/telumia/releases/latest"><strong>Baixar Telumia</strong></a>
  &nbsp;·&nbsp;
  <a href="#recursos">Recursos</a>
  &nbsp;·&nbsp;
  <a href="#estado-do-projeto">Estado do projeto</a>
  &nbsp;·&nbsp;
  <a href="#desenvolvimento">Desenvolvimento</a>
</p>

## Download e instalação

**[Acessar a versão estável mais recente](https://github.com/Pepeu2010/telumia/releases/latest)**

As releases do repositório principal reúnem os instaladores de Android TV e Windows, além de arquivos de verificação e código-fonte correspondente.

| Plataforma | Arquivo na página de download |
| --- | --- |
| **Windows (64 bits)** | Instalador `.msi` |
| **Android TV / TV Box** | APK `universal` — recomendado quando não souber a arquitetura |
| **Android TV / TV Box ARM64** | APK `arm64-v8a` |
| **Android TV / TV Box ARM32** | APK `armeabi-v7a` |
| **Android TV / TV Box x86 / x86_64** | APK correspondente à arquitetura |

As versões do aplicativo para Windows e Android TV são independentes: **não precisam ter a mesma numeração**. Confira os nomes dos arquivos e o `SHA256SUMS.txt` na página da release antes de instalar.

> **Atenção para instalações antigas do Android TV:** a versão 1.0.0 usava um certificado de assinatura diferente. Para migrar dessa versão para as versões atuais, pode ser necessário fazer backup dos dados locais, desinstalar a versão antiga e instalar a nova. A desinstalação pode apagar dados armazenados no dispositivo. As releases recentes usam uma assinatura persistente para permitir atualizações posteriores.

Os APKs publicados atualmente são builds **Full Debug**; a instalação e as atualizações continuam sujeitas às confirmações de segurança do Android. Consulte as notas de cada release para conhecer as condições e limitações específicas.

## Recursos

### Uma experiência pensada para cada tela

- **Interface cinematográfica:** Home e páginas de detalhes com destaque para as obras, informações e ações de reprodução.
- **Navegação por controle e teclado:** suporte a D-pad na TV, foco visível e atalhos no PC.
- **Experiência em português:** preferência inicial por metadados em português do Brasil em perfis novos, respeitando preferências já salvas.
- **Movimento ajustável:** opções de animação completa, reduzida ou desativada nas áreas implementadas.

### Biblioteca, perfis e reprodução

- **Biblioteca e progresso:** integração com os recursos de conta, histórico e organização disponíveis nos clientes.
- **Personalização de perfil:** seleção e edição local de avatares; no PC, também há suporte a importação por área de transferência e arrastar e soltar.
- **Player com mais contexto:** marcadores temporais, momentos salvos e aprimoramentos de timeline, com diferenças de implementação entre Windows e TV.
- **Cache configurável:** ajustes automáticos ou manuais de armazenamento conforme o dispositivo, ainda com integrações pendentes.

### Integrações e atualizações

- **Addons e fontes compatíveis:** o aplicativo utiliza integrações configuradas pelo usuário, de acordo com os recursos herdados dos clientes.
- **Controle pelo celular na rede local (TV):** pareamento por QR/código com aprovação na televisão, em evolução e ainda sem validação completa em aparelhos físicos.
- **Atualizações:** os clientes acompanham releases estáveis e usam os mecanismos de instalação de cada sistema.

> A disponibilidade e o comportamento de alguns recursos variam entre PC, Android TV, versão instalada, conta e fontes configuradas. O projeto **não fornece acesso automático a filmes, séries, canais ou serviços pagos**.

## Estado do projeto

O Telumia está em **desenvolvimento ativo**. A base funcional dos clientes existe, mas nem todas as melhorias planejadas estão finalizadas.

| Área | Situação |
| --- | --- |
| Home, detalhes e navegação por teclado/controle | Implementados, com refinamentos em andamento |
| Perfis e personalização de avatares | Implementados, com recursos locais |
| Biblioteca e sincronização de dados compatíveis | Implementação incremental; validação ponta a ponta pendente |
| Timeline, miniaturas e momentos salvos | Parcial; cobertura diferente entre PC e TV |
| Cache automático/manual | Parcial; integração e testes completos pendentes |
| Controle remoto local pelo celular | Implementação inicial; testes em hardware físico pendentes |
| Redesign integral, previews avançados, Live TV/EPG e outros recursos planejados | Em desenvolvimento, **não anunciados como concluídos** |

O foco atual inclui estabilidade, consumo de memória, navegação na TV Box e acabamento da experiência visual. Builds de teste para Linux e macOS **não significam disponibilidade de instaladores estáveis dessas plataformas** na página principal.

Acompanhe os detalhes no [roadmap](docs/ROADMAP.md) e no [histórico de releases](docs/RELEASES.md).

## Desenvolvimento

O Telumia é distribuído em três repositórios:

| Repositório | Responsabilidade |
| --- | --- |
| **[telumia](https://github.com/Pepeu2010/telumia)** | Identidade, documentação, automação de releases e downloads combinados |
| **[telumia-desktop](https://github.com/Pepeu2010/telumia-desktop)** | Cliente multiplataforma em Kotlin/Compose e reprodução no PC |
| **[telumia-tv](https://github.com/Pepeu2010/telumia-tv)** | Cliente Android TV, interface para controle remoto e reprodução com Media3 |

### Documentação técnica

- [Roadmap e funcionalidades planejadas](docs/ROADMAP.md)
- [Releases, versões e verificações](docs/RELEASES.md)
- [Player, timeline e miniaturas](docs/TIMED_METADATA.md)
- [Cache e gerenciamento de recursos](docs/MEDIA_CACHE.md)
- [Controle remoto local pelo celular](docs/PHONE_REMOTE.md)
- [Créditos dos projetos de origem](docs/UPSTREAM_CREDITS.md)

Contribuições devem respeitar as regras de cada cliente. Para reportar uma vulnerabilidade, consulte a [política de segurança](SECURITY.md) e **não publique credenciais ou detalhes exploráveis em issues públicas**.

## Conteúdo, independência e licença

Telumia é um projeto **independente, sem afiliação oficial com NuvioMedia**. Ele preserva os avisos de autoria, licenças e créditos aplicáveis aos projetos utilizados como base.

O aplicativo **não distribui filmes, séries, canais, listas ou assinaturas**. Cada usuário é responsável por configurar e utilizar somente fontes e conteúdos para os quais tenha autorização.

O código é disponibilizado sob a **[GNU GPL-3.0](LICENSE)**, com [atribuições e créditos de origem](docs/UPSTREAM_CREDITS.md). A identidade visual e a marca Telumia são próprias do projeto.
