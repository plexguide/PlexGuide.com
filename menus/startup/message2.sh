#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

domain=$( cat /var/plexguide/server.domain ) 1>/dev/null 2>&1
hd=$( cat /var/plexguide/server.hd.path ) 1>/dev/null 2>&1
ip=$( cat /var/plexguide/server.ip ) 1>/dev/null 2>&1

docker=$( cat /var/plexguide/docker.version ) 1>/dev/null 2>&1
docker=${docker::-1} 1>/dev/null 2>&1

cert2=$( cat /var/plexguide/status.traefik2 ) 1>/dev/null 2>&1
if [ "$cert2" == "certificate" ]
then
	echo "\nTraefik v2: Certificate is Valid" > /var/plexguide/status.traefik.cert
	cert2=$( cat /var/plexguide/status.traefik.cert ) 1>/dev/null 2>&1
else
	echo "\nTraefik v2: Certificate is NOT Valid" > /var/plexguide/status.traefik.cert
	cert2=$( cat /var/plexguide/status.traefik.cert ) 1>/dev/null 2>&1
fi

dialog --title "PG Startup Variable Page" --msgbox "\nIP:     $ip\nDomain: $domain\n$cert2\nDocker Version: $docker\nDownload Path : $hd" 0 0