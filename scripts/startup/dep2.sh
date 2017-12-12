clear

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "Example Dialog" --yesno "This is an example of a yes/no box." 8 78) then

echo -n "Do you consent to allow PlexGuide to Install/Upgrade (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;

###################### Install Depdency Programs ###############

    clear
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
    echo "Zip"
    yes | apt-get install zip 1>/dev/null 2>&1
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

## Create Directory Structure - Goal is to move everything here

################### chown

  chown -R plexguide:1000 /opt/plexguide/scripts/docker-no/*

################### For PlexDrive

  mkdir -p /opt/plexguide-startup
  chmod 755 /opt/plexguide-startup

################### For SAB

  mkdir -p /home/plexguide
  mkdir -p /home/plexguide/sab/admin
  mkdir -p /home/plexguide/sab/incomplete
  mkdir -p /home/plexguide/sab/complete/tv
  mkdir -p /home/plexguide/sab/complete/movies
  mkdir -p /home/plexguide/sab/nzb

#################### For NZBGET

  mkdir -p /home/plexguide/nzbget
  mkdir -p /home/plexguide/nzbget/incomplete
  mkdir -p /home/plexguide/nzbget/completed/tv
  mkdir -p /home/plexguide/nzbget/completed/movies
  mkdir -p /home/plexguide/nzbget/nzb
  mkdir -p /home/plexguide/nzbget/tmp
  mkdir -p /home/plexguide/nzbget/queue

########################################################### RClone

mkdir -p /home/plexguide/move
mkdir -p /home/plexguide/gdrive
mkdir -p /home/plexguide/unionfs
mkdir -p /home/plexguide/plexdrive4
mkdir -p /opt/appdata/plexguide
mkdir -p /home/plexguide/plexdrive4

#file="/var/plexguide/chown.yes"
#if [ -e "$file" ]
#then
#    mkdir -p /home/plexguide/move
#else
#    chown -R plexguide:1000 /home/plexguide/
#    touch /var/plexguide/chown.yes
#fi
bash /opt/plexguide/scripts/startup/owner.sh
######################################################### For RCLONE

echo "2. Pre-Installing RClone & Services (Please Wait)"

#Installing RClone and Service
  bash /opt/plexguide/scripts/startup/rclone-preinstall.sh

#Lets the System Know that Script Ran Once
  touch /var/plexguide/basics.yes
  touch /var/plexguide/version.5

echo "3. Pre-Installing PlexDrive & Services (Please Wait)"

#Installing MongoDB for PlexDrive
  bash /opt/plexguide/scripts/startup/plexdrive-preinstall.sh 1>/dev/null 2>&1

#  Adding basic environment file ################################
#  chmod +x bash /opt/plexguide/scripts/basic-env.sh

#  bash /opt/plexguide/scripts/test/basic-env.sh 1>/dev/null 2>&1

  echo "4. Installing Docker & Docker Compose (Please Standby)"

# Install Docker and Docker Composer / Checks to see if is installed also
  curl -sSL https://get.docker.com | sh 1>/dev/null 2>&1
  curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 1>/dev/null 2>&1
  chmod +x /usr/local/bin/docker-compose 1>/dev/null 2>&1

  echo "5. Created the PlexGuide Network for Docker"

# Creates PlexGuide Network
# docker network create --driver=bridge --subnet=172.24.0.0/16 plexguide 1>/dev/null 2>&1

  echo "6. Installing Portainer for Docker (Please Wait)"

# Installs Portainer
  docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d 1>/dev/null 2>&1

############################################# Install a Post-Docker Fix ###################### START

    echo "7. Removing NGINX-Proxy Container if it Exists (Please Wait)"
    docker stop nginx-proxy 1>/dev/null 2>&1
    docker rm nginx-proxy 1>/dev/null 2>&1

tee "/opt/plexguide/scripts/dockerfix.sh" > /dev/null <<EOF
  #!/bin/bash
  sleep 30
  while true
  do
    docker restart emby 1>/dev/null 2>&1
    docker restart nzbget 1>/dev/null 2>&1
    docker restart radarr 1>/dev/null 2>&1
    docker restart sonarr 1>/dev/null 2>&1
    docker restart plexpass 1>/dev/null 2>&1
    docker restart plexpublic 1>/dev/null 2>&1
    docker restart sabnzbd 1>/dev/null 2>&1
  sleep 6000000000000000000000000
  done
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

  echo "8. Rebooting Any Running Containers - Assist UnionFS (Please Wait)"

  docker restart emby 1>/dev/null 2>&1
  docker restart nzbget 1>/dev/null 2>&1
  docker restart radarr 1>/dev/null 2>&1
  docker restart sonarr 1>/dev/null 2>&1
  docker restart plexpass 1>/dev/null 2>&1
  docker restart plexpublic 1>/dev/null 2>&1
  docker restart sabnzbd 1>/dev/null 2>&1

  echo ""
  read -n 1 -s -r -p "Finished - Press any key to continue "
############################################# Install a Post-Docker Fix ###################### END

else
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

Pre-Install / Re-Install Complete!

>>> WARNING WARNING - RUN as USER: plexguide <<<

<Donation Info> If your enjoying the programming, donating coin or enabling
mininig helps up go a long way.  If you enable mining, you can choose how
many cores  are allocated. Any amount would be helpful! <Donation Info>

If you wish to contribute your skills (for the lack of ours); please let us
know anytime.  If you spot any issues, please post in the ISSUES portion of
GitHub.  Understand we'll do our best to respond - we have our lives too!
Just know that this project is meant to make your life easier, while at the
same time; we are learning and having fun!

Thank You!
The PlexGuide.com Team

EOF
read -n 1 -s -r -p "Press any key to continue"
