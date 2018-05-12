#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Flicker-Rate & Admin9705
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
####### START OF STATEMENT
drop=$(cat /var/plexguide/gce.check)

file="/dev/nvme0n1"
  if [ -e "$file" ] && [ "$drop" != "yes" ]
    then

      mkfs.ext4 -F /dev/nvme0n1
      mount -o discard,defaults,nobarrier /dev/nvme0n1 /mnt
      chmod a+w /mnt
      echo UUID=`blkid | grep nvme0n1 | cut -f2 -d'"'` /mnt ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab

      mkdir -p /nvme2
      mkfs.ext4 -F /dev/nvme0n2
      mount -o discard,defaults,nobarrier /dev/nvme0n2 /nvme2
      chmod a+w /nvme2
      echo UUID=`blkid | grep nvme0n2 | cut -f2 -d'"'` /nvme2 ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab

      mv /mnt/move /nvme2/move
      ln -s /nvme2/move /mnt

      mkdir -p /nvme2/sab/complete
      rm -r /mnt/sab/complete
      ln -s /nvme2/sab/complete /mnt/sab/

      chown -R 1000:1000 /mnt
      chown -R 1000:1000 /nvme2

      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr &>/dev/null &
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr &>/dev/null &
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sabnzbd &>/dev/null &

      curl -s https://rclone.org/install.sh | bash -s beta

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
      dialog --title "SETUP Incorrect" --msgbox "\nYour SETUP is not CORRECT!\n\nWe detected the NVME Drives not being setup correctly!\n\nVisit http://gce.plexguide.com!" 0 0
fi