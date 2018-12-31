#!/bin/bash
find /mnt/downloads/sabnzbd/abooks/* -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/downloads/sabnzbd/ebooks/* -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/downloads/sabnzbd/movies/* -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/downloads/sabnzbd/music/*  -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
find /mnt/downloads/sabnzbd/tv/* -type d -mmin +240 -ls -exec rm -rf {} + 2>/dev/null
