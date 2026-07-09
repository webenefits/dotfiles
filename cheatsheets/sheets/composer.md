# composer

## Projekt starten
composer init                              - composer.json interaktiv anlegen
composer create-project <paket> <ordner>   - Projekt aus Paket erzeugen
composer create-project <paket> . --no-dev - ohne Dev-Abhängigkeiten aufsetzen
composer install                           - Abhängigkeiten aus composer.lock laden
composer install --no-dev                  - ohne require-dev installieren (Produktion)
composer install -o --no-dev               - Produktion mit optimiertem Autoloader
composer install --dry-run                 - nur anzeigen, was passieren würde

## Pakete verwalten
composer require <vendor/paket>            - Paket hinzufügen und installieren
composer require <vendor/paket>:^2.0       - mit Versions-Constraint hinzufügen
composer require --dev <vendor/paket>      - als Dev-Abhängigkeit hinzufügen
composer require <paket> --no-update       - nur in composer.json eintragen
composer remove <vendor/paket>             - Paket entfernen (Alias: rm)
composer remove --unused                   - nicht mehr benötigte Pakete entfernen
composer reinstall <vendor/paket>          - Paket sauber neu installieren
composer reinstall "acme/*"                - Pakete per Wildcard neu installieren

## Aktualisieren
composer update                            - alle Pakete aktualisieren (Alias: u)
composer update <vendor/paket>             - nur ein Paket aktualisieren
composer update "vendor/*"                 - Pakete per Wildcard aktualisieren
composer update -w <paket>                 - Paket inkl. seiner Abhängigkeiten
composer update -W <paket>                 - Paket inkl. aller Abhängigkeiten
composer update --lock                     - nur Hash in composer.lock erneuern
composer update --dry-run                  - Aktualisierung simulieren
composer update --prefer-stable            - stabile Versionen bevorzugen
composer update --with <paket>:2.0.1       - temporäres Constraint beim Update
composer bump                              - Untergrenzen auf installierte Versionen

## Informationen
composer show                              - installierte Pakete auflisten (Alias: info)
composer show <vendor/paket>               - Details zu einem Paket anzeigen
composer show -t                           - Abhängigkeiten als Baum anzeigen
composer show -l                           - installierte und neueste Versionen
composer show -p                           - Plattform-Pakete (php, ext-*) anzeigen
composer show -N                           - nur Paketnamen ausgeben
composer outdated                          - veraltete Pakete anzeigen
composer outdated -D                       - nur direkte Abhängigkeiten
composer outdated -M                       - nur Major-Updates anzeigen
composer search <begriff>                  - Packagist durchsuchen
composer browse <vendor/paket>             - Paket-Homepage im Browser öffnen
composer licenses                          - Lizenzen aller Pakete auflisten
composer fund                              - Spendenlinks der Abhängigkeiten

## Abhängigkeiten analysieren
composer why <vendor/paket>                - wer benötigt dieses Paket (Alias: depends)
composer why <paket> -t                    - als rekursiven Baum anzeigen
composer why-not <paket> <version>         - was blockiert diese Version (prohibits)
composer why-not php 8.3                   - was verhindert PHP 8.3
composer depends <paket> -r                - rekursiv auflösen

## Prüfen & Diagnose
composer validate                          - composer.json/lock prüfen
composer validate --strict                 - Warnungen als Fehler behandeln
composer audit                             - auf Sicherheitslücken prüfen
composer audit --no-dev                    - nur Produktions-Pakete prüfen
composer audit -f summary                  - Kurzfassung ausgeben
composer check-platform-reqs               - PHP-/Extension-Anforderungen prüfen
composer diagnose                          - Umgebung auf typische Probleme prüfen
composer status                            - lokale Änderungen in vendor/ anzeigen

## Autoloader
composer dump-autoload                     - Autoloader neu erzeugen (Alias: dumpautoload)
composer dump-autoload -o                  - optimierten Classmap-Autoloader erzeugen
composer dump-autoload -a                  - Classmap-authoritative (nur Produktion)
composer dump-autoload --no-dev            - ohne autoload-dev-Einträge
composer dump-autoload --strict-psr        - PSR-Verstöße als Fehler melden

## Scripts & Binaries
composer run-script <name>                 - Script aus composer.json ausführen
composer run <name> -- --flag              - Script mit Argumenten aufrufen
composer run -l                            - definierte Scripts auflisten
composer exec <binary>                     - Binary aus vendor/bin ausführen
composer exec -l                           - verfügbare vendor/bin-Binaries auflisten
composer exec phpunit -- --filter Foo      - Argumente an das Binary durchreichen

## Konfiguration
composer config --list                     - alle Einstellungen anzeigen
composer config <key> <wert>               - Einstellung setzen
composer config --global <key> <wert>      - global setzen (Alias: -g)
composer config --unset <key>              - Einstellung entfernen
composer config minimum-stability dev      - Mindest-Stabilität festlegen
composer config platform.php 8.3           - PHP-Version für Auflösung fixieren
composer config allow-plugins.<paket> true - Plugin explizit erlauben
composer config repositories.foo vcs <url> - VCS-Repository eintragen
composer config repositories.foo path ../lib - lokales Pfad-Repository eintragen

## Global & Wartung
composer global require <vendor/paket>     - Paket global installieren
composer global update                     - globale Pakete aktualisieren
composer self-update                       - Composer selbst aktualisieren
composer self-update --rollback            - auf vorherige Composer-Version zurück
composer clear-cache                       - Composer-Cache leeren (Alias: cc)
composer archive <paket> --format=zip      - Paket als Archiv exportieren

## Nützliche Optionen (überall)
-n / --no-interaction                      - keine Rückfragen (CI/Deployment)
-v / -vv / -vvv                            - Ausgabe schrittweise ausführlicher
-q / --quiet                               - keine Ausgabe
-d <pfad> / --working-dir                  - in anderem Verzeichnis ausführen
--no-scripts                               - definierte Scripts überspringen
--no-plugins                               - Composer-Plugins deaktivieren
--profile                                  - Laufzeit und Speicherverbrauch anzeigen
--ignore-platform-reqs                     - Plattform-Anforderungen ignorieren
--ignore-platform-req=ext-gd               - einzelne Anforderung ignorieren
COMPOSER_MEMORY_LIMIT=-1 composer update   - Memory-Limit für Composer aufheben
