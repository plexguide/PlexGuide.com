#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

edition=$( cat /var/plexguide/pg.edition )
version=$( cat /var/plexguide/pg.version )
appguard=$(cat /var/plexguide/server.appguard)
portstat=$(cat /var/plexguide/server.ports.status)
watchtower=$(cat /var/plexguide/watchtower.yes)
timeinfo=$( date "+%H:%M:%S - %m/%d/%y" )
serverid=$( cat /var/plexguide/server.id )

traefikver=$(docker ps -a --format "{{.Names}}" | grep traefik)
domain=$( cat /var/plexguide/server.domain ) 1>/dev/null 2>&1
hd=$( cat /var/plexguide/server.hd.path ) 1>/dev/null 2>&1

docker --version | awk '{print $3}' > /var/plexguide/docker.version
docker=$( cat /var/plexguide/docker.version ) 1>/dev/null 2>&1
docker=${docker::-1} 1>/dev/null 2>&1

hostname -I | awk '{print $1}' > /var/plexguide/server.ip
ip=$( cat /var/plexguide/server.ip ) 1>/dev/null 2>&1

#### GDrive or Local Edition (Local Not Working Yet)
#cat /var/plexguide/pg.version > /var/plexguide/pg.version
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

#### Edition of PG
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1

traefikdetect="false"
#### If neither one exist, displays message below; if does executes the stuff under else
if [ "$traefikver" == "traefik2" ]
  then
  	traefik="Traefik V2"
  	traefikdetect="true"
fi

if [ "$traefikver" == "traefik" ]
  then
  	traefik="Traefik V1"
  	traefikdetect="true"
fi

if curl -s --head  --request GET https://portainer.$domain | grep "200 OK" > /dev/null
	then     
		tmessage=$(echo "$traefik: Certificate is Valid")
    else    
    	tmessage=$(echo "$traefik: Certificate is NOT Valid")
fi

if [ "$traefikdetect" == "false" ]
  then
    traefik="WARNING: Traefik Is Not Installed"
    tmessage=""
fi

dialog --title "PG Startup Variable Page" --msgbox "\n$edition - $version\nServer Time: $timeinfo\nServer ID  : $serverid\n\nIP:     $ip\nDomain: $domain\n\n$tmessage\nDocker Version: $docker\nDownload Path : $hd\nWatchTower: $watchtower\n\nPORTS: $portstat - APPGUARD: $appguard" 0 0

echo "INFO - Started $edition $version" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
echo "INFO - Docker Version $docker is installed" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
echo "INFO - $cert1$cert2" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
echo "INFO - APPGUARD is $appguard | PORTS are $portstat" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
