#!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

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
~~~~~~~~~~~~~~~~~~
 Mining Donations
~~~~~~~~~~~~~~~~~~
Have a tiny processing power to spare? If your Plex Server is never at 100%
usage, donating a little bit goes a long way for us.  Basically, your allowing
us to use some processing power to mine coins.  You can disable, enable, and
limit how processing power is used! If you have NETAPP installed, you can visit
http://yourip:19999 to see how it impacts your performance!

EOF

cat << EOF

1. Allow Mining of 2 Threads    :  1 Cores
2. Allow Mining of 4 Threads    :  2 Cores
3. Use My Entire Processor!     :  Really Sure? Only if your not using it!
4. Turn of All Mining Operations:  TURN IT OFF!
. Exit

EOF


read_options(){
	local choice
	read -p "Enter choice [ 1 - 7 ] " choice
	case $choice in
1)
clear

## Allow 2 Threads / 1 Core Normally

# Disable Any Other Miners if they Were allowed
systemctl stop mine2
systemctl stop minemax

systemctl disable mine2
systemctl disable minemax

tee "/etc/systemd/system/mine1.service" > /dev/null <<EOF
[Unit]
Description=MINE Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/plexguide-startup/mine1.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

tee "/opt/plexguide-startup/mine1.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
minergate-cli -user user@dunn.cloud -xmr 2
EOF

chmod 755 /opt/plexguide-startup/mine1.sh
systemctl daemon-reload
systemctl enable mine1
systemctl start mine1
echo
echo "Thank You So Much!"
echo
read -n 1 -s -r -p "Press any key to continue"
;;

2)
clear

## Allow 4 Threads / Normally 2 Cores

# Disable Any Other Miners if they Were allowed
systemctl stop mine1
systemctl stop minemax

systemctl disable mine1
systemctl disable minemax

tee "/etc/systemd/system/mine2.service" > /dev/null <<EOF
[Unit]
Description=MINE Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/plexguide-startup/mine2.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

tee "/opt/plexguide-startup/mine2.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
minergate-cli -user user@dunn.cloud -xmr 4
EOF

chmod 755 /opt/plexguide-startup/mine2.sh
systemctl daemon-reload
systemctl enable mine1
systemctl start mine1
echo
echo "Thank You So Much!"
echo
read -n 1 -s -r -p "Press any key to continue"
;;

3)
clear

## Allow 4 Threads / Normally 2 Cores

# Disable Any Other Miners if they Were allowed
systemctl stop mine1
systemctl stop mine2

systemctl disable mine1
systemctl disable mine2

tee "/etc/systemd/system/minemax.service" > /dev/null <<EOF
[Unit]
Description=MINE Service Daemon
After=multi-user.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /opt/plexguide-startup/minemax.sh
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes
Restart=always

[Install]
WantedBy=multi-user.target
EOF

tee "/opt/plexguide-startup/minemax.sh" > /dev/null <<EOF
#!/bin/bash
sleep 30
minergate-cli -user user@dunn.cloud -xmr 32
EOF

chmod 755 /opt/plexguide-startup/minemax.sh
systemctl daemon-reload
systemctl enable minemax
systemctl start minemax
echo
echo "Thank You So Much!"
echo
read -n 1 -s -r -p "Press any key to continue"
;;

4)
clear

## Stop and Disable All Miners

# Disable Any Other Miners if they Were allowed
systemctl stop mine1
systemctl stop mine2
systemctl stop minemax

systemctl disable mine1
systemctl disable mine2
systemctl disable minemax

clear

echo "All Miners are Off Per Your Request!"
echo
read -n 1 -s -r -p "Press any key to continue"
;;
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
