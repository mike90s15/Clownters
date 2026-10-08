#!/usr/bin/env bash
#
# Clownters — cliente/painel (open source).
# Interface para a API de consultas, que roda como Tor onion service.
# TODA a lógica de negócio fica na API; aqui é só menu, entrada e exibição.
#
set -euo pipefail

# Resolve o caminho real, mesmo quando chamado pelo symlink `clownters` no PATH
# (ex.: $PREFIX/bin/clownters no Termux). Sem isso, procuraria lib/ em /usr/bin.
_clw_src="${BASH_SOURCE[0]}"
while [ -h "$_clw_src" ]; do
    _clw_dir="$(cd "$(dirname "$_clw_src")" && pwd)"
    _clw_src="$(readlink "$_clw_src")"
    [[ "$_clw_src" != /* ]] && _clw_src="$_clw_dir/$_clw_src"
done
SCRIPT_DIR="$(cd "$(dirname "$_clw_src")" && pwd)"
unset _clw_src _clw_dir
# shellcheck source=lib/config.sh
source "$SCRIPT_DIR/lib/config.sh"
# shellcheck source=lib/ui.sh
source "$SCRIPT_DIR/lib/ui.sh"
# shellcheck source=lib/deps.sh
source "$SCRIPT_DIR/lib/deps.sh"
# shellcheck source=lib/tor.sh
source "$SCRIPT_DIR/lib/tor.sh"
# shellcheck source=lib/http.sh
source "$SCRIPT_DIR/lib/http.sh"
# shellcheck source=lib/auth.sh
source "$SCRIPT_DIR/lib/auth.sh"
# shellcheck source=lib/update.sh
source "$SCRIPT_DIR/lib/update.sh"

CLW_ROLE="user"
# Uma posição por função do painel (todas vêm de GET /api/modules).
declare -a CLW_MOD_NAMES=() CLW_MOD_CATS=() CLW_MOD_MENUS=() CLW_MOD_PROMPTS=() \
           CLW_MOD_EXAMPLES=() CLW_MOD_FREE=()

# Submenus do menu principal, nesta ordem: categoria e título.
CLW_CATS=(consulta conversor ferramenta gerador osint recon validador)
declare -A CLW_CAT_TITLE=(
    [consulta]="Menu de Consultas"   [gerador]="Menu de Geradores"
    [validador]="Menu de Validadores" [ferramenta]="Menu de Ferramentas"
    [osint]="Menu OSINT & Web"       [recon]="Menu Recon & Cyber"
    [conversor]="Menu Conversores"
)

# --- Setup inicial ----------------------------------------------------------

clw_bootstrap() {
    clw_banner                     # todo cliente vê o banner ao abrir o painel
    clw_self_update                # puxa a versão nova sozinho (reinicia se atualizar)
    clw_config_init
    clw_abrir_link "$CLW_INSTAGRAM_URL"  # abre o Instagram primeiro (o cara vê e segue)
    # depois de uns segundos abre o bot (facilita a compra) — em 2º plano, não trava o painel
    ( sleep "${CLW_BOT_DELAY:-7}"; clw_abrir_link "$CLW_BOT_URL" ) >/dev/null 2>&1 &
    clw_deps_ensure || exit 1      # instala curl/jq/tor se faltar
    clw_tor_ensure   || exit 1      # usa o Tor rodando ou sobe sozinho
    clw_auth_ensure  || exit 1      # login (ou renova token existente)
    clw_load_profile || true
    # Uma falha transitória do Tor ao carregar módulos não deve derrubar o painel.
    clw_load_modules || true
}

clw_load_profile() {
    if clw_api_get "/api/auth/me"; then
        CLW_ROLE=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.role // "user"')
    fi
}

# Lê um campo de cada módulo da última resposta de /api/modules.
_clw_mod_field() { printf '%s' "$CLW_HTTP_BODY" | jq -r ".[] | $1"; }

clw_load_modules() {
    if ! clw_api_get "/api/modules"; then
        clw_err "Não consegui carregar as funções do painel."
        CLW_MOD_NAMES=(); return 1
    fi
    mapfile -t CLW_MOD_NAMES    < <(_clw_mod_field '.name')
    mapfile -t CLW_MOD_CATS     < <(_clw_mod_field '.category // "consulta"')
    mapfile -t CLW_MOD_MENUS    < <(_clw_mod_field '.menu // ("Consulta de " + .label)')
    mapfile -t CLW_MOD_PROMPTS  < <(_clw_mod_field '.prompt // ("Informe o " + .label + " para a consulta")')
    mapfile -t CLW_MOD_EXAMPLES < <(_clw_mod_field '.example // ""')
    mapfile -t CLW_MOD_FREE     < <(_clw_mod_field '.free_text // false')
}

# --- Execução de uma função ---------------------------------------------------

# Aviso de entrada inválida no estilo do painel antigo: vermelho, 2s, pergunta de novo.
clw_aviso_invalido() {
    local line
    printf '\n'
    while IFS= read -r line; do
        printf '\e[31m %s\n' "$line"
    done <<<"$1"
    printf '\e[m'
    sleep 2
}

# Resultado: linha verde/vermelha (validadores) + campos alinhados.
clw_render_result() {
    local ok msg
    ok=$(printf '%s' "$1" | jq -r '.ok')
    msg=$(printf '%s' "$1" | jq -r '.message // empty')
    if [[ -n "$msg" ]]; then
        if [[ "$ok" == "true" ]]; then printf '\e[1;32m %s\e[m\n\n' "$msg"
        else printf '\e[1;31m %s\e[m\n\n' "$msg"; fi
    fi
    clw_render_data "$1"
}

# Executa a função de índice $1: pergunta (se houver), chama a API, mostra o
# resultado e oferece o menu de retorno. Geradores não perguntam nada.
clw_run_module() {
    local idx=$1 param path
    local tipo=${CLW_MOD_NAMES[idx]} prompt=${CLW_MOD_PROMPTS[idx]}
    local example=${CLW_MOD_EXAMPLES[idx]} free=${CLW_MOD_FREE[idx]}
    while :; do
        clw_banner
        if [[ -n "$prompt" ]]; then
            [[ -n "$example" ]] && printf '\e[1;33m %s\n\n' "$example"
            printf '\e[1;34m %s\n ===> \e[1;36m' "$prompt"
            # Funções de senha: leitura OCULTA (não aparece na tela).
            if [[ "$tipo" == "senhavazada" || "$tipo" == "forcasenha" ]]; then
                IFS= read -rs param || exit 0; printf '\n'
            else
                IFS= read -r param || exit 0
            fi
            # Senha não é "limpa" de espaços (poderia alterar a senha do usuário).
            if [[ "$tipo" != "senhavazada" && "$tipo" != "forcasenha" && "$free" != "true" ]]; then
                param=$(printf '%s' "$param" | tr -d '[:space:]')
            fi
            clw_is_back "${param// /}" && return 0
            [[ -z "${param// /}" ]] && { clw_digite_algo; continue; }
            # Senha Vazada: envia só o SHA-1 (a senha em texto nunca sai daqui).
            if [[ "$tipo" == "senhavazada" ]]; then
                param=$(printf '%s' "$param" | sha1sum | cut -c1-40)
            fi
            path="/api/$tipo/$(jq -rn --arg p "$param" '$p | @uri')"
        else
            path="/api/$tipo"
        fi

        clw_api_get "$path" || true

        echo
        case "$CLW_HTTP_CODE" in
            200) clw_render_result "$CLW_HTTP_BODY" ;;
            400)
                clw_aviso_invalido "$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.detail // "Entrada inválida"')"
                [[ -n "$prompt" ]] && continue
                ;;
            401)   # sessão derrubada (login em outro aparelho) ou expirada: novo login
                clw_err "Sessão encerrada — sua conta foi aberta em outro aparelho ou expirou. Faça login de novo."; sleep 2
                clw_auth_ensure || exit 0
                clw_load_profile || true
                return 0
                ;;
            404) clw_warn "Nada encontrado." ;;
            429) clw_err "Limite de consultas atingido. Aguarde um pouco." ;;
            502) clw_err "A fonte de dados está indisponível no momento." ;;
            *)   clw_err "Erro na consulta (HTTP ${CLW_HTTP_CODE:-sem resposta})." ;;
        esac
        echo
        clw_retorne_menu || return 0
    done
}

# --- Submenus (Consultas, Geradores, Validadores, Ferramentas) ----------------

clw_sub_menu() {
    local cat=$1 op i n
    local -a idxs
    while :; do
        idxs=()
        for i in "${!CLW_MOD_NAMES[@]}"; do
            [[ "${CLW_MOD_CATS[i]}" == "$cat" ]] && idxs+=("$i")
        done
        clw_banner
        n=${#idxs[@]}
        for ((i = 0; i < n; i++)); do
            clw_item "$(printf '%02d' $((i + 1)))" "${CLW_MOD_MENUS[idxs[i]]}"
        done
        printf '\n'
        clw_item 98 "Retornar ao menu" "$C_RED"
        clw_item 99 "Sair do script" "$C_RED"
        clw_prompt; read -r op || exit 0

        case "$op" in
            99|0|00) exit 0 ;;
            98) return 0 ;;
        esac
        clw_is_back "$op" && return 0
        if [[ "$op" =~ ^[0-9]+$ ]] && ((10#$op >= 1 && 10#$op <= n)); then
            clw_run_module "${idxs[10#$op - 1]}"
        else
            clw_invalida
        fi
    done
}

# --- Painel admin -----------------------------------------------------------

# Pergunta no layout do painel. Retorna 1 se digitou q (voltar).
# $1 = texto, $2 = variável de destino, $3 = "-s" para não mostrar o que digita
clw_ask() {
    local _resp
    printf '\e[1;34m %s\n ===> \e[1;36m' "$1"
    if [[ "${3:-}" == "-s" ]]; then
        IFS= read -rs _resp || exit 0
        echo
    else
        IFS= read -r _resp || exit 0
    fi
    [[ "${_resp,,}" == q ]] && return 1
    printf -v "$2" '%s' "$_resp"
}

# Mensagem de erro da API (detail) ou a padrão $1.
clw_api_detail() {
    local d
    d=$(printf '%s' "$CLW_HTTP_BODY" | jq -r 'if (.detail | type) == "string" then .detail else empty end' 2>/dev/null)
    printf '%s' "${d:-$1}"
}

# Lista os usuários; guarda o JSON em CLW_USERS para as outras ações.
CLW_USERS="[]"
clw_admin_list_users() {
    clw_api_get "/api/admin/users" || { clw_err "Não consegui listar os usuários."; return 1; }
    CLW_USERS=$CLW_HTTP_BODY
    printf '%s' "$CLW_USERS" | jq -r '.[] |
        "  \u001b[1;34m•#\(.id) \u001b[0;32m\(.username) \u001b[1;36m[\(.role)]" +
        (if .disabled == 1 then " \u001b[1;31m(desativado)" else "" end) + "\u001b[m"'
    echo
}

# Pede um ID existente na lista. Retorna 1 se voltou (q).
clw_admin_pick_user() {
    local -n _id=$1
    while :; do
        clw_ask "Informe o ID do usuário" _id || return 1
        _id=${_id//[^0-9]/}
        if [[ -n "$_id" ]] && printf '%s' "$CLW_USERS" | jq -e --argjson i "$_id" 'any(.[]; .id == $i)' >/dev/null; then
            return 0
        fi
        clw_aviso_invalido $'ID inválido\nEscolha um ID da lista acima'
    done
}

# Pede senha duas vezes, mínimo 8. Retorna 1 se voltou (q).
clw_admin_ask_password() {
    local -n _pw=$1
    local conf
    while :; do
        clw_ask "Senha (mínimo 8 caracteres)" _pw -s || return 1
        if ((${#_pw} < 8)); then
            clw_aviso_invalido $'Senha muito curta\nA senha precisa de pelo menos 8 caracteres'
            continue
        fi
        clw_ask "Repita a senha" conf -s || return 1
        [[ "$_pw" == "$conf" ]] && return 0
        clw_aviso_invalido $'Senhas diferentes\nDigite a mesma senha nas duas vezes'
    done
}

clw_admin_create() {
    local user pw tipo role json
    while :; do
        clw_ask "Informe o username do novo usuário" user || return 1
        user=$(printf '%s' "$user" | tr -d '[:space:]')
        [[ -n "$user" ]] && break
        clw_digite_algo; printf '\n'
    done
    clw_admin_ask_password pw || return 1
    clw_ask "Tipo: 1 = usuário, 2 = admin (Enter = usuário)" tipo || return 1
    role=user; [[ "$tipo" == 2 || "$tipo" == 02 ]] && role=admin
    json=$(jq -n --arg u "$user" --arg p "$pw" --arg r "$role" '{username:$u, password:$p, role:$r}')
    unset pw
    if clw_api_send POST "/api/admin/users" "$json"; then
        clw_ok "Usuário '$user' criado ($role)."
    else
        clw_err "$(clw_api_detail 'Não consegui criar o usuário.')"
    fi
}

# Gera um login de teste automático (usuário + senha aleatórios) no servidor.
clw_admin_create_auto() {
    local dias json u p e
    clw_ask "Validade em dias (Enter = sem prazo)" dias || return 1
    dias=$(printf '%s' "$dias" | tr -cd '0-9')
    if [[ -n "$dias" ]]; then
        json=$(jq -n --argjson d "$dias" '{dias:$d, prefixo:"teste"}')
    else
        json=$(jq -n '{dias:null, prefixo:"teste"}')
    fi
    if ! clw_api_send POST "/api/admin/users/auto" "$json"; then
        clw_err "$(clw_api_detail 'Não consegui gerar o login.')"
        return 0
    fi
    u=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.username')
    p=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.password')
    e=$(printf '%s' "$CLW_HTTP_BODY" | jq -r '.expires_at // "sem prazo"')
    clw_ok "Login de teste gerado:"
    printf '\n   %bUsuário:%b %s\n   %bSenha:%b   %s\n   %bValidade:%b %s\n\n' \
        "$C_CYA" "$C_RESET" "$u" "$C_CYA" "$C_RESET" "$p" "$C_CYA" "$C_RESET" "$e"
    clw_info "Copie e envie ao cliente. A senha não aparece de novo."
}

clw_admin_password() {
    local id pw json
    clw_admin_pick_user id || return 1
    clw_admin_ask_password pw || return 1
    json=$(jq -n --arg p "$pw" '{password:$p}')
    unset pw
    if clw_api_send POST "/api/admin/users/$id/password" "$json"; then
        clw_ok "Senha alterada."
    else
        clw_err "$(clw_api_detail 'Não consegui trocar a senha.')"
    fi
}

clw_admin_toggle() {
    local id now
    clw_admin_pick_user id || return 1
    now=$(printf '%s' "$CLW_USERS" | jq -r --argjson i "$id" '.[] | select(.id == $i) | .disabled')
    if [[ "$now" == 1 ]]; then
        clw_api_send POST "/api/admin/users/$id/disable?disabled=false" && clw_ok "Usuário reativado." \
            || clw_err "$(clw_api_detail 'Não consegui reativar.')"
    else
        clw_api_send POST "/api/admin/users/$id/disable?disabled=true" && clw_ok "Usuário desativado (sessões bloqueadas na hora)." \
            || clw_err "$(clw_api_detail 'Não consegui desativar.')"
    fi
}

clw_admin_revoke() {
    local id
    clw_admin_pick_user id || return 1
    clw_api_send POST "/api/admin/users/$id/revoke" && clw_ok "Sessões derrubadas: o usuário terá que logar de novo." \
        || clw_err "$(clw_api_detail 'Não consegui derrubar as sessões.')"
}

clw_admin_delete() {
    local id nome conf
    clw_admin_pick_user id || return 1
    nome=$(printf '%s' "$CLW_USERS" | jq -r --argjson i "$id" '.[] | select(.id == $i) | .username')
    clw_ask "Remover '$nome' de vez? Digite S para confirmar" conf || return 1
    [[ "${conf,,}" == s ]] || { clw_warn "Nada removido."; return 0; }
    clw_api_send DELETE "/api/admin/users/$id" && clw_ok "Usuário '$nome' removido." \
        || clw_err "$(clw_api_detail 'Não consegui remover.')"
}

clw_admin_menu() {
    local op
    while :; do
        clw_banner
        clw_item 01 "Listar usuários"
        clw_item 02 "Gerar login (teste)"
        clw_item 03 "Criar usuário"
        clw_item 04 "Trocar senha"
        clw_item 05 "Ativar/desativar"
        clw_item 06 "Derrubar sessões"
        clw_item 07 "Remover usuário"
        clw_item 08 "Sessões ativas"
        clw_item 09 "Logs de auditoria"
        printf '\n'
        clw_item 98 "Retornar ao menu" "$C_RED"
        clw_item 99 "Sair do script" "$C_RED"
        clw_prompt; read -r op || exit 0
        case "$op" in
            99|0|00) exit 0 ;;
            98) return 0 ;;
        esac
        clw_is_back "$op" && return 0
        [[ "$op" =~ ^0?[1-9]$ ]] || { clw_invalida; continue; }

        clw_banner
        case "${op#0}" in
            1) clw_admin_list_users || true ;;
            2) clw_admin_create_auto || continue ;;
            3) clw_admin_create || continue ;;
            4|5|6|7)
                clw_admin_list_users || { clw_retorne_menu || return 0; continue; }
                case "${op#0}" in
                    4) clw_admin_password || continue ;;
                    5) clw_admin_toggle || continue ;;
                    6) clw_admin_revoke || continue ;;
                    7) clw_admin_delete || continue ;;
                esac
                ;;
            8) clw_api_get "/api/admin/sessions" \
                    && printf '%s' "$CLW_HTTP_BODY" | jq -r '.[] | "  \u001b[1;34m•\(.username) \u001b[0;32mip:\(.declared_ip // "-") | \(.user_agent // "-") | \(.created_at)\u001b[m"' ;;
            9) clw_api_get "/api/admin/logs?limit=50" \
                    && printf '%s' "$CLW_HTTP_BODY" | jq -r '.[] | "  \u001b[1;34m•\(.ts) \u001b[0;32m\(.action) | user:\(.user_id // "-") | \(.detail // "")\u001b[m"' ;;
        esac
        echo
        clw_retorne_menu || return 0
    done
}

# --- Menu principal ---------------------------------------------------------

clw_main_menu() {
    local op i cat
    local -a cats
    while :; do
        # Só mostra os submenus que têm alguma função.
        cats=()
        for cat in "${CLW_CATS[@]}"; do
            for i in "${!CLW_MOD_CATS[@]}"; do
                [[ "${CLW_MOD_CATS[i]}" == "$cat" ]] && { cats+=("$cat"); break; }
            done
        done
        clw_banner
        for i in "${!cats[@]}"; do
            clw_item "$(printf '%02d' $((i + 1)))" "${CLW_CAT_TITLE[${cats[i]}]}"
        done
        ((${#cats[@]} == 0)) && clw_warn "Nada carregado (Tor lento?). Use 95 para recarregar."
        printf '\n'
        clw_item 95 "Recarregar painel" "$C_RED"
        [[ "$CLW_ROLE" == "admin" ]] && clw_item 96 "Painel admin" "$C_RED"
        clw_item 97 "Canais para ctt" "$C_RED"
        clw_item 98 "Trocar de conta" "$C_RED"
        clw_item 99 "exit do script" "$C_RED"
        clw_prompt; read -r op || exit 0

        clw_is_back "$op" && exit 0          # q ou 99: sai do script
        case "$op" in
            0|00) exit 0 ;;
            95) clw_self_update manual          # 95 = atualização manual (com feedback, re-sync)
                clw_load_profile || true; clw_load_modules || true ;;
            96) if [[ "$CLW_ROLE" == "admin" ]]; then clw_admin_menu; else clw_invalida; fi ;;
            97) clw_banner; clw_info "Telegram: https://t.me/ClowntersPainelBot"; echo; clw_retorne_menu || true ;;
            98) clw_logout; clw_auth_ensure && { clw_load_profile || true; clw_load_modules || true; } || exit 0 ;;
            *)
                if [[ "$op" =~ ^[0-9]+$ ]] && ((10#$op >= 1 && 10#$op <= ${#cats[@]})); then
                    clw_sub_menu "${cats[10#$op - 1]}"
                else
                    clw_invalida
                fi
                ;;
        esac
    done
}

main() {
    trap 'printf "\e[m"' EXIT     # não deixa o terminal colorido ao sair
    clw_bootstrap
    clw_main_menu
}

main "$@"
