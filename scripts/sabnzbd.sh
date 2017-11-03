## Missing variable quesiton for IP

################# Install SABNZBD
clear
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

    ## Installing the SABNZBD Service
    cd /etc/systemd/system/
    sudo systemctl stop sabnzbd
    rm -r sabnzbd.service
    touch sabnzbd.service
    echo [Unit] >> sabnzbd.service
    echo Description=SABnzbd Usenet Client >> sabnzbd.service
    echo After=multi-user.target >> sabnzbd.service
    echo >> sabnzbd.service
    echo [Service] >> sabnzbd.service
    echo Type=simple  >> sabnzbd.service
    echo User=root >> sabnzbd.service
    echo Group=root >> sabnzbd.service
    echo >> sabnzbd.service
    echo ExecStart=/usr/bin/python -OO /usr/bin/sabnzbdplus --server 127.0.0.1:8090 --browser 0 \& >> sabnzbd.service
    echo ExecStop=/usr/bin/pkill sabnzbdplus >> sabnzbd.service
    echo RemainAfterExit=yes >> sabnzbd.service
    echo SyslogIdentifier=SABnzbd Usenet Client >> sabnzbd.service
    echo >> sabnzbd.service
    echo [Install]  >> sabnzbd.service
    echo WantedBy=multi-user.target >> sabnzbd.service
    
    ## Enabling and Starting the SABNZBD.service
    systemctl daemon-reload
    sudo systemctl enable sabnzbd.service
    sudo systemctl start sabnzbd.service

    clear
    echo Installed SABNZBD - To utilize SABNZBD, goto Port 8090 with IP Address; hostname -I;
    echo
else
    echo No
    clear
    echo Not Installed - SABNZBD
    echo 
fi
