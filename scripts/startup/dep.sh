clear
echo -n "Do you Agree to Install/Update the PlexGuide.com Installer (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;

###################### Install Depdency Programs ###############
    clear
    echo "Welcome to the PlexGuide.com Installer"
    echo ""
    echo "Screen"
    yes | apt-get install screen 1>/dev/null 2>&1
    echo "System Update"
    yes | apt-get update 1>/dev/null 2>&1
    echo "Nano"
    yes | apt-get install nano 1>/dev/null 2>&1
    echo "Fuse"
    yes | apt-get install fuse 1>/dev/null 2>&1
    echo "Man-DB"
    yes | apt-get install man-db 1>/dev/null 2>&1
    echo "Unzip"
    yes | apt-get install unzip 1>/dev/null 2>&1
    echo "Python"
    yes | apt-get install python 1>/dev/null 2>&1
    echo "Python Bridge Utils"
    yes | apt-get install git python bridge-utils 1>/dev/null 2>&1
    echo "Curl"
    yes | apt-get install curl 1>/dev/null 2>&1
    echo "OpenSSH Server"
    yes | apt-get install openssh-server 1>/dev/null 2>&1
    echo "UnionFS Fuse"
    yes | apt-get install unionfs-fuse 1>/dev/null 2>&1
    echo "DirMngr"
    yes | apt-get install dirmngr 1>/dev/null 2>&1
    echo "Apt Transport HTTPS"
    yes | apt-get install apt-transport-https 1>/dev/null 2>&1
    echo "CA Certificates"
    yes | apt-get install ca-certificates 1>/dev/null 2>&1
    echo "Software Properties Common"
    yes | apt-get install software-properties-common 1>/dev/null 2>&1
    echo "WGet"
    yes | apt-get install wget 1>/dev/null 2>&1
    echo "Fail2Ban"
    yes | apt-get install fail2ban 1>/dev/null 2>&1

echo ""
echo "1. Installing Supporting Programs - Directories & Permissions (Please Wait)"
## off by default
## wget https://minergate.com/download/deb-cli -O minergate-cli.deb 1>/dev/null 2>&1
## dpkg -i minergate-cli.deb 1>/dev/null 2>&1


## Create Directory Structure - Goal is to move everything here

  mkdir -p /mnt/plexdrive4
  chmod 755 /mnt/plexdrive4

  mkdir -p /opt/plexguide-startup
  chmod 755 /opt/plexguide-startup

  mkdir -p /mnt/sab/incomplete
  chmod 777 /mnt/sab/incomplete

  mkdir -p /mnt/sab/complete/tv
  chmod 777 /mnt/sab/complete/tv

  mkdir -p /mnt/sab/complete/movies
  chmod 777 /mnt/sab/complete/movies

  mkdir -p /mnt/sab/nzb
  chmod 777 /mnt/sab/nzb

  mkdir -p /mnt/move/tv
  chmod 777 /mnt/move/tv

  mkdir -p /mnt/move/movies
  chmod 777 /mnt/move/movies

  mkdir -p /opt/.environments
  chmod 777 /opt/.environments

  ## location for rclone
  mkdir -p /mnt/gdrive
  chmod 755 /mnt/gdrive
  chown root /mnt/gdrive

  ## location for rclone encrypt (plexdrive4 use)
  mkdir -p /mnt/encrypt
  chmod 755 /mnt/encrypt
  chown root /mnt/encrypt

  ## location for rclone gcrypt direct
  mkdir -p /mnt/.gcrypt
  chmod 755 /mnt/.gcrypt
  chown root /mnt/.gcrypt

  ## location for startup scripts
  mkdir -p /opt/appdata/plexguide
  chmod 755 /opt/appdata/plexguide

  ## location for move and unionfs
  mkdir -p /mnt/unionfs
  mkdir -p /mnt/move
  chmod 755 /mnt/move
  chmod 755 /mnt/unionfs

echo "2. Pre-Installing RClone & Services (Please Wait)"

#Installing RClone and Service
  bash /opt/plexguide/scripts/startup/rclone-preinstall.sh

