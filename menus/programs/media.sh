#!/bin/bash
#
# [PlexGuide Menu]
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

 ### demo ip / comment out when done
 #ipv4=69.69.69.69

HEIGHT=12
WIDTH=38
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Media Programs"

OPTIONS=(A "Plex"
         B "Emby"
         C "Ubooquity"
         D "Airsonic"
         E "Booksonic"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=PLEX
            program=plex
            port=32400
            bash /opt/plexguide/menus/plex/main.sh

            file="/tmp/plexsetup"
            if [ -e "$file" ]
            then
                clear 1>/dev/null 2>&1
            else
                bash /opt/plexguide/menus/programs/media.sh
                exit
            fi
            dialog --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of PLEX. If your Library is super huge, when it's backing up; it will shut down your PLEX Container and could take several Minutes or Hours!" 0 0
            cronskip=no
            ;;
        B)
            display=Emby
            program=emby
            port=8096
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags emby &>/dev/null &
            sleep 2
            dialog --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of Emby! If your Library is super huge, when it's backing up; it will shut down your EMBY Container and could take several Minutes or Hours!" 0 0
            cronskip=no
            ;;
        C)
            display=Ubooquity
            program=ubooquity
            port=2202
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ubooquity &>/dev/null &
            sleep 2
            cronskip=no
            ;;

        D)
            display=Airsonic
            program=airsonic
            port=4040
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags airsonic &>/dev/null &
            sleep 2
            dialog --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of Airsonic! If your Library is super huge, when it's backing up; it will shut down your Airsonic Container and could take several Minutes or Hours!" 0 0
            cronskip=no
            ;;
        E)
            display=Booksonic
            program=booksonic
            port=4050
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags booksonic &>/dev/null &
            sleep 2
            dialog --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of Boosonic! If your Library is super huge, when it's backing up; it will shut down your Booksonic Container and could take several Minutes or Hours!" 0 0
            cronskip=no
            ;;
        Z)
            exit 0 ;;
esac

    clear

########## Cron Job a Program
echo "$program" > /tmp/program_var
if [ "$cronskip" == "yes" ]; then
    clear 1>/dev/null 2>&1
else
    bash /opt/plexguide/menus/backup/main.sh
fi

echo "$program" > /tmp/program
echo "$port" > /tmp/port
#### Pushes Out Ending
bash /opt/plexguide/menus/programs/ending.sh

#recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/media.sh
