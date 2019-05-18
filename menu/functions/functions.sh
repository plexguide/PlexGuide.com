#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
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
  touch /pg/data/blitz/rclone.conf
  mkdir -p /pg/var/rclone/

  gdcheck=$(cat /pg/data/blitz/rclone.conf | grep gdrive)
  if [ "$gdcheck" != "" ]; then echo "good" > /pg/var/rclone/gdrive.status && gdstatus="good";
  else echo "bad" > /pg/var/rclone/gdrive.status && gdstatus="bad"; fi

  gccheck=$(cat /pg/data/blitz/rclone.conf | grep "remote = gdrive:/encrypt")
  if [ "$gccheck" != "" ]; then echo "good" > /pg/var/rclone/gcrypt.status && gcstatus="good";
  else echo "bad" > /pg/var/rclone/gcrypt.status && gcstatus="bad"; fi

  tdcheck=$(cat /pg/data/blitz/rclone.conf | grep tdrive)
  if [ "$tdcheck" != "" ]; then echo "good" > /pg/var/rclone/tdrive.status && tdstatus="good"
  else echo "bad" > /pg/var/rclone/tdrive.status && tdstatus="bad"; fi

}

rcloneconfig () {
  rclone config --config /pg/data/blitz/rclone.conf
}

keysprocessed () {
  mkdir -p /pg/data/blitz/keys/processed
  ls -1 /pg/data/blitz/keys/processed | wc -l > /pg/var/project.keycount
}
