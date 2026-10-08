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

# clw_self_update [manual]
# Sem argumento = auto-update da inicialização: silencioso e rápido (não atrapalha
# quem está offline). Com "manual" (opção 95) = o usuário PEDIU: avisa cada passo,
# espera mais pela rede e ressincroniza de verdade (reset --hard mesmo já em dia,
# pra limpar qualquer alteração solta). Nunca derruba o painel (roda sob set -e).
clw_self_update() {
    local manual=${1:-}
    if [[ -n "${CLW_NO_UPDATE:-}" ]]; then
        [[ -n "$manual" ]] && clw_warn "Auto-atualização desligada (CLW_NO_UPDATE)."
        return 0
    fi
    [[ -z "$manual" && -n "${CLW_UPDATED:-}" ]] && return 0              # já reiniciou nesta sessão
    if ! command -v git >/dev/null 2>&1; then
        [[ -n "$manual" ]] && clw_warn "git não encontrado — não dá pra atualizar."
        return 0
    fi
    if [[ ! -d "$SCRIPT_DIR/.git" ]]; then
        [[ -n "$manual" ]] && clw_warn "Esta instalação não é um clone git; não atualiza sozinha."
        return 0
    fi

    local to="" branch local_ remoto secs=12
    [[ -n "$manual" ]] && secs=30                                        # manual: mais paciência c/ rede móvel
    command -v timeout >/dev/null 2>&1 && to="timeout $secs"            # offline não trava

    branch=$(git -C "$SCRIPT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)
    [[ -z "$branch" || "$branch" == "HEAD" ]] && branch="main"

    [[ -n "$manual" ]] && clw_info "Buscando atualização..."
    # Busca o estado remoto (silencioso no auto; sem rede, segue na versão atual).
    if ! $to git -C "$SCRIPT_DIR" fetch --quiet origin "$branch" 2>/dev/null; then
        [[ -n "$manual" ]] && clw_warn "Sem conexão pra atualizar agora; seguindo na versão atual."
        return 0
    fi
    local_=$(git -C "$SCRIPT_DIR" rev-parse HEAD 2>/dev/null) || return 0
    remoto=$(git -C "$SCRIPT_DIR" rev-parse "origin/$branch" 2>/dev/null) || return 0

    if [[ "$local_" == "$remoto" ]]; then                                # já em dia
        # No manual, ainda espelha o remoto pra descartar edição local solta.
        [[ -n "$manual" ]] && { git -C "$SCRIPT_DIR" reset --hard --quiet "origin/$branch" 2>/dev/null || true
                                clw_ok "Painel já está na última versão."; }
        return 0
    fi

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
