####### Agree to Install Plex Server

clear
echo "Dependicies & Docker are Required to be Installed"
echo 
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
    ## yes | apt-get install fail2ban ## install disabled until configured properly
    ## yes | apt-get install ufw ## install disabled until configured properly
    yes | apt-get install python
    yes | apt-get install curl
    yes | apt-get install openssh-server

    # Install Docker
    curl -sSL https://get.docker.com | sh
    curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    docker-compose -f /opt/plexguide/scripts/docker/docker-compose.yml up -d

    # This prevents this installer from running again
    mkdir /var/plexguide 
    touch /var/plexguide/dep.yes
    clear
    echo "Installed Required Dependicies"
    echo
else
    echo No
    clear
    echo "Install Aborted - You Failed to Agree"
    echo
    exit 0;;
    exit
fi
