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
echo 'INFO - @UI Programs Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

 HEIGHT=11
 WIDTH=38
 CHOICE_HEIGHT=5
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
      echo 'INFO - Selected: HeimDall' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      clear && ansible-playbook /opt/plexguide/pg.yml --tags heimdall
      read -n 1 -s -r -p "Press any key to continue"
      bash /opt/plexguide/menus/time/cron.sh
      ;;
    B)
      program=htpcmanager
      display=HTPCManager
      dialog --infobox "Installing: $display" 3 30
      sleep 2
      clear
      port=8085
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags htpcmanager
      read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
      ;;
    C)
      program=muximux
      display=MUXIMUX
      dialog --infobox "Installing: $display" 3 30
      sleep 2
      clear
      port=8015
      ansible-playbook /opt/plexguide/pg.yml --tags muximux
      read -n 1 -s -r -p "Press any key to continue"
            echo "$program" > /tmp/program
            echo "$program" > /tmp/program_var
            echo "$port" > /tmp/port
            bash /opt/plexguide/menus/time/cron.sh
            bash /opt/plexguide/menus/programs/ending.sh
      ;;

      D)
        program=organizr
        display=Organizr
        dialog --infobox "Installing: $display" 3 30
        sleep 2
        clear
        port=8020
        ansible-playbook /opt/plexguide/pg.yml --tags organizr
        read -n 1 -s -r -p "Press any key to continue"
              echo "$program" > /tmp/program
              echo "$program" > /tmp/program_var
              echo "$port" > /tmp/port
              bash /opt/plexguide/menus/time/cron.sh
              bash /opt/plexguide/menus/programs/ending.sh
        ;;
        E)
          program=organizrv2
          display=OrganizrV2
          dialog --infobox "Installing: $display" 3 30
          sleep 2
          clear
          port=8040
          ansible-playbook /opt/plexguide/pg.yml --tags organizrv2
          read -n 1 -s -r -p "Press any key to continue"
                echo "$program" > /tmp/program
                echo "$program" > /tmp/program_var
                echo "$port" > /tmp/port
                bash /opt/plexguide/menus/time/cron.sh
                bash /opt/plexguide/menus/programs/ending.sh
      ;;
    Z)
       exit 0 ;;
esac

    clear

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/ui.sh
