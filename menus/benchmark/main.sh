#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 - Deiteq - The Creator
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
echo $domain

HEIGHT=11
WIDTH=45
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Benchmark Applications"

OPTIONS=(A "System Info and Benchmark - Basic"
         B "System Info and Benchmark - Advanced"
         C "System Info and Benchmark - Custom"
         D "Simple Speed Test"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
            clear
            sudo wget -qO- bench.sh | bash ;;
        B)
            clear
            curl -LsO raw.githubusercontent.com/thecreatorzone/plexguide-bench/master/bench.sh; chmod +x bench.sh; chmod +x bench.sh
            echo ""
            ./bench.sh -a
            echo ""
            read -n 1 -s -r -p "Press any key to continue" 
            ;;
        C)
            clear
            bash /opt/plexguide/scripts/menus/bench-custom.sh 
            echo ""
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        D)
            clear
            pip install speedtest-cli
            echo
            speedtest-cli 
            echo ""
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        Z)
            exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/benchmark/main.sh
