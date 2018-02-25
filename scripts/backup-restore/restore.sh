#!/bin/bash
#
# [PlexGuide Installation Script]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
# URL:      https://plexguide.com
#
# QuickBox Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
# Advanced Restore Script


#d=$(date +%Y-%m-%d-%T)

#touch /opt/appdata/plexguide/backup 1>/dev/null 2>&1
#sudo rm -r /opt/appdata/plex/trans* 1>/dev/null 2>&1

#mfolder="/mnt/gdrive/plexguide/backup.old/backup-"
#mpath="$mfolder$d"

#mkdir /mnt/gdrive/plexguide/backup.old/ 1>/dev/null 2>&1
#mkdir $mpath
#mv /mnt/gdrive/plexguide/backup/* $mpath 

ls -la -R /mnt/gdrive/plexguide/backup.old | awk '{ print $9}' | tail -n 6 > /opt/appdata/plexguide/backuplist

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
  #echo $p > /tmp/program_var
  #ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags backup
done </opt/appdata/plexguide/backuplist

HEIGHT=16
WIDTH=40
CHOICE_HEIGHT=9
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Restore Your PlexGuide Server"
MENU="Select a Restore Option:"

OPTIONS=(A "Most Recent Backup"
         B "$var1"
         C "$var2"
         D "$var3"
         E "$var4"
         F "$var5"
         G "$var6"
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
            echo "" > varselect ;;
        B)
            varselect=$var1 ;;
        C)
            varselect=$var2 ;;
        D)
            varselect=$var3 ;;
        E)
            varselect=$var4 ;;
        F)
            varselect=$var5 ;;
        G)
            varselect=$var6 ;;
        Z)
            clear
            exit 0 ;;
esac

mfolder="/mnt/gdrive/plexguide/backup.old/"
mpath="$mfolder$varselect"

echo "mpath equals"
echo "$mpath"
#ls -la /mnt/gdrive/plexguide/backup.old/ | awk '{ print $9}' | tail -n 9 | cut -f 1 -d '.' 

ls -la $mpath | awk '{ print $9}' | tail -n 9 | cut -f 1 -d '.' > /opt/appdata/plexguide/backuplist2

while read p; do
  echo $p > /tmp/program_var
  ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags restore
done </opt/appdata/plexguide/backuplist2

#rm -r /mnt/gdrive/plexguide/backup/watchtower.tar 1>/dev/null 2>&1
#rm -r /opt/appdata/plexguide/backup 1>/dev/null 2>&

#echo ""
#echo "Backup Complete"
#read -n 1 -s -r -p "Press any key to continue "
#clear
