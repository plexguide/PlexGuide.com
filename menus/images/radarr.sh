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
# Important below, name based on target
app="Radarr"
############################
export NCURSES_NO_UTF8_ACS=1
HEIGHT=12
WIDTH=36
CHOICE_HEIGHT=6
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Select Your Image for $app"
MENU="Make a Selection Choice:"
OPTIONS=(A "linuxserver/radarr: Recommended"
         B "hotio/suitarr     : Space Saver"
         C "aront/radarr      : MP Convertor"
         D "Why Important: FAQ"
         Z "Exit")


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
            echo "linuxserver/radarr" > /var/plexguide/image.radarr
            echo "" > /var/plexguide/image.radarr.path
            ;;
        B)
            echo "hotio/suitarr" > /var/plexguide/image.radarr
            echo "" > /var/plexguide/image.radarr.path
            ;;
        C)
            dialog --title "Note" --msgbox "\nPRESS the ESC Key To Exit!" 0 0
            ctop ;;
        D)
            bash /opt/plexguide/menus/info-tshoot/info/status-menu.sh ;;
        Z)
            clear
            exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/menus/info-tshoot/info.sh
