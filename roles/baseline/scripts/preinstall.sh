#!/bin/bash
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (Read License in File)
#
# Execution: bash /opt/plexguide/roles/preinstall/scripts/baseline.sh

### STARTING DECLARED VARIABLES #######################################
keyword1="Baseline Install"
keyword2="PreInstall"
pg_dep=$( cat /var/plexguide/pg.dep )
pg_dep_stored=$( cat /var/plexguide/pg.dep.stored )
### STARTING LOG ######################################################
echo "INFO - $keyword1: Start Execution of $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

### MAIN SCRIPT #######################################################
if [ "$pg_dep" == "$pg_dep_stored" ]; then
      echo "25" | dialog --gauge "PG Dependencies Installed Already" 7 50 0
      sleep 2
    else 
      echo "25" | dialog --gauge "Installing: PG Dependencies" 7 50 0
      sleep 2
      clear
      ansible-playbook /opt/plexguide/pg.yml --tags preinstall
      sleep 2
      cat /var/plexguide/pg.dep > /var/plexguide/pg.dep.stored
fi 

### ENDING: DECLARED VARIABLES 
#NONE

### ENDING: FINAL LOG ##################################################
echo "INFO - $keyword1: Exiting $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh