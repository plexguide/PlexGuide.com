#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   cmachinol
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
echo 'INFO - @Monitoring PG Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

 HEIGHT=10
 WIDTH=38
 CHOICE_HEIGHT=4
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - Server Monitoring"

 OPTIONS=(A "NETDATA - Basic"
          B "NETDATA - Advanced"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in

	A)
		display=NETDATA-Basic
		program=netdata
		port=19999
		dialog --infobox "Installing: $display" 3 30
		skip=yes
        sleep 2
        clear
		ansible-playbook /opt/plexguide/pg.yml --tags netdata
        read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            
            bash /opt/plexguide/roles/programs/ending.sh
		;;

	B)
		display=NETDATA-Advanced
		program="netdata"
		port="9090"
        sleep 2
        clear
		dialog --infobox "Installing: $display" 3 38
		ansible-playbook /opt/plexguide/pg.yml --tags "monitor"
        read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            
            bash /opt/plexguide/roles/programs/ending.sh
		;;

	Z)
       exit 0 ;;
esac

# 8080 3000 9090
#rm -f /tmp/program
#for prgm in $program; do
#	echo "$prgm" >> /tmp/program
#	done

#rm -f /tmp/port
#for p in $port; do
#	echo "$p" >> /tmp/port
#	done
#"${program[@]}" "${port[@]}"


#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/monitoring.sh
