
clear

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "PlexGuide Installer/Upgrader" --yesno "Do You Agree to Install / Upgrade PlexGuide?" 8 78) then

###################### Install Depdency Programs ##########################################

    yes | apt-get update 1>/dev/null 2>&1 & disown

    {
        for ((i = 0 ; i <= 100 ; i+=1)); do
            sleep 0.2
            echo $i
        done
    } | whiptail --gauge "[ 1 of 5 ] Updating Your System" 6 50 0

    yes | apt-get install curl 1>/dev/null 2>&1 & disown
    yes | apt-get install apt-transport-https 1>/dev/null 2>&1 & disown
    yes | apt-get install nano 1>/dev/null 2>&1 & disown
    yes | apt-get install fuse 1>/dev/null 2>&1 & disown
    yes | apt-get install man-db 1>/dev/null 2>&1 & disown
    yes | apt-get install unzip 1>/dev/null 2>&1 & disown
    yes | apt-get install zip 1>/dev/null 2>&1 & disown
    yes | apt-get install python 1>/dev/null 2>&1 & disown
    yes | apt-get install openssh-server 1>/dev/null 2>&1 & disown
    yes | apt-get install unions-fuse 1>/dev/null 2>&1 & disown
    yes | apt-get install dirmngr 1>/dev/null 2>&1 & disown
    yes | apt-get install software-properties-common 1>/dev/null 2>&1 & disown
    yes | apt-get install fail2ban 1>/dev/null 2>&1 & disown

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.2
        echo $i
    done
} | whiptail --gauge "[ 2 of 5 ] Installing Dependencies" 6 50 0

###################### Rre-Install ##########################################
bash '/opt/plexguide/scripts/startup/directories.sh' 1>/dev/null 2>&1 & disown

#Installing RClone and Service
bash '/opt/plexguide/scripts/startup/rclone-preinstall.sh' 1>/dev/null 2>&1 & disown

#Lets the System Know that Script Ran Once

touch '/var/plexguide/basics.yes' 1>/dev/null 2>&1 & disown
touch '/var/plexguide/version.5' 1>/dev/null 2>&1 & disown

#Installing MongoDB for PlexDrive
bash '/opt/plexguide/scripts/startup/plexdrive-preinstall.sh' 1>/dev/null 2>&1 & disown

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.1
        echo $i
    done
} | whiptail --gauge "[ 3 of 5 ] Pre-Installing RClone & PlexDrive" 6 50 0

###################### Install Docker ##########################################
  curl -sSL https://get.docker.com | sh 1>/dev/null 2>&1 & disown
  curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 1>/dev/null 2>&1 & disown
  chmod +x /usr/local/bin/docker-compose 1>/dev/null 2>&1 & disown

# Installs Portainer
  docker-compose -f /opt/plexguide/scripts/docker/portainer.yml up -d 1>/dev/null 2>&1 & disown

  {
      for ((i = 0 ; i <= 100 ; i+=1)); do
          sleep 0.4
          echo $i
      done
  } | whiptail --gauge "[ 4 of 5 ] Installing Docker" 6 50 0

###################### Finishing Up ##########################################
bash '/opt/plexguide/scripts/startup/postdocker.sh' 1>/dev/null 2>&1 & disown
bash '/opt/plexguide/scripts/startup/owner.sh' 1>/dev/null 2>&1 & disown

{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0
        .05
        echo $i
    done
} | whiptail --gauge "[ 5 of 5 ] Finishing PlexGuide Install" 6 50 0

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
