# typo3

## Aufruf
vendor/bin/typo3 <befehl>                  - Composer-Installation (Standard)
typo3/sysext/core/bin/typo3 <befehl>       - Classic-Mode-Installation
ddev typo3 <befehl>                        - innerhalb eines DDEV-Projekts
vendor/bin/typo3 list                      - alle verfügbaren Befehle auflisten
vendor/bin/typo3 help <befehl>             - Hilfe zu einem Befehl anzeigen
vendor/bin/typo3 <befehl> -n               - ohne Rückfragen ausführen (CI/Deploy)

## Setup & Installation
typo3 setup                                - TYPO3 per CLI einrichten (interaktiv/ENV)
typo3 setup --no-interaction               - Setup mit Umgebungsvariablen ausführen
typo3 setup:begroups:default               - Standard-Backend-Benutzergruppen anlegen

## Cache
typo3 cache:flush                          - alle Caches leeren
typo3 cache:flush --group pages            - nur eine Cache-Gruppe leeren (pages/system/di)
typo3 cache:warmup                         - Caches vorwärmen
typo3 cache:warmup --group system          - nur eine Cache-Gruppe vorwärmen

## Extensions
typo3 extension:list                       - verfügbare Extensions anzeigen
typo3 extension:setup                      - alle Extensions einrichten (Schema, Daten)
typo3 extension:setup --extension=<key>    - nur eine Extension einrichten
typo3 language:update                      - Sprachdateien aktualisieren

## Upgrade
typo3 upgrade:list                         - verfügbare Upgrade-Wizards anzeigen
typo3 upgrade:list --all                   - auch bereits ausgeführte Wizards
typo3 upgrade:run                          - alle offenen Upgrade-Wizards ausführen
typo3 upgrade:run <identifier>             - einzelnen Wizard ausführen
typo3 upgrade:mark:undone <identifier>     - Wizard als nicht ausgeführt markieren

## Backend & Benutzer
typo3 backend:lock                         - Backend sperren (z. B. für Wartung)
typo3 backend:unlock                       - Backend wieder freigeben
typo3 backend:user:create                  - Backend-Benutzer anlegen
typo3 backend:resetpassword                - Passwort-Reset für Backend-Nutzer anstoßen

## Scheduler
typo3 scheduler:run                        - fällige Scheduler-Tasks ausführen
typo3 scheduler:list                       - alle Scheduler-Tasks auflisten
typo3 scheduler:execute --task-id=<id>     - bestimmten Task sofort ausführen

## Sites & Konfiguration
typo3 site:list                            - konfigurierte Sites anzeigen
typo3 site:show <identifier>               - Site-Konfiguration ausgeben
typo3 site:sets:list                       - verfügbare Site Sets anzeigen (v13+)
typo3 lint:yaml <pfad>                     - YAML-Dateien auf Fehler prüfen

## Referenzindex & Integrität
typo3 referenceindex:update                - Referenzindex aktualisieren
typo3 referenceindex:update --check        - nur prüfen, nichts schreiben
typo3 redirects:checkintegrity             - Redirects auf Konflikte prüfen
typo3 redirects:cleanup                    - alte Redirects aufräumen

## Aufräumen (Vorsicht: löscht Daten)
typo3 cleanup:deletedrecords               - als gelöscht markierte Datensätze entfernen
typo3 cleanup:orphanrecords                - verwaiste Datensätze finden und löschen
typo3 cleanup:missingrelations             - Referenzen auf fehlende Datensätze finden
typo3 cleanup:flexforms                    - FlexForm-Felder ohne Datenstruktur bereinigen
typo3 cleanup:localprocessedfiles          - verarbeitete Dateien und Records löschen
typo3 cleanup:versions                     - ungültige versionierte Datensätze bereinigen
typo3 cleanup:previewlinks                 - abgelaufene Vorschau-Links entfernen

## Import / Export
typo3 impexp:export                        - Seitenbaum als T3D/XML exportieren
typo3 impexp:import <datei>                - T3D/XML in den Seitenbaum importieren

## Sonstiges
typo3 syslog:list                          - sys_log-Einträge der letzten 24 h anzeigen
typo3 mailer:spool:send                    - Mails aus dem Spool versenden
typo3 messenger:consume <transport>        - Messenger-Nachrichten verarbeiten
typo3 workspace:autopublish                - Workspaces mit Publikationsdatum freigeben
typo3 fluid:schema:generate                - XSD-Schemas für ViewHelper erzeugen

## Nicht im Core (Extension typo3_console)
typo3cms database:updateschema             - DB-Schema abgleichen (helhum/typo3-console)
typo3cms install:generatepackagestates     - PackageStates.php erzeugen
typo3cms upgrade:all                       - alle Upgrade-Wizards ausführen
