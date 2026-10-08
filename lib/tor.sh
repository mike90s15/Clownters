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

# Confirma que o onion responde de PONTA A PONTA. Ter o SOCKS aberto não basta:
# no Termux o Tor demora a chegar em "Bootstrapped 100%" e o 1º request caía em
# HTTP 000 (login disparava cedo demais). Aqui a gente faz um ping barato em
# /api/health e INSISTE com backoff até o onion responder (qualquer código HTTP
# já prova que o caminho está de pé) ou estourar o prazo. Disponibilidade acima
# de velocidade: com a rede boa responde em ~1-2s e quase não pesa; com a rede
# ruim a gente espera em vez de falhar. Ajuste o prazo com CLW_ONION_WAIT (seg).
clw_tor_wait_onion() {
    [[ -n "$CLW_API_URL" ]] && return 0      # API direta: sem Tor, nada a checar
    local url code delay=2 max start elapsed shown=0
    max=${CLW_ONION_WAIT:-180}
    url="$(clw_base_url)/api/health"
    start=$SECONDS
    while (( SECONDS - start < max )); do
        code=$(curl -s -o /dev/null -w '%{http_code}' \
                 --socks5-hostname "$CLW_SOCKS" \
                 --connect-timeout 20 --max-time 30 "$url" 2>/dev/null) || code=""
        if [[ -n "$code" && "$code" != "000" ]]; then
            if (( shown )); then printf '\n'; fi     # fecha a linha do contador
            clw_ok "Conectado à rede Tor."
            return 0
        fi
        # Cabeçalho (uma vez): a citação vai na linha DE BAIXO — telas estreitas
        # do Termux não quebram no meio.
        if (( shown == 0 )); then
            clw_info "Conectando pela rede Tor..."
            clw_info "(na 1ª vez pode levar até ~${max}s)"
            shown=1
        fi
        # Contador de tempo vivo, atualizado NA MESMA linha (\r) p/ não rolar a tela.
        elapsed=$(( SECONDS - start ))
        printf '\r %b aguardando o circuito... %ds/%ds %b' "$C_CYA" "$elapsed" "$max" "$C_RESET"
        sleep "$delay"
        if (( delay < 8 )); then delay=$(( delay + 2 )); fi
    done
    if (( shown )); then printf '\n'; fi              # sai da linha do contador
    return 1
}

# Garante o caminho até a API: SOCKS de pé (o que já existir, ou sobe o Tor) E o
# onion respondendo. Só volta 0 quando dá pra realmente falar com o servidor.
clw_tor_ensure() {
    [[ -n "$CLW_API_URL" ]] && return 0     # API direta: não precisa de Tor
    if ! clw_tor_socks_up && ! clw_tor_autostart; then
        clw_tor_guide
        return 1
    fi
    clw_tor_wait_onion && return 0
    clw_err "A rede Tor demorou demais pra responder. Cheque sua internet e tente de novo."
    return 1
}
