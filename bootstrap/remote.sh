#!/usr/bin/env bash
# Bootstrap für Debian/Ubuntu-Server und Arch/CachyOS. Ein fehlgeschlagener
# Schritt bricht das Script nicht ab — am Ende folgt eine Zusammenfassung.
set -uo pipefail

DOTFILES_RAW="https://raw.githubusercontent.com/webenefits/dotfiles/refs/heads/main"
CONFIG_DIR="$HOME/.config/dotfiles"

# chafa: apt-Versionen (Debian 12: 1.12, Ubuntu 24.04: 1.14) kennen die von
# yazi genutzte Option --probe nicht (erst ab 1.16). Statisches Binary pinnen.
# (nur Debian/Ubuntu — Arch liefert eine aktuelle Version via pacman)
CHAFA_VERSION="1.18.2-1"

if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

# Paketmanager erkennen
if command -v pacman &>/dev/null; then
    DISTRO="arch"
elif command -v apt-get &>/dev/null; then
    DISTRO="debian"
else
    echo "Nicht unterstützte Distribution (weder pacman noch apt-get gefunden)." >&2
    exit 1
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

# installiert ein Paket über den erkannten Paketmanager
pkg_install() {
    case "$DISTRO" in
        arch)   $SUDO pacman -S --needed --noconfirm "$@" ;;
        debian) $SUDO apt-get install -y "$@" ;;
    esac
}

echo "==> Paketquellen aktualisieren ($DISTRO)"
case "$DISTRO" in
    # nur DB-Refresh; kein -u, um ungefragtes Full-Upgrade zu vermeiden
    arch)   $SUDO pacman -Sy --noconfirm || echo "  Warnung: pacman -Sy fehlgeschlagen" >&2 ;;
    debian) $SUDO apt-get update -y      || echo "  Warnung: apt-get update fehlgeschlagen" >&2 ;;
esac

echo "==> Pakete installieren"
if [ "$DISTRO" = arch ]; then
    # Arch: alles inkl. eza/yazi/fzf/chafa aus den offiziellen Repos
    PKGS=(file bat btop duf mc fd eza yazi fzf zoxide tealdeer neovim lnav chafa)
else
    # Debian/Ubuntu: eza/yazi/fzf/chafa folgen unten gesondert
    PKGS=(gpg wget unzip file bat btop duf mc fd-find zoxide tealdeer neovim lnav)
fi
for pkg in "${PKGS[@]}"; do
    try "$pkg" pkg_install "$pkg"
done

# --- Debian/Ubuntu: Tools ohne (aktuelles) apt-Paket gesondert installieren ---
if [ "$DISTRO" = debian ]; then
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

    # chafa: statisches Binary (apt-Version zu alt für yazi, siehe CHAFA_VERSION oben)
    install_chafa() {
        local dir="chafa-${CHAFA_VERSION}-x86_64-linux-gnu"
        curl -fL -o /tmp/chafa.tar.gz "https://hpjansson.org/chafa/releases/static/${dir}.tar.gz" || return 1
        tar -xzf /tmp/chafa.tar.gz -C /tmp || return 1
        $SUDO mv "/tmp/${dir}/chafa" /usr/local/bin/chafa || return 1
        $SUDO chmod +x /usr/local/bin/chafa || return 1
        rm -rf "/tmp/${dir}" /tmp/chafa.tar.gz
    }
    echo "==> chafa installieren"
    try "chafa" install_chafa
fi

# Shell-Configs herunterladen und per source einbinden (idempotent).
MARK_START="# --- dotfiles ---"
MARK_END="# --- dotfiles: end ---"
# Legacy-Start-Marker aus der Zeit vor der Config-Auslagerung (Inline-Block).
# Wird mitentfernt, damit alte Alias-/Funktionsdefinitionen nicht doppelt bleiben.
MARK_LEGACY="# --- dotfiles: tool aliases ---"

