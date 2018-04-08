#!/bin/bash
# Credit: RXWatcher
find /mnt/nzbget/completed/ebooks/* -type d -mmin +60 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/nzbget/completed/movies/* -type d -mmin +60 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/nzbget/completed/music/*  -type d -mmin +60 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/nzbget/completed/tv/* -type d -mmin +60 -ls -exec rm -rf {} + 2>/dev/null