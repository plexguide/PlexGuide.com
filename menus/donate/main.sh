#!/bin/bash
#
# [PlexGuide Menu]
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

dialog --title "PG Application Status" --msgbox "\nWould you be kind enough to TURN ON the Donation Option to mine for coins. This runs as a container; not installed on your machine, which SCALES against (downward) your programs being the lowest of priroity.  \nThe donation option utilizes UNUSED processing power and will not interfere with Plex or other programs.  This assists in further development and motivation. This option can be turned off anytime." 0 0

HEIGHT=11
WIDTH=50
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Donation Question"

OPTIONS=(A "Scaling (Best): Unused Processiong Power"
         B "Dedicate Cores: NOT READY"
         C "Percent Power : NOT READY"
         Z "No Thank You")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags support
            dialog --title "Message" --msgbox "\nThank You So Much For Your Support!" 0 0
            exit 0
            ;;
        B)
            clear
            ;;
        C) 
            clear
            ;;
        Z)
            exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/donate/main.sh
