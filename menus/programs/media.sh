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
  echo $domain

HEIGHT=10
WIDTH=38
CHOICE_HEIGHT=5
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Media Programs"

OPTIONS=(A "Plex"
         B "Emby"
         C "Ubooquity"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            clear
            program=plex
            port=32400

            bash /opt/plexguide/menus/plex/main.sh ;;
            --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of PLEX. If your Library is super huge, when it's backing up; it will shut down your PLEX Container and could take several Minutes or Hours!" 0 0
        B)
            clear
            program=emby
            port=8096
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags emby ;;
            --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of Emby! If your Library is super huge, when it's backing up; it will shut down your PLEX Container and could take several Minutes or Hours!" 0 0

        C)
            clear
            program=ubooquity
            port=2202
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ubooquity ;;

        Z)
            exit 0 ;;
esac

    clear

########## Deploy Start
number=$((1 + RANDOM % 2000))
echo "$number" > /tmp/number_var

if [ "$skip" == "yes" ]; then
    clear
else

    HEIGHT=9
    WIDTH=42
    CHOICE_HEIGHT=5
    BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
    TITLE="Schedule a Backup of --$program --?"

    OPTIONS=(A "Weekly"
             B "Daily"
             Z "None")

    CHOICE=$(dialog --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

    case $CHOICE in
            A)
                clear
                echo "$program" > /tmp/program_var
                echo "weekly" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy
                read -n 1 -s -r -p "Press any key to continue "
                --msgbox "\nBackups of -- $program -- will occur!" 0 0 ;;
            B)
                clear
                echo "$program" > /tmp/program_var
                echo "daily" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy
                read -n 1 -s -r -p "Press any key to continue "
                --msgbox "\nBackups of -- $program -- will occur!" 0 0 ;;
            Z)
                --msgbox "\nNo Daily Backups will Occur of -- $program --!" 0 0
                clear ;;
    esac
fi
########## Deploy End


    dialog --title "$program - Address Info" \
    --msgbox "\nIPv4      - http://$ipv4:$port\nSubdomain - https://$program.$domain\nDomain    - http://$domain:$port" 8 50

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/media.sh
