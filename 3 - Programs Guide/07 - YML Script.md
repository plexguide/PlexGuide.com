# YML Script
The location of this YML file: /opt/

## 1st Time Instructions
- Establishing location of script and creating file for first time.  Copy this below into the script!

```sh
cd /opt && sudo docker-compose -f docker-compose.yml up -d
```

## Future Instructions
- Do this ONLY if you make changes and rerun this script below again. It wipes the old script and allows you to paste again.  Did it to speed up things for you.

```sh
cd /opt && sudo rm -r docker-compose.yml && sudo nano docker-compose.yml
```

## YML Writeup (Copy this below - The spacing below in this script is important / it will fail) 
```sh
---
version: '2'
services:
 portainer:
   image: portainer/portainer
   container_name: portainer
   command: --templates http://templates/templates.json
   volumes:
     - /opt/appdata/portainer:/data
     - /var/run/docker.sock:/var/run/docker.sock
   ports:
     - 9000:9000
# ensures this container starts up when required to
   restart:
     always
 plexpy:
   image: linuxserver/plexpy
   container_name: plexpy
   volumes:
     - /opt/appdata/plexpy:/config
     - /opt/appdata/plex/Library/Application\ Support/Plex\ Media\
   ports:
     - 8181:8181
# ensures this container starts up when required to
   restart: always
   environment:
     - PUID=1001    
     - PGID=1001   
 muximux:
   image:  linuxserver/muximux
   container_name: muximux
# If you want your ip or domain to load this directly, change the 8015 to 80 (80:80).
# If you plan on creating a web-interface; leave as 8015; port 80 is reserved for your website
   ports:
     - 8015:80
   volumes:
     - /opt/appdata/muximux/config:/config
     - /etc/localtime:/etc/localtime:ro
   environment:
     - PUID=1001
     - PGID=1001
   restart:
     always

 emby:
        image: emby/embyserver
        container_name: emby
        # net: host
        ports:
            - 8096:8096
        volumes:
            - /etc/localtime:/etc/localtime:ro
            - /opt/appdata/embyserver:/config
            - /mnt:/shows
            - /mnt/rclone-union/:/media
        environment:
            - VIRTUAL_PORT=8096
            - VIRTUAL_HOST=emby.htpc
            - AUTO_UPDATES_ON=true
            - PUID=0
            - PGID=0
        restart: always
```

## Final Notes
- Once executed, access the following services
 - Portainer: http://ipv4address/domain:9000
 - PlexPy:    http://ipv4address/domain:8181
 - Muximux:   http://ipv4address/domain:8015
 - Emby:      http://ipv4address/domain:8096

## To Update Emby (Futurewise)
- Whenever you need to update Emby just use the following without '#' :-
sudo docker exec -ti emby update
