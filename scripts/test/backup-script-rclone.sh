#!/bin/bash

    clear
    rm -r /home/plexguide/gdrive/Backup/rclone 1>/dev/null 2>&1
    echo "1. Compressing & Zipping Your Backup Request for RCLONE"
    mkdir -p /home/plexguide/gdrive/Backup/rclone
    zip -r /tmp/rclone.zip /home/plexguide/.config/rclone
    echo "2. Copy Files to Your Google Drive"
    rclone copy /tmp/rclone.zip gdrive:/Backup/rclone -v --checksum --drive-chunk-size=64M 1>/dev/null 2>&1
    rm /tmp/rclone.zip
    echo ""
    echo "Finished - Check Your Google Drive for the Backup Incase!"
    echo ""

read -n 1 -s -r -p "Press any key to continue "
