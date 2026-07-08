#!/usr/bin/env bash
set -euo pipefail

if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

$SUDO apt update
$SUDO apt install -y gpg wget unzip file bat btop duf mc fd-find

# eza: Standard-Repo prüfen, sonst eigenes APT-Repo einbinden
if apt-cache show eza &>/dev/null; then
    $SUDO apt install -y eza
else
    $SUDO mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | gpg --dearmor | $SUDO tee /etc/apt/keyrings/gierens.gpg > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        | $SUDO tee /etc/apt/sources.list.d/gierens.list
    $SUDO chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    $SUDO apt update
    $SUDO apt install -y eza
fi

# yazi: kein Debian-Paket, Binary-Release von GitHub
curl -o /tmp/yazi.zip -L https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip -o /tmp/yazi.zip -d /tmp/yazi
$SUDO mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /tmp/yazi/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
$SUDO chmod +x /usr/local/bin/yazi /usr/local/bin/ya
rm -rf /tmp/yazi /tmp/yazi.zip

# Aliase in Shell-RC-Dateien eintragen (idempotent: alter Block wird ersetzt)
write_aliases() {
    local rc="$1"
    local tmp
    tmp="$(mktemp)"

    # remove previous dotfiles block including the blank line before it
    if [ -f "$rc" ]; then
        awk '
            /^# --- dotfiles: tool aliases ---$/ { inblock = 1; buf = ""; next }
            /^# --- dotfiles: end ---$/          { inblock = 0; next }
            inblock { next }
            /^$/ { buf = buf "\n"; next }
            { printf "%s", buf; buf = ""; print }
        ' "$rc" > "$tmp"
        cat "$tmp" > "$rc"
    fi
    rm -f "$tmp"

    cat >> "$rc" << 'EOF'

# --- dotfiles: tool aliases ---
alias ls='eza'
alias top='btop'
alias df='duf'

# Ubuntu/Debian: bat binary heißt batcat
if command -v batcat &>/dev/null; then
    alias bat='batcat'
    alias cat='batcat'
else
    alias cat='bat'
fi

# Ubuntu/Debian: fd binary heißt fdfind
if command -v fdfind &>/dev/null; then
    alias fd='fdfind'
fi

# mc: cd-on-exit wrapper
[ -f /usr/lib/mc/mc.sh ] && source /usr/lib/mc/mc.sh

# yazi: cd-on-exit wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# --- dotfiles: end ---
EOF
    echo "Aliase eingetragen: $rc"
}

write_aliases ~/.bashrc
if [ -f ~/.zshrc ]; then
    write_aliases ~/.zshrc
fi

echo "Fertig. Neue Shell starten oder RC-Datei neu sourcen."
