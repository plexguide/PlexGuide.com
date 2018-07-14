
    clear
    rm -r /opt/appdata/rclone 1>/dev/null 2>&1
    echo "1. Creating a directory for RClone"
    mkdir -p /home/plexguide/.rclone
    echo "2. Copying Files From Your Google Drive > Server"
    echo ""
    rclone copy gdrive:/Backup/rclone/rclone.zip /tmp --checksum --drive-chunk-size=64M -v
    unzip /tmp/rclone.zip -d /
    rm -r /tmp/rclone.zip
    echo ""
    echo "Finished - Check the Folder Manually or Program!"
    echo

read -n 1 -s -r -p "Press any key to continue "
