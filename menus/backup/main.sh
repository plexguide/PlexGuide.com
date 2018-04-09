#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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

number=$((1 + RANDOM % 2000))
#echo "$number" > /tmp/number_var
display=$( cat /tmp/program_var )

HEIGHT=10
WIDTH=42
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Schedule a Backup of --$display --?"

    OPTIONS=(A "Monthly"
             B "Weekly"
             C "Daily"
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
                echo "monthly" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy &>/dev/null &
                sleep 2
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            B)
                dialog --infobox "Establishing [Daily] CronJob" 3 34
                echo "weekly" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy &>/dev/null &
                sleep 2
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            C)
                dialog --infobox "Establishing [Daily] CronJob" 3 34
                echo "daily" > /tmp/time_var
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy &>/dev/null &
                sleep 2
                --msgbox "\nBackups of -- $display -- will occur!" 0 0 ;;
            Z)
                dialog --infobox "Removing CronJob (If Exists)" 3 34
                ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nocron &>/dev/null &
                sleep 2
                --msgbox "\nNo Daily Backups will Occur of -- $display --!" 0 0
                clear ;;
    esac
fi