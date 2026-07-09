# shopware

## Aufruf
bin/console <befehl>                       - Shopware-CLI im Projektroot ausführen
ddev exec bin/console <befehl>             - innerhalb eines DDEV-Projekts
bin/console list                           - alle verfügbaren Befehle auflisten
bin/console <befehl> -h                    - Hilfe zu einem Befehl anzeigen
bin/console <befehl> -n                    - ohne Rückfragen ausführen (CI/Deploy)

## Cache
bin/console cache:clear                    - Anwendungscache leeren
bin/console cache:clear:all                - alle Pools leeren, alte Kernel entfernen
bin/console cache:clear:http               - nur den HTTP-Cache leeren
bin/console cache:clear:delayed            - verzögerte Cache-Keys invalidieren
bin/console cache:warmup                   - Cache vorwärmen
bin/console cache:pool:list                - verfügbare Cache-Pools anzeigen
bin/console cache:pool:prune               - abgelaufene Pool-Einträge entfernen
bin/console http:cache:warm:up             - HTTP-Cache vorwärmen

## Plugins
bin/console plugin:refresh                 - Plugin-Liste mit Dateisystem abgleichen
bin/console plugin:list                    - alle Plugins mit Status anzeigen
bin/console plugin:install <name>          - Plugin installieren
bin/console plugin:install --activate <name> - installieren und direkt aktivieren
bin/console plugin:activate <name>         - Plugin aktivieren
bin/console plugin:deactivate <name>       - Plugin deaktivieren
bin/console plugin:update <name>           - Plugin aktualisieren
bin/console plugin:update:all              - alle verfügbaren Updates einspielen
bin/console plugin:uninstall <name>        - Plugin deinstallieren
bin/console plugin:create <name>           - Plugin-Grundgerüst erzeugen
bin/console plugin:zip-import <datei>      - Plugin aus ZIP-Archiv importieren

## Theme & Storefront
bin/console theme:compile                  - Themes kompilieren
bin/console theme:change                   - aktives Theme wechseln
bin/console theme:change --all <name>      - Theme für alle Sales Channels setzen
bin/console theme:refresh                  - Theme-Konfiguration neu einlesen
bin/console theme:create <name>            - Theme-Grundgerüst erzeugen
bin/console theme:dump                     - Theme-Konfiguration exportieren
bin/console assets:install                 - Bundle-Assets nach public/ kopieren

## Administration
bin/console administration:build           - Administration bauen
bin/console administration:delete-files-after-build - Build-Reste entfernen
bin/console bundle:dump                    - JSON-Konfiguration aktiver Bundles

## DAL & Indizes
bin/console dal:refresh:index              - alle Entitäts-Indizes neu aufbauen
bin/console dal:refresh:index --only=product.indexer - nur einen Indexer laufen lassen
bin/console dal:validate                   - DAL-Definitionen validieren
bin/console dal:create:entities            - Entity-Klassen generieren
bin/console dal:create:schema              - Datenbankschema erzeugen
bin/console dal:migration:create           - Migration aus Entity-Schema erzeugen

## Datenbank & Migrationen
bin/console database:migrate               - Migrationen ausführen
bin/console database:migrate --all         - alle Migrationen ausführen
bin/console database:migrate-destructive   - destruktive Migrationen ausführen
bin/console database:create-migration      - neue Migrationsdatei anlegen
bin/console database:refresh-migration     - Migrationsstatus zurücksetzen
bin/console database:clean-personal-data   - personenbezogene Daten entfernen

## System & Installation
bin/console system:install                 - Shopware 6 installieren
bin/console system:install --create-database --basic-setup - inkl. DB und Grundsetup
bin/console system:setup                   - Systemkonfiguration (.env) anlegen
bin/console system:check                   - Systemzustand prüfen
bin/console system:is-installed            - Installationsstatus prüfen (Exit-Code)
bin/console system:config:get <key>        - Konfigurationswert lesen
bin/console system:config:set <key> <wert> - Konfigurationswert setzen
bin/console system:update:prepare          - Update vorbereiten
bin/console system:update:finish           - Update abschließen
bin/console system:generate-app-secret     - neues App-Secret erzeugen

## Sales Channels
bin/console sales-channel:list             - Sales Channels auflisten
bin/console sales-channel:create           - Sales Channel anlegen
bin/console sales-channel:create:storefront - Storefront-Channel anlegen
bin/console sales-channel:update:domain <domain> - Domain des Channels ändern
bin/console sales-channel:maintenance:enable - Wartungsmodus aktivieren
bin/console sales-channel:maintenance:disable - Wartungsmodus deaktivieren

