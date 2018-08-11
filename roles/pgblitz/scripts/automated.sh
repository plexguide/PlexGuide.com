#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   PhysK & Teresa
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
echo "INFO - Setting Automated SA flag"  > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
touch /opt/appdata/pgblitz/vars/automated

echo "INFO - Installing requirements" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
dialog --title "NOTE" --msgbox "\nInstalling requirements" 0 0
cd  /opt/plexguide/roles/pgblitz/scripts/WCKD/
pip3 install -r requirements.txt
read -n 1 -s -r -p "Press any key to continue"
dialog --title "Auto SA Creation" \
       --yesno "Are you planning to use encryption?\n\nENCRYPTION CURRENTLY NOT WORKING!!" 7 60
response=$?
case $response in
    0)
        dialog --title "NOTE" --msgbox "\nYou were told it's not working yet ;-)" 0 0
        final = "encrypted";
        ;;
    1)
        echo 'INFO - USING AUTO SA CREATION TOOL' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        echo 'INFO - RUNNING Auto SA Tool by Teresa' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
        dialog --title "WARNING!" --msgbox "\nMake Sure you have read the Wiki for using the Auto SA Tool!" 0 0
        clear && python3 pgblitz.py
        if [ $? == 1 ]; then
            dialog --title "ERROR" --msgbox "\nSomething went wrong executing the script, Putting you back to the menu!\nPress [ENTER] to Continue!" 0 0
            bash /opt/plexguide/roles/deploychoice.sh
        fi
        if [ -e /root/.config/rclone/rclone.config ]; then
            mv /root/.config/rclone/rclone.config /root/.config/rclone/rclone.config.old
            dialog --title "NOTE" --msgbox "\nYou're old rclone config has been moved to /root/.config/rclone/rclone.config.old\nPress [ENTER] to Continue!" 0 0
        fi
        mv /opt/appdata/pgblitz/keys/automation/rclone.conf /root/.config/rclone/rclone.config
        dialog --title "NOTE" --msgbox "\nYour emails should be auto added to your tdrive!\nPress [ENTER] to Continue!" 0 0
        dialog --title "NOTE" --msgbox "\nAll done! Now to continue deploying PGBlitz!!\nPress [ENTER] to Continue!" 0 0
        final = "unencrypted"
        ;;
esac

#### BLANK OUT PATH - This Builds For UnionFS
rm -r /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1
touch /var/plexguide/unionfs.pgpath 1>/dev/null 2>&1

### Build UnionFS Paths Based on Version
if [ "$final" == "unencrypted" ];then
    echo -n "/mnt/gdrive=RO:/mnt/tdrive=RO:" >> /var/plexguide/unionfs.pgpath
elif [ "$final" == "encrypted" ];then
    echo -n "/mnt/gcrypt=RO:/mnt/tcrypt=RO:" >> /var/plexguide/unionfs.pgpath
fi

### Add GDSA Paths for UnionFS
bash /opt/plexguide/roles/pgblitz/scripts/ufbuilder.sh
temp=$( cat /tmp/pg.gdsa.build )
echo -n "$temp" >> /var/plexguide/unionfs.pgpath

#ask about PGBlitz GUI
dialog --title "PGBLitz WebGUI" \
       --yesno "Would you like to deploy the new PGBlitz WebGUI?" 7 60
response=$?
case $response in
    0)
        WEBUI="yes";
        ;;
    1)
        WEBUI="no";
        ;;
esac

### Execute Playbook Based on Version
if [ "$final" == "unencrypted" ];then
    if [ "$WEBUI" == "no" ]; then
        ansible-playbook /opt/plexguide/pg.yml --tags pgblitz --skip-tags encrypted,gui
    else
        ansible-playbook /opt/plexguide/pg.yml --tags pgblitz --skip-tags encrypted
    fi
elif [ "$final" == "encrypted" ];then
    if [ "$WEBUI" == "no" ]; then
        ansible-playbook /opt/plexguide/pg.yml --tags pgblitz --skip-tags gui
    else
        ansible-playbook /opt/plexguide/pg.yml --tags pgblitz
    fi
fi

file="/mnt/unionfs/plexguide/pgchecker.bin"
if [ -e "$file" ]; then
    echo 'PASSED - UnionFS is Properly Working - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
else
    mkdir -p /tmp/pgchecker/ 1>/dev/null 2>&1
    touch /tmp/pgchecker/pgchecker.bin 1>/dev/null 2>&1
    if [ "$final" == "encrypted" ]; then
        mkdir -p /mnt/tcrypt/plexguide/ 1>/dev/null 2>&1
        mkdir -p /mnt/gcrypt/plexguide/ 1>/dev/null 2>&1
        rclone copy /tmp/pgchecker gcyrpt:/plexguide/ &>/dev/null &
        rclone copy /tmp/pgchecker tcrypt:/plexguide/ &>/dev/null &
    else
        mkdir -p /mnt/tdrive/plexguide/ 1>/dev/null 2>&1
        mkdir -p /mnt/gdrive/plexguide/ 1>/dev/null 2>&1
        rclone copy /tmp/pgchecker gdrive:/plexguide/ &>/dev/null &
        rclone copy /tmp/pgchecker tdrive:/plexguide/ &>/dev/null &
    fi
    echo 'INFO - Deployed PGChecker.bin - PGChecker.Bin' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
fi
echo ""
read -n 1 -s -r -p "Press any key to continue"
dialog --title "NOTE" --msgbox "\nPG Drive & PG Blitz Deployed!!" 0 0