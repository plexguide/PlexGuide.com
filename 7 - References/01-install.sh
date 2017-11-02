#!/bin/bash

clear
echo "Welcome to the Awesome Plex Server ~ PlexGuide.com"
echo
echo "Warning: Only Select Mass Install for a Clean Server!"
echo

PS3='Please Make a Choice: '
options=("Mass Install" "Install Individual Programs" "Update Individual Programs" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Mass Install")
            bash 01-install.sh
            ;;
        "Install Individual Programs")
            echo "Not Enabled Yet"
            ;;
        "Update Individual Programs")
            echo "Not Enabled Yet"
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
