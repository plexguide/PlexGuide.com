#!/bin/bash
clear
if (dialog --title "Reboot Question" --yesno "New policy will not take affect until you reboot your machine. Do you want to reboot your machine?" 0 0); then
  dialog --title "Reboot Selected" --msgbox "Roger That! We will reboot your machine!" 0 0
  sudo reboot
  exit
else
  dialog --title "No Reboot Selected" --msgbox "No problem! Just remember to reboot your machine later!" 0 0
  exit
fi
