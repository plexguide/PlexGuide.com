# PlexGuide.com - Version 4

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-4/scripts/plexguide.PNG" alt="PlexGuide.com Logo"/>
</p>

<p align="center">
  <img src="https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/blob/Version-4/scripts/plexguide-demo2.PNG" alt="PlexGuide.com Logo"/>
</p>

### Basic Information
- Written By [Admin9705](https://github.com/Admin9705) and [Deiteq](https://github.com/Deiteq)
- Reddit Discussion Link: http://reddit.plexguide.com

### Want to Donate? Everybit Helps!

- Bitcoin : 1H3SD3ef6qaN8ND8S8ZQCaEyD4pMW4kFsA
- Ethereum: 0xe40ED5eA14e20e7dc4595FdE195526d36308cF04
- LiteCoin: LbCDaq26N39TuUarBkrxTXNFjsNWds9Ktj

### Mission Statement & Purpose

Build an operational-automated server that mounts your Google Drive, while utilizing various tools and Plex.  Purpose is to combat the poor performance of the Plex Cloud and issues in regards to the Google API Bans.  
 
----------------------------------------------------------------------

### Preparation, Installation & Configuration 

**A. Quick Notes:**
- Lightly check the PlexGuide Wiki @ http://wiki.plexguide.com
- With a GITHUB login, did you know that you can edit our wiki pages?! Yes, you can make correctons, add snapshots or expand on anytopic. IF you make an update, you'll save us time and help others! Some users have already helped us!

**B. Pre-Preparation:**
- Purchase a [Google Suite Drive Account](https://gsuite.google.com) via Unlimited Storage.
- Have a Dedicated, VPS, or Home Solution Ready!

*(Optional, but Super Highly Recommended) - Either a Free or Paid Domain*
- Paid Domains
    - [GoDaddy.com](https://godaddy.com) - Visit the [PlexGuide GoDaddy Wiki](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Godaddy-Domain-to-IPv4-Instructions)
    - Alternate Services - As long as you know how to configure it
- Free Domains
    - [FreeNom.com](http://freenom.com) - Visit the [PlexGuide FreeNom Wiki](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/FreeNom-Domain-to-IPv4-Instructions)
- This ***will become mandatory*** in Version 5 for better Security
  
**C. Preparation:**
 - [Google Drive Layout](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Google-Drive-Layout)
 - [Do you Require SSH Access?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Access-via-SSH)
 - [Do you Require a SUDO User?](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Creating-a-SUDO-User)
 - [Disk Space Warning Check!](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Disk-Check-Warning!)
 
**D. Install Instructions:**

*Install GIT*
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
  
**E. Configuration**
 - WARNING: If Docker refuses to install, go to Tools and force the reinstall. If that fails; there is a good chance you are running an older version of UBUNTU or using a VPS service that runs and outdated kernal. [Manual Install Incase](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository)
 - Install & Configure (Select Only One)
   - [RClone Unencrypted Version](http://unrclone.plexguide.com)  
   - [RClone Encrypted Version](http://enrclone.plexguide.com)   
 - [Configure PlexDrive](http://plexdrive.plexguide.com)
 - [Configure Plex](http://plex.plexguide.com)
 - [Configure Programs](http://wiki.plexguide.com) on the ***Right Hand Side***
 - [Configure Portainer](http://portainer.plexguide.com)
 - [Port Numbers Reminder](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/wiki/Port-Assignments)

**F. Final Notes**
- See issues or have solutions? Please post your [GitHub Issues for the Best Tracking](https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/issues) or our [REDDIT](http://reddit.plexguide.com). 
- Please visit: https://www.reddit.com/r/PleX/ for additonal support and information!
- Your Feedback Helps Us and You!
