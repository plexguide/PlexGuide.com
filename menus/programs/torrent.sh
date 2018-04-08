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

 HEIGHT=10
 WIDTH=38
 CHOICE_HEIGHT=4
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - Torrent Programs"

 OPTIONS=(A "RuTorrent"
          B "Deluge"
          C "Jackett"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in

     A)
       display=RUTorrent
       program=rutorrent
       echo "$program" > /tmp/program_var
       dialog --infobox "Installing: $display" 3 30
       port=8999
       ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags rutorrent 1>/dev/null 2>&1 
       cronskip=no
       ;;

     B)
       display=Deluge
       program=deluge
       echo "$program" > /tmp/program_var
       dialog --infobox "Installing: $display" 3 30
       port=8112
       ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deluge 1>/dev/null 2>&1 
       cronskip=no
       ;;

     C)
       display=Jackett
       program=jackett
       echo "$program" > /tmp/program_var
       dialog --infobox "Installing: $display" 3 30
       port=9117
       ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags jackett 1>/dev/null 2>&1 
       cronskip=no
       ;;

     Z)
       exit 0 ;;
esac

########## Cron Job a Program
if [ "$cronskip" == "yes" ]; then
    clear 1>/dev/null 2>&1
else
    bash /opt/plexguide/menus/backup/main.sh
fi 

echo "$program" > /tmp/program
echo "$port" > /tmp/port
#### Pushes Out Ending
bash /opt/plexguide/menus/programs/ending.sh

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/torrent.sh
