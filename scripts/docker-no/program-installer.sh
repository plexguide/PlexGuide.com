#!/bin/bash
YMLPROGRAM=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLDISPLAY=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLPORT=$(awk '/ymlport/{print $2}' /opt/plexguide/tmp.txt)

echo -n "Do you want to Install/Upgrade "$YMLDISPLAY" (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    docker stop "$YMLPROGRAM"
    docker rm "$YMLPROGRAM"
    docker-compose -f /opt/plexguide/scripts/docker/"$YMLPROGRAM".yml up -d
    echo
    echo Upgraded "$YMLDISPLAY" - Use Port "$YMLPORT" with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - $YMLDISPALY
    echo
fi

## ensure folders follow plexguide
bash /opt/plexguide/scripts/startup/owner.sh
read -n 1 -s -r -p "Press any key to continue "
