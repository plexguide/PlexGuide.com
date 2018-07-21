#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Flicker-Rate
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
deploy="no"
drop=$(cat /var/plexguide/gce.check)

### Set This Up Incase BoneHead didn't pick the NVME drives, but still requires the two drives setup
#file="/dev/sdb"
#  if [ -e "$file" ] && [ "$drop" != "yes" ]
#    then
#      deploy="yes"
#  fi

file="/dev/nvme0n1"
  if [ -e "$file" ] && [ "$drop" != "yes" ]
    then
      deploy="yes"
  fi

if [ "$deploy" == "yes" ] && [ "$drop" != "yes" ]
    then

echo 'INFO - Conducting GCE Mass Deployment' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

      dialog --title "NOTICE" --msgbox "\nGCE FeederBox Deploying!" 7 35

      echo "0" | dialog --gauge "Mount Deployment" 7 50 0
      sleep 1

      clear
      mkfs.ext4 -F /dev/nvme0n1 1>/dev/null 2>&1
      mount -o discard,defaults,nobarrier /dev/nvme0n1 /mnt
      chmod a+w /mnt 1>/dev/null 2>&1
      echo UUID=`blkid | grep nvme0n1 | cut -f2 -d'"'` /mnt ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab

      mkdir -p /nvme1 1>/dev/null 2>&1
      mkfs.ext4 -F /dev/nvme0n1
      mount -o discard,defaults,nobarrier /dev/nvme0n1 /nvme1
      chmod a+w /nvme1 1>/dev/null 2>&1
      echo UUID=`blkid | grep nvme0n1 | cut -f2 -d'"'` /nvme1 ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab

      #mv /mnt/move /nvme1/move 1>/dev/null 2>&1
      #ln -s /nvme1/move /mnt 1>/dev/null 2>&1

      #rm -r /tmp
      #ln -s /nvme1/tmp /
      #mkdir /nvme1/tmp

      chown -R 1000:1000 /mnt 1>/dev/null 2>&1
      chown -R 1000:1000 /nvme1 1>/dev/null 2>&1

      mkdir /mnt/move 1>/dev/null 2>&1
      chmod 0755 /mnt/move 1>/dev/null 2>&1
      chown -R 1000:1000 /mnt 1>/dev/null 2>&1
      chown -R 1000:1000 /mnt/move 1>/dev/null 2>&1

      mkdir /mnt/move 1>/dev/null 2>&1
      chmod 0755 /mnt/move 1>/dev/null 2>&1
      chown -R 1000:1000 /mnt 1>/dev/null 2>&1
      chown -R 1000:1000 /mnt/move 1>/dev/null 2>&1

      #rm -r /root/.ansible/tmp
      #ln -s /nvme1/tmp /root/.ansible

      #mkdir -p /opt/appdata
      #chmod 0755 /opt/appdata 1>/dev/null 2>&1
      #chown 1000:1000 /opt/appdata 1>/dev/null 2>&1

      #mkdir -p /nvme1/opt/appdata/radarr 1>/dev/null 2>&1
      #chmod 0755 /nvme1/opt/appdata/radarr 1>/dev/null 2>&1
      #chown -R 1000:1000 /nvme1/opt/appdata/radarr 1>/dev/null 2>&1
      #rm -r /opt/appdata/radarr
      #ln -s /nvme1/opt/appdata/radarr /opt/appdata

      #mkdir -p /nvme1/opt/appdata/nzbget 1>/dev/null 2>&1
      #chmod 0755 /nvme1/opt/appdata/nzbget 1>/dev/null 2>&1
      #chown -R 1000:1000 /nvme1/opt/appdata/nzbget 1>/dev/null 2>&1
      #rm -r /opt/appdata/nzbget
      #ln -s /nvme1/opt/appdata/nzbget /opt/appdata

      #mkdir -p /nvme1/opt/appdata/sonarr 1>/dev/null 2>&1
      #chmod 0755 /nvme1/opt/appdata/sonarr 1>/dev/null 2>&1
      #chown -R 1000:1000 /nvme1/opt/appdata/sonarr 1>/dev/null 2>&1
      #rm -r /opt/appdata/sonarr
      #ln -s /nvme1/opt/appdata/sonarr /opt/appdata

      mkdir /tmp 1>/dev/null 2>&1
      chmod 0777 /tmp 1>/dev/null 2>&1
      chown 0:0 /tmp 1>/dev/null 2>&1

      mkdir /mnt/gdrive 1>/dev/null 2>&1
      chmod 0755 /mnt/gdrive 1>/dev/null 2>&1
      chown 1000:1000 /mnt/gdrive 1>/dev/null 2>&1

      mkdir /mnt/tdrive 1>/dev/null 2>&1
      chmod 0755 /mnt/tdrive 1>/dev/null 2>&1
      chown 1000:1000 /mnt/tdrive 1>/dev/null 2>&1

      echo "50" | dialog --gauge "Installing RCLONE" 7 50 0
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

      ansible-role folders
      echo "100" | dialog --gauge "Feeder Box Install Complete" 7 50 0
      sleep 2

## RClone - Replace Fuse by removing the # from user_allow_other
tee "/etc/fuse.conf" > /dev/null <<EOF
  # /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)

  # Set the maximum number of FUSE mounts allowed to non-root users.
  # The default is 1000.
  #mount_max = 1000

  # Allow non-root users to specify the allow_other or allow_root mount options.
  user_allow_other
EOF
echo "yes" > /var/plexguide/gce.check
    else
      if [ "$drop" == "yes" ]
      then
        echo "corn" &>/dev/null &
      else
        echo 'FAILURE - GCE Deployment Failed: NVME HD was not selected!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        dialog --title "NVME Setup Failure" --msgbox "\nYour SETUP is not CORRECT!\n\nWe have detected that your NVME Drives are not setup correctly (or didn't read the wiki!) but your entire SETUP is going to FAIL!\n\nVisit http://gce.plexguide.com!" 0 0
      fi
fi
