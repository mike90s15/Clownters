#!/usr/bin/env bash
# Checagem e instalação automática de dependências.
# Suporta Termux (pkg) e as principais distros (apt/dnf/pacman/zypper).

CLW_REQUIRED=(curl jq tor)

# Detecta o gerenciador de pacotes disponível e ecoa o comando de install.
clw_pkg_manager() {
    if [[ -n "${PREFIX:-}" && -d "${PREFIX}" && $(command -v pkg) ]]; then
        echo "pkg install -y"          # Termux
    elif command -v apt-get >/dev/null 2>&1; then
        echo "sudo apt-get install -y"
    elif command -v dnf >/dev/null 2>&1; then
        echo "sudo dnf install -y"
    elif command -v pacman >/dev/null 2>&1; then
        echo "sudo pacman -S --noconfirm"
    elif command -v zypper >/dev/null 2>&1; then
        echo "sudo zypper install -y"
    else
        echo ""
    fi
}

# Garante que curl, jq e tor estão instalados. Oferece instalar o que faltar.
clw_deps_ensure() {
    local missing=() bin
    for bin in "${CLW_REQUIRED[@]}"; do
        command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
    done
    [[ ${#missing[@]} -eq 0 ]] && return 0

    clw_warn "Dependências faltando: ${missing[*]}"
    local installer
    installer=$(clw_pkg_manager)
    if [[ -z "$installer" ]]; then
        clw_err "Não reconheci seu gerenciador de pacotes."
        clw_err "Instale manualmente: ${missing[*]}"
        return 1
    fi

    clw_info "Instalar com: $installer ${missing[*]}"
    printf ' %bInstalar agora? [S/n] %b' "$C_BLU" "$C_RESET"
    read -r ans
    case "${ans,,}" in
        n|nao|não) clw_err "Sem as dependências não dá pra continuar."; return 1 ;;
    esac

    # shellcheck disable=SC2086
    $installer "${missing[@]}" || {
        clw_err "Falha ao instalar. Tente manualmente: $installer ${missing[*]}"
        return 1
    }
    clw_ok "Dependências instaladas."
}
