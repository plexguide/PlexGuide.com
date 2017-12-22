#!/bin/bash
YMLPROGRAM=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLDISPLAY=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLPORT=$(awk '/ymlport/{print $2}' /opt/plexguide/tmp.txt)


    docker stop "$YMLPROGRAM"
    docker rm "$YMLPROGRAM"
    docker-compose -f /opt/plexguide/scripts/docker/"$YMLPROGRAM".yml up -d
    echo
    echo Upgraded "$YMLDISPLAY" - Use Port "$YMLPORT" with IP Address; hostname -I;
    echo

bash /opt/plexguide/scripts/startup/owner.sh
read -n 1 -s -r -p "Press any key to continue "
echo ""
