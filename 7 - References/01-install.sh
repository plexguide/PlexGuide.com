################### Install Required Programs

echo -n "Do you agree to install "The Awesome Plex Server (y/n)? "
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
    yes | apt-get install software-properties-common    
    clear
    echo Installed Required Programs
    echo 
    echo Installed update, nano, fuse, man-db, screen, unzip, python, curl
    echo
else
    echo No
    clear
    echo Install Aborted! You failed to agree to the install
    exit
    echo 
fi

############## Ask About SSH Install

echo -n "Do you want to install SSH on your Server (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    yes | apt-get install openssh-server
    clear
    echo Installed OpenSSH-Server
    echo 
    echo To utilize SSH, use Port 22 with  IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - OpenSSH-Server
    echo 
fi

################# Install NetData

echo -n "Do you want to install NetData? Free Server Analytics! (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    cd /tmp
    sudo wget https://github.com/firehol/netdata/archive/v1.8.0.zip 
    rm -r netdata-*
    unzip v1.8.0.zip 
    bash /tmp/netdata-*/kickstart-static64.sh --dont-wait 
    echo Installed NetData
    echo 
    echo To utilize NetData, use Port 19999 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - NetData
    echo 
fi

################# Install Plex

echo -n "Do you want to Plex? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    echo deb https://downloads.plex.tv/repo/deb ./public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
    curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
    yes | apt-get update    
    yes | apt-get install plexmediaserver
    echo Installed NetData
    echo 
    echo To utilize NetData, use Port 19999 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - Plex Media Server
    echo 
fi
