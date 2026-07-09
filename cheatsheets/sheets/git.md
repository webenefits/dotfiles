# git

## Konfiguration
git config --global user.name "Name"      - globalen Autor-Namen setzen
git config --global user.email "mail"     - globale Autor-E-Mail setzen
git config --global core.editor "nvim"    - Standard-Editor für Commits setzen
git config --global init.defaultBranch main - Default-Branch neuer Repos festlegen
git config --global pull.rebase true      - pull standardmäßig als rebase
git config --list                         - alle wirksamen Einstellungen anzeigen
git config user.email                     - aktuellen Wert einer Einstellung anzeigen
git config --global alias.st status       - Alias anlegen (git st == git status)

## Anlegen & Klonen
git init                                  - aktuelles Verzeichnis zum Repo machen
git init projekt                          - neues Repo im Ordner "projekt" anlegen
git clone <url>                           - Repository klonen
git clone <url> ordner                    - in bestimmten Ordner klonen
git clone --depth 1 <url>                 - flacher Klon (nur letzter Commit)
git clone --branch <tag> <url>            - bestimmten Branch/Tag klonen

## Status & Änderungen
git status                                - Arbeitsverzeichnis- und Staging-Status
git status -s                             - Status kurz/kompakt anzeigen
git diff                                  - ungestagete Änderungen anzeigen
git diff --staged                         - gestagete Änderungen anzeigen
git diff HEAD                             - alle Änderungen ggü. letztem Commit
git diff <branch1> <branch2>              - zwei Branches vergleichen
git diff --stat                           - nur Zusammenfassung pro Datei

## Stagen (Index)
git add <datei>                           - Datei in Staging aufnehmen
git add .                                 - alle Änderungen im Verzeichnis stagen
git add -A                                - alle Änderungen inkl. Löschungen stagen
git add -p                                - interaktiv einzelne Hunks stagen
git add -u                                - nur bereits getrackte Dateien stagen
git restore --staged <datei>             - Datei aus Staging nehmen (unstage)
git reset <datei>                         - dito, alte Syntax

## Committen
git commit -m "message"                   - gestagete Änderungen committen
git commit -am "message"                  - getrackte Änderungen stagen + committen
git commit --amend                        - letzten Commit ändern (Message/Inhalt)
git commit --amend --no-edit              - letzten Commit ergänzen, Message behalten
git commit --fixup <hash>                 - Fixup-Commit für späteres autosquash
git commit --allow-empty -m "msg"         - leeren Commit erzeugen (z. B. CI-Trigger)

## Branches
git branch                                - lokale Branches auflisten
git branch -a                             - alle Branches (inkl. remote) auflisten
git branch -v                             - Branches mit letztem Commit anzeigen
git branch <name>                         - neuen Branch anlegen (ohne Wechsel)
git branch -d <name>                      - Branch löschen (nur wenn gemerged)
git branch -D <name>                      - Branch erzwungen löschen
git branch -m <alt> <neu>                 - Branch umbenennen
git branch --merged                       - bereits gemergte Branches anzeigen
git switch <name>                         - zu Branch wechseln
git switch -c <name>                      - neuen Branch anlegen und wechseln
git switch -                              - zum vorherigen Branch zurück
git checkout <name>                       - zu Branch wechseln (alte Syntax)
git checkout -b <name>                    - Branch anlegen und wechseln (alt)

## Merge & Rebase
git merge <branch>                        - Branch in aktuellen Branch mergen
git merge --no-ff <branch>                - Merge immer mit Merge-Commit
git merge --squash <branch>               - Änderungen als einen Commit übernehmen
git merge --abort                         - laufenden Merge abbrechen
git rebase <branch>                       - aktuellen Branch auf branch rebasen
git rebase -i <hash>                      - interaktives Rebase (squash/reorder/edit)
git rebase -i --autosquash <hash>         - Fixup-/Squash-Commits automatisch anordnen
git rebase --continue                     - nach Konfliktlösung fortsetzen
git rebase --abort                        - Rebase abbrechen, Ausgangszustand zurück
git rebase --onto <neu> <alt> <branch>    - Branch auf neue Basis umhängen
git cherry-pick <hash>                    - einzelnen Commit übernehmen
git cherry-pick <a>..<b>                  - Commit-Bereich übernehmen

## Remotes
git remote -v                             - konfigurierte Remotes anzeigen
git remote add <name> <url>               - Remote hinzufügen (z. B. origin)
git remote set-url origin <url>           - URL eines Remotes ändern
git remote remove <name>                  - Remote entfernen
git remote show origin                    - Details/Tracking zu Remote anzeigen

## Synchronisieren
git fetch                                 - Remote-Änderungen holen (ohne Merge)
git fetch --all --prune                   - alle Remotes holen, tote Branches löschen
git pull                                  - fetch + merge des Upstream-Branches
git pull --rebase                         - fetch + rebase statt merge
git push                                  - lokalen Branch zum Remote pushen
git push -u origin <branch>              - Branch pushen + Upstream setzen
git push --force-with-lease               - erzwingen, aber fremde Commits schützen
git push origin --delete <branch>         - Remote-Branch löschen
git push --tags                           - alle Tags pushen

