####### Agree to Install Plex Server

clear
echo -n "Do you Agree to Install the Awesome Plex Server (y/n)? "
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
    yes | apt-get install fail2ban
    yes | apt-get install ufw
    yes | apt-get install python
    yes | apt-get install software-properties-common    
    clear
    echo Installed Required Programs
    echo 
    echo Installed update, nano, fuse, man-db, screen, unzip, fail2ban, ufw, python, curl
    echo
else
    echo No
    clear
    echo Install Aborted - You failed to agree to the install
    exit
    echo 
fi
