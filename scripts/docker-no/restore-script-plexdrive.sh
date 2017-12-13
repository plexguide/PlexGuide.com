
    clear
    rm -r /opt/appdata/plexdrive 1>/dev/null 2>&1
    echo "1. Creating a directory for PlexDrive"
    mkdir -p /home/plexdrive
    echo "2. Copying Files From Your Google Drive > Server"
    echo ""
    rclone copy gdrive:/Backup/plexdrive/plexdrive.zip /tmp --checksum --drive-chunk-size=64M -v
    unzip /tmp/plexdrive.zip -d /
    rm -r /tmp/plexdrive.zip
    echo ""
    echo "Finished - Check the Folder Manually or Program!"
    echo

read -n 1 -s -r -p "Press any key to continue "
