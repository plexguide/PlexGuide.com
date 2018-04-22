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
#docker logs --tail 20 traefik2 2> /var/plexguide/status.traefik2
#dock=$( cat /var/plexguide/status.traefik2 )

#string='*with a certificate.'
#if [[ $string = *"with a certificate"* ]]; then
#  echo "certificate" > /var/plexguide/status.traefik2
#else
#  echo "nope" > /var/plexguide/status.traefik2
#fi

docker logs --tail 100 traefik2 | tee /var/plexguide/status.traefik2.temp
docker logs --tail 100 traefik  | tee /var/plexguide/status.traefik1.temp

#dock=${dock#*responded with a}
#echo $dock 

#new=${dock#*with a} 
#new=${new::-1}
#echo $new | head -c 1
#echo $new > /var/plexguide/status.traefik2

######### path to call script
#bash /opt/plexguide/menus/traefik/cert2.sh

######### Sample Script for Traefik2
#dock2=$( cat /var/plexguide/status.traefik2 )
#if [ "$dock2" == "certificate" ]
#then
	#echo "$dock2"
#fi

#string='My long string'
#if [[ $string = *"My long"* ]]; then
#  echo "It's there!"
#fi
