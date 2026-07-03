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
| broot | tree / ncdu / find / Dateimanager | Binary von dystroy.org |

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

### broot im Detail

broot (`br`) kombiniert mehrere klassische Tools in einer TUI:

**`tree`-Ersatz**
`br -sdp` zeigt Baum mit Größen, Daten und Permissions. Respektiert `.gitignore` automatisch — kein Noise durch `node_modules` etc. `alt+h` togglet hidden files, `alt+i` ignorierte Dateien — interaktiv ohne neuen Befehl.

**`ncdu`-Ersatz — whale-spotting**
`br -w` sortiert den Baum nach Größe, berechnet Verzeichnisgrößen im Hintergrund ohne zu blockieren. `:fs` zeigt alle eingehängten Dateisysteme mit Belegung. Vorteil: direkt aus der Ansicht löschen, ohne Tool zu wechseln.

**Dateimanager (ranger/nnn-Ersatz)**
Zwei-Panel-Modus via `Ctrl+→`. F5 kopieren, F6 verschieben zwischen Panels. `rm`, `mkdir`, `mv`, `cp` sind eingebaut. Bildvorschau nativ via Kitty-Protokoll (Kitty, WezTerm).

**`find`-Ersatz (einfache Fälle)**
Tippen filtert Dateinamen fuzzy. Präfix `/` schaltet auf Regex um. `c/suchbegriff` durchsucht Datei**inhalte**. Kombinierbar: `!/\.log$/&c/ERROR` findet Dateien ohne `.log` im Namen, die aber "ERROR" enthalten. Für großflächige Codesuche bleibt `rg` überlegen.

### Lokal (Fish)

| Original | Alternative | Install-Befehl | Verwendung |
|----------|-------------|----------------|------------|
| `cd` | `zoxide` | `pacman -S zoxide` / `apt install zoxide` | `z <pattern>`, Init in `config.fish`: `zoxide init fish \| source` |
| `man` | `tldr` | `pacman -S tealdeer` / `cargo install tealdeer` (kein Debian-Paket) | `tldr <command>` |
| History-Search | `fzf` | `pacman -S fzf` / `apt install fzf` | `Ctrl+R`, `Ctrl+T`, `Alt+C`, Init in `config.fish`: `fzf --fish \| source` |
| `z` + `br` | `zb` | Fish-Funktion | `zb <pattern>` springt per zoxide ins Verzeichnis und öffnet broot dort |

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
