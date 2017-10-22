# Linux 101 Commands
Written for SUDO Users; if ROOT... remove "sudo"

```sh
cd /home/$USER
### Takes you to the current user’s home directory
```

~ ----- Takes you to the current user’s home directory
sudo mkdir myprettyfolder ----- Makes a directory called myprettyfolder (example)
sudo rm -r file.txt ----- Removes a file in the current directory called file.txt
sudo rm -r fi* ----- Removes all files that start with fi in the current directory
sudo su ----- Switch to root
exit ----- Return to your regular user (prior to being root user)
clear ----- Clear the current screen
sudo bash myscript.sh ----- Execute the bash script called myscript.sh in current directory
chmod myscript.sh 777 ------ Allow all permissions for all groups (bad practice)
chmod +x myscript.sh ----- Allows the script to be executed when called upon
sudo reboot ----- Reboot your server
sudo docker rm -f portainer ----- an example of moving a specific container by names
