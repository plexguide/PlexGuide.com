{% raw %}
#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 & PhysK
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/pgblitz.sh
# Logging Function
function log()
{
    echo "[PGBlitz] $@" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    echo "[PGBlitz] $@"
}

#Make sure all the folders we need are created
downloadpath=$(cat /var/plexguide/server.hd.path)
path=/opt/appdata/pgblitz/keys
mkdir -p /opt/appdata/pgblitz/pid/
mkdir -p /opt/appdata/pgblitz/json/
mkdir -p /opt/appdata/pgblitz/logs/
mkdir -p /opt/appdata/pgblitz/vars/

#Header
log "PGBlitz v2.1 Started"
log "Started for the First Time - Cleaning up if from reboot"

# Remove left over webui and transfer files
rm -f /opt/appdata/pgblitz/pid/*
rm -f /opt/appdata/pgblitz/json/*
rm -f /opt/appdata/pgblitz/logs/*

#copy any files that failed to upload back to /mnt/move
for i in `find /mnt/pgblitz/ -maxdepth 1 -mindepth 1 -type d`; do
    cp -r ${i}/* $downloadpath/move
    rm -fr ${i}/*
done
log "Cleaned up - Sleeping 10 secs"
sleep 10

#### Generates the GDSA List from the Processed Keys

GDSAARRAY=(`ls -la $path/processed | awk '{print $9}' | grep gdsa`)
GDSACOUNT=`expr ${#GDSAARRAY[@]} - 1`

# Check to see if we have any keys
if [ $GDSACOUNT -lt 1 ]; then
    log "No accounts found to upload with, Exit"
    exit 1
fi

# Check if BC is installed
if [ `echo "10 + 10" | bc` == "20" ]; then
    log "BC Found! All good :)"
else
    log "BC Not installed, Exit"
    exit 2
fi
# Grabs vars from files
if [ -e /opt/appdata/pgblitz/vars/lastGDSA ]; then
    GDSAUSE=`cat /opt/appdata/pgblitz/vars/lastGDSA`
    GDSAAMOUNT=`cat /opt/appdata/pgblitz/vars/gdsaAmount`
else
    GDSAUSE=0
    GDSAAMOUNT=0
fi

# Run Loop
while [ 1 ]
do
    #Find files to transfer
    IFS=$'\n'
    files=(`find ${downloadpath}/move -type f ! -name '*partial~' ! -name '*_HIDDEN~' ! -name '*.fuse_hidden*' ! -name "*.lck" ! -name "*.version" ! -path '.unionfs-fuse/*' ! -path '.unionfs/*' ! -path '*.inProgress/*'`)
    if [[ ${#files[@]} -gt 0 ]]; then
        # If files are found loop though and upload
        log "Files found to upload"
        for i in "${files[@]}"
        do
            # If file has a lockfile skip
            if [ -e ${i}.lck ]; then
                log "Lock File found for $i"
                continue
            else
                # Check if file is still getting bigger
                FILESIZE1=`wc -c < "$i"`
                sleep 3
                FILESIZE2=`wc -c < "$i"`
                if [ "$FILESIZE1" -ne "$FILESIZE2" ]; then
                log "File is still getting bigger $i"
                    continue
                fi

                # Check if we have any upload slots available
                TRANSFERS=`ls -la /opt/appdata/pgblitz/pid/ | grep trans | wc -l`
                if [ ! $TRANSFERS -ge 8 ]; then
                    if [ -e $i ]; then
                    log "Starting upload of $i"
                        # Append filesize to GDSAAMOUNT
                        GDSAAMOUNT=`echo "$GDSAAMOUNT + $FILESIZE2" | bc`

                        # Run upload script demonised
                        /opt/appdata/pgblitz/upload.sh $i ${GDSAARRAY[$GDSAUSE]} &

                        PID=$!
                        FILEBASE=`basename $i`

                        # Add transfer to pid directory
                        echo "$PID" > /opt/appdata/pgblitz/pid/$FILEBASE.trans

                        # Increase or reset $GDSAUSE?
                        if [ "$GDSAAMOUNT" -gt "783831531520" ]; then
                            log "${GDSAARRAY[$GDSAUSE]} has hit 730GB switching to next SA"
                            if [ ${GDSAUSE} -eq ${GDSACOUNT} ]; then
                                GDSAUSE=0
                                GDSAAMOUNT=0
                            else
                                GDSAUSE=`expr $GDSAUSE + 1`
                                GDSAAMOUNT=0
                            fi
                            # Record next GDSA in case of crash/reboot
                            echo "$GDSAUSE" > /opt/appdata/pgblitz/vars/lastGDSA
                        fi
                        log "${GDSAARRAY[$GDSAUSE]} is now `echo "$GDSAAMOUNT/1024/1024/1024" | bc -l`"
                        # Record GDSA transfered in case of crash/reboot
                        echo "$GDSAAMOUNT" > /opt/appdata/pgblitz/vars/gdsaAmount
                    else
                        log "File $i seems to have dissapeared"
                    fi
                else
                    log "Already 8 transfers running, waiting for next loop"
                    break
                fi
            fi
            log "Sleeping 5s before looking at next file"
            sleep 5
        done
        log "Finished looking for files, sleeping 5 secs"
    else
        log "Nothing to upload, sleeping 5 secs"

    fi
    sleep 5
done
{% endraw %}
