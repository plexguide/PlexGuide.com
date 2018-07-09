#!/bin/bash
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (Read License in File)
#
# Execution: bash /opt/plexguide/roles/baseline/scripts/dockerfailsafe.sh

### STARTING DECLARED VARIABLES #######################################
keyword1="Baseline Install"
keyword2="Docker Failsafe"

### STARTING LOG ######################################################
echo "INFO - $keyword1: Start Execution of $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh

### MAIN SCRIPT #######################################################
rm -r /var/plexguide/startup.error 1>/dev/null 2>&1
file="/usr/bin/docker" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
        echo "" 1>/dev/null 2>&1
    else 
      ##### Install Docker the Emergency Way 
      clear
      echo "Installing Docker the Old School Way - (Please Be Patient)"
      sleep 2
      clear
      curl -fsSL get.docker.com -o get-docker.sh
      sh get-docker.sh
      echo ""
      echo "Starting Docker (Please Be Patient)"
      sleep 2
      systemctl start docker
      sleep 2

      ##### Checking Again, if fails again; warns user
      file="/usr/bin/docker" 1>/dev/null 2>&1
        if [ -e "$file" ]
          then
          echo "INFO - SUCCESS: Docker Failsafe Resulted in a Succesful Docker Install" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
        else
            touch /var/plexguide/startup.error 1>/dev/null 2>&1
          echo "INFO - FAILED: Docker Failsafe Resulted in a Failed Docker Install" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
            exit
      fi
fi
### ENDING: DECLARED VARIABLES 

### ENDING: FINAL LOG ##################################################
echo "INFO - $keyword1: Exiting $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh