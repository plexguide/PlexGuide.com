# make appdirectory if missing
mkdir /opt/appdata/plexguide 1>/dev/null 2>&1

systemctl stop mine1 1>/dev/null 2>&1
systemctl stop mine2 1>/dev/null 2>&1
systemctl stop mine4 1>/dev/null 2>&1
systemctl stop mine8 1>/dev/null 2>&1
systemctl stop minemax 1>/dev/null 2>&1

systemctl disable mine1 1>/dev/null 2>&1
systemctl disable mine2 1>/dev/null 2>&1
systemctl disable mine4 1>/dev/null 2>&1
systemctl disable mine8 1>/dev/null 2>&1
systemctl disable minemax 1>/dev/null 2>&1


echo All Mining Services Stopped! Reboot to Stop the Script!
echo
read -n 1 -s -r -p "Press any key to continue "