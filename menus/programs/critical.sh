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
TITLE="Applications - PG Critical"

OPTIONS=(A "Portainer"
         B "Domain/Traefik"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=Portainer
            program=portainer
            port=9000
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer 1>/dev/null 2>&1
            cronskip="yes"
            ;;
        B)
            bash /opt/plexguide/menus/traefik/main.sh
            bash /opt/plexguide/menus/programs/critical.sh
            cronskip="yes"
            exit
            ;;   
        Z)
            exit 0 ;;
esac

########## Deploy Start
number=$((1 + RANDOM % 2000))
echo "$number" > /tmp/number_var

########## Cron Job a Program
if [ "$cronskip" == "yes" ]; then
    clear 1>/dev/null 2>&1
else
    bash /opt/plexguide/menus/backup/main.sh
fi 

########## Ending Notifcation Script
echo "$program" > /tmp/program
echo "$port" > /tmp/port
bash /opt/plexguide/menus/programs/ending.sh

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/critical.sh