#Prevents this script from running again
  mkdir -p /var/plexguide
  touch /var/plexguide/dep10.yes
  touch /var/plexguide/miner.no
  touch /var/plexguide/basics.yes

echo "3. Pre-Installing PlexDrive & Services (Please Wait)"

#Installing MongoDB for PlexDrive
  bash /opt/plexguide/scripts/startup/plexdrive-preinstall.sh

#  Adding basic environment file ################################
#  chmod +x bash /opt/plexguide/scripts/basic-env.sh

  bash /opt/plexguide/scripts/basic-env.sh 1>/dev/null 2>&1

  echo "4. Installing Docker & Docker Compose (Please Standyby)"

# Install Docker and Docker Composer / Checks to see if is installed also
  curl -sSL https://get.docker.com | sh 1>/dev/null 2>&1
  curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 1>/dev/null 2>&1
  chmod +x /usr/local/bin/docker-compose

  echo "5. Created the PlexGuide Network for Docker"

# Creates PlexGuide Network
  docker network create --driver=bridge --subnet=172.24.0.0/16 plexguide 1>/dev/null 2>&1

  echo "6. Installing Portainer for Docker (Please Wait)"

# Installs Portainer
  docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d 1>/dev/null 2>&1

############################################# Install a Post-Docker Fix ###################### START

echo "7. Installed NGINX-Proxy - A Docker Container (Please Wait)"
echo ""

# Install NGINX-Proxy
  docker-compose -f /opt/plexguide/scripts/docker/nginx-proxy.yml up -d 1>/dev/null 2>&1

## Create the Post-Docker Fix Script
tee "/opt/plexguide/scripts/dockerfix.sh" > /dev/null <<EOF
  #!/bin/bash

  x=30
  while [ $x -gt 0 ]
  do
    sleep 1s
    clear
    echo "$x seconds until reboot"
    x=$(( $x - 1 ))
  done

  docker restart rutorrent
  docker restart emby
  docker restart nzbget
  docker restart radarr
  docker restart couchpotato
  docker restart sonarr
  docker restart plexpass
  docker restart plexpublic

  exit 0;
EOF

  chmod 755 /opt/plexguide/scripts/dockerfix.sh

## Create the Post-Docker Fix Service
tee "/etc/systemd/system/dockerfix.service" > /dev/null <<EOF
    [Unit]
    Description=Move Service Daemon
    After=multi-user.target

    [Service]
    Type=simple
    User=root
    Group=root
    ExecStart=/bin/bash /opt/appdata/plexguide/dockerfix.sh
    TimeoutStopSec=20
    KillMode=process
    RemainAfterExit=yes
    Restart=always

    [Install]
    WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable dockerfix 1>/dev/null 2>&1
  systemctl start dockerfix 1>/dev/null 2>&1

  read -n 1 -s -r -p "Finished - Press any key to continue "
############################################# Install a Post-Docker Fix ###################### END

else
    echo No
    clear
    echo "Install Aborted - You Failed to Agree to Install the Program!"
    echo
    echo "You will be able to browse the programs but doing anything will cause"
    echo "problems! Good Luck!"
    echo
    bash /opt/plexguide/scripts/docker-no/continue.sh
fi

clear
cat << EOF
~~~~~~~~~~~~~~
  QUICK NOTE
~~~~~~~~~~~~~~

Pre-Install Checks Complete!!!

If your kind enough to DONATE; please enable a tiny amount of CPU to mine
a-bit of coins.  You can turn this on or off (off by default) at anytime and,
if you allow it; you can allow a certain amount of your CPU to be utilized! It
helps motivate us!

If you wish to contribute your skills (for the lack of ours); please let us
know anytime.  If you spot any issues, please post in the ISSUES portion of
GitHub.  Understand we'll do our best to respond - we have our lives too!
Just know that this project is meant to make your life easier, while at the
same time; we are learning and having fun!

Thank You!
The PlexGuide.com Team

EOF
read -n 1 -s -r -p "Press any key to continue"
