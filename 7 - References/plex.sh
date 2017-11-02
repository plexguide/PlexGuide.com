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
    echo Installed Plex - Use Port 32400 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - Plex Media Server
    echo 
fi
