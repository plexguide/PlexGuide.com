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
  file="/opt/appdata/plexguide/rclone.conf"; if [ ! -e "$file" ]; then
  echo stage1
    file="/root/.config/rclone/rclone.conf"; if [ -e "$file" ]; then
      echo stage2
      cp /root/.config/rclone/rclone.conf /opt/plexguide/rclone.conf; fi; fi
  touch /opt/appdata/plexguide/rclone.conf
  chmod 775 /opt/appdata/plexguide/rclone.conf
  chown -R 1000:1000 /opt/appdata/plexguide/rclone.conf
  mkdir -p /var/plexguide/rclone/
  cat /opt/appdata/plexguide/rclone.conf | grep 'gcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone/gcrypt.status
  cat /opt/appdata/plexguide/rclone.conf | grep 'gdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone/gdrive.status
  cat /opt/appdata/plexguide/rclone.conf | grep 'tdrive' | head -n1 | cut -b1-8 > /var/plexguide/rclone/tdrive.status
  cat /opt/appdata/plexguide/rclone.conf | grep 'tcrypt' | head -n1 | cut -b1-8 > /var/plexguide/rclone/tcrypt.status
  gdrive=$(cat /var/plexguide/rclone/gdrive.status)
  gcrypt=$(cat /var/plexguide/rclone/gdrive.status)
  tdrive=$(cat /var/plexguide/rclone/tdrive.status)
  tcrypt=$(cat /var/plexguide/rclone/tcrypt.status)
}

rcloneconfig () {

rclone config --config /opt/appdata/plexguide/rclone.conf
}
