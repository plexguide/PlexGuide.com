#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install:  - Everything (Only Run Once on a Clean Machine")
            clear
            bash mass.sh
            ;;
        "Install:  - Programs")
            echo "This option does not work yet"
            ;;
        "Uninstall - Programs")
            echo "This option does not work yet"
            ;;
        "Quit")
            break
            ;;
        *) echo Invalid Selection;;
    esac
done
