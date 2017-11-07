################# Install Plex
echo -n "Do you want to Rutorrent (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    sudo docker-compose -f rutorrent.yml up -d
    clear
    echo Installed Rutorrent - Use Port XX with IP Address; hostname -I;
    echo
    continue.sh
else
    echo No
    clear
    echo Not Installed - RuTorrent
    echo
fi
