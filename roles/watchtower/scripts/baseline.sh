#!/bin/bash
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (Read License in File)
#
# Execution: bash /opt/plexguide/roles/watchtower/scripts/baseline.sh

### STARTING DECLARED VARIABLES #######################################
keyword1="Baseline Install"
keyword2="WatchTower"
edition=$( cat /var/plexguide/pg.edition )
pg_watchtower=$( cat /var/plexguide/pg.watchtower )
pg_watchtower_stored=$( cat /var/plexguide/pg.watchtower.stored )

### STARTING LOG ######################################################
echo "INFO - $keyword1: Start Execution of $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

### MAIN SCRIPT #######################################################
if [ "$edition" == "PG Edition: GCE Feed" ]; then
    echo "[Disabled Updates]" > /var/plexguide/watchtower.yes
    echo "INFO - $keyword1: GCE Feeder Edition - Skipping $keyword2 Install" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    exit 0  
fi

if [ "$pg_watchtower" == "$pg_watchtower_stored" ]; then
    echo "95" | dialog --gauge "$keyword2 File Is Already Installed" 7 50 0
    echo "INFO - $keyword1: $keyword2 is Already Installed" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
else
    echo "95" | dialog --gauge "Installing: $keyword2 File" 7 50 0
    echo "INFO - $keyword1: $keyword2 is Installing" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
    
  file="/var/plexguide/watchtower.yes"
  if [ -e "$file" ];then
    sleep 2
    clear
    ansible-playbook /opt/plexguide/pg.yml --tags watchtower
    sleep 2 
  else
    bash /opt/plexguide/menus/watchtower/main.sh
  fi

fi

### ENDING: DECLARED VARIABLES 
cat /var/plexguide/pg.watchtower > /var/plexguide/pg.watchtower.stored

### ENDING: FINAL LOG ##################################################
echo "INFO - $keyword1: Exiting $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh