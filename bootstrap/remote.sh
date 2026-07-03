#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y eza bat btop duf mc fd-find

# broot: kein Debian-Paket, Binary-Release
curl -o /tmp/broot -L https://dystroy.org/broot/download/x86_64-linux/broot
sudo mv /tmp/broot /usr/local/bin/broot
sudo chmod +x /usr/local/bin/broot
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
