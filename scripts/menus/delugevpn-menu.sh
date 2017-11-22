#!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

# Get local Username
localuname=`id -u -n`
# Get PUID
PUID=`id -u $localuname`
# Get GUID
PGID=`id -g $localuname`
# Get Hostname
thishost=`hostname`
# Get IP Address
locip=`hostname -I | awk '{print $1}'`
# Get Time Zone
time_zone=`cat /etc/timezone`

# CIDR - this assumes a 255.255.255.0 netmask - If your config is different use the custom CIDR line
lannet=`hostname -I | awk '{print $1}' | sed 's/\.[0-9]*$/.0\/24/'`
# Custom CIDR (comment out the line above if using this)
# Uncomment the line below and enter your CIDR info so the line looks like: lannet=xxx.xxx.xxx.0/24
#lannet=
echo "LOCALUSER=$localuname" >> /opt/plexguide/scripts/docker/.deluge-env
echo "HOSTNAME=$thishost" >> /opt/plexguide/scripts/docker/.deluge-env
echo "IP_ADDRESS=$locip" >> /opt/plexguide/scripts/docker/.deluge-env
echo "PUID=$PUID" >> /opt/plexguide/scripts/docker/.deluge-env
echo "PGID=$PGID" >> /opt/plexguide/scripts/docker/.deluge-env
#echo "PWD=$PWD" >> /opt/plexguide/scripts/docker/.deluge-env
echo "LAN_NETWORK=$lannet" >> /opt/plexguide/scripts/docker/.deluge-env
#echo "CIDR_ADDRESS=$lannet" >> /opt/plexguide/scripts/docker/.deluge-env
echo "TZ=$time_zone" >> /opt/plexguide/scripts/docker/.deluge-env

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
	echo "one() called"
        pause
}

# do something in two()
two(){
	echo "two() called"
        pause
}

# function to display menus
show_menus() {

clear
cat << EOF
~~~~~~~~~~~~~~~~~~~~~~~~
DELUGEVPN
~~~~~~~~~~~~~~~~~~~~~~~~

Note, make sure that you have an account with PIA before installing otherwise
it won't work! Please visit https://www.privateinternetaccess.com to join.

1. TESTING // PIA VPN details
2. Install DelugeVPN
3. Exit

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 3 ] " choice
	case $choice in
    1)
    clear
    echo "Visit https://www.privateinternetaccess.com for account details. "
    echo
    read -p "What is your PIA Username?: " pia_username
    echo "VPN_USER=$pia_username" >> /opt/plexguide/scripts/docker/.deluge-env
    echo
    read -s -p "What is your PIA Password? (Will not be echoed): " pia_password
    echo "VPN_PASS=$pia_password" >> /opt/plexguide/scripts/docker/.deluge-env
    echo
    read -p "What Remote server do you want to use? (e.g france): " vpn_remote_choice
    echo "VPN_REMOTE=$vpn_remote_choice.privateinternetaccess.com" >> /opt/plexguide/scripts/docker/.deluge-env
    echo
    clear
    touch /var/plexguide/pia-vpn-set.yes
    echo "Your PIA info has been Installed for the Easy Setup!"
    echo
    read -n 1 -s -r -p "Press any key to continue "
    ;;
		2)
      file="/var/plexguide/pia-vpn-set.yes"
      if [ -e "$file" ]
      then
        docker rm delugevpn
        clear
        echo ymlprogram delugevpn > /opt/plexguide/tmp.txt
        echo ymldisplay DelugeVPN >> /opt/plexguide/tmp.txt
        echo ymlport 8112 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/openvpn-setup.sh
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        clear
      else
        echo
        echo "Are you Special? You need to setup your PIA account details first!!!"
        echo
        read -n 1 -s -r -p "Press any key to continue "
      fi
      ;;
    3)
      exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do

	show_menus
	read_options
done
