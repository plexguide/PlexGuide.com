
 #!/bin/bash

whiptail --title "Uninstaller Information" --msgbox "The UnInstaller will remove all servers, nuke file directories, nuke accumlated files, uninstall docker, remove all containers; but will prompt you if you want to keep your program (APPDATA)." 13 76

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "UnInstaller Selection" --yesno "Do you want to Uninstall PlexGuide?" 8 76) then
    
    whiptail --title "UnInstall Notice" --msgbox "May The Force Be With You! Uninstalling PlexGuide!" 8 76
     ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unservices
     echo ""
     echo "Services Uninstalled"
     echo "Files Uninstalled - Not Ready"
     echo "Main Programs Uninstalled - Not Ready"
     echo "Program Data Removed - Not Ready"
     echo ""
     read -n 1 -s -r -p "Press any key to continue"
     clear
else
    whiptail --title "No Uninstall" --msgbox "Nothing has been uninstalled" 9 76
    clear
    read -n 1 -s -r -p "Press any key to continue"
fi
