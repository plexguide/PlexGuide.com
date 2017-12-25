#!/bin/bash

############################################################### PERMISSIONS
chown 1000:1000 /mnt/ 1>/dev/null 2>&1

############################################################### Deluge


############################################################### rutorrent


############################################################### Other




chown 1000:1000 /mnt/encrypt 1>/dev/null 2>&1
chown 1000:1000 /mnt/encrypt/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/encrypt/movies 1>/dev/null 2>&1



################################################## For UnionFS
# chown 1000:1000 /mnt/unionfs 1>/dev/null 2>&1
# chown 1000:1000 /mnt/unionfs/tv 1>/dev/null 2>&1
# chown 1000:1000 /mnt/unionfs/movies 1>/dev/null 2>&1

# chmod 777 /mnt/unionfs 1>/dev/null 2>&1
# chmod 777 /mnt/unionfs/tv 1>/dev/null 2>&1
# chmod 777 /mnt/unionfs/movies 1>/dev/null 2>&1

################################################## For RCLONE & PLXDRIVE


bash /opt/plexguide/scripts/startup/directories.sh
