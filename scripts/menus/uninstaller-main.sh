
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
     ansible-playbook /opt/plexguide/ansible/PlexGuide.yml --tags unfiles
     echo ""
     echo "Main Programs Uninstalled - Not Ready"
     echo "Program Data Removed - Not Ready"
     echo ""
     read -n 1 -s -r -p "Press any key to continue"
     clear
fi
