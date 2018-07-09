#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

edition=$( cat /var/plexguide/pg.edition )
version=$( cat /var/plexguide/pg.version )
appguard=$(cat /var/plexguide/server.appguard)
portstat=$(cat /var/plexguide/server.ports.status)
watchtower=$(cat /var/plexguide/watchtower.yes)
timeinfo=$( date "+%H:%M:%S - %m/%d/%y" )
serverid=$( cat /var/plexguide/server.id )
domain=$( cat /var/plexguide/server.domain )
hd=$( cat /var/plexguide/server.hd.path )
ansible=$( ansible --version | head -n1 )
ansible=${ansible:8}

docker --version | awk '{print $3}' > /var/plexguide/docker.version
docker=$( cat /var/plexguide/docker.version )
docker=${docker::-1}

hostname -I | awk '{print $1}' > /var/plexguide/server.ip
ip=$( cat /var/plexguide/server.ip ) 1>/dev/null 2>&1

#### GDrive or Local Edition (Local Not Working Yet)
#cat /var/plexguide/pg.version > /var/plexguide/pg.version
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

#### Edition of PG
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1

traefikver=$(docker ps -a --format "{{.Names}}" | grep traefikdeploy)
traefikdetect="false"
#### If neither one exist, displays message below; if does executes the stuff under else
if [ "$traefikver" == "traefikdeploy" ]
  then
  	tmessage="Reverse Proxy: Traefik Installed"
  	traefikdetect="true"
fi

if [ "$traefikdetect" == "false" ]
  then
    tmessage="NOTE: Traefik Not Installed"
fi

dialog --title "PG Startup Variable Page" --msgbox "\n$edition - $version\nServer Time: $timeinfo\nServer ID  : $serverid\n\nIP:     $ip\nDomain: $domain\n\nDocker: $docker | Ansible: $ansible\n$tmessage\nDownload Path : $hd\nWatchTower: $watchtower\n\nPORTS: $portstat - APPGUARD: $appguard" 0 0

echo "INFO - Started $edition $version" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
echo "INFO - $tmessage" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
echo "INFO - APPGUARD is $appguard | PORTS are $portstat" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
