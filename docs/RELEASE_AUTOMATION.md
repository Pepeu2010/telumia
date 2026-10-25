# Automação das releases de plataformas

O workflow `.github/workflows/platform-release.yml` gera uma release combinada
no repositório principal `Pepeu2010/telumia`. Ele acompanha diariamente a versão
do cliente Android TV no branch `codex/live-tv-mini-player`; ao encontrar uma
versão ainda não publicada, executa os testes focados de Live TV, compila os
cinco APKs Full Debug e combina o instalador Windows x64 da release estável
mais recente do repositório Desktop, junto aos arquivos-fonte correspondentes
das duas plataformas.

Cada publicação usa `versionName`/`versionCode` Android e registra à parte a
versão do MSI. O fluxo não substitui uma release existente. Uma atualização
publicável exige incrementar `versionName` e `versionCode` no cliente TV. A
execução manual permite escolher outro branch/commit TV, uma versão Desktop
específica e o modo `build-only` para conferir os pacotes sem publicar.

Antes de criar a release, o workflow valida os nove grupos de testes Live TV,
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
pacotes de loja. A versão Windows vem da última release estável Desktop, salvo
quando uma versão é indicada na execução manual. A validação e os limites da
release publicada ficam documentados em `docs/RELEASES.md`.
