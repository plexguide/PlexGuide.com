#!/bin/bash

cp /root/.sabnzbd/sabnzbd.ini /mnt/rclone-union/BACKUP

cp -r /root/.config/NzbDrone/ /mnt/rclone-union/BACKUP

cp -r /root/.config/Radarr/ /mnt/rclone-union/BACKUP

cp -r /root/.couchpotato/ /mnt/rclone-union/BACKUP

cp -r /root/.config/rclone/ /mnt/rclone-union/BACKUP

cp -r /root/.plexdrive/ /mnt/rclone-union/BACKUP

cp -r /opt/appdata/embyserver/ /mnt/rclone-union/BACKUP
