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
  
  dialog --infobox "Configuring Traefik For: GoDaddy" 4 35
  sleep 2
  
  dialog --title "Input Required Information" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "GODADDY_API_KEY: " 8 40 2>/tmp/var1
  var1=$(cat /tmp/var1)

  dialog --infobox "GODADDY_API_KEY:\n\n $var1" 4 45
  sleep 2

  dialog --title "Input Required Information" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "GODADDY_API_SECRET: " 8 40 2>/tmp/var2
  var2=$(cat /tmp/var2)

  dialog --infobox "GODADDY_API_SECRET:\n\n $var2" 4 45
  sleep 2

  ansible-playbook /opt/plexguide/ansible/roles/traefik2/traefik2.yml --tags godaddy