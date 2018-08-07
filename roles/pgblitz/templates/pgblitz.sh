#!/bin/bash
##
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & FlickerRate & Bryde ツ & PhysK
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

echo "INFO - PGBlitz Started for the First Time - 10 Second Sleep" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
sleep 10
path=/opt/appdata/pgblitz/keys
mkdir $downloadpath/move/movies 1>/dev/null 2>&1
mkdir $downloadpath/move/tv 1>/dev/null 2>&1
mkdir -p /opt/appdata/pgblitz/pid/
mkdir -p /opt/appdata/pgblitz/logs/
chown 1000:1000 -R $downloadpath/move/*

#### Generates the GDSA List from the Processed Keys
GDSAARRAY=(`ls -la $path/processed | awk '{print $9}' | grep GDSA`)
GDSACOUNT=`expr ${#GDSAARRAY[@]} - 1`
GDSAUSE=0
while [ 1 ]
do
    #Find files to transfer
    files=(`find /mnt/move -type f ! -name '*partial~' ! -name '*_HIDDEN~' ! -path '.unionfs-fuse/*' ! -path '.unionfs/*'`)
    if [[ ${#files[@]} -gt 0 ]]; then
        #if files are found loop though and upload
        for i in "${files[@]}"
        do
            #if file is in fileLock skip
            if `cat /tmp/fileLock | grep $i` ; then
                continue
            fi
            #Run upload script demonised
            /opt/plexguide/pgblitz/upload.sh \"$i\" ${GDSAARRAY[$GDSAUSE]} &
            PID=$!

            #get basename of file
            fileBase=`basename \"$i\"`

            #some logging
            echo $PID >> /opt/appdata/pgblitz/pid/${GDSAARRAY[${GDSAUSE}]}_${fileBase}.pid
            echo "INFO - Started upload of $i - PID: ${PID}" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
            #increase or reset $GDSAUSE
            if [ ${GDSAUSE} -eq ${GDSACOUNT} ]; then
                GDSAUSE=0
            else
                GDSAUSE=`expr $GDSAUSE + 1`
            fi
        done
        echo "INFO - Finished looking for files, sleeping 20 secs" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    else
        echo "INFO - Nothing to upload, sleeping 20 secs" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    fi
    sleep 20
done