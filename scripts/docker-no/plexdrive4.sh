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
Very Important: Once PlexDrive is running (blue letters) whatever you do,
do not shut down the computer until PlexDrive4 completes the scan.

If conducting a test in-between or verifying if your mount is ever working,
type /mnt/plexdrive4 & ls and verify your contents.  If you have other things
to do, open up a second terminal windows (you'll have to close this one
when it's done).  Ensure that you have your Google Secret/Password ready

Obtain Your Google Information at http://googleapi.plexguide.com
More PlexDrive Information at http://plexdrive.plexguide.com
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
WINDOWS USERS ONLY: When you copy and paste information from the terminal,
utilize CTRL + Insert to copy.  Do not use CTRL + C or copy and right click
on the terminal.  If you do, you might mess things up.

ALL USERS: Anytime you mess things up or have problems, press CTRL + Z or X
to break out.  Come back again, select Option 3 to remove previous keys and
press option [1] to restart the process.

WHEN EXECUTING: You will see blue numbers about process, deleted, and updated.
Leave this terminal window and when the process is complete, close it, and
come back to this menu again and select option [2] to ENABLE the plexdrive4
service.  If you forget, you will never see your items mount at
/mnt/plexdrive4 until YOU REBOOT
EOF
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
