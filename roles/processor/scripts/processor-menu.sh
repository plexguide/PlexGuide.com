#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & Bryde ツ
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
echo 'INFO - @Main Processor Profiles - processor-menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

edition=$( cat /var/plexguide/pg.edition ) 1>/dev/null 2>&1
version=$( cat /var/plexguide/pg.server.deploy ) 1>/dev/null 2>&1

HEIGHT=11
WIDTH=40
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Processor Mode - RISK!"

OPTIONS=(A "Performance Mode"
         B "Ondemand Mode"
         C "Conservative Mode"
         D "View Processor Policy"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

#if (dialog --title "Virutal Machine Question" --yesno "Are You Utilizing A Virtual Machine or VPS?" 0 0) then
#  echo 'INFO - Selected: Processor Profile - Is VPS' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
#  dialog --title "Virutal Machine - Yes" --msgbox "We are unable to adjust your CPU performance while utilizing a VM or VPS. Trust me, it does not work if you try!" 0 0
#  exit
#else
#  echo 'INFO - Selected: Processor Profile - Is Dedicated' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
#  dialog --title "Virutal Machine - No" --msgbox "We recommend that you select performance mode. By default, your utilizing ondemand mode. Mode does not kick in until you REBOOT!" 0 0
#fi

case $CHOICE in
  A)
    echo 'INFO - Selected: Processor Profile - Performance Mode' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/roles/processor/processor.yml  --tags performance
    echo ""
    read -n 1 -s -r -p "Press any key to continue - will reboot the machine"
    bash /opt/plexguide/roles/processor/scripts/reboot.sh ;;
  B)
    echo 'INFO - Selected: Processor Profile - Ondemand Mode' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/roles/processor/processor.yml  --tags ondemand
    echo ""
    read -n 1 -s -r -p "Press any key to continue - will reboot the machine"
    bash /opt/plexguide/roles/processor/scripts/reboot.sh ;;
  C)
    echo 'INFO - Selected: Processor Profile - Conservative Mode' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && ansible-playbook /opt/plexguide/roles/processor/processor.yml  --tags conservative
    echo ""
    read -n 1 -s -r -p "Press any key to continue - will reboot the machine"
    bash /opt/plexguide/roles/processor/scripts/reboot.sh ;;
  D)
    echo 'INFO - Selected: Processor Profile - View Processor Policy' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear && cpufreq-info
    echo ""
    read -n 1 -s -r -p "Press any key to continue - will reboot the machine" ;;
  Z)
    echo 'INFO - Selected: Exit Kernal mode menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    bash /opt/plexguide/roles/ending/ending.sh
    exit 0 ;;
esac
## repeat menu when exiting
echo 'INFO - Looping: Kernal Mod Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/roles/processor/scripts/processor-menu-new.sh
exit
