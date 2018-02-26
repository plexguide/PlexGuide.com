#!/bin/bash

clear

################# Install Plex
echo "READ >> REBOOT PLEXDRIVE AFTER IT COMPLETES!!! <<< READ"
echo ""
echo -n "Do you want to Install PlexDrive? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;

clear

## Enables the PlexDrive Service
#systemctl daemon-reload
#systemctl enable plexdrive.service

    sudo ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plexdrive
    #cd /tmp
    #wget https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64
    mv /tmp/plexdrive-linux-amd64 plexdrive
    mv plexdrive /usr/bin/
    cd /usr/bin/
    chown root:root /usr/bin/plexdrive
    chmod 755 /usr/bin/plexdrive
    systemctl daemon-reload
    systemctl enable plexdrive
    plexdrive mount --uid=1000 --gid=1000 -v 3 --refresh-interval=1m  --fuse-options=allow_other,read_only,allow_non_empty_mount --config=/root/.plexdrive  /mnt/plexdrive
    read -n 1 -s -r -p "Press any key to continue "
    clear
    ## USER Will Have To Reboot Once PlexDrive Is Finished!
else
    echo No
    clear
    echo Not Installed - PlexDrive
    echo
fi
