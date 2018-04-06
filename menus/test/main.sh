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

#ls -l /opt/appdata

# var=$(df -hT | awk '{print v++,$7}')
#locip=`hostname -I | awk '{print $1}'`

var=`ls -l /opt/appdata | awk '{print v++, print $9}'`
dialog --menu "Please choose a mounted Partition" 15 55 5 $var