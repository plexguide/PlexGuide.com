#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq & Bryde ツ
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
export NCURSES_NO_UTF8_ACS=1
echo 'INFO - @Main Kernel Profiles - Kernel-mod-menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

HEIGHT=13
WIDTH=44
CHOICE_HEIGHT=11
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Kernal Mods"

OPTIONS=(A "Enable BBR TCP Congestion Control"
         B "Klaver + BBR"
         C "TJ007 + BBR"
         D "Seedboxer + BBR"
         E "Install Latest Generic Kernel"
         F "Install Xanmod Kernel"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
if (dialog --title "Here Be Dragons" --yesno "Warning: Adjusting Kernel Parameters May Break Network Adapters or Even Brick Your Machine. Continue?" 8 56) then
  echo ok
else
  exit 0
fi

if (dialog --title "Network Speed" --yesno "Is Your Server On at least a 500mbit line?" 8 56) then
  echo good
else
    dialog --title "Network Speed - No" --msgbox "We reccomend only enabling BBR on slower networks." 9 66
fi
  A)
    echo 'INFO - Selected: Enable BBR TCP Congestion Control' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    # check if bbr is available
    skip_tags='tj,klaver,seedboxer'
    if [[ $(grep 'CONFIG_TCP_CONG_BBR=' /boot/config-$(uname -r)) || $(cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr) ]]; then
      echo 'INFO - Installing: BBR TCP Congestion Control' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      ansible-playbook /opt/plexguide/pg.yml --tags network_tuning --skip-tags $skip_tags
      cat /etc/sysctl.conf
      read -n 1 -s -r -p "Press any key to continue - will reboot the machine"
      bash /opt/plexguide/roles/processor/scripts/reboot.sh
    else
      echo 'INFO - Canceling: Unsupported Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      dialog --title "Unsupported Kernel" --msgbox "\nYour Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 0 0
      bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
    fi ;;
  B)
    echo 'INFO - Selected: Klaver + BBR' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear
    # check if bbr is available
    skip_tags='tj,seedboxer'
    if [[ $(grep 'CONFIG_TCP_CONG_BBR' /boot/config-$(uname -r)) || $(cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr) ]]; then
      echo 'INFO - Installing: Klaver + BBR' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      ansible-playbook /opt/plexguide/pg.yml --tags network_tuning --skip-tags $skip_tags
      cat /etc/sysctl.conf
      read -n 1 -s -r -p "Press any key to continue - will reboot the machine"
      bash /opt/plexguide/roles/processor/scripts/reboot.sh
    else
      echo 'INFO - Canceling: Unsupported Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      dialog --title "Unsupported Kernel" --msgbox "\nYour Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 0 0
      bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
    fi ;;
  C)
    echo 'INFO - Selected: TJ007 + BBR' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear
    # check if bbr is avail
    skip_tags='klaver,seedboxer'
    if [[ $(grep 'CONFIG_TCP_CONG_BBR' /boot/config-$(uname -r)) || $(cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr) ]]; then
      echo 'INFO - Installing: TJ007 + BBR' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      ansible-playbook /opt/plexguide/pg.yml --tags network_tuning --skip-tags $skip_tags
      cat /etc/sysctl.conf
      echo ""
      read -n 1 -s -r -p "Press any key to continue - will reboot the machine"
      bash /opt/plexguide/roles/processor/scripts/reboot.sh
    else
      echo 'INFO - Canceling: Unsupported Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      dialog --title "Unsupported Kernel" --msgbox "\nYour Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 0 0
      bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
    fi ;;
  D)
    echo 'INFO - Selected: Seedboxer + BBR' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear
    # check if bbr is available
    skip_tags='klaver,tj'
    if [[ $(grep 'CONFIG_TCP_CONG_BBR' /boot/config-$(uname -r)) || $(cat /proc/sys/net/ipv4/tcp_available_congestion_control | grep bbr) ]]; then
      echo 'INFO - Installing: Seedboxer + BBR' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      ansible-playbook /opt/plexguide/pg.yml --tags network_tuning --skip-tags $skip_tags
      cat /etc/sysctl.conf
      echo ""
      read -n 1 -s -r -p "Press any key to continue - will reboot the machine"
      bash /opt/plexguide/roles/processor/scripts/reboot.sh
    else
      echo 'INFO - Canceling: Unsupported Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      dialog --title "Unsupported Kernel" --msgbox "\nYour Kernel, $(uname -r) does not support BBR. Please Update Your Kernel." 0 0
      bash /opt/plexguide/scripts/menus/kernel-mod-menu.sh
    fi ;;
  E)
    echo 'INFO - Selected: Install Latest Generic Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear
    if (dialog --title "Kernel Upgrade" --yesno "Are You Sure You Want To Upgrade Your Kernel? (warning: this may break drivers)" 0 0) then
      echo 'INFO - Installing: Latest Generic Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      sudo apt update -y && sudo apt sudo apt install --install-recommends linux-generic-hwe-16.04
      bash /opt/plexguide/roles/processor/scripts/reboot.sh
    else
      echo 'INFO - Canceling: Xanmod Kernel Upgrade' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      dialog --title "Kernel Upgrade" --msgbox "Canceling Kernel Upgrade." 0 0
    fi ;;
  F)
    echo 'INFO - Selected: Install Xanmod Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    clear
    if (dialog --title "Kernel Upgrade" --yesno "Are You Sure You Want To Upgrade Your Kernel? (warning: this may break drivers)" 0 0); then
      echo 'INFO - Installing: Xanmod Kernel' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list && wget -qO - http://deb.xanmod.org/gpg.key | sudo apt-key add -
      sudo apt update && sudo apt install linux-xanmod-4.15
      bash /opt/plexguide/roles/processor/scripts/reboot.sh
    else
      echo 'INFO - Canceling: Xanmod Kernel Upgrade' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      dialog --title "Kernel Upgrade" --msgbox "Canceling Kernel Upgrade." 0 0
    fi ;;
  Z)
    echo 'INFO - Selected: Exit Kernal mode menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    exit 0 ;;
esac
## repeat menu when exiting
echo 'INFO - Looping: Kernal Mod Interface Menu' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
bash /opt/plexguide/scripts/menus/kernel-mod-menu-new.sh
exit
