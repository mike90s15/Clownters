#!/usr/bin/env bash
# Instalador do Clownters: instala dependências, cria o comando `clownters`
# (quando possível, sem sudo) e já abre o painel.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/deps.sh"

clw_banner
clw_info "Instalando o Clownters..."

clw_deps_ensure || exit 1
chmod +x "$SCRIPT_DIR/clownters.sh"

# Cria o atalho `clownters` num diretório do PATH gravável (sem sudo).
for BIN_DIR in "${PREFIX:+$PREFIX/bin}" "$HOME/.local/bin" "$HOME/bin"; do
    [[ -n "$BIN_DIR" ]] || continue
    mkdir -p "$BIN_DIR" 2>/dev/null || continue
    if [[ -w "$BIN_DIR" ]]; then
        ln -sf "$SCRIPT_DIR/clownters.sh" "$BIN_DIR/clownters"
        clw_ok "Comando 'clownters' instalado em $BIN_DIR"
        break
    fi
done

clw_ok "Abrindo o painel..."
exec bash "$SCRIPT_DIR/clownters.sh"
