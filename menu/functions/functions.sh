#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.pgblitz.com
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

readrcloneconfig () {
  touch /pg/var/rclone/blitz.conf
  mkdir -p /pg/var/rclone/

  gdcheck=$(cat /pg/var/rclone/blitz.conf | grep gdrive)
  if [ "$gdcheck" != "" ]; then echo "good" > /pg/var/rclone/gdrive.status && gdstatus="good";
  else echo "bad" > /pg/var/rclone/gdrive.status && gdstatus="bad"; fi

  gccheck=$(cat /pg/var/rclone/blitz.conf | grep "remote = gdrive:/encrypt")
  if [ "$gccheck" != "" ]; then echo "good" > /pg/var/rclone/gcrypt.status && gcstatus="good";
  else echo "bad" > /pg/var/rclone/gcrypt.status && gcstatus="bad"; fi

  tdcheck=$(cat /pg/var/rclone/blitz.conf | grep tdrive)
  if [ "$tdcheck" != "" ]; then echo "good" > /pg/var/rclone/tdrive.status && tdstatus="good"
  else echo "bad" > /pg/var/rclone/tdrive.status && tdstatus="bad"; fi

}

rcloneconfig () {
  rclone config --config /pg/var/rclone/blitz.conf
}

keysprocessed () {
  mkdir -p /pg/var/keys/processed
  ls -1 /pg/var/keys/processed | wc -l > /pg/var/project.keycount
}
