#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/wernight/docker-plex-media-server/blob/master/root/usr/local/bin/retrieve-plex-token
# Author:   Wernight
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
# Further Enhanced By https://plexguide.com
#################################################################################
if [ -z "$PLEX_LOGIN" ] || [ -z "$PLEX_PASSWORD" ]; then
    PLEX_LOGIN=$1
    PLEX_PASSWORD=$2
fi

while [ -z "$PLEX_LOGIN" ]; do
    >&2 echo -n 'Your Plex login (e-mail or username): '
    read PLEX_LOGIN
done

while [ -z "$PLEX_PASSWORD" ]; do
    >&2 echo -n 'Your Plex password: '
    read PLEX_PASSWORD
done

>&2 echo 'Retrieving a X-Plex-Token using Plex login/password...'

curl -qu "${PLEX_LOGIN}":"${PLEX_PASSWORD}" 'https://plex.tv/users/sign_in.xml' \
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