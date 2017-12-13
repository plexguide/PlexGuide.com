#!/bin/bash

    clear
    rm -r /mnt/gdrive/Backup/plexdrive 1>/dev/null 2>&1
    echo "1. Compressing & Zipping Your Backup Request for PLEXDRIVE"
    mkdir -p /gdrive/Backup/plexdrive
    zip -r /tmp/plexdrive.zip /home/plexdrive/.plexdrive
    echo "2. Copy Files to Your Google Drive"
    rclone copy /tmp/plexdrive.zip gdrive:/Backup/plexdrive -v --checksum --drive-chunk-size=64M 1>/dev/null 2>&1
    rm /tmp/plexdrive.zip
    echo ""
    echo "Finished - Check Your Google Drive for the Backup Incase!"
    echo ""

read -n 1 -s -r -p "Press any key to continue "
