#!/bin/bash

echo -n "Do you want to install Sonarr? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
   apt-get install libmono-cil-dev
   apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
   echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list
   apt-get update
   yes | apt-get install nzbdrone
   mv sonarr.service /etc/systemd/system/
   systemctl daemon-reload
   systemctl enable sonarr.service
   systemctl start sonarr.service
else
    echo No
    clear
    echo Not Installed - Sonarr
fi 
