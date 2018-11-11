#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & FlickerRate
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
downloadpath=$(cat /var/plexguide/server.hd.path)
tempbuild=$(cat /var/plexguide/json.tempbuild)
path=/opt/appdata/pgblitz/keys
rpath=/root/.config/rclone/rclone.conf
tdrive=$( cat /root/.config/rclone/rclone.conf | grep team_drive | head -n1 )
tdrive="${tdrive:13}"
ENCRYPTED="no"

if [ -f "/opt/appdata/pgblitz/vars/encrypted" ]; then
    ENCRYPTED="yes"
    PASSWORD=`cat /opt/appdata/pgblitz/vars/password`
    SALT=`cat /opt/appdata/pgblitz/vars/salt`
    ENC_PASSWORD=`rclone obscure "$PASSWORD"`
    ENC_SALT=`rclone obscure "$SALT"`
fi
#ls -la $path/processed | awk '{print $9}' | tail -n +4 > /tmp/pg.gdsa
echo "" >> $rpath
#### Ensure to Backup TDrive & GDrive and Wipe the Rest
#while read p; do

####tempbuild is need in order to call the correct gdsa
mkdir -p $downloadpath/pgblitz/$tempbuild
echo "[$tempbuild]" >> $rpath
echo "type = drive" >> $rpath
echo "client_id =" >> $rpath
echo "client_secret =" >> $rpath
echo "scope = drive" >> $rpath
echo "root_folder_id =" >> $rpath
echo "service_account_file = /opt/appdata/pgblitz/keys/processed/$tempbuild" >> $rpath
echo "team_drive = $tdrive" >> $rpath

if [ "$ENCRYPTED" == "yes" ]; then

    echo "" >> $rpath
    echo "[${tempbuild}C]" >> $rpath
    echo "type = crypt" >> $rpath
    echo "remote = $tempbuild:/encrypt" >> $rpath
    echo "filename_encryption = standard" >> $rpath
    echo "directory_name_encryption = true" >> $rpath
    echo "password = $ENC_PASSWORD" >> $rpath
    echo "password2 = $ENC_SALT" >> $rpath

fi

#done </tmp/pg.gdsa
