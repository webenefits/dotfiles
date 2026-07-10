# lazyvim

## Grundlagen
<leader>                                   - Leader-Taste ist die Leertaste
<localleader>                              - Localleader ist der Backslash
<leader> gedrückt halten                   - which-key blendet die möglichen Folgetasten ein
<C-s>                                      - speichern (auch aus dem Insert-Modus)
<leader>qq                                 - Neovim beenden (alle Fenster)
<leader>l                                  - Lazy öffnen (Plugin-Manager)
<leader>L                                  - LazyVim-Changelog anzeigen
<leader>cm                                 - Mason öffnen (LSP-Server & Tools verwalten)
<leader>ur                                 - Suchhighlight löschen, Diff & Anzeige neu zeichnen

## Dateien finden (snacks-Picker)
<leader><space>                            - Dateien im Projekt-Root suchen
<leader>ff / <leader>fF                    - Dateien im Projekt-Root / im aktuellen Verzeichnis
<leader>fg                                 - nur von Git verwaltete Dateien
<leader>fr / <leader>fR                    - zuletzt geöffnete Dateien (Root / cwd)
<leader>fb / <leader>fB                    - offene Buffer / alle Buffer inkl. versteckter
<leader>fc                                 - LazyVim-Konfigurationsdatei öffnen
<leader>fn                                 - neue, leere Datei anlegen
<leader>,                                  - Buffer per Picker wechseln
<leader>`                                  - zum zuletzt genutzten Buffer springen

## Explorer (snacks)
<leader>e / <leader>fe                     - Dateibaum im Projekt-Root öffnen
<leader>E / <leader>fE                     - Dateibaum im aktuellen Verzeichnis öffnen
r                                          - Datei unter Cursor umbenennen
d                                          - Datei löschen (nutzt den Papierkorb, wenn vorhanden)
m                                          - ohne Auswahl umbenennen, mit Auswahl hierher verschieben
c                                          - ohne Auswahl kopieren nach, mit Auswahl hierher kopieren
I                                          - von .gitignore ignorierte Dateien ein-/ausblenden
]g / [g                                    - zur nächsten / vorherigen Git-Änderung springen

## Suchen (snacks-Picker)
<leader>/ / <leader>sg                     - Volltextsuche im Projekt-Root (ripgrep)
<leader>sG                                 - Volltextsuche im aktuellen Verzeichnis
<leader>sw / <leader>sW                    - Wort unter Cursor bzw. Auswahl suchen (Root / cwd)
<leader>sb / <leader>sB                    - im aktuellen Buffer / in allen offenen Buffern suchen
<leader>sr                                 - Suchen & Ersetzen über Dateien hinweg (grug-far)
<leader>sR                                 - letzten Picker mit Suchbegriff wieder öffnen
<leader>sq / <leader>sl                    - Quickfix-Liste / Location-List durchsuchen

## Weitere Picker-Quellen
<leader>sh                                 - Hilfeseiten
<leader>sk                                 - Keymaps
<leader>sd / <leader>sD                    - Diagnosen (Projekt / aktueller Buffer)
<leader>ss / <leader>sS                    - LSP-Symbole (Datei / Workspace)
<leader>st / <leader>sT                    - Todo-Kommentare (alle / nur TODO, FIX, FIXME)
<leader>sm                                 - Marken
<leader>sj                                 - Jumplist
<leader>su                                 - Undo-Historie durchsuchen
<leader>sc / <leader>sC                    - Befehlshistorie / verfügbare Befehle
<leader>sa                                 - Autocommands
<leader>si                                 - Icons
<leader>sH                                 - Highlight-Gruppen
<leader>sM                                 - man-Pages
<leader>sp                                 - Plugin-Spezifikationen durchsuchen
<leader>n                                  - Benachrichtigungs-Historie
<leader>uC                                 - Colorscheme auswählen (mit Vorschau)

## LSP
gd / gD                                    - zur Definition / Deklaration springen
gr                                         - Referenzen auflisten
gI / gy                                    - zur Implementierung / Typdefinition springen
K                                          - Hover-Dokumentation anzeigen (LazyVim mappt K auf hover)
gK                                         - Signatur-Hilfe anzeigen
<leader>cr / <leader>cR                    - Symbol umbenennen / Datei umbenennen
<leader>ca / <leader>cA                    - Code-Action / Source-Action
<leader>cc / <leader>cC                    - Codelens ausführen / neu laden
<leader>cd                                 - Diagnose der aktuellen Zeile als Popup
<leader>cf                                 - Datei bzw. Auswahl formatieren (conform.nvim)
<leader>cl                                 - LSP-Info: aktive Server anzeigen
<leader>cs / <leader>cS                    - Symbole / LSP-Referenzen im Trouble-Fenster

## Diagnose & Trouble
]d / [d                                    - nächste / vorherige Diagnose
]e / [e                                    - nächster / vorheriger Fehler
]w / [w                                    - nächste / vorherige Warnung
<leader>xx / <leader>xX                    - Diagnosen im Projekt / nur aktueller Buffer (Trouble)
<leader>xq / <leader>xl                    - Quickfix-Liste / Location-List öffnen
<leader>xQ / <leader>xL                    - Quickfix-Liste / Location-List in Trouble
<leader>xt / <leader>xT                    - Todo-Kommentare in Trouble (alle / TODO, FIX, FIXME)
]t / [t                                    - nächster / vorheriger Todo-Kommentar
[q / ]q                                    - vorheriger / nächster Quickfix-Eintrag

## Buffer
<S-h> / <S-l>                              - vorheriger / nächster Buffer
[b / ]b                                    - vorheriger / nächster Buffer (bufferline)
[B / ]B                                    - Buffer in der bufferline nach links / rechts schieben
<leader>bb                                 - zum zuletzt genutzten Buffer wechseln
<leader>bd / <leader>bD                    - Buffer schließen (Fenster behalten / mitschließen)
<leader>bo / <leader>bi                    - alle anderen / alle unsichtbaren Buffer schließen
<leader>bp / <leader>bP                    - Buffer anheften / alle nicht angehefteten schließen
<leader>bj                                 - Buffer in der bufferline per Taste auswählen
<leader>bl / <leader>br                    - Buffer links / rechts vom aktuellen schließen

## Fenster
<C-h> / <C-j> / <C-k> / <C-l>              - zum Fenster links / unten / oben / rechts
<C-Up> / <C-Down>                          - Fensterhöhe vergrößern / verkleinern
<C-Left> / <C-Right>                       - Fensterbreite verkleinern / vergrößern
<leader>-  / <leader>|                     - Fenster horizontal / vertikal teilen
<leader>wd                                 - aktuelles Fenster schließen
<leader>wm / <leader>uZ                    - Fenster maximieren (Zoom) ein-/ausschalten
<leader>uz                                 - Zen-Modus ein-/ausschalten

## Tabs
<leader><tab><tab>                         - neuen Tab öffnen
<leader><tab>] / <leader><tab>[            - nächster / vorheriger Tab
<leader><tab>f / <leader><tab>l            - erster / letzter Tab
<leader><tab>d / <leader><tab>o            - Tab schließen / alle anderen Tabs schließen

## Git
<leader>gg / <leader>gG                    - lazygit im Projekt-Root / im aktuellen Verzeichnis
<leader>gb                                 - Blame für die aktuelle Zeile
<leader>gf                                 - Commit-Historie der aktuellen Datei
<leader>gl / <leader>gL                    - Git-Log (Projekt-Root / aktuelles Verzeichnis)
<leader>gs / <leader>gS                    - Git-Status / Stash-Liste
<leader>gd / <leader>gD                    - geänderte Hunks / Diff gegen origin
<leader>gB / <leader>gY                    - Datei auf der Git-Forge öffnen / URL kopieren

## Git-Hunks (gitsigns)
]h / [h                                    - nächster / vorheriger geänderter Hunk
]H / [H                                    - letzter / erster Hunk der Datei
<leader>ghs / <leader>ghr                  - Hunk stagen / verwerfen (auch auf Auswahl)
<leader>ghS / <leader>ghR                  - ganzen Buffer stagen / verwerfen
<leader>ghu                                - letztes Stagen rückgängig machen
<leader>ghp                                - Hunk inline als Vorschau anzeigen
<leader>ghb / <leader>ghB                  - Blame für Zeile / für den ganzen Buffer
<leader>ghd / <leader>ghD                  - Diff gegen Index / gegen den vorherigen Commit
ih                                         - Hunk als Textobjekt (z. B. dih, vih)

## Springen & Auswählen (flash)
s                                          - Sprungziel per Suchmuster ansteuern
S                                          - Sprung zu einem Treesitter-Knoten
r                                          - Flash im Operator-Modus (z. B. dr, yr)
R                                          - Treesitter-Suche im Operator-/Visual-Modus
<C-s>                                      - Flash in der Kommandozeile ein-/ausschalten

## Textobjekte (mini.ai)
af / if                                    - Funktion außen / innen
ac / ic                                    - Klasse außen / innen
ao / io                                    - Codeblock (Schleife, Bedingung) außen / innen
au / iu                                    - Funktionsaufruf außen / innen
aU / iU                                    - Funktionsaufruf ohne Punkt im Namen (foo statt a.foo)
ag / ig                                    - gesamter Buffer als Textobjekt
an / in                                    - Treesitter-Knoten außen / innen (nvim-Default)

## Kommentare
gcc                                        - Zeile aus-/einkommentieren (nvim-Default)
gc<motion>                                 - Bereich kommentieren, z. B. gcap für Absatz
gc                                         - Auswahl im visuellen Modus kommentieren
gco / gcO                                  - Kommentarzeile darunter / darüber einfügen (LazyVim)

## Autovervollständigung (blink.cmp, Preset "enter")
<CR>                                       - markierten Vorschlag übernehmen
<C-y>                                      - ersten Vorschlag direkt übernehmen
<C-n> / <C-p>                              - nächster / vorheriger Vorschlag
<Down> / <Up>                              - nächster / vorheriger Vorschlag
<C-space>                                  - Vorschläge bzw. Dokumentation einblenden
<C-e>                                      - Vorschlagsliste abbrechen
<Tab> / <S-Tab>                            - im Snippet vorwärts / rückwärts springen
<C-b> / <C-f>                              - Dokumentation hoch / runter scrollen
<C-k>                                      - Signatur-Hilfe ein-/ausblenden

## Terminal & Scratch
<leader>ft / <leader>fT                    - schwebendes Terminal (Projekt-Root / cwd)
<C-/>                                      - Terminal öffnen bzw. wieder ausblenden
<C-h> / <C-j> / <C-k> / <C-l>              - aus dem Terminal heraus das Fenster wechseln
<leader>.                                  - Scratch-Buffer öffnen bzw. schließen
<leader>S                                  - Scratch-Buffer auswählen

## Umschalter (Toggles)
<leader>uf / <leader>uF                    - Autoformat global / nur für diesen Buffer
<leader>ul / <leader>uL                    - Zeilennummern / relative Zeilennummern
<leader>ud                                 - Diagnosen ein-/ausblenden
<leader>uh                                 - Inlay-Hints ein-/ausblenden
<leader>us / <leader>uw                    - Rechtschreibprüfung / Zeilenumbruch
<leader>uc                                 - Conceal-Level umschalten
<leader>ub                                 - Hintergrund hell / dunkel
<leader>ug / <leader>uS                    - Einrückungslinien / sanftes Scrollen
<leader>ua / <leader>uD                    - Animationen / Dim-Modus
<leader>uT / <leader>uA                    - Treesitter-Highlighting / Tabline
<leader>ui / <leader>uI                    - Highlight-Gruppe unter Cursor / Treesitter-Baum
<leader>un                                 - alle Benachrichtigungen ausblenden

## Sessions (persistence.nvim)
<leader>qs                                 - Session dieses Verzeichnisses wiederherstellen
<leader>ql                                 - zuletzt genutzte Session wiederherstellen
<leader>qS                                 - Session aus einer Liste auswählen
<leader>qd                                 - aktuelle Session nicht speichern

## Profiler
<leader>dpp                                - Profiler starten / stoppen
<leader>dph                                - Profiler-Highlights ein-/ausblenden
<leader>dps                                - Profiler-Ergebnis im Scratch-Buffer

## Optional: Extra "util.project"
<leader>fp                                 - Projekt wechseln (nur mit aktiviertem Extra)

## Optional: GitHub-Picker (benötigt die gh-CLI)
<leader>gi / <leader>gI                    - GitHub-Issues (offene / alle)
<leader>gp / <leader>gP                    - GitHub-Pull-Requests (offene / alle)

## Optional: avante.nvim (eigenes Plugin, nicht Teil von LazyVim)
<leader>aa / <leader>an                    - Frage an die KI / neue Frage beginnen
<leader>ae                                 - markierten Code von der KI überarbeiten lassen
<leader>at / <leader>af                    - Avante-Fenster umschalten / fokussieren
<leader>ac / <leader>aB                    - aktuellen Buffer / alle Buffer als Kontext hinzufügen
<leader>ar / <leader>aS                    - Antwort neu erzeugen / laufende Anfrage stoppen
<leader>ah / <leader>a?                    - Verlauf / Modell auswählen
<leader>as                                 - Inline-Vorschläge ein-/ausschalten
<leader>az                                 - Zen-Modus für Avante
<M-l>                                      - Inline-Vorschlag übernehmen
]] / [[                                    - zum nächsten / vorherigen Vorschlag springen
co / ct / cb                               - Konflikt lösen: unsere / ihre / beide Seiten
]x / [x                                    - zum nächsten / vorherigen Konflikt springen

## Optional: diffview.nvim (eigenes Plugin, nicht Teil von LazyVim)
:DiffviewOpen                              - Diff der nicht committeten Änderungen öffnen
:DiffviewOpen main..HEAD                   - Diff zweier Revisionen öffnen
:DiffviewFileHistory                       - Commit-Historie des Repositorys durchblättern
:DiffviewFileHistory %                     - Commit-Historie der aktuellen Datei
:DiffviewClose                             - Diffview-Tab schließen
<tab> / <s-tab>                            - Diff der nächsten / vorherigen Datei öffnen
g?                                         - Hilfe-Panel mit allen Tasten der Ansicht
