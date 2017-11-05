#!/bin/bash

echo -n "Do you want to install Radarr? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
   apt update
   sudo apt-get install curl
   install libmono-cil-dev curl mediainfo
   wget $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
   tar -xvzf Radarr.develop.*.linux.tar.gz
   mv Radarr /opt 
   mv radarr.service /etc/systemd/system/ 
   systemctl daemon-reload
   systemctl enable radarr.service
   systemctl start radarr.service
   rm -r Radarr.dev*
else
    echo No
    clear
    echo Not Installed - Radarr
fi 
