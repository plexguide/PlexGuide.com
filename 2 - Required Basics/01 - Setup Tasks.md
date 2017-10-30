# Setup Tasks
Ensures that you install the necessary programs required before hand.  Skipping this part may result in numerous headaches.

## Update System & Install Required Programs

```sh
sudo apt update && sudo apt install nano && sudo apt install fuse
sudo apt install man-db && sudo apt install screen && sudo apt install unzip
sudo apt-get install python
sudo apt-get install software-properties-common
```

## Install NetData
Provides detailed information for your server | useful to determine chokepoints

```sh
sudo apt install curl
bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh)
```

- Press "Y" to accept when prompted
- Visit http://ipv4address:19999

![N](https://image.ibb.co/iuXNLm/Snip20171029_11.png)

## Google Drive API
Required for both RClone & PlexDrive - Credit: @Balazer on Github

- http://console.developers.google.com
- Select project or create a new project
- Under Overview, Google APs, Google Apps APIs; click "Drive API", then enable
- Click "Credentails" in the left-side panel (not "Go to Credentials" which is a Wizard)
- Then "Create credenntials"
- Then "OAuth client ID"
- Prompted to set OAuth consent screen product name.
- Choose application type as "other" and then click "Create"
- If you DO NOT SELECT other, the API is useless and will not work (Reported By PogMoThoin22 @ reddit)
- Will then show you a client ID and client secret
- Keep this somewhere secure; you need it for RClone and PlexDrive
