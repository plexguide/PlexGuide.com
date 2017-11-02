#!/bin/bash

echo -n "Do you want to install Ombi v3 (Required Docker Install)? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
   sudo docker-compose -f ombi.yml up -d
else
    echo No
    clear
    echo Not Installed Ombi v3
    echo 
fi
