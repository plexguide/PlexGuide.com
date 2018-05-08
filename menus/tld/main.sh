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

HEIGHT=12
WIDTH=38
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="App Selection for Primary Domain"

 OPTIONS=(A "Heimdall"
          B "HTPCManager"
          C "Muximux"
          D "Ombi"
          E "Organizr"
          Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            display=Heimdall
            program=heimdall
            bash /opt/plexguide/menus/plex/main.sh
            echo ",$program" > cat /var/plexguide/tld.$program
            dialog --msgbox "\n$program is now your supported by your Top Level Domain!" 0 0
            ;;
        B)
            display=Emby
            program=emby
            port=8096
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags emby &>/dev/null &
            sleep 3
            dialog --msgbox "\nI would CAUTION you either to make Weekly or Manual Backups of Emby! If your Library is super huge, when it's backing up; it will shut down your EMBY Container and could take several Minutes or Hours!" 0 0
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        C)
            display=Ubooquity
            program=ubooquity
            port=2202
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ubooquity &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;

        D)
            bash /opt/plexguide/menus/tld/clear.sh
            display=Ombi
            program=ombi
            echo ",$program" > cat /var/plexguide/tld.$program
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags $program &>/dev/null &
            dialog --msgbox "\n$program is now your supported by your Top Level Domain!" 0 0
            ;;
        E)
            display=Booksonic
            program=booksonic
            port=4050
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags booksonic &>/dev/null &
            sleep 3
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
            ;;
        Z)
            exit 0 ;;
esac

#recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/media.sh
