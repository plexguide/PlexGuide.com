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

HEIGHT=17
WIDTH=38
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Manager Programs"

OPTIONS=(A "Couchpotato"
         B "Lidarr"
         C "Medusa"
         D "Mylar"
         E "Radarr"
         F "Radarr4k"
         G "Sickrage"
         H "Sonarr"
         I "Sonarr4k"
         J "Lazy Librarian"
         K "Headphones"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=CouchPotato
      program=couchpotato
      port=5050
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags couchpotato &>/dev/null &
      sleep 2 
      cronskip="no"
      ;;

    B)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=Lidarr
      program=lidarr
      port=8686
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lidarr &>/dev/null &
      sleep 2
      cronskip="no"
      ;;
    C)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=MEDUSA
      program=medusa
      port=8081
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags medusa &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    D)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=Mylar
      program=mylar
      port=8090
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags mylar &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    E)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=Radarr
      program=radarr
      port=7878
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/radarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/radarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      cronskip="no"
      ;;

    F)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=Radarr4k
      program=radarr4k
      port=7874
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr4k 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/radarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/radarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1 
      cronskip="no"
      ;;

    G)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=SickRage
      program=sickrage
      port=8082
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sickrage &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    H)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=Sonarr
      program=sonarr
      port=8989
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/sonarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/sonarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      cronskip="no"
      ;;
    I)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=Sonarr4k
      program=sonarr4k
      port=8984
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr4k 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/sonarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/sonarr4k/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      cronskip="no"
      ;;
    J)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=LazyLibrarian
      program=lazy
      port=5299
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags lazy &>/dev/null &
      cronskip="no"
      sleep 2
      ;;
    K)
      file="/var/plexguide/nzb.discount3" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          bash /opt/plexguide/menus/nzb/main33.sh
          else
        touch /var/plexguide/nzb.discount3
        bash /opt/plexguide/menus/nzb/main.sh
        fi
      display=Headphones
      program=headphones
      port=8081
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags headphones &>/dev/null &
      cronskip="no"
      sleep 2
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

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/manager.sh
