################# Install Plex
echo -n "Do you want to Install SABNZBD (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    sudo docker-compose -f /opt/plexguide/scripts/docker/sabnzbd.yml up -d
    clear
    echo Installed SABNZBD - Use Port 8090 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - SABNZBD
    echo 
fi