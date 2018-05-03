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
display=$( cat /tmp/program_var )
timeinfo=$( date "+%H:%M:%S - %m/%d/%y" )

HEIGHT=10
WIDTH=39
CHOICE_HEIGHT=3
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron Job for $display"
MENU="Server Time: $timeinfo"

OPTIONS=(A "Backup Cron Job - On"
         B "Backup Cron Job - Off"
         C "Server Time Change")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
                        
                        ;;
        B)
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags remove &>/dev/null &
            dialog --title "Notice" --msgbox "\nThe backup for $display has been ignored and/or removed!\n\nWant to see it, Type crontab -e in the Command Line! " 0 0
            exit
                        ;;
        C)
            dpkg-reconfigure tzdata
            bash /opt/plexguide/menus/time/cron.sh
            exit
                        ;;
esac


###################### KICKOFF ###################################

file="/var/plexguide/backup.backoff"
if [ -e "$file" ]
then 
  count=$( cat /var/plexguide/backup.backoff )

  if [ "$count" -gt "300" ]; then
  count=$((count-287))
  fi

  count=$((count+5))
  echo "$count" > /var/plexguide/backup.backoff
else
  echo "1" > /var/plexguide/backup.backoff
fi
cat "/var/plexguide/backup.backoff" > /tmp/time_var

######################## CRON DAY START ##########################
HEIGHT=15
WIDTH=25
CHOICE_HEIGHT=8
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron - $display"
MENU="Select Day TimeFrame"

OPTIONS=(A "Monday"
         B "Tuesday"
         C "Wednesday"
         D "Thursday"
         E "Friday"
         F "Saturday"
         G "Sunday"
         H "DAILY")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
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
HEIGHT=17
WIDTH=27
CHOICE_HEIGHT=10
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron - $display"
MENU="Select Hour TimeFrame"

OPTIONS=(A "0000 - Midnight"
         B "0200 - 2 AM"
         C "0400 - 4 AM"
         D "0600 - 6 AM"
         E "0900 - 9 AM"
         F "1200 - Noon"
         G "1500 - 3 PM"
         H "1800 - 6 PM"
         I "2100 - 9 PM"
         J "2300 - 11PM")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
			echo "23" > /tmp/cron.hour
			;;
        B)
            echo "1" > /tmp/cron.hour
            ;;
        C)
			echo "3" > /tmp/cron.hour
			;;
        D)
			echo "5" > /tmp/cron.hour
			;;
        E)
			echo "8" > /tmp/cron.hour
			;;
        F)
			echo "11" > /tmp/cron.hour
			;;
        G)
			echo "14" > /tmp/cron.hour
			;;
        H)
			echo "17" > /tmp/cron.hour
			;;
        I)
			echo "22" > /tmp/cron.hour
			;;
        J)
            echo "23" > /tmp/cron.hour
            ;;
esac
######################## CRON HOUR END ##########################

######################## CRON DAY MINUTE ##########################
HEIGHT=11
WIDTH=30
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron - $display"
MENU="Select Minute TimeFrame"

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

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags deploy2 &>/dev/null &
dialog --title "Notice" --msgbox "\nThe backup for $display has been deployed\n\nWant to see it, Type crontab -e in the Command Line! " 0 0
