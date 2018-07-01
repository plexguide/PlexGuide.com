#!/bin/bash
# Credit: RXWatcher
find /mnt/sab/complete/ebooks/* -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/sab/complete/movies/* -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/sab/complete/music/*  -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/sab/complete/tv/* -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null