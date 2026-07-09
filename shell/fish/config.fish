# dotfiles: tool aliases & shell integration (fish)

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
