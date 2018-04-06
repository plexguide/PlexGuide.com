#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

domain=$( cat /var/plexguide/server.domain )
hd=$( cat /var/plexguide/server.hd.path )
ip=$( cat /var/plexguide/server.ip )

cert2=$( cat /var/plexguide/status.traefik2 )
if [ "$cert2" == "certificate" ]
then
	echo "\nTraefik v2: Certificate is Valid" > /var/plexguide/status.traefik.cert
	cert2=$( cat /var/plexguide/status.traefik.cert )
else
	echo "\nTraefik v2: Certificate is NOT Valid" > /var/plexguide/status.traefik.cert
	cert2=$( cat /var/plexguide/status.traefik.cert )
fi

dialog --title "PG Startup Variable Page" --msgbox "\nIP:     $ip\nDomain: $domain\n$cert2\nDownload Path: $hd" 0 0