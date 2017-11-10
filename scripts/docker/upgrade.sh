#!/bin/bash

read -n 1 -s -r -p "Press any key to continue "

echo -n "Do you want to Upgrade (y/n)?"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    docker stop "$YMLPROGRAM"
    docker rm "$YMLPROGRAM"
    docker-compose -f /opt/plexguide/scripts/docker/"$YMLPROGRAM".yml up -d
    clear
    echo Upgraded "$YMLDISPLAY" - Use Port "$YMLPORT" with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - Ombi
    echo 
fi