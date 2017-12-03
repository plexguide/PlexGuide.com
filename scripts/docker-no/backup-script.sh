#!/bin/bash
YMLPROGRAM=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLDISPLAY=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)

echo -n "Do you want to backup "$YMLPROGRAM" to your Google Drive (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    docker stop "$YMLPROGRAM"
    -s tar -cvjf /tmp/"$YMLPROGRAM".tar.bz2 /opt/appdata/"$YMLPROGRAM"
    rclone copy /tmp/"$YMLPROGRAM" gdrive:/Backup/"$YMLPROGRAM" -v --checksum --drive-chunk-size=64M
    rm /tmp/"$YMLPROGRAM"  
    docker start "$YMLPROGRAM"
else
    echo No
    clear
    echo Not Backed Up! - $YMLDISPALY
    echo 
fi

read -n 1 -s -r -p "Press any key to continue "