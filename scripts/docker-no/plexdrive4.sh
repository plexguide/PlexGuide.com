################# Install Plex
echo -n "Do you want to install PlexDrive? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    clear

# Dispalys First Warning Message
cat << EOF
CRITICAL: Once PlexDrive starts the scan, DO NOT shut down your computer
AND do NOT CLOSE THIS TERMINAL WINDOW until the scan is complete.

Completed: Once completed, you must reboot the server to ensure that
everything is working.  If it works, you should see some of your Google
Drive Items by typing: cd mnt/plexdrive4 & ls or you can come back to THIS
menu and use the PlexDrive Verification Tool.
EOF
echo
read -n 1 -s -r -p "Press any key to continue"
clear

## Install Mongod Program
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
apt-get update
apt-get install -y mongodb-org

## Enable Mongod Service
systemctl daemon-reload
systemctl enable mongod
systemctl start mongod
clear

## Create the PlexDrive4 Service
tee "/etc/systemd/system/plexdrive4.service" > /dev/null <<EOF
## Create the PlexDrive4 Service
[Unit]
Description=PlexDrive4 Service
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/plexdrive4 --uid=0 --gid=0 --fuse-options=allow_other --refresh-interval=1m /mnt/plexdrive4
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enables the PlexDrive Service
systemctl daemon-reload
systemctl enable plexdrive4.service

## Display 2nd Warning Message
clear
cat << EOF
WINDOWS USERS Only: When copying information to your terminal winodw,
PRESS [CTRL+Insert].  Do not use CTRL+C; this will result in messing up
things.  This then will require you to DELETE your PLEXDRIVE tokens and
restart the process again.

ALL USERS: Anytime you mess things up or have problems, press CTRL + Z or X
to break out.  Come back again, select Option 3 to remove previous keys and
press option [1] to restart the process.

FINAL NOTE: Leave this terminal window open UNTIL the action is complete.
If you fail to do this, you will have to repeat the process again.  If you
are impatient, PLEASE open a SECOND terminal window to do other things.
Look for a message like this:-
[PLEXDRIVE4] [2017-11-15 14:51] INFO   : First cache build process finished!

EOF

    echo
    read -n 1 -s -r -p "Press any key to continue"
    clear
    cd /tmp
    wget https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64
    mv plexdrive-linux-amd64 plexdrive4
    mv plexdrive4 /usr/bin/
    cd /usr/bin/
    chown root:root /usr/bin/plexdrive4
    chmod 755 /usr/bin/plexdrive4
    clear
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
