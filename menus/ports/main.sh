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
clear

################# Virtual Machine Check
if (whiptail --title "Virutal Machine Question" --yesno "Do You Want To Keep Your Ports Open?" 8 56) then

    whiptail --title "Virutal Machine - Yes" --msgbox "Your Ports are now/still Open.  If they were closed, you need to redeploy each container!" 9 66
    rm -r /opt/appdata/plexguide/ports-no 1>/dev/null 2>&1
    ansible-playbook /opt/plexguide/ansible/config.yml --tags ports --skip-tags closed
    read -n 1 -s -r -p "Press any key to continue "
    exit
else
    whiptail --title "Virutal Machine - No" --msgbox "Your Ports are now/still Closed. If they were open, you need to redeploy each container!" 9 66
    touch /opt/appdata/plexguide/ports-no 1>/dev/null 2>&1
    ansible-playbook /opt/plexguide/ansible/config.yml --tags ports --skip-tags open
    read -n 1 -s -r -p "Press any key to continue "
fi

exit
