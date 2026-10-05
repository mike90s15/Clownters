# Clownters Painel

Painel de **consultas, OSINT, cibersegurança, geradores, validadores,
conversores e ferramentas**, direto do seu terminal — no **Linux** ou no
**Termux** (Android). Tudo roda sobre **Tor**, cifrado de ponta a ponta.

Este repositório é só o **cliente** (a interface). É open source e você pode ler
cada linha: ele não guarda sua senha e não tem nenhuma verificação escondida.

## O que dá para fazer

| | |
|---|---|
| **Consultas** | CEP, CNPJ, Banco, DDD, DDI, Domínio .br, Feriados, FIPE, IP, ISBN, NCM, Taxas (Selic/CDI/IPCA), Cidade (IBGE), CNAE, telefone, **BIN de cartão, Cotações (dólar/euro/BTC), Clima, Código de barras (EAN), Leitor de boleto** |
| **OSINT & Web** | WHOIS, DNS, DNS reverso, SSL, Headers HTTP, Site no ar?, Validar e-mail, **Site é golpe? (anti-phishing), Raio-X do site (tecnologias), Nota de segurança, Rastrear link (unshorten), Domínio livre?** |
| **Recon & Cyber** | CVE, Identificar hash, Exposição do IP, IP em blocklist, Subdomínios, **Caça-Usuário (procura um @ em dezenas de redes), Senha vazada, Força da senha, Fabricante por MAC** |
| **Conversores** | Hexadecimal, Binário, URL encode, Código Morse, ROT13, Decodificar JWT, Data ⇄ Timestamp, Gerar UUID, QR Code, Texto estilizado |
| **Geradores** | CPF, CNPJ (inclusive o novo alfanumérico), RG, CNH, Título, PIS, RENAVAM, CNS, Certidão, Cartão, Conta bancária, Placa, Senha, **Pessoa, Empresa e Veículo completos** |
| **Validadores** | CPF, CNPJ, RG, CNH, Título, PIS, RENAVAM, CNS, Certidão, Cartão, ISBN, Placa |
| **Ferramentas** | Hash, Base64, contador de texto, conversor de bases, conversor de texto, número por extenso, **Link de WhatsApp, PIX copia-e-cola** |

Os dados dos geradores são **fictícios** (com dígito verificador válido, mas
aleatórios): servem para testar software, não pertencem a ninguém. As consultas
usam apenas fontes **públicas** — nada de dado de pessoa física.

## Como conseguir acesso

O painel é por **login**. Para assinar e receber seu usuário e senha na hora,
fale pelo nosso Telegram: **https://t.me/ClowntersPainelBot**. O pagamento é por Pix e o
acesso é liberado automaticamente.

## Instalar

Você só precisa do **git** instalado. O próprio `A1.sh` cuida do resto
(`curl`, `jq`, `tor`), **sobe o Tor sozinho** e abre o painel. Não precisa
configurar nada: o endereço do servidor já vem embutido.

### 📱 Termux (Android)

Instale o Termux pela **F-Droid** (a versão da Play Store é desatualizada).
Depois, abra o Termux e cole:

```bash
pkg update -y && pkg upgrade -y     # atualiza o Termux
pkg install -y git                  # instala o git
git clone https://github.com/Mike90s15/Clownters.git
cd Clownters
bash A1.sh                          # instala o resto e abre o painel
```

A primeira conexão ao Tor pode levar 1–2 minutos; o painel mostra o progresso e
só pede o login quando o Tor estiver pronto.

### 💻 Linux (Debian/Ubuntu/Kali e derivados)

```bash
sudo apt update && sudo apt upgrade -y   # atualiza o sistema
sudo apt install -y git                  # instala o git
git clone https://github.com/Mike90s15/Clownters.git
cd Clownters
bash A1.sh                               # instala o resto e abre o painel
```

> Fedora/RHEL: troque por `sudo dnf install -y git`. Arch: `sudo pacman -S git`.

### Depois de instalado

Da próxima vez, basta rodar `clownters` de qualquer pasta (o instalador cria
esse atalho) ou entrar na pasta e rodar `bash A1.sh`. O painel **se atualiza
sozinho** ao abrir — você sempre pega a versão mais nova.

## Como funciona

1. **Login** com o usuário e a senha que você recebeu. A sessão fica salva e
   **renova sozinha**; a senha nunca é guardada no aparelho.
2. O menu principal lista as áreas em ordem alfabética — **Consultas,
   Conversores, Ferramentas, Geradores, OSINT & Web, Recon & Cyber e
   Validadores**.
3. Escolhe a função, informa o valor (os geradores não pedem nada) e o resultado
   aparece na tela.

O menu é **dinâmico e se atualiza sozinho**: ao abrir, o painel busca a versão
mais nova e, quando uma função nova entra no servidor, ela aparece aqui sem você
fazer nada. Para recarregar na hora, use o item **95**.

> As funções de **senha** (vazada / força) são lidas de forma **oculta** e a
> senha **não sai do seu aparelho**: a checagem de vazamento envia só um trecho
> do hash (k-anonimato).

## Navegação

- **`q`** volta em qualquer tela (no menu principal, sai).
- **`98`** retorna ao menu e **`99`** sai do script.
- Depois de cada resultado: **01** continua na mesma função, **02** retorna ao
  menu, **00** sai.
- Entrada fora do formato mostra o aviso em vermelho e pergunta de novo.

Quem tem conta de administrador vê o item **96 Painel admin**: **gerar login de
teste** (usuário e senha automáticos, com validade opcional), criar usuário,
trocar senha, ativar/desativar, derrubar sessões, remover, e ver sessões ativas
e logs. As senhas são digitadas sem aparecer na tela.

> Já usa o painel e o `git pull` não funciona? O repositório foi reorganizado:
> apague a pasta e rode `git clone` de novo.

## Cuidados de segurança adotados

- Senha lida com `read -s` e enviada via **arquivo temporário (600)**, nunca no
  `argv` (não aparece em `ps`).
- Token enviado via **arquivo de config do curl (600)**, também fora do `argv`.
- JSON montado só com `jq -n --arg` (sem concatenação de string).
- Arquivos de config/token em `~/.config/clownters` com `umask 077`.

## Sobre o IP

O IP é **autodeclarado** pelo cliente. Enquanto a API roda sobre Tor, ele não é
verificável (toda conexão chega de `127.0.0.1`) — serve como rótulo de auditoria.
Passa a valer como origem real quando a API sair do Tor.

## Integridade (open source, sem "anti-mexer" escondido)

Não há verificação oculta que impeça você de ler ou alterar o código — isso
contradiz software aberto. A integridade é conferível de forma transparente:
publicamos os hashes e você confere.

```bash
sha256sum -c SHA256SUMS      # confere que os arquivos batem com os publicados
```

## Estrutura

```
.
├── A1.sh            # inicia o painel: bash A1.sh
├── clownters.sh     # entrypoint + menus
├── install.sh       # instala deps e o comando `clownters`
└── lib/
    ├── config.sh    # caminhos, endereço .onion, socks
    ├── ui.sh        # banner e menu (identidade Clownters)
    ├── deps.sh      # checagem/instalação de dependências
    ├── tor.sh       # detecção do Tor e do serviço
    ├── http.sh      # curl via SOCKS, sem expor segredos
    └── auth.sh      # login, token 600, refresh automático
```

## Licença

MIT — veja [`LICENSE`](LICENSE).
