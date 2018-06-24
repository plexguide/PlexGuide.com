#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
rm -r /tmp/plexsetup 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
 ## point to variable file for ipv4 and domain.com
hostname -I | awk '{print $1}' > /var/plexguide/server.ip
ipv4=$( cat /var/plexguide/server.ip ) 1>/dev/null 2>&1
domain=$( cat /var/plexguide/server.domain ) 1>/dev/null 2>&1

 ### demo ip / comment out when done
 #ipv4=69.69.69.69

display=PLEX
program=plex
port=32400

        dialog --title "Input >> PLEX CLAIM" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --inputbox "Token? Windows Users - SHIFT + INSERT to PASTE" 8 50 2>/var/plexguide/plextoken
        plextoken=$(cat /var/plexguide/plextoken)
        dialog --infobox "Token: $plextoken" 3 45
        sleep 2
        touch /tmp/server.check 1>/dev/null 2>&1

echo "lastest" > /var/plexguide/plextag

ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plextest &>/dev/null &

            dialog --infobox "Installing Plex: Please Wait" 3 45
            sleep 2
            dialog --infobox "Done!" 3 45

clear
