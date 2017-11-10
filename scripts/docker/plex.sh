################# Install Plex
echo -n "Do you want to Plex (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    sudo docker-compose -f plex.yml up -d
    clear
    echo Installed Plex - Use Port 32400 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - Plex
    echo 
fi