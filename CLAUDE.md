# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Überblick

Dotfiles plus ein einziges Bootstrap-Script (`bootstrap/remote.sh`) für Debian/Ubuntu (`apt`) und Arch/CachyOS (`pacman`). Gestartet wird per `curl … | bash` direkt von GitHub `main` — Änderungen wirken auf Zielsystemen also erst nach Push auf `main`. Bewusst reines Bash ohne zusätzliche Runtime-Abhängigkeiten (kein Python, kein Ansible/chezmoi).

`README.md` dokumentiert jedes Verhalten des Scripts sehr detailliert (Tool-Tabelle, Update-Logik, Struktur). Verhaltensänderungen am Script immer auch dort nachziehen.

## Prüfen & Testen

Kein Build, keine Testsuite.

```bash
bash -n bootstrap/remote.sh                 # Syntaxcheck
shellcheck bootstrap/remote.sh cheatsheets/cheat shell/bash/aliases.sh   # falls installiert
fish -n shell/fish/config.fish              # falls fish installiert
```

Lokaler Lauf gegen den Working-Tree statt GitHub (installiert echte Pakete — nur in Wegwerf-VM/Container):

```bash
DOTFILES_RAW="file://$PWD" bash bootstrap/remote.sh --user   # bzw. --system
```

## Architektur von `bootstrap/remote.sh`

**Zwei Phasen:** erst systemweite Paketinstallation (immer mit root/sudo), dann `user_setup` für alle `$HOME`-Configs. Scope `--user` → nur aktueller User; `--system` (Default bei root/sudo) → root, alle Login-User aus `/etc/passwd` (UID-Range aus `/etc/login.defs`) und `/etc/skel`.

**Fehlerbehandlung:** Kein `set -e`. Jeder Schritt läuft über `try "<label>" <funktion>`; Fehler landen in `FAILED[]` und werden am Ende gelistet. Eine Funktion kann vor `return 1` `LAST_TRY_REASON` setzen, um einen Kurzgrund mitzugeben. Neue Schritte nach diesem Muster einbauen, nie hart abbrechen.

**Interaktivität:** stdin ist die curl-Pipe, daher alle Rückfragen per `read … < /dev/tty`, vorher `has_tty` prüfen und ohne Terminal einen sinnvollen Default wählen (CI/cron/System-Modus).

**System-Modus — wichtigste Falle:** `user_setup` wird *nicht* direkt aufgerufen, sondern samt Abhängigkeiten per `declare -f` / `declare -p` in ein Temp-Script serialisiert und pro User mit `env -i` via `runuser`/`sudo -u` ausgeführt. **Jede neue Funktion oder globale Variable, die `user_setup` (direkt oder indirekt) nutzt, muss in `USER_SETUP_FUNCS` bzw. `USER_SETUP_VARS` eingetragen werden**, sonst funktioniert sie nur im User-Modus. Fehler kommen über stdout als `__FAILED__:<label>` zurück. Für `/etc/skel` wird `user_setup --skel` aufgerufen (ohne tldr-Cache, XDG-Cache/State in Wegwerf-Verzeichnis).

**Drei Deploy-Muster für Configs** — beim Hinzufügen einer neuen Config das passende wählen:
1. *Import-Zeile zwischen Markern* (`add_import`): Repo-Datei nach `~/.config/dotfiles/` laden, in der RC-Datei nur eine `source`/`dofile`-Zeile zwischen `# --- dotfiles ---` / `# --- dotfiles: end ---` pflegen. Für Shell (bash/zsh/fish) und nvim.
2. *Managed File* (`install_managed_file`): für Single-File-Configs ohne Import-Mechanismus (micro `settings.json`, yazi `yazi.toml`/`keymap.toml`). Drei-Wege-Vergleich gegen den zuletzt deployten Repo-Stand in `~/.config/dotfiles/<name>`; bei echtem Konflikt interaktive Abfrage (r/l/d).
3. *Vendor-Dateien* (micro-Colorschemes, micro-Syntax, cheat + Sheets): bei jedem Lauf überschreiben.

**Dateien werden einzeln per URL geladen** (raw.githubusercontent bietet kein Listing). Neue Dateien im Repo erscheinen daher nicht automatisch auf Zielsystemen — sie müssen im Script registriert werden, z. B. `CHEAT_SHEETS`, `MICRO_COLORSCHEMES`, `YAZI_PLUGINS` oder ein neuer Schritt in `user_setup`.

**Distro-Unterschiede:** Arch bezieht alles aus den offiziellen Repos. Unter Debian/Ubuntu sind einige apt-Versionen zu alt oder fehlen (eza, yazi, glow → Fremd-APT-Repos; fzf, chafa, ggf. tealdeer → Binaries nach `/usr/local/bin`). micro hat eine mehrstufige Fallback-Kette (Paket → Flatpak → Snap → Flatpak nachinstallieren) samt Aufräumen alter Wrapper. Debian-Server/Client-Modus steuert `--no-install-recommends`.

## Shell-Configs

`shell/bash/aliases.sh` (bash + zsh) und `shell/fish/config.fish` sind inhaltlich parallel gepflegt — Änderungen an Aliasen/Integrationen immer in beiden vornehmen. Debian-Binary-Namen beachten (`batcat`, `fdfind`).

## Cheatsheets

Format: `## Abschnitt`, darunter Zeilen `<befehl>   - <beschreibung>`. Neues Sheet: `cheatsheets/sheets/<name>.md` anlegen, in `CHEAT_SHEETS` im Script und in der Sheet-Liste im README ergänzen.

## Git

Commit-Stil: Conventional Commits auf Englisch mit Scope, z. B. `feat(bootstrap): …`, `fix(shell): …`. Pro Änderung ein eigener Branch, Merge nach `main` lokal (`Merge branch '<branch>'`).
