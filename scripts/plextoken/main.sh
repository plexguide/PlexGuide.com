#!/bin/bash
#
# [Token Retriever]
#
# Website:   https://plexguide.com
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

curl -qu "${plexuser}":"${plexpassword}" 'https://plex.tv/users/sign_in.xml' 1>/dev/null 2>&1 \
    -X POST -H 'X-Plex-Device-Name: PlexMediaServer' \
    -H 'X-Plex-Provides: server' \
    -H 'X-Plex-Version: 0.9' \
    -H 'X-Plex-Platform-Version: 0.9' \
    -H 'X-Plex-Platform: xcid' \
    -H 'X-Plex-Product: Plex Media Server'\
    -H 'X-Plex-Device: Linux'\
    -H 'X-Plex-Client-Identifier: XXXX' --compressed >/opt/appdata/plexguide/plex_sign_in
X_PLEX_TOKEN=$(sed -n 's/.*<authentication-token>\(.*\)<\/authentication-token>.*/\1/p' /opt/appdata/plexguide/plex_sign_in)
if [ -z "$X_PLEX_TOKEN" ]; then
    cat /opt/appdata/plexguide/plex_sign_in 1>/dev/null 2>&1
    rm -f /opt/appdata/plexguide/plex_sign_in 1>/dev/null 2>&1
    dialog --title "Token Status" --msgbox "\nFailed to Retrieve the Plex Token!" 0 0
    exit 1
fi
rm -f /opt/appdata/plexguide/plex_sign_in
dialog --title "Your Token - We Saved It" --msgbox "\nToken: $X_PLEX_TOKEN!\n\nNote: You Do Not Need To Copy This" 0 0  