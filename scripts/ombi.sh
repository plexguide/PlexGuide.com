################# Install Plex
echo -n "Do you want to Ombiv3 (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    sudo docker-compose -f ombi.yml up -d
    clear
    echo Installed Ombi - Use Port 3579 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - Ombi
    echo 
fi