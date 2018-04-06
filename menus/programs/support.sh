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
skip=no
## point to variable file for ipv4 and domain.com
domain=$( cat /var/plexguide/server.domain )

HEIGHT=15
WIDTH=37
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - PG Supporting"

OPTIONS=(A "Netdata"
         B "Ombi"
         C "Ombi4k"
         D "NextCloud"
         E "pyLoad"
         F "Resilio"
         G "Tautulli"
         H "SpeedTEST Server"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=NETDATA
            program=netdata
            port=19999
            dialog --infobox "Installing: $display" 3 30
            skip=yes
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata 1>/dev/null 2>&1;;
        B)
            display=Ombi
            program=ombi
            port=3579
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi 1>/dev/null 2>&1;;
        C)
            display=Ombi4K
            program=ombi4k
            port=3574
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ombi 1>/dev/null 2>&1;;
        D)
            display=NEXTCloud
            program=nextcloud
            port=4645
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags next 1>/dev/null 2>&1 ;;
        E)
            display=PYLoad
            program=pyload
            port=8000
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pyLoad 1>/dev/null 2>&1 ;;
        F)
            display=RESILIO
            program=resilio
            port=8888
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags resilio 1>/dev/null 2>&1 ;;
        G)
            display=Tautulli
            program=tautulli
            port=8181
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tautulli 1>/dev/null 2>&1

            vers=$( cat /var/plexguide/provider )
            if [ "$vers" == "null" ]
            then
                clear 1>/dev/null 2>&1
            else
              --msgbox "Using Traefikv2 & Tautulli\n\nAs a result, you can use the following subdomains and domains\ntautulli.domain.com\nplexply.domain.com" 0 0
            fi
            ;;
        H)
            program=speed
            port=8223
            dialog --infobox "Installing: SpeedTEST Server" 3 38
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags speedtestserver 1>/dev/null 2>&1

            echo "$program" > /tmp/program
            echo "$port" > /tmp/port
            #### Pushes Out Ending
            bash /opt/plexguide/menus/programs/ending.sh
            #### recall itself to loop unless user exits
            bash /opt/plexguide/menus/programs/support.sh
            exit 
            ;;
        Z)
            exit 0 ;;
    esac

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
    TITLE="Schedule a Backup of --$display --?"

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
                dialog --infobox "Establishing [Weekly] CronJob" 3 34
                echo "$program" > /tmp/program_var
                echo "weekly" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy 1>/dev/null 2>&1
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            B)
                dialog --infobox "Establishing [Daily] CronJob" 3 34
                echo "$program" > /tmp/program_var
                echo "daily" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy 1>/dev/null 2>&1
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            Z)
                dialog --infobox "Removing CronJob (If Exists)" 3 34
                echo "$program" > /tmp/program_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nocron 1>/dev/null 2>&1
                --msgbox "\nNo Daily Backups will Occur of -- $display --!" 0 0
                clear ;;
    esac
fi
########## Deploy End
clear

echo "$program" > /tmp/program
echo "$port" > /tmp/port
#### Pushes Out Ending
bash /opt/plexguide/menus/programs/ending.sh

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/support.sh
