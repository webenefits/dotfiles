# ddev

## Projekt einrichten
ddev config                                - Projekt interaktiv konfigurieren
ddev config --auto                         - Konfiguration mit erkannten Defaults
ddev config --update                       - Einstellungen aus Projekt neu erkennen
ddev config --project-type=typo3           - Projekttyp setzen (typo3, wordpress, shopware6…)
ddev config --docroot=public               - Docroot festlegen
ddev config --php-version=8.3              - PHP-Version setzen
ddev config --database=mariadb:10.11       - Datenbanktyp und -version setzen
ddev config --webserver-type=apache-fpm    - Webserver wählen (nginx-fpm/apache-fpm)
ddev config global --performance-mode=mutagen - globale Einstellungen ändern

## Lebenszyklus
ddev start                                 - Projekt starten (Alias: ddev add)
ddev start --all                           - alle Projekte starten
ddev start --no-cache                      - Container ohne Docker-Cache neu bauen
ddev stop                                  - Projekt stoppen, Daten bleiben erhalten
ddev stop --all                            - alle Projekte stoppen
ddev stop --snapshot                       - vor dem Stoppen DB-Snapshot anlegen
ddev restart                               - Projekt neu starten (nach Config-Änderung)
ddev poweroff                              - alle DDEV-Container systemweit stoppen
ddev delete                                - Projekt inkl. Datenbank entfernen
ddev delete --omit-snapshot                - löschen ohne Sicherungs-Snapshot
ddev delete images                         - DDEV-Docker-Images entfernen
ddev clean --all                           - alle von DDEV erzeugten Artefakte löschen

## Status & Info
ddev describe                              - URLs, DB-Zugang, Services (Alias: status)
ddev list                                  - alle Projekte mit Status auflisten
ddev list --active-only                    - nur laufende Projekte
ddev logs                                  - Logs des Web-Containers
ddev logs -f                               - Logs live mitverfolgen
ddev logs --service=db                     - Logs eines bestimmten Services
ddev version                               - DDEV- und Komponenten-Versionen
ddev tui                                   - interaktives Terminal-Dashboard
ddev aliases                               - alle verfügbaren Befehls-Aliase

## Im Container arbeiten
ddev ssh                                   - Shell im Web-Container öffnen
ddev ssh --service=db                      - Shell im DB-Container öffnen
ddev ssh -d /var/www/html/public           - Shell in bestimmtem Verzeichnis
ddev exec <befehl>                         - Befehl im Web-Container ausführen
ddev exec --service=db <befehl>            - Befehl in anderem Service ausführen
ddev exec -u root <befehl>                 - Befehl als root ausführen
ddev . <befehl>                            - Kurzform für ddev exec
ddev php <args>                            - PHP im Web-Container ausführen
ddev php -v                                - PHP-Version im Container prüfen

## Composer & Frontend
ddev composer install                      - Composer im Container ausführen (Alias: co)
ddev composer require <paket>              - Paket installieren
ddev composer update <paket>               - Paket aktualisieren
ddev composer create-project <paket> -y    - neues Projekt im Container aufsetzen
ddev npm install                           - npm im Web-Container ausführen
ddev npm run build                         - npm-Script ausführen
ddev yarn install                          - yarn im Web-Container ausführen
ddev yarn --cwd <pfad> build               - yarn in Unterverzeichnis ausführen

## Datenbank
ddev import-db --file=dump.sql.gz          - Dump importieren (.sql/.gz/.zip/.bz2)
ddev import-db --file=dump.sql --no-drop   - importieren ohne vorheriges Leeren
ddev import-db --database=zweite           - in bestimmte Datenbank importieren
ddev export-db --file=dump.sql.gz          - Datenbank exportieren (gzip default)
ddev export-db --gzip=false -f dump.sql    - unkomprimiert exportieren
ddev mysql                                 - MySQL-Client im DB-Container öffnen
ddev mariadb                               - MariaDB-Client öffnen
ddev psql                                  - PostgreSQL-Client öffnen
ddev mysql -uroot -proot                   - als root auf die DB verbinden
ddev sequelace / tableplus / dbeaver       - DB-GUI mit Projekt-Zugangsdaten öffnen
ddev heidisql                              - HeidiSQL öffnen (Windows/WSL2)

## Snapshots
ddev snapshot                              - Datenbank-Snapshot anlegen
ddev snapshot --name=vor-update            - benannten Snapshot anlegen
ddev snapshot --list                       - vorhandene Snapshots auflisten
ddev snapshot restore --latest             - letzten Snapshot einspielen
ddev snapshot restore <name>               - bestimmten Snapshot einspielen
ddev snapshot --cleanup                    - alle Snapshots des Projekts löschen

