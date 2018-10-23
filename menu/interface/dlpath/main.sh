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
pgpath=$(cat /var/plexguide/server.hd.path)
tee <<-EOF

---------------------------------------------------------------------------
PlexGuide Download/Processing Selection Interface
---------------------------------------------------------------------------

NOTE: PG does not format harddrives. User is responsible to format and mount
their secondary drives! You may change this later in the PG Settings!

PURPOSE: Allow DOWNLOADS to process on a SECONDARY DRIVE (which is good for
small or slow primary drives). Like Windows, you can have your stuff download
and process on a (D): Drive instead of the (C): Drive.

WARNING: Don't know what to do? Leave Select - NO -

Default Path: /mnt
Current Path: $pgpath

EOF
read -p "Change the Current Download/Processing Path? (y/n): " -n 1 -r
echo    # move cursor to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo ""
  echo "---------------------------------------------------"
  echo "SYSTEM MESSAGE: [Y] Key was NOT Selected - Exiting!"
  echo "---------------------------------------------------"
  echo ""
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  exit 1;
fi

tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: User Selected to Change the Path!
---------------------------------------------------------------------------

Current Path: $pgpath

NOTE: When typing your path following the examples as shown below! We will
then attempt to check to see if your path exists! If not, we will let you know!

Examples:
/mnt/mymedia
/secondhd/media
/myhd/storage/media

echo "To QUIT, type >>> exit"
EOF

break=no
while [ "$break" == "no" ]; do
read -p 'Type the NEW PATH (follow example above): ' typed

storage=$(grep $typed /var/plexguide/ver.temp)

  if [ "$typed" == "exit" ]; then
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Exiting the Downloading/Processing Selection Interface
---------------------------------------------------------------------------

EOF
  read -n 1 -s -r -p "Press [ANY KEY] to Continue "
  echo ""
  exit
else
tee <<-EOF

---------------------------------------------------------------------------
SYSTEM MESSAGE: Checking Path: $typed
---------------------------------------------------------------------------

EOF
sleep 1.5

##### If BONEHEAD forgot to add a / in the beginning, we fix for them
initial="$(echo $typed | head -c 1)"
if [ "$initial" != "/" ]
  then
        pathe="$typed"
        path="/$typed"
        echo "$typed" > /var/plexguide/server.hd.path
  fi

  ##### If BONEHEAD added a / at the end, we fix for them
  initial="${path: -1}"
  if [ "$initial" == "/" ]
    then
          pathe="$path"
          path=${path::-1}
          echo "$path" > /var/plexguide/server.hd.path
    fi

mkdir -p $typed/test

echo $typed
### Final FI
fi





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
