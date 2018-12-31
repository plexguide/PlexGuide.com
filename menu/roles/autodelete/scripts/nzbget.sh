#!/bin/bash
find /mnt/downloads/nzbget/tv/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
find /mnt/downloads/nzbget/music/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
find /mnt/downloads/nzbget/movies/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
find /mnt/downloads/nzbget/ebooks/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
find /mnt/downloads/nzbget/abooks/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
