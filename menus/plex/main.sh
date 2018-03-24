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

export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
 source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
 echo $ipv4
 echo $domain

 ### demo ip / comment out when done
 #ipv4=69.69.69.69

display=PLEX
program=plex
port=32400

    dialog --infobox "Pay ATTENTION: Is this Server A REMOTE SERVER (Non-Local)?\n\nIf You SAY -NO- and it is, you must repeat this process!" 7 50
    sleep 4

    if dialog --stdout --title "PAY ATTENTION!" \
      --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
      --yesno "\nDo you require to claim this SERVER? (No, if already done and is working fine" 7 50; then
      echo "claimedalready" > /tmp/plextoken 1>/dev/null 2>&1
    else
        if dialog --stdout --title "PAY ATTENTION!" \
          --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
          --yesno "\nIs this Server a REMOTE SERVER (Non-Local)?" 7 50; then

        dialog --title "PLEX CLAIM INFORMATION" \
        --msgbox "\nVisit http://plex.tv/claim and PRESS the [COPY] Button (do not highlight and copy). You have 5 minutes starting NOW! [PRESS ENTER] when you are READY!" 10 50

        dialog --title "Input >> PLEX CLAIM" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "Token? Windows Users - SHIFT + INSERT to PASTE" 8 50 2>/tmp/plextoken
        plextoken=$(cat /tmp/plextoken)
        dialog --infobox "Token: $plextoken" 3 45
        sleep 2
        else
            echo "claimedalready" > /tmp/plextoken 1>/dev/null 2>&1
        fi
    fi

HEIGHT=10
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Visit https://PlexGuide.com - Automations Made Simple"
TITLE="Plex Installer"
MENU="Select your Plex Preference:"

OPTIONS=(A "Plex Latest"
         B "Plex Custom"
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
                echo "latest" > /tmp/plextag
                dialog --infobox "Selected Tag: Latest" 3 38
                sleep 2

            dialog --infobox "Installing Plex: Please Wait" 3 45   
            touch /tmp/plexsetup
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex --skip-tags webtools 1>/dev/null 2>&1
            #read -n 1 -s -r -p "Press any key to continue "
            ;;

        B)
                dialog --title "Warning - Tag Info" \
                --msgbox "\nVisit http://tags.plexguide.com and COPY and PASTE a TAG version in the dialog box coming up! If you mess this up, you will get a nasty red error in ansible.  You can rerun to fix!" 10 50

                dialog --title "Input >> Tag Version" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --inputbox "Windows Users - SHIFT + INSERT to PASTE" 8 40 2>/tmp/plextag
                plexgtag=$(cat /tmp/plextag)
                dialog --infobox "Typed Tag: $plextag" 3 45
                sleep 2
            
            dialog --infobox "Installing Plex: Please Wait" 3 45
            touch /tmp/plexsetup
            ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex --skip-tags webtools 1>/dev/null 2>&1
            #read -n 1 -s -r -p "Press any key to continue "
            ;;
        Z)
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

dialog --title "FOR REMOTE PLEX SERVERS Users!" \
--msgbox "\nRemember to claim your SERVER @ http(s)://$ipv4:32400 \n\nGoto Settings > Remote access > Check Manual > Type Port 32400 > ENABLE. \n\nMake the lights is GREEN! DO NOT FORGET or do it now!" 13 50

echo "Visit http(s)://$ipv4:32400 to Claim Your Server!" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

dialog --infobox "If the claim does not work, read the WIKI for other methods!" 4 50

echo "If Claim Does Not Work; read the Wiki for Other Methods!" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

sleep 4

if dialog --stdout --title "WebTools Question" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nDo You Want to Install WebTools 3.0?" 7 50; then
    dialog --infobox "WebTools: Installing - Please Wait (Slow)" 3 48
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags webtools 1>/dev/null 2>&1

    echo "WebTools - Was Installed" > /tmp/pushover
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
else
    dialog --infobox "WebTools: Not Installed" 3 45
 
    echo "WebTools - Is Not Installed" > /tmp/pushover
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

    sleep 2
fi