#!/usr/bin/env bash
# Bootstrap für Debian/Ubuntu-Server und Arch/CachyOS. Ein fehlgeschlagener
# Schritt bricht das Script nicht ab — am Ende folgt eine Zusammenfassung.
set -uo pipefail

# per Env übersteuerbar, z. B. für Forks oder lokale Tests (file://…)
DOTFILES_RAW="${DOTFILES_RAW:-https://raw.githubusercontent.com/webenefits/dotfiles/refs/heads/main}"

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

# --- Umfang: nur aktueller User oder systemweit ---
# Pakete sind immer systemweit. Die User-Configs (Shell, nvim, micro, yazi,
# cheat, tldr) landen im User-Modus nur im eigenen $HOME, im System-Modus
# zusätzlich bei root, allen lokalen Login-Usern und in /etc/skel (für künftig
# angelegte User). Ohne Rückfrage: curl … | bash -s -- --system  (bzw. --user)
SCOPE=""
for arg in "$@"; do
    case "$arg" in
        --system) SCOPE="system" ;;
        --user)   SCOPE="user" ;;
        *) echo "Unbekannte Option: $arg (erlaubt: --user, --system)" >&2; exit 1 ;;
    esac
done
CAN_SYSTEM=0
if [ "$(id -u)" -eq 0 ] || [ -n "$SUDO" ]; then
    CAN_SYSTEM=1
fi
if [ "$SCOPE" = system ] && [ "$CAN_SYSTEM" -eq 0 ]; then
    echo "==> --system braucht root oder sudo, nutze User-Modus" >&2
    SCOPE="user"
fi
if [ -z "$SCOPE" ]; then
    SCOPE="user"
    if [ "$CAN_SYSTEM" -eq 1 ] && [ -r /dev/tty ]; then
        echo "==> Configs für wen einrichten?" >&2
        echo "    User:   nur für $(id -un) ($HOME)." >&2
        echo "    System: für root, alle lokalen Login-User und /etc/skel (neue User)." >&2
        printf "    [u] User  [s] System  (Enter = User) > " >&2
        if read -r ANSWER < /dev/tty 2>/dev/null; then
            case "$ANSWER" in
                [sS]) SCOPE="system" ;;
                [uU]|"") SCOPE="user" ;;
                *) echo "    Ungültige Eingabe, nutze Default: user" >&2 ;;
            esac
        fi
    fi
fi
echo "    → Umfang: $SCOPE"

# --- Server/Client-Modus (nur relevant für Debian/Ubuntu) ---
# apt installiert "Recommends" standardmäßig mit. Bei yazi zieht das die
# komplette Vorschau-Toolchain (ffmpeg, imagemagick, poppler-utils, 7zip)
# inkl. GTK/Mesa/VA-API-Treibern nach — auf einem Server meist unerwünschter
# Ballast, auf einem Desktop/Client aber sinnvoll (Datei-Vorschau in yazi).
APT_RECOMMENDS_FLAG=()
if [ "$DISTRO" = debian ]; then
    DEFAULT_MODE="server"
    systemctl get-default 2>/dev/null | grep -q graphical && DEFAULT_MODE="client"

    MODE="$DEFAULT_MODE"
    if [ -r /dev/tty ]; then
        echo "==> System: Server oder Client?" >&2
        echo "    Server: schlank, ohne Vorschau-Tools (kein ffmpeg/imagemagick/poppler-utils/7zip)." >&2
        echo "    Client: mit Vorschau-Tools für Bilder/Videos/PDFs/Archive in yazi." >&2
        printf "    [s] Server  [c] Client  (Enter = erkannter Default: %s) > " "$DEFAULT_MODE" >&2
        if read -r ANSWER < /dev/tty 2>/dev/null; then
            case "$ANSWER" in
                [sS]) MODE="server" ;;
                [cC]) MODE="client" ;;
                "")   MODE="$DEFAULT_MODE" ;;
                *)    echo "    Ungültige Eingabe, nutze Default: $DEFAULT_MODE" >&2 ;;
            esac
        fi
    else
        echo "==> Kein Terminal verfügbar, nutze erkannten Default: $DEFAULT_MODE" >&2
    fi
    echo "    → Modus: $MODE"
    [ "$MODE" = server ] && APT_RECOMMENDS_FLAG=(--no-install-recommends)
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
        debian) $SUDO apt-get install -y "${APT_RECOMMENDS_FLAG[@]}" "$@" ;;
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
    PKGS=(git file bat btop duf mc fd eza yazi fzf zoxide tealdeer neovim lnav chafa glow)
