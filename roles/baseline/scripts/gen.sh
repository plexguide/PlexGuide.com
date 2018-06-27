#!/bin/bash
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (Read License in File)
#
# Execution: bash /opt/plexguide/roles/baseline/scripts/gen.sh

### STARTING DECLARED VARIABLES #######################################
keyword1="Installing"
keyword2="PG YML GEN"

### STARTING LOG ######################################################
echo "INFO - $keyword1: Start Execution of $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

### MAIN SCRIPT #######################################################
ls -la /opt/plexguide/roles | awk '{ print $9 }' | tail -n +4 > /var/plexguide/yml.list
echo "INFO - YML List Generated @ /var/plexguide/yml.list" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

rm -r /opt/plexguide/pg.yml 1>/dev/null 2>&1

echo "---" > /opt/plexguide/pg.yml
echo "- hosts: localhost" >> /opt/plexguide/pg.yml
echo "" >> /opt/plexguide/pg.yml
echo "  roles:" >> /opt/plexguide/pg.yml

while read p; do
echo "  - { role: $p, tags: ['$p'] }" >> /opt/plexguide/pg.yml
done </var/plexguide/yml.list

echo "INFO - SUCCESS: YML List Created!" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh

mkdir -p /opt/plexguide/inventories 1>/dev/null 2>&1
echo "[local]" > /opt/plexguide/inventories/local
echo "localhost ansible_connection=local" >> /opt/plexguide/inventories/local

### ENDING: DECLARED VARIABLES 

### ENDING: FINAL LOG ##################################################
echo "INFO - $keyword1: Exiting $keyword2 Script" > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh