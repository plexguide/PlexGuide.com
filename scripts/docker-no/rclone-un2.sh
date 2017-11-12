# ensure that the unencrypted services are on
systemctl enable rclone
systemctl enable move

# turn services back on
systemctl start unionfs
systemctl start rclone
systemctl start move

clear
cat << EOF
NOTE: You installed the encrypted version for the RClone data transport! If you
messed anything up, select [2] and run through again.  Also check:
http://unrclone.plexguide.com and or post on http://reddit.plexguide.com

HOW TO CHECK: In order to check if everything is working, have 1 item at least in 
your google Drive

1. Type: /mnt/rclone (and then you should see some item from your g-drive there)
2. Type: /mnt/rclone-union (and you should see the same g-drive stuff there)

Verifying that 1 and 2 are important due to this is how your data will sync!

EOF
bash /opt/plexguide/scripts/docker-no/continue.sh