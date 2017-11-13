clear
echo -n "Do you Agree to Install the PlexGuide.com Installer (y/n)?"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    yes | apt-get update
    yes | apt-get install nano
    yes | apt-get install fuse
    yes | apt-get install man-db
    yes | apt-get install screen
    yes | apt-get install unzip
    yes | apt-get install python
    yes | apt-get install curl
    yes | apt-get install openssh-server
    yes | apt-get install unionfs-fuse

    #important folders
    mkdir /mnt/plexdrive4
    chmod 755 /mnt/plexdrive4

    mkdir /mnt/sab
    chmod 777 /mnt/sab

    mkdir /mnt/sab/incomplete
    chmod 777 /mnt/sab/incomplete

    mkdir /mnt/sab/complete
    chmod 777 /mnt/sab/complete

    mkdir /mnt/sab/complete/tv
    chmod 777 /mnt/sab/complete/tv

    mkdir /mnt/sab/complete/movies
    chmod 777 /mnt/sab/complete/movies

    mkdir /mnt/sab/nzb
    chmod 777 /mnt/sab/nzb

    #Prevents this script from running again
    mkdir /var/plexguide
    touch /var/plexguide/dep3.yes

    #Install Docker
    curl -sSL https://get.docker.com | sh
    curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    docker-compose -f /opt/plexguide/scripts/docker/docker-compose.yml up -d

########################################################### Work around for Plex Docker ### Start

## Create the PlexFix Script
tee "/opt/plexfix.sh" > /dev/null <<EOF

#!/bin/bash

if [ -e "/var/plexguide/plex.pass" ]
then
  docker stop plexpass
  docker rm plexpass
  touch /var/plexguide/plex.pass
  docker-compose -f /opt/plexguide/scripts/docker/plexpass.yml up -d
else
  echo "popcorn"
fi

EOF
chmod 755 /opt/rclone-move.sh

## Create the PlexFix Script
tee "/etc/systemd/system/plexfix.service" > /dev/null <<EOF
[Unit]
Description=Move Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/plexfix.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl systemctl enable plexfix
systemctl systemctl start plexfix

########################################################### Work around for Plex Docker ### Start

else
    echo No
    clear
    echo "Install Aborted - You Failed to Agree"
    echo
fi
