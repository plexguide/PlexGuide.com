#!/bin/bash
#
# [PG BaseInstall]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & FlickerRate
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
echo "lsb_release -r -s" > /var/plexguide/ubversion
ubversion=$( cat /var/plexguide/ubversion )

if [ "$ubversion" -eq "16.04" ]; then
    dialog --title "Ubuntu Version" --msgbox "\nGood Choice! You Are Running Ubuntu 16.04" 0 0
fi
