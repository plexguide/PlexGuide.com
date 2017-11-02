#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '
options=("Silly" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Silly")
            bash
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice 3"
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
