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
rm -r /tmp/plexsetup 1>/dev/null 2>&1
echo 'INFO - @Plex Type Selection Menu' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
hostname -I | awk '{print $1}' > /var/plexguide/server.ip
ipv4=$( cat /var/plexguide/server.ip )
domain=$( cat /var/plexguide/server.domain )
server=$( cat /var/plexguide/server.type )

display=PLEX
program=plex
port=32400

#### add the dialog to the end - reminder
plexurl="https://plex.$domain:443,http://plex.$domain:80"
echo "$plexurl" > /var/plexguide/plex.url

if [ "$server" == "remote" ] 
then
    if dialog --stdout --title "PAY ATTENTION!" \
      --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
      --yesno "\nDo you require to claim this SERVER for PLEX?\n\nSelect No: IF your PLEX Container is already Claimed & Working" 0 0; then

        dialog --title "PLEX CLAIM INFORMATION" \
        --msgbox "\nVisit http://plex.tv/claim and PRESS the [COPY] Button (do not highlight and copy). You have 5 minutes starting NOW! [PRESS ENTER] when you are READY!" 10 50

        dialog --title "Input >> PLEX CLAIM" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "Token? Windows Users - SHIFT + INSERT to PASTE" 8 50 2>/var/plexguide/plextoken
        plextoken=$(cat /var/plexguide/plextoken)
        dialog --infobox "Token: $plextoken" 3 45
        sleep 2
        touch /tmp/server.check 1>/dev/null 2>&1
    else
       echo "claimedalready" > /var/plexguide/plextoken 1>/dev/null 2>&1
       touch /tmp/server.check 1>/dev/null 2>&1
    fi
fi

HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Plex Installer"
MENU="Select your Plex Preference:"

OPTIONS=(A "Plex Latest"
         B "Plex Pass"
         C "Plex Custom"
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
echo 'INFO - Selected: Plex Latest' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            echo "latest" > /var/plexguide/plextag
            dialog --infobox "Selected Tag: Latest" 3 38
            sleep 2

            dialog --infobox "Installing Plex: Please Wait" 3 45
            touch /tmp/plexsetup

            if [ "$server" == "remote" ] 
            then
              clear
echo 'INFO - Deployed Plex For a Remote Server' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
               # user select remote server (which requires claiming operations)
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex
               read -n 1 -s -r -p "Press any key to continue"
            else
               clear
echo 'INFO - Deployed Plex For a Local Server' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex2
               read -n 1 -s -r -p "Press any key to continue"
            fi

            #read -n 1 -s -r -p "Press any key to continue "
            ;;
        B)
echo 'INFO - Selected: PlexPass' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            echo "plexpass" > /var/plexguide/plextag
            dialog --infobox "Selected Tag: PlexPass" 3 38
            sleep 2

            dialog --infobox "Installing Plex: Please Wait" 3 45
            touch /tmp/plexsetup

            if [ "$server" == "remote" ] 
            then
echo 'INFO - Deployed Plex For a Remote Server' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex
               read -n 1 -s -r -p "Press any key to continue"
            else
echo 'INFO - Deployed Plex For a Local Server' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex2
               read -n 1 -s -r -p "Press any key to continue"
            fi

            #read -n 1 -s -r -p "Press any key to continue "
            ;;

        C)
echo 'INFO - Selected: Plex Custom' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
                dialog --title "Warning - Tag Info" \
                --msgbox "\nVisit http://tags.plexguide.com and COPY and PASTE a TAG version in the dialog box coming up! If you mess this up, you will get a nasty red error in ansible.  You can rerun to fix!" 10 50

                dialog --title "Input >> Tag Version" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Windows Users - SHIFT + INSERT to PASTE" 8 40 2>/var/plexguide/plextag
                plextag=$(cat /var/plexguide/plextag)
                dialog --infobox "Typed Tag: $plextag" 3 45
                sleep 2

            dialog --infobox "Installing Plex: Please Wait" 3 45
            touch /tmp/plexsetup

            if [ "$server" == "remote" ] 
            then
echo 'INFO - Deployed Plex For a Remote Server' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex
               read -n 1 -s -r -p "Press any key to continue"
            else
               clear
echo 'INFO - Deployed Plex For a Local Server' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex2
               read -n 1 -s -r -p "Press any key to continue"
               
            fi

            #read -n 1 -s -r -p "Press any key to continue "
            ;;
        Z)
echo 'INFO - Selected: Users Selected to Exit' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            clear
            exit 0 ;;

########## Deploy End
esac

file="/tmp/plexsetup"
if [ -e "$file" ]
then
   clear 1>/dev/null 2>&1
else
   exit
fi


if [ "$server" == "remote" ] 
then
  echo 'INFO - Remote User: Warned to Enable Port 32400' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
  dialog --title "FOR REMOTE PLEX SERVERS Users!" \
  --msgbox "\nRemember to claim your SERVER @ http://$ipv4:32400 \n\nGoto Settings > Remote access > Check Manual > Type Port 32400 > ENABLE. \n\nMake the lights is GREEN! DO NOT FORGET or do it now!" 13 50

  echo "Visit http://$ipv4:32400 to Claim Your Server!" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

  dialog --infobox "If the claim does not work, read the WIKI for other methods!" 4 50

  echo "If Claim Does Not Work; read the Wiki for Other Methods!" > /tmp/pushover
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
  sleep 4
else
   exit
fi

rm -r /tmp/server.check 1>/dev/null 2>&1