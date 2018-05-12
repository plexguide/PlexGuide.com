#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Flicker-Rate & Admin9705
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

touch /nvme2/.test

####### START OF STATEMENT
file="touch /nvme2/.test" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
      echo "corn" 1>/dev/null 2>&1
    else
      mkfs.ext4 -F /dev/nvme0n1
      mount -o discard,defaults,nobarrier /dev/nvme0n1 /mnt
      chmod a+w /mnt
      echo UUID=`blkid | grep nvme0n1 | cut -f2 -d'"'` /mnt ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab

      mkdir -p /nvme2
      mkfs.ext4 -F /dev/nvme0n2
      mount -o discard,defaults,nobarrier /dev/nvme0n2 /nvme2
      chmod a+w /nvme2
      echo UUID=`blkid | grep nvme0n2 | cut -f2 -d'"'` /nvme2 ext4 discard,defaults,nobarrier,nofail 0 2 | tee -a /etc/fstab
  
      mv /mnt/move /nvme2/move
      ln -s /nvme2/move /mnt

      mkdir -p /nvme2/sab/complete
      rm -r /mnt/sab/complete
      ln -s /nvme2/sab/complete /mnt/sab/

      chown -R 1000:1000 /mnt
      chown -R 1000:1000 /nvme2

      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sonarr &>/dev/null &
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags radarr &>/dev/null &
      ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags sabnzbd &>/dev/null &

      curl -s https://rclone.org/install.sh | bash -s beta

## RClone - Replace Fuse by removing the # from user_allow_other
tee "/etc/fuse.conf" > /dev/null <<EOF
# /etc/fuse.conf - Configuration file for Filesystem in Userspace (FUSE)

# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#mount_max = 1000

# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
EOF 

  fi
####### END OF STATEMENT


file="touch /nvme2/.test" 1>/dev/null 2>&1
  if [ -e "$file" ]
    then
      echo "corn" 1>/dev/null 2>&1
    else
    ## Tell Users Doesn't Exist / Issues
    exit
  fi

exit
################### NOTES ONLY BELOW ######
  dialog --title "HD Selection" --msgbox "\nYou Selected: Yes, and I am Ready!\n\nThis you named and can access your HD! If you botch the name, visit SETTINGS and change ANYTIME!" 0 0
  echo "yes" > /var/plexguide/server.hd

  dialog --title "SET FULL PATH [ EXAMPLE: /hd2/media or /hd2 ]" \
  --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
  --inputbox "Full Path: " 8 50 2>/var/plexguide/server.hd.path
  path=$(cat /var/plexguide/server.hd.path)

  if dialog --stdout --title "PG Path Builder" \
        --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
        --yesno "\nPATH: $path\n\nCorrect?" 0 0; then
    dialog --title "Path Choice" --msgbox "\nPATH: $path\n\nTracking!" 0 0
    
    ##### If BONEHEAD forgot to add a / in the beginning, we fix for them
    initial="$(echo $path | head -c 1)"
    if [ "$initial" != "/" ]
      then
            pathe="$path"
            path="/$path"
            dialog --title "PG Error Checking" --msgbox "\nForgot to add a FORWARD SLASH in the beginning!\n\nOLD PATH:\n$pathe\n\nNEW PATH:\n$path" 0 0
            echo "$path" > /var/plexguide/server.hd.path
      fi
  
    ##### If BONEHEAD added a / at the end, we fix for them  
    initial="${path: -1}"
    if [ "$initial" == "/" ]
      then
            pathe="$path"
            path=${path::-1} 
            dialog --title "PG Error Checking" --msgbox "\nADDED a FORWARD SLASH to the END! Not Needed!\n\nOLD PATH:\n$pathe\n\nNEW PATH:\n$path" 0 0
            echo "$path" > /var/plexguide/server.hd.path
      fi

    ##### READ / WRITE CHECK
    mkdir "$path/plexguide"
    
    file="$path/plexguide"
    if [ -e "$file" ]
      then
        dialog --title "PG Path Checker" --msgbox "\nPATH: $path\n\nThe PATH exists! We are going to CHMOD & CHOWN the path for you!" 0 0
        chown 1000:1000 "$path"
        chmod 0775 "$path"
        rm -r "$path/plexguide"
      else
        dialog --title "PG Path Checker" --msgbox "\nPATH: $path\n\nTHE PATH does not EXIST! Re-Running Menu!" 0 0
        bash /opt/plexguide/scripts/baseinstall/harddrive.sh
        exit
    fi

    ### Ensure Location Get Stored for Variables Role
    echo "$path" > /var/plexguide/server.hd.path

    ##### Symbolic Link
    #path="/mnt/hd2"
    rm -r "/mnt/move" 1>/dev/null 2>&1
    mkdir "$path/move" 1>/dev/null 2>&1
    ln -s "$path/move" /mnt

    #### Rebuild Containers
    dialog --infobox "Rebuilding Folders For: $path" 3 55
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags folders 1>/dev/null 2>&1

    #### Rebuild Containers
    bash /opt/plexguide/scripts/baseinstall/rebuild.sh

    dialog --title "PG Container Status" --msgbox "\nContainers Rebuilt According to Your Path!\n\nWant to check? Use PORTAINER and check the ENVs of certain containers!" 0 0
    exit

  else
    dialog --title "Path Choice" --msgbox "\nPATH: $path\n\nIs NOT Correct. Re-running HD Menu!" 0 0
    bash /opt/plexguide/scripts/baseinstall/harddrive.sh
    exit
  fi

esac