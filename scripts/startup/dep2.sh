clear

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Installer/Upgrader" --yesno "Do You Agree to Install / Upgrade PlexGuide?" 8 78) then

###################### Install Depdency Programs ###############

    clear
    yes | apt-get install screen 1>/dev/null 2>&1
    yes | apt-get update 1>/dev/null 2>&1
    yes | apt-get install nano 1>/dev/null 2>&1
    yes | apt-get install fuse 1>/dev/null 2>&1
    yes | apt-get install man-db 1>/dev/null 2>&1
    yes | apt-get install unzip 1>/dev/null 2>&1
    yes | apt-get install zip 1>/dev/null 2>&1
    yes | apt-get install python 1>/dev/null 2>&1
    yes | apt-get install git python bridge-utils 1>/dev/null 2>&1
    yes | apt-get install curl 1>/dev/null 2>&1
    yes | apt-get install openssh-server 1>/dev/null 2>&1
    yes | apt-get install unionfs-fuse 1>/dev/null 2>&1
    yes | apt-get install dirmngr 1>/dev/null 2>&1
    yes | apt-get install apt-transport-https 1>/dev/null 2>&1
    yes | apt-get install ca-certificates 1>/dev/null 2>&1
    yes | apt-get install software-properties-common 1>/dev/null 2>&1
    yes | apt-get install wget 1>/dev/null 2>&1
    yes | apt-get install fail2ban 1>/dev/null 2>&1

    {
        for ((i = 0 ; i <= 100 ; i+=1)); do
            sleep 0.3
            echo $i
        done
    } | whiptail --gauge "[ 1 of 5 ] Updating Your System" 6 50 0

## Create Directory Structure - Goal is to move everything here

################### chown

  chown -R 1000:1000 /opt/plexguide/scripts/docker-no/* 1>/dev/null 2>&1

################### For PlexDrive

  mkdir -p /opt/plexguide-startup 1>/dev/null 2>&1
  chmod 755 /opt/plexguide-startup 1>/dev/null 2>&1

################### For SAB

  mkdir -p /mnt
  mkdir -p /mnt/sab/admin
  mkdir -p /mnt/sab/incomplete
  mkdir -p /mnt/sab/complete/tv
  mkdir -p /mnt/sab/complete/movies
  mkdir -p /mnt/sab/nzb

#################### For NZBGET

  mkdir -p /mnt/nzbget
  mkdir -p /mnt/nzbget/incomplete
  mkdir -p /mnt/nzbget/completed/tv
  mkdir -p /mnt/nzbget/completed/movies
  mkdir -p /mnt/nzbget/nzb
  mkdir -p /mnt/nzbget/tmp
  mkdir -p /mnt/nzbget/queue

########################################################### RClone

mkdir -p /mnt/move
mkdir -p /mnt/gdrive
mkdir -p /mnt/unionfs
mkdir -p /mnt/plexdrive4
mkdir -p /opt/appdata/plexguide
mkdir -p /mnt/plexdrive4

bash /opt/plexguide/scripts/startup/owner.sh 1>/dev/null 2>&1

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.2
        echo $i
    done
} | whiptail --gauge "[ 2 of 5 ] Installing Dependencies" 6 50 0

######################################################### For RCLONE

#Installing RClone and Service
  bash /opt/plexguide/scripts/startup/rclone-preinstall.sh 1>/dev/null 2>&1

#Lets the System Know that Script Ran Once
  touch /var/plexguide/basics.yes 1>/dev/null 2>&1
  touch /var/plexguide/version.5 1>/dev/null 2>&1

#Installing MongoDB for PlexDrive
  bash /opt/plexguide/scripts/startup/plexdrive-preinstall.sh 1>/dev/null 2>&1

#  Adding basic environment file ################################
#  chmod +x bash /opt/plexguide/scripts/basic-env.sh

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.1
        echo $i
    done
} | whiptail --gauge "[ 3 of 5 ] Pre-Installing RClone & PlexDrive" 6 50 0

#  bash /opt/plexguide/scripts/test/basic-env.sh 1>/dev/null 2>&1

# Install Docker and Docker Composer / Checks to see if is installed also
  curl -sSL https://get.docker.com | sh 1>/dev/null 2>&1
  curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 1>/dev/null 2>&1
  chmod +x /usr/local/bin/docker-compose 1>/dev/null 2>&1

# Installs Portainer
  docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d 1>/dev/null 2>&1

  {
      for ((i = 0 ; i <= 100 ; i+=1)); do
          sleep 0.4
          echo $i
      done
  } | whiptail --gauge "[ 4 of 5 ] Installing Docker" 6 50 0

############################################# Install a Post-Docker Fix ###################### START

    echo "6. Finishing Up"

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
    ExecStart=/bin/bash /opt/plexguide/scripts/dockerfix.sh
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

  echo "7. Rebooting Any Running Containers - Assist UnionFS (Please Wait)"

  docker restart emby 1>/dev/null 2>&1
  docker restart nzbget 1>/dev/null 2>&1
  docker restart radarr 1>/dev/null 2>&1
  docker restart sonarr 1>/dev/null 2>&1
  docker restart plexpass 1>/dev/null 2>&1
  docker restart plexpublic 1>/dev/null 2>&1
  docker restart sabnzbd 1>/dev/null 2>&1

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep .1
        echo $i
    done
} | whiptail --gauge "[ 5 of 5 ] Finishing PlexGuide Install" 6 50 0

  file="/var/plexguide/donation.yes"
  if [ -e "$file" ]
    then
        echo "" 1>/dev/null 2>&1
    else
        echo "8. Donation Information - (Please Wait)"
        echo ""
        bash /opt/plexguide/scripts/menus/donate-menu.sh
    fi


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