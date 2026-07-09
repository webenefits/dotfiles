# oxid

## Aufruf
vendor/bin/oe-console <befehl>             - OXID-Console im Projektroot ausführen
ddev exec vendor/bin/oe-console <befehl>   - innerhalb eines DDEV-Projekts
vendor/bin/oe-console                      - alle verfügbaren Befehle auflisten
vendor/bin/oe-console list                 - dito, explizit
vendor/bin/oe-console <befehl> -h          - Hilfe zu einem Befehl anzeigen
vendor/bin/oe-console --shop-id=1 <befehl> - Befehl für Subshop ausführen (EE)
vendor/bin/oe-console --shop-id=<id>       - Befehle eines Subshops auflisten (EE)

## Shop einrichten
oe:setup:shop                              - OXID eShop installieren
oe:setup:shop --db-host=localhost --db-port=3306 - Datenbankserver angeben
oe:setup:shop --db-name=<db> --db-user=<u> --db-password=<pw> - DB-Zugang angeben
oe:setup:shop --shop-url=<url>             - öffentliche Shop-URL setzen
oe:setup:shop --shop-directory=<pfad>      - Pfad zum source-Verzeichnis
oe:setup:shop --compile-directory=<pfad>   - Verzeichnis für temporäre Dateien
oe:setup:shop --language=de                - Shop-Sprache (ISO 639-1)
oe:setup:demodata                          - Demodaten installieren
oe:admin:create-user --admin-email=<mail> --admin-password=<pw> - Admin anlegen
oe:license:add <key>                       - Lizenzschlüssel eintragen (PE/EE)
oe:license:clear                           - alle Lizenzschlüssel entfernen

## Module
oe:module:install <pfad>                   - Modul aus Quellverzeichnis installieren
oe:module:install-configuration <pfad>     - nur Modulkonfiguration installieren
oe:module:activate <module-id>             - Modul aktivieren
oe:module:deactivate <module-id>           - Modul deaktivieren
oe:module:uninstall <module-id>            - Modul deinstallieren
oe:module:activate <id> --shop-id=1        - Modul in bestimmtem Subshop aktivieren

## Modulkonfiguration ausrollen
oe:module:deploy-configurations            - Konfigurationen aller Module ausrollen (7.x)
oe:module:deploy-configurations --shop-id=1 - nur für einen Subshop (EE)
oe:module:apply-configuration              - Vorgänger-Befehl in OXID 6.x

## Themes
oe:theme:activate <theme-id>               - Theme aktivieren

## Datenbank-Migrationen
vendor/bin/oe-eshop-db_migrate migrations:migrate - alle Migrationen ausführen
vendor/bin/oe-eshop-db_migrate migrations:migrate PR - nur Projekt-Migrationen
vendor/bin/oe-eshop-db_migrate migrations:generate PR - Projekt-Migration erzeugen
vendor/bin/oe-eshop-db_migrate migrations:status - Migrationsstatus anzeigen
vendor/bin/oe-eshop-db_migrate migrations:migrate <module-id> - Modul-Migrationen
vendor/bin/oe-eshop-db_views_generate      - DB-Views neu erzeugen (nach Migration!)

## Suite-Typen (Migrationen)
PR                                         - projektspezifisch (Projektentwicklung)
CE / PE / EE                               - Edition-Migrationen (nur Produktentwicklung)
<module-id>                                - Migrationen eines Moduls

## Cache & Wartung
rm -rf source/tmp/*                        - Template-/Objektcache leeren (Compile-Dir)
composer dump-autoload -o                  - Autoloader nach Klassenänderungen erneuern

## Typische Abläufe
composer update && oe:module:deploy-configurations - nach Modul-Update
oe-eshop-db_migrate migrations:migrate && oe-eshop-db_views_generate - nach Schema-Änderung
oe:module:install <pfad> && oe:module:activate <id> - Modul frisch einspielen
