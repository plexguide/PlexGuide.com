#!/bin/bash
#
# [ST2 Monitor]
# Note:  This helps monitor if the log ever displays a failed status; rekick the 
# service back into play
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
echo 'SUCCESS - UFSMonitor (UnionFS) Monitor Script.sh Deployed' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
sleep 3

while true
do

  file="/mnt/unionfs/plexguide/pgchecker.bin"
      if [ -e "$file" ]
        then
      echo "" 1>/dev/null 2>&1
      echo 'INFO - UNIONFS: Up & Running - Checking Again 3 Minutes' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
      sleep 180
        else
        echo 'FAILURE - UNIONFS FAILED - PGChecker.bin missing!' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
        docker stop plex &>/dev/null &
        docker stop sonarr &>/dev/null &
        docker stop radarr &>/dev/null &
        docker stop sonarr4k &>/dev/null &
        docker stop radarr4k&>/dev/null &
        echo 'WARNING - Plex, Radarr & Sonarr were shutdown' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
        echo 'INFO - Redeploying PGDrive Service To Assist' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags gdrive 1>/dev/null 2>&1
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags tdrive 1>/dev/null 2>&1
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags unionfs 1>/dev/null 2>&1
        echo 'INFO - PGDrive ReDeployment Complete' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
        echo 'INFO - Plex, Raddar & Sonarr will be Redeployed in 30 seconds' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
        sleep 30
        #### checking for pgchecker.bin again; if fails, exit script and warn user in PGLog; requires restart or T-Shoot / Warn User in STARTUP
  		  file="/mnt/unionfs/plexguide/pgchecker.bin" 1>/dev/null 2>&1
  		  if [ -e "$file" ]
  		    then
  			    docker restart plex &>/dev/null &
  			    docker restart sonarr &>/dev/null &
  			    docker restart radarr &>/dev/null &
  			    docker restart sonarr4k &>/dev/null &
  			    docker restart radarr4k&>/dev/null &
  			    echo 'INFO - Plex, Raddar & Sonarr were Deployed!' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
  			  else 
            echo 'FAILURE - UNIONFS FAILED! You must restart and T-Shoot Your System' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            echo 'WARNING - Programs Utilizing UnionFS are being ShutDown!' > /var/plexguide/pg.log && bash /opt/plexguide/scripts/log.sh
            docker stop plex &>/dev/null &
            docker stop sonarr &>/dev/null &
            docker stop radarr &>/dev/null &
            docker stop sonarr4k &>/dev/null &
            docker stop radarr4k&>/dev/null &
            sleep 2
            exit
  		  fi

      fi

### For While Loop
done