# screen

## Session starten
screen                  - neue Session starten
screen -S name          - neue Session mit Namen "name" starten
screen -t titel         - erstes Fenster mit Titel benennen
screen befehl args      - Session direkt mit Befehl statt Shell starten
screen -dm              - Session sofort im Hintergrund (detached) starten
screen -dmS name befehl - benannte Detached-Session mit Befehl starten (z. B. für Dienste)
screen -c datei         - alternative Konfigdatei statt ~/.screenrc nutzen

## Session auflisten & verbinden
screen -ls              - laufende Sessions auflisten
screen -r               - an einzige Detached-Session anhängen
screen -r name          - an Session "name" (oder PID) anhängen
screen -R               - anhängen falls möglich, sonst neue Session starten
screen -d -r            - anderswo laufende Session lösen und hier anhängen
screen -x               - an bereits attachte Session anhängen (Multi-Display, gemeinsam)
screen -x name          - an benannte attachte Session anhängen (Screen-Sharing)
screen -d name          - Session "name" von außen detachen
screen -wipe            - tote/kaputte Sessions aus der Liste entfernen

## Prefix (Standard: Ctrl-a)
Ctrl-a Ctrl-a           - zum zuletzt genutzten Fenster wechseln
Ctrl-a a                - literales Ctrl-a an die Anwendung senden
Ctrl-a ?                - Hilfe / Liste aller Tastenbelegungen
Ctrl-a :                - Screen-Befehlszeile öffnen (Kommandos direkt eingeben)

## Fenster verwalten
Ctrl-a c                - neues Fenster (Shell) erstellen
Ctrl-a Ctrl-c           - alternativ neues Fenster erstellen
Ctrl-a n / Ctrl-a Space - nächstes Fenster
Ctrl-a p / Ctrl-a Bksp  - vorheriges Fenster
Ctrl-a 0-9              - direkt zu Fenster 0-9 springen
Ctrl-a '                - zu Fenster nach Nummer/Name springen (Prompt)
Ctrl-a "                - Fensterliste zur Auswahl anzeigen
Ctrl-a w                - Fensterliste in der Statuszeile anzeigen
Ctrl-a A                - aktuelles Fenster umbenennen (Titel setzen)
Ctrl-a k                - aktuelles Fenster schließen (kill, mit Rückfrage)
Ctrl-a \                - alle Fenster schließen und Screen beenden (Rückfrage)
Ctrl-a Ctrl-\           - dito, ohne Rückfrage beenden (quit)

## Detach & Sperren
Ctrl-a d                - Session lösen (detach), läuft im Hintergrund weiter
Ctrl-a D D              - detachen und die aufrufende Shell zusätzlich abmelden
Ctrl-a x                - Bildschirm mit Passwort sperren (lockscreen)
Ctrl-a z                - Screen suspendieren (Ctrl-z), mit fg zurückholen

## Splits / Regionen
Ctrl-a S                - horizontal splitten (obere/untere Region)
Ctrl-a |                - vertikal splitten (linke/rechte Region)
Ctrl-a Tab              - Fokus zur nächsten Region wechseln
Ctrl-a X                - aktuelle Region schließen (Fenster läuft weiter)
Ctrl-a Q                - alle Regionen bis auf die aktuelle schließen
Ctrl-a :resize n        - aktuelle Region auf n Zeilen/Spalten setzen
Ctrl-a :focus           - Fokus zyklisch zur nächsten Region (wie Tab)
Hinweis: Neue Regionen sind leer — mit Ctrl-a c oder Ctrl-a " ein Fenster hineinlegen.

## Copy- / Scrollback-Modus
Ctrl-a Esc / Ctrl-a [   - Copy/Scroll-Modus starten (im Puffer zurückblättern)
Leertaste (im Modus)    - Markierung starten, erneut = Auswahl kopieren
Enter                   - Markierung setzen bzw. Auswahl beenden
Ctrl-a ]                - kopierten Puffer einfügen (paste)
Ctrl-b / Ctrl-f (Modus) - Seite hoch / runter blättern
h j k l / Pfeile        - Cursor bewegen (vi-artig)
0 / $ (Modus)           - Zeilenanfang / Zeilenende
G (Modus)               - ans Ende des Puffers springen
/ pattern (Modus)       - im Puffer vorwärts suchen (? = rückwärts)
Ctrl-a > / Ctrl-a <     - Puffer in Datei schreiben / aus Datei lesen

## Logging & Aufzeichnung
Ctrl-a H                - Logging des Fensters in screenlog.n an/aus
Ctrl-a h                - Hardcopy: Bildschirminhalt in hardcopy.n schreiben
screen -L               - Session mit aktiviertem Logging starten
Ctrl-a M                - Monitor für Aktivität im Fenster an/aus
Ctrl-a _                - Monitor für Stille (Silence) im Fenster an/aus

## Anzeige & Sonstiges
Ctrl-a C                - Bildschirm leeren (clear)
Ctrl-a l                - Anzeige neu zeichnen (redraw)
Ctrl-a i                - Info zum aktuellen Fenster anzeigen
Ctrl-a t                - Uhrzeit / Systemlast anzeigen (time)
Ctrl-a F                - Fenstergröße an das Terminal anpassen (fit)
Ctrl-a *                - angeschlossene Displays anzeigen

## ~/.screenrc
escape ^Tt              - Prefix von Ctrl-a auf Ctrl-t umlegen
defscrollback 10000     - Scrollback-Puffergröße (Zeilen) je Fenster
startup_message off     - Copyright-Startbildschirm unterdrücken
altscreen on            - alternativen Schirm (z. B. less/vim) sauber verlassen
mousetrack on           - Regionen-Auswahl per Mausklick erlauben
vbell off               - visuelle statt akustischer Glocke deaktivieren
defutf8 on              - UTF-8 als Standard für neue Fenster
hardstatus alwayslastline "%{= kG}%H %{= kw}%-w%{= bW}%n %t%{-}%+w %=%c" - Statuszeile mit Fensterliste
screen -t htop 1 htop   - beim Start Fenster 1 "htop" mit htop öffnen
bind s                  - Standardbelegung der Taste s aufheben (Kollisionen lösen)

## screen vs. tmux
- screen ist quasi überall vorinstalliert; tmux bietet mehr (Copy-Mode, Scripting).
- Prefix screen = Ctrl-a, tmux = Ctrl-b.
- Regionen in screen sind zustandslos (Fenster wird zugewiesen), in tmux sind Panes eigenständig.
