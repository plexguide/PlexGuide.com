
 #!/bin/bash

whiptail --title "Uninstaller Information" --msgbox "The UnInstaller will remove all services, nuke file directories and accumlated files, uninstall docker, and remove all containers; but will prompt you if you want to keep your program (APPDATA)." 13 76

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "UnInstaller Selection" --yesno "Do you WANT TO STOP THE UNINSTALL & BACKOUT!?" 8 76) then
    
    dialog --infobox "Nothing Has Been Uninstalled!" 0 0
    sleep 4
    clear
else
    whiptail --title "Uninstalling PlexGuide" --msgbox "May The Force Be With You! Uninstalling PlexGuide!" 9 76
     dialog --infobox "Removing Services" 0 0
     sleep 1
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unservices
     dialog --infobox "Removing Files & Folders" 0 0
     sleep 1
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unfiles
     dialog --infobox "Uninstall Docker & Removing Containers" 0 0
     sleep 1
     # 1>/dev/null 2>&1
     rm -r /etc/docker 1>/dev/null 2>&1
     apt-get purge docker-ce -y
     rm -rf /var/lib/docker 1>/dev/null 2>&1

     dialog --infobox "Program Data Removed - Not Ready" 0 0
     sleep 1
     if (whiptail --title "Program (AppData)" --yesno "Do you WANT to keep your Program Configs (Appdata)?" 8 76) then
    
     dialog --infobox "Your Data will remain under /opt/appdata" 0 0
        clear
        else
     sudo rm -r /opt/appdata
     dialog --infobox "I'm here, I'm there, wait... I'm your DATA! Poof! I'm gone!" 0 0
     clear
     fi
     dialog --infobox "Reboot will commence in 3 SECONDS!" 0 0
     3
     reboot
fi
