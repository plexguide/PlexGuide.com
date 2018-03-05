#!/bin/bash

## This is to analyse what's taking up space on you drives

#apt install ncdu -y


clear

while [ 1 ]
do
CHOICE=$(
whiptail --title "NCDU Directory Size Menu" --menu "*** Press q to quit! ***" 21 60 12 \
    "1)" "Entire drive - excluding /mnt"   \
    "2)" "Entire drive - excluding /mnt & /opt"   \
    "3)" "/opt - WARNING Can take a long time!"   \
    "4)" "/mnt - WARNING Can take a long time!"  \
    "5)" "Move"  \
    "6)" "UnionFS - WARNING Can take a long time!"  \
    "7)" "NZBGET"  \
    "8)" "SAB"  \
    "9)" "Deluge"  \
    "10)" "RuTorrent"  \
    "11)" "TorrentVPN"  \
    "12)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
      clear
      ncdu / --exclude=/mnt
      ;;

    "2)")
      clear
      ncdu / --exclude=/mnt --exclude=/opt
      ;;

    "3)")
        clear
        ncdu /opt
        ;;

    "4)")
        clear
        ncdu /mnt
        ;;

    "5)")
      clear
      ncdu /mnt/move
      ;;

    "6)")
      clear
      ncdu /mnt/unionfs
      ;;

    "7)")
      clear
      ncdu /mnt/nzbget
      ;;

    "8)")
        clear
        ncdu /mnt/sab
        ;;

    "9)")
        clear
        ncdu /mnt/deluge
        ;;

    "10)")
        clear
        ncdu /mnt/rutorrent
        ;;

     "11)")
         clear
         ncdu /mnt/torrentvpn
         ;;

      "12)")
      clear
      exit 0
      ;;
esac
done
exit
