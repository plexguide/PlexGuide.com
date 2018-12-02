#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
}

badinput1 () {
echo
read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
question1
}

variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

removemounts () {
  ansible-playbook /opt/plexguide/menu/remove/mounts.yml
}

readrcloneconfig () {
  #touch /root/.config/rclone/rclone.conf
  mkdir -p /var/plexguide/rclone/
  cat /root/.config/rclone/rclone.conf | grep 'gcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone/gcrypt.status
  cat /root/.config/rclone/rclone.conf | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone/gdrive.status
  cat /root/.config/rclone/rclone.conf | grep 'tdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone/tdrive.status
  cat /root/.config/rclone/rclone.conf | grep 'tcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone/tcrypt.status
  gdrive=$(cat /var/plexguide/rclone/gdrive.status)
  gcrypt=$(cat /var/plexguide/rclone/gdrive.status)
  tdrive=$(cat /var/plexguide/rclone/tdrive.status)
  tcrypt=$(cat /var/plexguide/rclone/tcrypt.status)
}
