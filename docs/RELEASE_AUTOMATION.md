# Automação das releases de plataformas

O workflow `.github/workflows/platform-release.yml` gera uma release combinada
no repositório principal `Pepeu2010/telumia`. A cada seis horas, ele consulta o
branch `codex/live-tv-mini-player` do cliente Android TV e a release publicada
mais recente do repositório Desktop, incluindo pré-releases. Compara os commits e a tag Desktop com o último
manifesto combinado publicado. Quando encontra uma mudança, executa os testes
focados de Live TV e Phone Remote, compila os cinco APKs Full Debug, inclui o MSI
Windows x64 correspondente e arquiva os fontes das duas plataformas. Sem
mudanças, encerra sem duplicar ou substituir arquivos. Também pode ser executado
manualmente com outro branch/commit, versão Desktop ou modo `build-only`.

Cada publicação recebe um `versionName` Android maior que o da release
combinada anterior. Se o cliente TV já tiver avançado sua versão, ela é
preservada; se não, a automação incrementa o contador de pré-lançamento (ou abre
a próxima `alpha` após uma versão estável). O `versionCode` também é maior que o último
publicado, permitindo instalar a atualização sobre o mesmo pacote. Esses dois
valores são aplicados apenas ao checkout temporário de CI; o arquivo de fonte
continua representando o commit upstream sem alterações e o manifesto registra
a versão exata incluída nos APKs. A versão/tag do MSI é registrada à parte. A
release combinada fica marcada como pré-release se qualquer uma das plataformas
estiver em pré-lançamento.
Releases existentes permanecem intactas. Um push na `main` que altere o próprio
arquivo do workflow também inicia uma execução.

Antes de criar a release, o workflow valida os nove grupos de testes Live TV e
os três grupos de Phone Remote,
os cinco APKs/assinaturas, tamanho e digest SHA-256 dos arquivos Desktop,
arquivos-fonte TV/Desktop e os dez assets enviados. Os arquivos-fonte passam
pela verificação dos objetos Git LFS. Só publica o rascunho depois de conferir
os digests no GitHub. Se uma execução parar depois de enviar todos os arquivos,
a próxima execução retoma o mesmo rascunho, confere o manifesto, os checksums e
os digests publicados, e então conclui a publicação sem gerar uma tag duplicada.
O workflow também guarda os pacotes no run por 30 dias para recuperação se o
upload da release falhar.

O repo principal precisa permitir `contents: write` para o `GITHUB_TOKEN` nas
configurações de Actions. Se a configuração impedir esse acesso, o build ainda
fica disponível como artefato do run, mas a publicação não ocorre.

Os APKs são builds Full Debug assinados com chave de desenvolvimento; não são
pacotes de loja. A versão Windows vem da última release Desktop publicada, salvo
quando uma versão é indicada na execução manual. A validação e os limites da
release publicada ficam documentados em `docs/RELEASES.md`.
