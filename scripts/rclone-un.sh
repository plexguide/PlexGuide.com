mkdir /mnt/rclone-union
mkdir /mnt/rclone-move
chmod 755 /mnt/rclone-move
chmod 755 /mnt/rclone-union
cd /tmp
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
cp rclone /usr/bin/
chown root:root /usr/bin/rclone
chmod 755 /usr/bin/rclone
mkdir -p /usr/local/share/man/man1
cp rclone.1 /usr/local/share/man/man1/
mandb
cd .. && sudo rm -r rclone*
mkdir /mnt/rclone
chmod 755 /mnt/rclone
schown root /mnt/rclone