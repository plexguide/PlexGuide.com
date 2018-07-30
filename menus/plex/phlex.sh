dialog --infobox "Phlex is unsupported at this time. You must already have a good understanding of it and how it works to use it!" 5 75
sleep 4

dialog --title "Confirm Phlex Installation" \
--yesno "Are you sure you want to install Phlex?" 7 60

response=$?

case $response in
   0) 
      dialog --infobox "Installing Phlex: Please Wait" 3 35
      ansible-playbook /opt/plexguide/pg.yml --tags phlex
      sleep 4
      ;;
   1) 
      clear
      exit 0 ;;
esac