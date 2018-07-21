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
echo "INFO - BaseInstall Started" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
edition=$( cat /var/plexguide/pg.edition )

file="/var/plexguide/nzb.discount"
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
  echo "WARNING - User Failed To Update PlexGuide" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  exit 0
fi

################################################################ Create Server ID
  file="/var/plexguide/server.id"
    if [ -e "$file" ]
      then
    echo "" 1>/dev/null 2>&1
  else
      bash /opt/plexguide/menus/backup-restore/first.sh
    echo "INFO - First Time: Server ID Generated" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    fi
#  date +"%m%d%Y" > /var/plexguide/server.id
#  echo "INFO - First Time: Server ID Generated" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

############################################################################# END

################################################################ Create Server ID

file="/var/plexguide/restore.id"
  if [ -e "$file" ]
    then
  echo "" 1>/dev/null 2>&1
    else
  cat /var/plexguide/server.id > /var/plexguide/restore.id
  echo "INFO - First Time: Restore ID Generated" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  fi
############################################################################# END

############################################################ Creates Blank File if it DOES NOT Exist! Ports for APPS are Open

######### Check to SEE IF GCE FEED Edition
if [ "$edition" == "PG Edition: GCE Feed" ]
  then
      touch /var/plexguide/server.appguard 1>/dev/null 2>&1
      echo "[OFF]" > /var/plexguide/server.appguard
      touch /var/plexguide/server.ports
      echo "[OPEN]" > /var/plexguide/server.ports.status
  else
    #### If NOT GCE Edition
    file="/var/plexguide/server.settings.set" 1>/dev/null 2>&1
      if [ -e "$file" ]
        then
          echo "" 1>/dev/null 2>&1
        else
          echo "INFO - Selecting PG Edition for the FIRST TIME" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
          bash /opt/plexguide/menus/setup/servertype.sh
    fi
    file="/var/plexguide/server.ports" 1>/dev/null 2>&1
      if [ -e "$file" ]
        then
      echo "" 1>/dev/null 2>&1
        else
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
fi

############################################################ Starting Install Processing
echo "0" | dialog --gauge "Conducting a System Update" 7 50 0
sleep 2
clear
yes | apt-get update
yes | apt-get install software-properties-common
yes | apt-get install sysstat nmon
sed -i 's/false/true/g' /etc/default/sysstat
echo "INFO - Conducted a System Update" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
sleep 2

############################################################ Enables Use of ROLES AfterWards
pg_ansible=$( cat /var/plexguide/pg.ansible )
pg_ansible_stored=$( cat /var/plexguide/pg.ansible.stored )

if [ "$pg_ansible" == "$pg_ansible_stored" ]
    then
      echo "20" | dialog --gauge "Suppport Is Already Installed" 7 50 0
      echo "INFO - Support is Already Installed" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      sleep 2
    else
      echo "20" | dialog --gauge "Installing: Ansible Playbook" 7 50 0
      echo "INFO - Installing: Support" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      sleep 2
      clear
      bash /opt/plexguide/roles/baseline/scripts/ansible.sh
      cat /var/plexguide/pg.ansible > /var/plexguide/pg.ansible.stored
      sleep 2
fi

############# FOR ANSIBLE
mkdir -p /etc/ansible/inventories/ 1>/dev/null 2>&1
echo "[local]" > /etc/ansible/inventories/local
echo "127.0.0.1 ansible_connection=local" >> /etc/ansible/inventories/local

### Reference: https://docs.ansible.com/ansible/2.4/intro_configuration.html
echo "[defaults]" > /etc/ansible/ansible.cfg
echo "command_warnings = False" >> /etc/ansible/ansible.cfg
echo "callback_whitelist = profile_tasks" >> /etc/ansible/ansible.cfg
echo "inventory = /etc/ansible/inventories/local" >> /etc/ansible/ansible.cfg
############################################################ Create Inventory File

#### Install Alias Command - 25 Percent
bash /opt/plexguide/roles/baseline/scripts/preinstall.sh

# START ########################### If doesn't exist, put /mnt into the file for the folders role
file="/var/plexguide/server.hd.path"
if [ -e "$file" ]
    then
      echo "" 1>/dev/null 2>&1
    else
      echo "/mnt" > /var/plexguide/server.hd.path
fi
# END########################### If doesn't exist, put /mnt into the file for the folders role


