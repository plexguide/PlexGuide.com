# Transmission Basics (VPN, Usenet, Torrents)

#### Intro
This guide is written for the use of newsgroups only.  You can add torrents, but those solutions will require your own modifications (shouldn't be too hard)

#### VPN
A VPN is a virtual private network that is typically encrypted and utilized either to change the location of a service being provided, to hide/and or conceal information, and/or to prevent the interception of information.  From the CIA TRIAD perspective, VPNs provide confidentiality to a limited extent (depends on your provider).  Avoid free ones; any VPN provider has the ability to read all of your information!

Learn more about VPN’s: https://www.youtube.com/watch?v=K9bhbEm7JAk

# Utilizing USENET

### Question? VPN required for USENET?
USENET does not require a VPN.  If you select port 443 or 563 as your transmission port, the information will be encrypted.  A VPN adds an extra layer of security, but can potentially slow down your connection speeds.

USENET was utilized long before torrents.  It was very confusing, the software to download-repair-and reproduce a file was clunky, the speeds were capped, and required tons manual processing. As a result people chose to rely on the use of torrents due to simplicty and being completely free.

With USENET, you can achieve over 1 GIG speeds with 0 sharing (unlike torrents) in downloading material.

The programs utilized are the following:

Sonarr - TV Shows

Radarr - Movies (New and appears to have same common design of Sonarr, so learning curve is easier.  Small bugs, can crash)
CouchPotato - Movies (existed longer than Radarr, but the complicated v3 interface is something left to be desired)
SABNZBD or NZBGET:  I recommend SABNZBD.  With NZBGET, many of files got lost or the program would just stop or crash.  I tried it over the years, but it’s ok. See the debate of the two on reddit.   

NZB Indexers:  

This is where I first got lost.  With a torrent, you just download the file and call it a day.  

With USENET, the process is a little-bit more complicated.  I call the NZB Indexers the Treasure Map People (my friends get it).  So when Sonarr, Radarr, or CouchPotato is looking for a show/movie, it talks to the treasure map people and says "hey, do you have the treasure map for XY&Z?""  Whichever INDEXER meets the critera of what you are looking for, the managing program then downloads the NZB file from that INDEXER (treasure map).  You're like… man that’s easy.  There is much more regarding USENET.

USENET Servers:  So your managing program now has an NZB file of XY&Z.nzb and you're wondering where the file is.  Well, you have a file, but not the data (sort of like having a torrent).  What you obtained was just the treasure map.  So in this case, the managing program talks to the download program via an API key and passes the information.  So in this case, tv show XY&Z is now being tracked by SABNZBD.  SABNZBD is required to have USENET Servers configured to download the requested files.   

Tip: If utilizing a REMOTE SERVER and you get a timeout, it’s because the NewsGroup blocked the IP your coming from.  It’s due to abuse.  Hetzner is a good remote server, but half of the usenet companies block them due to abuse.

Next, SABNZBD will download the pieces of the file using the TREASURE MAP (NZB Indexer / NZB File) from the beginning and start downloading all of the files (like how utorrent works).  Once downloaded, SABNZBD will store the file to a particular location and then notify the management program (Sonarr,Radarr,CouchPotato) that the file is now downloaded.

The management program (Sonarr/Radarr/CouchPotato) takes the completed file, renames it, and moves it to your selected location of choice.  When installing RClone, the management programs will automatically place the files in rclone’s upload path.  Basically, your downloaded files are pushed to the cloud automatically.

# Utilizing Torrents

Basic Info:  Torrents are the easiest route to go, but are complicated through the use of automations.  Torrents are not always around, your information is exposed, and it carries a-lot of risk.  Most people select torrents because they are well known, easy to use, and technically free.  What a-lot of people do not realize is that your ip-address is fully displayed for the world to see.  So if you're using torrents, figure out to adapt the programs (not my area), and use a VPN when possible.  If using a VPN, I would use: PIA (Private Internet Access).  PIA is cheap, do not hassle you about multiple collections, take paypal, and I’ve had no problem over the years and being overseas.  Just remember that with any VPN, they can snoop on you.  The free VPN’s, be most wary of.

Learn More About Torrents: https://www.youtube.com/watch?v=OFswNCU5CKA

# Recommend Plex Servers (Go Dedicated & Avoid VPS)

I would recommend the following based on personal experience

#### Dedicated Servers
PROS: More horsepower, more diskspace, better control, better bandwidth
CONS: Costs more

1. http://wholesaleinternet.com
  * Server Dual Xeon 2670 (16core/32thread)
  * RAM 32GB - 96GB
  * Solid State Drives
  * Costs: $69-$99
  * 100TB up and down dedicated bandwidth
  * PROS:
    - Bandwidth:  Reach 150 MB (1.5gpbs speeds)
    - It's dual core server for under $100
    - Easy to use
    - Takes Paypal
    - NOT BANNED by indexers or anybody else
    - (Great for US Customers) You pay in dollars
  * CONS:
    - Slightly less options
    - DO NOT PICK CUSTOM servers!!! If you do, you'll have to put in tickets to hard reboot
2. Online.net
  * Xeons Processors
  * RAM 32+
  * Solid State & HD Drives
  * Costs: Nutty costs for dual core, single core Xeons around $29-99; 8-15 for ATOMS (do not recommend)
  * Bandwidth: Unlimited, reached 90 MB speeds (.9gbps)
  * PROS:
    - Sales: Super cheap on sales
    - Interface: Very good with lots of options
    - Bandwidth: Top notch
    - NOT BANNED by indexers or anybody else
  * CONS:
    - If you do not cancel by the 20th of the month, they bill you next month
    - Requires identity verification
    - Only takes Credit Cards
    - (Bad for US Customers) EURO GOES up, so does your costs
3. Hetzner.de
  * Xeon, Desktop, and AMD Processors
  * RAM - All types
  * Solid State & HD Drives
  * Costs: $20+
  * 30TB outgoing bandwidth, unlimited incoming
  * PROS
    - Bandwidth unlimited incoming is great; to balance against the 30TB outgoing
    - Takes Paypal
    - Can use auctioned servers or custom
    - Customer service is very fast
    - Can setup servers and not pay for 14 days and cancel, great for newbs
  * CONS
    - Interface can be semi-confusing (worst if all brand new to everything)
    - Half download companies ban HETZNER due to abuse such as Giganews and Supernews; several others
    - Bandwidth good, but never reach the highest speeds; still good
    - Customer server packages get pricy

#### VPS Servers
PROS: Cheaper
CONS: Less horsepower, less diskspace, semi-ok control, semi-ok bandwidth

I have not used one because of plex server processing requirements, but http://online.net and http://hetzner.de offer VPS

