#!/bin/bash
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (Read License in File)
#
# Execution: bash /opt/plexguide/roles/alias/scripts/baseline.sh

### STARTING DECLARED VARIABLES #######################################
keyword1="Baseline Install"
keyword2="Alias"
pg_alias=$( cat /var/plexguide/pg.alias )
pg_alias_stored=$( cat /var/plexguide/pg.alias.stored )

### STARTING LOG ######################################################
echo "INFO - $keyword1: Start Execution of $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh

### MAIN SCRIPT #######################################################
if [ "$pg_alias" == "$pg_alias_stored" ]
    then
      echo "65" | dialog --gauge "$keyword2 File Is Already Installed" 7 50 0
      echo "INFO - $keyword1: $keyword2 is Already Installed" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
      sleep 2
    else 
      echo "65" | dialog --gauge "Installing: $keyword2 File" 7 50 0
      echo "INFO - $keyword1: $keyword2 is Installing" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
      sleep 2
      clear
      ansible-playbook /opt/plexguide/pg.yml --tags alias
      sleep 2
fi 

### ENDING: DECLARED VARIABLES 
cat /var/plexguide/pg.alias > /var/plexguide/pg.alias.stored

### ENDING: FINAL LOG ##################################################
echo "INFO - $keyword1: Exiting $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh