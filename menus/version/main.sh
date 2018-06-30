#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq - Flicker-Rate
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
echo 'INFO - @PG Version Selection Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

export NCURSES_NO_UTF8_ACS=1
clear

HEIGHT=18
WIDTH=33
CHOICE_HEIGHT=11
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Select A PlexGuide Version"
MENU="Make a Selection:"

OPTIONS=(00 "Developer     ~ 6.000"
         Z "------ Exit Menu ------"
         01 "BETA 3        ~ 6.000"
         02 "Historical    ~ 5.1"
         03 "Historical    ~ 5.048"
         04 "Historical    ~ 5.013"
         05 "Historical    ~ 5.004"
         06 "Historical    ~ 4.1")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        00)
echo 'INFO - Selected to Upgrade PG to DEV Edition' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

            version="Developer"

            file="/var/plexguide/ask.yes"
            if [ -e "$file" ]
            then
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            if ! dialog --stdout --title "Version User Confirmation" \
               --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
               --yesno "\nDo You Want Install Version - $version?" 7 50; then
               dialog --title "PG Update Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
            clear
            sudo bash /opt/plexguide/scripts/message/ending.sh
            exit 0
                else
            clear
            fi

            else
                clear
            fi
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            mv /opt/plexguide/scripts/docker-no/upgrade2.sh /tmp
            cd /tmp
            bash /tmp/upgrade2.sh
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1

            dialog --title "PG Application Status" --msgbox "\nUpgrade Complete - Version $version!" 0 0
            clear
            sudo bash /opt/plexguide/scripts/message/ending.sh
            exit 0 ;;
        Z)
            bash /opt/plexguide/menus/main.sh
echo 'INFO - Selected: Exit Upgrade Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            exit 0
            ;;
        01)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="6.000" ;;
        02)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.1" ;;
        03)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.048" ;;
        04)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.013" ;;
        05)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="5.003" ;;
        06)
            touch /var/plexguide/ask.yes 1>/dev/null 2>&1
            version="Legacy-v4" ;;
esac

file="/var/plexguide/ask.yes"
if [ -e "$file" ]
then

touch /var/plexguide/ask.yes 1>/dev/null 2>&1
if ! dialog --stdout --title "Version User Confirmation" \
   --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
   --yesno "\nDo Want to Install: Version - $version?" 7 50; then
   dialog --title "PG Update Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
clear
echo 'INFO - Selected Not To Upgrade PG' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

sudo bash /opt/plexguide/scripts/message/ending.sh
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

echo "INFO - Selected: Upgrade to PG $version" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

bash /opt/plexguide/scripts/message/ending.sh

## delete this later
