#!/usr/bin/env bash
# Verificação do Tor: porta SOCKS acessível + serviço da API alcançável.

# Testa se a porta SOCKS responde. Tenta 9050 (daemon) e 9150 (Tor Browser).
clw_tor_socks_up() {
    local host port
    for cand in "$CLW_SOCKS" "127.0.0.1:9050" "127.0.0.1:9150"; do
        host=${cand%:*}; port=${cand##*:}
        # O fd 3 só existe dentro do subshell; nada a fechar aqui fora.
        if (exec 3<>"/dev/tcp/$host/$port") 2>/dev/null; then
            CLW_SOCKS="$cand"
            return 0
        fi
    done
    return 1
}

# Orienta o usuário caso o Tor não suba sozinho.
clw_tor_guide() {
    clw_err "Não consegui iniciar o Tor."
    if [[ -n "${PREFIX:-}" ]]; then
        clw_info "No Termux:  pkg install tor    e depois rode o painel de novo."
    else
        clw_info "Instale o Tor:  sudo apt install tor    e rode o painel de novo."
    fi
}

# Espera o Tor chegar a "Bootstrapped 100%" lendo o log. A porta SOCKS abre
# bem antes disso, e um .onion acessado nesse meio-tempo falha — no Termux,
# onde o bootstrap é mais lento, o primeiro login caía sempre aqui.
clw_tor_wait_bootstrap() {
    local log=$1 pid=$2 i
    for ((i = 0; i < 120; i++)); do
        grep -q 'Bootstrapped 100%' "$log" 2>/dev/null && return 0
        kill -0 "$pid" 2>/dev/null || return 1
        sleep 1
    done
    return 1
}

# Inicia o Tor em background (Termux e Linux sem systemd) e espera o bootstrap.
clw_tor_autostart() {
    command -v tor >/dev/null 2>&1 || return 1
    clw_info "Iniciando o Tor... (a primeira vez pode levar alguns segundos)"
    mkdir -p "$CLW_CONFIG_DIR"
    local log="$CLW_CONFIG_DIR/tor.log" pid
    nohup tor >"$log" 2>&1 </dev/null &
    pid=$!
    disown 2>/dev/null || true

    if ! clw_tor_wait_bootstrap "$log" "$pid" && ! kill -0 "$pid" 2>/dev/null; then
        clw_err "O Tor encerrou ao iniciar. Final do log ($log):"
        tail -n 5 "$log" >&2
        return 1
    fi
    clw_tor_socks_up && { clw_ok "Tor pronto."; return 0; }
    return 1
}

# Garante o SOCKS de pé: usa o que já existir (9050/9150) ou sobe o Tor sozinho.
clw_tor_ensure() {
    [[ -n "$CLW_API_URL" ]] && return 0     # API direta: não precisa de Tor
    clw_tor_socks_up && return 0
    clw_tor_autostart && return 0
    clw_tor_guide
    return 1
}
