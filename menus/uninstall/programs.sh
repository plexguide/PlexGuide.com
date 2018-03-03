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

dialog --inputbox "This is an input box  with named pipe" 40 5 2> /tmp/namedPipe1 &

OUTPUT="$( cat /tmp/namedPipe1  )" # release contents of pipe

echo  "This is the output " $OUTPUT


read -n 1 -s -r -p "Press any key to continue "



HEIGHT=11
WIDTH=32
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Version Install"
MENU="Make a Selection"

OPTIONS=(- "P"
         - "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        A)

            exit 0 ;;
        B)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.059" ;;
        Z)
            clear
            exit 0
            ;;
esac