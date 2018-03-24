 #!/bin/bash

clear

################# init message

if (whiptail --title "Network Speed" --yesno "Is Your Server On at least a 500mbit line?" 8 56) then

    whiptail --title "Network Speed - Yes" --msgbox "These tweaks work best in high-latency, low packet loss enviroments (ie: server is located in America, but you are streaming from Austrailia)." 9 66
else
    whiptail --title "Network Speed - No" --msgbox "We reccomend only enabling BBR on slower networks." 9 66
fi

while [ 1 ]
do
CHOICE=$(
whiptail --title "Kernel Profiles" --menu "See Wiki For Info" 12 38 5 \
    "1)" "Enable BBR TCP Congestion Control"  \
    "2)" "Klaver Kernel Tweaks + BBR"  \
    "3)" "tj007s13 Kernel Tweaks + BBR"  \
    "4)" "Update to Latest Generic Kernel"  \
    "5)" "Install Xanmod Kernel"  \
    "6)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    # check if bbr is avail
    skip-tags='tj,klaver'
    if cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr -q; then \
      ansible-playbook /opt/plexguide/ansible/roles/processor/processor.yml --tags network_tuning --skip-tags $skip_tags
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      bash /opt/plexguide/scripts/menus/processor/reboot.sh
    else
      whiptail --title "Unsupported Kernel" --msgbox "Your Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 9 66
      bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
    ;;

    "2)")
    clear
    # check if bbr is avail
    skip-tags='tj'
    if cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr -q; then \
      ansible-playbook /opt/plexguide/ansible/roles/processor/processor.yml --tags network_tuning --skip-tags $skip_tags
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      bash /opt/plexguide/scripts/menus/processor/reboot.sh
    else
      whiptail --title "Unsupported Kernel" --msgbox "Your Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 9 66
      bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
    ;;

    "3)")
    clear
    # check if bbr is avail
    skip-tags='klaver'
    if cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr -q; then \
      ansible-playbook /opt/plexguide/ansible/roles/processor/processor.yml --tags network_tuning --skip-tags $skip_tags
      echo ""
      read -n 1 -s -r -p "Press any key to continue "
      bash /opt/plexguide/scripts/menus/processor/reboot.sh
    else
      whiptail --title "Unsupported Kernel" --msgbox "Your Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 9 66
      bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
    ;;

    "4)")
    clear
    echo "not yet implenmented"
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "5)")
    clear
    echo "not yet implenmented"
    read -n 1 -s -r -p "Press any key to continue "
    ;;

    "6)")
      clear
      exit 0
      ;;
esac
done
exit
