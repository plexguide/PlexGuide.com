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

FILE=$1
GDSA=$2

echo "[PGBlitz] Upload started for $FILE using $GDSA" >> /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

FILESTER="$(echo $FILE | sed 's/\'$downloadpath'\/move//g')"
FILEBASE=`basename $FILE`
FILEDIR=`$(echo $FILE | sed 's/\'$FILEBASE'\//g')`

mkdir -p $downloadpath/pgblitz/$GDSA
echo "[PGBlitz] Moving $FILE to GDSA folder: $GDSA" >> /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

# add to file lock to stop another process being spawned while file is moving
echo $FILE >> /tmp/fileLock

rclone move $FILE $downloadpath/pgblitz/$GDSA/$FILEDIR/$FILEBASE \
    --exclude="**partial~" --exclude="**_HIDDEN~" \
    --exclude=".unionfs-fuse/**" --exclude=".unionfs/**"

echo "[PGBlitz] $FILE Moved" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

#remove file lock
sed "s/\$FILE//g" /tmp/fileLock
{% endraw %}