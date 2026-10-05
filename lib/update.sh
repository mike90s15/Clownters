#!/usr/bin/env bash
# Auto-atualização do cliente.
#
# Se o painel foi instalado via `git clone`, ele mesmo busca a versão nova no
# início e se reinicia já atualizado — assim toda melhoria publicada chega no
# cliente sem ele fazer nada. É silencioso e tolerante a falha: offline, sem
# git ou com erro, o painel segue normal na versão atual.
#
# O repositório é mantido como UM commit só (publicação por force-push), então
# o update ESPELHA o remoto com `reset --hard` em vez de `pull` — assim aguenta
# a reescrita de histórico. O cliente é só leitura; nada de dado do usuário mora
# aqui (token/config ficam em ~/.config/clownters), então o reset é seguro.
#
# Desligar de vez:  CLW_NO_UPDATE=1 bash clownters.sh

clw_self_update() {
    [[ -n "${CLW_NO_UPDATE:-}" || -n "${CLW_UPDATED:-}" ]] && return 0   # desligado / já reiniciou
    command -v git >/dev/null 2>&1 || return 0
    [[ -d "$SCRIPT_DIR/.git" ]] || return 0                              # só clones git

    local to="" branch local_ remoto
    command -v timeout >/dev/null 2>&1 && to="timeout 12"               # offline não trava

    branch=$(git -C "$SCRIPT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)
    [[ -z "$branch" || "$branch" == "HEAD" ]] && branch="main"

    # Busca o estado remoto (silencioso; sem rede, segue na versão atual).
    $to git -C "$SCRIPT_DIR" fetch --quiet origin "$branch" 2>/dev/null || return 0
    local_=$(git -C "$SCRIPT_DIR" rev-parse HEAD 2>/dev/null) || return 0
    remoto=$(git -C "$SCRIPT_DIR" rev-parse "origin/$branch" 2>/dev/null) || return 0
    [[ "$local_" == "$remoto" ]] && return 0                             # já em dia

    clw_info "Atualizando o painel..."
    # Espelha exatamente o remoto (aguenta force-push / histórico reescrito).
    if git -C "$SCRIPT_DIR" reset --hard --quiet "origin/$branch" 2>/dev/null; then
        clw_ok "Painel atualizado. Reiniciando..."
        sleep 1
        CLW_UPDATED=1 exec bash "$SCRIPT_DIR/clownters.sh"               # reinicia já na versão nova
    else
        clw_warn "Não consegui atualizar agora; seguindo na versão atual."
        sleep 1
    fi
    return 0                                                             # nunca derruba o painel (set -e)
}
