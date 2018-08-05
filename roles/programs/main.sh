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
echo 'INFO - @Main Programs Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

# This takes .yml file and converts it to bash readable format
sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' /opt/appdata/plexguide/var.yml > /opt/appdata/plexguide/var.sh

HEIGHT=18
WIDTH=26
CHOICE_HEIGHT=12
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="PG Application Suite"

OPTIONS=(A "Media Servers"
         B "Managers"
         C "NZB"
         D "Torrents"
         E "Supporting"
         F "UI Organziers"
         G "Tools"
         H "Backups"
         I "Critical"
         J "4K Versions"
         K "Beta"
         L "WordPress"
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
echo "INFO - Selected Media Servers Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/media.sh ;;
        B)
echo "INFO - Selected Mangers Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/manager.sh ;;
        C)
echo "INFO - Selected NZB Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/nzbs.sh ;;
        D)
echo "INFO - Selected Torrent ProgramsInterface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/torrent.sh ;;
        E)
echo "INFO - Selected Supporting Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/support.sh ;;
        F)
echo "INFO - Selected UI Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/ui.sh ;;
        G)
echo "INFO - Selected Tools Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/tools.sh ;;
        H)
echo "INFO - Selected Backups Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/backups.sh ;;
        I)
echo "INFO - Selected Critical Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/critical.sh ;;
        J)
echo "INFO - Selected 4K Versions Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/versions4k.sh ;;
        K)
echo "INFO - Selected Beta Programs Interface" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/roles/programs/beta.sh ;;
        L)
echo 'INFO - Selected: PG Wordpress' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            bash /opt/plexguide/menus/wordpress/main.sh ;;
        Z)
            clear
            exit 0 ;;
esac

### loops until exit
bash /opt/plexguide/roles/programs/main.sh
