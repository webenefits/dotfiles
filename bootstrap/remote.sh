#!/usr/bin/env bash
set -euo pipefail

if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

$SUDO apt update
$SUDO apt install -y gpg wget bat btop duf mc fd-find

# eza: kein Standard-Debian-Paket, eigenes APT-Repo erforderlich
mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | $SUDO tee /etc/apt/sources.list.d/gierens.list
$SUDO chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
$SUDO apt update
$SUDO apt install -y eza

# broot: kein Debian-Paket, Binary-Release
curl -o /tmp/broot -L https://dystroy.org/broot/download/x86_64-linux/broot
$SUDO mv /tmp/broot /usr/local/bin/broot
$SUDO chmod +x /usr/local/bin/broot
broot --install

# Aliase in ~/.bashrc eintragen
cat >> ~/.bashrc << 'EOF'

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
EOF

echo "Fertig. Neue Shell starten oder 'source ~/.bashrc' ausführen."