## Benutzer & Integrationen
bin/console user:create <name>             - Admin-Benutzer anlegen
bin/console user:create <name> --admin     - als Administrator anlegen
bin/console user:list                      - Benutzer auflisten
bin/console user:change-password <name>    - Passwort ändern
bin/console integration:create <label>     - Integration mit Zugangsdaten anlegen

## Scheduled Tasks & Messenger
bin/console scheduled-task:register        - alle Tasks registrieren
bin/console scheduled-task:list            - Tasks mit Status anzeigen
bin/console scheduled-task:run             - Scheduler-Worker starten
bin/console scheduled-task:run-single <name> - einzelnen Task ausführen
bin/console messenger:consume async        - Queue abarbeiten
bin/console messenger:consume async --time-limit=60 - mit Zeitlimit (Cron)
bin/console messenger:stats                - Anzahl Nachrichten je Transport
bin/console messenger:failed:show          - fehlgeschlagene Nachrichten anzeigen
bin/console messenger:failed:retry         - fehlgeschlagene Nachrichten wiederholen
bin/console messenger:stop-workers         - Worker sauber beenden

## Medien & Produkte
bin/console media:generate-thumbnails      - Thumbnails erzeugen
bin/console media:delete-unused            - ungenutzte Medien löschen
bin/console media:generate-media-types     - Medientypen neu ermitteln
bin/console product-export:generate        - Produktexport-Datei erzeugen
bin/console import:entity <datei>          - Entitäten aus CSV importieren
bin/console import-export:delete-expired   - abgelaufene Import/Export-Dateien löschen
bin/console sitemap:generate               - Sitemaps erzeugen
bin/console number-range:migrate           - Nummernkreis-Speicher migrieren

## Elasticsearch
bin/console es:index                       - alle Entitäten neu indizieren
bin/console es:status                      - Indexstatus anzeigen
bin/console es:reset                       - Suchindex zurücksetzen
bin/console es:index:cleanup               - veraltete Indizes entfernen
bin/console es:mapping:update              - Mapping der Indizes aktualisieren

## Apps & Store
bin/console app:install <name>             - App installieren
bin/console app:install --activate <name>  - installieren und aktivieren
bin/console app:list                       - Apps auflisten
bin/console app:refresh                    - Apps neu einlesen
bin/console app:activate / app:deactivate  - App aktivieren / deaktivieren
bin/console app:uninstall <name>           - App deinstallieren
bin/console app:validate                   - manifest.xml auf Fehler prüfen
bin/console app:url-change:resolve         - geänderte App-URL auflösen
bin/console store:login                    - am Shopware Store anmelden
bin/console store:download -p <name>       - Plugin aus dem Store laden

## Plugin-Entwicklung (make)
bin/console make:plugin:plugin-class       - Basis-Plugin-Klasse erzeugen
bin/console make:plugin:command            - CLI-Command-Gerüst erzeugen
bin/console make:plugin:entity             - Entity-Gerüst erzeugen
bin/console make:plugin:event-subscriber   - Event-Subscriber erzeugen
bin/console make:plugin:scheduled-task     - Scheduled Task erzeugen
bin/console make:plugin:storefront-controller - Storefront-Controller erzeugen
bin/console make:plugin:store-api-route    - Store-API-Route erzeugen
bin/console make:plugin:admin-module       - Admin-Modul erzeugen
bin/console make:plugin:config             - System-Config-Gerüst erzeugen

## Debug & Lint
bin/console debug:container <service>      - Services im DI-Container anzeigen
bin/console debug:router                   - alle Routen anzeigen
bin/console debug:event-dispatcher         - registrierte Listener anzeigen
bin/console debug:business-events          - Business Events anzeigen
bin/console debug:config <extension>       - Konfiguration einer Extension anzeigen
bin/console debug:twig                     - Twig-Funktionen und -Filter anzeigen
bin/console debug:scheduler                - Schedules und Nachrichten anzeigen
bin/console debug:dotenv                   - geladene .env-Variablen anzeigen
bin/console lint:twig                      - Twig-Templates validieren
bin/console lint:container                 - Service-Argumenttypen prüfen
bin/console lint:yaml <pfad>               - YAML-Dateien validieren
bin/console snippets:validate              - Snippet-Dateien prüfen
bin/console mailer:test <empfaenger>       - Test-Mail versenden
bin/console feature:list                   - Feature-Flags anzeigen
bin/console feature:enable <flag>          - Feature-Flag aktivieren
