#!/bin/bash

find /mnt/nzbget/downloads/completed/tv/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
find /mnt/nzbget/downloads/completed/music/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
find /mnt/nzbget/downloads/completed/movies/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
find /mnt/nzbget/downloads/completed/ebooks/* -maxdepth 1 -mmin +240 -type f -exec rm -fv {} 2>/dev/null \;