## Stash
git stash                                 - Änderungen zwischenspeichern & wegräumen
git stash -u                              - inkl. untracked Dateien stashen
git stash -m "beschreibung"               - Stash mit Nachricht anlegen
git stash list                            - alle Stashes auflisten
git stash show -p                         - Inhalt des letzten Stash als Diff
git stash pop                             - letzten Stash anwenden und entfernen
git stash apply                           - Stash anwenden, aber behalten
git stash apply stash@{2}                 - bestimmten Stash anwenden
git stash drop                            - letzten Stash verwerfen
git stash clear                           - alle Stashes löschen

## Rückgängig machen
git restore <datei>                       - Datei auf letzten Commit zurücksetzen
git restore --source=<hash> <datei>       - Datei aus bestimmtem Commit holen
git checkout -- <datei>                   - Änderungen verwerfen (alte Syntax)
git reset --soft HEAD~1                    - letzten Commit lösen, Änderungen gestaget
git reset HEAD~1                           - letzten Commit lösen, Änderungen unstaged
git reset --hard HEAD~1                    - letzten Commit + Änderungen verwerfen
git reset --hard origin/main               - lokal exakt auf Remote-Stand bringen
git revert <hash>                         - Commit durch Gegen-Commit rückgängig machen
git revert --no-commit <hash>             - Revert stagen, aber nicht committen
git clean -n                              - anzeigen, welche untracked Dateien wegkämen
git clean -fd                             - untracked Dateien & Ordner löschen

## History & Log
git log                                    - Commit-History anzeigen
git log --oneline                          - kompakt, ein Commit pro Zeile
git log --oneline --graph --all            - Branch-Graph aller Branches
git log -p                                 - History mit Diffs
git log --stat                             - History mit geänderten Dateien
git log -n 5                               - nur die letzten 5 Commits
git log --since="2 weeks ago"              - Commits seit Zeitraum
git log --author="Thomas"                  - Commits eines Autors
git log --grep="fix"                       - Commits nach Message durchsuchen
git log <datei>                            - History einer Datei
git log -S "text"                          - Commits, die "text" eingeführt/entfernt haben
git shortlog -sn                           - Commits pro Autor zählen
git reflog                                 - Log aller HEAD-Bewegungen (Rettungsanker)

## Inspektion
git show <hash>                            - Details & Diff eines Commits
git show <hash>:<datei>                    - Dateiinhalt zu einem Commit anzeigen
git blame <datei>                          - Zeile für Zeile letzter Änderer/Commit
git blame -L 10,20 <datei>                 - blame nur für Zeilen 10–20
git describe --tags                        - nächsten Tag relativ zu HEAD beschreiben
git rev-parse HEAD                         - vollen Hash des aktuellen Commits
git cat-file -p <hash>                     - Roh-Inhalt eines Git-Objekts

## Suchen & Fehler finden
git grep "muster"                          - im getrackten Code suchen
git grep -n "muster"                       - mit Zeilennummern suchen
git grep "muster" <hash>                   - in bestimmtem Commit suchen
git bisect start                           - binäre Fehlersuche starten
git bisect bad                             - aktuellen Commit als fehlerhaft markieren
git bisect good <hash>                     - bekannten guten Commit markieren
git bisect reset                           - Bisect beenden, zu HEAD zurück

## Tags
git tag                                    - alle Tags auflisten
git tag <name>                             - leichten Tag auf HEAD setzen
git tag -a <name> -m "msg"                 - annotierten Tag mit Nachricht anlegen
git tag -a <name> <hash>                   - Tag auf bestimmten Commit setzen
git tag -d <name>                          - lokalen Tag löschen
git push origin <name>                     - einzelnen Tag pushen
git push origin --delete <name>            - Remote-Tag löschen
git checkout <name>                        - Arbeitsstand eines Tags auschecken

## Worktrees
git worktree add ../dir <branch>           - Branch in separatem Verzeichnis auschecken
git worktree list                          - alle Worktrees auflisten
git worktree remove ../dir                 - Worktree entfernen
git worktree prune                         - verwaiste Worktree-Einträge aufräumen

## Submodule
git submodule add <url> <pfad>             - Submodul hinzufügen
git submodule update --init --recursive    - Submodule initialisieren & laden
git submodule update --remote              - Submodule auf neuesten Remote-Stand
git clone --recurse-submodules <url>       - Repo inkl. aller Submodule klonen

## Ignorieren & Attribute
git check-ignore -v <datei>                - zeigen, welche Regel eine Datei ignoriert
git rm --cached <datei>                    - Datei untracken, aber lokal behalten
git rm -r --cached <ordner>                - Ordner rekursiv aus Tracking nehmen
git ls-files                               - alle getrackten Dateien auflisten

## Wartung & Aufräumen
git gc                                     - Repository komprimieren & aufräumen
git prune                                  - unerreichbare Objekte entfernen
git fsck                                   - Repository-Integrität prüfen
git count-objects -vH                      - Objektanzahl & Repo-Größe anzeigen
git maintenance start                      - automatische Hintergrundwartung aktivieren

## Patches & Bundle
git format-patch -1 <hash>                 - Commit als .patch-Datei exportieren
git apply <datei.patch>                    - Patch anwenden (ohne Commit)
git am <datei.patch>                       - Patch als Commit(s) übernehmen
git bundle create repo.bundle --all        - komplettes Repo in eine Datei packen
git archive -o code.zip HEAD               - Arbeitsstand als Zip-Archiv exportieren
