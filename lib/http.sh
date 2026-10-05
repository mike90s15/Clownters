#!/usr/bin/env bash
# Camada HTTP: fala com a API via Tor (SOCKS5).
# Segredos (senha, token) nunca vão no argv: usamos arquivo de config do curl
# (600) e o corpo da requisição em arquivo temporário, ambos apagados no fim.

CLW_HTTP_CODE=""
CLW_HTTP_BODY=""

# clw_http METHOD PATH [DATAFILE] [BEARER]
# Preenche CLW_HTTP_CODE e CLW_HTTP_BODY.
clw_http() {
    local method=$1 path=$2 datafile=${3:-} bearer=${4:-}
    local cfg out dev
    dev=$(clw_device_id 2>/dev/null)          # id estável deste aparelho
    cfg=$(mktemp) || return 1
    chmod 600 "$cfg"
    {
        printf 'url = "%s%s"\n' "$(clw_base_url)" "$path"
        printf 'request = "%s"\n' "$method"
        [[ -z "$CLW_API_URL" ]] && printf 'socks5-hostname = "%s"\n' "$CLW_SOCKS"
        printf 'connect-timeout = 30\n'
        printf 'max-time = 60\n'
        printf 'silent\n'
        printf 'write-out = "\\n%%{http_code}"\n'
        [[ -n "$bearer" ]] && printf 'header = "Authorization: Bearer %s"\n' "$bearer"
        # Amarra a sessão a este aparelho (token copiado p/ outro não funciona).
        [[ -n "$dev" ]] && printf 'header = "X-Device-Id: %s"\n' "$dev"
        if [[ -n "$datafile" ]]; then
            printf 'header = "Content-Type: application/json"\n'
            printf 'data = "@%s"\n' "$datafile"
        fi
        # Retry só é seguro em GET (idempotente); login/refresh nunca repetem.
        [[ "$method" == "GET" ]] && printf 'retry = 2\nretry-delay = 3\nretry-connrefused\n'
    } >"$cfg"

    out=$(curl -K "$cfg" 2>/dev/null)
    rm -f "$cfg"
    CLW_HTTP_CODE=${out##*$'\n'}
    CLW_HTTP_BODY=${out%$'\n'*}
    [[ -n "$CLW_HTTP_CODE" ]]
}

# GET autenticado, com renovação automática do token em caso de 401.
clw_api_get() {
    local path=$1 token
    token=$(clw_token_read) || { clw_err "Você não está logado."; return 2; }
    clw_http GET "$path" "" "$token"
    if [[ "$CLW_HTTP_CODE" == "401" ]]; then
        if clw_auth_refresh; then
            token=$(clw_token_read)
            clw_http GET "$path" "" "$token"
        fi
    fi
    [[ "$CLW_HTTP_CODE" == "200" ]]
}

# POST/DELETE autenticado, com corpo JSON opcional e renovação do token em 401.
# O corpo vai num arquivo temporário 600 (senhas nunca aparecem no argv).
clw_api_send() {
    local method=$1 path=$2 json=${3:-} token datafile=""
    token=$(clw_token_read) || { clw_err "Você não está logado."; return 2; }
    if [[ -n "$json" ]]; then
        datafile=$(mktemp); chmod 600 "$datafile"
        printf '%s' "$json" >"$datafile"
    fi
    clw_http "$method" "$path" "$datafile" "$token"
    if [[ "$CLW_HTTP_CODE" == "401" ]] && clw_auth_refresh; then
        token=$(clw_token_read)
        clw_http "$method" "$path" "$datafile" "$token"
    fi
    if [[ -n "$datafile" ]]; then rm -f "$datafile"; fi
    [[ "$CLW_HTTP_CODE" == 2* ]]
}
