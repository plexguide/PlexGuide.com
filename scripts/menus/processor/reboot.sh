 #!/bin/bash

clear

if (whiptail --title "Reboot Question" --yesno "New policy will not take affect until you reboot your machine. Do you want to reboot your machine?" 8 56) then

    whiptail --title "Reboot Selected" --msgbox "Roger That! We will reboot your machine!" 8 66
    sudo reboot
    exit 
else
    whiptail --title "No Reboot Selected" --msgbox "No problem! Just remember to reboot your machine later!" 8 66
    exit
fi
