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
export NCURSES_NO_UTF8_ACS=1

#!/bin/bash

MENU_OPTIONS=5
COUNT=0

for i in `ls`
do
       COUNT=$[COUNT+1]
       MENU_OPTIONS="${MENU_OPTIONS} ${COUNT} $i off "
done
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(${MENU_OPTIONS})
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
for choice in $choices
do
       echo " WHATEVER from HERE"
done