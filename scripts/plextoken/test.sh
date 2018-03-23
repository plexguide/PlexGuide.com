#!/bin/bash
#
# [Token Retriever]
#
# Website:  https://plexguide.com
# Author:   Admin9705
#
# PlexGuide Copyright (C) PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
# Original Script
# GitHub:   https://github.com/wernight/docker-plex-media-server/blob/master/root/usr/local/bin/retrieve-plex-token
# Author:   Wernight
#################################################################################
if [ -z "$plexuser" ] || [ -z "$plexpassword" ]; then
    plexuser=$1
    plexpassword=$2
fi

    dialog --title "Input >> Plex Login" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "Plex Username or EMail:" 8 45 2>/tmp/plexuser
    plexuser=$(cat /tmp/plexuser)
    dialog --infobox "Typed PlexUser: $plexuser" 3 45
    sleep 2
 
    dialog --title "Input >> Plex Password" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "Your Plex Password" 8 45 2>/tmp/plexpassword
    plexpassword=$(cat /tmp/plexpassword)
    dialog --infobox "Typed Password: $plexpassword" 3 45
    sleep 2

    dialog --infobox "Fetching Your Plex Token" 3 45
    sleep 2



token=$(curl -H "Content-Length: 0" -H "X-Plex-Client-Identifier: PlexInTheCloud" -u "${plexuser}":"${plexpassword}" -X POST https://my.plexapp.com/users/sign_in.xml | cut -d "\"" -s -f22 | tr -d '\n')

# Grab the Plex Section ID of our new TV show library
tvID=$(curl -H "X-Plex-Token: ${token}" http://ffplex.com:32400/library/sections | grep "show" | grep "title=" | awk -F = '{print $6" "$7" "$8}' | sed 's/ art//g' | sed 's/title//g' | sed 's/type//g' | awk -F \" '{print "Section=\""$6"\" ID="$2}' | cut -d '"' -f2)

dialog --title "Your Token - We Saved It" --msgbox "\nToken: $X_PLEX_TOKEN!\nNote:  Do Not Need To Copy This" 0 0  
echo "$token" > /opt/appdata/plexguide/plextoken