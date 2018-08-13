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
mkdir -p /opt/appdata/pgblitz/vars/

#### Generates the GDSA List from the Processed Keys
if [ -e /opt/appdata/pgblitz/vars/automated ]; then
    GDSAARRAY=(`ls -la $path/automation | awk '{print $9}' | grep PG`)
else
    GDSAARRAY=(`ls -la $path/processed | awk '{print $9}' | grep GDSA`)
fi
GDSACOUNT=`expr ${#GDSAARRAY[@]} - 1`

#grabs vars from files
if [ -e /opt/appdata/pgblitz/vars/lastGDSA ]; then
	GDSAUSE=`cat /opt/appdata/pgblitz/vars/lastGDSA`
	GDSAAMOUNT=`cat /opt/appdata/pgblitz/vars/gdsaAmount`
else
	GDSAUSE=0
	GDSAAMOUNT=0
fi
while [ 1 ]
do
    #Find files to transfer
    IFS=$'\n'
    files=(`find /mnt/move -type f ! -name '*partial~' ! -name '*_HIDDEN~' ! -name '*.fuse_hidden*' ! -name "*.lck" ! -name "*.version" ! -path '.unionfs-fuse/*' ! -path '.unionfs/*' ! -path '*.inProgress/*'`)
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
                FILESIZE1=`wc -c < "$i"`
                sleep .5
                FILESIZE2=`wc -c < "$i"`
                if [ "$FILESIZE1" -ne "$FILESIZE2" ]; then
                    echo "[PGBlitz] File is still getting bigger $i" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
                    continue
                fi
                TRANSFERS=`ls -la /opt/appdata/pgblitz/pid/ | grep trans | wc -l`
                if [ ! $TRANSFERS -ge 8 ]; then
                    echo "[PGBlitz] Starting upload of $i" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

                    #Run upload script demonised
                    /opt/appdata/pgblitz/upload.sh $i ${GDSAARRAY[$GDSAUSE]} &
                    
                    PID=$!
                    FILEBASE=`basename $i`

                    #append filesize to GDSAAMOUNT
                    GDSAAMOUNT=`expr $GDSAAMOUNT + $FILESIZE2`

                    #add transfer to pid directory
                    echo "$PID" > /opt/appdata/pgblitz/pid/$FILEBASE.trans
                    
                    #increase or reset $GDSAUSE?
                    if [ "$GDSAAMOUNT" -gt "751619276800" ]; then
						echo "[PGBlitz] ${GDSAARRAY[$GDSAUSE]} has hit 700GB switching to next SA" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
                        if [ ${GDSAUSE} -eq ${GDSACOUNT} ]; then
                            GDSAUSE=0
                            GDSAAMOUNT=0
                        else
                            GDSAUSE=`expr $GDSAUSE + 1`
                            GDSAAMOUNT=0
							
                        fi
						#record next GDSA in case of crash/reboot
						echo "$GDSAUSE" > /opt/appdata/pgblitz/vars/lastGDSA
					fi
					#record GDSA transfered in case of crash/reboot
                    echo "$GDSAAMOUNT" > /opt/appdata/pgblitz/vars/gdsaAmount
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