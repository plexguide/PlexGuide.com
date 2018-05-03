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
file="/var/plexguide/nzb.discount" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
  touch /var/plexguide/nzb.discount
  bash /opt/plexguide/menus/nzb/main.sh
  fi

############################################################ Push Over Notification of Starting Process
echo "Installation Started" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

############################################################ Basic Menu
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

############################################################ Creates Blank File if it DOES NOT Exist! Ports for APPS are Open
file="/var/plexguide/server.ports" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
  dialog --title "Server Ports - One Time Message" --msgbox "\nYour Applicaiton Ports are Open by Default!\n\nYou can turn them OFF via Settings. TURN OFF only when https:// is confirmed for you DOMAIN!" 0 0
  touch /var/plexguide/server.ports
  echo "[OPEN]" > /var/plexguide/server.ports.status
  fi

file="/var/plexguide/server.appguard" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
  touch /var/plexguide/server.appguard 1>/dev/null 2>&1
  echo "[OFF]" > /var/plexguide/server.appguard
  fi
############################################################ Starting Install Processing
echo "0" | dialog --gauge "Conducting a System Update" 7 50 0
yes | apt-get update 1>/dev/null 2>&1

#echo "10" | dialog --gauge "Installing Python Support" 7 50 0
#bash /opt/plexguide/scripts/baseinstall/python.sh 1>/dev/null 2>&1
#sleep 1

echo "12" | dialog --gauge "Installing: Software Properties Common" 7 50 0
yes | apt-get install software-properties-common 1>/dev/null 2>&1
sleep 1

echo "18" | dialog --gauge "Enabling System Health Monitoring" 7 50 0
yes | apt-get install sysstat nmon 1>/dev/null 2>&1
sed -i 's/false/true/g' /etc/default/sysstat 1>/dev/null 2>&1
sleep 1

############################################################ Enables Use of ROLES AfterWards
echo "22" | dialog --gauge "Installing: Ansible Playbook" 7 50 0
yes | apt-add-repository ppa:ansible/ansible 1>/dev/null 2>&1
apt-get update -y 1>/dev/null 2>&1
apt-get install ansible -y 1>/dev/null 2>&1
yes | apt-get update 1>/dev/null 2>&1

############################################################ Start of Role Execution
echo "26" | dialog --gauge "Installing: PlexGuide Dependencies" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags preinstall 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

echo "30" | dialog --gauge "Installing: PlexGuide Commands" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags commands &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
sleep 2

# START ########################### If doesn't exist, put /mnt into the file for the folders role
file="/var/plexguide/server.hd.path"
if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1
    else
      echo "/mnt" > /var/plexguide/server.hd.path
fi
# END########################### If doesn't exist, put /mnt into the file for the folders role

echo "37" | dialog --gauge "Installing: PlexGuide Folders" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags folders 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

echo "43" | dialog --gauge "Installing: PlexGuide Labeling" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags label 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

############################################################ Docker Install
docker --version | awk '{print $3}' > /var/plexguide/docker.version
docker_var=$( cat /var/plexguide/docker.version )

if [ "$docker_var" == "18.03.1-ce," ]
then
  echo "50" | dialog --gauge "Docker Is Already Installed" 7 50 0
  sleep 2
  #read -n 1 -s -r -p "Press any key to continue "
else

docver=$( cat /var/plexguide/ub.ver )

  if [ "$docver" == "16" ]
    then
  echo "50" | dialog --gauge "Installing: UB16 - Docker 18.03 (Please Be Patient)" 7 58 0
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags docker 1>/dev/null 2>&1
  #read -n 1 -s -r -p "Press any key to continue "
  fi

  if [ "$docver" == "18" ]
    then
  echo "50" | dialog --gauge "Installing: UB18 - Docker 18.03 (Please Be Patient)" 7 58 0
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags docker18 1>/dev/null 2>&1
  #read -n 1 -s -r -p "Press any key to continue "
  fi

fi

############################################################ Checks to See if Docker Installed; if not... FAIL!
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
bash /opt/plexguide/scripts/startup/rclone-preinstall.sh &>/dev/null &
touch /var/plexguide/basics.yes &>/dev/null &
sleep 1

echo "77" | dialog --gauge "Installing: Auto-Delete" 7 50 0
bash /opt/plexguide/scripts/autodelete/install.sh &>/dev/null &
sleep 1

echo "79" | dialog --gauge "Installing: Portainer" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer &>/dev/null &
sleep 1
echo "Portainer Installed - Goto Port 9000 and Set Your Password!" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &

############################################################ Reboot Startup Container Script
echo "82" | dialog --gauge "Installing: Docker Startup Assist" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags dockerfix 1>/dev/null 2>&1
#read -n 1 -s -r -p "Press any key to continue "

echo "85" | dialog --gauge "Forcing Reboot of Existing Containers!" 7 50 0
bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
sleep 2

echo "88" | dialog --gauge "Installing: WatchTower" 7 50 0
##### Traefik Process
file="/var/plexguide/watchtower.yes"
if [ -e "$file" ]
    then
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower &>/dev/null &
      sleep 2
    else
      bash /opt/plexguide/menus/watchtower/main.sh
fi

echo "91" | dialog --gauge "Installing: Python Support" 7 50 0
bash /opt/plexguide/scripts/baseinstall/python.sh 1>/dev/null 2>&1

##### Traefik Process
file="/var/plexguide/server.domain"
if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1
    else
      echo "null" > /var/plexguide/server.domain
      bash /opt/plexguide/scripts/baseinstall/domain.sh
      touch /var/plexguide/base.domain
fi

file="/var/plexguide/base.hd"
if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1
    else
      dialog --title "2nd Harddrive - One Time Message" --msgbox "\nYou will be asked if you want to setup a second harddrive.\n\nOnly SETUP if you have your harddrive is formatted and ready to go! If you have one and it's not ready, you can visit the SETTINGS to set this up anytime!" 0 0
      echo "94" | dialog --gauge "Setting Up: 2nd Hard Drive Question" 7 50 0
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower &>/dev/null &
      sleep 2
      bash /opt/plexguide/scripts/baseinstall/harddrive.sh
      echo "null" > /var/plexguide/base.hd
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

touch /var/plexguide/donation.yes 1>/dev/null 2>&1
cat /var/plexguide/pg.preinstall > /var/plexguide/pg.preinstall.stored

echo "PG Install is Complete" > /tmp/pushover
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags pushover &>/dev/null &
clear
