#!/bin/bash

echo -n "Do you want to install Docker | PlexPy | Mumimux | Portainer (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
   curl -sSL https://get.docker.com | sh
   sudo apt install docker-compose
   sudo docker-compose -f docker-compose.yml up -d
else
    echo No
    clear
    echo Not Installed - Docker | PlexPy | Mumimux | Portainer
    echo 
fi
