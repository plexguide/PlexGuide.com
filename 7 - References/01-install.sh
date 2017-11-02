#!/bin/bash
clear
echo "Welcome to the Awesome Plex Server ~ PlexGuide.com"
echo
echo "Warning: Only Select Mass Install for a Clean Server!"
echo

PS3='Please Make a Choice: '
options=("1. Mass Install" "2. Install Individual Program" "3. Update Individual Programs" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "1. Mass Install")
            bash 01-install.sh
            ;;
        "2. Install Individual Programs")
            echo "Not Enabled Yet"
            ;;
        "3. Update Individual Programs")
            echo "Not Enabled Yet"
            ;;
        "Quit")
            break
            ;;
        *) echo An Invalid Option;;
    esac
done
