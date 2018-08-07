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

 HEIGHT=12
 WIDTH=55
 CHOICE_HEIGHT=7
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - VPN Programs"

 OPTIONS=(A "DO NOT USE - For Developers Use Only!"
          B "dns-gen"
          Z "Exit")

 CHOICE=$(dialog --clear \
                 --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in
  A)
    clear
    bash /opt/plexguide/scripts/test/move.sh
    echo "Testing files have now been swapped"
    echo "Please go back to the main menu to see changes"
    read -n 1 -s -r -p "Press any key to continue " ;;
  B)
    display=dns-gen
    dialog --infobox "Installing: $display" 3 30
    sleep 2
    clear
    ansible-playbook /opt/plexguide/pg.yml --tags dns-gen
    echo "" && read -n 1 -s -r -p "Press any key to continue"
    cronskip="yes" ;;
  Z)
    clear
    exit 0 ;;
esac
bash /opt/plexguide/roles/programs/beta.sh
