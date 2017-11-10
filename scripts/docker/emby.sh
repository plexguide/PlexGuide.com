################# Install Plex
echo -n "Do you want to Emby (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    sudo docker-compose -f /opt/plexguide/scripts/docker/emby.yml up -d
    clear
    echo Installed Emby - Use Port 8096 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - Emby
    echo 
fi