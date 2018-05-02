#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
echo "plex" > /tmp/program_var

file="/var/plexguide/backup.backoff"
if [ -e "$file" ]
then 
  count=$( cat /var/plexguide/backup.backoff )
  ((count+=1))
  echo "$count" > /var/plexguide/backup.backoff
else
  echo "1" > /var/plexguide/backup.backoff
fi
cat "/var/plexguide/backup.backoff" > /tmp/time_var

display=$( cat /tmp/program_var )

######################## CRON DAY START ##########################
HEIGHT=14
WIDTH=30
CHOICE_HEIGHT=7
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron - $display"
MENU="Select a Day"

OPTIONS=(A "Monday"
         B "Tuesday"
         C "Wednesday"
         D "Thursday"
         E "Friday"
         F "Saturday"
         G "Sunday"
         H "Daily")

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
			echo "1" > /tmp/cron.day
			;;
        B)
			echo "2" > /tmp/cron.day
			;;
        C)
			echo "3" > /tmp/cron.day
			;;
        D)
			echo "4" > /tmp/cron.day
			;;
        E)
			echo "5" > /tmp/cron.day
			;;
        F)
			echo "6" > /tmp/cron.day
			;;
        G)
			echo "0" > /tmp/cron.day
			;;
        H)
			echo "*" > /tmp/cron.day
			;;
esac
######################## CRON DAY END ##########################

######################## CRON DAY HOUR ##########################
HEIGHT=15
WIDTH=30
CHOICE_HEIGHT=8
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron - $display"
MENU="Select an Hour"

OPTIONS=(A "0000 - Midnight"
         B "0300 - 3 AM"
         C "0600 - 6 AM"
         D "0900 - 9 AM"
         E "1200 - Noon"
         F "1500 - 3 PM"
         G "1800 - 6 PM"
         H "2100 - 9 PM")

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
			echo "0" > /tmp/cron.hour
			;;
        B)
			echo "3" > /tmp/cron.hour
			;;
        C)
			echo "6" > /tmp/cron.hour
			;;
        D)
			echo "9" > /tmp/cron.hour
			;;
        E)
			echo "12" > /tmp/cron.hour
			;;
        F)
			echo "15" > /tmp/cron.hour
			;;
        G)
			echo "18" > /tmp/cron.hour
			;;
        H)
			echo "21" > /tmp/cron.hour
			;;
esac
######################## CRON HOUR END ##########################

######################## CRON DAY MINUTE ##########################
HEIGHT=11
WIDTH=30
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron"
MENU="Select the Minutes TimeFrame"

OPTIONS=(A "00 - On the Hour"
         B "15 - 15 Minutes After"
         C "30 - 30 Minutes After"
         D "45 - 45 Minutes After")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        A)
			echo "0" > /tmp/cron.minute
			;;
        B)
			echo "15" > /tmp/cron.minute
			;;
        C)
			echo "30" > /tmp/cron.minute
			;;
        D)
			echo "45" > /tmp/cron.minute
			;;
esac
######################## CRON HOUR MINUTE ##########################

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy2