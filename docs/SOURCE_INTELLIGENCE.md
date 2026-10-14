# Source Intelligence

Estado: **primeiro incremento de seleção declarativa implementado localmente na TV; build/testes em execução, QA nativa pendente**. Não é a entrega completa de Source Intelligence e não altera os binários da release 1.0.0.

Fonte: `repos/tv`, commit `f655a5802`, ampliando `StreamAutoPlaySelector`, `StreamAutoPlayPolicy`, `PlayerSettingsDataStore`, as configurações de reprodução e a lista de fontes existentes. Não cria outro player, repositório ou resolver.

## Comportamento implementado

O seletor mantém filtros de addon/plugin, exclusão de páginas externas e estados de debrid indisponíveis, prioridade de grupo de episódios configurada pelo usuário e desempate pela ordem original das fontes. A coleta continua usando a janela/timeout de seleção já configurada: a recomendação considera as fontes disponíveis naquela janela, não promete conhecer providers que ainda não responderam.

| Modo | Regra deste incremento |
| --- | --- |
| Melhor qualidade | Prefere maior resolução declarada reconhecida; cache debrid declarado contribui 10 pontos. |
| Equilibrado | Resolução declarada 1080p contribui 120 pontos, 720/800p 100, resoluções superiores 70, inferiores 50. Cache declarado contribui 10. |
| Economia de dados | Até 720p contribui 120 pontos, até 1080p 50, superiores 10. Tamanho positivo conhecido contribui até 80 pontos, decrescendo por blocos de 256 MiB; cache declarado contribui 10. |
| Manual | Conserva a escolha existente e sua preferência explícita de continuidade por grupo de episódios. |

Primeira fonte e Regex continuam disponíveis como opções avançadas existentes. A pontuação usa somente resolução estruturada do provider ou `qualityValue` existente, tamanho declarado positivo e estado de cache debrid. Não lê credenciais ou URLs para pontuar, não interpreta palavras publicitárias no nome como evidência e limita valores para evitar overflow. Informações ausentes são neutras; tamanho desconhecido não recebe o bônus reservado a tamanho conhecido. Não calcula bitrate a partir de duração com unidade desconhecida.

Os cards exibem a pontuação e suas contribuições quando um modo novo está ativo. A própria UI identifica que codec, HDR e rede não foram verificados. O picker existente oferece os modos com descrições pt-BR/inglês, preservando navegação/foco atuais; a geometria e a interação ainda precisam de QA no APK deste incremento.

## Persistência e conta

Os modos novos usam `telumia_source_mode_v1` no DataStore existente de cada perfil. Não substituem silenciosamente `stream_auto_play_mode` compartilhado com o cliente original. Selecionar Manual/Primeira fonte/Regex remove o override local e atualiza a preferência legada. O filtro de configurações remotas exclui a chave nova em envio e recepção; não anuncia que o cliente oficial conhece esses modos.

## Verificação em andamento

O build `telumia-tv-source-ranking-r1` foi iniciado em árvore limpa do commit acima, com worker único, heap de 4 GiB e compilador Kotlin no processo. Inclui APKs de aplicação e instrumentação e testes de seleção, timeout/watchdog, contrato de sync e DataStore real de preferências em diretórios temporários. Lançar o processo não constitui aprovação.

As novas regressões cobrem escolha independente da ordem, qualidade versus equilíbrio, preferência por arquivos pequenos conhecidos, exclusão de páginas externas/debrid indisponível, empate com dados desconhecidos, filtros de addon, limites numéricos, isolamento da chave em sync e persistência/recriação/troca de perfil sem alterar o modo compartilhado. Os resultados serão vinculados ao commit/APKs após término; nenhuma dessas verificações é anunciada como aprovada antes disso.

## Escopo ainda necessário

Faltam a implementação equivalente no Desktop, DeviceCapabilities centralizado, adequação de codec/decoder/HDR/áudio/legendas, preferência de idioma, bitrate com origem/unidade confiáveis, medições reais de latência/disponibilidade/estabilidade, pre-flight limitado e failover com posição e tentativas finitas. Também falta QA visual/nativa dos novos modos e reprodução pelo caminho real com seleção automática. O score declarativo é uma camada inicial do recurso completo, não prova esses requisitos.
