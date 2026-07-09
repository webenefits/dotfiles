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
| yazi | TUI-Dateimanager (ranger/nnn) | Binary von GitHub-Releases |
| fzf | Fuzzy Finder (History-Search, yazi `Z`) | Binary von GitHub-Releases |
| zoxide | cd | `apt install zoxide` |
| tldr | man | `apt install tealdeer` (Binary `tldr`) |
| chafa | Bildvorschau in yazi | `apt install chafa` |

Das Bootstrap-Script trägt Aliase und Init-Zeilen idempotent in `~/.bashrc`, `~/.zshrc` (falls vorhanden) und `~/.config/fish/config.fish` (falls fish installiert) ein.

## Tool-Cheatsheet

| Original | Alternative | Install-Befehl | Verwendung |
|----------|-------------|----------------|------------|
| `ls` | `eza` | `apt install eza` | `eza`, `eza --tree`, Alias: `alias ls=eza` |
| `cat`/`less` | `bat` | `apt install bat` (Ubuntu: Binary `batcat`) | `bat <file>`, Alias: `alias cat=bat` (Ubuntu: `alias bat=batcat` zuerst) |
| `top`/`htop` | `btop` | `apt install btop` | `btop`, Alias: `alias top=btop` |
| `df` | `duf` | `apt install duf` | `duf`, Alias: `alias df=duf` |
| Dateimanager | `mc` | `apt install mc` (Debian), `pacman -S mc` | `mc`, cd-on-exit: `source /usr/lib/mc/mc.sh` in `.bashrc` (Pfad: `dpkg -L mc \| grep mc.sh`) |
| `find` | `fd` | `pacman -S fd` / `apt install fd-find` (Ubuntu: Binary `fdfind`) | `fd <pattern>`, Alias: `alias fd=fdfind` (nur Ubuntu) |
| TUI-Filemanager | `yazi` | `pacman -S yazi` / Debian: Binary-Release erforderlich | `y` (Wrapper mit cd-on-exit) |
| History-Search | `fzf` | `pacman -S fzf` / Debian: Binary-Release erforderlich (apt-Version < 0.53, zu alt für yazi) | `Ctrl+R`, `Ctrl+T`, `Alt+C`; von yazi für `Z` genutzt. Init: bash `eval "$(fzf --bash)"`, fish `fzf --fish \| source` |
| `cd` | `zoxide` | `pacman -S zoxide` / `apt install zoxide` | `z <pattern>`, `zi`; Init: bash `eval "$(zoxide init bash)"`, fish `zoxide init fish \| source` |
| `man` | `tldr` | `pacman -S tealdeer` / `apt install tealdeer` (Binary `tldr`) | `tldr <command>`, `tldr --update` |
| Bildvorschau (yazi) | `chafa` | `pacman -S chafa` / `apt install chafa` | Fallback-Adapter für yazi ohne Kitty-/Sixel-Grafik |

### yazi im Detail

yazi ist ein asynchroner TUI-Dateimanager (Rust) im Miller-Spalten-Layout (parent / current / preview):

**Dateimanager (ranger/nnn-Ersatz)**
Kopieren (`y`), Ausschneiden (`x`), Einfügen (`p`), Löschen (`d`), Umbenennen (`r`) direkt in der TUI. Mehrfachauswahl mit `Space`, Bulk-Rename öffnet alle markierten Namen im `$EDITOR`. Tabs (`t`), alle I/O-Operationen laufen asynchron — große Verzeichnisse blockieren nicht.

**Vorschau**
Bildvorschau nativ via Kitty-Protokoll, iTerm2, Sixel oder Überzug++. Code-Dateien mit Syntax-Highlighting, Archive, PDFs und Videos (Thumbnails via ffmpeg) werden ebenfalls gerendert.

**Suche & Navigation**
`s` sucht Dateinamen via `fd`, `S` Datei**inhalte** via `rg` — Ergebnisse erscheinen als virtuelles Verzeichnis. `z` springt per zoxide, `Z` per fzf. Für großflächige Codesuche bleibt `rg` direkt überlegen.

**cd-on-exit**
Der `y`-Wrapper (offizielle Shell-Funktion, wird vom Bootstrap in die Shell-Config eingetragen) wechselt beim Beenden ins zuletzt besuchte Verzeichnis — yazi immer über `y` statt `yazi` starten.

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
