#!/bin/bash
#
# [Ansible Role]
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
### Notes
num=0
echo " " > /var/plexguide/programs.temp
#### Build up list backup list for the main.yml execution
while read p; do
  echo -n $p >> /var/plexguide/programs.temp
  echo -n " " >> /var/plexguide/programs.temp

  num=$[num+1]
  if [ $num == 8 ]; then
    num=0
    echo " " >> /var/plexguide/programs.temp
  fi

done </opt/plexguide/menu/interface/apps/app.list

tee <<-EOF
---------------------------------------------------------------------------
Welcome to the PG Application Suite
---------------------------------------------------------------------------
EOF
cat /var/plexguide/programs.temp
################## Selection ########### START
typed=nullstart
prange=$(cat /var/plexguide/programs.temp)
tcheck=""
break=off
echo ""
echo ""
echo "NOTE: Type all lowercase! To Exit, type >>> exit"
while [ "$break" == "off" ]; do

  read -p 'Type the name of a program | PRESS [ENTER]: ' typed
  tcheck=$(echo $prange | grep $typed)
  echo ""

  if [ "$tcheck" == "" ] || [ "$typed" == "exit" ]; then

    if [ "$typed" == "exit" ]; then
      echo "--------------------------------------------------------"
      echo "SYSTEM MESSAGE: Exiting the PG App Installer Interface "
      echo "--------------------------------------------------------"
      echo ""
      read -n 1 -s -r -p "Press [ANY KEY] to Continue "
      exit
    fi

    echo "--------------------------------------------------------"
    echo "SYSTEM MESSAGE: Failed! Type a Program from the List! "
    echo "--------------------------------------------------------"
    echo ""
    read -n 1 -s -r -p "Press [ANY KEY] to Continue "
    echo ""
    cat /var/plexguide/programs.temp
    echo ""
    echo ""
    echo ""
    echo "NOTE: Type all lowercase! To Exit, type >>> exit"
  else
    break=on
  fi
done

if [ "$typed" == "netdata" ] || [ "$typed" == "vpn" ] || [ "$typed" == "speedtest" ] || [ "$typed" == "alltube" ]; then
  echo "$typed" > /tmp/program_selection && ansible-playbook /opt/plexguide/programs/core/main.yml --extra-vars "quescheck=on cron=off display=on"
else
  echo "$typed" > /tmp/program_selection && ansible-playbook /opt/plexguide/programs/core/main.yml --extra-vars "quescheck=on cron=on display=on"
fi
