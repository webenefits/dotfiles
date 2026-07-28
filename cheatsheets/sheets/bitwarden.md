# bitwarden

## Grundlagen
Clients: Web-Vault, Browser-Extension, Desktop-App, CLI  - laufen gegen die interne Vaultwarden-Instanz (Bitwarden-kompatibel)
Die Suche läuft im Client (Lunr)            - durchsucht nur den entschlüsselten Tresor, nicht den Server

## Suche – Basis
begriff                     - Basissuche in Name, ID, Login-Benutzername und URI
>begriff                    - Präfix > schaltet die erweiterte Suche mit Feldern & Operatoren frei

## Suche – Felder (Präfix >)
>name:begriff               - im Eintragsnamen suchen
>subtitle:begriff           - Untertitel: Benutzername, Kartenmarke/-endung oder Identitätsname
>login.username:begriff     - nach Login-Benutzername suchen
>login.uris:begriff         - nach Login-Host/URL suchen
>notes:begriff              - in Notizen suchen (nur ganze Wörter)
>fields:begriff             - in Namen/Werten eigener Felder (nur Textfelder)
>attachments:begriff        - nach Dateinamen von Anhängen suchen
>shortid:1a2b3c4d           - über die ersten 8 Zeichen der Eintrags-ID
>organizationid:<id>        - nach Organisations-ID filtern

## Suche – Operatoren (Präfix >)
>+begriff                   - Pflicht-Term: Ergebnis muss den Begriff enthalten
>-begriff                   - Ausschluss: Ergebnis darf den Begriff nicht enthalten
>+name:Turbo +name:Tax      - mehrere Pflicht-Terme kombinieren
>login.uris:*example.com    - Platzhalter * steht für beliebige Zeichen
>name:email~1               - unscharfe Suche, Editierdistanz 1 (findet z. B. auch "gmail")
>organizationid:*           - alle Einträge, die einer Organisation zugeordnet sind
>-organizationid:*          - alle Einträge ohne Organisation
AND / OR / NOT / "phrase"   - werden nicht unterstützt; Terme stattdessen mit + / - kombinieren

## Browser-Extension – Kürzel (Standard)
Ctrl-Shift-L                - letzten passenden Login autofillen (erneut = nächster Treffer; TOTP wird danach kopiert)
Ctrl-Shift-Y                - Extension öffnen/aktivieren
Ctrl-Shift-9                - Passwort generieren und in die Zwischenablage kopieren
Ctrl-Shift-N                - Tresor sperren

## Desktop-App – Kürzel (Mac: Cmd statt Ctrl)
Ctrl-f                      - Tresor durchsuchen
Ctrl-l                      - Tresor sperren
Ctrl-g                      - Passwort-Generator öffnen
Ctrl-n                      - neuen Login anlegen
Ctrl-u                      - Benutzername des Eintrags kopieren
Ctrl-p                      - Passwort des Eintrags kopieren
Ctrl-t                      - TOTP-Code des Eintrags kopieren
Ctrl-,                      - Einstellungen öffnen
Ctrl-Shift-R                - App neu laden
Ctrl-q                      - App beenden

## CLI (bw) – Installation & Anmeldung
npm install -g @bitwarden/cli       - CLI installieren (alternativ Standalone-Binary/Snap)
bw config server https://<host>     - CLI vor dem Login auf die interne Instanz zeigen lassen
bw login                            - mit E-Mail & Passwort anmelden (für interaktive Nutzung empfohlen)
bw login --apikey                   - per API-Key anmelden (aus BW_CLIENTID / BW_CLIENTSECRET)
bw login --sso                      - per SSO anmelden
bw logout                           - abmelden

## CLI (bw) – Session
bw unlock                           - Tresor entsperren, gibt den Session-Key aus
export BW_SESSION="<key>"           - Session-Key setzen, damit Folgebefehle nicht erneut fragen
bw unlock --passwordenv BW_PASSWORD - Passphrase aus einer Umgebungsvariable lesen
bw lock                             - Tresor sperren und Session verwerfen
bw status                           - Status ausgeben: unauthenticated / locked / unlocked
bw sync                             - lokalen Tresor mit dem Server abgleichen

## CLI (bw) – Lesen & Suchen
bw list items                       - alle Einträge als JSON ausgeben
bw list items --search <begriff>    - Einträge nach Begriff filtern
bw list folders                     - Ordner auflisten
bw list collections                 - Sammlungen auflisten
bw list organizations               - Organisationen auflisten
bw get item <id|name>               - vollständigen Eintrag holen
bw get username <id|name>           - Benutzernamen ausgeben
bw get password <id|name>           - Passwort ausgeben
bw get totp <id|name>               - aktuellen TOTP-Code ausgeben
bw get uri <id|name>                - hinterlegte URL ausgeben
bw get notes <id|name>              - Notizen ausgeben
bw get exposed <id|name>            - prüfen, ob das Passwort in Leaks auftaucht (HIBP)
bw get attachment <name> --itemid <id> --output <pfad> - Anhang eines Eintrags herunterladen

## CLI (bw) – Ändern
bw get template item | jq '.name="Neu"' | bw encode | bw create item - Eintrag aus Vorlage anlegen
bw create folder <base64-json>      - Ordner aus base64-kodiertem JSON anlegen
bw edit item <id> <base64-json>     - bestehenden Eintrag bearbeiten
bw delete item <id>                 - Eintrag in den Papierkorb verschieben
bw delete item <id> --permanent     - Eintrag endgültig löschen
bw restore item <id>                - Eintrag aus dem Papierkorb wiederherstellen
bw encode                           - stdin Base64-kodieren (Eingabe für create/edit)

## CLI (bw) – Generieren & Daten
bw generate                         - zufälliges Passwort erzeugen
bw generate -uln --length 20        - 20 Zeichen aus Groß-, Kleinbuchstaben und Zahlen
bw generate -ulns --length 28       - dieselben plus Sonderzeichen
bw generate --passphrase --words 5 --separator - - Passphrase aus 5 Wörtern
bw export --format json --output <pfad>          - Tresor unverschlüsselt als JSON exportieren
bw export --format encrypted_json --password <pw> - passwortgeschützt exportieren
bw import <format> <pfad>           - Daten importieren (bw import --help listet die Formate)
bw serve --port 8087                - lokale REST-API zum Tresor starten