# fügt eine Import-Zeile zwischen den Markern ein, ersetzt vorhandenen Block
# (Marker optional übersteuerbar, z. B. Lua-Kommentare für nvim)
add_import() {
    local rc="$1" line="$2" start="${3:-$MARK_START}" end="${4:-$MARK_END}" tmp
    mkdir -p "$(dirname "$rc")" || return 1
    touch "$rc" || return 1
    tmp="$(mktemp)" || return 1
    awk -v s="$start" -v s2="$MARK_LEGACY" -v e="$end" '
        $0 == s || $0 == s2 { inblock = 1; next }
        $0 == e { inblock = 0; next }
        !inblock { print }
    ' "$rc" > "$tmp" || { rm -f "$tmp"; return 1; }
    # trailing Leerzeilen entfernen, dann Block anhängen
    sed -e :a -e '/^\n*$/{$d;N;ba}' "$tmp" > "$rc"
    rm -f "$tmp"
    printf '\n%s\n%s\n%s\n' "$start" "$line" "$end" >> "$rc"
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

# nvim-Config herunterladen und per dofile einbinden (analog zu den Shell-Configs)
install_nvim_config() {
    # init.vim und init.lua schließen sich in nvim gegenseitig aus —
    # eine vorhandene init.vim nicht durch Anlegen einer init.lua brechen
    if [ -f "$HOME/.config/nvim/init.vim" ]; then
        echo "  init.vim vorhanden, nvim-Config übersprungen" >&2
        return 1
    fi
    mkdir -p "$CONFIG_DIR" || return 1
    curl -fsSL "$DOTFILES_RAW/nvim/init.lua" -o "$CONFIG_DIR/nvim.lua" || return 1
    add_import "$HOME/.config/nvim/init.lua" \
        'pcall(dofile, os.getenv("HOME") .. "/.config/dotfiles/nvim.lua")' \
        "-- --- dotfiles ---" "-- --- dotfiles: end ---"
}
echo "==> nvim-Config einbinden"
try "nvim-config" install_nvim_config

# cheat-Wrapper (~/.local/bin) und Cheatsheets ($XDG_DATA_HOME/cheatsheets) installieren.
# Neue Sheets hier ergänzen (HTTP bietet kein Verzeichnislisting).
CHEAT_SHEETS=(git regex docker ddev composer typo3 shopware oxid vim lazyvim nano yazi screen)
install_cheat() {
    local sheet_dir="${XDG_DATA_HOME:-$HOME/.local/share}/cheatsheets"
    # Beim Update den ganzen Ordner neu aufbauen, damit entfernte Sheets verschwinden.
    rm -rf "$sheet_dir" || return 1
    # Alt-Verzeichnis der Pre-XDG-Variante entfernen (Migration).
    if [ -d "$HOME/.cheatsheets" ]; then
        echo "    Cheatsheets von ~/.cheatsheets nach $sheet_dir verschoben"
        rm -rf "$HOME/.cheatsheets" || return 1
    fi
    mkdir -p "$HOME/.local/bin" "$sheet_dir" || return 1
    curl -fsSL "$DOTFILES_RAW/cheatsheets/cheat" -o "$HOME/.local/bin/cheat" || return 1
    chmod +x "$HOME/.local/bin/cheat" || return 1
    local s
    for s in "${CHEAT_SHEETS[@]}"; do
        curl -fsSL "$DOTFILES_RAW/cheatsheets/sheets/$s.md" -o "$sheet_dir/$s.md" || return 1
    done
}
echo "==> cheat-Wrapper & Cheatsheets installieren"
try "cheat" install_cheat

# tldr-Cache füllen, damit der erste Aufruf ohne Nachladen funktioniert.
# Nur wenn tealdeer erfolgreich installiert wurde.
if command -v tldr &>/dev/null; then
    echo "==> tldr-Cache aktualisieren"
    try "tldr-cache" tldr --update
fi

echo
if [ ${#FAILED[@]} -eq 0 ]; then
    echo "Fertig. Alles installiert. Neue Shell starten oder die aktive Config neu sourcen:"
    echo "  bash:  source ~/.bashrc"
    if [ -f "$HOME/.zshrc" ]; then
        echo "  zsh:   source ~/.zshrc"
    fi
    if command -v fish &>/dev/null || [ -f "$HOME/.config/fish/config.fish" ]; then
        echo "  fish:  source ~/.config/fish/config.fish"
    fi
else
    echo "Fertig, aber Folgendes ist fehlgeschlagen:"
    printf '  - %s\n' "${FAILED[@]}"
    echo "Bitte manuell prüfen."
    exit 1
fi
