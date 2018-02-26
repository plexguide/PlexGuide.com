mv /opt/plexguide/scripts/docker-no/upgrade2.sh /tmp
cd /tmp
bash /tmp/upgrade2.sh
dialog --title "PG Application Status" --msgbox "\nUpgrade Complete!" 0 0