#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

bash /opt/plexguide/menus/traefik/cert2.sh &>/dev/null &
bash /opt/plexguide/menus/traefik/cert1.sh &>/dev/null &
sleep 1
edition=$( cat /var/plexguide/pg.edition ) 
version=$( cat /var/plexguide/pg.version )
appguard=$(cat /var/plexguide/server.appguard)
portstat=$(cat /var/plexguide/server.ports.status)
watchtower=$(cat /var/plexguide/watchtower.yes)
timeinfo=$( date "+%H:%M:%S - %m/%d/%y" )

sleep 2

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

#### Checks to See if Either Traefik Exisxts

docker logs traefik2 3>&1 1>>/var/plexguide/traefik.error2 2>&1
docker logs traefik 3>&1 1>>/var/plexguide/traefik.error1 2>&1

error2=$( awk 'END {print $NF}' /var/plexguide/traefik.error2 )
error1=$( awk 'END {print $NF}' /var/plexguide/traefik.error1 )
error2=${error2::-1}

#### If neither one exist, displays message below; if does executes the stuff under else
if [ "$error2" == "$error1" ]
  then
    echo "\nWARNING: Traefik is not installed!" > /var/plexguide/status.traefik.cert
    cert1=$( cat /var/plexguide/status.traefik.cert ) 1>/dev/null 2>&1
  else
  	
  	#### Version 1 or 2 Display
	provider=$( cat /var/plexguide/provider ) 1>/dev/null 2>&1
	if [ "$provider" == "null" ]
	then
		cert1=$( cat /var/plexguide/status.traefik1 ) 1>/dev/null 2>&1
		if [ "$cert1" == "certificate" ]
		then
			echo "\nTraefik v1: Certificate is Valid" > /var/plexguide/status.traefik.cert
			cert1=$( cat /var/plexguide/status.traefik.cert ) 1>/dev/null 2>&1
		else
			echo "\nTraefik v1: Certificate is NOT Valid" > /var/plexguide/status.traefik.cert
			cert1=$( cat /var/plexguide/status.traefik.cert ) 1>/dev/null 2>&1
		fi
	else
		cert2=$( cat /var/plexguide/status.traefik2 ) 1>/dev/null 2>&1
		if [ "$cert2" == "certificate" ]
		then
			echo "\nTraefik v2: Certificate is Valid" > /var/plexguide/status.traefik.cert
			cert2=$( cat /var/plexguide/status.traefik.cert ) 1>/dev/null 2>&1
		else
			echo "\nTraefik v2: Certificate is NOT Valid" > /var/plexguide/status.traefik.cert
			cert2=$( cat /var/plexguide/status.traefik.cert ) 1>/dev/null 2>&1
		fi
	fi

fi

dialog --title "PG Startup Variable Page" --msgbox "\n$edition - $version\nServer Time: $timeinfo\n\nIP:     $ip\nDomain: $domain\n$cert1$cert2\nDocker Version: $docker\nDownload Path : $hd\nWatchTower: $watchtower\n\nPORTS: $portstat - APPGUARD: $appguard" 0 0