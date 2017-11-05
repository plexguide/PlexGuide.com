## Making the directories and setting the permissions
mkdir /mnt/rclone-union
mkdir /mnt/rclone-move
chmod 755 /mnt/rclone-move
chmod 755 /mnt/rclone-union

## Installing rclone
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

## Making rclone directory
mkdir /mnt/rclone
chmod 755 /mnt/rclone
chown root /mnt/rclone

## Warning
clear
echo "Warning: You are going to make two rclone directories.  Please go"
echo "to http://rclone.plexguide.com for instructions"
 
echo "Quick Instructions - Write Down or goto website"
echo "[N] New Remote, [9] Google, Enter Info, Verify, Ok, and Continue"
echo "[N] New Remote, [11] Local, Type /mnt/rclone-move, Ok, and Quit"
echo

bash continue.sh

rclone config

## Copying the config from the local folder to the root folder
sudo mkdir /root/.config && sudo mkdir /root/.config/rclone 2>dev/null
sudo cp ~/.config/rclone/rclone.conf /root/.config/rclone 2>dev/null