else
    # Debian/Ubuntu: eza/yazi/fzf/chafa/tealdeer/glow folgen unten gesondert
    # (micro folgt unten gesondert, mit Flatpak/Snap-Fallback)
    PKGS=(git gpg wget file bat btop duf mc fd-find zoxide neovim lnav)
fi
for pkg in "${PKGS[@]}"; do
    try "$pkg" pkg_install "$pkg"
done

# micro: darf praktisch nicht fehlschlagen, daher mehrstufiger Fallback.
# 1) natives Distro-Paket, 2) bereits installiertes Flatpak, 3) bereits
# installiertes Snap, 4) Flatpak selbst nachinstallieren und darüber micro
# ziehen. Bei Flatpak-Installation wird ein "micro"-Wrapper angelegt, da
# Flatpak-Apps sonst nur über "flatpak run <id>" erreichbar sind: im User-Modus
# per --user nach ~/.local/bin, im System-Modus per --system nach
# /usr/local/bin (Snap legt seinen Binary-Symlink bereits selbst unter
# /snap/bin ab).
MICRO_FLATPAK_ID="io.github.zyedidia.micro"
MICRO_SYSTEM_WRAPPER="/usr/local/bin/micro"
is_micro_flatpak_wrapper() {
    [ -f "$1" ] && grep -q "flatpak run" "$1" 2>/dev/null
}
install_micro_flatpak_wrapper() {
    local target="$1" sudo="${2:-}"
    $sudo mkdir -p "$(dirname "$target")" || return 1
    printf '#!/usr/bin/env sh\nexec flatpak run %s "$@"\n' "$MICRO_FLATPAK_ID" \
        | $sudo tee "$target" > /dev/null || return 1
    $sudo chmod 755 "$target"
}
install_micro_via_flatpak() {
    if [ "$SCOPE" = system ]; then
        $SUDO flatpak remote-add --system --if-not-exists flathub \
            https://dl.flathub.org/repo/flathub.flatpakrepo || return 1
        $SUDO flatpak install --system -y --noninteractive flathub "$MICRO_FLATPAK_ID" || return 1
        install_micro_flatpak_wrapper "$MICRO_SYSTEM_WRAPPER" "$SUDO"
    else
        flatpak remote-add --user --if-not-exists flathub \
            https://dl.flathub.org/repo/flathub.flatpakrepo || return 1
        flatpak install --user -y --noninteractive flathub "$MICRO_FLATPAK_ID" || return 1
        install_micro_flatpak_wrapper "$HOME/.local/bin/micro"
    fi
}
install_micro() {
    if pkg_install micro; then
        # systemweiten Wrapper aus einem früheren Flatpak-Fallback-Lauf entfernen --
        # /usr/local/bin steht in PATH vor /usr/bin und würde das native Paket sonst
        # überdecken. User-Wrapper in ~/.local/bin räumt user_setup pro User auf.
        if is_micro_flatpak_wrapper "$MICRO_SYSTEM_WRAPPER"; then
            $SUDO rm -f "$MICRO_SYSTEM_WRAPPER"
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
            $SUDO apt-get install -y "${APT_RECOMMENDS_FLAG[@]}" eza
        else
            $SUDO mkdir -p /etc/apt/keyrings || return 1
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
                | gpg --dearmor | $SUDO tee /etc/apt/keyrings/gierens.gpg > /dev/null || return 1
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
                | $SUDO tee /etc/apt/sources.list.d/gierens.list > /dev/null || return 1
            $SUDO chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list || return 1
            $SUDO apt-get update -y || return 1
            $SUDO apt-get install -y "${APT_RECOMMENDS_FLAG[@]}" eza
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
        $SUDO apt-get install -y "${APT_RECOMMENDS_FLAG[@]}" yazi
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
        if $SUDO apt-get install -y "${APT_RECOMMENDS_FLAG[@]}" tealdeer; then
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

    # glow: Standard-Repo prüfen, sonst offizielles Charm-APT-Repo einbinden
    install_glow() {
        if apt-cache show glow &>/dev/null; then
            $SUDO apt-get install -y "${APT_RECOMMENDS_FLAG[@]}" glow
        else
            $SUDO mkdir -p /etc/apt/keyrings || return 1
            curl -fsSL https://repo.charm.sh/apt/gpg.key \
                | gpg --dearmor | $SUDO tee /etc/apt/keyrings/charm.gpg > /dev/null || return 1
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
                | $SUDO tee /etc/apt/sources.list.d/charm.list > /dev/null || return 1
            $SUDO chmod 644 /etc/apt/keyrings/charm.gpg /etc/apt/sources.list.d/charm.list || return 1
            $SUDO apt-get update -y || return 1
            $SUDO apt-get install -y "${APT_RECOMMENDS_FLAG[@]}" glow
        fi
    }
    echo "==> glow installieren"
    try "glow" install_glow
fi

# --- User-Configs ---
# Alles ab hier betrifft nur $HOME und läuft gesammelt in user_setup: im
# User-Modus einmal für den aktuellen User, im System-Modus für jeden
# Ziel-User (siehe setup_all_users weiter unten). Sämtliche Schritte sind
# idempotent — erneute Läufe ersetzen bestehende Blöcke/Dateien, statt sie
# zu duplizieren.

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

# Einzelne Config-Dateien ohne Import-Mechanismus (micro, yazi): Whole-File-
# Vergleich gegen den zuletzt bekannten Repo-Stand ($CONFIG_DIR/<managed>).
# Ohne lokale Änderungen seit dem letzten Deploy wird automatisch aktualisiert;
# bei einem echten Konflikt (lokale Änderung UND neuer Repo-Stand) wird
# interaktiv nachgefragt.
install_managed_file() {
    local src="$1" target="$2" managed="$CONFIG_DIR/$3"
    local tmp
    mkdir -p "$(dirname "$target")" "$CONFIG_DIR" || return 1
    tmp="$(mktemp)" || return 1
    curl -fsSL "$DOTFILES_RAW/$src" -o "$tmp" || { rm -f "$tmp"; return 1; }

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
    echo "  $src: lokale Änderungen und Repo-Update gefunden ($target)" >&2
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

# micro-Syntax (Fallback-Highlighting für Dateien ohne bekannte Zuordnung):
# reine Vendor-Datei ohne lokale Anpassung, daher immer überschreiben.
install_micro_syntax() {
    mkdir -p "$HOME/.config/micro/syntax" || return 1
    curl -fsSL "$DOTFILES_RAW/micro/syntax/default.yaml" -o "$HOME/.config/micro/syntax/default.yaml" || return 1
}

# micro-Plugin editorconfig: eine .editorconfig im Projekt übersteuert die
# globalen Einrückungs-Defaults aus settings.json. Idempotent: bereits
# installiert -> nur aktualisieren. micro meldet Fehler nicht zuverlässig per
# Exit-Code, daher danach auf das Plugin-Verzeichnis prüfen.
install_micro_editorconfig() {
    local plug="$HOME/.config/micro/plug/editorconfig"
    if ! command -v micro &>/dev/null; then
        LAST_TRY_REASON="micro nicht gefunden"
        return 1
    fi
    if [ -d "$plug" ]; then
        micro -plugin update editorconfig || return 1
    else
        micro -plugin install editorconfig || return 1
    fi
    if [ ! -d "$plug" ]; then
        LAST_TRY_REASON="Plugin-Verzeichnis fehlt nach Installation"
        return 1
    fi
}

# micro-Wrapper aus einem früheren Flatpak-Fallback-Lauf (User-Modus) entfernen,
# sobald ein anderes micro im PATH liegt (natives Paket, Snap oder systemweiter
# Wrapper) -- ~/.local/bin steht in PATH vorne und würde es sonst überdecken.
cleanup_micro_wrapper() {
    local wrapper="$HOME/.local/bin/micro" dir
    is_micro_flatpak_wrapper "$wrapper" || return 0
    local IFS=:
    for dir in $PATH; do
        [ "$dir" = "$HOME/.local/bin" ] && continue
        if [ -x "$dir/micro" ]; then
            rm -f "$wrapper"
            return 0
        fi
    done
}

# yazi-Plugins: piper (glow-Vorschau für Markdown), toggle-pane (Vorschau im
# Vollbild, Taste T in keymap.toml). Idempotent: nur Plugins, die noch nicht
# in package.toml stehen, werden per "ya pkg add" hinzugefügt; für bereits
# eingetragene stellt "ya pkg install" nur fehlende Dateien wieder her.
YAZI_PLUGINS=(yazi-rs/plugins:piper yazi-rs/plugins:toggle-pane)
install_yazi_plugins() {
    local pkg_toml="$HOME/.config/yazi/package.toml" p have_existing=0
    if ! command -v ya &>/dev/null; then
        LAST_TRY_REASON="ya nicht gefunden"
        return 1
    fi
    for p in "${YAZI_PLUGINS[@]}"; do
        if grep -qF "\"$p\"" "$pkg_toml" 2>/dev/null; then
            have_existing=1
        else
            ya pkg add "$p" || return 1
        fi
    done
    if [ "$have_existing" -eq 1 ]; then
        ya pkg install || return 1
    fi
}

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

# alle User-Schritte für $HOME; mit --skel für /etc/skel (ohne tldr-Cache,
# der gehört nicht in die Vorlage für neue User)
user_setup() {
    CONFIG_DIR="$HOME/.config/dotfiles"

    cleanup_micro_wrapper

    echo "==> Shell-Config einbinden"
    try "shell-config" install_shell_config

    echo "==> nvim-Config einbinden"
    try "nvim-config" install_nvim_config

    echo "==> micro-Config einbinden"
    try "micro-config" install_managed_file micro/settings.json "$HOME/.config/micro/settings.json" micro-settings.json

    echo "==> micro-Colorschemes installieren"
    try "micro-colorschemes" install_micro_colorschemes

    echo "==> micro-Syntax (Fallback-Highlighting) installieren"
    try "micro-syntax" install_micro_syntax

    echo "==> micro-Plugin editorconfig installieren"
    try "micro-editorconfig" install_micro_editorconfig

    # yazi-Config (Markdown-Vorschau via glow), gleiche Update-Logik wie micro
    echo "==> yazi-Config einbinden"
    try "yazi-config" install_managed_file yazi/yazi.toml "$HOME/.config/yazi/yazi.toml" yazi.toml

    echo "==> yazi-Keymap einbinden"
    try "yazi-keymap" install_managed_file yazi/keymap.toml "$HOME/.config/yazi/keymap.toml" yazi-keymap.toml

    echo "==> yazi-Plugins installieren (${YAZI_PLUGINS[*]})"
    try "yazi-plugins" install_yazi_plugins

    echo "==> cheat-Wrapper & Cheatsheets installieren"
    try "cheat" install_cheat

    # tldr-Cache füllen, damit der erste Aufruf ohne Nachladen funktioniert.
    # Nur wenn tealdeer erfolgreich installiert wurde.
    if [ "${1:-}" != --skel ] && command -v tldr &>/dev/null; then
        echo "==> tldr-Cache aktualisieren"
        try "tldr-cache" tldr --update
    fi
}

# --- System-Modus: user_setup für alle Ziel-User ---
# Jeder User wird als er selbst bedient (sudo -u / runuser), damit alle
# angelegten Dateien und Verzeichnisse ihm gehören. user_setup wird dafür samt
# Abhängigkeiten in ein temporäres Script serialisiert und mit leerer Umgebung
# gestartet (sonst würden HOME/XDG_* des aufrufenden Users durchschlagen).
USER_SETUP_FUNCS=(try add_import install_shell_config install_nvim_config install_managed_file
    install_micro_colorschemes install_micro_syntax install_micro_editorconfig
    is_micro_flatpak_wrapper cleanup_micro_wrapper
    install_yazi_plugins install_cheat user_setup)
USER_SETUP_VARS=(DOTFILES_RAW MARK_START MARK_END MARK_LEGACY MICRO_COLORSCHEMES YAZI_PLUGINS CHEAT_SHEETS)
SAFE_PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

write_user_setup_script() {
    {
        echo 'set -uo pipefail'
        echo 'cd "$HOME" 2>/dev/null || cd /'
        declare -p "${USER_SETUP_VARS[@]}"
        declare -f "${USER_SETUP_FUNCS[@]}"
        echo 'FAILED=(); LAST_TRY_REASON=""'
        echo 'user_setup "$@"'
        # Fehler über stdout an den aufrufenden Prozess zurückmelden
        echo 'for f in "${FAILED[@]}"; do printf "__FAILED__:%s\n" "$f"; done'
    } > "$1" && chmod 644 "$1"
}

# lokale Login-User: root + UID_MIN..UID_MAX, mit echter Shell und
# existierendem Home. Ausgabe: <name>:<home>
list_login_users() {
    local uid_min uid_max name uid home shell
    uid_min="$(awk '$1 == "UID_MIN" { print $2 }' /etc/login.defs 2>/dev/null)"
    uid_max="$(awk '$1 == "UID_MAX" { print $2 }' /etc/login.defs 2>/dev/null)"
    : "${uid_min:=1000}" "${uid_max:=60000}"
    while IFS=: read -r name _ uid _ _ home shell; do
        [ "$uid" -eq 0 ] || { [ "$uid" -ge "$uid_min" ] && [ "$uid" -le "$uid_max" ]; } || continue
        case "$shell" in ""|*/nologin|*/false) continue ;; esac
        [ -d "$home" ] || continue
        printf '%s:%s\n' "$name" "$home"
    done < /etc/passwd
}

# startet das serialisierte user_setup als <user> mit HOME=<home>
# Args: <user> <home> <script> [env-Zuweisungen...] [-- user_setup-Args...]
run_user_setup() {
    local user="$1" home="$2" script="$3"; shift 3
    local -a envs=()
    while [ $# -gt 0 ] && [ "$1" != -- ]; do envs+=("$1"); shift; done
    [ "${1:-}" = -- ] && shift
    local -a cmd=(env -i HOME="$home" USER="$user" LOGNAME="$user" PATH="$SAFE_PATH"
        TERM="${TERM:-dumb}" LANG="${LANG:-C.UTF-8}" "${envs[@]}" bash "$script" "$@")
    if [ "$user" = "$(id -un)" ]; then
        "${cmd[@]}"
    elif [ "$(id -u)" -eq 0 ]; then
        runuser -u "$user" -- "${cmd[@]}"
    else
        sudo -u "$user" -- "${cmd[@]}"
    fi
}

# user_setup für einen Ziel-User, Fehler landen mit Präfix in FAILED.
# Args: <label> + Args von run_user_setup
collect_user_setup() {
    local label="$1" user="$2" home="$3" line n i
    # aktueller User im eigenen HOME: direkt aufrufen, eigene Umgebung behalten
    if [ "$user" = "$(id -un)" ] && [ "$home" = "$HOME" ]; then
        n=${#FAILED[@]}
        user_setup
        for ((i = n; i < ${#FAILED[@]}; i++)); do FAILED[i]="$label: ${FAILED[i]}"; done
        return
    fi
    shift 3
    while IFS= read -r line; do
        case "$line" in
            __FAILED__:*) FAILED+=("$label: ${line#__FAILED__:}") ;;
            *) printf '%s\n' "$line" ;;
        esac
    done < <(run_user_setup "$user" "$home" "$@" < /dev/null)
}

setup_all_users() {
    local script user home tmp_xdg
    script="$(mktemp)" || { FAILED+=("user-setup (mktemp)"); return; }
    write_user_setup_script "$script" || { FAILED+=("user-setup (Script)"); rm -f "$script"; return; }

    while IFS=: read -r user home; do
        echo
        echo "######## User: $user ($home)"
        collect_user_setup "$user" "$user" "$home" "$script"
    done < <(list_login_users)

    # /etc/skel: Vorlage, die useradd in neue Homes kopiert. Cache/State von
    # ya pkg (Git-Checkouts) in ein Wegwerf-Verzeichnis umleiten, damit sie
    # nicht in jedes neue Home kopiert werden.
    echo
    echo "######## Vorlage für neue User: /etc/skel"
    tmp_xdg="$(mktemp -d)" && chmod 755 "$tmp_xdg"
    collect_user_setup "skel" root /etc/skel "$script" \
        XDG_CACHE_HOME="$tmp_xdg/cache" XDG_STATE_HOME="$tmp_xdg/state" -- --skel
    $SUDO rm -rf "$tmp_xdg" "$script"
}

if [ "$SCOPE" = system ]; then
    setup_all_users
else
    user_setup
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
if [ "$SCOPE" = system ]; then
    echo "Andere User erhalten die Änderungen mit ihrer nächsten Shell."
fi

if [ ${#FAILED[@]} -ne 0 ]; then
    exit 1
fi
