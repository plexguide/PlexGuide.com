#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & Flicker-Rate
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
echo 'INFO - @PG Version Selection Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

export NCURSES_NO_UTF8_ACS=1

HEIGHT=18
WIDTH=33
CHOICE_HEIGHT=11
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Select A PlexGuide Version"
MENU="Make a Selection:"

OPTIONS=(Z "----- Exit Menu -----"
         01 "EDGE         ~ 6.035"
         02 "Release      ~ 6.034"
         03 "Release      ~ 6.033"
         04 "Release      ~ 6.032"
         05 "Internal Bug Test")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
  Z)
    echo 'INFO - Selected: Exit Upgrade Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    exit 0 ;;
  01)
    file="/var/plexguide/ask.yes"
      if [ -e "$file" ]; then
        echo "INFO - User Selected the Edge Install" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      else
        dialog --title "NOTE" --msgbox "\nThis is a new install!\n\nYou must install a NORMAL Release before EDGE" 0 0
        bash /opt/plexguide/menus/version/main.sh
        exit
      fi
    rm -r /opt/plexguide2 1>/dev/null 2>&1
    ansible-playbook /opt/plexguide/pg.yml --tags pgedge
    rm -r /opt/plexguide 1>/dev/null 2>&1
    mv /opt/plexguide2 /opt/plexguide
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    echo "INFO - Selected: Upgrade to PG EDGE" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
    bash /opt/plexguide/roles/ending/ending.sh
    exit ;;
  02)
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    version="6.034" ;;
  03)
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    version="6.033" ;;
  04)
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    version="6.032" ;;
  05)
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    version="bugtest" ;;
esac

file="/var/plexguide/ask.yes"
if [ -e "$file" ]; then
  touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    if ! dialog --stdout --title "Version User Confirmation" \
       --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
       --yesno "\nDo Want to Install: Version - $version?" 7 50; then
      dialog --title "PG Update Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
      clear
      echo 'INFO - Selected Not To Upgrade PG' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

      sudo bash /opt/plexguide/roles/ending/ending.sh
      exit 0
    else
      clear
    fi
else
  clear
fi

rm -rf /opt/plexguide 2>/dev/null
wget https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/archive/$version.zip -P /tmp
unzip /tmp/$version.zip -d /opt/
mv /opt/PlexG* /opt/plexguide
bash /opt/plexg*/sc*/ins*
rm -r /tmp/$version.zip
touch /var/plexguide/ask.yes 1>/dev/null 2>&1

echo "INFO - Selected: Upgrade to PG $version" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

bash /opt/plexguide/roles/ending/ending.sh
## delete this later
