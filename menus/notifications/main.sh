#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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

file="/var/plexguide/notification.yes"
if [ -e "$file" ]
then
   clear
else
   dialog --infobox "Notice: You can enable PUSH Notifications!\n\nIf NOT READY or DON'T CARE, visit SETTINGS to to put in your INFO later on!" 7 50
   sleep 5
   mkdir -p /opt/appdata/plexguide
   chmod 755 /opt/appdata/plexguide
   echo "corn" > /opt/appdata/plexguide/pushapp
   echo "corn" > /opt/appdata/plexguide/pushuser
   touch /var/plexguide/notification.yes
fi

HEIGHT=10
WIDTH=44
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Notification Manager (Purely Optional)"
MENU="Select Notification Preference(s):"

OPTIONS=(Z "Exit"
         A "Enable Pushover"
         B "Disable Pushover")

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
                dialog --title "Input >> Pushover User Key" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "USER KEY - WINDOWS USERS: SHIFT+INSERT:" 8 45 2>/opt/appdata/plexguide/pushuser
                pushuser=$(cat /opt/appdata/plexguide/pushuser)
                dialog --infobox "Typed Tag: $pushuser" 3 45
                sleep 4

                dialog --title "Input >> Pushover APP Key" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "APP KEY - WINDOWS USERS: SHIFT+INSERT:" 8 45 2>/opt/appdata/plexguide/pushapp
                pushapp=$(cat /opt/appdata/plexguide/pushapp)
                dialog --infobox "Typed Tag: $pushapp" 3 45
                sleep 4

                dialog --infobox "Notice: You can configure more notifications; if you want!\n\nMade an error? Just SELECT it again!" 0 0
                sleep 7
            ;;
        B)
            "fart" > /opt/appdata/plexguide/pushapp
            "butt" > /opt/appdata/plexguide/user
            dialog --infobox "IF this was enabled before, it's now disabled!  Please EXIT!" 0 0
            sleep 6
            ;;
        Z)
            clear
            exit 0 ;;
esac

bash /opt/plexguide/menus/notifications/main.sh
