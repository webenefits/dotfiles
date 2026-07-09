# docker

## Info & Grundlagen
docker version                             - Client- und Server-Version anzeigen
docker info                                - Systemweite Docker-Infos (Container, Images)
docker --help                              - Hilfe; funktioniert für jeden Subbefehl
docker context ls                          - verfügbare Docker-Kontexte auflisten
docker context use <name>                  - Kontext wechseln (z. B. remote Docker-Host)
docker login                               - an Registry anmelden (Default: Docker Hub)
docker logout                              - von Registry abmelden

## Container starten
docker run <image>                         - Container aus Image starten
docker run -d <image>                      - im Hintergrund starten (detached)
docker run -it <image> bash                - interaktiv mit TTY, Shell öffnen
docker run --rm <image>                    - Container nach Beenden automatisch löschen
docker run --name <name> <image>           - Container benennen
docker run -p 8080:80 <image>              - Host-Port 8080 auf Container-Port 80 mappen
docker run -P <image>                      - alle EXPOSE-Ports zufällig auf Host mappen
docker run -v <host>:<ziel> <image>        - Verzeichnis/Volume einhängen (bind mount)
docker run -v <name>:/data <image>         - benanntes Volume einhängen
docker run -e KEY=value <image>            - Umgebungsvariable setzen
docker run --env-file .env <image>         - Umgebungsvariablen aus Datei laden
docker run -w /app <image>                 - Arbeitsverzeichnis im Container setzen
docker run -u 1000:1000 <image>            - als bestimmte UID/GID laufen lassen
docker run --network <netz> <image>        - Container an Netzwerk hängen
docker run --restart unless-stopped <image> - Neustart-Policy setzen (no/always/on-failure)
docker run --memory 512m --cpus 1.5 <image> - RAM-/CPU-Limit setzen
docker run --entrypoint sh <image>         - ENTRYPOINT des Images überschreiben

## Container verwalten
docker ps                                  - laufende Container auflisten
docker ps -a                               - alle Container inkl. gestoppte
docker ps -q                               - nur Container-IDs ausgeben
docker stop <container>                    - Container sauber stoppen (SIGTERM)
docker kill <container>                    - Container hart beenden (SIGKILL)
docker start <container>                   - gestoppten Container wieder starten
docker restart <container>                 - Container neu starten
docker pause / unpause <container>         - Prozesse einfrieren / fortsetzen
docker rm <container>                      - Container löschen
docker rm -f <container>                   - laufenden Container erzwungen löschen
docker rename <alt> <neu>                  - Container umbenennen
docker update --restart=always <container> - Einstellungen eines Containers ändern
docker wait <container>                    - blockieren bis Container endet, Exit-Code

## Im Container arbeiten
docker exec -it <container> bash           - Shell in laufendem Container öffnen
docker exec -it <container> sh             - dito, für Alpine-Images (keine bash)
docker exec -u root -it <container> bash   - als root in den Container
docker exec <container> <befehl>           - einzelnen Befehl im Container ausführen
docker attach <container>                  - an Hauptprozess des Containers andocken
docker logs <container>                    - Logausgabe des Containers anzeigen
docker logs -f <container>                 - Logs live mitverfolgen (follow)
docker logs --tail 100 -t <container>      - letzte 100 Zeilen mit Zeitstempel
docker top <container>                     - Prozesse im Container anzeigen
docker stats                               - Live-Ressourcenverbrauch aller Container
docker inspect <container>                 - vollständige Metadaten als JSON
docker diff <container>                    - geänderte Dateien ggü. Image anzeigen
docker port <container>                    - Port-Mappings des Containers anzeigen
docker cp <container>:/pfad ./lokal        - Datei aus Container kopieren
docker cp ./lokal <container>:/pfad        - Datei in Container kopieren

## Images
docker images                              - lokale Images auflisten
docker image ls -a                         - alle Images inkl. Zwischenschichten
docker pull <image>:<tag>                  - Image aus Registry laden
docker push <user>/<image>:<tag>           - Image in Registry hochladen
docker rmi <image>                         - Image löschen
docker tag <image> <user>/<image>:<tag>    - Image taggen (z. B. vor Push)
docker history <image>                     - Layer-Historie eines Images
docker inspect <image>                     - Image-Metadaten als JSON
docker save -o img.tar <image>             - Image als Tar-Archiv exportieren
docker load -i img.tar                     - Image aus Tar-Archiv importieren
docker search <begriff>                    - Docker Hub nach Images durchsuchen

