### Remove ### Traefik
### Install ### NGINX

sudo docker stop traefik
sudo docker rm traefik

if (whiptail --title "Upgrade Question" --yesno "You will be required to rebuild all your containers for the upgrade? Are you ready? (Will not lose data)" 9 66) then
clear
echo "Stopping & Removing All Containers"
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
rm -r /var/plexguide/version.5
rm /var/plexguide/donation*
rm /var/plexguide/dep*
touch /var/plexguide/version-5.27
whiptail --title "New Containers" --msgbox "Remember to Rebuild Your Containers" 9 66
else
    whiptail --title "No Upgrade" --msgbox "Your System Will Not Upgrade! Do not select or do anything" 9 66
    sudo touch /var/plexguide/exit.yes
    exit
fi
