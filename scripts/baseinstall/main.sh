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
echo "INFO - BaseInstall Started" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

file="/var/plexguide/nzb.discount" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
  touch /var/plexguide/nzb.discount
  bash /opt/plexguide/menus/nzb/main.sh
  fi

############################################################ Basic Menu
if dialog --stdout --title "System Update" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --yesno "\nDo You Agree to Install/Update PlexGuide?" 7 50; then
  clear
else
  clear
  dialog --title "PG Update Status" --msgbox "\nUser Failed To Agree! You can view the program, but doing anything will mess things up!" 0 0
  echo "Type to Restart the Program: sudo plexguide"
  echo "WARNING - User Failed To Update PlexGuide" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
  exit 0
fi

##### Server Type
file="/var/plexguide/server.settings.set" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1
    else
      echo "INFO - Selecting PG Edition for the FIRST TIME" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      bash /opt/plexguide/menus/setup/servertype.sh
fi

############################################################ Creates Blank File if it DOES NOT Exist! Ports for APPS are Open
file="/var/plexguide/server.ports" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
  dialog --title "Server Ports - One Time Message" --msgbox "\nYour APP Ports are Open by Default!\n\nYou can turn them OFF via Settings. TURN OFF only when https:// is confirmed for you DOMAIN!" 0 0
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
sleep 2
clear
yes | apt-get update
yes | apt-get install software-properties-common 
yes | apt-get install sysstat nmon
sed -i 's/false/true/g' /etc/default/sysstat
echo "INFO - Conducted a System Update" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
sleep 2

############################################################ Enables Use of ROLES AfterWards
pg_ansible=$( cat /var/plexguide/pg.ansible )
pg_ansible_stored=$( cat /var/plexguide/pg.ansible.stored )

if [ "$pg_ansible" == "$pg_ansible_stored" ]
    then
      echo "20" | dialog --gauge "Ansible Is Already Installed" 7 50 0
      echo "INFO - Ansible is Already Installed" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      sleep 2
    else 
      echo "20" | dialog --gauge "Installing: Ansible Playbook" 7 50 0
      echo "INFO - Installing: Ansible PlayBook" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      yes | apt-add-repository ppa:ansible/ansible 1>/dev/null 2>&1
      apt-get update -y 1>/dev/null 2>&1
      apt-get install ansible -y 1>/dev/null 2>&1
      yes | apt-get update 1>/dev/null 2>&1
      cat /var/plexguide/pg.ansible > /var/plexguide/pg.ansible.stored
fi 
############################################################ Create Inventory File

file="/etc/ansible/inventory" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
####### Create File
tee "/etc/ansible/inventory" > /dev/null <<EOF
[localhost]
127.0.0.1  ansible_connection=local
EOF
####### Append File
echo "" >> /etc/ansible/ansible.cfg
echo "[defaults]" >> /etc/ansible/ansible.cfg
echo "inventory = inventory" >> /etc/ansible/ansible.cfg
  fi

############################################################ Start of Role Execution
#### DEPENDENCIES
pg_dep=$( cat /var/plexguide/pg.dep )
pg_dep_stored=$( cat /var/plexguide/pg.dep.stored )

if [ "$pg_dep" == "$pg_dep_stored" ]
    then
      echo "25" | dialog --gauge "PG Dependencies Installed Already" 7 50 0
      sleep 2
    else 
      echo "25" | dialog --gauge "Installing: PG Dependencies" 7 50 0
      sleep 2
      clear
      ansible-playbook /opt/plexguide/ansible/critical.yml --tags preinstall
      sleep2
      cat /var/plexguide/pg.dep > /var/plexguide/pg.dep.stored
fi 

# START ########################### If doesn't exist, put /mnt into the file for the folders role
file="/var/plexguide/server.hd.path"
if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1
    else
      echo "/mnt" > /var/plexguide/server.hd.path
fi
# END########################### If doesn't exist, put /mnt into the file for the folders role

echo "30" | dialog --gauge "Installing: PlexGuide Folders" 7 50 0
sleep 2
clear
ansible-playbook /opt/plexguide/ansible/critical.yml --tags folders
sleep 2
#read -n 1 -s -r -p "Press any key to continue "

######## COMMANDS
pg_commands=$( cat /var/plexguide/pg.commands )
pg_commands_stored=$( cat /var/plexguide/pg.commands.stored )

if [ "$pg_commands" == "$pg_commands_stored" ]
    then
      echo "35" | dialog --gauge "PG Commands Already Installed" 7 50 0
      sleep 2
    else 
      clear
      echo "35" | dialog --gauge "Installing: PlexGuide Commands" 7 50 0
      ansible-playbook /opt/plexguide/ansible/critical.yml --tags commands &>/dev/null &
      cat /var/plexguide/pg.commands > /var/plexguide/pg.commands.stored
      sleep 2
      #read -n 1 -s -r -p "Press any key to continue "
fi 

############################################################ Docker Install
docker --version | awk '{print $3}' > /var/plexguide/docker.version
docker_var=$( cat /var/plexguide/docker.version )
version_recall16=$( cat /var/plexguide/pg.docker16 )
version_recall18=$( cat /var/plexguide/pg.docker18 )

if [ "$docker_var" == "$version_recall16-ce," ]
then
  echo "40" | dialog --gauge "Docker Is Already Installed" 7 50 0
  sleep 2
  #read -n 1 -s -r -p "Press any key to continue "
else

docver=$( cat /var/plexguide/ubversion )

  if [ "$docver" == "16.04" ]
    then
  echo "40" | dialog --gauge "Installing: UB16 - Docker $version_recall (Please Be Patient)" 7 58 0
  echo "INFO - Installing Docker for UB16" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
  sleep 2
  clear
  ansible-playbook /opt/plexguide/ansible/critical.yml --tags docker_standard,docker16
  sleep 2
  #read -n 1 -s -r -p "Press any key to continue "
  fi

