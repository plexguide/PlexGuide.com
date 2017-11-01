################# Install SABNZBD

echo -n "Do you want to SABNZBD? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    mkdir /mnt/sab
    mkdir /mnt/sab/nzb
    mkdir /mnt/sab/complete
    mkdir /mnt/sab/complete/tv
    mkdir /mnt/sab/complete/movies
    mkdir /mnt/sab/incomplete
    yes | apt install sabnzbdplus
    clear
    add-apt-repository ppa:jcfp/nobetas
    yes | apt update
    yes | apt install sabnzbdplus
    clear
    sudo add-apt-repository ppa:jcfp/sab-addons
    yes | apt-get update
    yes | apt-get install par2-tbb
    yes | apt-get install par2-mt
    yes | apt-get install python-sabyenc
    echo Installed SABNZBD
    echo 
    echo To utilize SABNZBD, use Port 8090 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - SABNZBD
    echo 
fi

## Missing to install service
