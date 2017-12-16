#!/bin/bash

############################################################### FOLDERS

############################################################### PERMISSIONS
chown 1000:1000 /mnt/ 1>/dev/null 2>&1

chown 1000:1000 /mnt/gdrive 1>/dev/null 2>&1
chown 1000:1000 /mnt/gdrive/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/gdrive/movies 1>/dev/null 2>&1

chmod 777 /mnt/gdrive 1>/dev/null 2>&1
chmod 777 /mnt/gdrive/tv 1>/dev/null 2>&1
chmod 777 /mnt/gdrive/movies 1>/dev/null 2>&1

chown 1000:1000 /mnt/.grcypt 1>/dev/null 2>&1
chown 1000:1000 /mnt/.grcypt/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/.grcypt/movies 1>/dev/null 2>&1

chmod 777 /mnt/.grcypt 1>/dev/null 2>&1
chmod 777 /mnt/.grcypt/tv 1>/dev/null 2>&1
chmod 777 /mnt/.grcypt/movies 1>/dev/null 2>&1

chown 1000:1000 /mnt/move 1>/dev/null 2>&1
chown 1000:1000 /mnt/move/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/move/movies 1>/dev/null 2>&1

chmod 777 /mnt/move 1>/dev/null 2>&1
chmod 777 /mnt/move/tv 1>/dev/null 2>&1
chmod 777 /mnt/move/movies 1>/dev/null 2>&1

chown 1000:1000 /mnt/nzbget 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/completed 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/completed/movies 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/completed/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/completed/movies 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/incomplete 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/nzb 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/queue 1>/dev/null 2>&1
chown 1000:1000 /mnt/nzbget/tmp 1>/dev/null 2>&1

chmod 777 /mnt/nzbget 1>/dev/null 2>&1
chmod 777 /mnt/nzbget/completed 1>/dev/null 2>&1
chmod 777 /mnt/nzbget/completed/movies 1>/dev/null 2>&1
chmod 777 /mnt/nzbget/completed/tv 1>/dev/null 2>&1
chmod 777 /mnt/nzbget/incomplete 1>/dev/null 2>&1
chmod 777 /mnt/nzbget/nzb 1>/dev/null 2>&1
chmod 777 /mnt/nzbget/queue1>/dev/null 2>&1
chmod 777 /mnt/nzbget/tmp 1>/dev/null 2>&1

chown 1000:1000 /mnt/plexdrive4 1>/dev/null 2>&1
chown 1000:1000 /mnt/plexdrive4/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/plexdrive4/movies 1>/dev/null 2>&1

chown 1000:1000 /mnt/encrypt 1>/dev/null 2>&1
chown 1000:1000 /mnt/encrypt/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/encrypt/movies 1>/dev/null 2>&1

chown 1000:1000 /mnt/sab 1>/dev/null 2>&1
chown 1000:1000 /mnt/sab/admin 1>/dev/null 2>&1
chown 1000:1000 /mnt/sab/complete 1>/dev/null 2>&1
chown 1000:1000 /mnt/sab/complete/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/sab/complete/movies 1>/dev/null 2>&1
chown 1000:1000 /mnt/sab/incomplete 1>/dev/null 2>&1
chown 1000:1000 /mnt/sab/nzb 1>/dev/null 2>&1

chmod 777 /mnt/sab/ 1>/dev/null 2>&1
chmod 777 /mnt/sab/complete 1>/dev/null 2>&1
chmod 777 /mnt/sab/complete/tv  1>/dev/null 2>&1
chmod 777 /mnt/sab/complete/movies  1>/dev/null 2>&1
chmod 777 /mnt/sab/complete/incomplete  1>/dev/null 2>&1
chmod 777 /mnt/sab/complete/nzb  1>/dev/null 2>&1

chown 1000:1000 /mnt/unionfs 1>/dev/null 2>&1
chown 1000:1000 /mnt/tv 1>/dev/null 2>&1
chown 1000:1000 /mnt/movies 1>/dev/null 2>&1

chown 1000:1000 /mnt/.config/* 1>/dev/null 2>&1
chown 1000:1000 /mnt/.plexdrive* 1>/dev/null 2>&1

chmod 777 /mnt/.config/* 1>/dev/null 2>&1
chmod 777 /mnt/.plexdrive*  1>/dev/null 2>&1

bash /opt/plexguide/scripts/startup/directories.sh
