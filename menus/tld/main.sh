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
            
            program="heimdall"
            echo ",$program" > cat /var/plexguide/tld.$program
            bash /opt/plexguide/menus/tld/rebuild.sh
            dialog --msgbox "\n$program is now your supported by your Top Level Domain!" 0 0
            ;;
        B)
            echo "$heimdall" > /var/plexguide/tld.var
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags emby &>/dev/null &

            ;;
        C)
            echo "$heimdall" > /var/plexguide/tld.var
            port=2202
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags ubooquity &>/dev/null &
            sleep 3

            ;;

        D)
            echo "$heimdall" > /var/plexguide/tld.var
            display=Ombi
            program=ombi
            echo ",$program" > cat /var/plexguide/tld.$program
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags $program &>/dev/null &
            ;;
        E)
            echo "$heimdall" > /var/plexguide/tld.var
            display=Booksonic
            program=booksonic
            port=4050
            dialog --infobox "Installing: $display" 3 30
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags booksonic &>/dev/null &
            sleep 3
            ;;
        Z)
            exit 0 ;;
esac

#recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/media.sh
