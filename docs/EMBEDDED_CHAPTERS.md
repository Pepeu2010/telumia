# Capítulos embutidos na timeline Desktop e TV

O incremento `e4ec9bfa7660339e8c533fb1b237ba0c7e5bb9e7` amplia a abstração temporal e o player existentes. O bridge libmpv lê `chapter-list` do arquivo aberto; o controller recebe um snapshot UTF-8, e o adapter projeta capítulos nomeados nos mesmos marcadores da timeline utilizados pelos skips. Não há outro player, pesquisa externa, título inferido da sinopse ou painel fictício.

## Comportamento e limites

- Posições vêm do libmpv e são convertidas para milissegundos. Identidade, título e ordem do arquivo são preservados; títulos vazios não recebem conteúdo inventado.
- Um capítulo sem título ainda limita o intervalo anterior. Posições negativas/duplicadas/inválidas, títulos excessivos e dados incompletos são tratados conservadoramente. O último capítulo só recebe o fim da duração quando o snapshot é completo; corte desconhecido/truncado mantém esse fim desconhecido.
- O leitor limita 512 capítulos, 64 campos por entrada e 1024 bytes por título. O canal JNI é limitado a 1 MiB e decodifica UTF-8 estrito, incluindo Unicode fora do BMP. Dados malformados viram snapshot vazio, sem publicar conteúdo parcial ou logs do payload.
- O controller verifica o source capturado antes/depois da consulta, além de handle e estado de release. A troca de source invalida o snapshot anterior. A prova de uma sequência completa de trocas de episódio/fonte na UI real continua como gate próprio.
- A origem é `embedded-mpv`. Não há confiança fabricada nem fallback para elenco global: os títulos de capítulos não viram afirmações de ator/música/Scene Info. A UI mantém escape por `textContent` e descrição acessível no seek.

Os wrappers equivalentes Linux/macOS estão no código e nos inputs de build. Os builds nativos dessas plataformas estão em execução no [gate de portabilidade](DESKTOP_PORTABILITY.md), ainda sem aprovação de runtime. Scene Info e o restante de 2-B/2-C continuam pendentes.

## Android TV / Media3

O incremento TV `00734dde0502f3fcb93d864ed345e9f2e0fa6095` integra capítulos ID3 do `Metadata` recebido pelo listener do player à abstração `TimedMetadataTimeline` existente. Os títulos vêm do frame `TIT2`; identificadores servem de fallback quando o arquivo não fornece título. O adapter ignora posições negativas, intervalos de duração zero/inválidos e capítulos além de uma duração conhecida, limita e mescla callbacks por identidade do conteúdo, preserva proveniência `media3-id3` e limpa os dados ao preparar outra reprodução.

Os capítulos passam a aparecer como marcadores nas timelines principal e de seek. O botão de capítulos e o seletor com navegação D-pad só aparecem quando a reprodução VOD realmente contém eventos; escolher um item busca sua posição no player existente. Live TV não exibe o controle. Esses títulos permanecem capítulos e não são promovidos a afirmações de cena ou Scene Info.

**Validação:** quatro testes dedicados cobrem leitura de títulos `TIT2`, acumulação entre callbacks, limites/intervalos inválidos e troca de identidade. O workflow executou também os testes selecionados já existentes e compilou `:app:assembleFullDebug` com sucesso. [Registro do CI e APK](telumia-tv-embedded-chapters-r1-ci.json). A interface ainda aguarda QA com controle remoto e TV Box física; isso não foi demonstrado pelo build automatizado.

## Evidência

[Build preservado](telumia-embedded-chapters-r1-build-binding.json): **279 testes selecionados**, 64 arquivos JUnit, zero falhas/erros/skips; MSI de desenvolvimento com árvore limpa antes/depois. [Resultado](telumia-embedded-chapters-results.json), [inspeção](telumia-embedded-chapters-r1-package-inspection.json).

Os [seis casos JNI](telumia-embedded-chapters-native-cases.json) usam o libmpv empacotado, vídeo original gerado e HWND oculto próprio. O novo caso criou Matroska/MJPEG local, leu dois capítulos reais em 0/3000 ms, preservou acentos/aspas/newline/emoji e projetou intervalos 0–3000/3000–6000 no índice temporal. Também extraiu um frame do mesmo arquivo com o worker separado. O caso passou em 1,021 segundo; isso não é benchmark de hardware.

[Renderer](telumia-embedded-chapters-renderer-qa.json): oito execuções, quatro resoluções, dois estados OS de movimento reduzido, 72 pares de política/intensidade, **1.084 verificações**, zero erros JS. Os checks adicionais verificam bounds/rótulo do capítulo, descrição acessível, texto HTML tratado como texto e remoção da descrição/marcadores ao limpar uma fonte. São fixtures controladas da ponte do renderer; não equivalem a interação completa WebView2 com o arquivo reproduzido.

## Distribuição

Os capítulos Desktop estão incluídos na release regular **1.0.0**, cujo MSI publicado está ligado ao commit `470c38d5cc02e597c94ea562f5d645f49f8fad60`. O APK TV deste incremento é um artefato `fullDebug` temporário do CI, não uma release assinada de produção; ele expira após sete dias. A meta integral permanece em execução.
