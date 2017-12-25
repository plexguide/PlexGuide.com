# PlexGuide.com - Version 5

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/plexguide-logo5.PNG?raw=true" alt="PlexGuide.com Logo"/>
</p>

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/capture5.PNG?raw=true" alt="PlexGuide.com Preview"/>
</p>

----------------------------------------------------------------------
### Basic Information
- Written By [Admin9705](https://github.com/Admin9705) and [Deiteq](https://github.com/Deiteq)
- **UBUNTU 16.04 & 17.04 ** Only !!! PlexGuide is not MADE FOR SERVER EDITONS 16.10 - 17.10
- This is built for **USENET**; not for torrents.  The Wikis will help you understand USENET if required.
- If anyone wants to take on the torrent portion of the project, please let us know!

## Social
- [PlexGuide Discord Channel](https://discord.gg/mg7bVnw) ![alt text](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-5/scripts/discord-button.PNG?raw=true "Logo")
- Reddit Discussion Link: http://reddit.plexguide.com
- Slack is now discontinued! Use the offical Discord instead!

### Awesome Beta Testers & Contributers!

- Augie, [AugusDogus](https://github.com/AugusDogus), [Bate](https://github.com/batedk), cocainbiceps, [daveftw84](https://github.com/daveftw84), Jackalblood, imes, [The Creator](https://github.com/TheCreatorzOne), trustyfox, [Rothuith](https://github.com/Rothuith), simon021, SpencerUK

### Want to Donate? Everybit Helps!

- Bitcoin : 1H3SD3ef6qaN8ND8S8ZQCaEyD4pMW4kFsA
- LiteCoin: LbCDaq26N39TuUarBkrxTXNFjsNWds9Ktj

----------------------------------------------------------------------

### Preparation, Installation & Configuration

**A. Quick Notes:**
- Lightly check the PlexGuide Wiki @ http://wiki.plexguide.com
- With a GITHUB login, did you know that you can edit our wiki pages?! Yes, you can make corrections, add snapshots or expand on any topic. IF you make an update, you'll save us time and help others! Some users have already helped us!

**B. Pre-Preparation:**
- Purchase a [Google Suite Drive Account](https://gsuite.google.com) via Unlimited Storage.
- Have a Dedicated, VPS, or Home Solution Ready!

**C. Preparation:**
 - [Google Drive Layout](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Google-Drive-Layout)
 - [Do you Require SSH Access?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Access-via-SSH)
 - [Do you Require a SUDO User?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Creating-a-SUDO-User)
 - [Disk Space Warning Check!](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Disk-Check-Warning!)

**D. Install Instructions:**

*Recommened First to Prevent Issues*
```sh
sudo apt-get update -y && apt-get upgrade -y
```

*Install Supporting Programs*
```sh
sudo apt-get install git
```

*Install PlexGuide*
```sh
sudo git clone https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server.git /opt/plexguide
sudo bash /opt/plexg*/sc*/ins*
```

*Execute PlexGuide AnyTime Futurewise*
```sh
plexguide
```
**E. RClone / PlexDrive / UnionFS**
 - Install & Configure (Select Only One) - YouTube Video for RClone & PlexGuide: https://youtu.be/R15xXDwmxtk
   - [RClone Unencrypted Version](http://unrclone.plexguide.com)  
   - [RClone Encrypted Version](http://enrclone.plexguide.com)   
 - [Configure PlexDrive](http://plexdrive.plexguide.com) Note: Let It Finish and then Reboot Serv
 
**F. Decision Time - Normal Install or Reverse Proxy** 
- No Reverse Proxy (Access Via http://ipv4:port) (Example: http://192.168.1.20:7878)
  - Requires No Domain
  - Provides Less Protection and Exposed Ports
  - No LetsEncrypt Support
  - Select #2 From the Menu

- NGINX Reverse Proxy (Access Via Subdomain http://subdomain.domain.com) (Example: http://radarr.domain.com)
  - In Testing Mode; near production
  - Requires a Domain 
    - How To With a Paid GoDaddy Domain
    - How To With a Free NomNom Domain
  - Provides More Protection and Closes Exposed Ports / Can Access ports only via Localhost)
  - Future Support for LetsEncrypt
  - Select #7 From the Menu

**G. Installing & Setting Up Support Programs**
 
 - [Configure Plex](http://plex.plexguide.com)
 - [Configure Programs](http://wiki.plexguide.com) on the ***Right Hand Side***
 - [Configure Portainer](http://portainer.plexguide.com)
 - [Port Numbers Reminder](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Port-Assignments)

**H. Final Notes**
- See issues or have solutions? Please post your [GitHub Issues for the Best Tracking](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/issues) or our [REDDIT](http://reddit.plexguide.com).
- Please visit: https://www.reddit.com/r/PleX/ for additonal support and information!
- Your Feedback Helps Us and You!

**I. Quick Troubleshoot**
- Docker Install Failure: If Docker refuses to install, visit Tools and force the reinstall. If that fails; most likely you are running an older version of UB or have a VPS service that runs and outdated kernel. [[Manual Docker Install Incase]](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository)
