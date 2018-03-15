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

HEIGHT=14
WIDTH=59
CHOICE_HEIGHT=8
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="PG Settings"
MENU="Make Your Selection Choice:"

OPTIONS=(A "Domain       : Set/Change a Domain"
         B "Notifications: Enable the Use of Notifications"
         C "Ports        : Turn On/Off Application Ports"
         D "Processor    : Enhance Processing Power"
         E "Redirect     : Force Apps to use HTTPS Only?"
         F "SuperSpeeds  : Change Gdrive Transfer Settings"
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
################################################# START
if dialog --stdout --title "Domain Question" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nAre You Adding/Changing a Domain?" 7 34; then
  
  domain='yes'
  
  dialog --title "Input >> Your Domain" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Domain (Example - plexguide.com)" 8 40 2>/tmp/domain
  dom=$(cat /tmp/domain)

  dialog --title "Input >> Your E-Mail" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "E-Mail (Example - user@pg.com)" 8 37 2>/tmp/email
  email=$(cat /tmp/email)

  dialog --infobox "Set Domain is $dom" 3 45
  sleep 5

  echo "Domain - Set to $dom" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

  dialog --infobox "Set E-Mail is $email" 3 45
  sleep 5

  echo "E-Mail - Set to $email" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

  clear

else
  domain="no"
  dialog --infobox "No Changes Were Made!" 3 38
  sleep 4
  bash /opt/plexguide/menus/settings/main.sh
  exit
fi

### Tracked So It Does Not Ask User Again!
touch /var/plexguide/domain
################################################## END

################################################## Main
            rm -r /opt/appdata/plexguide/var.yml
            ansible-playbook /opt/plexguide/ansible/config.yml --tags var

################################################## REDIRECT QUESTION
            bash /opt/plexguide/menus/redirect/main.sh

            file="/var/plexguide/redirect.yes"
                if [ -e "$file" ]
                    then
                sed -i 's/-OFF-/-ON-/g' /opt/plexguide/menus/redirect/main.sh
                    else
                sed -i 's/-ON-/-OFF-/g' /opt/plexguide/menus/redirect/main.sh
            fi
            ;;
        B)
              bash /opt/plexguide/menus/notifications/main.sh
              echo "Pushover Notifications are Working!" > /tmp/pushover
              ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
              ;;
        C)
            bash /opt/plexguide/menus/ports/main.sh ;;  
        D)
            bash /opt/plexguide/scripts/menus/processor/processor-menu.sh ;;
        E)
            bash /opt/plexguide/menus/redirect/main.sh

            file="/var/plexguide/redirect.yes"
                if [ -e "$file" ]
                    then
                sed -i 's/-OFF-/-ON-/g' /opt/plexguide/menus/redirect/main.sh
                    else
                sed -i 's/-ON-/-OFF-/g' /opt/plexguide/menus/redirect/main.sh
            fi
            ;;
        F) 
            bash /opt/plexguide/menus/transfer/main.sh ;;
        Z)
            clear
            exit 0
            ;;
esac
clear

bash /opt/plexguide/menus/settings/main.sh
exit 0
