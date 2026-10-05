#!/usr/bin/env bash
# Login, armazenamento do token (600) e renovação automática.

# Lê o access token salvo (stdout). Retorna 1 se não existir.
clw_token_read() {
    [[ -s "$CLW_TOKEN_FILE" ]] || return 1
    cat "$CLW_TOKEN_FILE"
}

# Salva tokens com permissão restrita.
clw_token_write() {
    umask 077
    printf '%s' "$1" >"$CLW_TOKEN_FILE"; chmod 600 "$CLW_TOKEN_FILE"
    printf '%s' "$2" >"$CLW_REFRESH_FILE"; chmod 600 "$CLW_REFRESH_FILE"
}

clw_logout() {
    local token
    if token=$(clw_token_read); then
        clw_http POST "/api/auth/logout" "" "$token" >/dev/null 2>&1 || true
    fi
    rm -f "$CLW_TOKEN_FILE" "$CLW_REFRESH_FILE"
    clw_ok "Sessão encerrada."
}

# device_id estável por instalação (gerado uma vez, guardado 600).
clw_device_id() {
    if [[ -s "$CLW_DEVICE_FILE" ]]; then
        cat "$CLW_DEVICE_FILE"; return 0
    fi
    local id
    id=$(cat /proc/sys/kernel/random/uuid 2>/dev/null) \
        || id=$(head -c16 /dev/urandom | od -An -tx1 | tr -d ' \n')
    umask 077
    printf '%s' "$id" >"$CLW_DEVICE_FILE"; chmod 600 "$CLW_DEVICE_FILE"
    printf '%s' "$id"
}

# IP público obtido FORA do Tor (o servidor, via Tor, veria só 127.0.0.1).
# Atenção: isto revela seu IP real ao serviço de IP e à API. É autodeclarado e
# não é verificável; serve para auditoria/log de login.
clw_public_ip() {
    curl -s --max-time 5 https://api.ipify.org 2>/dev/null || echo ""
}

# Fluxo de login interativo.
clw_login() {
    local user pass ip dev datafile
    # Layout do painel antigo: Username / Password, "q" sai, vazio repete.
    while :; do
        clw_banner
        printf '\e[1;32m Username\n\e[1;34m ===> \e[1;36m'
        read -r user || exit 0
        clw_is_back "$user" && exit 0
        [[ -n "$user" ]] && break
        clw_digite_algo
    done
    while :; do
        clw_banner
        printf '\e[1;32m Password\n \e[1;34m===> \e[1;36m'
        read -rs pass || exit 0
        echo
        clw_is_back "$pass" && exit 0
        [[ -n "$pass" ]] && break
        clw_digite_algo
    done

    dev=$(clw_device_id)
    ip=$(clw_public_ip)

    # Monta o JSON com jq (nunca por concatenação) num arquivo temporário 600.
    # Sem `trap ... RETURN`: ele continua ativo depois desta função e, com
    # `set -u`, derrubava o painel no próximo return (datafile já não existe).
    datafile=$(mktemp); chmod 600 "$datafile"
    jq -n --arg u "$user" --arg p "$pass" --arg d "$dev" --arg i "$ip" \
        '{username:$u, password:$p, device_id:$d, declared_ip:$i}' >"$datafile"
    unset pass

    clw_info "Autenticando via Tor..."
    clw_http POST "/api/auth/token" "$datafile"
    rm -f "$datafile"

    case "$CLW_HTTP_CODE" in
        200)
            local at rt
            at=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.access_token')
            rt=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.refresh_token')
            clw_token_write "$at" "$rt"
            printf '\n Okay...\n'; sleep 1
            return 0
            ;;
        401) printf '\n \e[1;31m\aUsername ou password incorreto\a\n'; sleep 1 ;;
        429) clw_err "Muitas tentativas. Aguarde e tente de novo." ;;
        "")  clw_err "Sem resposta do serviço (.onion fora do ar?)." ;;
        *)   clw_err "Falha no login (HTTP $CLW_HTTP_CODE)." ;;
    esac
    return 1
}

# Renova o access token usando o refresh (rotação). Retorna 0 se renovou.
clw_auth_refresh() {
    [[ -s "$CLW_REFRESH_FILE" ]] || return 1
    local rt datafile
    rt=$(cat "$CLW_REFRESH_FILE")
    datafile=$(mktemp); chmod 600 "$datafile"
    jq -n --arg r "$rt" '{refresh_token:$r}' >"$datafile"
    clw_http POST "/api/auth/refresh" "$datafile"
    rm -f "$datafile"
    if [[ "$CLW_HTTP_CODE" == "200" ]]; then
        local at nrt
        at=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.access_token')
        nrt=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.refresh_token')
        clw_token_write "$at" "$nrt"
        return 0
    fi
    # refresh inválido/reuso: limpa e força novo login.
    rm -f "$CLW_TOKEN_FILE" "$CLW_REFRESH_FILE"
    return 1
}

# Garante uma sessão válida (tenta refresh; senão, login).
clw_auth_ensure() {
    # Sessão salva: confere com a API (usuário pode ter sido desativado/removido).
    if clw_token_read >/dev/null 2>&1 || clw_auth_refresh; then
        clw_api_get "/api/auth/me" && return 0
        [[ "$CLW_HTTP_CODE" == "401" ]] || return 0   # sem rede: segue com a sessão salva
        rm -f "$CLW_TOKEN_FILE" "$CLW_REFRESH_FILE"
    fi
    # 3 tentativas, como no painel antigo.
    local i
    for i in 1 2 3; do
        clw_login && return 0
        [[ "$CLW_HTTP_CODE" == "401" && $i -lt 3 ]] || return 1
        printf ' Digite Q para sair\n'; sleep 1
    done
}
