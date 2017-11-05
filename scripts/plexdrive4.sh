################# Install Plex
echo -n "Do you want to install PlexDrive? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    clear
    echo "Very Important - Once PlexDrive is running (blue letters)"
    echo "make sure to press CTRL+C. Whatever you do, do not shut"
    echo "down the computer until PlexDrive4 completed the scan."
    echo
    echo "You should see all your folders under /mnt/plexdrive4."
    echo "Again, press CTRL + C once it's running the scan to "
    echo "continue onward."
    echo
    read -n 1 -s -r -p "Press any key to continue"
    clear
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
    apt-get update
    apt-get install -y mongodb-org
    systemctl daemon-reload
    systemctl enable mongod
    systemctl start mongod   
    mv plexdrive4.service /etc/systemd/system/
    cd /tmp
    wget https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64
    mv plexdrive-linux-amd64 plexdrive4
    mv plexdrive4 /usr/bin/
    cd /usr/bin/
    chown root:root /usr/bin/plexdrive4
    chmod 755 /usr/bin/plexdrive4
    mkdir /mnt/plexdrive4 && chmod 755 /mnt/plexdrive4
    sudo systemctl daemon-reload
    sudo systemctl enable plexdrive4.service
    sudo systemctl start plexdrive4.service
    # screen plexdrive4 --uid=0 --gid=0 -o allow_other -v 2 --refresh-interval=1m /mnt/plexdrive4
    clear
    cd /opt/plexguide/scripts
    echo Installed PlexDrive; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - PlexDrive
    echo 
fi