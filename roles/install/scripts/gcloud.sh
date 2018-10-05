#!/bin/bash
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

######################################################## Declare Variables
sname="PG Installer: Google Console"
pg_gcloud=$( cat /var/plexguide/pg.gcloud )
pg_gcloud_stored=$( cat /var/plexguide/pg.gcloud.stored )
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
######################################################## START: Main Script
if [ "$pg_cloud" == "$pg_cloud_stored" ]; then
      echo "" 1>/dev/null 2>&1
    else
      echo "Installing GCloud Interface" > /var/plexguide/message.phase
      bash /opt/plexguide/roles/install/scripts/message.sh
      echo ""
      export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
      echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
      sudo apt-get update && sudo apt-get install google-cloud-sdk
      cat /var/plexguide/pg.gcloud > /var/plexguide/pg.gcloud.stored
  fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/plexguide/pg.log
sudo bash /opt/plexguide/roles/log/log.sh
