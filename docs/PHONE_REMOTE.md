# Controle remoto local pelo celular

## Escopo

O Phone Remote R1 é uma função opcional do cliente Android TV/TV Box. O servidor
permanece desligado até a ativação em **Configurações → Integrações → Phone
Remote**. A primeira versão inclui pareamento por QR/código e comandos de
navegação, reprodução, volume e entrada de texto.

## Ativação e pareamento

1. Ative o Phone Remote na TV. O app procura um endereço IPv4 privado e inicia
   o servidor somente nesse endereço, sem escutar em todas as interfaces.
2. Leia o QR no celular conectado à mesma rede local ou abra o endereço mostrado
   na TV. O código numérico de seis dígitos expira em dois minutos; após cinco
   códigos incorretos, a janela é encerrada.
3. A TV mostra o nome e o endereço do aparelho que pediu pareamento. Nenhum
   comando é aceito antes de a pessoa aprovar essa solicitação na TV.
4. A sessão não persiste entre reinícios do servidor; é revogada ao desativar o
   controle remoto. Tokens ficam em memória, e o servidor guarda apenas o hash
   do token. A sessão vence após 15 minutos sem atividade ou oito horas no total.

O celular pode usar os botões do D-pad, selecionar, voltar, Home, play/pause,
seek, volume e alternar legendas. A entrada de texto atual cobre letras latinas
ASCII, números e pontuação básica; caracteres que não correspondem a uma tecla
Android são ignorados. O texto recebido é limitado a 256 caracteres.

## Limites de rede e protocolo

- Somente endereços IPv4 privados ou loopback são aceitos para bind.
- Cada pedido WebSocket precisa corresponder ao Host e Origin esperados para o
  endereço local. A página bloqueia cache e restringe suas conexões ao próprio
  servidor.
- São aceitas no máximo duas conexões, mensagens de até 2 KiB e 30 comandos por
  segundo por conexão.
- Uma mensagem sem sessão válida recebe erro e não despacha o comando; essa
  conexão permanece aberta. A recusa de pareamento também devolve estado ao
  celular sem encerrar necessariamente o socket.
- O transporte local desta versão usa HTTP/WebSocket sem TLS. O servidor não
  faz bind em interfaces públicas nem oferece acesso pela Internet; use-o apenas
  em uma rede local confiável.

## Verificação e distribuição

Os testes focados `PhoneRemoteLanAddressTest`,
`PhoneRemotePairingAuthorityTest` e `PhoneRemoteServerTest` passaram. A compilação
`assembleFullDebug` gera cinco APKs: universal, ARM64, ARM32, x86_64 e x86. São
pacotes de desenvolvimento com assinatura debug. Os APKs alpha.3 locais foram
gerados do commit TV `571b4ab475cd0d3caf5f1d111030c2bb75a4c806`, verificados com
`apksigner` e registrados em `artifacts/builds/v1.0.2-alpha.3` com SHA-256.

A release combinada do repositório principal também inclui o MSI Windows x64 da
última release estável Desktop disponível. Esse fluxo copia e verifica o MSI;
não compila uma nova versão Desktop quando só o cliente Android TV muda. O
manifesto identifica separadamente a versão Android e a versão do instalador PC.

Não foi feita validação em TV Box ou celular físicos nesta entrega. Na execução
completa observada anteriormente, 2.051 testes terminaram com 13 falhas e um
teste ignorado em módulos alheios ao Phone Remote; não foi estabelecido que essas
falhas sejam preexistentes. O interceptor de rota do Ktor também emite um aviso
de depreciação durante a compilação.
