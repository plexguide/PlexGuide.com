#!/bin/bash
#
# [PG BaseInstall]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & FlickerRate
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

clear

echo "Installation Started" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

if dialog --stdout --title "System Update" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nDo You Agree to Install/Update PlexGuide?" 7 50; then
  clear
else
  clear
  dialog --title "PG Update Status" --msgbox "\nUser Failed To Agree! You can view the program, but doing anything will mess things up!" 0 0
  echo "Type to Restart the Program: sudo plexguide"
  exit 0
fi

############### Domain Question - START
file="/var/plexguide/domain"
if [ -e "$file" ]
then
  clear
else
      rm -r /opt/appdata/plexguide/var.yml
      if dialog --stdout --title "Domain Question - One Time" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nAre You Utilizing a Domain?" 7 34; then
        
        domain='yes'
        
        dialog --title "Input >> Your Domain" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "Domain (Example - plexguide.com)" 8 40 2>/tmp/domain
        dom=$(cat /tmp/domain)

        dialog --title "Input >> Your E-Mail" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "E-Mail (Example - user@pg.com)" 8 37 2>/tmp/email
        email=$(cat /tmp/email)

        dialog --infobox "Set Domain is $dom" 3 45
        sleep 5
        dialog --infobox "Set E-Mail is $email" 3 45
        sleep 5
        dialog --infobox "Need to Change? Change via Settings Any Time!" 4 28
        sleep 5

      else
        domain="no"
        dialog --infobox "Add a Domain Anytime Via - Settings" 3 48
        sleep 5
      fi

      ### Tracked So It Does Not Ask User Again!
      touch /var/plexguide/domain

fi
############### Domain Question - END

echo "0" | dialog --gauge "Conducting a System Update" 7 50 0
yes | apt-get update 1>/dev/null 2>&1

echo "10" | dialog --gauge "Installing Python Support" 7 50 0
bash /opt/plexguide/scripts/baseinstall/python.sh &>/dev/null &
sleep 2

echo "15" | dialog --gauge "Installing: Software Properties Common" 7 50 0
yes | apt-get install software-properties-common &>/dev/null &
sleep 2

echo "18" | dialog --gauge "Enabling System Health Monitoring" 7 50 0
yes | apt-get install sysstat nmon 1>/dev/null &>/dev/null &
sed -i 's/false/true/g' /etc/default/sysstat &>/dev/null &
sleep 2

echo "22" | dialog --gauge "Installing: Ansible Playbook" 7 50 0
yes | apt-add-repository ppa:ansible/ansible 1>/dev/null 2>&1
apt-get update -y 1>/dev/null 2>&1
apt-get install ansible -y 1>/dev/null 2>&1
yes | apt-get update 1>/dev/null 2>&1

echo "26" | dialog --gauge "Installing: PlexGuide Dependencies" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags preinstall &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
sleep 2

echo "30" | dialog --gauge "Installing: PlexGuide Commands" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags commands &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
sleep 2

echo "37" | dialog --gauge "Installing: PlexGuide Folders" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags folders 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

echo "43" | dialog --gauge "Installing: PlexGuide Labeling" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags label &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
sleep 2

echo "50" | dialog --gauge "Installing: Docker (Please Be Patient)" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags docker 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

echo "70" | dialog --gauge "Installing: PlexGuide Basics" 7 50 0
ansible-playbook /opt/plexguide/ansible/config.yml --tags var 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

##### Check For Docker / Ansible Failure #### If file is missing, one of the two failed
rm -r /var/plexguide/startup.error
file="/usr/bin/docker" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
    
    echo "Program Aborted - Docker Install Failed" > /tmp/pushover
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
    
    touch /var/plexguide/startup.error 1>/dev/null 2>&1
    exit
  fi

echo "75" | dialog --gauge "Installing: RClone & Services" 7 50 0
bash /opt/plexguide/scripts/startup/rclone-preinstall.sh &>/dev/null &
touch /var/plexguide/basics.yes &>/dev/null &
sleep 2

echo "80" | dialog --gauge "Installing: Portainer" 7 50 0 
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer &>/dev/null &
echo "Portainer Installed - Goto Port 9000 and Set Your Password!" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover
sleep 2

file="/var/plexguide/redirect.yes"
if [ -e "$file" ]
then
  echo "85" | dialog --gauge "Installing: Traefik" 7 50 0
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik --skip-tags=redirectoff 1>/dev/null 2>&1
  #read -n 1 -s -r -p "Press any key to continue "
else
  echo "85" | dialog --gauge "Installing: Traefik" 7 50 0
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik --skip-tags=redirecton 1>/dev/null 2>&1
  #read -n 1 -s -r -p "Press any key to continue "
fi

echo "88" | dialog --gauge "Installing: Docker Startup Assist" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags dockerfix 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

echo "92" | dialog --gauge "Forcing Reboot of Existing Containers!" 7 50 0
bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
sleep 2

echo "96" | dialog --gauge "Installing: WatchTower" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower &>/dev/null &
sleep 2


      #read -n 1 -s -r -p "Press any key to continue "
echo "99" | dialog --gauge "Donation Question" 7 50 0
sleep 2

  file="/var/plexguide/donation.yes"
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
        echo "Please Support Us with Any Donations :D" > /tmp/pushover
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
        
        bash /opt/plexguide/menus/donate/main.sh
    fi

   rm -r /var/plexguide/dep* 1>/dev/null 2>&1
   touch /var/plexguide/dep44.yes


echo "PG Install is Complete" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
clear
