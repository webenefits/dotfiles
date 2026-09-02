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

# führt einen Schritt aus, sammelt Fehler statt abzubrechen.
# Eine aufgerufene Funktion kann vor "return 1" LAST_TRY_REASON setzen, um der
# Zusammenfassung am Ende einen kurzen Fehlgrund in Klammern mitzugeben.
LAST_TRY_REASON=""
try() {
    local label="$1"; shift
    LAST_TRY_REASON=""
    if "$@"; then
        echo "  ✓ $label"
    else
        if [ -n "$LAST_TRY_REASON" ]; then
            echo "  ✗ $label fehlgeschlagen ($LAST_TRY_REASON)" >&2
            FAILED+=("$label ($LAST_TRY_REASON)")
        else
            echo "  ✗ $label fehlgeschlagen" >&2
            FAILED+=("$label")
        fi
    fi
}

# installiert ein Paket über den erkannten Paketmanager
pkg_install() {
    case "$DISTRO" in
        arch)   $SUDO pacman -S --needed --noconfirm "$@" ;;
        debian) $SUDO apt-get install -y "$@" ;;
    esac
    local status=$?
    [ "$status" -ne 0 ] && LAST_TRY_REASON="Paketmanager-Fehler (Exit $status)"
    return "$status"
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
    # (micro folgt unten gesondert, mit Flatpak/Snap-Fallback)
    PKGS=(file bat btop duf mc fd eza yazi fzf zoxide tealdeer neovim lnav chafa)
else
    # Debian/Ubuntu: eza/yazi/fzf/chafa/tealdeer folgen unten gesondert
    # (micro folgt unten gesondert, mit Flatpak/Snap-Fallback)
    PKGS=(gpg wget file bat btop duf mc fd-find zoxide neovim lnav)
fi
for pkg in "${PKGS[@]}"; do
    try "$pkg" pkg_install "$pkg"
done

# micro: darf praktisch nicht fehlschlagen, daher mehrstufiger Fallback.
# 1) natives Distro-Paket, 2) bereits installiertes Flatpak, 3) bereits
# installiertes Snap, 4) Flatpak selbst nachinstallieren und darüber micro
# ziehen. Bei Flatpak-Installation wird ein "micro"-Wrapper nach
# ~/.local/bin gelegt, da Flatpak-Apps sonst nur über "flatpak run <id>"
# erreichbar sind (Snap legt seinen Binary-Symlink bereits selbst unter
# /snap/bin ab).
MICRO_FLATPAK_ID="io.github.zyedidia.micro"
install_micro_flatpak_wrapper() {
    mkdir -p "$HOME/.local/bin" || return 1
    printf '#!/usr/bin/env sh\nexec flatpak run %s "$@"\n' "$MICRO_FLATPAK_ID" \
        > "$HOME/.local/bin/micro" || return 1
    chmod +x "$HOME/.local/bin/micro"
}
install_micro_via_flatpak() {
    flatpak remote-add --user --if-not-exists flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo || return 1
    flatpak install --user -y --noninteractive flathub "$MICRO_FLATPAK_ID" || return 1
    install_micro_flatpak_wrapper
}
install_micro() {
    if pkg_install micro; then
        # Wrapper aus einem früheren Flatpak-Fallback-Lauf entfernen -- ~/.local/bin
        # steht in PATH vor /usr/bin und würde das native Paket sonst weiter
        # überdecken (gleiches Muster wie beim yazi-Fallback weiter unten).
        if [ -f "$HOME/.local/bin/micro" ] && grep -q "flatpak run" "$HOME/.local/bin/micro" 2>/dev/null; then
            rm -f "$HOME/.local/bin/micro"
        fi
        return 0
    fi

    # jede verfügbare Fallback-Stufe wird versucht, keine bricht die Kette ab
    if command -v flatpak &>/dev/null && install_micro_via_flatpak; then
        return 0
    fi
    if command -v snap &>/dev/null && $SUDO snap install micro --classic; then
        return 0
    fi
    # keins von beiden vorhanden (oder beide fehlgeschlagen): Flatpak nachinstallieren
    if ! command -v flatpak &>/dev/null && pkg_install flatpak && install_micro_via_flatpak; then
        return 0
    fi

    LAST_TRY_REASON="Paket, Flatpak und Snap fehlgeschlagen"
    return 1
}
echo "==> micro installieren (mit Flatpak/Snap-Fallback)"
try "micro" install_micro

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

    # yazi: kein Debian-Paket, offizielles APT-Repo einbinden (yazi-rs/builds)
    install_yazi() {
        # Relikt der alten Installationsart entfernen: /usr/local/bin steht in
        # PATH vor /usr/bin und würde sonst das apt-Paket weiter überdecken.
        $SUDO rm -f /usr/local/bin/yazi /usr/local/bin/ya
        curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg \
            | $SUDO tee /usr/share/keyrings/yazi-keyring.gpg > /dev/null || return 1
        echo "deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main" \
            | $SUDO tee /etc/apt/sources.list.d/yazi.list > /dev/null || return 1
        $SUDO apt-get update -y || return 1
        $SUDO apt-get install -y yazi
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

    # tealdeer: apt-Version < 1.8.0 laedt kaputtes tldr-Archiv (Issue #459).
    # apt bevorzugen, wenn aktuell genug; sonst statisches Release-Binary von GitHub.
    install_tealdeer() {
        local need=1.8.0 ver
        if $SUDO apt-get install -y tealdeer; then
            ver="$(tldr --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)"
            if [ -n "$ver" ] && dpkg --compare-versions "$ver" ge "$need"; then
                return 0
            fi
            echo "  apt-tealdeer ${ver:-unbekannt} < ${need}, nutze GitHub-Binary" >&2
        fi
        $SUDO curl -fL -o /usr/local/bin/tldr \
            https://github.com/tealdeer-rs/tealdeer/releases/latest/download/tealdeer-linux-x86_64-musl || return 1
        $SUDO chmod +x /usr/local/bin/tldr || return 1
    }
    echo "==> tealdeer installieren"
    try "tealdeer" install_tealdeer
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

# micro-Config: Whole-File-Vergleich gegen den zuletzt bekannten Repo-Stand
# ($CONFIG_DIR/micro-settings.json). Ohne lokale Änderungen seit dem letzten
# Deploy wird automatisch aktualisiert; bei einem echten Konflikt (lokale
# Änderung UND neuer Repo-Stand) wird interaktiv nachgefragt.
install_micro_config() {
    local target="$HOME/.config/micro/settings.json"
    local managed="$CONFIG_DIR/micro-settings.json"
    local tmp
    mkdir -p "$HOME/.config/micro" "$CONFIG_DIR" || return 1
    tmp="$(mktemp)" || return 1
    curl -fsSL "$DOTFILES_RAW/micro/settings.json" -o "$tmp" || { rm -f "$tmp"; return 1; }

    # keine lokale Config oder lokal bereits identisch zum neuen Stand
    if [ ! -f "$target" ] || cmp -s "$target" "$tmp"; then
        cp "$tmp" "$target" || { rm -f "$tmp"; return 1; }
        mv "$tmp" "$managed"
        return 0
    fi

    # Repo-Stand seit dem letzten Lauf unverändert -- lokale Änderungen bleiben unangetastet
    if [ -f "$managed" ] && cmp -s "$tmp" "$managed"; then
        rm -f "$tmp"
        return 0
    fi

    # keine lokalen Änderungen seit dem letzten Deploy -- Update automatisch übernehmen
    if [ -f "$managed" ] && cmp -s "$target" "$managed"; then
        cp "$tmp" "$target" || { rm -f "$tmp"; return 1; }
        mv "$tmp" "$managed"
        return 0
    fi

    # Konflikt: lokale Änderungen vorhanden UND neuer Repo-Stand verfügbar
    echo "  micro/settings.json: lokale Änderungen und Repo-Update gefunden" >&2
    local choice
    while true; do
        echo "  [r] Repo-Version übernehmen  [l] lokale Version behalten  [d] Diff anzeigen" >&2
        if ! read -r choice < /dev/tty 2>/dev/null; then
            echo "  kein Terminal verfügbar, behalte lokale Version" >&2
            choice=l
        fi
        case "$choice" in
            [rR]) cp "$tmp" "$target" || { rm -f "$tmp"; return 1; }; break ;;
            [lL]) break ;;
            [dD]) diff -u "$target" "$tmp" >&2 || true ;;
            *) echo "  bitte r/l/d wählen" >&2 ;;
        esac
    done
    mv "$tmp" "$managed"
}
echo "==> micro-Config einbinden"
try "micro-config" install_micro_config

