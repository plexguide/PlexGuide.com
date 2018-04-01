################## Built for PY3

import os
import os.path
import shutil

folders = [
"var/plexguide/logs", 
"mnt/deluge/temp",
"mnt/deluge/downloaded", 
"mnt/deluge/torrent", 
"mnt/rutorrents/downloads",  
"mnt/move/tv", 
"mnt/move/movies", 
"mnt/move/music", 
"mnt/nzbget/completed/movies",
"mnt/nzbget/completed/music",
"mnt/nzbget/completed/tv",
"mnt/nzbget/completed/ebooks",
"mnt/nzbget/incomplete",
"mnt/nzbget/nzb",
"mnt/nzbget/queue",
"mnt/nzbget/tmp",
"mnt/nzbget/log",
"mnt/sab/admin",
"mnt/sab/complete/tv",
"mnt/sab/complete/movies",
"mnt/sab/complete/music",
"mnt/sab/complete/ebooks",
"mnt/sab/incomplete",
"mnt/sab/nzb",
"opt/appdata/plexguide"
]
for folder in folders:
    print(folder)
    dir = os.path.join('/',folder)
    if os.path.exists(dir):
        shutil.rmtree(dir)
    os.makedirs(dir)
    os.chmod(dir, 0o775)
    os.chown(dir, 1000, 1000)