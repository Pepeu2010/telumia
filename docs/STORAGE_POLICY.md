# Armazenamento do ambiente de desenvolvimento

Em 17/10/2026 o usuário solicitou reduzir a ocupação do armazenamento. A auditoria encontrou aproximadamente 60,40 GiB em `artifacts`, 5,56 GiB nos checkouts e 0,38 GiB em tooling local. O volume C tinha aproximadamente 16,64 GiB livres. Isso mede este workspace, não atribui ao projeto os demais dados ou caches globais do computador.

## Limpeza preparada, ainda não executada

| Material gerado antigo | GiB aproximados |
| --- | ---: |
| `artifacts/android-avd/NuvioEnhanced_ATV_01a10441.avd` | 6,67 |
| `artifacts/android-avd/NuvioEnhanced_QA_01a10441.avd` | 7,17 |
| `artifacts/android-avd/Telumia_API24_01a10441.avd` | 13,63 |
| Pacotes intermediários e arquivos redundantes de validação de source ZIP | 17,70 |

Preservar os repositórios e alterações de código, todos os relatórios/logs/capturas/manifests, `artifacts/releases` (inclusive 1.0.0), o snapshot TV aprovado `telumia-tv-account-copy-r2`, os pacotes de portabilidade `telumia-desktop-portability-r7`, o AVD mais recente `Telumia_PlayerFlow_R1` e os assets de terceiros. Os totais são tamanhos lógicos; o espaço físico efetivamente recuperado deve ser medido após a remoção, pois imagens de emulador podem ser esparsas.

A revisão automática bloqueou tanto a proposta de limpeza em lote quanto a exclusão isolada do primeiro emulador. **Nenhuma remoção ocorreu.** A lista de candidatos é um plano, não prova de espaço liberado. Não executar por outra linguagem ou ferramenta para contornar esse bloqueio. Aguardar autorização explícita do usuário ou limpeza manual das pastas revisadas.

## Evitar novo acúmulo

`Test-TelumiaStorageBudget.ps1` é uma verificação somente de leitura. Os defaults são reserva de 40 GiB livres no volume e orçamento de 16 GiB em `artifacts`. O orçamento conta os arquivos reais e ignora reparse points; cópias novas incluem o tamanho previsto. Os parâmetros podem ser ajustados conscientemente, sem tratar esse orçamento como limite do produto Telumia.

As rotinas `Start-TelumiaBaseline`, `Invoke-Baseline` e `Export-TelumiaBuildBinding` executam a verificação antes de criar novos outputs ou duplicar pacotes. A regra não limpa arquivos automaticamente, não altera SDK/caches globais e não impede processos externos que não usem essas rotinas. Com o estado atual, novos builds dessas rotinas ficam impedidos até liberar espaço.

Depois da limpeza, manter apenas snapshots necessários à entrega atual e os pacotes de release; conservar os resultados pequenos dos marcos anteriores. Registrar que pacotes intermediários removidos deixam de estar disponíveis localmente para replay, preservando seus hashes e resultados históricos. Não anunciar que binários antigos continuam preservados se forem removidos.
