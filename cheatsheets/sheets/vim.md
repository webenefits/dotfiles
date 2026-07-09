# vim

## Bewegung
0 / ^ / $           - Zeilenanfang / erstes Zeichen / Zeilenende
g_                  - letztes Nicht-Blank-Zeichen der Zeile
gg / G              - Dateianfang / Dateiende
5gg / 5G            - zu Zeile 5 springen
w / b / e           - Wort vor / zurück / Wortende
W / B / E           - wie w/b/e, aber Wort inkl. Satzzeichen (WORD)
ge / gE             - rückwärts zum Wortende (klein/WORD)
{ / }               - Absatz vor / zurück
H / M / L           - Bildschirm oben / mitte / unten
fx / Fx             - zu nächstem/vorherigem Zeichen x springen
tx / Tx             - vor nächstes / nach vorheriges Zeichen x springen
; / ,               - letztes f/t/F/T wiederholen (vorwärts/rückwärts)
zz / zt / zb        - Cursor zentrieren / oben / unten positionieren
Ctrl-d / Ctrl-u      - halbe Seite runter / hoch
Ctrl-f / Ctrl-b      - ganze Seite runter / hoch
%                    - zu passender Klammer springen
gd / gD             - zu lokaler / globaler Deklaration springen
`` / ''              - zur Position vor dem letzten Sprung (exakt / Zeile)
g; / g,             - zur letzten / nächsten Änderungsposition (Changelist)

## Einfügemodus
i / I               - vor Cursor / am Zeilenanfang einfügen
a / A               - nach Cursor / am Zeilenende einfügen
o / O               - neue Zeile unter / über einfügen
ea                  - am Wortende einfügen
Ctrl-w (Insert)      - Wort vor Cursor löschen
Ctrl-r x (Insert)    - Inhalt von Register x einfügen

## Suchen & Ersetzen
/pattern             - vorwärts suchen
?pattern             - rückwärts suchen
n / N                - nächster / vorheriger Treffer
* / #                - Wort unter Cursor vorwärts / rückwärts suchen
:noh                 - Suchhighlight entfernen
:%s/foo/bar/g        - global im ganzen File
:%s/foo/bar/gc       - mit Bestätigung
:s/foo/bar/g         - nur aktuelle Zeile
:g/pattern/d         - alle Zeilen mit pattern löschen

## Editieren
dd / yy / p          - Zeile löschen / kopieren / einfügen
dw / cw              - Wort löschen / ändern
x / X                - Zeichen unter / vor Cursor löschen
d$ / D               - bis Zeilenende löschen
C / cc               - bis Zeilenende / ganze Zeile ändern
s / S                - Zeichen / Zeile löschen und einfügen (wie cl / cc)
u / Ctrl-r           - undo / redo
.                    - letzte Änderung wiederholen
ciw / diw            - inneres Wort ändern / löschen
ci" / ci(            - Inhalt in Anführungszeichen / Klammern ändern
cit / dit            - Inhalt eines HTML/XML-Tags ändern / löschen
r / R                - ein Zeichen ersetzen / Overwrite-Modus
~ / g~w              - Groß-/Kleinschreibung toggeln (Zeichen / Wort)
guw / gUw            - Wort klein / groß schreiben (auch guu/gUU für Zeile)
Ctrl-a / Ctrl-x       - Zahl unter Cursor erhöhen / verringern
J / gJ               - Zeile darunter anfügen (mit/ohne Leerzeichen)
xp                   - zwei Zeichen vertauschen
>> / <<              - Zeile ein-/ausrücken
gg=G                 - gesamten Buffer neu einrücken

## Visueller Modus
v / V / Ctrl-v        - Zeichen / Zeile / Block visuell
VG                    - zeilenweise bis Dateiende markieren
ggVG                  - gesamte Datei markieren
o                      - zum anderen Ende der Auswahl springen
> / <                 - ein-/ausrücken
u / U / ~             - Auswahl klein / groß schreiben / toggeln
gv                    - letzte Auswahl wiederherstellen
aw / ab / aB          - Wort / ()-Block / {}-Block auswählen
iw / ib / iB          - Wort / ()-Block / {}-Block ohne Umschließung
I / A (nach Ctrl-v)    - Block-Einfügen am Anfang / Ende der Auswahl

## Marken & Register
ma                    - Marke 'a' setzen
`a / 'a                - zu Marke a springen (exakt / Zeilenanfang)
:marks                - Markenliste anzeigen
"ayy / "ap             - in Register a kopieren / einfügen
"+y / "+p               - in/aus Systemzwischenablage
:reg                  - Registerinhalt anzeigen

## Fenster & Buffer
:vsp / :sp            - vertikaler / horizontaler Split
Ctrl-w v / Ctrl-w s     - dito, per Tastenkombination
Ctrl-w w               - zwischen Fenstern wechseln
Ctrl-w o                - alle anderen Fenster schließen (only)
Ctrl-w h/j/k/l          - gezielt zu Fenster links/unten/oben/rechts
Ctrl-w q                - Fenster schließen
Ctrl-w =                - alle Fenster gleich groß
:bn / :bp              - nächster / vorheriger Buffer
:ls / :buffers          - Buffer-Liste
:bd                    - Buffer schließen

## Tabs
:tabnew                - neuen Tab öffnen
gt / gT                - nächster / vorheriger Tab
#gt                    - zu Tab Nummer # springen
:tabc                  - aktuellen Tab schließen

## Folding
za                     - Fold toggeln
zo / zc                - Fold öffnen / schließen
zR / zM                - alle Folds öffnen / schließen

## Diff
]c / [c                - zum nächsten / vorherigen Unterschied springen
do / dp                - Unterschied holen / übertragen
:diffthis              - aktuelles Fenster in Diff-Modus

## Sonstiges
:w / :q / :wq / :q!    - speichern / verlassen / speichern+verlassen / erzwingen
ZZ / ZQ                 - speichern+verlassen / verlassen ohne speichern
:e datei                - Datei öffnen
:w !sudo tee %           - Datei mit sudo speichern (wenn ohne sudo geöffnet)
Ctrl-o / Ctrl-i          - vorherige / nächste Cursor-Position (Jumplist)
qa ... q / @a             - Makro in Register a aufnehmen / abspielen
@@                       - letztes Makro wiederholen
K                        - man-Page zu Wort unter Cursor öffnen
