#!/usr/bin/env bash
# Bootstrap für Debian/Ubuntu-Server. Ein fehlgeschlagener Schritt bricht das
# Script nicht ab — am Ende folgt eine Zusammenfassung der Fehler.
set -uo pipefail

DOTFILES_RAW="https://raw.githubusercontent.com/webenefits/dotfiles/refs/heads/main"
CONFIG_DIR="$HOME/.config/dotfiles"

if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

FAILED=()

# führt einen Schritt aus, sammelt Fehler statt abzubrechen
try() {
    local label="$1"; shift
    if "$@"; then
        echo "  ✓ $label"
    else
        echo "  ✗ $label fehlgeschlagen" >&2
        FAILED+=("$label")
    fi
}

echo "==> Paketquellen aktualisieren"
$SUDO apt-get update -y || echo "  Warnung: apt-get update fehlgeschlagen" >&2

echo "==> APT-Pakete installieren"
APT_PKGS=(gpg wget unzip file bat btop duf mc fd-find chafa zoxide tealdeer neovim)
for pkg in "${APT_PKGS[@]}"; do
    try "$pkg" $SUDO apt-get install -y "$pkg"
done

# eza: Standard-Repo prüfen, sonst eigenes APT-Repo einbinden
install_eza() {
    if apt-cache show eza &>/dev/null; then
        $SUDO apt-get install -y eza
    else
        $SUDO mkdir -p /etc/apt/keyrings || return 1
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
            | gpg --dearmor | $SUDO tee /etc/apt/keyrings/gierens.gpg > /dev/null || return 1
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
            | $SUDO tee /etc/apt/sources.list.d/gierens.list > /dev/null || return 1
        $SUDO chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list || return 1
        $SUDO apt-get update -y || return 1
        $SUDO apt-get install -y eza
    fi
}
echo "==> eza installieren"
try "eza" install_eza

# yazi: kein Debian-Paket, Binary-Release von GitHub
install_yazi() {
    curl -fL -o /tmp/yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip || return 1
    unzip -o /tmp/yazi.zip -d /tmp/yazi || return 1
    $SUDO mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /tmp/yazi/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/ || return 1
    $SUDO chmod +x /usr/local/bin/yazi /usr/local/bin/ya || return 1
    rm -rf /tmp/yazi /tmp/yazi.zip
}
echo "==> yazi installieren"
try "yazi" install_yazi

# fzf: apt-Version zu alt für yazi (braucht >= 0.53), Binary-Release von GitHub
install_fzf() {
    local ver
    ver="$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest | grep -oP '"tag_name": "v\K[^"]+')" || return 1
    [ -n "$ver" ] || return 1
    curl -fL -o /tmp/fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${ver}/fzf-${ver}-linux_amd64.tar.gz" || return 1
    tar -xzf /tmp/fzf.tar.gz -C /tmp || return 1
    $SUDO mv /tmp/fzf /usr/local/bin/ || return 1
    $SUDO chmod +x /usr/local/bin/fzf || return 1
    rm -f /tmp/fzf.tar.gz
}
echo "==> fzf installieren"
try "fzf" install_fzf

# Shell-Configs herunterladen und per source einbinden (idempotent).
MARK_START="# --- dotfiles ---"
MARK_END="# --- dotfiles: end ---"

# fügt eine Import-Zeile zwischen den Markern ein, ersetzt vorhandenen Block
add_import() {
    local rc="$1" line="$2" tmp
    mkdir -p "$(dirname "$rc")" || return 1
    touch "$rc" || return 1
    tmp="$(mktemp)" || return 1
    awk -v s="$MARK_START" -v e="$MARK_END" '
        $0 == s { inblock = 1; next }
        $0 == e { inblock = 0; next }
        !inblock { print }
    ' "$rc" > "$tmp" || { rm -f "$tmp"; return 1; }
    # trailing Leerzeilen entfernen, dann Block anhängen
    sed -e :a -e '/^\n*$/{$d;N;ba}' "$tmp" > "$rc"
    rm -f "$tmp"
    printf '\n%s\n%s\n%s\n' "$MARK_START" "$line" "$MARK_END" >> "$rc"
}

install_shell_config() {
    mkdir -p "$CONFIG_DIR" || return 1
    curl -fsSL "$DOTFILES_RAW/shell/bash/aliases.sh" -o "$CONFIG_DIR/aliases.sh" || return 1
    curl -fsSL "$DOTFILES_RAW/shell/fish/config.fish" -o "$CONFIG_DIR/config.fish" || return 1

    add_import "$HOME/.bashrc" \
        '[ -f "$HOME/.config/dotfiles/aliases.sh" ] && . "$HOME/.config/dotfiles/aliases.sh"' || return 1
    if [ -f "$HOME/.zshrc" ]; then
        add_import "$HOME/.zshrc" \
            '[ -f "$HOME/.config/dotfiles/aliases.sh" ] && . "$HOME/.config/dotfiles/aliases.sh"' || return 1
    fi
    # fish nur wenn installiert oder config bereits vorhanden
    if command -v fish &>/dev/null || [ -f "$HOME/.config/fish/config.fish" ]; then
        add_import "$HOME/.config/fish/config.fish" \
            'test -f "$HOME/.config/dotfiles/config.fish"; and source "$HOME/.config/dotfiles/config.fish"' || return 1
    fi
}
echo "==> Shell-Config einbinden"
try "shell-config" install_shell_config

echo
if [ ${#FAILED[@]} -eq 0 ]; then
    echo "Fertig. Alles installiert. Neue Shell starten oder RC-Datei neu sourcen."
else
    echo "Fertig, aber Folgendes ist fehlgeschlagen:"
    printf '  - %s\n' "${FAILED[@]}"
    echo "Bitte manuell prüfen."
    exit 1
fi
