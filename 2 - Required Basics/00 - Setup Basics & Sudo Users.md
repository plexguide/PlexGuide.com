# Building the Foundational Layout
Go to Google Drive and create root folder called zilch.  I called it ZILCH in order for it to be the LAST FOLDER when accessing Google Drive.  If you do anything other than ZILCH, it may cause some headaches.  You'll will have to remember to rename everything.
Create two subfolders: movies & tv
The entire guide depends on this setup
- googledrive:zilch/movies
- googledrive:zilch/tv

## Ubuntu Setup 
Download and install Ubuntu 16.04 on your local, remote, or virutal machine.

#### Obtaining the IP Address
- Configure or set the IP Address
- Cannot remember? Type "ifconfig"
- (IF) VMware: Use bridge mode and assign an IP via mac address or in the OS, assign a STATIC IP address!

## Install SSH

```sh
sudo apt-get install openssh-server 
sudo service ssh status
```

* Press CTRL + C to Exit

## Access Linux via Windows
- Download:  https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
- In the mainbox, type in your main IP address and then keep port as 22

## Using MAC/Linux
- Utilize a built in program called Terminal
- Goto Applications or search for terminal
  - Example type: ssh username@youripaddress-or-domain

## Troubleshooting Tips for Access
- Ensure that your IP Address is correct, including port number.
- Firewall can be a choke point.
- You should not have to configure anything out of the ordinary.
- Your network setup can be a problem.

## Create a SUDO User
- Only Required if you DO NOT have a SUDO USER Acccount
- Copy below to notepad and change [YOUR-USERNAME] in each location
- Run each line ONE at a time!

```sh
su root
useradd -m -d /home/[YOUR-USERNAME] [YOUR-YOUSERNAME]
usermod -aG sudo [YOUR-USERNAME]
passwd [YOUR-USERNAME]
su [YOUR-USERNAME]
sudo usermod -s /bin/bash [YOUR-USERNAME]
### Switch to username home folder ###
cd ~
```
