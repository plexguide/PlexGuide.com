#!/bin/bash
YMLPROGRAM=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLDISPLAY=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
clear
echo "Warning! This will delete and overwrite the current install (if one)"
echo
echo -n "Do you want to restore "$YMLPROGRAM" from your Google Drive (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    clear
    rm -r /opt/appdata/"$YMLPROGRAM"
    echo "1. Stopping Your Docker Program"
    echo "2. Make a directory for "$YMLDISPLAY"" 
    mkdir -p /opt/appdata/"$YMLPROGRAM"
    docker stop "$YMLPROGRAM" 1>/dev/null 2>&1
    echo "3. Copying Files From Your Google Drive > Server"
    rclone copy gdrive:/Backup/"$YMLPROGRAM".tar.bz2 /tmp/"$YMLPROGRAM" -v --checksum --drive-chunk-size=64M 1>/dev/null 2>&1
    tar -xvf /tmp/"$YMLPROGRAM".tar.bz2 /opt/appdata/"$YMLPROGRAM" 1>/dev/null 2>&1
    rm /tmp/"$YMLPROGRAM".tar.bz2
    docker start "$YMLPROGRAM" 1>/dev/null 2>&1
    echo "4. Restarting Your Docker Program"
    echo ""
    echo "Finished - Check the program to see if it worked!"
else
    echo No
    clear
    echo Not Restored Up! - "$YMLDISPALY"
    echo 
fi

read -n 1 -s -r -p "Press any key to continue "