# micro-Colorschemes: reine Vendor-Dateien ohne lokale Anpassung, daher immer
# überschreiben (kein Merge nötig). Verzeichnis wird nicht komplett neu aufgebaut,
# da der Nutzer dort eigene, nicht von uns verwaltete Themes ablegen könnte.
MICRO_COLORSCHEMES=(catppuccin-latte catppuccin-frappe catppuccin-macchiato catppuccin-mocha)
install_micro_colorschemes() {
    mkdir -p "$HOME/.config/micro/colorschemes" || return 1
    local c
    for c in "${MICRO_COLORSCHEMES[@]}"; do
        curl -fsSL "$DOTFILES_RAW/micro/colorschemes/$c.micro" -o "$HOME/.config/micro/colorschemes/$c.micro" || return 1
    done
}
echo "==> micro-Colorschemes installieren"
try "micro-colorschemes" install_micro_colorschemes

# micro-Syntax (Fallback-Highlighting für Dateien ohne bekannte Zuordnung):
# reine Vendor-Datei ohne lokale Anpassung, daher immer überschreiben.
install_micro_syntax() {
    mkdir -p "$HOME/.config/micro/syntax" || return 1
    curl -fsSL "$DOTFILES_RAW/micro/syntax/default.yaml" -o "$HOME/.config/micro/syntax/default.yaml" || return 1
}
echo "==> micro-Syntax (Fallback-Highlighting) installieren"
try "micro-syntax" install_micro_syntax

# cheat-Wrapper (~/.local/bin) und Cheatsheets ($XDG_DATA_HOME/cheatsheets) installieren.
# Neue Sheets hier ergänzen (HTTP bietet kein Verzeichnislisting).
CHEAT_SHEETS=(git regex docker ddev composer typo3 shopware oxid vim lazyvim nano yazi screen bitwarden)
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
    echo "Fertig. Alles installiert."
else
    echo "Fertig, aber Folgendes ist fehlgeschlagen:"
    printf '  - %s\n' "${FAILED[@]}"
    echo "Bitte manuell prüfen."
fi

echo "Neue Shell starten oder die aktive Config neu sourcen:"
echo "  bash:  source ~/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
    echo "  zsh:   source ~/.zshrc"
fi
if command -v fish &>/dev/null || [ -f "$HOME/.config/fish/config.fish" ]; then
    echo "  fish:  source ~/.config/fish/config.fish"
fi

if [ ${#FAILED[@]} -ne 0 ]; then
    exit 1
fi
