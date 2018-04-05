
 #!/bin/bash

whiptail --title "Uninstaller Information" --msgbox "The UnInstaller will remove all services, nuke file directories and accumlated files, uninstall docker, and remove all containers; but will prompt you if you want to keep your program (APPDATA)." 13 76

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "UnInstaller Selection" --yesno "Do you WANT TO STOP THE UNINSTALL & BACKOUT!?" 8 76) then
    
    whiptail --title "No Uninstall" --msgbox "Nothing has been uninstalled" 8 76
    clear
else
    whiptail --title "Uninstalling PlexGuide" --msgbox "May The Force Be With You! Uninstalling PlexGuide!" 9 76
     clear
     echo 1. "Stopping & Uninstalling Services"
     echo ""
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unservices
     echo ""
     echo 2. "Removing Directories & Unnecessary Files"
     echo ""
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unfiles
     echo ""
     echo 3. "Uninstalling Docker & Removing all Containers"
     echo ""
     # 1>/dev/null 2>&1
     rm -r /etc/docker
     apt-get purge docker-ce -y
     rm -rf /var/lib/docker
     echo ""

     echo "Program Data Removed - Not Ready"
     echo ""
     if (whiptail --title "Program (AppData)" --yesno "Do you WANT to keep your Program Configs (Appdata)?" 8 76) then
    
     whiptail --title "AppData - No Action" --msgbox "Your Program-AppData remains intact at: /opt/appdata" 8 76
        clear
        else
     sudo rm -r /opt/appdata
     whiptail --title "Removing AppData" --msgbox "Poof! I'm gone (appdata removed from /opt/appdata)!" 9 76
     clear
     fi
    whiptail --title "Final Notice" --msgbox "Most of everything should have been removed. Time to reboot! After you reboot, you can type plexguide to start a new installation once again!" 9 76  
    reboot
fi
