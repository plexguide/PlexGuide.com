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

  ### Part 1
  pcount=$(cat /var/plexguide/project.processor)
  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Current Processor Count Interface"
  echo "---------------------------------------------------"
  echo ""
  echo "NOTE: Processor Count: [$pcount]"
  echo ""
  read -p "Set or Change the Processor Count (y/n)? " -n 1 -r
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
      echo "";
  fi

  ### part 2
  typed=nullstart
  prange="2 3 4 5 6"
  tcheck=""
  break=off
  while [ "$break" == "off" ]; do
    echo "---------------------------------------------------"
    echo "SYSTEM MESSAGE: Processor Count Interface"
    echo "---------------------------------------------------"
    echo ""
    echo "Ideal Processor Usage = 3"
    echo "Set Your Processor Count | Range 2 - 6"
    echo ""
    echo "NOTE: More Processors = Faster Credit Drain"
    echo ""
    read -p 'Type a Number from 2 - 6 | PRESS [ENTER]: ' typed
    tcheck=$(echo $prange | grep $typed)
    echo ""

    if [ "$tcheck" == "" ]; then
      echo "---------------------------------------------------"
      echo "SYSTEM MESSAGE: Failed! Type a Number from 2 - 6"
      echo "---------------------------------------------------"
      echo ""
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      echo ""
      echo ""
    else
      echo "----------------------------------------------"
      echo "SYSTEM MESSAGE: Passed! Process Count $typed Set"
      echo "----------------------------------------------"
      echo ""
      echo $typed > /var/plexguide/project.processor
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      break=on
    fi
  done


fi

if [ "$menu" == "5" ]; then
### Part 1
gcloud compute zones list | awk '{print $1}' | tail -n +2 > /tmp/zones.list
num=0
echo " " > /tmp/zones.print

while read p; do
  echo -n $p >> /tmp/zones.print
  echo -n " " >> /tmp/zones.print

  num=$[num+1]
  if [ $num == 4 ]; then
    num=0
    echo " " >> /tmp/zones.print
  fi
done </tmp/zones.list

### Part 2
typed=nullstart
prange=$(cat /tmp/zones.print)
tcheck=""
break=off
while [ "$break" == "off" ]; do
  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: Google Cloud Server Zones List"
  echo "---------------------------------------------------"
  cat /tmp/zones.print
  echo ""
  read -p 'Type a Server Zone Name | PRESS [ENTER]: ' typed
  echo ""
  tcheck=$(echo $prange | grep $typed)
  echo ""

  if [ "$tcheck" == "" ]; then
    echo "---------------------------------------------------"
    echo "SYSTEM MESSAGE: Failed! Type a Server Location"
    echo "---------------------------------------------------"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    echo ""
    echo ""
  else
    echo "----------------------------------------------"
    echo "SYSTEM MESSAGE: Passed! Location $typed Set"
    echo "----------------------------------------------"
    echo ""
    echo $typed > /var/plexguide/project.location
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    break=on
  fi
done
fi

if [ "$menu" == "6" ]; then
########## Prior Deployment Check
echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Checking Existing Deployment"
echo "---------------------------------------------------"
echo ""

inslist=$(gcloud compute instances list | grep pg-gce)
if [ "$inslist" != "" ]; then
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Failed! Must Delete Current Server!"
echo "---------------------------------------------------"
echo ""
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
exit
fi

############ FireWall
echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Checking PG GCE Firewall Rules"
echo "---------------------------------------------------"
echo ""

inslist=$(gcloud compute firewall-rules list | grep plexguide)
if [ "$inslist" == "" ]; then
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: FireWall Rules Do Not Exist!"
echo "---------------------------------------------------"
echo ""
echo "NOTE: Building Firewall Rules! Please Wait"
echo ""
gcloud compute firewall-rules create plexguide --allow all
echo ""
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
fi

#gcloud compute instance-templates list
############ IP Address
echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Checking PG External Address Rules"
echo "---------------------------------------------------"
echo ""

inslist=$(gcloud compute addresses list | grep pg-gce)
if [ "$inslist" != "" ]; then
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Deleting Old IP Address"
echo "---------------------------------------------------"
echo ""
echo "NOTE: Please Standby"
echo ""
gcloud compute addresses delete $location --global --quiet
echo ""
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
fi

echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Creating New IP Address"
echo "---------------------------------------------------"
echo ""
echo "NOTE: Please Standby"
echo ""
projectname=$(cat /var/plexguide/project.final)
gcloud compute addresses create pg-gce --ip-version IPV4 --project $projectname
sleep 1.5

echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Mounting IP Address to the PG GCE"
echo "---------------------------------------------------"
echo ""
echo "NOTE: Please Standby"
echo ""
gcloud compute addresses list | grep pg-gce | awk '{print $2}' > /var/plexguide/project.ipaddress
ipaddress=$(cat /var/plexguide/project.ipaddress)

########### Deployment
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Setting Variables for Deployment"
echo "---------------------------------------------------"
echo ""
location=$(cat /var/plexguide/project.location)
gcecpu=$(cat /var/plexguide/project.processor)

sleep 1.5

echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Building PG GCE Template"
echo "---------------------------------------------------"
echo ""
echo "NOTE: Please Standby!"
echo ""
gcloud compute instance-templates create pg-gce-blueprint \
--custom-cpu $gcecpu --custom-memory 8GB \
--image-family ubuntu-1804-lts --image-project ubuntu-os-cloud \
--boot-disk-auto-delete --boot-disk-size 100GB \
--local-ssd interface=nvme --address $ipaddress

sleep 2

echo ""
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Deploying PG GCE Server"
echo "---------------------------------------------------"
echo ""
echo "NOTE: Please Standby!"
echo ""
gcloud compute instances create pg-gce --source-instance-template pg-gce-blueprint --zone $location --address $ipaddress
echo ""

######## Final Message
echo "---------------------------------------------------"
echo "SYSTEM MESSAGE: Deployment Complete"
echo "---------------------------------------------------"
echo ""
read -n 1 -s -r -p "Press [ANY KEY] to Continue "
fi
