#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
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
menu=$(cat /var/plexguide/final.choice)

if [ "$menu" == "2" ]; then
  gcloud auth login
fi

if [ "$menu" == "3" ]; then
  echo ""
  gcloud projects list
  echo ""
  read -p "Set the Project ID (y/n)? " -n 1 -r
  echo    # move cursor to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo ""
    echo "---------------------------------------------------"
    echo "SYSTEM MESSAGE: [Y] Key was NOT Selected - Exiting!"
    echo "---------------------------------------------------"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      echo "";
      exit 1;
  else
      echo "";# leave if statement and continue.
  fi
  echo "";
  echo "";
  echo "This script is about to *UPDATE* AND *UPGRADE* your OS. It is highly "
  echo "  recommended that you deploy this on a new server, and not an existing"
  echo "  one you may already be using. Running upgrades on an existing"
  echo "  in-production server may break your environment and pre-existing setup"
  echo "  of software, programs, scripts, applications, etc."
  echo "";
  echo "";
  # read: safe shell input check. non-negated answer continues, else aborts.
  read -p "Would you like to proceed updating and upgrading your OS and ALL packages? " -n 1 -r
  echo    # move cursor to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      echo "";
      echo "";
      echo "ABORTING per user request.";
      echo "";
      echo "";
      exit 1;
  else
      echo "";# leave if statement and continue.
  fi



  echo ""
fi

if [ "$menu" == "4" ]; then
  bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
fi

if [ "$menu" == "5" ]; then
  bash /opt/plexguide/roles/watchtower/menus/main.sh
fi

if [ "$menu" == "6" ]; then
  bash /opt/plexguide/menus/migrate/main.sh
fi

if [ "$menu" == "7" ]; then
  dpkg-reconfigure tzdata
fi
