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
    sleep 4
 
    dialog --title "Input >> Plex Password" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "Your Plex Password" 8 45 2>/tmp/plexuser
    plexpassword=$(cat /tmp/plexpassword)
    dialog --infobox "Typed Password: $plexpassword" 3 45
    sleep 4

    clear
>&2 echo 'Retrieving a X-Plex-Token using Plex login/password...'

curl -qu "${plexuser}":"${plexpassword}" 'https://plex.tv/users/sign_in.xml' \
    -X POST -H 'X-Plex-Device-Name: PlexMediaServer' \
    -H 'X-Plex-Provides: server' \
    -H 'X-Plex-Version: 0.9' \
    -H 'X-Plex-Platform-Version: 0.9' \
    -H 'X-Plex-Platform: xcid' \
    -H 'X-Plex-Product: Plex Media Server'\
    -H 'X-Plex-Device: Linux'\
    -H 'X-Plex-Client-Identifier: XXXX' --compressed >/tmp/plex_sign_in
X_PLEX_TOKEN=$(sed -n 's/.*<authentication-token>\(.*\)<\/authentication-token>.*/\1/p' /tmp/plex_sign_in)
if [ -z "$X_PLEX_TOKEN" ]; then
    cat /tmp/plex_sign_in
    rm -f /tmp/plex_sign_in
    >&2 echo 'Failed to retrieve the X-Plex-Token.'
    exit 1
fi
rm -f /tmp/plex_sign_in

>&2 echo "Your X_PLEX_TOKEN:"

echo $X_PLEX_TOKEN