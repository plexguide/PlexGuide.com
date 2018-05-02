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
######################## CRON DAY START ##########################
HEIGHT=14
WIDTH=40
CHOICE_HEIGHT=7
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron"
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
			"1" > /tmp/cron.day
			;;
        B)
			"2" > /tmp/cron.day
			;;
        C)
			"3" > /tmp/cron.day
			;;
        D)
			"4" > /tmp/cron.day
			;;
        E)
			"5" > /tmp/cron.day
			;;
        F)
			"6" > /tmp/cron.day
			;;
        G)
			"0" > /tmp/cron.day
			;;
        H)
			"*" > /tmp/cron.day
			;;
esac
######################## CRON DAY END ##########################

######################## CRON DAY HOUR ##########################
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=8
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Cron"
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
			"0" > /tmp/cron.hour
			;;
        B)
			"3" > /tmp/cron.hour
			;;
        C)
			"6" > /tmp/cron.hour
			;;
        D)
			"9" > /tmp/cron.hour
			;;
        E)
			"12" > /tmp/cron.hour
			;;
        F)
			"15" > /tmp/cron.hour
			;;
        G)
			"18" > /tmp/cron.hour
			;;
        H)
			"21" > /tmp/cron.hour
			;;
esac
######################## CRON HOUR END ##########################

######################## CRON DAY MINUTE ##########################
HEIGHT=14
WIDTH=48
CHOICE_HEIGHT=7
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

clear
case $CHOICE in
        A)
			"0" > /tmp/cron.minute
			;;
        B)
			"15" > /tmp/cron.minute
			;;
        C)
			"30" > /tmp/cron.minute
			;;
        D)
			"45" > /tmp/cron.minute
			;;
esac
######################## CRON HOUR MINUTE ##########################