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
############################################################ Basic Menu

edition=$( cat /var/plexguide/pg.edition )
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

echo "75" | dialog --gauge "Installing: RClone & Services" 7 50 0
sleep 2
clear

pg_rclone=$( cat /var/plexguide/pg.rclone )
pg_rclone_stored=$( cat /var/plexguide/pg.rclone.stored )

if [ "$pg_rclone" == "$pg_rclone_stored" ]; then
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

echo "90" | dialog --gauge "Forcing Reboot of Existing Containers!" 7 50 0
bash /opt/plexguide/scripts/containers/reboot.sh &>/dev/null &
#read -n 1 -s -r -p "Press any key to continue "
#sleep 2

#### Install WatchTower Command - 95 Percent
bash /opt/plexguide/roles/baseline/scripts/watchtower.sh
