#!/bin/bash
#
# [Traefik V2]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & DesignGears
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
#source /var/plexguide/traefik.var
  
provider=$( cat /var/plexguide/provider )
dialog --infobox "Configuring Traefik For: $provider" 3 40
sleep 1

############################## DISPLAY 1
file="/tmp/display1"
if [ -e "$file" ]
then
display1=$( cat /tmp/display1 )
    dialog --title "Input Required Information" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "$display1:" 8 40 2>/var/plexguide/traefik.var1
fi

############################## DISPLAY 2
file="/tmp/display2"
if [ -e "$file" ]
then
display2=$( cat /tmp/display2 )
    dialog --title "Input Required Information" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "$display2:" 8 40 2>/var/plexguide/traefik.var2
fi

############################## DISPLAY 3
file="/tmp/display3"
if [ -e "$file" ]
then
display3=$( cat /tmp/display3 )
    dialog --title "Input Required Information" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "$display3:" 8 40 2>/var/plexguide/traefik.var3
fi

############################## DISPLAY 4
file="/tmp/display4"
if [ -e "$file" ]
then
display3=$( cat /tmp/display4 )
    dialog --title "Input Required Information" \
    --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
    --inputbox "$display4:" 8 40 2>/var/plexguide/traefik.var4
fi