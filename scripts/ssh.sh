############## Ask About SSH Install
echo -n "Do you want to install SSH on your Server (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    yes | apt-get install openssh-server
    clear
    echo Installed OpenSSH-Server
    echo 
    echo To utilize SSH, use Port 22 with  IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - OpenSSH-Server
    echo 
fi
