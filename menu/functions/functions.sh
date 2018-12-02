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
  touch /opt/appdata/plexguide/rclone.conf
  chown -R 1000:1000 /opt/appdata/plexguide/rclone.conf
  mkdir -p /var/plexguide/rclone/

  gdcheck=$(cat /opt/appdata/plexguide/rclone.conf | grep -A 2 gdrive| grep token)
  if [ "$gdcheck" != "" ]; then echo "good" > /var/plexguide/rclone/gdrive.status && gdstatus="good";
  else echo "bad" > /var/plexguide/rclone/gdrive.status && gdstatus="bad"; fi

  gccheck=$(cat /opt/appdata/plexguide/rclone.conf | grep "remote = gdrive:/encrypt")
  if [ "$gccheck" != "" ]; then echo "good" > /var/plexguide/rclone/gcrypt.status && gcstatus="good";
  else echo "bad" > /var/plexguide/rclone/gcrypt.status && gcstatus="bad"; fi
}

rcloneconfig () {
rclone config --config /opt/appdata/plexguide/rclone.conf
}
