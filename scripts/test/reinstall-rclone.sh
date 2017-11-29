#!/bin/bash

## Re-do preinstall of RClone

bash /opt/plexguide/scripts/startup/rclone-preinstall.sh

systemctl restart unionfs
systemctl restart unionfs-encrypt
