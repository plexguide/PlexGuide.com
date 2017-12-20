#!/bin/bash

# Get PUID
PUID=`id -u $local_username`
# Get GUID
PGID=`id -g $local_username`
# Get IP Address
local_ip=`hostname -I | awk '{print $1}'`

echo "IP_ADDRESS=$local_ip" >> .env
echo "PUID=$PUID" >> .env
echo "PGID=$PGID" >> .env

cat .env >> /opt/.environments/.uhttpd-env

# Let's configure the access to the Deluge Daemon for CouchPotato
echo "CouchPotato requires access to the Deluge daemon port and needs credentials set."
read -p "What would you like to use as the daemon access username?: " daemonun
read -p "What would you like to use as the daemon access password?: " daemonpass
printf "\n\n"

# Finish up the config
printf "Configuring Deluge daemon access - UHTTPD index file - Permissions \n\n"

# Configure DelugeVPN: Set Daemon access on, delete the core.conf~ file
`while [ ! -f /opt/appdata/delugevpn/config/core.conf ]; do sleep 1; done`
`docker stop delugevpn > /dev/null 2>&1`
`rm /opt/appdata/delugevpn/config/core.conf~ > /dev/null 2>&1`
`sed -i 's/"allow_remote": false,/"allow_remote": true,/g'  /opt/appdata/delugevpn/config/core.conf`
`sed -i 's/"move_completed": false,/"move_completed": true,/g'  /opt/appdata/delugevpn/config/core.conf`
`docker start delugevpn > /dev/null 2>&1`

# Push the Deluge Daemon Access info the to Auth file
`echo $daemonun:$daemonpass:10 >> /opt/appdata//delugevpn/config/auth`

# Configure UHTTPD settings and Index file
`docker stop uhttpd > /dev/null 2>&1`
`mv index.html /opt/appdata/www/index.html`
`sed -i "s/local_ip/$locip/g" /opt/appdata/www/index.html`
`sed -i "s/daemonun/$daemonun/g" /opt/appdata/www/index.html`
`sed -i "s/daemonpass/$daemonpass/g" /opt/appdata/www/index.html`
`cp .env /opt/appdata/www/env.txt`
`docker start uhttpd > /dev/null 2>&1`
