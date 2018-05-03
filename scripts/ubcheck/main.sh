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
export NCURSES_NO_UTF8_ACS=1
lsb_release -r -s > /var/plexguide/ubversion
ubversion=$( cat /var/plexguide/ubversion )

if [ "$ubversion" == "16.04" ]; then
    dialog --title "Ubuntu Version" --msgbox "\nGood Choice! You Are Running Ubuntu 16.04!" 7 50
    echo "16" > /var/plexguide/ub.ver
else
if [ "$ubversion" == "18.04" ]; then
    dialog --title "Ubuntu Version" --msgbox "\nYou Are Running Ubuntu 18.04!" 7 50
    echo "18" > /var/plexguide/ub.ver
else
    dialog --title "Ubuntu Version" --msgbox "\nWARNING! SYSTEM IS NOT Running Ubuntu 16.04/18.04! USE AT YOUR OWN RISK! No Support Provided!" 8 50
fi
fi
exit
