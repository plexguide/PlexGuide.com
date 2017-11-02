![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)

# Automated Method
Both are the same thing.  Only pick 1 for install.  Number 1 just saves you some time.  Guide.sh contains the exact code of method 2.

### Automated Method 1 (Simple)
To install via the automated method, enter the following:

```sh
sudo apt-get install curl
bash <(curl -Ss http://107.150.32.90/guide.sh)
```

*To finish, go-to 1.5b and down!*

### or Automated Method 2 (Without Curl; or for the security prone)

```sh
#!/bin/bash
sudo apt-get install unzip
cd /tmp
sudo rm -r plexguide && sudo rm -r Version-*
sudo wget https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/archive/Version-3.5.zip /tmp
sudo unzip /tmp/Version-3.5.zip
sudo mv PlexGuide.com* plexguide && cd plexguide && cd 7*
sudo bash 01*
```

# Manual Method

At anytime you want to LEARN the process, please visit https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/tree/Version-3

The scripts (in the current #7 Folder for References are built of the V3 guide.  If you want to compare the guide and the scripts, it can assit you further in the process)
