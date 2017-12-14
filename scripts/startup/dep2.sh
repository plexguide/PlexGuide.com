clear

## FutureNotes: sudo bash -c 'apt-get -y install sleuthkit >/dev/null 2>&1 & disown'

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Installer/Upgrader" --yesno "Do You Agree to Install / Upgrade PlexGuide?" 8 78) then

###################### Install Depdency Programs ###############

    clear

    sudo bash -c 'apt-get -y install update >/dev/null 2>&1 & disown'

    {
        for ((i = 0 ; i <= 100 ; i+=1)); do
            sleep 0.3
            echo $i
        done
    } | whiptail --gauge "[ 1 of 6 ] Updating Your System" 6 50 0

    sudo bash -c 'apt-get -y install curl >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install apt-transport-https >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install ca-certificates >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install nano >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install fuse >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install man-db >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install unzip >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install zip >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install python >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install openssh-server >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install unions-fuse >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install dirmngr >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install software-properties-common >/dev/null 2>&1 & disown'
    sudo bash -c 'apt-get -y install fail2ban >/dev/null 2>&1 & disown'

################### For PlexDrive

  mkdir -p /opt/plexguide-startup 1>/dev/null 2>&1
  chmod 755 /opt/plexguide-startup 1>/dev/null 2>&1

################### For SAB

  mkdir -p /home/plexguide 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/admin 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/incomplete 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/complete/tv 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/complete/movies 1>/dev/null 2>&1
  mkdir -p /home/plexguide/sab/nzb 1>/dev/null 2>&1

#################### For NZBGET

  mkdir -p /home/plexguide/nzbget 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/incomplete 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/completed/tv 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/completed/movies 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/nzb 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/tmp 1>/dev/null 2>&1
  mkdir -p /home/plexguide/nzbget/queue 1>/dev/null 2>&1

########################################################### RClone

mkdir -p /home/plexguide/move 1>/dev/null 2>&1
mkdir -p /home/plexguide/gdrive 1>/dev/null 2>&1
mkdir -p /home/plexguide/unionfs 1>/dev/null 2>&1
mkdir -p /home/plexguide/plexdrive4 1>/dev/null 2>&1
mkdir -p /opt/appdata/plexguide 1>/dev/null 2>&1
mkdir -p /home/plexguide/plexdrive4 1>/dev/null 2>&1

bash /opt/plexguide/scripts/startup/owner.sh 1>/dev/null 2>&1

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.2
        echo $i
    done
} | whiptail --gauge "[ 2 of 6] Installing Dependencies" 6 50 0



#Installing RClone and Service
sudo bash -c '/opt/plexguide/scripts/startup/rclone-preinstall.sh >/dev/null 2>&1 & disown'

#Lets the System Know that Script Ran Once
  touch /var/plexguide/basics.yes 1>/dev/null 2>&1
  touch /var/plexguide/version.5 1>/dev/null 2>&1

#Installing MongoDB for PlexDrive
sudo bash -c '/opt/plexguide/scripts/startup/plexdrive-preinstall.sh >/dev/null 2>&1 & disown'

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.1
        echo $i
    done
} | whiptail --gauge "[ 3 of 6] Pre-Installing RClone & PlexDrive" 6 50 0

# Install Docker and Docker Composer / Checks to see if is installed also
  curl -sSL https://get.docker.com | sh 1>/dev/null 2>&1
  curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 1>/dev/null 2>&1
  chmod +x /usr/local/bin/docker-compose 1>/dev/null 2>&1

# Installs Portainer
  docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d 1>/dev/null 2>&1

  {
      for ((i = 0 ; i <= 100 ; i+=1)); do
          sleep 0.5
          echo $i
      done
  } | whiptail --gauge "[ 4 of 6] Installing Docker" 6 50 0

############################################# Install a Post-Docker Fix ###################### START

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
