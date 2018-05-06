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
hostname -I | awk '{print $1}' > /var/plexguide/server.ip
ipv4=$( cat /var/plexguide/server.ip ) 1>/dev/null 2>&1
domain=$( cat /var/plexguide/server.domain ) 1>/dev/null 2>&1

 ### demo ip / comment out when done
 #ipv4=69.69.69.69

display=PLEX
program=plex
port=32400

rm -r /tmp/server.check 1>/dev/null 2>&1

dialog --infobox "Pay ATTENTION: Is this Server A REMOTE SERVER (Non-Local)?\n\nIf You SAY -NO- and it is, you must repeat this process!" 7 50
sleep 6

if dialog --stdout --title "PAY ATTENTION!" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nIs this Server a REMOTE SERVER (Non-Local)?" 7 50; then

    if dialog --title "IF YOU DON'T KNOW, SAY -NO- HERE!!!" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nAre you using a CDN (Content Delivery Network)?\n\nIF YOU DON'T KNOW WHAT THIS IS, SAY -NO- HERE!!!" 0 0; then

        if dialog --stdout --title "Do you need a Custom Access URL?" \
                --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                --yesno "\nDo you need to use a Custom Access URL?\n\nThis is for Cloudflare Reverse Proxy.\n\nIf you don't know what this is, SELECT NO!!!" 0 0; then

                   ## Manual Custom Access URL entry
                   #dialog --title "Input CUSTOM ACCESS URL:" \
                   #--backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
                   #--inputbox "Enter your Custom Access URL.\nExample: https://plex.yourdomain.com:443,http://plex.yourdomain.com:80" 0 0 2>/var/plexguide/plex.url
                   #plexurl=$(cat /var/plexguide/plex.url)
                   #dialog --infobox "URL: $plexurl" 0 0
                   #sleep 2

                   ## Automatic Custom Access URL creation
                   plexurl="https://plex.$domain:443,http://plex.$domain:80"
                   echo "$plexurl" > /var/plexguide/plex.url
                   dialog --infobox "Custom Access URL: $plexurl" 0 0
                   sleep 5

        else
            echo "default" > /var/plexguide/plex.url 1>/dev/null 2>&1
        fi
    else
        echo "default" > /var/plexguide/plex.url 1>/dev/null 2>&1
    fi

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
else
    echo "claimedalready" > /var/plexguide/plextoken 1>/dev/null 2>&1
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
                echo "latest" > /var/plexguide/plextag
                dialog --infobox "Selected Tag: Latest" 3 38
                sleep 2

            dialog --infobox "Installing Plex: Please Wait" 3 45
            touch /tmp/plexsetup

            file="/tmp/server.check"
            if [ -e "$file" ]
            then
               # user select remote server (which requires claiming operations)
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex --skip-tags webtools &>/dev/null &
               sleep 2
            else
               # user select local server (non-remote which requires to change some things to work!)
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex2 --skip-tags webtools &>/dev/null &
               sleep 2
            fi

            #read -n 1 -s -r -p "Press any key to continue "
            ;;

        B)
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

            file="/tmp/server.check"
            if [ -e "$file" ]
            then
               # user select remote server (which requires claiming operations)
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex --skip-tags webtools &>/dev/null &
               sleep 2
            else
               # user select local server (non-remote which requires to change some things to work!)
               ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plex2 --skip-tags webtools &>/dev/null &
               sleep 2
            fi

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


file="/tmp/server.check"
if [ -e "$file" ]
then
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

rm -r /tmp/server.check 1>/dev/null 2>&1
