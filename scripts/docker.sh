#!/bin/bash

echo -n "Do you want to install Docker & Portainer (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
   sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   sudo docker-compose -f docker-compose.yml up -d
else
    echo No
    clear
    echo Not Installed - Docker and Portainer
    echo 
fi
