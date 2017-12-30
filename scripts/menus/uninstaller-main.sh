
 #!/bin/bash

whiptail --title "Uninstaller Information" --msgbox "The UnInstaller will remove ALL SERVICES, NUKE the file directories and accumulated files, UNINSTALL Docker, REMOVE ALL CONTAINERS, and PROMPT you if you want to keep your PROGRAM DATA." 13 76

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "UnInstaller Selection" --noyes "Do you want to Uninstall PlexGuide?" 8 76) then
    
    whiptail --title "Now Uninstalling PlexGuide" --msgbox "May the Force Be With You!" 8 76
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unservices
     echo ""
     echo "Services Uninstalled"
     echo "Files Uninstalled - Not Ready"
     echo "Main Programs Uninstalled - Not Ready"
     echo "Program Data Removed - Not Ready"
     echo ""
     read -n 1 -s -r -p "Press any key to continue"
else
    whiptail --title "No Uninstall" --msgbox "Nothing has been uninstalled" 9 76
    clear
    echo "Support Container Removed - Turn it back on anytime!"
    read -n 1 -s -r -p "Press any key to continue"
fi
