# yazi

## Navigation
h / j / k / l         - links / runter / hoch / rechts (rein ins Verzeichnis)
H / L                   - Verzeichnis-History zurück / vorwärts
K / J                   - Preview 5 Einheiten hoch / runter scrollen
gg / G                 - zum Anfang / Ende der Liste
Ctrl-d / Ctrl-u          - halbe Seite runter / hoch
z                       - cd/reveal via fzf
Z                       - cd via zoxide
g Space                 - cd/reveal via interaktiven Prompt
g h / g c / g d          - zu ~ / ~/.config / ~/Downloads springen

## Auswahl
Space                  - Datei(en) selektieren
v                        - visueller Modus (Selektion)
V                        - visueller Modus (Deselektion)
Ctrl-a                    - alle selektieren
Ctrl-r                    - Auswahl invertieren
Esc                      - Auswahl abbrechen

## Dateioperationen
o / O                    - öffnen / interaktiv öffnen
Enter                    - öffnen
Tab                      - Dateiinfo anzeigen
y / x / p                - kopieren (yank) / ausschneiden / einfügen
P                        - einfügen, überschreibt falls Ziel existiert
Y / X                     - Yank-Status abbrechen
d                        - in Trash löschen
D                        - permanent löschen
a                        - neue Datei/Ordner erstellen (Ordner mit trailing /)
r                        - umbenennen
.                        - versteckte Dateien anzeigen/ausblenden
;                        - Shell-Befehl ausführen
:                        - Shell-Befehl ausführen (blockierend bis fertig)
-  / _                    - Symlink (absolut / relativ) der geyankten Dateien
Ctrl+-                    - Hardlink der geyankten Dateien

## Pfade kopieren
c c                     - Dateipfad kopieren
c d                     - Verzeichnispfad kopieren
c f                     - Dateiname kopieren
c n                     - Dateiname ohne Extension kopieren

## Suchen & Filtern
f                       - Dateien filtern
/ / ?                    - nächste / vorherige Datei finden
n / N                    - zum nächsten / vorherigen Fund springen
s                        - Dateien nach Name suchen (fd)
S                        - Dateien nach Inhalt suchen (ripgrep)
Ctrl-s                    - laufende Suche abbrechen

## Linemode (Zusatzspalte)
m s / m p               - Größe / Berechtigungen anzeigen
m m / m b               - Änderungszeit / Erstellzeit anzeigen
m o / m n               - Besitzer / nichts anzeigen

## Sortierung
, m / , M                - nach Änderungszeit (/ umgekehrt)
, b / , B                - nach Erstellzeit (/ umgekehrt)
, e / , E                - nach Extension (/ umgekehrt)
, a / , A                - alphabetisch (/ umgekehrt)
, n / , N                - natürlich (/ umgekehrt)
, s / , S                - nach Größe (/ umgekehrt)
, r                      - zufällig

## Tabs
t t                     - neuer Tab im aktuellen Verzeichnis
1-9                     - zu Tab n springen
[ / ]                    - vorheriger / nächster Tab
{ / }                    - aktuellen Tab mit vorherigem/nächstem tauschen
Ctrl-c                    - aktuellen Tab schließen

## Sonstiges
q / Q                    - beenden (Q: ohne CWD-Wechsel bei y-Wrapper)
w                        - Task-Manager anzeigen (laufende Kopier-/Löschjobs)
Ctrl-z                    - yazi suspendieren (fg zum Zurückkehren)
F1 / ~                   - Hilfemenü öffnen
