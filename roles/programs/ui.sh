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
echo 'INFO - @UI Programs Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

 HEIGHT=12
 WIDTH=38
 CHOICE_HEIGHT=6
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - Manager Programs"

 OPTIONS=(A "Heimdall"
          B "HTPCManager"
          C "Muximux"
          D "Organizr"
          E "OrganizrV2"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in

      A)
        echo 'INFO - Selected: HeimDall' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        clear && ansible-playbook /opt/plexguide/pg.yml --tags pgrole --extra-vars "mod=heimdall"
        read -n 1 -s -r -p "Press any key to continue"
        ;;
      B)
      echo 'INFO - Selected: Muximux' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags pgrole --extra-vars "mod=htpcmanager"
      read -n 1 -s -r -p "Press any key to continue"
        ;;
      C)
          echo 'INFO - Selected: Muximux' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
          clear && ansible-playbook /opt/plexguide/pg.yml --tags muximux --extra-vars "skipend=no"
          read -n 1 -s -r -p "Press any key to continue"
          ;;
      D)
        echo 'INFO - Selected: Organizr' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        clear && ansible-playbook /opt/plexguide/pg.yml --tags organizr --extra-vars "skipend=no"
        read -n 1 -s -r -p "Press any key to continue"
        ;;
        E)
        echo 'INFO - Selected: OrganizrV2' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        clear && ansible-playbook /opt/plexguide/pg.yml --tags organizrv2 --extra-vars "skipend=no"
        read -n 1 -s -r -p "Press any key to continue"
        ;;
     Z)
       exit 0 ;;
esac
    clear

#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/ui.sh
