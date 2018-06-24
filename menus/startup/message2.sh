#!/bin/bash
export NCURSES_NO_UTF8_ACS=1

edition=$( cat /var/plexguide/pg.edition )
version=$( cat /var/plexguide/pg.version )
appguard=$(cat /var/plexguide/server.appguard)
portstat=$(cat /var/plexguide/server.ports.status)
watchtower=$(cat /var/plexguide/watchtower.yes)
timeinfo=$( date "+%H:%M:%S - %m/%d/%y" )
serverid=$( cat /var/plexguide/server.id )
sleep 1

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

#### Checks to See if Either Traefik Exists  Based on Portainer
docker logs traefik2 3>&1 1>>/var/plexguide/traefik.error2 2>&1
docker logs traefik 3>&1 1>>/var/plexguide/traefik.error1 2>&1

error2=$( awk 'END {print $NF}' /var/plexguide/traefik.error2 )
error1=$( awk 'END {print $NF}' /var/plexguide/traefik.error1 )
error2=${error2::-1}

#### If neither one exist, displays message below; if does executes the stuff under else
if [ "$error2" == "$error1" ]
  then
    echo 'WARNING - Traefik Not Installed' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    dialog --title "Setup Note" --msgbox "\nNo Version of Traefik is Installed!\n\nWarning, goto domains.plexguide.com for Info!" 0 0
  else
    #### This results in providing which version of Traefik one is using
    version=$( cat /var/plexguide/provider )
    if [ "$version" == "null" ]
    then
    #### Using Traefik V2
    traefik="Traefik V1"
    else
    #### Using Traefik V2
    traefik="Traefik V2"
    fi
fi

if curl -s --head  --request GET https://portainer.$domain.com | grep "200 OK" > /dev/null
	then     
		tmessage=$(echo "$traefik: Certificate is Valid")
    else    
    	tmessage=$(echo "$traefik: Certificate is NOT Valid")
fi

dialog --title "PG Startup Variable Page" --msgbox "\n$edition - $version\nServer Time: $timeinfo\nServer ID  : $serverid\n\nIP:     $ip\nDomain: $domain\n\n$traefik: $tmessage\nDocker Version: $docker\nDownload Path : $hd\nWatchTower: $watchtower\n\nPORTS: $portstat - APPGUARD: $appguard" 0 0

echo "INFO - Started $edition $version" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
echo "INFO - Docker Version $docker is installed" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
echo "INFO - $cert1$cert2" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
echo "INFO - APPGUARD is $appguard | PORTS are $portstat" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
