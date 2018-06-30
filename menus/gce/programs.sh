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
echo 'INFO - @GCE Program Select Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

HEIGHT=16
WIDTH=38
CHOICE_HEIGHT=10
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Applications - Manager Programs"

OPTIONS=(A "NZBGET"
         B "Sonarr"
         C "Radarr"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      display=NZBGET
      program=nzbget
      port=6789
      bash /opt/plexguide/menus/images/nzbget.sh
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/pg.yml --tags nzbget &>/dev/null &
      sleep 3
      echo "$program" > /tmp/program
      echo "$program" > /tmp/program_var
      echo "$port" > /tmp/port
      bash /opt/plexguide/menus/time/cron.sh
      bash /opt/plexguide/menus/programs/ending.sh
      ;;
    B)
      display=Sonarr
      program=sonarr
      port=8989
      bash /opt/plexguide/menus/images/sonarr.sh
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/pg.yml --tags sonarr 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/sonarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/sonarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      sleep 3
      echo "$program" > /tmp/program
      echo "$program" > /tmp/program_var
      echo "$port" > /tmp/port
      bash /opt/plexguide/menus/time/cron.sh
      bash /opt/plexguide/menus/programs/ending.sh
      ;;
    C)
      display=Radarr
      program=radarr
      port=7878
      bash /opt/plexguide/menus/images/radarr.sh
      dialog --infobox "Installing: $display" 3 30
      ansible-playbook /opt/plexguide/pg.yml --tags radarr 1>/dev/null 2>&1
      chown 1000:1000 /opt/appdata/radarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
      chmod 0755 /opt/appdata/radarr/mp4_automator/autoProcess.ini 1>/dev/null 2>&1
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

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/gce/programs.sh
