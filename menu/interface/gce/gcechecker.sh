#!/bin/bash
#
# [PlexGuide Menu]
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
