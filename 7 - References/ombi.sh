#!/bin/bash

echo -n "Do you want to install Ombi v3 (Required Docker Install)? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
   sudo apt-get install libunwind8
   sudo mkdir /opt/Ombi && cd /opt/Ombi
   sudo wget https://ci.appveyor.com/api/buildjobs/78fxna1vxsmei7wn/artifacts/linux.tar.gz
   sudo tar -xzf linux.tar.gz
   sudo chmod 755 Ombi
else
    echo No
    clear
    echo Not Installed Ombi v3
    echo 
fi
