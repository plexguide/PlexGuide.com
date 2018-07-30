dialog --infobox "Phlex is unsupported at this time. You must already have a good understanding of it and how it works to use it!" 5 75
sleep 4

dialog --infobox "Installing Phlex: Please Wait" 3 35
ansible-playbook /opt/plexguide/pg.yml --tags phlex &>/dev/null &
sleep 4