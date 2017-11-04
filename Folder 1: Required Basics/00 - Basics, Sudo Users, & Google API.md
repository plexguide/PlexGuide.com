![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)


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

## Access SSH via Linux via Windows
- Download:  https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
- In the mainbox, type in your main IP address and then keep port as 22

## Access SSH via MAC/Linux 
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

# Google Drive API (retrieve instructions)

Required for both RClone & PlexDrive - Credit: @Balazer on Github

http://console.developers.google.com
Select project or create a new project
Under Overview, Google APs, Google Apps APIs; click "Drive API", then enable
Click "Credentails" in the left-side panel (not "Go to Credentials" which is a Wizard)
Then "Create credenntials"
Then "OAuth client ID"
Prompted to set OAuth consent screen product name.
Choose application type as "other" and then click "Create"
If you DO NOT SELECT other, the API is useless and will not work (Reported By PogMoThoin22 @ reddit)
Will then show you a client ID and client secret
Keep this somewhere secure; you need it for RClone and PlexDrive
