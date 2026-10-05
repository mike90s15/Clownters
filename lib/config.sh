#!/usr/bin/env bash
# Configuração e caminhos do cliente Clownters.
# Toda a lógica de negócio fica na API; aqui é só interface.

CLW_NAME="Clownters"
CLW_VERSION="2.0.0"

# Diretório de config do usuário (token, device_id, endereço .onion).
CLW_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/clownters"
CLW_CONF_FILE="$CLW_CONFIG_DIR/config"
CLW_TOKEN_FILE="$CLW_CONFIG_DIR/access.token"
CLW_REFRESH_FILE="$CLW_CONFIG_DIR/refresh.token"
CLW_DEVICE_FILE="$CLW_CONFIG_DIR/device.id"

# Proxy SOCKS do Tor. 9050 = daemon (tor), 9150 = Tor Browser.
CLW_SOCKS="${CLW_SOCKS:-127.0.0.1:9050}"

# Endereço do onion service da API (sem http://).
# Já vem embutido para o usuário não precisar digitar nada; pode ser
# sobrescrito pela variável de ambiente CLW_ONION ou pelo arquivo de config.
CLW_ONION="${CLW_ONION:-ctwxsyernpf6vcqgxol2e3o45v7ewfsu3lx2fx75547zjkgg6ogaeyqd.onion}"

# Bot de vendas/contato no Telegram. O painel tenta abrir ao iniciar.
CLW_BOT_URL="${CLW_BOT_URL:-https://t.me/ClowntersPainelBot}"
CLW_INSTAGRAM_URL="${CLW_INSTAGRAM_URL:-https://instagram.com/mike90s15}"

# Cria o diretório de config com permissão restrita.
clw_config_init() {
    umask 077
    mkdir -p "$CLW_CONFIG_DIR"
    # `if` e não `[[ ]] && source`: sem o arquivo (1ª execução) o && retornaria
    # 1 e o `set -e` do clownters.sh encerraria o painel sem mensagem nenhuma.
    if [[ -f "$CLW_CONF_FILE" ]]; then
        # shellcheck disable=SC1090
        source "$CLW_CONF_FILE"
    fi
}

# Persiste o endereço .onion e o socks escolhidos.
clw_config_save() {
    umask 077
    {
        echo "CLW_ONION=\"$CLW_ONION\""
        echo "CLW_SOCKS=\"$CLW_SOCKS\""
    } >"$CLW_CONF_FILE"
    chmod 600 "$CLW_CONF_FILE"
}

# API direta, sem Tor (só para testes/desenvolvimento). Ex.: http://127.0.0.1:8011
CLW_API_URL="${CLW_API_URL:-}"

# Base URL da API (sobre Tor, a menos que CLW_API_URL esteja definida).
clw_base_url() {
    if [[ -n "$CLW_API_URL" ]]; then printf '%s' "${CLW_API_URL%/}"
    else printf 'http://%s' "$CLW_ONION"; fi
}