fi

### For Docker 18
if [ "$docker_var" == "$version_recall18-ce," ]
then
  echo "40" | dialog --gauge "Docker Is Already Installed" 7 50 0
  sleep 2
  #read -n 1 -s -r -p "Press any key to continue "
else

docver=$( cat /var/plexguide/ubversion )

  if [ "$docver" == "18.04" ]
    then
  echo "40" | dialog --gauge "Installing: UB18 - $version_recall (Please Be Patient)" 7 58 0
  echo "INFO - Installing Docker for UB18" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
  sleep 2 
  clear
  ansible-playbook /opt/plexguide/ansible/critical.yml --tags docker_standard,docker18
  sleep 2
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
      ##### Install Docker the Emergency Way 
      clear
      echo "Installing Docker the Old School Way - (Please Be Patient)"
      sleep 2
      clear
      curl -fsSL get.docker.com -o get-docker.sh
      sh get-docker.sh
      echo ""
      echo "Starting Docker (Please Be Patient)"
      sleep 2
      systemctl start docker
      sleep 2

      ##### Checking Again, if fails again; warns user
      file="/usr/bin/docker" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
            echo "" 1>/dev/null 2>&1
        else
            touch /var/plexguide/startup.error 1>/dev/null 2>&1
            exit
      fi
fi

######## ALIAS
pg_alias=$( cat /var/plexguide/pg.alias )
pg_alias_stored=$( cat /var/plexguide/pg.alias.stored )

if [ "$pg_alias" == "$pg_alias_stored" ]
    then
      echo "65" | dialog --gauge "Alias File Is Already Installed" 7 50 0
      sleep 2
    else 
      echo "65" | dialog --gauge "Installing: Alias File" 7 50 0
      sleep 2
      clear
      ansible-playbook /opt/plexguide/ansible/critical.yml --tags alias
      cat /var/plexguide/pg.alias > /var/plexguide/pg.alias.stored
      sleep 2
fi 

echo "70" | dialog --gauge "Installing: PlexGuide Label" 7 50 0
sleep 2
######## ALIAS
pg_label=$( cat /var/plexguide/pg.label )
pg_label_stored=$( cat /var/plexguide/pg.label.stored )

if [ "$pg_label" == "$pg_label_stored" ]
    then
      echo "70" | dialog --gauge "Label Is Already Installed" 7 50 0
      sleep 2
    else 
      echo "70" | dialog --gauge "Installing: PlexGuide Label" 7 50 0
      sleep 2
      clear
      ansible-playbook /opt/plexguide/ansible/critical.yml --tags label
      sleep 2
      #read -n 1 -s -r -p "Press any key to continue "
      cat /var/plexguide/pg.label > /var/plexguide/pg.label.stored
      sleep 2
fi 

echo "75" | dialog --gauge "Installing: RClone & Services" 7 50 0
bash /opt/plexguide/scripts/startup/rclone-preinstall.sh &>/dev/null &
touch /var/plexguide/basics.yes &>/dev/null &
#sleep 1

echo "80" | dialog --gauge "Installing: AutoDelete & Cleaner" 7 50 0
ansible-playbook /opt/plexguide/ansible/critical.yml --tags autodelete &>/dev/null &
ansible-playbook /opt/plexguide/ansible/critical.yml --tags clean &>/dev/null &
sleep 2

echo "85" | dialog --gauge "Installing: Portainer" 7 50 0
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags portainer &>/dev/null &
#sleep 1
############################################################ Reboot Startup Container Script
pg_docstart=$( cat /var/plexguide/pg.docstart)
pg_docstart_stored=$( cat /var/plexguide/pg.docstart.stored )

if [ "$pg_docstart" == "$pg_docstart_stored" ]
    then
      echo "82" | dialog --gauge "Docker Assist Is Already Installed" 7 50 0
      sleep 2
    else 
      echo "82" | dialog --gauge "Installing: Docker Startup Assist" 7 50 0
      ansible-playbook /opt/plexguide/ansible/critical.yml --tags dockerfix 1>/dev/null 2>&1
      #read -n 1 -s -r -p "Press any key to continue "
      cat /var/plexguide/pg.docstart > /var/plexguide/pg.docstart.stored      
fi 

echo "90" | dialog --gauge "Forcing Reboot of Existing Containers!" 7 50 0
bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
#sleep 2

echo "95" | dialog --gauge "Installing: WatchTower" 7 50 0
file="/var/plexguide/watchtower.yes"
if [ -e "$file" ]
    then
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags watchtower &>/dev/null &
      #sleep 1
    else
      bash /opt/plexguide/menus/watchtower/main.sh
fi

############################# Python Support
pg_python=$( cat /var/plexguide/pg.python )
pg_python_stored=$( cat /var/plexguide/pg.python.stored )

if [ "$pg_python" == "$pg_python_stored" ]
    then
      echo "99" | dialog --gauge "Python Support Is Already Installed" 7 50 0
      sleep 2
    else 
      echo "99" | dialog --gauge "Installing: Python Support" 7 50 0
      bash /opt/plexguide/scripts/baseinstall/python.sh 1>/dev/null 2>&1
      cat /var/plexguide/pg.python > /var/plexguide/pg.python.stored
fi

##### Traefik Process
file="/var/plexguide/server.domain"
if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1
    else
      echo "null" > /var/plexguide/server.domain
      bash /opt/plexguide/scripts/baseinstall/domain.sh
      touch /var/plexguide/base.domain

#### Complete!
cat /var/plexguide/pg.preinstall > /var/plexguide/pg.preinstall.stored
echo "INFO - BaseInstall Finished" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh