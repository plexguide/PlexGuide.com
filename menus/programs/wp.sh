#!/bin/bash
#
# [PlexGuide Critical Menu]
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

export NCURSES_NO_UTF8_ACS=1
## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
domain=$( cat /var/plexguide/server.domain )

HEIGHT=9
WIDTH=38
CHOICE_HEIGHT=4
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - WordPress"

OPTIONS=(A "Deploy WP to Main Domain"
         B "Deploy WP to a SubDomain"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

######## Goal is so user can deploy a wordpress site based on an ID from 1-99
######## 



case $CHOICE in
        A)
            clear ;;
        B)
            exit 
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags wordpress
            ;;
        Z)
            exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/wp.sh
