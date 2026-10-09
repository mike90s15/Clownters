#!/usr/bin/env bash
# Identidade visual do Clownters: arte do "Arquivo", cores verde/ciano/amarelo.

# Cores
C_RESET=$'\e[m'
C_YEL=$'\e[1;33m'
C_GRN=$'\e[1;32m'
C_CYA=$'\e[1;36m'
C_MAG=$'\e[1;35m'
C_RED=$'\e[1;31m'
C_BLU=$'\e[1;34m'

clw_banner() {
    printf '\ec'  # limpa a tela
    local art=(
"${C_YEL}.--------.____________"
"|| ° ° ° °     .2021.|| ${C_GRN}®${C_YEL}"
"||                    | ${C_GRN}©${C_YEL}"
"||\\     ______________________"
"|| \\   // ° ° ° ° ° ° ° ° ° °/"
"||\\ \\ //                    /"
"|| \\ //                    /"
"||\\ //                    /"
"|| //                    /"
"||//                    /"
"||/                    /"
"|/____________________/"
"${C_RED}Arquivo ${CLW_NAME}${C_RESET}"
"${C_MAG}<<< PAINEL ${CLW_NAME^^} $(date +%Y/%m/%d) >>>"
"${C_GRN}=======================================${C_RESET}"
    )
    local line
    for line in "${art[@]}"; do printf ' %b\n' "$line"; done
}

# Item de menu no padrão original: [NN] Texto  (+_+)
# $1=número  $2=texto  $3=cor do número (padrão ciano; vermelho nas opções especiais)
# Pad manual por nº de caracteres (não bytes), p/ alinhar rótulos com acento.
clw_item() {
    local nc=${3:-$C_CYA} pad=$(( 21 - ${#2} ))
    ((pad < 0)) && pad=0
    printf ' \e[1;32m[\e[m%s%s\e[1;32m]\e[m \e[1;36m%s%*s\e[1;32m]\e[1;32m       (+_+)\e[m\n' \
        "$nc" "$1" "$2" "$pad" ""
}

clw_prompt() { printf '\n %b===> %b' "$C_BLU" "$C_CYA"; }

# Renderiza o .data de uma resposta no estilo original: rótulo azul,
# valor verde, dois-pontos alinhados. $1 = corpo JSON da resposta.
clw_render_data() {
    local -a pairs
    local line k v maxlen=0
    mapfile -t pairs < <(printf '%s' "$1" | jq -r '.data | to_entries[] | "\(.key)\t\(.value // "")"')
    for line in "${pairs[@]}"; do k=${line%%$'\t'*}; ((${#k} > maxlen)) && maxlen=${#k}; done
    for line in "${pairs[@]}"; do
        k=${line%%$'\t'*}; v=${line#*$'\t'}
        printf '  \e[1;34m•%s%*s : \e[0;32m%s\e[m\n' "$k" "$(( maxlen - ${#k} ))" "" "$v"
    done
}

# Emite uma mensagem já QUEBRADA pra telas estreitas (Termux): parte só em
# espaços (nunca corta palavra/URL no meio) numa largura segura. Override pela
# env CLW_WIDTH (padrão 46). Preserva quebras que já existam no texto.
_clw_emit() {
    local color=$1 text=$2 to=${3:-} line w=${CLW_WIDTH:-46}
    local -a out=()
    if command -v fold >/dev/null 2>&1; then
        while IFS= read -r line || [[ -n "$line" ]]; do out+=("$line"); done \
            < <(printf '%s\n' "$text" | fold -s -w "$w")
    else
        out=("$text")
    fi
    for line in "${out[@]}"; do
        if [[ "$to" == err ]]; then printf ' %b%b%b\n' "$color" "$line" "$C_RESET" >&2
        else                        printf ' %b%b%b\n' "$color" "$line" "$C_RESET"; fi
    done
}
clw_info()  { _clw_emit "$C_CYA" "$1"; }
clw_ok()    { _clw_emit "$C_GRN" "$1"; }
clw_warn()  { _clw_emit "$C_YEL" "$1"; }
clw_err()   { _clw_emit "$C_RED" "$1" err; }

# "q" (maiúsculo ou minúsculo) e 99 voltam/saem em qualquer tela, como no painel antigo.
clw_is_back() { [[ "${1,,}" == q || "$1" == 99 ]]; }

clw_invalida()    { printf ' \e[1;33mOpção invalida'; sleep 1; }
clw_digite_algo() { printf '\e[1;33m Digite algo!'; sleep 1; }

# Menu pós-função do painel antigo (_retorneMenu).
# Retorna 0 = continuar na função, 1 = voltar ao menu principal.
clw_retorne_menu() {
    local op
    printf ' \e[1;32m'; printf '=%.0s' {0..38}
    printf '\n\n\e[1;34m Continue ou retorne ao menu principal?\n\n'
    printf ' \e[1;32m[\e[m\e[1;36m01\e[1;32m]\e[m \e[1;36mContinue            \e[1;32m]\e[m\e[1;32m       (+_+)\n'
    printf ' \e[1;32m[\e[m\e[1;36m02\e[1;32m]\e[m \e[1;36mRetorna para o menu \e[1;32m]\e[m\e[1;32m       (+_+)\n'
    printf ' \e[1;32m[\e[m\e[1;36m00\e[1;32m]\e[m \e[1;36mSair do menu        \e[1;32m]\e[m\e[1;32m       (+_+)\n\n'
    printf ' \e[1;34m===> \e[1;36m'
    read -r op || exit 0
    case "$op" in
        0|00|exit) exit 0 ;;
        2|02) return 1 ;;
    esac
    clw_is_back "$op" && return 1
    return 0
}

# Spinner simples enquanto um comando roda em background (PID em $1).
clw_spin() {
    local pid=$1 i=0 frames='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        printf '\r %bconsultando %s%b' "$C_YEL" "${frames:i++%4:1}" "$C_RESET"
        sleep 0.1
    done
    printf '\r\033[K'
}

# Abre uma URL no navegador, best-effort (Termux ou Linux). Nunca trava nem
# polui a tela: se não houver com o que abrir, segue em silêncio.
clw_abrir_link() {
    local url=$1 abridor
    for abridor in termux-open-url xdg-open; do
        if command -v "$abridor" >/dev/null 2>&1; then
            "$abridor" "$url" >/dev/null 2>&1 &
            return 0
        fi
    done
    return 0
}
