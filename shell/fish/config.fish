# dotfiles: tool aliases & shell integration (fish)

# ~/.local/bin im PATH (u. a. für cheat)
fish_add_path -g "$HOME/.local/bin"

# ls -> eza
alias ls='eza -alh --color=always --group-directories-first --icons=always' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons=always'  # all files and dirs
alias ll='eza -aalgh --color=always --group-directories-first --icons=always' # long format incl. group + header, shows . and ..
alias lt='eza -aT --color=always --group-directories-first --icons=always' # tree listing
alias l.="eza -a | grep -e '^\.'"                                          # show only dotfiles
alias top='btop'
alias df='duf'

# bat as cat replacement (binary is 'batcat' on Ubuntu/Debian, 'bat' on Arch)
if type -q batcat
    alias bat='batcat'
    alias cat='batcat'
else if type -q bat
    alias cat='bat'
end

# fd (binary is 'fdfind' on Ubuntu/Debian, 'fd' on Arch)
if type -q fdfind
    alias fd='fdfind'
end

# fzf: keybindings (Ctrl+R, Ctrl+T, Alt+C)
if type -q fzf
    fzf --fish | source
end

# micro: als Standard-Editor (u. a. von yazi genutzt)
if type -q micro
    set -gx EDITOR micro
end

# neovim: weiterhin per `vim`-Alias nutzbar, aber nicht mehr Standard-Editor
if type -q nvim
    alias vim='nvim'
end

# zoxide: smarter cd (z, zi)
if type -q zoxide
    zoxide init fish | source
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
