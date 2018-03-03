#!/bin/bash
#
# [PlexGuide Restore Script]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - deiteq
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

mkfifo /tmp/namedPipe1 # this creates named pipe, aka fifo

dialog --inputbox "Name of the Program You Want to Uninstall" 8 40 2> /tmp/namedPipe1 &
OUTPUT="$( cat /tmp/namedPipe1 )"


echo  "This is the output " $OUTPUT
echo "$OUTPUT" | awk '{print tolower($0)}' 2> /tmp/namedPipe1 &
OUTPUT="$( cat /tmp/namedPipe )"
echo "$OUTPUT"
docker stop $OUTPUT
docker rm $OUTPUT


read -n 1 -s -r -p "Press any key to continue "

