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
echo 'INFO - @Benchmark Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

export NCURSES_NO_UTF8_ACS=1
## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)

HEIGHT=12
WIDTH=45
CHOICE_HEIGHT=6
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Benchmark Applications"

OPTIONS=(A "System Info and Benchmark - Basic"
         B "System Info and Benchmark - Advanced"
         C "System Info and Benchmark - Custom"
         D "Simple Speed Test"
         E "SpeedTEST Server (Container)"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
echo "INFO - Selected: Info & Benchmark - Basic" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear
            sudo wget -qO- bench.sh | bash
            echo ""
            read -n 1 -s -r -p "Press any key to continue"            ;;
        B)
echo "INFO - Selected: Info & Benchmark - Advanced" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear
            curl -LsO raw.githubusercontent.com/thecreatorzone/plexguide-bench/master/bench.sh; chmod +x bench.sh; chmod +x bench.sh
            echo ""
            ./bench.sh -a
            echo ""
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        C)
echo "INFO - Selected: Info & Benchmark - Custom" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear
            bash /opt/plexguide/scripts/menus/bench-custom.sh
            echo ""
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        D)
echo "INFO - Selected: Simple Speed TEst" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            clear
            pip install speedtest-cli
            echo
            speedtest-cli
            echo ""
            read -n 1 -s -r -p "Press any key to continue"
            ;;
        E)
echo "INFO - Selected: Speed Test Server"> /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            program=speed
            port=8223
            dialog --infobox "Installing: SpeedTEST Server" 3 38
            ansible-playbook /opt/plexguide/pg.yml --tags speedtestserver 1>/dev/null 2>&1

            echo "$program" > /tmp/program
            echo "$port" > /tmp/port
            #### Pushes Out Ending
            bash /opt/plexguide/roles/programs/ending.sh
            #### recall itself to loop unless user exits
            bash /opt/plexguide/roles/programs/support.sh
            ;;
        Z)
            exit 0 ;;
esac

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/benchmark/main.sh
