# Dotfiles

Dotfiles und Bootstrap-Script für Debian/Ubuntu und Arch/CachyOS.

## Bootstrap

Einmalig ausführen — das Script erkennt den Paketmanager (`apt`/`pacman`) automatisch:

```bash
curl -sL https://raw.githubusercontent.com/webenefits/dotfiles/refs/heads/main/bootstrap/remote.sh | bash
```

### Was installiert wird

Auf Arch/CachyOS liegen alle Tools in den offiziellen Repos (`pacman`). Auf Debian/Ubuntu sind einige apt-Versionen zu alt (yazi, fzf, chafa) und werden als Binary bezogen.

| Tool | Ersetzt | Arch (pacman) | Debian/Ubuntu |
|------|---------|---------------|---------------|
| eza | ls | `eza` | `apt install eza` (+ eigenes Repo als Fallback) |
| bat | cat / less | `bat` | `apt install bat` (Binary `batcat`) |
| btop | top / htop | `btop` | `apt install btop` |
| duf | df | `duf` | `apt install duf` |
| mc | Dateimanager | `mc` | `apt install mc` |
| fd | find | `fd` | `apt install fd-find` (Binary `fdfind`) |
| yazi | TUI-Dateimanager (ranger/nnn) | `yazi` | Binary von GitHub-Releases |
| fzf | Fuzzy Finder (History-Search, yazi `Z`) | `fzf` | Binary von GitHub-Releases |
| zoxide | cd | `zoxide` | `apt install zoxide` |
| tldr | man | `tealdeer` | `apt install tealdeer` (Binary `tldr`) |
| chafa | Bildvorschau in yazi | `chafa` | Binary von hpjansson.org (apt-Version zu alt) |
| neovim | vim / nano | `neovim` | `apt install neovim` |
| lnav | tail / less (Logs) | `lnav` | `apt install lnav` |

Zusätzlich installiert das Script den `cheat`-Wrapper nach `~/.local/bin/` und die Cheatsheets nach `~/.local/share/cheatsheets/` (`$XDG_DATA_HOME`, siehe [Cheatsheets](#cheatsheets)). Ist `tldr` (tealdeer) installiert, füllt das Script am Ende per `tldr --update` den Cache, damit der erste Aufruf sofort funktioniert.

Die Shell-Integration (Aliase, `fzf`-/`zoxide`-Init, `y`-Wrapper, `~/.local/bin` im PATH) liegt in `shell/` und wird vom Bootstrap nach `~/.config/dotfiles/` geladen. In `~/.bashrc`, `~/.zshrc` (falls vorhanden) und `~/.config/fish/config.fish` (falls fish installiert) wird idempotent nur eine `source`-Zeile eingetragen — Updates erfordern kein erneutes Bearbeiten der RC-Dateien. Die nvim-Optionen (`nvim/init.lua`, u. a. `clipboard=unnamedplus`) landen nach demselben Muster in `~/.config/dotfiles/nvim.lua` und werden per `dofile`-Zeile in `~/.config/nvim/init.lua` eingebunden; eine vorhandene `init.vim` wird nicht angetastet (Schritt wird dann übersprungen). Schlägt die Installation eines Tools fehl, laufen die übrigen weiter; am Ende listet das Script alle Fehler auf.

Das Bootstrap-Script ist idempotent: erneutes Ausführen aktualisiert Tools, Configs und Cheatsheets, ohne Bestehendes zu zerstören.

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
| Bildvorschau (yazi) | `chafa` | `pacman -S chafa` / Debian/Ubuntu: statisches Binary von hpjansson.org (apt-Version < 1.16 kennt yazis `--probe` nicht) | Fallback-Adapter für yazi ohne Kitty-/Sixel-Grafik |
| `vim`/`nano` | `neovim` | `pacman -S neovim` / `apt install neovim` | `nvim`; als `$EDITOR` gesetzt (von yazi genutzt), Alias `vim=nvim` |
| `tail -f`/`less` (Logs) | `lnav` | `pacman -S lnav` / `apt install lnav` | `lnav /var/log/…`; erkennt Log-Formate automatisch, Zeitleiste, SQL-Abfragen auf Logs |

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

## Cheatsheets

Der `cheat`-Wrapper zeigt Cheatsheets an und durchsucht sie per `fzf` (Preview via `bat`):

```bash
cheat              # Cheatsheet auswählen und anzeigen
cheat vim          # direkt vim.md anzeigen (fuzzy-Match auf Dateiname)
cheat vim suchen   # in vim.md nach "suchen" filtern, gewählte Zeile in die Zwischenablage
```

Enthaltene Sheets: `git`, `docker`, `ddev`, `composer`, `typo3`, `shopware`, `oxid`, `vim`, `lazyvim`, `nano`, `yazi`. Neue Sheets als `cheatsheets/sheets/<name>.md` ablegen und in `bootstrap/remote.sh` (`CHEAT_SHEETS`) ergänzen.

Der Wrapper landet unter `~/.local/bin/cheat`, die Sheets unter `~/.local/share/cheatsheets/` (`$XDG_DATA_HOME`). Bei jedem Bootstrap-Lauf wird dieser Ordner komplett neu aufgebaut, damit entfernte Sheets verschwinden; ein evtl. vorhandenes Alt-Verzeichnis `~/.cheatsheets` wird migriert (gelöscht). **Voraussetzungen:** `fish` (Shebang), `fzf` und `bat`/`batcat` — `fzf` und `bat` bringt das Bootstrap mit; ohne `fish` bleiben die Sheets per `bat ~/.local/share/cheatsheets/<name>.md` lesbar. Ohne TTY (z. B. aus KRunner) öffnet sich der Wrapper in einem Terminal (`xdg-terminal-exec`/`konsole`).

## Struktur

```
bootstrap/
  remote.sh        ← Bootstrap für Debian/Ubuntu & Arch/CachyOS
shell/
  bash/
    aliases.sh     ← Aliase & Integration für bash/zsh (→ ~/.config/dotfiles/aliases.sh)
  fish/
    config.fish    ← Aliase & Integration für fish (→ ~/.config/dotfiles/config.fish)
nvim/
  init.lua         ← nvim-Optionen (→ ~/.config/dotfiles/nvim.lua, via dofile in ~/.config/nvim/init.lua)
cheatsheets/
  cheat            ← fzf-Wrapper (→ ~/.local/bin/cheat)
  sheets/          ← Cheatsheet-Inhalte (→ ~/.local/share/cheatsheets/)
    vim.md
    lazyvim.md
    nano.md
    yazi.md
    git.md
    docker.md
    ddev.md
    composer.md
    typo3.md
    shopware.md
    oxid.md
```

Die Dateien unter `shell/` und `cheatsheets/` sind die Single Source of Truth; das Bootstrap-Script lädt sie herunter und bindet sie ein.
