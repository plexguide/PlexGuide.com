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
echo 'INFO - @Main Torrent Program Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

 HEIGHT=12
 WIDTH=38
 CHOICE_HEIGHT=6
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - Torrent Programs"

 OPTIONS=(A "qBittorrent"
          B "RuTorrent"
          C "Deluge"
          D "Jackett"
          E "VPN Options"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in

      A)
        echo 'INFO - Selected: QBittorrent' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        clear && ansible-playbook /opt/plexguide/pg.yml --tags qbittorrent --extra-vars "quescheck=on cron=on display=on"
        echo "" && read -n 1 -s -r -p "Press any key to continue"
        ;;
      B)
        echo 'INFO - Selected: RuTorrent' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        clear && ansible-playbook /opt/plexguide/pg.yml --tags rutorrent --extra-vars "quescheck=on cron=on display=on"
        echo "" && read -n 1 -s -r -p "Press any key to continue"
        ;;
      C)
         echo 'INFO - Selected: Deluge' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
         clear && ansible-playbook /opt/plexguide/pg.yml --tags deluge --extra-vars "quescheck=on cron=on display=on"
         echo "" && read -n 1 -s -r -p "Press any key to continue"
         ;;
        D)
        echo 'INFO - Selected: Jackett' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        clear && ansible-playbook /opt/plexguide/pg.yml --tags jackett --extra-vars "quescheck=on cron=on display=on"
        echo "" && read -n 1 -s -r -p "Press any key to continue"
        ;;
     E)
       bash /opt/plexguide/menus/programs/vpn.sh ;;
     Z)
       exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/roles/programs/torrent.sh
