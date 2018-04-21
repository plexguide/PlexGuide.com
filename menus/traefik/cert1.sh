#!/bin/bash
#
# [Rebuilding Containers]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
#docker logs --tail 20 traefik 2> /var/plexguide/status.traefik1
#dock=$( cat /var/plexguide/status.traefik1 )

#string='*with a certificate.'
#if [[ $string = *"with a certificate"* ]]; then
#  echo "certificate" > /var/plexguide/status.traefik1
#else
#  echo "nope" > /var/plexguide/status.traefik1
#fi

bash /opt/plexguide/menus/traefik/certlog.sh 1>/dev/null 2>&1
dock=$( cat /var/plexguide/status.traefik1.temp )
info=${dock#*responded with a}
info=$( echo ${info:0:12} ) 1>/dev/null 2>&1
echo $info 1>/dev/null 2>&1 | head -c 1
echo $info > /var/plexguide/status.traefik1

######### path to call script
#bash /opt/plexguide/menus/traefik/cert2.sh

######### Sample Script for Traefik2
#dock2=$( cat /var/plexguide/status.traefik2 )
#if [ "$dock2" == "certificate" ]
#then
	#echo "$dock2"
#fi
