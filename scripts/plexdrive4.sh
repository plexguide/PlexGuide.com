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
    echo "whatever you do, do not shut down the computer until"
    echo "PlexDrive4 completes the scan."
    echo
    echo "You should see all your folders under /mnt/plexdrive4."
    echo "when complete.  You can complete other tasks, by OPENING UP"
    echo "a second console-terminal window and ensure that you have"
    echo "your Google Secret/Password ready for this action!"
    echo
    read -n 1 -s -r -p "Press any key to continue"
    clear
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
    apt-get update
    apt-get install -y mongodb-org
    
    ## Enable Mongod Service
    sudo systemctl daemon-reload
    sudo systemctl enable mongod
    sudo systemctl start mongod
    clear
    echo "Important for WINDOWS Users: When you have to copy and paste"
    echo "from terminal, USE CTRL + Insert.  DO NOT use CTRL +C or right "
    echo "click on terminal.  If you mess it up, select OPTION 3 on the main"
    echo "menu and start with Option [1] again"
    echo
    echo "Again, when you see the BLUE Letters moving until it nearly stops"
    echo "leave this window terminal open.  When it's complete, close it and"
    echo "come back to the same menu and select Option [2] about the plexdrive"
    echo "service. If you forget, you'll never have content at /mnt/plexdrive4"
    echo "until you do so!"
    bash continue.sh
    clear
    cd /tmp
    wget https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64
    mv plexdrive-linux-amd64 plexdrive4
    mv plexdrive4 /usr/bin/
    cd /usr/bin/
    chown root:root /usr/bin/plexdrive4
    chmod 755 /usr/bin/plexdrive4
    mkdir /mnt/plexdrive4 2>dev/null
    chmod 755 /mnt/plexdrive4
    plexdrive4 --uid=0 --gid=0 -o allow_other -v 2 --refresh-interval=1m /mnt/plexdrive4
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
