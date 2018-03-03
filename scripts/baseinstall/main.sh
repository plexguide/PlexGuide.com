#!/bin/bash
#
# [PlexGuide Startup Script]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
export NCURSES_NO_UTF8_ACS=1

clear

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

echo "15" | dialog --gauge "Installing: Software Properties Common" 7 50 0
yes | apt-get install software-properties-common 1>/dev/null 2>&1

echo "20" | dialog --gauge "Installing: Ansible Playbook" 7 50 0
yes | apt-add-repository ppa:ansible/ansible 1>/dev/null 2>&1
apt-get update -y 1>/dev/null 2>&1
apt-get install ansible -y 1>/dev/null 2>&1
yes | apt-get update 1>/dev/null 2>&1

echo "25" | dialog --gauge "Installing: PlexGuide Dependiences" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags preinstall 1>/dev/null 2>&1

echo "30" | dialog --gauge "Installing: PlexGuide Commands" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags commands 1>/dev/null 2>&1

echo "35" | dialog --gauge "Installing: PlexGuide Folders" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags folders 1>/dev/null 2>&1

echo "40" | dialog --gauge "Installing: PlexGuide Labeling" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags label 1>/dev/null 2>&1

echo "45" | dialog --gauge "Installing: Docker" 7 50 0
ansible-playbook /opt/plexguide/ansible/pre.yml --tags docker 1>/dev/null 2>&1

echo "70" | dialog --gauge "Installing: PlexGuide Basics" 7 50 0
ansible-playbook /opt/plexguide/ansible/config.yml --tags var 

echo "75" | dialog --gauge "Installing: RClone & Services" 7 50 0
bash /opt/plexguide/scripts/startup/rclone-preinstall.sh 1>/dev/null 2>&1
touch /var/plexguide/basics.yes 1>/dev/null 2>&1

echo "80" | dialog --gauge "Installing: Portainer" 7 50 0 
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer 1>/dev/null 2>&1

echo "85" | dialog --gauge "Installing: Traefik" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags traefik 1>/dev/null 2>&1

echo "90" | dialog --gauge "Installing: Docker Startup Assist" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags dockerfix 1>/dev/null 2>&1

echo "95" | dialog --gauge "Installing: WatchTower" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower 1>/dev/null 2>&1

read -n 1 -s -r -p "Press any key to continue "
echo "99" | dialog --gauge "Donation Question" 7 50 0
sleep 3

  file="/var/plexguide/donation.yes"
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
        bash /opt/plexguide/menus/donate/main.sh
    fi

   rm -r /var/plexguide/dep* 1>/dev/null 2>&1
   touch /var/plexguide/dep39.yes

clear
