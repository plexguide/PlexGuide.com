![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# Linux 101 Commands
Written for SUDO Users; if ROOT... remove "sudo"

```sh
cd /home/$USER
### Takes you to the current user’s home directory
```
 
```sh
~ 
### Takes you to the current user’s home directory
```

```sh
sudo mkdir myprettyfolder
### Makes a directory called myprettyfolder (example)
```

```sh
sudo rm -r file.txt 
### Removes a file in the current directory called file.txt
```

```sh
sudo rm -r fi*
### Removes all files that start with fi in the current directory
```

```sh
sudo su
### Switch to root
```

```sh
exit
### Return to your regular user (prior to being root user)
```

```sh
clear
### Clear the current screen
```

```sh
sudo bash myscript.sh
### Execute the bash script called myscript.sh in current directory
```

```sh
chmod myscript.sh 777
### Allow all permissions for all groups (bad practice)
```

```sh
chmod +x myscript.sh
### Allows the script to be executed when called upon
```

```sh
sudo reboot
### Reboot your server
```

```sh
sudo systemctl status sonarr
### Check on the service called 'Sonarr'
```

```sh
sudo systemctl restart sonarr
### Restarts the service called 'Sonarr'
```

```sh
sudo docker rm -f portainer
### An example of moving a specific container by names
```
