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
