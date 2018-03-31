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

echo "0" | dialog --gauge "Conducting a System Update" 7 50 0
yes | apt-get update 1>/dev/null 2>&1

echo "10" | dialog --gauge "Installing Python Support" 7 50 0
#bash /opt/plexguide/scripts/baseinstall/python.sh 1>/dev/null 2>&1
sleep 1

echo "15" | dialog --gauge "Installing: Software Properties Common" 7 50 0
yes | apt-get install software-properties-common 1>/dev/null 2>&1
sleep 1

echo "18" | dialog --gauge "Enabling System Health Monitoring" 7 50 0
yes | apt-get install sysstat nmon 1>/dev/null 2>&1
sed -i 's/false/true/g' /etc/default/sysstat 1>/dev/null 2>&1
sleep 1

echo "22" | dialog --gauge "Installing: Ansible Playbook" 7 50 0
yes | apt-add-repository ppa:ansible/ansible 1>/dev/null 2>&1
apt-get update -y 1>/dev/null 2>&1
apt-get install ansible -y 1>/dev/null 2>&1
yes | apt-get update 1>/dev/null 2>&1

echo "26" | dialog --gauge "Installing: PlexGuide Dependencies" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags preinstall #1>/dev/null 2>&1
read -n 1 -s -r -p "Press any key to continue "

echo "30" | dialog --gauge "Installing: PlexGuide Commands" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags commands #&>/dev/null &
read -n 1 -s -r -p "Press any key to continue "
sleep 2

echo "37" | dialog --gauge "Installing: PlexGuide Folders" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags folders #1>/dev/null 2>&1
read -n 1 -s -r -p "Press any key to continue "

echo "43" | dialog --gauge "Installing: PlexGuide Labeling" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags label #1>/dev/null 2>&1
read -n 1 -s -r -p "Press any key to continue "

echo "50" | dialog --gauge "Installing: Docker (Please Be Patient)" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags docker #1>/dev/null 2>&1
read -n 1 -s -r -p "Press any key to continue "

echo "70" | dialog --gauge "Installing: PlexGuide Basics" 7 50 0
ansible-playbook /opt/plexguide/ansible/config.yml --tags var #1>/dev/null 2>&1
read -n 1 -s -r -p "Press any key to continue "

##### Check For Docker / Ansible Failure #### If file is missing, one of the two failed
rm -r /var/plexguide/startup.error 1>/dev/null 2>&1
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
bash /opt/plexguide/scripts/startup/rclone-preinstall.sh #&>/dev/null &
touch /var/plexguide/basics.yes &>/dev/null &
sleep 2

echo "78" | dialog --gauge "Installing: Portainer" 7 50 0 
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer #&>/dev/null &
sleep 2
echo "Portainer Installed - Goto Port 9000 and Set Your Password!" > /tmp/pushover 
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover #&>/dev/null &

echo "82" | dialog --gauge "Installing: Docker Startup Assist" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags dockerfix #1>/dev/null 2>&1
read -n 1 -s -r -p "Press any key to continue "

echo "86" | dialog --gauge "Forcing Reboot of Existing Containers!" 7 50 0
bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
read -n 1 -s -r -p "Press any key to continue "
sleep 2

echo "89" | dialog --gauge "Installing: WatchTower" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower &>/dev/null &
sleep 2

file="/var/plexguide/server.domain"
if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1   
    else
      echo "No-Domain" > /var/plexguide/server.domain
      bash /opt/plexguide/scripts/baseinstall/domain.sh
fi

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
   touch /var/plexguide/dep46.yes

echo "PG Install is Complete" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
clear
