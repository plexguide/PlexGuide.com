{% raw %}
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

echo "[PGBlitz] PGBlitz Started for the First Time - 10 Second Sleep" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
sleep 10
path=/opt/appdata/pgblitz/keys
mkdir -p /opt/appdata/pgblitz/pid/
mkdir -p /opt/appdata/pgblitz/json/
mkdir -p /opt/appdata/pgblitz/logs/

#### Generates the GDSA List from the Processed Keys
if [ -e /opt/appdata/pgblitz/vars/automated ]; then
    GDSAARRAY=(`ls -la $path/automation | awk '{print $9}' | grep PG`)
else
    GDSAARRAY=(`ls -la $path/processed | awk '{print $9}' | grep GDSA`)
fi
GDSACOUNT=`expr ${#GDSAARRAY[@]} - 1`
GDSAUSE=0
while [ 1 ]
do
    #Find files to transfer
    IFS=$'\n'
    files=(`find /mnt/move -type f ! -name '*partial~' ! -name '*_HIDDEN~' ! -name "*.lck" ! -path '.unionfs-fuse/*' ! -path '.unionfs/*' ! -path '*.inProgress/*'`)
    if [[ ${#files[@]} -gt 0 ]]; then
        #if files are found loop though and upload
        for i in "${files[@]}"
        do
            #FILESTERL=$(printf '%q' "$i")
            #if file has a lockfile skip
            if [ -e ${i}.lck ]; then
                echo "[PGBlitz] Lock File found for $i" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
                continue
            else
                TRANSFERS=`ls -la /opt/appdata/pgblitz/pid/ | grep trans | wc -l`
                if [ ! $TRANSFERS -ge 8 ]; then
                    echo "[PGBlitz] Starting upload of $i" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
                    #Run upload script demonised
                    /opt/appdata/pgblitz/upload.sh $i ${GDSAARRAY[$GDSAUSE]} &
                    
                    PID=$!
                    FILEBASE=`basename $i`
                    
                    #add transfer to pid directory
                    echo "$PID" > /opt/appdata/pgblitz/pid/$FILEBASE.trans
                    
                    #increase or reset $GDSAUSE
                    if [ ${GDSAUSE} -eq ${GDSACOUNT} ]; then
                        GDSAUSE=0
                    else
                        GDSAUSE=`expr $GDSAUSE + 1`
                    fi
                else
                    echo "[PGBlitz] Already 8 transfers running, waiting for next loop" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
                    break
                fi
                
            fi
            
            
        done
        echo "[PGBlitz] Finished looking for files, sleeping 20 secs" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    else
        echo "[PGBlitz] Nothing to upload, sleeping 20 secs" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    fi
    sleep 20
done
{% endraw %}