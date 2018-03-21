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

file="/opt/appdata/plexguide/ports-no"
if [ -e "$file" ]
then
    status="Closed"
else
	status="Open"
fi

dialog --title "Very Important" --msgbox "\nYour Ports Status: $status\n\nYou must decide to keep your PORTS opened or closed.  Only close your PORTS if your REVERSE PROXY (subdomains) are working!" 0 0

############ Menu
HEIGHT=12
WIDTH=45
CHOICE_HEIGHT=5
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Make a Choice"
MENU="Ports are Currently $status"

OPTIONS=(A "Open Ports"
         B "Closed Ports"
         Z "No Change")

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
			rm -r /opt/appdata/plexguide/ports-no 1>/dev/null 2>&1
 			ansible-playbook /opt/plexguide/ansible/config.yml --tags ports --skip-tags closed
 			dialog --title "Note" --msgbox "\nYour Ports Are Open (Worst for Security)" 0 0
            ;;
        B)
			touch /opt/appdata/plexguide/ports-no 1>/dev/null 2>&1	
			ansible-playbook /opt/plexguide/ansible/config.yml --tags ports --skip-tags open
			dialog --title "Note" --msgbox "\nYour Ports Are Open (Best for Security)" 0 0
            ;;
        Z)
            clear
            exit 0 ;;
esac

bash /opt/plexguide/menus/ports/main.sh
