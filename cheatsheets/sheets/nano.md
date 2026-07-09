# nano

## Öffnen & Erstellen
nano file               - Datei öffnen/erstellen
nano +10 file            - an Zeile 10 öffnen
nano +10,5 file           - an Zeile 10, Spalte 5 öffnen
nano -v file              - read-only öffnen
nano -l file              - mit Zeilennummern öffnen

## Speichern & Verlassen
Ctrl-o                  - speichern (Write Out)
Ctrl-s                   - direkt speichern ohne Nachfrage (nano ≥ 4)
Ctrl-x                   - verlassen
Ctrl-x, Y                 - speichern und verlassen
Ctrl-x, N                 - verlassen ohne speichern
Ctrl-o, Enter              - unter gleichem Namen speichern

## Navigation
Ctrl-f / Ctrl-b            - Zeichen vor / zurück
Ctrl-p / Ctrl-n             - Zeile hoch / runter
Ctrl-Space / Alt-Space      - Wort vor / zurück (auch Ctrl-Pfeil li/re)
Ctrl-a / Ctrl-e             - Zeilenanfang / Zeilenende

## Seitennavigation
Ctrl-v / Ctrl-y             - Seite runter / hoch
Ctrl-_ / Alt-g               - zu Zeilennummer springen
Alt-\                       - zum Dateianfang
Alt-/                       - zum Dateiende

## Ausschneiden, Kopieren, Einfügen
Ctrl-k                   - aktuelle Zeile ausschneiden (mehrfach = mehrere Zeilen)
Alt-6                     - aktuelle Zeile kopieren
Ctrl-u                    - einfügen (uncut)
Alt-k                      - Zeile löschen ohne Cutbuffer zu überschreiben (zap)

## Auswahl
Alt-a / Ctrl-^             - Markierung starten (dann mit Cursor erweitern)
Shift-Pfeiltaste            - Text auswählen
Ctrl-k (bei Markierung)      - Auswahl ausschneiden
Alt-^ (bei Markierung)       - Auswahl kopieren

## Löschen
Backspace / Ctrl-h          - Zeichen vor Cursor löschen
Delete / Ctrl-d              - Zeichen unter Cursor löschen
Alt-Delete                  - Wort vor Cursor löschen
Ctrl-Delete                 - Wort nach Cursor löschen
Ctrl-k                      - Zeile ausschneiden (=löschen)

## Suchen
Ctrl-w                   - Suchen (Where Is)
Alt-w                     - letzte Suche wiederholen
Ctrl-w, Enter               - nächster Treffer
Alt-b                      - rückwärts suchen
Alt-c                      - Groß-/Kleinschreibung toggeln
Alt-r                      - Regex toggeln

## Suchen & Ersetzen
Ctrl-\                   - Suchen & Ersetzen
Y / N                     - diese Stelle ersetzen / überspringen
A                         - alle ersetzen
Ctrl-c                    - Ersetzen abbrechen

## Undo/Redo
Alt-u                     - undo
Alt-e                     - redo

## Zeilenoperationen
Ctrl-j                   - Absatz umbrechen (justify)
Alt-j                     - gesamte Datei umbrechen
Alt-3                     - Zeile kommentieren/auskommentieren
Alt-} / Alt-{             - Zeile/Auswahl ein-/ausrücken (auch Tab/Shift-Tab bei Markierung)

## Makros
Alt-:                    - Makro-Aufnahme starten/stoppen
Alt-;                     - Makro abspielen

## Anzeige
Alt-n                    - Zeilennummern toggeln
Alt-p                     - Whitespace anzeigen toggeln
Alt-y                     - Syntax-Highlighting toggeln
Alt-x                     - Hilfeleiste toggeln
Alt-l                     - Hard-Wrap (automatischer Zeilenumbruch) toggeln
Alt-s                     - Soft-Wrap (Anzeige-Umbruch) toggeln

## Mehrere Buffer
Ctrl-r                   - Datei in Buffer einlesen
Alt-< / Alt->              - vorheriger / nächster Buffer
nano file1 file2           - mehrere Dateien öffnen

## Rechtschreibprüfung
Ctrl-t                   - Rechtschreibprüfung starten (benötigt spell-Paket)

## Info
Ctrl-g                   - Hilfe anzeigen
Ctrl-c                    - Cursor-Position anzeigen
Alt-d                      - Wort-/Zeilen-/Zeichenanzahl

## Nützliche Start-Flags
nano -m file              - Maus aktivieren
nano -i file               - Auto-Einrückung
nano -T 4 file              - Tabbreite 4
nano -w file                - kein Zeilenumbruch
nano -B file                 - Backup vor Bearbeitung

## Konfiguration (~/.nanorc)
set linenumbers            - Zeilennummern anzeigen
set autoindent              - Auto-Einrückung
set tabsize 4                - Tab-Breite
set tabstospaces              - Tabs als Leerzeichen einfügen
set softwrap                  - lange Zeilen umbrochen anzeigen
set constantshow              - Cursor-Position dauerhaft anzeigen
set mouse                    - Maus aktivieren
include /usr/share/nano/*.nanorc  - Syntax-Highlighting laden
