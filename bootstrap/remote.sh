#!/usr/bin/env bash
set -euo pipefail

if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

$SUDO apt update
$SUDO apt install -y gpg wget unzip file bat btop duf mc fd-find chafa

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

# fzf: apt-Version zu alt für yazi (braucht >= 0.53), Binary-Release von GitHub
FZF_VERSION="$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep -oP '"tag_name": "v\K[^"]+')"
curl -o /tmp/fzf.tar.gz -L "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
tar -xzf /tmp/fzf.tar.gz -C /tmp
$SUDO mv /tmp/fzf /usr/local/bin/
$SUDO chmod +x /usr/local/bin/fzf
rm -f /tmp/fzf.tar.gz

# remove previous dotfiles block including the blank line before it (idempotent)
strip_block() {
    local rc="$1" tmp
    [ -f "$rc" ] || return 0
    tmp="$(mktemp)"
    awk '
        /^# --- dotfiles: tool aliases ---$/ { inblock = 1; buf = ""; next }
        /^# --- dotfiles: end ---$/          { inblock = 0; next }
        inblock { next }
        /^$/ { buf = buf "\n"; next }
        { printf "%s", buf; buf = ""; print }
    ' "$rc" > "$tmp"
    cat "$tmp" > "$rc"
    rm -f "$tmp"
}

# Aliase in Shell-RC-Dateien eintragen (bash/zsh)
write_aliases() {
    local rc="$1"
    strip_block "$rc"

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

# fzf: keybindings (Ctrl+R, Ctrl+T, Alt+C)
if command -v fzf &>/dev/null; then
    if [ -n "${BASH_VERSION:-}" ]; then
        eval "$(fzf --bash)"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        eval "$(fzf --zsh)"
    fi
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

# Aliase in fish-Config eintragen (eigene Syntax)
write_aliases_fish() {
    local rc="$1"
    mkdir -p "$(dirname "$rc")"
    strip_block "$rc"

    cat >> "$rc" << 'EOF'

# --- dotfiles: tool aliases ---
alias ls='eza'
alias top='btop'
alias df='duf'

# Ubuntu/Debian: bat binary heißt batcat
if type -q batcat
    alias bat='batcat'
    alias cat='batcat'
else
    alias cat='bat'
end

# Ubuntu/Debian: fd binary heißt fdfind
if type -q fdfind
    alias fd='fdfind'
end

# fzf: keybindings (Ctrl+R, Ctrl+T, Alt+C)
if type -q fzf
    fzf --fish | source
end

# yazi: cd-on-exit wrapper
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
# --- dotfiles: end ---
EOF
    echo "Aliase eingetragen: $rc"
}

write_aliases ~/.bashrc
if [ -f ~/.zshrc ]; then
    write_aliases ~/.zshrc
fi

# fish nur wenn installiert oder config bereits vorhanden
if command -v fish &>/dev/null || [ -f ~/.config/fish/config.fish ]; then
    write_aliases_fish ~/.config/fish/config.fish
fi

echo "Fertig. Neue Shell starten oder RC-Datei neu sourcen."