## Images bauen
docker build .                             - Image aus Dockerfile im aktuellen Ordner
docker build -t <name>:<tag> .             - Image bauen und benennen
docker build -f Dockerfile.dev .           - anderes Dockerfile verwenden
docker build --no-cache .                  - ohne Layer-Cache neu bauen
docker build --build-arg KEY=val .         - Build-Argument übergeben
docker build --target <stage> .            - bestimmte Stage im Multi-Stage-Build
docker build --platform linux/amd64 .      - für andere Architektur bauen
docker buildx build --push -t <name> .     - bauen und direkt pushen (buildx)
docker init                                - Dockerfile/Compose interaktiv generieren

## Volumes
docker volume ls                           - Volumes auflisten
docker volume create <name>                - Volume anlegen
docker volume inspect <name>               - Details inkl. Mountpoint anzeigen
docker volume rm <name>                    - Volume löschen
docker volume prune                        - unbenutzte Volumes löschen

## Netzwerke
docker network ls                          - Netzwerke auflisten
docker network create <name>               - Netzwerk anlegen (Default: bridge)
docker network inspect <name>              - Details & verbundene Container
docker network connect <netz> <container>  - Container mit Netzwerk verbinden
docker network disconnect <netz> <container> - Container vom Netzwerk trennen
docker network rm <name>                   - Netzwerk löschen
docker network prune                       - unbenutzte Netzwerke löschen

## Aufräumen
docker system df                           - Speicherverbrauch von Docker anzeigen
docker system prune                        - gestoppte Container, Netze, dangling Images
docker system prune -a                     - zusätzlich alle unbenutzten Images
docker system prune -a --volumes           - zusätzlich alle unbenutzten Volumes
docker container prune                     - alle gestoppten Container löschen
docker image prune                         - dangling Images löschen
docker image prune -a                      - alle unbenutzten Images löschen
docker builder prune                       - Build-Cache aufräumen
docker rm -f (docker ps -aq)               - alle Container erzwungen löschen (fish)
docker stop (docker ps -q)                 - alle laufenden Container stoppen (fish)

## Compose
docker compose up                          - Services starten (Vordergrund)
docker compose up -d                       - Services im Hintergrund starten
docker compose up -d --build               - vor dem Start neu bauen
docker compose up -d <service>             - nur einen Service starten
docker compose down                        - Container und Netzwerke entfernen
docker compose down -v                     - zusätzlich Volumes löschen
docker compose down --rmi all              - zusätzlich Images löschen
docker compose ps                          - Status der Services anzeigen
docker compose logs -f                     - Logs aller Services live
docker compose logs -f <service>           - Logs eines Services live
docker compose exec <service> bash         - Shell in laufendem Service öffnen
docker compose run --rm <service> <befehl> - Einmal-Befehl in neuem Container
docker compose build --no-cache            - Images ohne Cache neu bauen
docker compose pull                        - Images der Services aktualisieren
docker compose restart <service>           - Service neu starten
docker compose stop / start                - Services stoppen / starten (ohne Löschen)
docker compose config                      - zusammengeführte Config validiert ausgeben
docker compose watch                       - Dateien beobachten, Container auto-updaten
docker compose cp <service>:/pfad ./lokal  - Datei aus Service-Container kopieren
docker compose -f compose.prod.yml up -d   - andere Compose-Datei verwenden
docker compose --profile debug up -d       - Services eines Profils mitstarten

## Diagnose
docker events                              - Docker-Events live mitverfolgen
docker inspect -f '{{.State.Status}}' <c>  - einzelnes Feld per Go-Template auslesen
docker inspect -f '{{.NetworkSettings.IPAddress}}' <c> - IP eines Containers ermitteln
docker run --rm -it --network <netz> alpine sh - Wegwerf-Container im Netz zum Debuggen
docker debug <container>                   - Debug-Shell auch in Slim-Images (Desktop)
docker scout cves <image>                  - Image auf bekannte Schwachstellen prüfen