## Dateien & Uploads
ddev import-files --source=files.tar.gz    - Upload-Dateien ins Projekt importieren
ddev import-files --source=./files --target=fileadmin - in bestimmtes Zielverzeichnis

## CMS & Frameworks
ddev typo3 <befehl>                        - TYPO3-CLI (typo3 cache:flush, …)
ddev wp <befehl>                           - WP-CLI (wp plugin list, wp search-replace)
ddev drush <befehl>                        - Drush für Drupal/Backdrop
ddev magento <befehl>                      - Magento-CLI (Projekttyp magento2)
ddev artisan <befehl>                      - Laravel Artisan (Alias: art)
ddev console <befehl>                      - Symfony Console
ddev exec bin/console <befehl>             - Shopware 6 CLI (bin/console)
ddev exec vendor/bin/oe-console <befehl>   - OXID eSales Console

## Xdebug & Profiling
ddev xdebug on                             - Xdebug aktivieren (Alias: enable, true)
ddev xdebug off                            - Xdebug deaktivieren (kostet Performance)
ddev xdebug status                         - Status von Xdebug anzeigen
ddev xdebug toggle                         - Xdebug umschalten
ddev xhprof on / off / status              - XHProf-Profiling steuern
ddev xhgui on / launch                     - XHGui-Oberfläche aktivieren / öffnen
ddev blackfire on / off / status           - Blackfire-Profiling steuern

## Browser, Mail & Sharing
ddev launch                                - Projekt-URL im Browser öffnen
ddev launch /typo3                         - bestimmten Pfad öffnen
ddev launch --mailpit                      - Mailpit-Oberfläche öffnen
ddev mailpit                               - abgefangene Mails im Browser ansehen
ddev share                                 - Projekt per ngrok/cloudflared öffentlich teilen
ddev share --provider=cloudflared          - Tunnel-Provider wählen
ddev hostname --remove-inactive            - verwaiste hosts-Einträge aufräumen

## Add-ons
ddev add-on list                           - verfügbare Add-ons anzeigen
ddev add-on list --installed               - installierte Add-ons anzeigen
ddev add-on search <begriff>               - Add-on-Registry durchsuchen
ddev add-on get <name>                     - Add-on installieren (Alias: install)
ddev add-on get ddev/ddev-redis            - Add-on per owner/repo installieren
ddev add-on remove <name>                  - Add-on entfernen

## Hosting-Provider
ddev pull <provider>                       - DB & Dateien vom Hoster holen (pantheon, acquia…)
ddev pull <provider> --skip-files          - nur Datenbank holen
ddev push <provider>                       - DB & Dateien zum Hoster hochladen
ddev auth ssh                              - SSH-Keys in den ddev-ssh-agent laden

## Performance (Mutagen)
ddev mutagen status                        - Sync-Status anzeigen
ddev mutagen sync                          - Synchronisation manuell anstoßen
ddev mutagen monitor                       - Sync fortlaufend beobachten
ddev mutagen reset                         - Projekt stoppen und Sync-Volume löschen
ddev mutagen logs                          - Mutagen-Logs live anzeigen

## Diagnose & Wartung
ddev utility diagnose                      - Docker, Netzwerk und HTTPS prüfen
ddev utility test                          - vollständige Diagnose-Suite ausführen
ddev utility tls-diagnose                  - TLS/mkcert-Vertrauensstellung prüfen
ddev utility port-diagnose                 - Prozesse auf belegten DDEV-Ports finden
ddev utility rebuild                       - Docker-Cache neu bauen (Alias: refresh)
ddev utility compose-config                - erzeugte docker-compose-Config ausgeben
ddev utility configyaml                    - aufbereitete YAML-Konfiguration anzeigen
ddev utility check-custom-config           - eigene Configs unter .ddev auflisten
ddev utility download-images               - DDEV-Images vorab laden
ddev utility migrate-database <typ:version> - DB-Typ/-Version migrieren
ddev dotenv set .env --app-key=wert        - APP_KEY in .env schreiben (Flag → ENV_KEY)
ddev dotenv get .env --app-key             - Wert von APP_KEY aus .env lesen

## Sonstiges
ddev help <befehl>                         - Hilfe zu einem Befehl anzeigen
ddev <befehl> --json-output                - Ausgabe als JSON (Alias: -j)
ddev self-upgrade                          - Upgrade-Anleitung für DDEV anzeigen
