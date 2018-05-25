#!/bin/bash

dialog --title "PG Uninstaller Info" --msgbox "\nThe UnInstaller will remove all services, nuke file directories and accumlated files, uninstall docker, and remove all containers; but will prompt you if you want to keep your program (APPDATA)" 9 60

if dialog --stdout --title "PG UnInstaller" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nDo you WANT TO STOP THE UNINSTALL & BACKOUT!?" 7 50; then
            dialog --infobox "Nothing Has Been Uninstalled!" 3 45
            sleep 3 
    else
         dialog --infobox "UnInstalling PlexGuide!\n\nMay the Force Be With You!\nPlexGuide Never Dies!" 0 0
         sleep 4
         dialog --infobox "Removing Services" 3 30
         sleep 2
         ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unservices &>/dev/null &
         dialog --infobox "Removing Files & Folders" 3 30
         sleep 2
         ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unfiles &>/dev/null &
         dialog --infobox "Uninstall Docker & Removing Containers" 3 35
         sleep 2
         clear
         rm -r /etc/docker 1>/dev/null 2>&1
         apt-get purge docker-ce -y 1>/dev/null 2>&1
         rm -rf /var/lib/docker 1>/dev/null 2>&1

         #dialog --infobox "Program Data Removed - Not Ready" 0 0
         #sleep 2

         if dialog --stdout --title "Program (AppData)" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nDo you WANT to keep your Program Configs (Appdata)?" 7 60; then
          dialog --infobox "Your Data will remain under /opt/appdata" 3 50
          sleep 3
        else
         dialog --infobox "Deleting Your Data Forever!" 3 45
         sleep 1
         rm -r /opt/appdata &>/dev/null &
         dialog --infobox "I'm here, I'm there, wait... I'm your DATA! Poof! I'm gone!" 3 60
         sleep 3
        fi
         dialog --infobox "A REBOOT of your Server will Commence in 3 SECONDS!" 3 45
         sleep 3
         dialog --infobox "GoodBye!" 0 0
         sleep 1
         reboot
fi