#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

bash /opt/plexguide/menus/traefik/cert2.sh 1>/dev/null 2>&1
bash /opt/plexguide/menus/traefik/cert1.sh 1>/dev/null 2>&1
edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.version ) 1>/dev/null 2>&1

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
docker logs traefik2 2> /var/plexguide/traefik.error2
docker logs traefik 2> /var/plexguide/traefik.error1
error2=$( cat /var/plexguide/traefik.error2 )
error2=${error2::-1}
error1=$( cat /var/plexguide/traefik.error1 )

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

dialog --title "PG Startup Variable Page" --msgbox "\n$edition - $version\n\nIP:     $ip\nDomain: $domain\n$cert1$cert2\nDocker Version: $docker\nDownload Path : $hd" 0 0