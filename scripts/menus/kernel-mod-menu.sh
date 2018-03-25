 #!/bin/bash

clear

################# init message

if (whiptail --title "Network Speed" --yesno "Is Your Server On at least a 500mbit line?" 8 56) then
  echo good
else
    whiptail --title "Network Speed - No" --msgbox "We reccomend only enabling BBR on slower networks." 9 66
fi

while [ 1 ]
do
CHOICE=$(
whiptail --title "Kernel Profiles" --menu "See Wiki For More Info + iperf Network Benchmarks" 14 50 6 \
    "1)" "Enable BBR TCP Congestion Control"  \
    "2)" "High-Latency Network + BBR"  \
    "3)" "Low-Latency Network + BBR"  \
    "4)" "Install Latest Generic Kernel"  \
    "5)" "Install Xanmod Kernel"  \
    "6)" "Exit"  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
      # check if bbr is avail
      skip_tags='tj,klaver'
      if cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr -q
        then
        ansible-playbook /opt/plexguide/ansible/roles/plexguide.yml --tags network_tuning --skip-tags $skip_tags
        cat /etc/sysctl.conf
        read -n 1 -s -r -p "Press any key to continue "
        bash /opt/plexguide/scripts/menus/processor/reboot.sh
      else
        whiptail --title "Unsupported Kernel" --msgbox "Your Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 9 66
        bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
      fi
    ;;

    "2)")
      clear
      # check if bbr is avail
      skip_tags='tj'
      if cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr -q
      then
        ansible-playbook /opt/plexguide/ansible/roles/plexguide.yml --tags network_tuning --skip-tags $skip_tags
        cat /etc/sysctl.conf
        read -n 1 -s -r -p "Press any key to continue "
        bash /opt/plexguide/scripts/menus/processor/reboot.sh
      else
        whiptail --title "Unsupported Kernel" --msgbox "Your Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 9 66
        bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
      fi
    ;;

    "3)")
      clear
      # check if bbr is avail
      skip_tags='klaver'
      if cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr -q
      then
        ansible-playbook /opt/plexguide/ansible/roles/plexguide.yml --tags network_tuning --skip-tags $skip_tags
        cat /etc/sysctl.conf
        echo ""
        read -n 1 -s -r -p "Press any key to continue "
        bash /opt/plexguide/scripts/menus/processor/reboot.sh
      else
        whiptail --title "Unsupported Kernel" --msgbox "Your Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 9 66
        bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
      fi
    ;;

    "4)")
      clear
        if (whiptail --title "Kernel Upgrade" --yesno "Are You Sure You Want To Upgrade Your Kernel? (warning: this may break drivers)" 8 56) then
          sudo apt update -y && sudo apt sudo apt install --install-recommends linux-generic-hwe-16.04
          bash /opt/plexguide/scripts/menus/processor/reboot.sh
        else
            whiptail --title "Kernel Upgrade" --msgbox "Canceling Kernel Upgrade." 9 66
        fi
    ;;

    "5)")
      clear
        if (whiptail --title "Kernel Upgrade" --yesno "Are You Sure You Want To Install An Expirimental Kernel? (warning: this may break drivers)" 8 56) then
          echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list && wget -qO - http://deb.xanmod.org/gpg.key | sudo apt-key add -
          sudo apt update && sudo apt install linux-xanmod-4.15
          bash /opt/plexguide/scripts/menus/processor/reboot.sh
        else
            whiptail --title "Kernel Upgrade" --msgbox "Canceling Kernel Upgrade." 9 66
        fi
    ;;

    "6)")
      clear
      exit 0
      ;;
esac
done
exit
