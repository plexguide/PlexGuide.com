#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

domain=$( cat /var/plexguide/server.domain )

cert2=$( cat /var/plexguide/status.traefik2 )
if [ "$cert2" == "certificate" ]
then
	echo "\nTraefik v2: Certificate is Valid" > /var/plexguide/status.traefik.cert
	cert2=$( cat /var/plexguide/status.traefik.cert )
fi

dialog --title "PLEXGUIDE Variable Page" --msgbox "\nDomain: $domain.$cert2" 0 0

