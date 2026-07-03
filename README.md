# Dotfiles

Dotfiles und Bootstrap-Scripts für Remote-Server (Debian/Ubuntu).

## Bootstrap

Einmalig auf einem neuen Server ausführen:

```bash
curl -sL https://raw.githubusercontent.com/webenefits/dotfiles/refs/heads/main/bootstrap/remote.sh | bash
```

### Was installiert wird

| Tool | Ersetzt | Paket |
|------|---------|-------|
| eza | ls | `apt install eza` |
| bat | cat / less | `apt install bat` |
| btop | top / htop | `apt install btop` |
| duf | df | `apt install duf` |
| mc | Dateimanager | `apt install mc` |
| fd | find | `apt install fd-find` |
| broot | TUI-Filemanager | Binary von dystroy.org |

## Tool-Cheatsheet

### Allgemein (Remote & Lokal, Bash)

| Original | Alternative | Install-Befehl | Verwendung |
|----------|-------------|----------------|------------|
| `ls` | `eza` | `apt install eza` | `eza`, `eza --tree`, Alias: `alias ls=eza` |
| `cat`/`less` | `bat` | `apt install bat` (Ubuntu: Binary `batcat`) | `bat <file>`, Alias: `alias cat=bat` (Ubuntu: `alias bat=batcat` zuerst) |
| `top`/`htop` | `btop` | `apt install btop` | `btop`, Alias: `alias top=btop` |
| `df` | `duf` | `apt install duf` | `duf`, Alias: `alias df=duf` |
| Dateimanager | `mc` | `apt install mc` (Debian), `pacman -S mc` | `mc`, cd-on-exit: `source /usr/lib/mc/mc.sh` in `.bashrc` (Pfad: `dpkg -L mc \| grep mc.sh`) |
| `find` | `fd` | `pacman -S fd` / `apt install fd-find` (Ubuntu: Binary `fdfind`) | `fd <pattern>`, Alias: `alias fd=fdfind` (nur Ubuntu) |
| TUI-Filemanager | `broot` | `pacman -S broot` / Debian 12: Binary-Release erforderlich | `br`, Setup: `broot --install` (fügt Funktion in `.bashrc` ein) |

### Lokal (Fish)

| Original | Alternative | Install-Befehl | Verwendung |
|----------|-------------|----------------|------------|
| `cd` | `zoxide` | `pacman -S zoxide` / `apt install zoxide` | `z <pattern>`, Init in `config.fish`: `zoxide init fish \| source` |
| `man` | `tldr` | `pacman -S tealdeer` / `cargo install tealdeer` (kein Debian-Paket) | `tldr <command>` |
| History-Search | `fzf` | `pacman -S fzf` / `apt install fzf` | `Ctrl+R`, `Ctrl+T`, `Alt+C`, Init in `config.fish`: `fzf --fish \| source` |

## Struktur

```
bootstrap/
  remote.sh       ← Bootstrap für Debian/Ubuntu-Server
shell/
  bash/
    .bashrc       ← Bash-Aliase und -Konfiguration
  fish/
    config.fish   ← Fish-Konfiguration (lokal)
```
