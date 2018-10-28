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
  echo "--------------------------------------------------------"
  echo "SYSTEM MESSAGE: Creating Project ID"
  echo "--------------------------------------------------------"
  echo ""
  date=`date +%m%d`
  rand=$(echo $((1 + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM )))
  projectid="pg-$date-$rand"
  gcloud projects create $projectid
  sleep 1
fi

if [ "$menu" == "4" ]; then
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
      echo ""
      echo ""
      echo "----------------------------------------------"
      echo "SYSTEM MESSAGE: Enabling Your API!"
      echo "----------------------------------------------"
      echo ""
      echo "NOTE: Enabling GDrive API for Project - $typed"
      gcloud services enable drive.googleapis.com --project $typed
      echo ""
      sleep 1
      echo "----------------------------------------------"
      echo "SYSTEM MESSAGE: Finished!"
      echo "----------------------------------------------"
      echo ""
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    fi
  done

  echo $typed > /var/plexguide/project.final
  echo 'INFO - Selected: Exiting Application Suite Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  exit
fi

if [ "$menu" == "5" ]; then
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

  choicedel=$(cat /var/plexguide/gdsa.cut)
  if [ "$choicedel" != "" ]; then
    echo "Deleting All Previous Keys!"
    echo ""
  while read p; do
    gcloud iam service-accounts delete $p --quiet
    done </var/plexguide/gdsa.cut
    rm -rf /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1
    echo ""
    echo "------------------------------------------------"
    echo "SYSTEM MESSAGE: Prior Service Accounts Deleted!"
    echo "------------------------------------------------"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  else
    echo "--------------------------------------------------"
    echo "SYSTEM MESSAGE: No Prior Service Keys! Continuing!"
    echo "--------------------------------------------------"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  fi

  break=off
  while [ "$break" == "off" ]; do
    echo ""
    echo "--------------------------------------------------"
    echo "SYSTEM MESSAGE: Key Creation Number Selection"
    echo "--------------------------------------------------"
    echo ""
    echo "1 - Create 2  Keys: Daily Limit - 1.5  TB"
    echo "2 - Create 4  Keys: Daily Limit - 3.0  TB"
    echo "3 - Create 6  Keys: Daily Limit - 4.5  TB"
    echo "4 - Create 8  Keys: Daily Limit - 6.0  TB"
    echo "5 - Create 10 Keys: Daily Limit - 7.5  TB"
    echo "6 - Create 20 Keys: Daily Limit - 15.0 TB"
    echo ""
    echo "NOTE: # of Keys Generated Sets Your Daily Upload Limit!"
    echo ""
    read -p 'Type a Number from 1 - 6 & Press [ENTER]: ' typed
    #typed=typed+0
    if [ "$typed" -ge 1 -a "$typed" -le 6 ]; then
      break=on
    else
      break=off
      echo ""
      echo "-------------------------------------------------"
      echo "SYSTEM MESSAGE: Error! Select a Number from 1 - 6"
      echo "-------------------------------------------------"
      echo ""
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    fi
  done

  echo ""
  echo "NOTE: Please Wait"
  echo ""
  if [ "$typed" == "1" ]; then echo "Creating 2 Keys - Daily Upload Limit Set to 1.5TB" && keys=2;
elif [ "$typed" == "2" ]; then echo "Creating 4 Keys - Daily Upload Limit Set to 3.0TB" && keys=4;
elif [ "$typed" == "3" ]; then echo "Creating 6 Keys - Daily Upload Limit Set to 4.5TB" && keys=6;
elif [ "$typed" == "4" ]; then echo "Creating 8 Keys - Daily Upload Limit Set to 6.0TB" && keys=8;
elif [ "$typed" == "5" ]; then echo "Creating 10 Keys - Daily Upload Limit Set to 7.5TB" && keys=10;
elif [ "$typed" == "6" ]; then echo "Creating 20 Keys - Daily Upload Limit Set to 15.0TB" && keys=20;
  fi
  sleep 2
  echo ""

  num=$keys
  count=0
  project=$(cat /var/plexguide/project.final)

  ##wipe previous keys stuck there
  mkdir -p /opt/appdata/pgblitz/keys/processed/
  rm -rf /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1

  ## purpose of the rewrite is to save gdrive and tdrive info and toss old GDSAs
  file="/root/.config/rclone/rclone.conf"
    if [ -e "$file" ]; then
      touch /root/.config/rclone/rclone.conf
    else
      cat /root/.config/rclone/rclone.conf | grep  -w tdrive -A 9 > /root/.config/rclone/tdrive.info
      cat /root/.config/rclone/rclone.conf | grep  -w gdrive -A 8 > /root/.config/rclone/gdrive.info
      rm -r cat /root/.config/rclone/rclone.conf
      echo "#### rclone rewrite generated by plexguide.com" > /root/.config/rclone/rclone.conf
      echo "" >> /root/.config/rclone/rclone.conf
      cat /root/.config/rclone/gdrive.info >> /root/.config/rclone/rclone.conf
      cat /root/.config/rclone/tdrive.info >> /root/.config/rclone/rclone.conf
    fi

  while [ "$count" != "$keys" ]; do
  ((count++))
  rand=$(echo $((1 + RANDOM * RANDOM)))

  if [ "$count" -ge 1 -a "$count" -le 9 ]; then
    gcloud iam service-accounts create gdsa$rand --display-name “gdsa0$count”
    gcloud iam service-accounts keys create /opt/appdata/pgblitz/keys/processed/gdsa0$count --iam-account gdsa$rand@$project.iam.gserviceaccount.com --key-file-type="json"
    echo "gdsa0$count" > /var/plexguide/json.tempbuild
    bash /opt/plexguide/roles/menu-pgblitz/scripts/gdsa.sh
    echo ""
  else
    gcloud iam service-accounts create gdsa$rand --display-name “gdsa$count”
    gcloud iam service-accounts keys create /opt/appdata/pgblitz/keys/processed/gdsa$count --iam-account gdsa$rand@$project.iam.gserviceaccount.com --key-file-type="json"
    echo "gdsa$count" > /var/plexguide/json.tempbuild
    bash /opt/plexguide/roles/menu-pgblitz/scripts/gdsa.sh
    echo ""
  fi
  done

echo $keys > /var/plexguide/project.keycount
echo "no" > /var/plexguide/project.deployed

fi
