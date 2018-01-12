### Remove ### Traefik
### Install ### NGINX

## Stopping containers

clear
echo "Stopping All containers"
docker stop $(docker ps -a -q)
################
## Moving Nginx-Proxy Certs
mv /opt/nginx-proxy /opt/appdata/nginx-proxy
## Remake the LetsEncrypt
ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags nginx
################ Version Updates for Patch
echo "Restarting All Docker Containers"
docker restart $(docker ps -a -q)
rm -r /var/plexguide/version-5.27
touch /var/plexguide/version-5.28
whiptail --title "Finished" --msgbox "Your good to go! Always recommend a Reboot!" 9 66
else
    whiptail --title "No Upgrade" --msgbox "Your System Will Not Upgrade! Do not select or do anything" 9 66
    sudo touch /var/plexguide/exit.yes
    exit
fi
