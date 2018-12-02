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