#### Install Folders - 30 Percent
bash /opt/plexguide/roles/baseline/scripts/folders.sh

############################################################ Docker Install

  echo "40" | dialog --gauge "Install / Check: Docker (Please Be Patient)" 7 58 0
  echo "INFO - Docker Install for UB" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  sleep 2
  clear
  ansible-playbook /opt/plexguide/pg.yml --tags docker

#### Install Alias Command - Part of Docker
bash /opt/plexguide/roles/baseline/scripts/dockerfailsafe.sh

#### Install Alias Command - 65 Percent
bash /opt/plexguide/roles/baseline/scripts/alias.sh


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
      ansible-playbook /opt/plexguide/pg.yml --tags label
      sleep 2
      #read -n 1 -s -r -p "Press any key to continue "
      cat /var/plexguide/pg.label > /var/plexguide/pg.label.stored
      sleep 2
fi

echo "75" | dialog --gauge "Installing: RClone & Services" 7 50 0
sleep 2
clear

pg_rclone=$( cat /var/plexguide/pg.rclone )
pg_rclone_stored=$( cat /var/plexguide/pg.rclone.stored )

if [ "$pg_rclone" == "$pg_rclone_stored" ]
    then
      echo "75" | dialog --gauge "RClone 1.42 Is Already Installed" 7 50 0
      sleep 2
    else
      echo "75" | dialog --gauge "Installing: RClone" 7 50 0
      sleep 2
      clear
      ansible-playbook /opt/plexguide/pg.yml --tags rcloneinstall
      sleep 2
#### Alignment Note #### Have to Have It Left Aligned
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF

chown 1000:1000 /usr/bin/rclone 1>/dev/null 2>&1
chmod 755 /usr/bin/rclone 1>/dev/null 2>&1

      #read -n 1 -s -r -p "Press any key to continue "
      cat /var/plexguide/pg.rclone > /var/plexguide/pg.rclone.stored
fi
sleep 2
#sleep 1

echo "80" | dialog --gauge "Installing: AutoDelete & Cleaner" 7 50 0
ansible-playbook /opt/plexguide/pg.yml --tags autodelete &>/dev/null &
ansible-playbook /opt/plexguide/pg.yml --tags clean &>/dev/null &
ansible-playbook /opt/plexguide/pg.yml --tags clean-encrypt &>/dev/null &
sleep 2

#### Install Alias Command - 85 Percent
bash /opt/plexguide/roles/baseline/scripts/portainer.sh

############################################################ Reboot Startup Container Script
pg_docstart=$( cat /var/plexguide/pg.docstart)
pg_docstart_stored=$( cat /var/plexguide/pg.docstart.stored )

if [ "$pg_docstart" == "$pg_docstart_stored" ]
    then
      echo "90" | dialog --gauge "Docker Assist Is Already Installed" 7 50 0
      sleep 2
    else
      echo "90" | dialog --gauge "Installing: Docker Startup Assist" 7 50 0
      clear
      sleep 2
      ansible-playbook /opt/plexguide/pg.yml --tags dockerfix
      sleep 2
      #read -n 1 -s -r -p "Press any key to continue "
      cat /var/plexguide/pg.docstart > /var/plexguide/pg.docstart.stored
fi

echo "90" | dialog --gauge "Forcing Reboot of Existing Containers!" 7 50 0
bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
#sleep 2

#### Install WatchTower Command - 95 Percent
bash /opt/plexguide/roles/baseline/scripts/watchtower.sh

########### Python Support
pg_python=$( cat /var/plexguide/pg.python )
pg_python_stored=$( cat /var/plexguide/pg.python.stored )

if [ "$pg_python" == "$pg_python_stored" ]
    then
      echo "99" | dialog --gauge "Python Support Is Already Installed" 7 50 0
      sleep 2
    else
      echo "99" | dialog --gauge "Installing: Python Support" 7 50 0
      bash /opt/plexguide/roles/baseline/scripts/python.sh &>/dev/null &
      cat /var/plexguide/pg.python > /var/plexguide/pg.python.stored
      sleep 2
fi

#### Complete!
cat /var/plexguide/pg.preinstall > /var/plexguide/pg.preinstall.stored
echo "INFO - BaseInstall Finished" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

echo "100" | dialog --gauge "PG BaseInstall Finished!" 7 50 0
sleep 2
