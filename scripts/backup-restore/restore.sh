#!/bin/bash
#
# [PlexGuide Installation Script]
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

export NCURSES_NO_UTF8_ACS=1

clear
echo "Starting Restore Process"
echo ""

sudo rm -r /opt/appdata/plexguide/backuplist2 1>/dev/null 2>&1
sudo rm -r /opt/appdata/plexguide/backuplist 1>/dev/null 2>&1

ls -la /mnt/gdrive/plexguide/backup.old | awk '{ print $9}' | tail -n 6 > /opt/appdata/plexguide/backuplist

declare -i count=0

while read p; do
      count=$((count+1))
      	if [ $count -eq 1 ]; then
            echo "$p" > var1
            var1=$p
        fi
      	if [ $count -eq 2 ]; then
            echo "$p" > var2
            var2=$p
        fi
      	if [ $count -eq 3 ]; then
            echo "$p" > var3
            var3=$p
        fi
      	if [ $count -eq 4 ]; then
            echo "$p" > var4
            var4=$p
        fi
      	if [ $count -eq 5 ]; then
            echo "$p" > var5
            var5=$p
        fi
      	if [ $count -eq 6 ]; then
            echo "$p" > var6
            var6=$p
        fi
done </opt/appdata/plexguide/backuplist

HEIGHT=15
WIDTH=48
CHOICE_HEIGHT=8
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="PG Restore - Last 7 Shown"
MENU="Select a Restore Option (Most Recent Top):"

OPTIONS=(A "Most Recent Backup"
         B "$var6"
         C "$var5"
         D "$var4"
         E "$var3"
         F "$var2"
         G "$var1"
         Z "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        A)
            varselect="main" ;;
        B)
            varselect=$var6 ;;
        C)
            varselect=$var5 ;;
        D)
            varselect=$var4 ;;
        E)
            varselect=$var3 ;;
        F)
            varselect=$var2 ;;
        G)
            varselect=$var1 ;;
        Z)
            clear
            exit 0 ;;
esac

mfolder="/mnt/gdrive/plexguide/backup.old/"
mpath="$mfolder$varselect"

# Force Exit if Required
if [ $varselect = "main" ]
then
  clear
  echo "Main Selected"
  mpath="/mnt/gdrive/plexguide/backup/"
fi

# Force Exit if Required
if [ $mpath = "/mnt/gdrive/plexguide/backup.old/" ]
then
  clear
  echo "You Selected a Blank Field - Nothing Happened"
  read -n 1 -s -r -p "Press any key to continue "
  clear
  exit
fi

ls -la $mpath | awk '{ print $9}' | tail -n 9 | cut -f 1 -d '.' > /opt/appdata/plexguide/backuplist2

#mkdir /tmp/plexguide
#cp /opt/appdata/plexguide/* /tmp/plexguide

while read p; do
  echo $p > /tmp/program_var
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags restoremass
done </opt/appdata/plexguide/backuplist2

rm -r /opt/appdata/plexguide/backuplist2 1>/dev/null 2>&1
rm -r /opt/appdata/plexguide/backuplist 1>/dev/null 2>&1
rm -r /opt/appdata/var* 1>/dev/null 2>&1

echo ""
echo "Backup Complete"
read -n 1 -s -r -p "Press any key to continue "
clear
