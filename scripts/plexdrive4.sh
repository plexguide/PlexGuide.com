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
    echo "when complete.  You can complete other tasks by OPENING UP"
    echo "a second/another console-terminal window. Ensure that you have"
    echo "your Google Secret/Password ready for this action!"
    echo
    echo "Obtain Google Information at http://googleapi.plexguide.com"
    echo "More PlexDrive information at http://plexdrive.plexguide.com"
    echo
    read -n 1 -s -r -p "Press any key to continue"
    clear
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
    apt-get update
    apt-get install -y mongodb-org

    ## Enable Mongod Service
    systemctl daemon-reload
    systemctl enable mongod
    systemctl start mongod
    clear
    echo "WINDOWS USERS ONLY: When you copy and paste from terminal,"
    echo "USE CTRL + Insert.  DO NOT use CTRL +C or right click on terminal."
    echo "If you mess it up, select OPTION 3 on the main"
    echo "menu and start with Option [1] again."
    echo
    echo "Again, when you see the BLUE Letters moving until it nearly stops"
    echo "leave this window terminal open.  When it's complete, close it and"
    echo "come back to the same menu and select Option [2] about the plexdrive"
    echo "service. If you forget, you will never have content at /mnt/plexdrive4"
    echo "you enable the service!"
    echo
    echo "If at anytime the program gets stuck, Press CTRL+Z ([3]delete keys and rerun)"
    echo
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
    chmod 755 /mnt/plexdrive4 2>dev/null
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
