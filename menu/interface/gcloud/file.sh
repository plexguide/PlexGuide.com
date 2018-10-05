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
  echo "[NOT SET]" > /var/plexguide/project.final
fi

if [ "$menu" == "3" ]; then
  echo ""
  gcloud projects list && gcloud projects list > /var/plexguide/projects.list
  echo ""
  echo "------------------------------------------------------------------------------"
  echo "SYSTEM MESSAGE: GCloud Project Interface"
  echo "------------------------------------------------------------------------------"
  echo ""
  echo "NOTE: If no project is listed, please visit https://project.plexguide.com and"
  echo "      review the wiki on how to build a project! Without one, this will fail!"
  echo ""
  read -p "Set or Change the Project ID (y/n)? " -n 1 -r
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

  typed=nullstart
  while [ "$typed" != "$list" ]; do
    echo "------------------------------------------------------------------------------"
    echo "SYSTEM MESSAGE: Project Selection Interface"
    echo "------------------------------------------------------------------------------"
    echo ""
    cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2
    cat /var/plexguide/projects.list | cut -d' ' -f1 | tail -n +2 > /var/plexguide/project.cut
    echo ""
    echo "NOTE: Type the Name of the Project you want to utilize!"
    read -p 'Type the Name of the Project to Utlize & Press [ENTER]: ' typed
    list=$(cat /var/plexguide/project.cut | grep $typed)
    echo ""

    if [ "$typed" != "$list" ]; then
      echo "---------------------------------------------------"
      echo "SYSTEM MESSAGE: Failed! Please type the exact name!"
      echo "---------------------------------------------------"
      echo ""
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    else
      echo "----------------------------------------------"
      echo "SYSTEM MESSAGE: Passed the Validation Checks!"
      echo "----------------------------------------------"
      echo ""
      echo "Set Project is: $list"
      gcloud config set project $typed
      echo ""
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    fi
  done

  echo $typed > /var/plexguide/project.final
  echo 'INFO - Selected: Exiting Application Suite Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  exit
fi

if [ "$menu" == "4" ]; then
  echo ""
  echo "------------------------------------------------------------------------------"
  echo "SYSTEM MESSAGE: PlexGuide Service Account Key Generator"
  echo "------------------------------------------------------------------------------"
  echo ""
  gcloud iam service-accounts list --filter="GDSA"
  gcloud iam service-accounts list --filter="GDSA" > /var/plexguide/gdsa.list
  cat /var/plexguide/gdsa.list | awk '{print $2}' | tail -n +2 > /var/plexguide/gdsa.cut
  echo ""
  echo "NOTE: Keys listed above are the ones in current use! Proceeding onward will"
  echo "      delete the current keys and will generate new ones!"
  echo ""
  read -p "Build New Google Service Account Keys? (y/n)? " -n 1 -r
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

  echo "Deleting All Previous Keys!"
  while read p; do
  gcloud iam service-accounts delete $p --quiet”
done </var/plexguide/gdsa.cut

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
