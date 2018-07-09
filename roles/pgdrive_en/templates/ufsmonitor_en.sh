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
echo 'SUCCESS - UFSMonitor (UnionFS) Monitor Script.sh Deployed' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
sleep 20

while true
do

  file="/mnt/unionfs/plexguide/pgchecker.bin"
      if [ -e "$file" ]
        then
      echo "" 1>/dev/null 2>&1
      sleep 120
        else
        echo 'FAILURE - UNIONFS FAILED - PGChecker.bin missing!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
        docker stop medusa &>/dev/null &
        docker stop couchpotato &>/dev/null &
        docker stop sickrage &>/dev/null &
        docker stop lidarr &>/dev/null &
        docker stop plex &>/dev/null &
        docker stop sonarr &>/dev/null &
        docker stop radarr &>/dev/null &
        docker stop sonarr4k &>/dev/null &
        docker stop radarr4k&>/dev/null &
        echo 'WARNING - Programs Utilizing UnionFS were shutdown' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
        echo 'INFO - Redeploying PG Drive Service To Assist' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
        ansible-playbook /opt/plexguide/pg.yml --tags gcrypt 1>/dev/null 2>&1
        ansible-playbook /opt/plexguide/pg.yml --tags tcrypt 1>/dev/null 2>&1
        ansible-playbook /opt/plexguide/pg.yml --tags unionfs_en 1>/dev/null 2>&1
        echo 'INFO - PG Drive ReDeployment Complete' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
        echo 'INFO - Programs Utilizing UnionFS will Redeploy in 30 seconds' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
        sleep 30
        #### checking for pgchecker.bin again; if fails, exit script and warn user in PGLog; requires restart or T-Shoot / Warn User in STARTUP
  		  file="/mnt/unionfs/plexguide/pgchecker.bin" 1>/dev/null 2>&1
  		  if [ -e "$file" ]
  		    then
            docker start medusa &>/dev/null &
            docker start couchpotato &>/dev/null &
            docker start sickrage &>/dev/null &
            docker start lidarr &>/dev/null &
  			    docker start plex &>/dev/null &
  			    docker start sonarr &>/dev/null &
  			    docker start radarr &>/dev/null &
  			    docker start sonarr4k &>/dev/null &
  			    docker start radarr4k &>/dev/null &
  			    echo 'INFO - Plex, Raddar & Sonarr were Deployed!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
  			  else 
            echo 'FAILURE - UNIONFS FAILED! You must restart and T-Shoot Your System' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
            echo 'WARNING - Programs Utilizing UnionFS were ShutDown!' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log.sh
            docker stop medusa &>/dev/null &
            docker stop couchpotato &>/dev/null &
            docker stop sickrage &>/dev/null &
            docker stop lidarr &>/dev/null &
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