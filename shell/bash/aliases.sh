# dotfiles: tool aliases & shell integration (bash/zsh)

alias ls='eza'
alias top='btop'
alias df='duf'

# Ubuntu/Debian: bat binary heißt batcat
if command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat'
else
    alias cat='bat'
fi

# Ubuntu/Debian: fd binary heißt fdfind
if command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
fi

# fzf: keybindings (Ctrl+R, Ctrl+T, Alt+C)
if command -v fzf >/dev/null 2>&1; then
    if [ -n "${BASH_VERSION:-}" ]; then
        eval "$(fzf --bash)"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        eval "$(fzf --zsh)"
    fi
fi

# neovim: als Standard-Editor (u. a. von yazi genutzt)
if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
    alias vim='nvim'
fi

# zoxide: smarter cd (z, zi)
if command -v zoxide >/dev/null 2>&1; then
    if [ -n "${BASH_VERSION:-}" ]; then
        eval "$(zoxide init bash)"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        eval "$(zoxide init zsh)"
    fi
fi

# mc: cd-on-exit wrapper
[ -f /usr/lib/mc/mc.sh ] && . /usr/lib/mc/mc.sh

# yazi: cd-on-exit wrapper
y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
