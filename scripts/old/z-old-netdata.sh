################# Install NetData
echo -n "Do you want to install NetData? Free Server Analytics! (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    cd /tmp
    sudo wget https://github.com/firehol/netdata/archive/v1.8.0.zip 
    rm -r netdata-*
    unzip v1.8.0.zip 
    bash /tmp/netdata-*/kickstart-static64.sh --dont-wait 
    echo Installed NetData
    echo 
    echo To utilize NetData, use Port 19999 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - NetData
    echo 
fi
